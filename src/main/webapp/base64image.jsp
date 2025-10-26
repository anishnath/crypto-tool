<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />

    <title>Free Image to Base64 Converter Online - Data URI Generator</title>
    <meta name="description" content="Free online image to Base64 converter. Convert JPG, PNG, GIF, WebP to Base64 encoded data URI. Generate CSS background-image, HTML img tag, or plain Base64 string. No upload to server, 100% client-side." />
    <meta name="keywords" content="image to base64, base64 image encoder, data uri generator, base64 image converter, image data uri, base64 encode image, convert image to base64, png to base64, jpg to base64" />

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/base64image.jsp" />
    <meta property="og:title" content="Free Image to Base64 Converter - Data URI Generator" />
    <meta property="og:description" content="Convert images to Base64 data URI instantly. Support JPG, PNG, GIF, WebP. Generate CSS, HTML tags. 100% client-side, no upload." />
    <meta property="og:image" content="https://8gwifi.org/images/site/base64image.png" />

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:url" content="https://8gwifi.org/base64image.jsp" />
    <meta property="twitter:title" content="Image to Base64 Converter - Data URI Generator" />
    <meta property="twitter:description" content="Convert images to Base64 data URI. JPG, PNG, GIF, WebP support. 100% client-side." />
    <meta property="twitter:image" content="https://8gwifi.org/images/site/base64image.png" />

    <link rel="canonical" href="https://8gwifi.org/base64image.jsp" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free Image to Base64 Converter Online - Data URI Generator",
      "alternateName": ["Base64 Image Encoder", "Image to Base64", "Data URI Generator", "Base64 Image Converter"],
      "description": "Professional online image to Base64 converter tool. Convert JPG, PNG, GIF, WebP, SVG images to Base64 encoded data URI strings. Generate CSS background-image code, HTML img tags, or plain Base64 strings. Support for multiple output formats and image preview. 100% client-side processing - images never uploaded to server.",
      "url": "https://8gwifi.org/base64image.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Any",
      "permissions": "browser",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "creator": {
        "@type": "Organization",
        "name": "8gwifi.org"
      },
      "featureList": [
        "Convert images to Base64 encoding",
        "Generate data URI scheme",
        "Support JPG/JPEG images",
        "Support PNG images",
        "Support GIF images",
        "Support WebP images",
        "Support SVG images",
        "Generate CSS background-image code",
        "Generate HTML img tag",
        "Generate plain Base64 string",
        "Image preview",
        "Drag and drop support",
        "Copy to clipboard",
        "Download Base64 output",
        "Image size information",
        "MIME type detection",
        "Privacy-focused (no server upload)",
        "Instant conversion",
        "Responsive design",
        "Mobile friendly"
      ],
      "keywords": [
        "image to base64 converter online",
        "base64 image encoder",
        "data uri generator",
        "convert image to base64",
        "png to base64",
        "jpg to base64",
        "gif to base64",
        "webp to base64",
        "base64 encode image online",
        "image data uri scheme",
        "base64 css background",
        "base64 html img",
        "encode image to base64",
        "picture to base64",
        "photo to base64",
        "base64 image decoder",
        "data url generator",
        "inline image base64",
        "embed image base64",
        "base64 image converter tool",
        "image to data url",
        "base64 image online",
        "convert jpg to base64 online",
        "convert png to base64 online",
        "base64 encoder image",
        "image file to base64",
        "upload image to base64",
        "base64 image generator"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.9",
        "ratingCount": "4500",
        "bestRating": "5",
        "worstRating": "1"
      },
      "screenshot": "https://8gwifi.org/images/base64-converter-screenshot.png"
    }
    </script>

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
        }

        .container-custom {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 1.8rem;
        }

        .subtitle {
            color: #666;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }

        .upload-area {
            border: 2px dashed #007bff;
            border-radius: 6px;
            padding: 20px;
            text-align: center;
            background: #f8f9fa;
            margin-bottom: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .upload-area:hover {
            background: #e9ecef;
            border-color: #0056b3;
        }

        .upload-area.dragover {
            background: #cfe2ff;
            border-color: #0056b3;
        }

        .upload-icon {
            font-size: 24px;
            color: #007bff;
            display: inline-block;
            margin-right: 10px;
        }

        .upload-text {
            font-size: 0.95rem;
            color: #333;
            display: inline-block;
        }

        .upload-subtext {
            font-size: 0.85rem;
            color: #666;
            margin-top: 5px;
        }

        .file-input {
            display: none;
        }

        .output-format-selector {
            display: flex;
            gap: 10px;
            margin: 20px 0;
            flex-wrap: wrap;
        }

        .format-btn {
            padding: 8px 16px;
            background: #f8f9fa;
            border: 2px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.2s;
        }

        .format-btn:hover {
            background: #e9ecef;
        }

        .format-btn.active {
            background: #007bff;
            color: white;
            border-color: #0056b3;
        }

        .preview-container {
            display: none;
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .preview-container.active {
            display: block;
        }

        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .preview-title {
            font-weight: 600;
            color: #333;
            font-size: 1rem;
        }

        .preview-actions {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            padding: 6px 12px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: background 0.2s;
        }

        .action-btn:hover {
            background: #5a6268;
        }

        .action-btn.primary {
            background: #007bff;
        }

        .action-btn.primary:hover {
            background: #0056b3;
        }

        .preview-image {
            max-width: 100%;
            max-height: 400px;
            display: block;
            margin: 0 auto 20px;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .image-info {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .info-item {
            font-size: 0.9rem;
        }

        .info-label {
            color: #666;
            font-weight: 500;
        }

        .info-value {
            color: #007bff;
            font-weight: 600;
        }

        .output-textarea {
            width: 100%;
            min-height: 200px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            resize: vertical;
            background: #2d2d2d;
            color: #f8f8f2;
        }

        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #007bff;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }

        .info-box h3 {
            margin-top: 0;
            color: #0056b3;
            font-size: 1.1rem;
        }

        .info-box code {
            background: #fff;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Consolas', 'Monaco', monospace;
            color: #d63384;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
            display: none;
            border: 1px solid #c3e6cb;
        }

        @media (max-width: 768px) {
            .upload-area {
                padding: 30px 20px;
            }

            .format-btn {
                font-size: 0.8rem;
                padding: 6px 12px;
            }
        }
    </style>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>

<div class="container-custom">
    <h1>Free Image to Base64 Converter Online</h1>
    <p class="subtitle">Convert JPG, PNG, GIF, WebP, SVG images to Base64 data URI. Generate CSS background-image, HTML img tag, or plain Base64 string. 100% client-side - your images never leave your browser.</p>

    <div class="upload-area" id="uploadArea">
        <span class="upload-icon">📁</span>
        <span class="upload-text">Click to upload or drag & drop image</span>
        <div class="upload-subtext">Supports: JPG, PNG, GIF, WebP, SVG (Max 10MB)</div>
        <input type="file" id="fileInput" class="file-input" accept="image/*">
    </div>

    <div class="success-message" id="successMessage"></div>

    <div class="preview-container" id="previewContainer">
        <div class="preview-header">
            <span class="preview-title">Output Format</span>
        </div>

        <div class="output-format-selector">
            <button class="format-btn active" data-format="datauri" onclick="changeFormat('datauri')">Data URI (Full)</button>
            <button class="format-btn" data-format="base64only" onclick="changeFormat('base64only')">Base64 Only</button>
            <button class="format-btn" data-format="html" onclick="changeFormat('html')">HTML img Tag</button>
            <button class="format-btn" data-format="css" onclick="changeFormat('css')">CSS Background</button>
            <button class="format-btn" data-format="json" onclick="changeFormat('json')">JSON</button>
        </div>

        <div class="preview-header">
            <span class="preview-title" id="outputTitle">Base64 Output</span>
            <div class="preview-actions">
                <button class="action-btn primary" onclick="copyOutput()">Copy</button>
                <button class="action-btn" onclick="downloadOutput()">Download</button>
            </div>
        </div>

        <textarea id="outputText" class="output-textarea" readonly></textarea>

        <div class="preview-header" style="margin-top: 20px;">
            <span class="preview-title">Image Preview & Details</span>
            <div class="preview-actions">
                <button class="action-btn" onclick="clearImage()">Clear</button>
            </div>
        </div>

        <img id="previewImage" class="preview-image" alt="Preview">

        <div class="image-info">
            <div class="info-item">
                <span class="info-label">File:</span>
                <span class="info-value" id="fileName"></span>
            </div>
            <div class="info-item">
                <span class="info-label">Size:</span>
                <span class="info-value" id="fileSize"></span>
            </div>
            <div class="info-item">
                <span class="info-label">Type:</span>
                <span class="info-value" id="fileType"></span>
            </div>
            <div class="info-item">
                <span class="info-label">Dimensions:</span>
                <span class="info-value" id="fileDimensions"></span>
            </div>
            <div class="info-item">
                <span class="info-label">Base64 Length:</span>
                <span class="info-value" id="base64Length"></span>
            </div>
        </div>
    </div>

    <div class="info-box">
        <h3>About Data URI & Base64 Images</h3>
        <p><strong>Data URI scheme</strong> allows you to embed images directly in HTML/CSS using Base64 encoding.</p>

        <p><strong>Format:</strong> <code>data:[mediatype][;base64],[data]</code></p>

        <p><strong>Example:</strong></p>
        <code style="display: block; padding: 10px; background: #fff; overflow-x: auto;">
            &lt;img src="data:image/png;base64,iVBORw0KGgoAAAA..." alt="Image" /&gt;
        </code>

        <p><strong>Advantages:</strong></p>
        <ul>
            <li>Reduces HTTP requests</li>
            <li>Images load instantly with HTML/CSS</li>
            <li>Good for small icons and logos</li>
            <li>Works in offline applications</li>
        </ul>

        <p><strong>Disadvantages:</strong></p>
        <ul>
            <li>Increases HTML/CSS file size by ~33%</li>
            <li>Not cached separately</li>
            <li>Not suitable for large images</li>
            <li>Cannot be lazy-loaded</li>
        </ul>
    </div>
</div>

<script>
    let currentFormat = 'datauri';
    let base64Data = '';
    let mimeType = '';
    let fileName = '';

    const uploadArea = document.getElementById('uploadArea');
    const fileInput = document.getElementById('fileInput');
    const previewContainer = document.getElementById('previewContainer');
    const previewImage = document.getElementById('previewImage');
    const outputText = document.getElementById('outputText');

    // Click to upload
    uploadArea.addEventListener('click', () => {
        fileInput.click();
    });

    // File input change
    fileInput.addEventListener('change', (e) => {
        handleFile(e.target.files[0]);
    });

    // Drag and drop
    uploadArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadArea.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', () => {
        uploadArea.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadArea.classList.remove('dragover');
        handleFile(e.dataTransfer.files[0]);
    });

    function handleFile(file) {
        if (!file) return;

        if (!file.type.startsWith('image/')) {
            alert('Please upload an image file');
            return;
        }

        if (file.size > 10 * 1024 * 1024) {
            alert('File size must be less than 10MB');
            return;
        }

        fileName = file.name;
        mimeType = file.type;

        const reader = new FileReader();

        reader.onload = function(e) {
            base64Data = e.target.result;

            // Set preview image
            previewImage.src = base64Data;

            // Get image dimensions
            const img = new Image();
            img.onload = function() {
                document.getElementById('fileDimensions').textContent = this.width + ' × ' + this.height;
            };
            img.src = base64Data;

            // Update file info
            document.getElementById('fileName').textContent = fileName;
            document.getElementById('fileSize').textContent = formatFileSize(file.size);
            document.getElementById('fileType').textContent = mimeType;
            document.getElementById('base64Length').textContent = base64Data.length.toLocaleString() + ' chars';

            // Show preview container
            previewContainer.classList.add('active');

            // Generate output
            generateOutput();

            showSuccess('Image converted successfully!');
        };

        reader.readAsDataURL(file);
    }

    function changeFormat(format) {
        currentFormat = format;

        // Update active button
        document.querySelectorAll('.format-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector('[data-format="' + format + '"]').classList.add('active');

        generateOutput();
    }

    function generateOutput() {
        let output = '';
        let title = 'Base64 Output';

        switch(currentFormat) {
            case 'datauri':
                output = base64Data;
                title = 'Data URI (Complete)';
                break;

            case 'base64only':
                output = base64Data.split(',')[1];
                title = 'Base64 Only (Without Data URI prefix)';
                break;

            case 'html':
                output = '<img src="' + base64Data + '" alt="' + fileName + '" />';
                title = 'HTML img Tag';
                break;

            case 'css':
                output = 'background-image: url(\'' + base64Data + '\');';
                title = 'CSS Background Image';
                break;

            case 'json':
                output = JSON.stringify({
                    fileName: fileName,
                    mimeType: mimeType,
                    base64: base64Data
                }, null, 4);
                title = 'JSON Format';
                break;
        }

        document.getElementById('outputTitle').textContent = title;
        outputText.value = output;
    }

    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
    }

    function copyOutput() {
        outputText.select();
        document.execCommand('copy');
        showSuccess('Copied to clipboard!');
    }

    function downloadOutput() {
        const blob = new Blob([outputText.value], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'base64-output.txt';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        showSuccess('Downloaded successfully!');
    }

    function clearImage() {
        fileInput.value = '';
        base64Data = '';
        mimeType = '';
        fileName = '';
        previewContainer.classList.remove('active');
        previewImage.src = '';
        outputText.value = '';
    }

    function showSuccess(message) {
        const successDiv = document.getElementById('successMessage');
        successDiv.textContent = message;
        successDiv.style.display = 'block';

        setTimeout(() => {
            successDiv.style.display = 'none';
        }, 3000);
    }
</script>

<hr>
<div class="sharethis-inline-share-buttons"></div>

<hr>
<h2 class="mt-4">Related Tools</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="Base64Functions.jsp">Base64 Encode/Decode Text</a></li>
            <li><a href="base64Hex.jsp">Base64 to Hex Converter</a></li>
            <li><a href="UrlEncodeDecodeFunctions.jsp">URL Encoder/Decoder</a></li>
            <li><a href="StringFunctions.jsp">String Converter & Text Tools</a></li>
            <li><a href="HexToStringFunctions.jsp">Hex to String Converter</a></li>
        </ul>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
