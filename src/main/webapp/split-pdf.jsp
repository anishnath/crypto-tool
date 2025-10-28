<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Split PDF - Extract Pages from PDF Files Online | Free PDF Splitter Tool</title>
    <meta name="description" content="Free online PDF splitter tool. Split PDF by page ranges, extract specific pages, split every N pages, or separate odd/even pages. No upload required - 100% client-side processing.">
    <meta name="keywords" content="split pdf, pdf splitter, extract pdf pages, divide pdf, separate pdf pages, split pdf online, pdf page extractor, free pdf split">

    <!-- Open Graph / Social Media -->
    <meta property="og:title" content="Split PDF - Extract Pages from PDF Files Online">
    <meta property="og:description" content="Split PDF files by page ranges or extract specific pages. Free, secure, client-side processing.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/split-pdf.jsp">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context" : "https://schema.org",
      "@type" : "SoftwareApplication",
      "name" : "Split PDF - PDF Page Extractor Tool",
      "url" : "https://8gwifi.org/split-pdf.jsp",
      "applicationCategory" : "UtilityApplication",
      "operatingSystem" : "Any",
      "description" : "Free online tool to split PDF files by page ranges, extract specific pages, or split every N pages with client-side processing.",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList" : [
        "Split PDF by custom page ranges (e.g., 1-5, 10-15)",
        "Extract specific pages from PDF documents",
        "Split every N pages automatically",
        "Extract odd or even pages only",
        "100% client-side processing - files never uploaded",
        "No file size limits",
        "Instant PDF splitting",
        "Multiple output files",
        "Preserve PDF quality and formatting",
        "Privacy-focused - no data collection",
        "Free unlimited usage",
        "Works offline after loading"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "ratingCount": "467"
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
        "name": "Split PDF",
        "item": "https://8gwifi.org/split-pdf.jsp"
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Split a PDF File",
      "description": "Learn how to split PDF files and extract specific pages using our free online tool",
      "step": [{
        "@type": "HowToStep",
        "position": 1,
        "name": "Upload PDF",
        "text": "Click 'Choose PDF File' or drag and drop your PDF document"
      },{
        "@type": "HowToStep",
        "position": 2,
        "name": "Select Split Method",
        "text": "Choose from page ranges, every N pages, odd/even pages, or custom selection"
      },{
        "@type": "HowToStep",
        "position": 3,
        "name": "Configure Pages",
        "text": "Enter page numbers or ranges (e.g., 1-5, 10, 15-20)"
      },{
        "@type": "HowToStep",
        "position": 4,
        "name": "Split PDF",
        "text": "Click 'Split PDF' to process and generate separate files"
      },{
        "@type": "HowToStep",
        "position": 5,
        "name": "Download",
        "text": "Download individual split PDF files or all at once"
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "Is this PDF splitter free to use?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Yes, this tool is completely free with unlimited usage. No registration or payment required."
        }
      },{
        "@type": "Question",
        "name": "Are my PDF files uploaded to a server?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "No, all PDF splitting happens in your browser using client-side JavaScript. Your files never leave your device."
        }
      },{
        "@type": "Question",
        "name": "What is the maximum file size I can split?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "There is no fixed limit. The tool can handle files as large as your browser's memory allows, typically several hundred megabytes."
        }
      },{
        "@type": "Question",
        "name": "Can I split password-protected PDFs?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "No, encrypted or password-protected PDFs cannot be split. You must remove the password first."
        }
      },{
        "@type": "Question",
        "name": "How do I specify page ranges?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Use comma-separated values and hyphens for ranges. Example: '1-5,10,15-20' will extract pages 1 through 5, page 10, and pages 15 through 20."
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

        .split-pdf-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .split-pdf-header {
            text-align: center;
            color: white;
            margin-bottom: 1.5rem;
        }

        .split-pdf-header h1 {
            font-size: 2rem;
            margin: 0 0 0.5rem 0;
            font-weight: 600;
        }

        .split-pdf-header p {
            font-size: 1rem;
            margin: 0;
            opacity: 0.95;
        }

        .split-pdf-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 968px) {
            .split-pdf-layout {
                grid-template-columns: 1fr;
            }
        }

        .split-pdf-panel {
            background: white;
            border-radius: 12px;
            padding: 1rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }

        .split-pdf-panel h3 {
            margin: 0 0 0.75rem 0;
            font-size: 1rem;
            color: #333;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .split-pdf-panel h3 .icon {
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

        .split-method-group {
            margin-bottom: 0.75rem;
        }

        .split-method-group label {
            display: block;
            margin-bottom: 0.3rem;
            color: #555;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .method-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
        }

        .method-option {
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            padding: 0.6rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
        }

        .method-option:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .method-option.selected {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .method-option input[type="radio"] {
            display: none;
        }

        .method-option .method-name {
            font-weight: 500;
            font-size: 0.9rem;
            display: block;
        }

        .method-option .method-desc {
            font-size: 0.75rem;
            opacity: 0.8;
            margin-top: 0.2rem;
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

        .input-group-custom input[type="text"],
        .input-group-custom input[type="number"] {
            width: 100%;
            padding: 0.6rem;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: border-color 0.2s ease;
            box-sizing: border-box;
        }

        .input-group-custom input:focus {
            outline: none;
            border-color: #667eea;
        }

        .input-hint {
            font-size: 0.75rem;
            color: #999;
            margin-top: 0.25rem;
        }

        .btn-split {
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

        .btn-split:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-split:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .output-files {
            max-height: 500px;
            overflow-y: auto;
        }

        .output-file-item {
            background: #f8f9fa;
            padding: 0.75rem;
            border-radius: 6px;
            margin-bottom: 0.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .file-item-info {
            flex: 1;
        }

        .file-item-info .file-name {
            font-weight: 500;
            color: #333;
            font-size: 0.9rem;
            margin-bottom: 0.2rem;
        }

        .file-item-info .file-details {
            font-size: 0.75rem;
            color: #999;
        }

        .btn-download {
            padding: 0.5rem 1rem;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.85rem;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .btn-download:hover {
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

        .page-preview {
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

        .page-preview-item {
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            padding: 0.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            background: white;
            position: relative;
        }

        .page-preview-item:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
        }

        .page-preview-item.selected {
            border-color: #667eea;
            background: #f0f2ff;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
        }

        .page-preview-item input[type="checkbox"] {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            width: 18px;
            height: 18px;
            cursor: pointer;
            z-index: 10;
        }

        .page-preview-item .page-thumbnail {
            width: 100%;
            height: 140px;
            object-fit: contain;
            background: white;
            border-radius: 4px;
            margin-bottom: 0.5rem;
            border: 1px solid #e0e0e0;
        }

        .page-preview-item .page-number {
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

        .progress-bar {
            width: 100%;
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
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
    </style>
</head>
<%@ include file="body-script.jsp"%>

    <div class="split-pdf-container">
        <div class="split-pdf-header">
            <h1>📄 Split PDF - Extract Pages from PDF Files</h1>
            <p>Split PDF by page ranges, extract specific pages, or split every N pages - All processing done in your browser</p>
        </div>

        <div class="split-pdf-layout">
            <!-- Left Panel: Input -->
            <div class="split-pdf-panel">
                <h3><span class="icon">📤</span> Upload & Configure</h3>

                <div class="file-upload-area" id="fileDropArea">
                    <div class="upload-icon">📄</div>
                    <p class="primary-text">Click to upload or drag & drop PDF</p>
                    <p>Maximum file size: Based on your browser memory</p>
                    <input type="file" id="pdfFileInput" accept=".pdf,application/pdf" style="display: none;">
                </div>

                <div class="file-info" id="fileInfo">
                    <p><strong>File:</strong> <span id="fileName"></span></p>
                    <p><strong>Size:</strong> <span id="fileSize"></span></p>
                    <p><strong>Pages:</strong> <span id="pageCount"></span></p>
                </div>

                <div class="split-method-group">
                    <label>Split Method</label>
                    <div class="method-options">
                        <label class="method-option selected" id="methodRanges">
                            <input type="radio" name="splitMethod" value="ranges" checked>
                            <span class="method-name">Page Ranges</span>
                            <span class="method-desc">e.g., 1-5, 10-15</span>
                        </label>
                        <label class="method-option" id="methodEveryN">
                            <input type="radio" name="splitMethod" value="everyN">
                            <span class="method-name">Every N Pages</span>
                            <span class="method-desc">Split at intervals</span>
                        </label>
                        <label class="method-option" id="methodOddEven">
                            <input type="radio" name="splitMethod" value="oddEven">
                            <span class="method-name">Odd/Even</span>
                            <span class="method-desc">Separate pages</span>
                        </label>
                        <label class="method-option" id="methodCustom">
                            <input type="radio" name="splitMethod" value="custom">
                            <span class="method-name">Custom Select</span>
                            <span class="method-desc">Pick manually</span>
                        </label>
                    </div>
                </div>

                <div class="input-group-custom" id="rangesInput">
                    <label>Page Ranges (e.g., 1-5, 10, 15-20)</label>
                    <input type="text" id="pageRanges" placeholder="1-5, 10, 15-20">
                    <div class="input-hint">Use commas to separate ranges, hyphens for sequences</div>
                </div>

                <div class="input-group-custom" id="everyNInput" style="display: none;">
                    <label>Split Every N Pages</label>
                    <input type="number" id="everyNPages" min="1" value="10" placeholder="10">
                    <div class="input-hint">Each output file will contain N pages</div>
                </div>

                <div class="input-group-custom" id="oddEvenInput" style="display: none;">
                    <label>Select Pages</label>
                    <select id="oddEvenSelect" style="width: 100%; padding: 0.6rem; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 0.9rem;">
                        <option value="odd">Odd Pages (1, 3, 5, ...)</option>
                        <option value="even">Even Pages (2, 4, 6, ...)</option>
                        <option value="both">Both (Separate Files)</option>
                    </select>
                </div>

                <div id="customSelectPreview" style="display: none;">
                    <label style="display: block; margin-bottom: 0.5rem; color: #555; font-size: 0.85rem; font-weight: 500;">Select Pages to Extract</label>
                    <div class="page-preview" id="pagePreview"></div>
                </div>

                <div class="progress-bar" id="progressBar">
                    <div class="progress-fill" id="progressFill"></div>
                </div>

                <button class="btn-split" id="splitBtn" disabled>Split PDF</button>
            </div>

            <!-- Right Panel: Output -->
            <div class="split-pdf-panel">
                <h3><span class="icon">📥</span> Split Results</h3>

                <div class="status-message" id="statusMessage"></div>

                <!-- PDF Preview Section (shown after upload) -->
                <div id="pdfPreviewSection" style="display: none; margin-bottom: 0.75rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <label style="font-size: 0.85rem; font-weight: 500; color: #555; margin: 0;">PDF Preview</label>
                        <button id="togglePreviewBtn" style="padding: 0.4rem 0.8rem; background: #667eea; color: white; border: none; border-radius: 4px; font-size: 0.75rem; cursor: pointer;">Hide Preview</button>
                    </div>
                    <div class="page-preview" id="mainPagePreview"></div>
                </div>

                <div class="output-files" id="outputFiles">
                    <div style="text-align: center; padding: 2rem; color: #999;">
                        <div style="font-size: 3rem; margin-bottom: 0.5rem;">📄</div>
                        <p style="margin: 0;">Upload a PDF and configure split options to begin</p>
                    </div>
                </div>

                <button class="btn-download-all" id="downloadAllBtn">Download All Files</button>
            </div>
        </div>

        <!-- About Section -->
        <div class="about-section">
            <h2>About PDF Split Tool</h2>
            <p>This free online PDF splitter allows you to extract pages from PDF documents in multiple ways. Whether you need to split by page ranges, extract specific pages, or divide a large PDF into smaller files, this tool handles it all with client-side processing for maximum privacy and speed.</p>

            <h3 style="font-size: 1rem; margin-top: 1rem; margin-bottom: 0.5rem;">Features:</h3>
            <ul>
                <li><strong>Page Ranges:</strong> Extract specific page ranges like "1-5, 10-15, 20"</li>
                <li><strong>Every N Pages:</strong> Automatically split every N pages into separate files</li>
                <li><strong>Odd/Even Pages:</strong> Separate odd and even pages for duplex scanning</li>
                <li><strong>Custom Selection:</strong> Manually select which pages to extract with visual preview</li>
                <li><strong>100% Client-Side:</strong> All processing happens in your browser - files never uploaded</li>
                <li><strong>No Limits:</strong> Split PDFs of any size your browser can handle</li>
                <li><strong>Preserve Quality:</strong> Original PDF quality maintained in split files</li>
                <li><strong>Multiple Outputs:</strong> Generate multiple split PDF files at once</li>
            </ul>

            <h3 style="font-size: 1rem; margin-top: 1rem; margin-bottom: 0.5rem;">Common Use Cases:</h3>
            <ul>
                <li>Extract specific chapters from a large document</li>
                <li>Separate scanned documents that were accidentally combined</li>
                <li>Extract odd/even pages from duplex scanning errors</li>
                <li>Split large PDFs for easier sharing via email</li>
                <li>Organize document sections into separate files</li>
            </ul>
        </div>

        <!-- Related Tools -->
        <div class="related-section">
            <h2>Related PDF Tools</h2>
            <div class="related-links">
                <a href="merge-pdf.jsp" class="related-link">📋 Merge PDF Files</a>
                <a href="compress-pdf.jsp" class="related-link">🗜️ Compress PDF</a>
                <a href="pdf-to-images.jsp" class="related-link">🖼️ PDF to Images</a>
                <a href="watermark-pdf.jsp" class="related-link">💧 Watermark PDF</a>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    <%@ include file="thanks.jsp"%>

    <!-- PDF.js Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
    <script src="https://unpkg.com/pdf-lib@1.17.1/dist/pdf-lib.min.js"></script>

    <script>
        // Initialize PDF.js worker
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';

        var selectedFile = null;
        var pdfDoc = null; // pdf-lib document for splitting
        var pdfJsDoc = null; // pdf.js document for rendering previews
        var totalPages = 0;
        var splitResults = [];

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

            // Load PDF to get page count
            try {
                showStatus('info', 'Loading PDF...');
                var arrayBuffer = await file.arrayBuffer();

                // Load with pdf-lib for splitting
                pdfDoc = await PDFLib.PDFDocument.load(arrayBuffer);
                totalPages = pdfDoc.getPageCount();

                // Load with pdf.js for rendering thumbnails
                pdfJsDoc = await pdfjsLib.getDocument({ data: arrayBuffer }).promise;

                document.getElementById('pageCount').textContent = totalPages;
                document.getElementById('splitBtn').disabled = false;

                showStatus('success', 'PDF loaded successfully! ' + totalPages + ' pages found.');

                // Show preview section in right panel
                document.getElementById('pdfPreviewSection').style.display = 'block';
                generateMainPreview();

                // If custom method is selected, also generate preview in custom selector
                if (document.querySelector('input[name="splitMethod"]:checked').value === 'custom') {
                    generatePagePreview();
                }
            } catch (error) {
                console.error('Error loading PDF:', error);
                showStatus('error', 'Failed to load PDF: ' + error.message);
            }
        }

        // Split method selection
        document.querySelectorAll('.method-option').forEach(function(option) {
            option.addEventListener('click', function() {
                document.querySelectorAll('.method-option').forEach(function(opt) {
                    opt.classList.remove('selected');
                });
                this.classList.add('selected');
                this.querySelector('input[type="radio"]').checked = true;

                var method = this.querySelector('input[type="radio"]').value;

                // Hide all input groups
                document.getElementById('rangesInput').style.display = 'none';
                document.getElementById('everyNInput').style.display = 'none';
                document.getElementById('oddEvenInput').style.display = 'none';
                document.getElementById('customSelectPreview').style.display = 'none';

                // Show relevant input group
                if (method === 'ranges') {
                    document.getElementById('rangesInput').style.display = 'block';
                } else if (method === 'everyN') {
                    document.getElementById('everyNInput').style.display = 'block';
                } else if (method === 'oddEven') {
                    document.getElementById('oddEvenInput').style.display = 'block';
                } else if (method === 'custom') {
                    document.getElementById('customSelectPreview').style.display = 'block';
                    if (selectedFile && totalPages > 0) {
                        generatePagePreview();
                    }
                }
            });
        });

        // Generate page preview for custom selection
        async function generatePagePreview() {
            var previewContainer = document.getElementById('pagePreview');
            previewContainer.innerHTML = '<div class="preview-loading"><span class="spinner"></span>Generating previews...</div>';

            if (!pdfJsDoc) {
                previewContainer.innerHTML = '<div class="preview-loading">Unable to generate previews</div>';
                return;
            }

            previewContainer.innerHTML = '';

            // Render thumbnails for each page
            for (var i = 1; i <= totalPages; i++) {
                var pageItem = document.createElement('div');
                pageItem.className = 'page-preview-item';
                pageItem.dataset.pageNum = i;

                // Create checkbox
                var checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.id = 'page' + i;
                checkbox.value = i;

                // Create thumbnail canvas
                var canvas = document.createElement('canvas');
                canvas.className = 'page-thumbnail';

                // Create page number label
                var pageLabel = document.createElement('div');
                pageLabel.className = 'page-number';
                pageLabel.textContent = 'Page ' + i;

                pageItem.appendChild(checkbox);
                pageItem.appendChild(canvas);
                pageItem.appendChild(pageLabel);

                // Click handler for the entire item
                pageItem.addEventListener('click', function(e) {
                    if (e.target.tagName !== 'INPUT') {
                        var cb = this.querySelector('input[type="checkbox"]');
                        cb.checked = !cb.checked;
                    }
                    this.classList.toggle('selected', this.querySelector('input[type="checkbox"]').checked);
                });

                // Checkbox handler
                checkbox.addEventListener('change', function(e) {
                    this.closest('.page-preview-item').classList.toggle('selected', this.checked);
                });

                previewContainer.appendChild(pageItem);

                // Render thumbnail asynchronously
                renderThumbnail(i, canvas);
            }
        }

        // Render thumbnail for a specific page
        async function renderThumbnail(pageNum, canvas) {
            try {
                var page = await pdfJsDoc.getPage(pageNum);
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
                console.error('Error rendering thumbnail for page ' + pageNum + ':', error);
            }
        }

        // Split PDF button
        document.getElementById('splitBtn').addEventListener('click', async function() {
            if (!pdfDoc) {
                showStatus('error', 'Please upload a PDF file first');
                return;
            }

            var method = document.querySelector('input[name="splitMethod"]:checked').value;
            var pageGroups = [];

            try {
                if (method === 'ranges') {
                    pageGroups = parsePageRanges(document.getElementById('pageRanges').value);
                } else if (method === 'everyN') {
                    var n = parseInt(document.getElementById('everyNPages').value);
                    pageGroups = splitEveryN(n);
                } else if (method === 'oddEven') {
                    var oddEven = document.getElementById('oddEvenSelect').value;
                    pageGroups = splitOddEven(oddEven);
                } else if (method === 'custom') {
                    pageGroups = getCustomSelectedPages();
                }

                if (pageGroups.length === 0) {
                    showStatus('error', 'No pages selected or invalid configuration');
                    return;
                }

                await performSplit(pageGroups);

            } catch (error) {
                console.error('Error splitting PDF:', error);
                showStatus('error', 'Failed to split PDF: ' + error.message);
            }
        });

        // Parse page ranges (e.g., "1-5, 10, 15-20")
        function parsePageRanges(rangesStr) {
            var groups = [];
            var parts = rangesStr.split(',');

            parts.forEach(function(part) {
                part = part.trim();
                if (part.includes('-')) {
                    var range = part.split('-');
                    var start = parseInt(range[0]);
                    var end = parseInt(range[1]);
                    if (start > 0 && end <= totalPages && start <= end) {
                        var pages = [];
                        for (var i = start; i <= end; i++) {
                            pages.push(i);
                        }
                        groups.push(pages);
                    }
                } else {
                    var pageNum = parseInt(part);
                    if (pageNum > 0 && pageNum <= totalPages) {
                        groups.push([pageNum]);
                    }
                }
            });

            return groups;
        }

        // Split every N pages
        function splitEveryN(n) {
            var groups = [];
            for (var i = 1; i <= totalPages; i += n) {
                var pages = [];
                for (var j = i; j < i + n && j <= totalPages; j++) {
                    pages.push(j);
                }
                groups.push(pages);
            }
            return groups;
        }

        // Split odd/even pages
        function splitOddEven(type) {
            var oddPages = [];
            var evenPages = [];

            for (var i = 1; i <= totalPages; i++) {
                if (i % 2 === 1) {
                    oddPages.push(i);
                } else {
                    evenPages.push(i);
                }
            }

            if (type === 'odd') {
                return [oddPages];
            } else if (type === 'even') {
                return [evenPages];
            } else {
                return [oddPages, evenPages];
            }
        }

        // Get custom selected pages
        function getCustomSelectedPages() {
            var selectedPages = [];
            document.querySelectorAll('#pagePreview input[type="checkbox"]:checked').forEach(function(checkbox) {
                selectedPages.push(parseInt(checkbox.value));
            });

            if (selectedPages.length > 0) {
                return [selectedPages.sort(function(a, b) { return a - b; })];
            }
            return [];
        }

        // Perform the actual split
        async function performSplit(pageGroups) {
            splitResults = [];
            document.getElementById('outputFiles').innerHTML = '';
            showStatus('info', 'Splitting PDF into ' + pageGroups.length + ' file(s)...');

            var progressBar = document.getElementById('progressBar');
            var progressFill = document.getElementById('progressFill');
            progressBar.classList.add('active');

            for (var i = 0; i < pageGroups.length; i++) {
                var pages = pageGroups[i];
                var newPdf = await PDFLib.PDFDocument.create();

                // Copy pages (indices are 0-based, but our page numbers are 1-based)
                var copiedPages = await newPdf.copyPages(pdfDoc, pages.map(function(p) { return p - 1; }));
                copiedPages.forEach(function(page) {
                    newPdf.addPage(page);
                });

                var pdfBytes = await newPdf.save();
                var blob = new Blob([pdfBytes], { type: 'application/pdf' });

                var fileName = selectedFile.name.replace('.pdf', '') + '_pages_' + pages[0];
                if (pages.length > 1) {
                    fileName += '-' + pages[pages.length - 1];
                }
                fileName += '.pdf';

                splitResults.push({
                    blob: blob,
                    fileName: fileName,
                    pages: pages,
                    size: blob.size
                });

                // Update progress
                var progress = ((i + 1) / pageGroups.length) * 100;
                progressFill.style.width = progress + '%';

                // Add to output display
                addOutputFileItem(splitResults[splitResults.length - 1], i);
            }

            progressBar.classList.remove('active');
            progressFill.style.width = '0%';

            showStatus('success', 'Successfully split PDF into ' + pageGroups.length + ' file(s)!');
            document.getElementById('downloadAllBtn').classList.add('active');
        }

        // Add output file item to display
        function addOutputFileItem(fileData, index) {
            var container = document.getElementById('outputFiles');

            var item = document.createElement('div');
            item.className = 'output-file-item';

            var info = document.createElement('div');
            info.className = 'file-item-info';

            var name = document.createElement('div');
            name.className = 'file-name';
            name.textContent = fileData.fileName;

            var details = document.createElement('div');
            details.className = 'file-details';
            var pageText = fileData.pages.length === 1 ? '1 page' : fileData.pages.length + ' pages';
            details.textContent = pageText + ' • ' + formatFileSize(fileData.size);

            info.appendChild(name);
            info.appendChild(details);

            var downloadBtn = document.createElement('button');
            downloadBtn.className = 'btn-download';
            downloadBtn.textContent = 'Download';
            downloadBtn.addEventListener('click', function() {
                downloadFile(fileData.blob, fileData.fileName);
            });

            item.appendChild(info);
            item.appendChild(downloadBtn);
            container.appendChild(item);
        }

        // Download all files
        document.getElementById('downloadAllBtn').addEventListener('click', function() {
            splitResults.forEach(function(fileData) {
                downloadFile(fileData.blob, fileData.fileName);
            });
        });

        // Download file helper
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

        // Format file size
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            var k = 1024;
            var sizes = ['Bytes', 'KB', 'MB', 'GB'];
            var i = Math.floor(Math.log(bytes) / Math.log(k));
            return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
        }

        // Show status message
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

        // Generate main preview (in right panel)
        async function generateMainPreview() {
            var previewContainer = document.getElementById('mainPagePreview');
            previewContainer.innerHTML = '<div class="preview-loading"><span class="spinner"></span>Generating previews...</div>';

            if (!pdfJsDoc) {
                previewContainer.innerHTML = '<div class="preview-loading">Unable to generate previews</div>';
                return;
            }

            previewContainer.innerHTML = '';

            // Render thumbnails for each page (non-interactive, just visual)
            for (var i = 1; i <= totalPages; i++) {
                var pageItem = document.createElement('div');
                pageItem.className = 'page-preview-item';
                pageItem.style.cursor = 'default';

                // Create thumbnail canvas
                var canvas = document.createElement('canvas');
                canvas.className = 'page-thumbnail';

                // Create page number label
                var pageLabel = document.createElement('div');
                pageLabel.className = 'page-number';
                pageLabel.textContent = 'Page ' + i;

                pageItem.appendChild(canvas);
                pageItem.appendChild(pageLabel);

                previewContainer.appendChild(pageItem);

                // Render thumbnail asynchronously
                renderThumbnail(i, canvas);
            }
        }

        // Toggle preview visibility
        var previewVisible = true;
        document.getElementById('togglePreviewBtn').addEventListener('click', function() {
            previewVisible = !previewVisible;
            var previewContainer = document.getElementById('mainPagePreview');

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
