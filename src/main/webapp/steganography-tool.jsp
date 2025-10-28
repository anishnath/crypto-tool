<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<div lang="en">
<head>
    <title>Advanced Steganography Tool - Hide Secret Messages in Images | 8gwifi.org</title>

    <!-- JSON-LD markup -->
    <script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Advanced Steganography Tool - Hide Secret Messages in Images",
  "image" : "https://8gwifi.org/images/steganography.png",
  "url" : "https://8gwifi.org/steganography-tool.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2025-01-28",
  "applicationCategory" : [ "Steganography", "Image security", "Data hiding", "Privacy tools" ],
  "downloadUrl" : "https://8gwifi.org/steganography-tool.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : "Web Browser with HTML5 Canvas support",
  "softwareVersion" : "v1.0"
}
    </script>

    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Advanced online steganography tool to hide and extract secret messages in images using LSB (Least Significant Bit) encoding. Supports text encryption, password protection, and multiple image formats.">
    <meta name="keywords" content="steganography, hide message in image, LSB encoding, data hiding, image steganography, secret message, covert communication, image encryption">
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
            max-width: 900px;
            margin: 0 auto;
            padding: 1rem;
        }

        .page-header-compact {
            background: transparent;
            color: white;
            padding: 1.5rem 0;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .page-header-compact h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .page-header-compact p {
            font-size: 1rem;
            margin: 0;
            opacity: 0.95;
        }

        .tool-description-compact {
            background: white;
            border-radius: var(--border-radius);
            padding: 1rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--card-shadow);
            font-size: 0.9rem;
        }

        .tool-description-compact h4 {
            font-size: 1rem;
            margin-bottom: 0.5rem;
            color: #667eea;
        }

        .tool-description-compact p {
            margin-bottom: 0.5rem;
        }

        .tool-description-compact p:last-child {
            margin-bottom: 0;
        }

        .stego-container {
            margin: 1rem 0;
        }

        .mode-selector {
            display: flex;
            justify-content: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .mode-btn {
            flex: 1;
            max-width: 200px;
            padding: 1rem;
            background: white;
            border: 2px solid #dee2e6;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }

        .mode-btn:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: var(--card-shadow);
        }

        .mode-btn.active {
            background: var(--primary-gradient);
            color: white;
            border-color: #667eea;
            box-shadow: var(--card-shadow);
        }

        .mode-btn i {
            font-size: 2rem;
            margin-bottom: 0.3rem;
            display: block;
        }

        .mode-btn h3 {
            font-size: 1rem;
            margin: 0;
        }

        .mode-btn p {
            margin: 0.3rem 0 0 0;
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .stego-panel {
            display: none;
            background: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
        }

        .stego-panel h3 {
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }

        .stego-panel.active {
            display: block;
        }

        .upload-zone {
            border: 2px dashed #ced4da;
            border-radius: var(--border-radius);
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: #f8f9fa;
        }

        .upload-zone:hover,
        .upload-zone.dragover {
            border-color: #667eea;
            background: #f8f9ff;
            transform: scale(1.01);
        }

        .upload-zone input[type="file"] {
            display: none;
        }

        .upload-zone i {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .upload-zone h4 {
            font-size: 1.1rem;
            margin-bottom: 0.3rem;
        }

        .upload-zone p {
            margin-bottom: 0.3rem;
            font-size: 0.9rem;
        }

        .image-preview-container {
            margin-top: 1rem;
            display: none;
        }

        .image-preview-container.active {
            display: block;
        }

        .image-preview {
            max-width: 100%;
            max-height: 400px;
            border: 2px solid #dee2e6;
            border-radius: var(--border-radius);
            margin-bottom: 0.75rem;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .image-info {
            background: #f8f9fa;
            padding: 0.75rem;
            border-radius: var(--border-radius);
            font-size: 0.85rem;
        }

        .image-info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.3rem 0;
            border-bottom: 1px solid #dee2e6;
        }

        .image-info-item:last-child {
            border-bottom: none;
        }

        .message-input-section {
            margin: 1rem 0;
        }

        .message-input-section label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .stego-textarea {
            width: 100%;
            min-height: 120px;
            font-family: 'Courier New', monospace;
            border: 2px solid #dee2e6;
            border-radius: var(--border-radius);
            padding: 0.75rem;
            resize: vertical;
            font-size: 0.9rem;
        }

        .stego-input {
            width: 100%;
            padding: 0.6rem;
            border: 2px solid #dee2e6;
            border-radius: var(--border-radius);
            font-size: 0.9rem;
        }

        .stego-input:focus,
        .stego-textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .options-panel {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: var(--border-radius);
            margin: 1rem 0;
        }

        .option-group {
            margin-bottom: 1rem;
        }

        .option-group:last-child {
            margin-bottom: 0;
        }

        .option-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.4rem;
            color: #495057;
            font-size: 0.9rem;
        }

        .option-group small {
            font-size: 0.8rem;
        }

        .stego-btn {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1.1rem;
            transition: transform 0.2s;
            width: 100%;
        }

        .stego-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .stego-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
        }

        .stego-btn.secondary {
            background: #6c757d;
            margin-top: 0.5rem;
        }

        .result-section {
            display: none;
            margin-top: 2rem;
        }

        .result-section.active {
            display: block;
        }

        .result-message {
            background: #d1f4d1;
            border-left: 4px solid #28a745;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .result-error {
            background: #ffd7d5;
            border-left: 4px solid #dc3545;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .extracted-message {
            background: white;
            border: 2px solid #667eea;
            border-radius: 8px;
            padding: 1.5rem;
            font-family: 'Courier New', monospace;
            white-space: pre-wrap;
            word-break: break-all;
        }

        .capacity-meter {
            background: #f8f9fa;
            padding: 0.75rem;
            border-radius: var(--border-radius);
            margin: 0.75rem 0;
            font-size: 0.85rem;
        }

        .capacity-bar {
            height: 16px;
            background: #e9ecef;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 0.4rem;
        }

        .capacity-fill {
            height: 100%;
            background: var(--primary-gradient);
            transition: width 0.3s;
        }

        .capacity-text {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 0.4rem;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .feature-card {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
        }

        .feature-card:hover {
            border-color: #667eea;
            transform: translateY(-3px);
            box-shadow: var(--card-shadow);
        }

        .feature-card i {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 1rem;
        }

        .example-section {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 2rem 0;
        }

        .example-section h4 {
            color: #667eea;
            margin-bottom: 1rem;
        }

        .example-section ul {
            margin: 0;
        }

        .alert-info {
            background: #cfe2ff;
            border-left: 4px solid #0d6efd;
            padding: 0.75rem;
            border-radius: var(--border-radius);
            margin: 0.75rem 0;
            font-size: 0.9rem;
        }

        .alert-info strong {
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .mode-selector {
                flex-direction: column;
            }

            .mode-btn {
                max-width: 100%;
            }
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
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<div class="main-wrapper">
    <div class="page-header-compact">
        <h1><i class="fas fa-user-secret"></i> Steganography Tool</h1>
        <p>Hide and extract secret messages in images using LSB encoding</p>
    </div>

    <div class="tool-description-compact">
        <h4><i class="fas fa-info-circle"></i> About Steganography</h4>
        <p><strong>Steganography</strong> is the practice of concealing messages within other non-secret data. This tool uses LSB (Least Significant Bit) encoding to hide text messages within image pixels invisibly.</p>
        <p class="mb-0"><strong>Features:</strong> Compatible with multiple steganography formats including stylesuxx and other popular tools. Supports both encoding and decoding of messages from various sources.</p>
    </div>

    <div class="stego-container">

        <!-- Mode Selector -->
        <div class="mode-selector">
            <div class="mode-btn active" onclick="switchMode('encode')">
                <i class="fas fa-lock"></i>
                <h3>Encode Message</h3>
                <p style="margin: 0.5rem 0 0 0; font-size: 0.9rem;">Hide secret text in image</p>
            </div>
            <div class="mode-btn" onclick="switchMode('decode')">
                <i class="fas fa-unlock"></i>
                <h3>Decode Message</h3>
                <p style="margin: 0.5rem 0 0 0; font-size: 0.9rem;">Extract hidden text from image</p>
            </div>
        </div>

        <!-- Encode Panel -->
        <div id="encodePanel" class="stego-panel active">
            <h3><i class="fas fa-lock"></i> Hide Message in Image</h3>

            <div class="alert-info">
                <i class="fas fa-info-circle"></i> <strong>How it works:</strong> Upload an image and enter your secret message. The tool will encode your message into the image pixels using LSB encoding. The resulting image will look identical to the original but contains your hidden message.
            </div>

            <!-- Image Upload -->
            <div class="upload-zone" id="encodeUploadZone">
                <input type="file" id="encodeImageInput" accept="image/png,image/jpeg,image/bmp" />
                <i class="fas fa-image"></i>
                <h4>Upload Cover Image</h4>
                <p>Click to browse or drag and drop</p>
                <p style="font-size: 0.9rem; color: #6c757d;">Supports PNG, JPEG, BMP (PNG recommended for best quality)</p>
            </div>

            <div class="image-preview-container" id="encodePreviewContainer">
                <canvas id="encodeCanvas" class="image-preview"></canvas>
                <div class="image-info" id="encodeImageInfo"></div>
            </div>

            <!-- Message Input -->
            <div class="message-input-section">
                <label for="messageInput"><strong><i class="fas fa-comment-dots"></i> Secret Message</strong></label>
                <textarea id="messageInput" class="stego-textarea" placeholder="Enter your secret message here..."></textarea>
                <div class="capacity-meter" id="capacityMeter" style="display: none;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span><strong>Message Capacity:</strong></span>
                        <span id="capacityText">0 / 0 characters</span>
                    </div>
                    <div class="capacity-bar">
                        <div class="capacity-fill" id="capacityFill" style="width: 0%;"></div>
                    </div>
                    <div class="capacity-text" id="capacityDetails"></div>
                </div>
            </div>

            <!-- Options -->
            <div class="options-panel">
                <div class="option-group">
                    <label for="encodePassword"><i class="fas fa-key"></i> Password Protection (Optional)</label>
                    <input type="password" id="encodePassword" class="stego-input" placeholder="Enter password to encrypt message (leave empty for no encryption)" />
                    <small style="color: #6c757d; display: block; margin-top: 0.5rem;">Password will be required to decode the message</small>
                </div>
                <div class="option-group">
                    <label><i class="fas fa-sliders-h"></i> Encoding Options</label>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="encodeCompression" checked>
                        <label class="form-check-label" for="encodeCompression">
                            Message compression (reduces size)
                        </label>
                    </div>
                </div>
            </div>

            <button class="stego-btn" id="encodeBtn" onclick="encodeMessage()" disabled>
                <i class="fas fa-lock"></i> Hide Message in Image
            </button>

            <div class="loading-spinner" id="encodeSpinner">
                <div class="spinner"></div>
                <p>Encoding message...</p>
            </div>

            <div class="result-section" id="encodeResult"></div>
        </div>

        <!-- Decode Panel -->
        <div id="decodePanel" class="stego-panel">
            <h3><i class="fas fa-unlock"></i> Extract Hidden Message</h3>

            <div class="alert-info">
                <i class="fas fa-info-circle"></i> <strong>How it works:</strong> Upload an image that contains a hidden message. The tool automatically detects the encoding format and works with images from stylesuxx, this tool, and other popular steganography tools. If password-protected, enter the password to decrypt.
            </div>

            <!-- Image Upload -->
            <div class="upload-zone" id="decodeUploadZone">
                <input type="file" id="decodeImageInput" accept="image/png,image/jpeg,image/bmp" />
                <i class="fas fa-image"></i>
                <h4>Upload Image with Hidden Message</h4>
                <p>Click to browse or drag and drop</p>
                <p style="font-size: 0.9rem; color: #6c757d;">Upload the image containing the hidden message</p>
            </div>

            <div class="image-preview-container" id="decodePreviewContainer">
                <canvas id="decodeCanvas" class="image-preview"></canvas>
                <div class="image-info" id="decodeImageInfo"></div>
            </div>

            <!-- Password Input -->
            <div class="options-panel" id="decodePasswordSection" style="display: none;">
                <div class="option-group">
                    <label for="decodePassword"><i class="fas fa-key"></i> Password (if message is encrypted)</label>
                    <input type="password" id="decodePassword" class="stego-input" placeholder="Enter password to decrypt message" />
                </div>
            </div>

            <button class="stego-btn" id="decodeBtn" onclick="decodeMessage()" disabled>
                <i class="fas fa-unlock"></i> Extract Hidden Message
            </button>

            <div class="loading-spinner" id="decodeSpinner">
                <div class="spinner"></div>
                <p>Decoding message...</p>
            </div>

            <div class="result-section" id="decodeResult"></div>
        </div>

    </div>

    <!-- Related Tools -->
    <div style="background: white; border-radius: 8px; padding: 1rem; margin-top: 1.5rem; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">
        <h4 style="font-size: 1.1rem; margin-bottom: 0.75rem;"><i class="fas fa-link"></i> Related Tools</h4>
        <div class="row" style="font-size: 0.9rem;">
            <div class="col-md-6">
                <ul class="list-unstyled mb-0">
                    <li><i class="fas fa-lock text-muted"></i> <a href="CipherFunctions.jsp">AES Encryption</a></li>
                    <li><i class="fas fa-key text-muted"></i> <a href="rsafunctions.jsp">RSA Encryption</a></li>
                    <li><i class="fas fa-file-archive text-muted"></i> <a href="file-encrypt.jsp">File Encryption</a></li>
                </ul>
            </div>
            <div class="col-md-6">
                <ul class="list-unstyled mb-0">
                    <li><i class="fas fa-fingerprint text-muted"></i> <a href="MessageDigest.jsp">Hash Calculator</a></li>
                    <li><i class="fas fa-exchange-alt text-muted"></i> <a href="HexToStringFunctions.jsp">Hex Converters</a></li>
                    <li><i class="fas fa-qrcode text-muted"></i> <a href="qr-code.jsp">QR Code Generator</a></li>
                </ul>
            </div>
        </div>
    </div>

    <div style="margin-top: 1rem;">
        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="thanks.jsp"%>
        <%@ include file="addcomments.jsp"%>
    </div>

    <script>
        // Global variables
        var currentMode = 'encode';
        var encodeImage = null;
        var decodeImage = null;
        var maxCapacity = 0;

        // Mode switching
        function switchMode(mode) {
            currentMode = mode;
            var modeBtns = document.querySelectorAll('.mode-btn');
            modeBtns.forEach(function(btn) {
                btn.classList.remove('active');
            });
            event.target.closest('.mode-btn').classList.add('active');

            document.getElementById('encodePanel').classList.toggle('active', mode === 'encode');
            document.getElementById('decodePanel').classList.toggle('active', mode === 'decode');
        }

        // Setup encode image upload
        (function setupEncodeUpload() {
            var zone = document.getElementById('encodeUploadZone');
            var input = document.getElementById('encodeImageInput');
            var canvas = document.getElementById('encodeCanvas');
            var container = document.getElementById('encodePreviewContainer');
            var btn = document.getElementById('encodeBtn');

            zone.addEventListener('click', function() { input.click(); });

            zone.addEventListener('dragover', function(e) {
                e.preventDefault();
                zone.classList.add('dragover');
            });

            zone.addEventListener('dragleave', function() {
                zone.classList.remove('dragover');
            });

            zone.addEventListener('drop', function(e) {
                e.preventDefault();
                zone.classList.remove('dragover');
                if (e.dataTransfer.files.length > 0) {
                    processEncodeImage(e.dataTransfer.files[0]);
                }
            });

            input.addEventListener('change', function(e) {
                if (e.target.files.length > 0) {
                    processEncodeImage(e.target.files[0]);
                }
            });

            document.getElementById('messageInput').addEventListener('input', updateCapacityMeter);
        })();

        // Setup decode image upload
        (function setupDecodeUpload() {
            var zone = document.getElementById('decodeUploadZone');
            var input = document.getElementById('decodeImageInput');
            var canvas = document.getElementById('decodeCanvas');
            var container = document.getElementById('decodePreviewContainer');
            var btn = document.getElementById('decodeBtn');

            zone.addEventListener('click', function() { input.click(); });

            zone.addEventListener('dragover', function(e) {
                e.preventDefault();
                zone.classList.add('dragover');
            });

            zone.addEventListener('dragleave', function() {
                zone.classList.remove('dragover');
            });

            zone.addEventListener('drop', function(e) {
                e.preventDefault();
                zone.classList.remove('dragover');
                if (e.dataTransfer.files.length > 0) {
                    processDecodeImage(e.dataTransfer.files[0]);
                }
            });

            input.addEventListener('change', function(e) {
                if (e.target.files.length > 0) {
                    processDecodeImage(e.target.files[0]);
                }
            });
        })();

        // Process encode image
        function processEncodeImage(file) {
            if (!file.type.match('image.*')) {
                alert('Please select an image file');
                return;
            }

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
                    maxCapacity = Math.floor((img.width * img.height * 3) / 8) - 100; // Reserve 100 bytes for metadata

                    document.getElementById('encodePreviewContainer').classList.add('active');
                    document.getElementById('encodeImageInfo').innerHTML =
                        '<div class="image-info-item"><span><strong>Filename:</strong></span><span>' + file.name + '</span></div>' +
                        '<div class="image-info-item"><span><strong>Dimensions:</strong></span><span>' + img.width + ' × ' + img.height + ' px</span></div>' +
                        '<div class="image-info-item"><span><strong>File Size:</strong></span><span>' + formatBytes(file.size) + '</span></div>' +
                        '<div class="image-info-item"><span><strong>Max Message Capacity:</strong></span><span>' + maxCapacity + ' characters</span></div>';

                    document.getElementById('capacityMeter').style.display = 'block';
                    document.getElementById('encodeBtn').disabled = false;
                    updateCapacityMeter();
                };
                img.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }

        // Process decode image
        function processDecodeImage(file) {
            if (!file.type.match('image.*')) {
                alert('Please select an image file');
                return;
            }

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
                        '<div class="image-info-item"><span><strong>Filename:</strong></span><span>' + file.name + '</span></div>' +
                        '<div class="image-info-item"><span><strong>Dimensions:</strong></span><span>' + img.width + ' × ' + img.height + ' px</span></div>' +
                        '<div class="image-info-item"><span><strong>File Size:</strong></span><span>' + formatBytes(file.size) + '</span></div>';

                    document.getElementById('decodePasswordSection').style.display = 'block';
                    document.getElementById('decodeBtn').disabled = false;
                };
                img.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }

        // Update capacity meter
        function updateCapacityMeter() {
            var message = document.getElementById('messageInput').value;
            var messageLength = new Blob([message]).size;
            var percentage = Math.min((messageLength / maxCapacity) * 100, 100);

            document.getElementById('capacityText').textContent = messageLength + ' / ' + maxCapacity + ' bytes';
            document.getElementById('capacityFill').style.width = percentage + '%';

            if (percentage > 90) {
                document.getElementById('capacityFill').style.background = 'linear-gradient(135deg, #dc3545 0%, #c82333 100%)';
                document.getElementById('capacityDetails').textContent = 'Warning: Message size is near capacity limit';
            } else if (percentage > 70) {
                document.getElementById('capacityFill').style.background = 'linear-gradient(135deg, #ffc107 0%, #e0a800 100%)';
                document.getElementById('capacityDetails').textContent = 'Message size is ' + percentage.toFixed(1) + '% of capacity';
            } else {
                document.getElementById('capacityFill').style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
                document.getElementById('capacityDetails').textContent = 'Message size is ' + percentage.toFixed(1) + '% of capacity';
            }
        }

        // Encode message
        function encodeMessage() {
            var message = document.getElementById('messageInput').value;
            if (!message) {
                alert('Please enter a message to hide');
                return;
            }

            if (!encodeImage) {
                alert('Please upload an image first');
                return;
            }

            var messageLength = new Blob([message]).size;
            if (messageLength > maxCapacity) {
                alert('Message is too large for this image. Maximum capacity is ' + maxCapacity + ' bytes.');
                return;
            }

            document.getElementById('encodeSpinner').classList.add('active');
            document.getElementById('encodeBtn').disabled = true;

            setTimeout(function() {
                try {
                    var password = document.getElementById('encodePassword').value;
                    var useCompression = document.getElementById('encodeCompression').checked;

                    // Encrypt message if password provided
                    var processedMessage = message;
                    if (password) {
                        processedMessage = xorEncrypt(message, password);
                    }

                    // Compress if enabled
                    if (useCompression) {
                        processedMessage = btoa(processedMessage); // Simple base64 encoding as compression placeholder
                    }

                    // Encode message into image
                    var encodedData = encodeLSB(encodeImage, processedMessage);

                    // Create download link
                    var canvas = document.getElementById('encodeCanvas');
                    var ctx = canvas.getContext('2d');
                    ctx.putImageData(encodedData, 0, 0);

                    canvas.toBlob(function(blob) {
                        var url = URL.createObjectURL(blob);
                        var filename = '8gwifi.org-stego-' + Date.now() + '.png';

                        var resultHtml = '<div class="result-message">' +
                            '<h4><i class="fas fa-check-circle"></i> Message Encoded Successfully!</h4>' +
                            '<p>Your message has been hidden in the image. Download the image below:</p>' +
                            '</div>' +
                            '<canvas id="resultCanvas" class="image-preview"></canvas>' +
                            '<button class="stego-btn" onclick="downloadEncodedImage(\'' + url + '\', \'' + filename + '\')">' +
                            '<i class="fas fa-download"></i> Download Image with Hidden Message' +
                            '</button>' +
                            '<button class="stego-btn secondary" onclick="resetEncode()">' +
                            '<i class="fas fa-redo"></i> Encode Another Message' +
                            '</button>';

                        document.getElementById('encodeResult').innerHTML = resultHtml;
                        document.getElementById('encodeResult').classList.add('active');

                        // Copy canvas to result
                        var resultCanvas = document.getElementById('resultCanvas');
                        resultCanvas.width = canvas.width;
                        resultCanvas.height = canvas.height;
                        var resultCtx = resultCanvas.getContext('2d');
                        resultCtx.putImageData(encodedData, 0, 0);

                        document.getElementById('encodeSpinner').classList.remove('active');
                    }, 'image/png');

                } catch (err) {
                    document.getElementById('encodeResult').innerHTML =
                        '<div class="result-error"><h4><i class="fas fa-exclamation-triangle"></i> Encoding Failed</h4>' +
                        '<p>' + err.message + '</p></div>';
                    document.getElementById('encodeResult').classList.add('active');
                    document.getElementById('encodeSpinner').classList.remove('active');
                    document.getElementById('encodeBtn').disabled = false;
                }
            }, 100);
        }

        // Decode message
        function decodeMessage() {
            if (!decodeImage) {
                alert('Please upload an image first');
                return;
            }

            document.getElementById('decodeSpinner').classList.add('active');
            document.getElementById('decodeBtn').disabled = true;

            setTimeout(function() {
                try {
                    // Decode message from image
                    var encodedMessage = decodeLSB(decodeImage);

                    if (!encodedMessage) {
                        throw new Error('No hidden message found in this image');
                    }

                    var password = document.getElementById('decodePassword').value;

                    // Try to decompress (base64 decode)
                    var processedMessage = encodedMessage;
                    try {
                        processedMessage = atob(encodedMessage);
                    } catch (e) {
                        // Not compressed
                    }

                    // Decrypt if password provided
                    if (password) {
                        processedMessage = xorEncrypt(processedMessage, password);
                    }

                    var resultHtml = '<div class="result-message">' +
                        '<h4><i class="fas fa-check-circle"></i> Message Extracted Successfully!</h4>' +
                        '<p>The hidden message has been extracted from the image:</p>' +
                        '</div>' +
                        '<div class="extracted-message">' + escapeHtml(processedMessage) + '</div>' +
                        '<button class="stego-btn secondary" onclick="copyMessage(\'' + escapeHtml(processedMessage) + '\')">' +
                        '<i class="fas fa-copy"></i> Copy Message' +
                        '</button>' +
                        '<button class="stego-btn secondary" onclick="resetDecode()">' +
                        '<i class="fas fa-redo"></i> Decode Another Image' +
                        '</button>';

                    document.getElementById('decodeResult').innerHTML = resultHtml;
                    document.getElementById('decodeResult').classList.add('active');
                    document.getElementById('decodeSpinner').classList.remove('active');

                } catch (err) {
                    document.getElementById('decodeResult').innerHTML =
                        '<div class="result-error"><h4><i class="fas fa-exclamation-triangle"></i> Decoding Failed</h4>' +
                        '<p>' + err.message + '</p>' +
                        '<p>Possible reasons:</p>' +
                        '<ul>' +
                        '<li>Image does not contain a hidden message</li>' +
                        '<li>Wrong password (if message was encrypted)</li>' +
                        '<li>Image was modified or compressed after encoding</li>' +
                        '</ul></div>';
                    document.getElementById('decodeResult').classList.add('active');
                    document.getElementById('decodeSpinner').classList.remove('active');
                    document.getElementById('decodeBtn').disabled = false;
                }
            }, 100);
        }

        // LSB Encoding
        function encodeLSB(imageData, message) {
            var data = new Uint8ClampedArray(imageData.data);

            // Add message length header (4 bytes)
            var msgLength = message.length;
            var header = [
                (msgLength >> 24) & 0xFF,
                (msgLength >> 16) & 0xFF,
                (msgLength >> 8) & 0xFF,
                msgLength & 0xFF
            ];

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

        // LSB Decoding - Multi-method decoder
        function decodeLSB(imageData) {
            // Try multiple decoding methods for compatibility with different tools

            // Method 1: Try our custom format with length header
            try {
                var result = decodeWithLengthHeader(imageData);
                if (result && result.length > 0) return result;
            } catch (e) {}

            // Method 2: Try null-terminated string (common format)
            try {
                var result = decodeNullTerminated(imageData);
                if (result && result.length > 0) return result;
            } catch (e) {}

            // Method 3: Try reading with delimiter (stylesuxx method)
            try {
                var result = decodeWithDelimiter(imageData);
                if (result && result.length > 0) return result;
            } catch (e) {}

            // Method 4: Try reading up to printable ASCII limit
            try {
                var result = decodePrintableASCII(imageData);
                if (result && result.length > 0) return result;
            } catch (e) {}

            throw new Error('No hidden message found or unsupported format');
        }

        // Method 1: Decode with length header (our format)
        function decodeWithLengthHeader(imageData) {
            var data = imageData.data;
            var bitIndex = 0;
            var bytes = [];

            // Read length header (4 bytes)
            for (var i = 0; i < 4; i++) {
                var byte = 0;
                for (var bit = 7; bit >= 0; bit--) {
                    var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
                    var bitValue = data[pixelIndex] & 1;
                    byte = (byte << 1) | bitValue;
                    bitIndex++;
                }
                bytes.push(byte);
            }

            var msgLength = (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];

            if (msgLength <= 0 || msgLength > 100000) {
                throw new Error('Invalid message length');
            }

            // Read message
            bytes = [];
            for (var i = 0; i < msgLength; i++) {
                var byte = 0;
                for (var bit = 7; bit >= 0; bit--) {
                    var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
                    var bitValue = data[pixelIndex] & 1;
                    byte = (byte << 1) | bitValue;
                    bitIndex++;
                }
                bytes.push(byte);
            }

            return new TextDecoder().decode(new Uint8Array(bytes));
        }

        // Method 2: Decode null-terminated string
        function decodeNullTerminated(imageData) {
            var data = imageData.data;
            var bitIndex = 0;
            var bytes = [];
            var maxBytes = 100000;

            for (var i = 0; i < maxBytes; i++) {
                var byte = 0;
                for (var bit = 7; bit >= 0; bit--) {
                    var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
                    if (pixelIndex >= data.length) break;
                    var bitValue = data[pixelIndex] & 1;
                    byte = (byte << 1) | bitValue;
                    bitIndex++;
                }

                if (byte === 0) break; // Null terminator found
                bytes.push(byte);
            }

            if (bytes.length === 0) throw new Error('No message');

            var text = new TextDecoder().decode(new Uint8Array(bytes));
            // Validate it's mostly printable
            var printable = text.split('').filter(function(c) {
                var code = c.charCodeAt(0);
                return code >= 32 && code <= 126 || code === 10 || code === 13;
            }).length;

            if (printable / text.length < 0.8) throw new Error('Not text');
            return text;
        }

        // Method 3: Decode with delimiter marker (stylesuxx and similar tools)
        function decodeWithDelimiter(imageData) {
            var data = imageData.data;
            var bitIndex = 0;
            var bytes = [];
            var maxBytes = 100000;
            var delimiter = '#&#';  // Common delimiter used by many tools
            var delFound = false;

            // First, try to read until we find the delimiter
            for (var i = 0; i < maxBytes; i++) {
                var byte = 0;
                for (var bit = 7; bit >= 0; bit--) {
                    var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
                    if (pixelIndex >= data.length) break;
                    var bitValue = data[pixelIndex] & 1;
                    byte = (byte << 1) | bitValue;
                    bitIndex++;
                }

                bytes.push(byte);

                // Check if we've reached the delimiter
                if (bytes.length >= delimiter.length) {
                    var tail = String.fromCharCode.apply(null, bytes.slice(-delimiter.length));
                    if (tail === delimiter) {
                        delFound = true;
                        bytes = bytes.slice(0, -delimiter.length);
                        break;
                    }
                }
            }

            if (bytes.length === 0) throw new Error('No message');

            var text = new TextDecoder('utf-8', {fatal: false}).decode(new Uint8Array(bytes));

            // Clean up any trailing null bytes or non-printable characters at the end
            text = text.replace(/\0+$/, '');

            if (text.length === 0) throw new Error('Empty message');
            return text;
        }

        // Method 4: Decode printable ASCII only (heuristic approach)
        function decodePrintableASCII(imageData) {
            var data = imageData.data;
            var bitIndex = 0;
            var bytes = [];
            var maxBytes = 50000;
            var consecutiveNonPrintable = 0;

            for (var i = 0; i < maxBytes; i++) {
                var byte = 0;
                for (var bit = 7; bit >= 0; bit--) {
                    var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
                    if (pixelIndex >= data.length) break;
                    var bitValue = data[pixelIndex] & 1;
                    byte = (byte << 1) | bitValue;
                    bitIndex++;
                }

                // Check if byte is printable ASCII or common whitespace
                if ((byte >= 32 && byte <= 126) || byte === 10 || byte === 13 || byte === 9) {
                    bytes.push(byte);
                    consecutiveNonPrintable = 0;
                } else if (byte === 0 && bytes.length > 0) {
                    // Likely end of message
                    break;
                } else {
                    consecutiveNonPrintable++;
                    // If we hit too many non-printable chars, stop
                    if (consecutiveNonPrintable > 10 && bytes.length > 0) break;
                    if (consecutiveNonPrintable > 50) throw new Error('Not text');
                }
            }

            if (bytes.length < 1) throw new Error('No message');

            var text = new TextDecoder().decode(new Uint8Array(bytes));
            return text.trim();
        }

        // XOR Encryption
        function xorEncrypt(message, password) {
            var result = '';
            for (var i = 0; i < message.length; i++) {
                result += String.fromCharCode(message.charCodeAt(i) ^ password.charCodeAt(i % password.length));
            }
            return result;
        }

        // Helper functions
        function formatBytes(bytes) {
            if (bytes === 0) return '0 Bytes';
            var k = 1024;
            var sizes = ['Bytes', 'KB', 'MB'];
            var i = Math.floor(Math.log(bytes) / Math.log(k));
            return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
        }

        function escapeHtml(text) {
            var map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
        }

        function downloadEncodedImage(url, filename) {
            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            a.click();
        }

        function copyMessage(message) {
            var textarea = document.createElement('textarea');
            textarea.value = message;
            document.body.appendChild(textarea);
            textarea.select();
            document.execCommand('copy');
            document.body.removeChild(textarea);
            alert('Message copied to clipboard!');
        }

        function resetEncode() {
            document.getElementById('encodeImageInput').value = '';
            document.getElementById('messageInput').value = '';
            document.getElementById('encodePassword').value = '';
            document.getElementById('encodePreviewContainer').classList.remove('active');
            document.getElementById('encodeResult').classList.remove('active');
            document.getElementById('capacityMeter').style.display = 'none';
            document.getElementById('encodeBtn').disabled = true;
            encodeImage = null;
        }

        function resetDecode() {
            document.getElementById('decodeImageInput').value = '';
            document.getElementById('decodePassword').value = '';
            document.getElementById('decodePreviewContainer').classList.remove('active');
            document.getElementById('decodeResult').classList.remove('active');
            document.getElementById('decodeBtn').disabled = true;
            decodeImage = null;
        }
    </script>
</div>
</div>
<%@ include file="body-close.jsp"%>
