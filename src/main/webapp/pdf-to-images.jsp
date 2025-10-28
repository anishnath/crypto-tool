<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PDF to Images - Convert PDF Pages to PNG/JPG Online | Free PDF Converter</title>
    <meta name="description" content="Free online PDF to image converter. Convert PDF pages to PNG, JPG, or WEBP format. Extract all pages or select specific ones. High quality, client-side processing.">
    <meta name="keywords" content="pdf to jpg, pdf to png, pdf to image, convert pdf to images, pdf to webp, pdf page extractor, pdf converter, free pdf to jpg">

    <!-- Open Graph / Social Media -->
    <meta property="og:title" content="PDF to Images - Convert PDF to PNG/JPG Online">
    <meta property="og:description" content="Convert PDF pages to high-quality images in PNG, JPG, or WEBP format. Free, secure, client-side processing.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/pdf-to-images.jsp">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context" : "https://schema.org",
      "@type" : "SoftwareApplication",
      "name" : "PDF to Images - PDF Page Converter",
      "url" : "https://8gwifi.org/pdf-to-images.jsp",
      "applicationCategory" : "UtilityApplication",
      "operatingSystem" : "Any",
      "description" : "Free online tool to convert PDF pages to images in PNG, JPG, or WEBP format with customizable quality and resolution.",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList" : [
        "Convert PDF to PNG, JPG, or WEBP images",
        "Extract all pages or select specific ones",
        "Adjustable image quality and resolution",
        "High-quality rendering up to 300 DPI",
        "Preview before download",
        "Batch download all images as ZIP",
        "100% client-side processing - no upload",
        "No file size limits",
        "Preserve image quality",
        "Privacy-focused - files never leave device",
        "Free unlimited conversions",
        "Custom page selection"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "ratingCount": "634"
      }
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [{
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "https://8gwifi.org/"
      },{
        "@type": "ListItem",
        "position": 2,
        "name": "PDF Tools",
        "item": "https://8gwifi.org/merge-pdf.jsp"
      },{
        "@type": "ListItem",
        "position": 3,
        "name": "PDF to Images",
        "item": "https://8gwifi.org/pdf-to-images.jsp"
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Convert PDF to Images",
      "description": "Learn how to convert PDF pages to PNG, JPG, or WEBP images",
      "step": [{
        "@type": "HowToStep",
        "position": 1,
        "name": "Upload PDF",
        "text": "Click 'Choose PDF File' or drag and drop your PDF document"
      },{
        "@type": "HowToStep",
        "position": 2,
        "name": "Select Format",
        "text": "Choose output format: PNG (best quality), JPG (smaller size), or WEBP (balanced)"
      },{
        "@type": "HowToStep",
        "position": 3,
        "name": "Configure Settings",
        "text": "Adjust quality (1-100) and scale (resolution) settings"
      },{
        "@type": "HowToStep",
        "position": 4,
        "name": "Select Pages",
        "text": "Choose 'All Pages' or manually select specific pages to convert"
      },{
        "@type": "HowToStep",
        "position": 5,
        "name": "Convert",
        "text": "Click 'Convert to Images' and wait for processing"
      },{
        "@type": "HowToStep",
        "position": 6,
        "name": "Download",
        "text": "Download individual images or all at once as ZIP file"
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "What image formats are supported?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "We support PNG (best quality, larger files), JPG (smaller files, lossy compression), and WEBP (modern format, balanced quality and size)."
        }
      },{
        "@type": "Question",
        "name": "What's the maximum resolution?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "You can render up to 300 DPI (scale 3.0) for print-quality images. Higher scales produce larger, more detailed images."
        }
      },{
        "@type": "Question",
        "name": "Are my PDFs uploaded to a server?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "No, all conversion happens locally in your browser using JavaScript. Your files never leave your device."
        }
      },{
        "@type": "Question",
        "name": "Can I convert specific pages only?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Yes, after uploading, you can select specific pages to convert using the visual page selector or convert all pages at once."
        }
      },{
        "@type": "Question",
        "name": "Which format should I choose?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "PNG for maximum quality and transparency support, JPG for photos and smaller file sizes, WEBP for modern web usage with good compression."
        }
      }]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 1rem 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        .pdf-to-images-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .pdf-to-images-header {
            text-align: center;
            color: white;
            margin-bottom: 1.5rem;
        }

        .pdf-to-images-header h1 {
            font-size: 2rem;
            margin: 0 0 0.5rem 0;
            font-weight: 600;
        }

        .pdf-to-images-header p {
            font-size: 1rem;
            margin: 0;
            opacity: 0.95;
        }

        .pdf-to-images-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 968px) {
            .pdf-to-images-layout {
                grid-template-columns: 1fr;
            }
        }

        .pdf-to-images-panel {
            background: white;
            border-radius: 12px;
            padding: 1rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }

        .pdf-to-images-panel h3 {
            margin: 0 0 0.75rem 0;
            font-size: 1rem;
            color: #333;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .pdf-to-images-panel h3 .icon {
            font-size: 1.2rem;
        }

        .file-upload-area {
            border: 2px dashed #667eea;
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #f8f9ff;
            margin-bottom: 0.75rem;
        }

        .file-upload-area:hover {
            border-color: #764ba2;
            background: #f0f2ff;
        }

        .file-upload-area.drag-over {
            border-color: #764ba2;
            background: #e8ebff;
            transform: scale(1.02);
        }

        .file-upload-area .upload-icon {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .file-upload-area p {
            margin: 0.25rem 0;
            color: #666;
            font-size: 0.85rem;
        }

        .file-upload-area .primary-text {
            font-size: 1rem;
            color: #333;
            font-weight: 500;
        }

        .file-info {
            background: #f8f9fa;
            padding: 0.75rem;
            border-radius: 6px;
            margin-bottom: 0.75rem;
            display: none;
        }

        .file-info.active {
            display: block;
        }

        .file-info p {
            margin: 0.25rem 0;
            font-size: 0.85rem;
            color: #666;
        }

        .file-info strong {
            color: #333;
        }

        .format-selection {
            margin-bottom: 0.75rem;
        }

        .format-selection label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .format-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.5rem;
        }

        .format-option {
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            padding: 0.6rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
        }

        .format-option:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .format-option.selected {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .format-option input[type="radio"] {
            display: none;
        }

        .format-option .format-name {
            font-weight: 500;
            font-size: 0.9rem;
            display: block;
        }

        .format-option .format-desc {
            font-size: 0.7rem;
            opacity: 0.8;
            margin-top: 0.15rem;
        }

        .settings-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .input-group-custom {
            margin-bottom: 0.75rem;
        }

        .input-group-custom label {
            display: block;
            margin-bottom: 0.3rem;
            color: #555;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .input-group-custom input[type="range"],
        .input-group-custom input[type="number"] {
            width: 100%;
        }

        .input-group-custom input[type="number"] {
            padding: 0.6rem;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 0.9rem;
            box-sizing: border-box;
        }

        .range-with-value {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .range-with-value input[type="range"] {
            flex: 1;
        }

        .range-with-value .range-value {
            min-width: 40px;
            text-align: center;
            font-weight: 600;
            color: #667eea;
        }

        .input-hint {
            font-size: 0.75rem;
            color: #999;
            margin-top: 0.25rem;
        }

        .page-selection-mode {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
        }

        .mode-btn {
            padding: 0.6rem;
            border: 2px solid #e0e0e0;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .mode-btn:hover {
            border-color: #667eea;
        }

        .mode-btn.active {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .page-selector {
            max-height: 200px;
            overflow-y: auto;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            padding: 0.5rem;
            display: none;
        }

        .page-selector.active {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(60px, 1fr));
            gap: 0.5rem;
        }

        .page-selector-item {
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            padding: 0.4rem;
            text-align: center;
            cursor: pointer;
            font-size: 0.8rem;
            transition: all 0.2s ease;
        }

        .page-selector-item:hover {
            border-color: #667eea;
        }

        .page-selector-item.selected {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .btn-convert {
            width: 100%;
            padding: 0.8rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .btn-convert:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-convert:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .progress-bar {
            width: 100%;
            height: 6px;
            background: #e0e0e0;
            border-radius: 3px;
            overflow: hidden;
            margin: 0.75rem 0;
            display: none;
        }

        .progress-bar.active {
            display: block;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            width: 0%;
            transition: width 0.3s ease;
        }

        .progress-text {
            text-align: center;
            font-size: 0.85rem;
            color: #666;
            margin-top: 0.25rem;
            display: none;
        }

        .progress-text.active {
            display: block;
        }

        .image-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 0.75rem;
            max-height: 500px;
            overflow-y: auto;
        }

        .image-item {
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
            background: #f8f9fa;
        }

        .image-preview {
            width: 100%;
            height: 120px;
            object-fit: contain;
            background: white;
            padding: 0.5rem;
        }

        .image-info {
            padding: 0.5rem;
            border-top: 2px solid #e0e0e0;
        }

        .image-info .image-name {
            font-size: 0.75rem;
            font-weight: 500;
            color: #333;
            margin-bottom: 0.25rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .image-info .image-size {
            font-size: 0.7rem;
            color: #999;
            margin-bottom: 0.5rem;
        }

        .btn-download-image {
            width: 100%;
            padding: 0.4rem;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 0.75rem;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .btn-download-image:hover {
            background: #218838;
        }

        .btn-download-all {
            width: 100%;
            padding: 0.8rem;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            margin-top: 0.75rem;
            display: none;
        }

        .btn-download-all.active {
            display: block;
        }

        .btn-download-all:hover {
            background: #218838;
        }

        .status-message {
            padding: 0.75rem;
            border-radius: 6px;
            margin-bottom: 0.75rem;
            font-size: 0.85rem;
            display: none;
        }

        .status-message.active {
            display: block;
        }

        .status-message.info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .status-message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .placeholder-output {
            text-align: center;
            padding: 2rem;
            color: #999;
        }

        .placeholder-output .placeholder-icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }

        .placeholder-output p {
            margin: 0;
        }

        .pdf-preview {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 0.75rem;
            margin-top: 0.75rem;
            max-height: 400px;
            overflow-y: auto;
            padding: 0.5rem;
            background: #f8f9fa;
            border-radius: 6px;
        }

        .pdf-preview-item {
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            padding: 0.5rem;
            text-align: center;
            background: white;
            transition: all 0.2s ease;
        }

        .pdf-preview-item:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
        }

        .pdf-preview-item .preview-thumbnail {
            width: 100%;
            height: 140px;
            object-fit: contain;
            background: white;
            border-radius: 4px;
            margin-bottom: 0.5rem;
            border: 1px solid #e0e0e0;
        }

        .pdf-preview-item .preview-page-number {
            font-size: 0.85rem;
            font-weight: 500;
            color: #667eea;
        }

        .preview-loading {
            text-align: center;
            padding: 1rem;
            color: #999;
            font-size: 0.85rem;
        }

        .preview-loading .spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #e0e0e0;
            border-top-color: #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 0.5rem;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .about-section, .related-section {
            background: white;
            border-radius: 12px;
            padding: 1rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }

        .about-section h2, .related-section h2 {
            font-size: 1.2rem;
            margin: 0 0 0.75rem 0;
            color: #333;
        }

        .about-section p, .about-section ul {
            font-size: 0.9rem;
            line-height: 1.6;
            color: #666;
            margin-bottom: 0.75rem;
        }

        .about-section ul {
            padding-left: 1.5rem;
        }

        .about-section li {
            margin-bottom: 0.5rem;
        }

        .related-links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.75rem;
        }

        .related-link {
            display: block;
            padding: 0.75rem;
            background: #f8f9ff;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            text-decoration: none;
            color: #667eea;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.2s ease;
            text-align: center;
        }

        .related-link:hover {
            border-color: #667eea;
            background: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>

    <div class="pdf-to-images-container">
        <div class="pdf-to-images-header">
            <h1>🖼️ PDF to Images - Convert PDF Pages to PNG/JPG</h1>
            <p>Convert PDF pages to high-quality images in PNG, JPG, or WEBP format</p>
        </div>

        <div class="pdf-to-images-layout">
            <!-- Left Panel: Input -->
            <div class="pdf-to-images-panel">
                <h3><span class="icon">📤</span> Upload & Configure</h3>

                <div class="file-upload-area" id="fileDropArea">
                    <div class="upload-icon">📄</div>
                    <p class="primary-text">Click to upload or drag & drop PDF</p>
                    <p>Convert pages to images for presentations & sharing</p>
                    <input type="file" id="pdfFileInput" accept=".pdf,application/pdf" style="display: none;">
                </div>

                <div class="file-info" id="fileInfo">
                    <p><strong>File:</strong> <span id="fileName"></span></p>
                    <p><strong>Size:</strong> <span id="fileSize"></span></p>
                    <p><strong>Pages:</strong> <span id="pageCount"></span></p>
                </div>

                <div class="format-selection">
                    <label>Output Format</label>
                    <div class="format-options">
                        <label class="format-option selected" id="formatPNG">
                            <input type="radio" name="outputFormat" value="png" checked>
                            <span class="format-name">PNG</span>
                            <span class="format-desc">Best quality</span>
                        </label>
                        <label class="format-option" id="formatJPG">
                            <input type="radio" name="outputFormat" value="jpg">
                            <span class="format-name">JPG</span>
                            <span class="format-desc">Smaller size</span>
                        </label>
                        <label class="format-option" id="formatWEBP">
                            <input type="radio" name="outputFormat" value="webp">
                            <span class="format-name">WEBP</span>
                            <span class="format-desc">Modern</span>
                        </label>
                    </div>
                </div>

                <div class="settings-grid">
                    <div class="input-group-custom">
                        <label>Quality (1-100)</label>
                        <div class="range-with-value">
                            <input type="range" id="qualitySlider" min="1" max="100" value="92">
                            <span class="range-value" id="qualityValue">92</span>
                        </div>
                        <div class="input-hint">Higher = better quality, larger files</div>
                    </div>

                    <div class="input-group-custom">
                        <label>Scale (Resolution)</label>
                        <div class="range-with-value">
                            <input type="range" id="scaleSlider" min="1" max="3" step="0.5" value="2">
                            <span class="range-value" id="scaleValue">2.0</span>
                        </div>
                        <div class="input-hint">Higher = more detail, larger files</div>
                    </div>
                </div>

                <div class="input-group-custom">
                    <label>Page Selection</label>
                    <div class="page-selection-mode">
                        <button class="mode-btn active" id="modeAllPages">All Pages</button>
                        <button class="mode-btn" id="modeSelectPages">Select Pages</button>
                    </div>
                    <div class="page-selector" id="pageSelector"></div>
                </div>

                <div class="progress-bar" id="progressBar">
                    <div class="progress-fill" id="progressFill"></div>
                </div>
                <div class="progress-text" id="progressText">Converting page 0/0...</div>

                <button class="btn-convert" id="convertBtn" disabled>Convert to Images</button>
            </div>

            <!-- Right Panel: Output -->
            <div class="pdf-to-images-panel">
                <h3><span class="icon">📥</span> Converted Images</h3>

                <div class="status-message" id="statusMessage"></div>

                <!-- PDF Preview Section (shown after upload) -->
                <div id="pdfPreviewSection" style="display: none; margin-bottom: 0.75rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <label style="font-size: 0.85rem; font-weight: 500; color: #555; margin: 0;">PDF Preview</label>
                        <button id="togglePreviewBtn" style="padding: 0.4rem 0.8rem; background: #667eea; color: white; border: none; border-radius: 4px; font-size: 0.75rem; cursor: pointer;">Hide Preview</button>
                    </div>
                    <div class="pdf-preview" id="mainPdfPreview"></div>
                </div>

                <div class="placeholder-output" id="placeholderOutput">
                    <div class="placeholder-icon">🖼️</div>
                    <p>Upload a PDF to convert pages to images</p>
                    <p style="font-size: 0.85rem; margin-top: 0.5rem;">Supports PNG, JPG, and WEBP formats</p>
                </div>

                <div id="outputContainer" style="display: none;">
                    <div class="image-gallery" id="imageGallery"></div>
                    <button class="btn-download-all" id="downloadAllBtn">Download All Images</button>
                </div>
            </div>
        </div>

        <!-- About Section -->
        <div class="about-section">
            <h2>About PDF to Images Converter</h2>
            <p>This free online tool converts PDF pages into high-quality images in PNG, JPG, or WEBP format. Perfect for extracting diagrams, slides, or graphics from PDFs to use in presentations, documents, or websites. All conversion happens in your browser for complete privacy.</p>

            <h3 style="font-size: 1rem; margin-top: 1rem; margin-bottom: 0.5rem;">Format Guide:</h3>
            <ul>
                <li><strong>PNG:</strong> Best quality, supports transparency, lossless compression. Ideal for diagrams, text, and graphics requiring perfect clarity. Larger file sizes.</li>
                <li><strong>JPG:</strong> Good quality, smaller file sizes, lossy compression. Best for photos and images where slight quality loss is acceptable. Most compatible format.</li>
                <li><strong>WEBP:</strong> Modern format with excellent compression, good quality, smaller than PNG. Best for web usage, not all software supports it.</li>
            </ul>

            <h3 style="font-size: 1rem; margin-top: 1rem; margin-bottom: 0.5rem;">Settings Explained:</h3>
            <ul>
                <li><strong>Quality (1-100):</strong> Controls image compression. 90-100 = excellent quality, 70-89 = good quality, below 70 = smaller files but visible quality loss.</li>
                <li><strong>Scale (1.0-3.0):</strong> Controls resolution. 1.0 = 100 DPI (screen), 2.0 = 200 DPI (recommended), 3.0 = 300 DPI (print quality). Higher scale = larger images with more detail.</li>
            </ul>

            <h3 style="font-size: 1rem; margin-top: 1rem; margin-bottom: 0.5rem;">Features:</h3>
            <ul>
                <li><strong>Multiple Formats:</strong> Export as PNG, JPG, or WEBP</li>
                <li><strong>Custom Quality:</strong> Adjust quality and resolution for optimal results</li>
                <li><strong>Page Selection:</strong> Convert all pages or select specific ones</li>
                <li><strong>Batch Processing:</strong> Convert multiple pages at once</li>
                <li><strong>High Resolution:</strong> Up to 300 DPI for print-quality images</li>
                <li><strong>Preview Gallery:</strong> See all converted images before downloading</li>
                <li><strong>100% Client-Side:</strong> Files never uploaded, complete privacy</li>
                <li><strong>No Limits:</strong> Convert PDFs of any size</li>
            </ul>

            <h3 style="font-size: 1rem; margin-top: 1rem; margin-bottom: 0.5rem;">Common Use Cases:</h3>
            <ul>
                <li>Extract presentation slides for social media posts</li>
                <li>Convert diagrams and charts for documents</li>
                <li>Create image thumbnails from PDF pages</li>
                <li>Extract graphics for website usage</li>
                <li>Convert textbook pages to images for notes</li>
                <li>Generate preview images for PDF files</li>
            </ul>
        </div>

        <!-- Related Tools -->
        <div class="related-section">
            <h2>Related PDF Tools</h2>
            <div class="related-links">
                <a href="split-pdf.jsp" class="related-link">✂️ Split PDF</a>
                <a href="merge-pdf.jsp" class="related-link">📋 Merge PDF Files</a>
                <a href="compress-pdf.jsp" class="related-link">🗜️ Compress PDF</a>
                <a href="watermark-pdf.jsp" class="related-link">💧 Watermark PDF</a>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    <%@ include file="thanks.jsp"%>

    <!-- PDF.js Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

    <script>
        // Initialize PDF.js worker
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';

        var selectedFile = null;
        var pdfDocument = null;
        var totalPages = 0;
        var convertedImages = [];
        var selectedPages = new Set();

        // File upload handling
        var dropArea = document.getElementById('fileDropArea');
        var fileInput = document.getElementById('pdfFileInput');

        dropArea.addEventListener('click', function() {
            fileInput.click();
        });

        dropArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropArea.classList.add('drag-over');
        });

        dropArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropArea.classList.remove('drag-over');
        });

        dropArea.addEventListener('drop', function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropArea.classList.remove('drag-over');

            var files = e.dataTransfer.files;
            if (files.length > 0 && files[0].type === 'application/pdf') {
                handleFileSelect({ target: { files: files } });
            } else {
                showStatus('error', 'Please drop a valid PDF file');
            }
        });

        fileInput.addEventListener('change', handleFileSelect);

        async function handleFileSelect(event) {
            var file = event.target.files[0];
            if (!file) return;

            if (file.type !== 'application/pdf') {
                showStatus('error', 'Please select a valid PDF file');
                return;
            }

            selectedFile = file;

            // Update file info
            document.getElementById('fileName').textContent = file.name;
            document.getElementById('fileSize').textContent = formatFileSize(file.size);
            document.getElementById('fileInfo').classList.add('active');

            // Load PDF
            try {
                showStatus('info', 'Loading PDF...');
                var arrayBuffer = await file.arrayBuffer();
                pdfDocument = await pdfjsLib.getDocument({ data: arrayBuffer }).promise;
                totalPages = pdfDocument.numPages;

                document.getElementById('pageCount').textContent = totalPages;
                document.getElementById('convertBtn').disabled = false;

                // Show preview section
                document.getElementById('pdfPreviewSection').style.display = 'block';
                generatePdfPreview();

                generatePageSelector();
                showStatus('success', 'PDF loaded successfully! ' + totalPages + ' pages found.');

            } catch (error) {
                console.error('Error loading PDF:', error);
                showStatus('error', 'Failed to load PDF: ' + error.message);
            }
        }

        // Format selection
        document.querySelectorAll('.format-option').forEach(function(option) {
            option.addEventListener('click', function() {
                document.querySelectorAll('.format-option').forEach(function(opt) {
                    opt.classList.remove('selected');
                });
                this.classList.add('selected');
                this.querySelector('input[type="radio"]').checked = true;
            });
        });

        // Quality and scale sliders
        document.getElementById('qualitySlider').addEventListener('input', function(e) {
            document.getElementById('qualityValue').textContent = e.target.value;
        });

        document.getElementById('scaleSlider').addEventListener('input', function(e) {
            document.getElementById('scaleValue').textContent = parseFloat(e.target.value).toFixed(1);
        });

        // Page selection mode
        document.getElementById('modeAllPages').addEventListener('click', function() {
            document.getElementById('modeAllPages').classList.add('active');
            document.getElementById('modeSelectPages').classList.remove('active');
            document.getElementById('pageSelector').classList.remove('active');
        });

        document.getElementById('modeSelectPages').addEventListener('click', function() {
            document.getElementById('modeSelectPages').classList.add('active');
            document.getElementById('modeAllPages').classList.remove('active');
            document.getElementById('pageSelector').classList.add('active');
        });

        // Generate page selector
        function generatePageSelector() {
            var selector = document.getElementById('pageSelector');
            selector.innerHTML = '';
            selectedPages.clear();

            for (var i = 1; i <= totalPages; i++) {
                var item = document.createElement('div');
                item.className = 'page-selector-item';
                item.textContent = i;
                item.dataset.page = i;

                item.addEventListener('click', function() {
                    var pageNum = parseInt(this.dataset.page);
                    this.classList.toggle('selected');

                    if (this.classList.contains('selected')) {
                        selectedPages.add(pageNum);
                    } else {
                        selectedPages.delete(pageNum);
                    }
                });

                selector.appendChild(item);
            }
        }

        // Convert button
        document.getElementById('convertBtn').addEventListener('click', async function() {
            if (!pdfDocument) {
                showStatus('error', 'Please upload a PDF file first');
                return;
            }

            var mode = document.getElementById('modeAllPages').classList.contains('active') ? 'all' : 'selected';
            var pagesToConvert = [];

            if (mode === 'all') {
                for (var i = 1; i <= totalPages; i++) {
                    pagesToConvert.push(i);
                }
            } else {
                if (selectedPages.size === 0) {
                    showStatus('error', 'Please select at least one page to convert');
                    return;
                }
                pagesToConvert = Array.from(selectedPages).sort(function(a, b) { return a - b; });
            }

            try {
                await convertPages(pagesToConvert);
            } catch (error) {
                console.error('Error converting pages:', error);
                showStatus('error', 'Failed to convert pages: ' + error.message);
            }
        });

        async function convertPages(pageNumbers) {
            convertedImages = [];
            document.getElementById('imageGallery').innerHTML = '';
            document.getElementById('outputContainer').style.display = 'none';
            document.getElementById('placeholderOutput').style.display = 'none';

            var format = document.querySelector('input[name="outputFormat"]:checked').value;
            var quality = parseInt(document.getElementById('qualitySlider').value) / 100;
            var scale = parseFloat(document.getElementById('scaleSlider').value);

            showStatus('info', 'Converting ' + pageNumbers.length + ' page(s) to ' + format.toUpperCase() + '...');
            document.getElementById('progressBar').classList.add('active');
            document.getElementById('progressText').classList.add('active');

            for (var i = 0; i < pageNumbers.length; i++) {
                var pageNum = pageNumbers[i];
                var progress = ((i + 1) / pageNumbers.length) * 100;

                document.getElementById('progressFill').style.width = progress + '%';
                document.getElementById('progressText').textContent = 'Converting page ' + (i + 1) + '/' + pageNumbers.length + '...';

                var page = await pdfDocument.getPage(pageNum);
                var viewport = page.getViewport({ scale: scale });

                var canvas = document.createElement('canvas');
                canvas.width = viewport.width;
                canvas.height = viewport.height;

                var context = canvas.getContext('2d');
                await page.render({ canvasContext: context, viewport: viewport }).promise;

                var mimeType = format === 'png' ? 'image/png' : (format === 'jpg' ? 'image/jpeg' : 'image/webp');
                var imageData = canvas.toDataURL(mimeType, quality);
                var blob = await dataURLToBlob(imageData);

                var fileName = selectedFile.name.replace('.pdf', '') + '_page_' + pageNum + '.' + format;

                convertedImages.push({
                    blob: blob,
                    fileName: fileName,
                    pageNum: pageNum,
                    dataURL: imageData,
                    size: blob.size
                });

                displayImage(convertedImages[convertedImages.length - 1]);
            }

            document.getElementById('progressBar').classList.remove('active');
            document.getElementById('progressText').classList.remove('active');
            document.getElementById('progressFill').style.width = '0%';

            document.getElementById('outputContainer').style.display = 'block';
            document.getElementById('downloadAllBtn').classList.add('active');

            showStatus('success', 'Successfully converted ' + pageNumbers.length + ' page(s) to ' + format.toUpperCase() + '!');
        }

        function displayImage(imageData) {
            var gallery = document.getElementById('imageGallery');

            var item = document.createElement('div');
            item.className = 'image-item';

            var img = document.createElement('img');
            img.className = 'image-preview';
            img.src = imageData.dataURL;

            var info = document.createElement('div');
            info.className = 'image-info';

            var name = document.createElement('div');
            name.className = 'image-name';
            name.textContent = imageData.fileName;
            name.title = imageData.fileName;

            var size = document.createElement('div');
            size.className = 'image-size';
            size.textContent = 'Page ' + imageData.pageNum + ' • ' + formatFileSize(imageData.size);

            var downloadBtn = document.createElement('button');
            downloadBtn.className = 'btn-download-image';
            downloadBtn.textContent = 'Download';
            downloadBtn.addEventListener('click', function() {
                downloadFile(imageData.blob, imageData.fileName);
            });

            info.appendChild(name);
            info.appendChild(size);
            info.appendChild(downloadBtn);

            item.appendChild(img);
            item.appendChild(info);
            gallery.appendChild(item);
        }

        // Download all images as ZIP
        document.getElementById('downloadAllBtn').addEventListener('click', async function() {
            if (convertedImages.length === 0) return;

            showStatus('info', 'Creating ZIP file...');

            var zip = new JSZip();

            convertedImages.forEach(function(image) {
                zip.file(image.fileName, image.blob);
            });

            var zipBlob = await zip.generateAsync({ type: 'blob' });
            var zipFileName = selectedFile.name.replace('.pdf', '') + '_images.zip';

            downloadFile(zipBlob, zipFileName);
            showStatus('success', 'ZIP file created and downloaded!');
        });

        // Helper functions
        async function dataURLToBlob(dataURL) {
            var response = await fetch(dataURL);
            return await response.blob();
        }

        function downloadFile(blob, fileName) {
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = fileName;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            var k = 1024;
            var sizes = ['Bytes', 'KB', 'MB', 'GB'];
            var i = Math.floor(Math.log(bytes) / Math.log(k));
            return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
        }

        function showStatus(type, message) {
            var statusDiv = document.getElementById('statusMessage');
            statusDiv.className = 'status-message ' + type + ' active';
            statusDiv.textContent = message;

            if (type === 'success') {
                setTimeout(function() {
                    statusDiv.classList.remove('active');
                }, 5000);
            }
        }

        // Generate PDF preview
        async function generatePdfPreview() {
            var previewContainer = document.getElementById('mainPdfPreview');
            previewContainer.innerHTML = '<div class="preview-loading"><span class="spinner"></span>Generating previews...</div>';

            if (!pdfDocument) {
                previewContainer.innerHTML = '<div class="preview-loading">Unable to generate previews</div>';
                return;
            }

            previewContainer.innerHTML = '';

            // Render thumbnails for each page
            for (var i = 1; i <= totalPages; i++) {
                var pageItem = document.createElement('div');
                pageItem.className = 'pdf-preview-item';

                // Create thumbnail canvas
                var canvas = document.createElement('canvas');
                canvas.className = 'preview-thumbnail';

                // Create page number label
                var pageLabel = document.createElement('div');
                pageLabel.className = 'preview-page-number';
                pageLabel.textContent = 'Page ' + i;

                pageItem.appendChild(canvas);
                pageItem.appendChild(pageLabel);

                previewContainer.appendChild(pageItem);

                // Render thumbnail asynchronously
                renderPreviewThumbnail(i, canvas);
            }
        }

        // Render thumbnail for a specific page
        async function renderPreviewThumbnail(pageNum, canvas) {
            try {
                var page = await pdfDocument.getPage(pageNum);
                var viewport = page.getViewport({ scale: 0.5 }); // Small scale for thumbnail

                // Set canvas size
                canvas.width = viewport.width;
                canvas.height = viewport.height;

                var context = canvas.getContext('2d');

                // Render page
                await page.render({
                    canvasContext: context,
                    viewport: viewport
                }).promise;

            } catch (error) {
                console.error('Error rendering preview thumbnail for page ' + pageNum + ':', error);
            }
        }

        // Toggle preview visibility
        var previewVisible = true;
        document.getElementById('togglePreviewBtn').addEventListener('click', function() {
            previewVisible = !previewVisible;
            var previewContainer = document.getElementById('mainPdfPreview');

            if (previewVisible) {
                previewContainer.style.display = 'grid';
                this.textContent = 'Hide Preview';
            } else {
                previewContainer.style.display = 'none';
                this.textContent = 'Show Preview';
            }
        });
    </script>
</div>
    <%@ include file="body-close.jsp"%>
