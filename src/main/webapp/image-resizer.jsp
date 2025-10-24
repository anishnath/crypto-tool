<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Free Image Resizer Online - Resize Images in Pixels or Percentage | 8gwifi.org</title>
  <meta name="description" content="Resize images online for free. Batch resize up to 10 images at once with pixel or percentage control. Maintain aspect ratio, preview instantly, and download in original format. Perfect for social media, blogs, and websites.">
  <meta name="keywords" content="resize image, image resizer online, resize image pixels, resize image percentage, batch image resizer, free image resizer, photo resizer, picture resizer, compress image size, social media image resizer, bulk image resize, aspect ratio lock">
  <meta name="author" content="8gwifi.org">
  <link rel="canonical" href="https://8gwifi.org/image-resizer.jsp">

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/image-resizer.jsp">
  <meta property="og:title" content="Free Image Resizer Online - Resize Images in Pixels or Percentage">
  <meta property="og:description" content="Resize images online for free. Batch resize up to 10 images with pixel or percentage control. Instant preview and download.">
  <meta property="og:image" content="https://8gwifi.org/images/site/image-resizer-tool.png">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/image-resizer.jsp">
  <meta property="twitter:title" content="Free Image Resizer Online - Resize Images in Pixels or Percentage">
  <meta property="twitter:description" content="Resize images online for free. Batch resize up to 10 images with pixel or percentage control.">
  <meta property="twitter:image" content="https://8gwifi.org/images/site/image-resizer-tool.png">

  <!-- JSON-LD Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Image Resizer Online",
    "applicationCategory": "MultimediaApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online image resizer tool. Resize images by pixels or percentage, batch process up to 10 files, maintain aspect ratio, and download in original format. Perfect for social media, blogs, and websites.",
    "url": "https://8gwifi.org/image-resizer.jsp",
    "author": {
      "@type": "Organization",
      "name": "8gwifi.org"
    },
    "featureList": [
      "Resize by pixels or percentage",
      "Batch resize up to 10 images",
      "Aspect ratio lock/unlock",
      "Instant preview",
      "Maintain image quality",
      "Download in original format (JPG, PNG, WEBP)",
      "No file upload to server - 100% client-side",
      "Support for JPG, PNG, WEBP, GIF formats"
    ],
    "screenshot": "https://8gwifi.org/images/site/image-resizer-tool.png",
    "softwareVersion": "1.0",
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "3420",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <style>
    body { background: #f7f7fb; }

    /* Compact Header */
    .app-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 1rem 0;
      border-bottom: none;
    }
    .app-header h1 {
      color: white;
      font-size: 1.5rem;
      margin-bottom: 0.25rem;
    }
    .app-header p {
      color: rgba(255,255,255,0.9);
      font-size: 0.9rem;
      margin-bottom: 0;
    }

    /* Compact Upload Area */
    .upload-area {
      border: 2px dashed #007bff;
      border-radius: 8px;
      padding: 1rem;
      text-align: center;
      background: #f8f9fa;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    .upload-area svg { width: 40px; height: 40px; margin-bottom: 0.5rem; }
    .upload-area h5 { font-size: 1rem; margin-bottom: 0.5rem; }
    .upload-area p { font-size: 0.8rem; margin-bottom: 0.5rem; }
    .upload-area:hover { background: #e9ecef; border-color: #0056b3; }
    .upload-area.dragover { background: #d4e9ff; border-color: #0056b3; }

    /* Compact Presets */
    .presets-section {
      background: white;
      padding: 1rem;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 1rem;
    }
    .presets-section h6 {
      font-size: 0.9rem;
      margin-bottom: 0.75rem;
      font-weight: 700;
    }
    .preset-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
      gap: 0.5rem;
    }
    .preset-btn {
      padding: 0.5rem;
      border: 2px solid #e9ecef;
      background: white;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s;
      text-align: left;
      font-size: 0.8rem;
    }
    .preset-btn:hover {
      border-color: #007bff;
      background: #f8f9fa;
      transform: translateY(-1px);
    }
    .preset-btn strong { display: block; color: #007bff; font-size: 0.85rem; }
    .preset-btn small { color: #6c757d; font-size: 0.7rem; }

    /* Compact Batch Actions */
    .batch-actions {
      background: white;
      padding: 0.75rem;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 1rem;
    }
    .batch-actions h6 { font-size: 0.9rem; margin-bottom: 0.5rem; font-weight: 700; }
    .batch-actions .row { font-size: 0.85rem; }
    .batch-actions .form-label { font-size: 0.8rem; margin-bottom: 0.25rem; }
    .batch-actions .form-control-sm { font-size: 0.8rem; padding: 0.25rem 0.5rem; }
    .batch-actions .btn-sm { font-size: 0.8rem; padding: 0.4rem 0.75rem; }

    /* Compact Image Cards */
    .image-preview-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 1rem;
    }
    .image-card {
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      overflow: hidden;
      transition: transform 0.2s;
    }
    .image-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.12); }
    .image-preview {
      width: 100%;
      height: 150px;
      object-fit: contain;
      background: #f8f9fa;
      padding: 8px;
    }
    .image-controls { padding: 0.75rem; }
    .slider-group { margin-bottom: 0.75rem; }
    .slider-group label { font-weight: 600; font-size: 0.8rem; margin-bottom: 0.25rem; display: block; }
    .slider-container { display: flex; gap: 0.4rem; align-items: center; }
    .slider-container input[type="range"] { flex: 1; height: 6px; }
    .slider-container input[type="number"] { width: 70px; font-size: 0.8rem; padding: 0.25rem; }
    .dimension-info { font-size: 0.75rem; color: #6c757d; margin-top: 0.25rem; }
    .aspect-ratio-toggle { margin-bottom: 0.5rem; }
    .aspect-ratio-toggle .form-check-label { font-size: 0.8rem; }
    .btn-download { width: 100%; margin-top: 0.5rem; font-size: 0.85rem; padding: 0.4rem; }
    .mode-switch {
      display: flex;
      gap: 0.3rem;
      margin-bottom: 0.75rem;
      border: 1px solid #dee2e6;
      border-radius: 6px;
      padding: 0.2rem;
      background: #f8f9fa;
    }
    .mode-switch button {
      flex: 1;
      padding: 0.35rem;
      border: none;
      background: transparent;
      border-radius: 4px;
      cursor: pointer;
      font-weight: 500;
      transition: all 0.2s;
      font-size: 0.8rem;
    }
    .mode-switch button.active { background: #007bff; color: white; }
    .file-info { font-size: 0.75rem; color: #6c757d; margin-top: 0.25rem; }
    .remove-btn {
      position: absolute;
      top: 8px;
      right: 8px;
      background: rgba(220, 53, 69, 0.9);
      color: white;
      border: none;
      border-radius: 50%;
      width: 24px;
      height: 24px;
      cursor: pointer;
      font-size: 14px;
      line-height: 1;
      z-index: 10;
    }
    .remove-btn:hover { background: rgba(220, 53, 69, 1); }
    .quality-section { margin-top: 0.75rem; padding-top: 0.75rem; border-top: 1px solid #e9ecef; }
    .quality-section label { font-size: 0.8rem; }
    .format-section { margin-top: 0.75rem; }
    .format-section label { font-size: 0.8rem; }
    .format-section select { font-size: 0.8rem; padding: 0.25rem; }

    /* Two-Column Layout */
    .left-controls {
      position: sticky;
      top: 1rem;
      max-height: calc(100vh - 2rem);
      overflow-y: auto;
    }

    /* Mobile Responsive */
    @media (max-width: 991px) {
      .left-controls { position: relative; max-height: none; }
    }
    @media (max-width: 768px) {
      .image-preview-grid { grid-template-columns: 1fr; }
      .preset-grid { grid-template-columns: repeat(2, 1fr); }
    }
  </style>
  <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>

<header class="app-header">
  <div class="container">
    <h1 class="h4 mb-2">Free Online Image Resizer</h1>
    <p class="text-muted mb-0">Resize images by pixels or percentage. Batch process up to 10 images at once!</p>
  </div>
</header>

<main class="container-fluid" style="max-width: 1400px; padding: 1rem;">
  <div class="row g-2">
    <!-- Left Column: Upload & Controls -->
    <div class="col-lg-4 col-md-5">
      <div class="left-controls">
        <!-- Upload Area -->
        <div class="upload-area" id="uploadArea">
          <svg width="40" height="40" fill="currentColor" class="text-primary" viewBox="0 0 16 16">
            <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
            <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z"/>
          </svg>
          <h5>Upload Images</h5>
          <p class="text-muted">JPG, PNG, WEBP, GIF<br>Max 10 files • 10MB each</p>
          <input type="file" id="fileInput" accept="image/*" multiple hidden>
          <button class="btn btn-primary btn-sm" onclick="document.getElementById('fileInput').click()">
            Select Images
          </button>
        </div>

        <!-- Social Media Presets -->
        <div class="presets-section" id="presetsSection" style="display: none;">
          <h6>📱 Social Media Presets</h6>
          <div class="preset-grid" id="presetGrid"></div>
        </div>

        <!-- Batch Actions -->
        <div id="batchActions" class="batch-actions" style="display: none;">
          <h6>⚙️ Batch Resize Settings</h6>
          <div class="row g-2 mb-2">
            <div class="col-6">
              <label class="form-label">Width</label>
              <input type="number" id="batchWidth" class="form-control form-control-sm" placeholder="Width">
            </div>
            <div class="col-6">
              <label class="form-label">Height</label>
              <input type="number" id="batchHeight" class="form-control form-control-sm" placeholder="Height">
            </div>
          </div>
          <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" id="batchAspectRatio" checked>
            <label class="form-check-label" for="batchAspectRatio" style="font-size: 0.8rem;">Lock aspect ratio</label>
          </div>
          <div class="d-grid gap-1">
            <button class="btn btn-success btn-sm" onclick="applyBatchSettings()">Apply to All</button>
            <button class="btn btn-primary btn-sm" onclick="downloadAll()">Download All (ZIP)</button>
            <button class="btn btn-outline-danger btn-sm" onclick="clearAll()">Clear All</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Column: Image Grid -->
    <div class="col-lg-8 col-md-7">
      <div class="image-preview-grid" id="imageGrid"></div>
    </div>
  </div>

  <!-- SEO Content Section -->
  <section class="container my-5">
    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <h2 class="h5 mb-3">About Image Resizer - Free Online Photo Resizing Tool</h2>
            <p>Resize images online for free with our powerful batch image resizer. Whether you need to resize photos for social media, compress images for websites, or adjust picture dimensions for printing, our tool handles it all instantly in your browser.</p>

            <h3 class="h6 mt-4 mb-2">Key Features:</h3>
            <ul>
              <li><strong>Resize by Pixels or Percentage:</strong> Choose between exact pixel dimensions or percentage-based scaling</li>
              <li><strong>Batch Processing:</strong> Upload and resize up to 10 images simultaneously</li>
              <li><strong>Aspect Ratio Lock:</strong> Maintain original proportions or resize freely</li>
              <li><strong>Instant Preview:</strong> See changes in real-time before downloading</li>
              <li><strong>Multiple Formats:</strong> Support for JPG, PNG, WEBP, and GIF images</li>
              <li><strong>Download Options:</strong> Download individually or all at once in a ZIP file</li>
              <li><strong>100% Client-Side:</strong> Your images never leave your device - complete privacy</li>
              <li><strong>No Registration:</strong> Use instantly without signing up</li>
            </ul>

            <h3 class="h6 mt-4 mb-2">Popular Use Cases:</h3>
            <div class="row">
              <div class="col-md-6">
                <ul>
                  <li>Social media posts (Instagram, Facebook, Twitter)</li>
                  <li>Website optimization and faster loading</li>
                  <li>Email attachments size reduction</li>
                  <li>Blog post featured images</li>
                </ul>
              </div>
              <div class="col-md-6">
                <ul>
                  <li>Profile pictures and avatars</li>
                  <li>Product photos for e-commerce</li>
                  <li>Thumbnail creation</li>
                  <li>Print-ready image preparation</li>
                </ul>
              </div>
            </div>

            <h3 class="h6 mt-4 mb-2">How to Use:</h3>
            <ol>
              <li><strong>Upload Images:</strong> Click or drag & drop up to 10 images (JPG, PNG, WEBP, GIF)</li>
              <li><strong>Choose Resize Mode:</strong> Select pixels or percentage mode</li>
              <li><strong>Adjust Dimensions:</strong> Use sliders or enter exact values</li>
              <li><strong>Lock Aspect Ratio:</strong> Toggle to maintain original proportions</li>
              <li><strong>Preview & Download:</strong> See instant preview and download individually or as ZIP</li>
            </ol>

            <h3 class="h6 mt-4 mb-2">Common Image Sizes:</h3>
            <div class="row">
              <div class="col-md-6">
                <strong>Social Media:</strong>
                <ul class="small">
                  <li>Instagram Post: 1080x1080px (square) or 1080x1350px (portrait)</li>
                  <li>Facebook Cover: 820x312px</li>
                  <li>Twitter Header: 1500x500px</li>
                  <li>LinkedIn Post: 1200x627px</li>
                </ul>
              </div>
              <div class="col-md-6">
                <strong>Web & Email:</strong>
                <ul class="small">
                  <li>Blog Featured Image: 1200x630px</li>
                  <li>Email Header: 600x200px</li>
                  <li>Website Banner: 1920x500px</li>
                  <li>Thumbnail: 300x300px</li>
                </ul>
              </div>
            </div>

            <p class="mt-4"><strong>Why Choose Our Image Resizer?</strong> Unlike desktop software that requires installation, our online tool works instantly in any browser. It's perfect for quick resizing tasks, maintaining privacy (no uploads to servers), and batch processing multiple images efficiently. Completely free with no watermarks or quality loss.</p>

            <p class="text-muted small mt-3"><strong>Keywords:</strong> resize image, image resizer online, resize image pixels, resize image percentage, batch image resizer, free image resizer, photo resizer, picture resizer, compress image size, social media image resizer, bulk image resize, aspect ratio lock, resize images for web, reduce image file size, image dimension changer</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="js/image-resizer.js"></script>

<div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
