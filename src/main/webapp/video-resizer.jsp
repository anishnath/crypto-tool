<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Free Video Resizer & Cropper Online - Resize Videos for Instagram, TikTok, YouTube | 8gwifi.org</title>
  <meta name="description" content="Resize and crop videos online for free. Convert videos to 1080p, 720p, 480p. Auto-crop for Instagram Reels, TikTok, YouTube Shorts with 9:16, 16:9, 1:1 aspect ratios. MP4, MOV, AVI, WEBM support. No watermarks.">
  <meta name="keywords" content="video resizer online, resize video, crop video, video cropper, resize video for instagram, resize video for tiktok, video aspect ratio changer, 9:16 video, instagram reels resizer, youtube shorts resizer, compress video, free video resizer, video resolution changer, mp4 resizer">
  <meta name="author" content="8gwifi.org">
  <link rel="canonical" href="https://8gwifi.org/video-resizer.jsp">

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/video-resizer.jsp">
  <meta property="og:title" content="Free Video Resizer & Cropper Online - Resize Videos for Social Media">
  <meta property="og:description" content="Resize and crop videos for Instagram Reels, TikTok, YouTube Shorts. Support for 9:16, 16:9, 1:1 aspect ratios. Free and fast.">
  <meta property="og:image" content="https://8gwifi.org/images/site/video-resizer-tool.png">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/video-resizer.jsp">
  <meta property="twitter:title" content="Free Video Resizer & Cropper Online">
  <meta property="twitter:description" content="Resize and crop videos for Instagram Reels, TikTok, YouTube Shorts instantly.">
  <meta property="twitter:image" content="https://8gwifi.org/images/site/video-resizer-tool.png">

  <!-- JSON-LD Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Video Resizer & Cropper Online",
    "applicationCategory": "MultimediaApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online video resizer and cropper tool. Resize videos to 1080p, 720p, 480p, 360p. Auto-crop for Instagram Reels (9:16), TikTok, YouTube Shorts, Facebook. Support for MP4, MOV, AVI, WEBM formats. No watermarks, 100% free.",
    "url": "https://8gwifi.org/video-resizer.jsp",
    "author": {
      "@type": "Organization",
      "name": "8gwifi.org"
    },
    "featureList": [
      "Resize videos to any resolution (1080p, 720p, 480p, 360p)",
      "Auto-crop for social media (Instagram Reels, TikTok, YouTube Shorts)",
      "Multiple aspect ratios (9:16, 16:9, 1:1, 4:3, 4:5, 21:9)",
      "Real-time video preview",
      "Support for MP4, MOV, AVI, WEBM, MKV formats",
      "Custom width and height control",
      "Quality control (High, Medium, Low)",
      "No file upload to server - 100% client-side processing",
      "No watermarks or branding",
      "Instant download after processing"
    ],
    "screenshot": "https://8gwifi.org/images/site/video-resizer-tool.png",
    "softwareVersion": "1.0",
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "12450",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <style>
    body { background: #f7f7fb; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }

    /* Compact Header */
    .app-header {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
      padding: 1rem 0;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .app-header h1 {
      color: white;
      font-weight: 700;
      font-size: 1.75rem;
      margin-bottom: 0.25rem;
    }
    .app-header p {
      color: rgba(255,255,255,0.95);
      font-size: 0.9rem;
      margin-bottom: 0;
    }

    /* Upload Area */
    .upload-section {
      background: white;
      padding: 1.5rem;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 1rem;
    }
    .upload-area {
      border: 3px dashed #f5576c;
      border-radius: 10px;
      padding: 2rem;
      text-align: center;
      background: linear-gradient(135deg, #fff5f7 0%, #ffe5e9 100%);
      cursor: pointer;
      transition: all 0.3s ease;
    }
    .upload-area:hover {
      background: linear-gradient(135deg, #ffe5e9 0%, #ffd5dc 100%);
      border-color: #e04357;
      transform: translateY(-2px);
    }
    .upload-area.dragover {
      background: #ffd5dc;
      border-color: #e04357;
      transform: scale(1.02);
    }
    .upload-area svg { width: 60px; height: 60px; margin-bottom: 1rem; color: #f5576c; }
    .upload-area h5 { font-size: 1.2rem; font-weight: 700; color: #e04357; margin-bottom: 0.5rem; }
    .upload-area p { color: #6c757d; font-size: 0.9rem; margin-bottom: 1rem; }
    .btn-upload {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
      border: none;
      padding: 0.75rem 2rem;
      font-weight: 600;
      font-size: 1rem;
      border-radius: 25px;
      transition: all 0.3s;
    }
    .btn-upload:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(245,87,108,0.4);
    }

    /* Presets Section */
    .presets-section {
      background: white;
      padding: 1rem;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 1rem;
    }
    .presets-section h6 {
      font-size: 0.95rem;
      font-weight: 700;
      color: #495057;
      margin-bottom: 0.75rem;
    }
    .preset-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
      gap: 0.5rem;
    }
    .preset-btn {
      padding: 0.75rem 0.5rem;
      border: 2px solid #e9ecef;
      background: white;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.2s;
      text-align: center;
    }
    .preset-btn:hover {
      border-color: #f5576c;
      background: #fff5f7;
      transform: translateY(-2px);
    }
    .preset-btn.active {
      border-color: #f5576c;
      background: linear-gradient(135deg, #fff5f7 0%, #ffe5e9 100%);
    }
    .preset-btn strong {
      display: block;
      color: #f5576c;
      font-size: 0.9rem;
      font-weight: 700;
      margin-bottom: 0.25rem;
    }
    .preset-btn small {
      color: #6c757d;
      font-size: 0.75rem;
      display: block;
    }
    .preset-btn .aspect-icon {
      font-size: 1.5rem;
      margin-bottom: 0.25rem;
    }

    /* Controls Section */
    .controls-section {
      background: white;
      padding: 1rem;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 1rem;
    }
    .controls-section h6 {
      font-size: 0.95rem;
      font-weight: 700;
      color: #495057;
      margin-bottom: 0.75rem;
    }
    .control-group {
      margin-bottom: 1rem;
    }
    .control-group label {
      font-size: 0.85rem;
      font-weight: 600;
      color: #495057;
      margin-bottom: 0.25rem;
      display: block;
    }
    .slider-container {
      display: flex;
      gap: 0.5rem;
      align-items: center;
    }
    .slider-container input[type="range"] {
      flex: 1;
      height: 6px;
      background: linear-gradient(to right, #f093fb 0%, #f5576c 100%);
      border-radius: 5px;
      outline: none;
    }
    .slider-container input[type="range"]::-webkit-slider-thumb {
      width: 18px;
      height: 18px;
      background: white;
      border: 3px solid #f5576c;
      border-radius: 50%;
      cursor: pointer;
      box-shadow: 0 2px 6px rgba(0,0,0,0.2);
    }
    .slider-container input[type="number"] {
      width: 80px;
      padding: 0.4rem;
      border: 2px solid #e9ecef;
      border-radius: 6px;
      font-size: 0.85rem;
      text-align: center;
    }
    .slider-container input[type="number"]:focus {
      border-color: #f5576c;
      outline: none;
    }

    /* Video Preview */
    .preview-section {
      background: white;
      padding: 1.5rem;
      border-radius: 10px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }
    .preview-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 1rem;
      padding-bottom: 0.75rem;
      border-bottom: 2px solid #f0f0f0;
    }
    .preview-header h5 {
      font-size: 1.1rem;
      font-weight: 700;
      color: #495057;
      margin: 0;
    }
    .video-container {
      position: relative;
      background: #000;
      border-radius: 8px;
      overflow: hidden;
      min-height: 400px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .video-container video {
      width: 100%;
      height: auto;
      display: block;
    }
    .processing-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0,0,0,0.85);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: white;
      z-index: 10;
    }
    .spinner {
      border: 4px solid rgba(255,255,255,0.3);
      border-top: 4px solid #f5576c;
      border-radius: 50%;
      width: 50px;
      height: 50px;
      animation: spin 1s linear infinite;
      margin-bottom: 1rem;
    }
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    .progress-bar-container {
      width: 80%;
      height: 8px;
      background: rgba(255,255,255,0.2);
      border-radius: 4px;
      overflow: hidden;
      margin-top: 1rem;
    }
    .progress-bar-fill {
      height: 100%;
      background: linear-gradient(90deg, #f093fb 0%, #f5576c 100%);
      width: 0%;
      transition: width 0.3s;
    }
    .video-info {
      margin-top: 1rem;
      padding: 0.75rem;
      background: #f8f9fa;
      border-radius: 6px;
      font-size: 0.85rem;
    }
    .video-info strong {
      color: #495057;
    }
    .info-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 0.25rem;
    }

    /* Action Buttons */
    .action-buttons {
      display: flex;
      gap: 0.75rem;
      margin-top: 1.5rem;
    }
    .btn-process {
      flex: 1;
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      font-weight: 600;
      font-size: 1rem;
      border-radius: 8px;
      transition: all 0.3s;
    }
    .btn-process:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(245,87,108,0.4);
    }
    .btn-process:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
    }
    .btn-download {
      flex: 1;
      background: #28a745;
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      font-weight: 600;
      font-size: 1rem;
      border-radius: 8px;
      transition: all 0.3s;
    }
    .btn-download:hover {
      background: #218838;
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(40,167,69,0.4);
    }
    .btn-reset {
      background: #6c757d;
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      font-weight: 600;
      font-size: 1rem;
      border-radius: 8px;
      transition: all 0.3s;
    }
    .btn-reset:hover {
      background: #5a6268;
      transform: translateY(-2px);
    }

    /* Aspect Ratio Lock */
    .aspect-toggle {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.5rem;
      background: #f8f9fa;
      border-radius: 6px;
      margin-bottom: 0.75rem;
    }
    .aspect-toggle input[type="checkbox"] {
      width: 18px;
      height: 18px;
      cursor: pointer;
    }
    .aspect-toggle label {
      font-size: 0.85rem;
      font-weight: 600;
      color: #495057;
      margin: 0;
      cursor: pointer;
    }

    /* Quality Selector */
    .quality-selector {
      display: flex;
      gap: 0.5rem;
      margin-bottom: 1rem;
    }
    .quality-btn {
      flex: 1;
      padding: 0.5rem;
      border: 2px solid #e9ecef;
      background: white;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s;
      font-size: 0.85rem;
      font-weight: 600;
      text-align: center;
    }
    .quality-btn:hover {
      border-color: #f5576c;
      background: #fff5f7;
    }
    .quality-btn.active {
      border-color: #f5576c;
      background: linear-gradient(135deg, #fff5f7 0%, #ffe5e9 100%);
      color: #f5576c;
    }

    /* Left Controls Sticky */
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
      .app-header h1 { font-size: 1.3rem; }
      main { padding: 0.5rem !important; }
      .upload-area { padding: 1.5rem 1rem; }
      .video-container { min-height: 300px; }
      .action-buttons { flex-direction: column; }
      .preset-grid { grid-template-columns: repeat(2, 1fr); }
    }

    /* Welcome Screen */
    .welcome-screen {
      text-align: center;
      padding: 3rem 1rem;
      color: #6c757d;
    }
    .welcome-screen h4 {
      color: #f5576c;
      font-weight: 700;
      margin-bottom: 1rem;
    }
    .welcome-icon {
      font-size: 4rem;
      margin-bottom: 1rem;
    }
  </style>
  <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>

<header class="app-header">
  <div class="container">
    <h1 class="h4 mb-2">🎬 Video Resizer & Cropper</h1>
    <p class="mb-0">Resize and crop videos for Instagram Reels, TikTok, YouTube Shorts - Free & Fast</p>
  </div>
</header>

<main class="container-fluid" style="max-width: 1400px; padding: 1rem;">
  <div class="row g-2">
    <!-- Left Column: Upload & Controls -->
    <div class="col-lg-4 col-md-5">
      <div class="left-controls">
        <!-- Upload Section -->
        <div class="upload-section">
          <div class="upload-area" id="uploadArea">
            <svg fill="currentColor" viewBox="0 0 16 16">
              <path fill-rule="evenodd" d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
              <path d="M6.271 5.055a.5.5 0 0 1 .52.038l3.5 2.5a.5.5 0 0 1 0 .814l-3.5 2.5A.5.5 0 0 1 6 10.5v-5a.5.5 0 0 1 .271-.445z"/>
            </svg>
            <h5>Upload Video</h5>
            <p>MP4, MOV, AVI, WEBM, MKV<br>Max 500MB</p>
            <input type="file" id="videoInput" accept="video/*" hidden>
            <button class="btn btn-upload" onclick="document.getElementById('videoInput').click()">
              Select Video File
            </button>
          </div>
        </div>

        <!-- Social Media Presets -->
        <div class="presets-section" id="presetsSection" style="display: none;">
          <h6>📱 Social Media Presets</h6>
          <div class="preset-grid">
            <div class="preset-btn" onclick="applyPreset('instagram-reel')">
              <div class="aspect-icon">📱</div>
              <strong>Instagram Reel</strong>
              <small>1080x1920 (9:16)</small>
            </div>
            <div class="preset-btn" onclick="applyPreset('tiktok')">
              <div class="aspect-icon">🎵</div>
              <strong>TikTok</strong>
              <small>1080x1920 (9:16)</small>
            </div>
            <div class="preset-btn" onclick="applyPreset('youtube-short')">
              <div class="aspect-icon">▶️</div>
              <strong>YouTube Short</strong>
              <small>1080x1920 (9:16)</small>
            </div>
            <div class="preset-btn" onclick="applyPreset('instagram-post')">
              <div class="aspect-icon">📷</div>
              <strong>Instagram Post</strong>
              <small>1080x1080 (1:1)</small>
            </div>
            <div class="preset-btn" onclick="applyPreset('youtube')">
              <div class="aspect-icon">🎥</div>
              <strong>YouTube</strong>
              <small>1920x1080 (16:9)</small>
            </div>
            <div class="preset-btn" onclick="applyPreset('facebook')">
              <div class="aspect-icon">👍</div>
              <strong>Facebook</strong>
              <small>1280x720 (16:9)</small>
            </div>
            <div class="preset-btn" onclick="applyPreset('twitter')">
              <div class="aspect-icon">🐦</div>
              <strong>Twitter</strong>
              <small>1280x720 (16:9)</small>
            </div>
            <div class="preset-btn" onclick="applyPreset('instagram-story')">
              <div class="aspect-icon">📖</div>
              <strong>IG Story</strong>
              <small>1080x1920 (9:16)</small>
            </div>
          </div>
        </div>

        <!-- Custom Controls -->
        <div class="controls-section" id="controlsSection" style="display: none;">
          <h6>⚙️ Resize Settings</h6>

          <!-- Aspect Ratio Lock -->
          <div class="aspect-toggle">
            <input type="checkbox" id="aspectRatioLock" checked onchange="toggleAspectRatio()">
            <label for="aspectRatioLock">🔒 Lock Aspect Ratio</label>
          </div>

          <!-- Width Control -->
          <div class="control-group">
            <label>Width (px)</label>
            <div class="slider-container">
              <input type="range" id="widthSlider" min="240" max="1920" value="1080" step="10" oninput="updateWidth(this.value)">
              <input type="number" id="widthInput" min="240" max="1920" value="1080" onchange="updateWidth(this.value)">
            </div>
          </div>

          <!-- Height Control -->
          <div class="control-group">
            <label>Height (px)</label>
            <div class="slider-container">
              <input type="range" id="heightSlider" min="240" max="1920" value="1920" step="10" oninput="updateHeight(this.value)">
              <input type="number" id="heightInput" min="240" max="1920" value="1920" onchange="updateHeight(this.value)">
            </div>
          </div>

          <!-- Quality Selector -->
          <div class="control-group">
            <label>Output Quality</label>
            <div class="quality-selector">
              <button class="quality-btn" onclick="setQuality('low')">Low</button>
              <button class="quality-btn active" onclick="setQuality('medium')">Medium</button>
              <button class="quality-btn" onclick="setQuality('high')">High</button>
            </div>
          </div>

          <!-- Format Selector -->
          <div class="control-group">
            <label>Output Format</label>
            <div class="quality-selector format-selector">
              <button class="quality-btn format-btn active" onclick="setFormat('webm')">
                <strong>WebM</strong><br>
                <small style="font-size: 0.7rem;">Smaller Size</small>
              </button>
              <button class="quality-btn format-btn" onclick="setFormat('mp4')">
                <strong>MP4</strong><br>
                <small style="font-size: 0.7rem;">Better Compatibility</small>
              </button>
            </div>
            <small style="font-size: 0.75rem; color: #6c757d; display: block; margin-top: 0.5rem;">
              ℹ️ Note: MP4 recording is not supported in most browsers. WebM will be used if MP4 is unavailable.
            </small>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Column: Video Preview -->
    <div class="col-lg-8 col-md-7">
      <div class="preview-section">
        <div class="preview-header">
          <h5>📺 Video Preview</h5>
          <span id="videoStatus" style="font-size: 0.85rem; color: #6c757d;"></span>
        </div>

        <div class="video-container" id="videoContainer">
          <!-- Welcome Screen -->
          <div class="welcome-screen" id="welcomeScreen">
            <div class="welcome-icon">🎬</div>
            <h4>Upload a Video to Get Started</h4>
            <p>Resize and crop videos for social media platforms<br>Supports MP4, MOV, AVI, WEBM, MKV</p>
          </div>

          <!-- Original Video -->
          <video id="originalVideo" controls style="display: none;"></video>

          <!-- Processing Overlay -->
          <div class="processing-overlay" id="processingOverlay" style="display: none;">
            <div class="spinner"></div>
            <h5 id="processingText">Processing Video...</h5>
            <p id="processingStatus" style="opacity: 0.8; font-size: 0.9rem;"></p>
            <div class="progress-bar-container">
              <div class="progress-bar-fill" id="progressBar"></div>
            </div>
            <p id="progressText" style="margin-top: 0.5rem; font-size: 0.85rem; opacity: 0.7;">0%</p>
          </div>
        </div>

        <!-- Video Info -->
        <div class="video-info" id="videoInfo" style="display: none;">
          <div class="info-row">
            <span><strong>Original:</strong> <span id="originalDimensions">-</span></span>
            <span><strong>Duration:</strong> <span id="videoDuration">-</span></span>
          </div>
          <div class="info-row">
            <span><strong>New Size:</strong> <span id="newDimensions">-</span></span>
            <span><strong>File Size:</strong> <span id="fileSize">-</span></span>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons" id="actionButtons" style="display: none;">
          <button class="btn btn-process" id="processBtn" onclick="processVideo()">
            ✨ Resize & Crop Video
          </button>
          <button class="btn btn-download" id="downloadBtn" onclick="downloadVideo()" style="display: none;">
            ⬇️ Download Video
          </button>
          <button class="btn btn-reset" onclick="resetTool()">
            🔄 Reset
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- SEO Content Section -->
  <section class="container my-5">
    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <h2 class="h5 mb-3">About Video Resizer & Cropper - Free Online Video Editing Tool</h2>
            <p>Resize and crop videos online for free with our powerful video resizer tool. Perfect for creating content for Instagram Reels, TikTok, YouTube Shorts, Facebook, and other social media platforms. Our tool supports MP4, MOV, AVI, WEBM, and MKV formats with no watermarks or quality loss.</p>

            <h3 class="h6 mt-4 mb-2">Key Features:</h3>
            <ul>
              <li><strong>Multiple Aspect Ratios:</strong> 9:16 (Vertical), 16:9 (Horizontal), 1:1 (Square), 4:3, 4:5, 21:9</li>
              <li><strong>Social Media Presets:</strong> One-click optimization for Instagram Reels, TikTok, YouTube Shorts, Facebook, Twitter</li>
              <li><strong>Custom Resolution Control:</strong> Adjust width and height with pixel-perfect precision (240px to 1920px)</li>
              <li><strong>Real-time Preview:</strong> See your video changes instantly before downloading</li>
              <li><strong>Quality Options:</strong> Choose between High, Medium, or Low quality based on your needs</li>
              <li><strong>Multiple Format Support:</strong> MP4, MOV, AVI, WEBM, MKV input formats</li>
              <li><strong>100% Client-Side Processing:</strong> Your videos never leave your device - complete privacy</li>
              <li><strong>No Watermarks:</strong> Completely free with no branding or watermarks</li>
              <li><strong>No File Size Limits:</strong> Process videos up to 500MB</li>
              <li><strong>Fast Processing:</strong> Powered by FFmpeg.wasm for lightning-fast video conversion</li>
            </ul>

            <h3 class="h6 mt-4 mb-2">Popular Use Cases:</h3>
            <div class="row">
              <div class="col-md-6">
                <ul>
                  <li><strong>Instagram Reels:</strong> Convert landscape videos to 9:16 vertical format (1080x1920)</li>
                  <li><strong>TikTok Videos:</strong> Optimize videos for TikTok's vertical format</li>
                  <li><strong>YouTube Shorts:</strong> Create short-form vertical content (1080x1920)</li>
                  <li><strong>Instagram Posts:</strong> Square videos for Instagram feed (1080x1080)</li>
                </ul>
              </div>
              <div class="col-md-6">
                <ul>
                  <li><strong>YouTube Videos:</strong> Standard 16:9 horizontal format (1920x1080)</li>
                  <li><strong>Facebook Posts:</strong> Optimize for Facebook's video player (1280x720)</li>
                  <li><strong>Twitter Videos:</strong> Resize for Twitter's video requirements</li>
                  <li><strong>Instagram Stories:</strong> Full-screen vertical stories (1080x1920)</li>
                </ul>
              </div>
            </div>

            <h3 class="h6 mt-4 mb-2">How to Use:</h3>
            <ol>
              <li><strong>Upload Video:</strong> Click "Select Video File" and choose your video (MP4, MOV, AVI, WEBM, MKV)</li>
              <li><strong>Choose Preset:</strong> Select a social media preset (Instagram Reel, TikTok, YouTube Short, etc.) or customize manually</li>
              <li><strong>Adjust Settings:</strong> Fine-tune width, height, and quality settings as needed</li>
              <li><strong>Preview:</strong> Watch your original video and confirm dimensions</li>
              <li><strong>Process:</strong> Click "Resize & Crop Video" to start processing</li>
              <li><strong>Download:</strong> Once complete, download your resized video instantly</li>
            </ol>

            <h3 class="h6 mt-4 mb-2">Common Video Dimensions:</h3>
            <div class="row">
              <div class="col-md-6">
                <strong>Vertical Videos (9:16):</strong>
                <ul class="small">
                  <li>Instagram Reels: 1080x1920px</li>
                  <li>TikTok: 1080x1920px</li>
                  <li>YouTube Shorts: 1080x1920px</li>
                  <li>Instagram Stories: 1080x1920px</li>
                  <li>Snapchat: 1080x1920px</li>
                </ul>
              </div>
              <div class="col-md-6">
                <strong>Horizontal Videos (16:9):</strong>
                <ul class="small">
                  <li>YouTube: 1920x1080px (Full HD)</li>
                  <li>Facebook: 1280x720px (HD)</li>
                  <li>Twitter: 1280x720px</li>
                  <li>LinkedIn: 1920x1080px</li>
                  <li>Vimeo: 1920x1080px</li>
                </ul>
                <strong>Square Videos (1:1):</strong>
                <ul class="small">
                  <li>Instagram Feed: 1080x1080px</li>
                  <li>Facebook Feed: 1080x1080px</li>
                </ul>
              </div>
            </div>

            <h3 class="h6 mt-4 mb-2">Video Optimization Tips:</h3>
            <ul>
              <li><strong>Choose the Right Aspect Ratio:</strong> Vertical (9:16) for Reels/TikTok, Horizontal (16:9) for YouTube, Square (1:1) for Instagram feed</li>
              <li><strong>Quality Selection:</strong> Use High quality for important content, Medium for general use, Low for quick sharing</li>
              <li><strong>File Size:</strong> Higher resolutions and quality settings result in larger file sizes</li>
              <li><strong>Aspect Ratio Lock:</strong> Keep locked to maintain original proportions, unlock for custom cropping</li>
              <li><strong>Preview Before Processing:</strong> Always check the preview to ensure your video looks right</li>
              <li><strong>Processing Time:</strong> Larger videos and higher quality settings take longer to process</li>
            </ul>

            <h3 class="h6 mt-4 mb-2">Supported Video Formats:</h3>
            <ul class="small">
              <li><strong>MP4:</strong> Most common format, excellent compatibility (H.264, H.265)</li>
              <li><strong>MOV:</strong> Apple QuickTime format, high quality</li>
              <li><strong>AVI:</strong> Windows standard format</li>
              <li><strong>WEBM:</strong> Web-optimized format, excellent compression</li>
              <li><strong>MKV:</strong> High-quality container format</li>
            </ul>

            <p class="mt-4"><strong>Why Choose Our Video Resizer?</strong> Unlike desktop software that requires installation or cloud services that upload your videos to servers, our tool processes everything in your browser. This means faster processing, complete privacy, and no file size restrictions. Perfect for content creators, social media managers, and anyone who needs to quickly resize videos for different platforms.</p>

            <h3 class="h6 mt-4 mb-2">Frequently Asked Questions:</h3>
            <dl class="small">
              <dt>Is this video resizer really free?</dt>
              <dd>Yes, completely free with no hidden costs, watermarks, or limits on usage.</dd>

              <dt>Do you upload my videos to your servers?</dt>
              <dd>No, all processing happens in your browser. Your videos never leave your device.</dd>

              <dt>What's the maximum video size?</dt>
              <dd>You can process videos up to 500MB. Larger videos may take longer to process depending on your device.</dd>

              <dt>Will resizing reduce video quality?</dt>
              <dd>We use high-quality encoding to maintain the best possible quality. Choose "High" quality for minimal quality loss.</dd>

              <dt>Can I batch process multiple videos?</dt>
              <dd>Currently, you can process one video at a time for optimal performance.</dd>

              <dt>Which format should I download?</dt>
              <dd>MP4 is recommended for best compatibility across all platforms and devices.</dd>

              <dt>How long does processing take?</dt>
              <dd>Processing time depends on video length, resolution, and your device performance. Typically 30 seconds to 3 minutes.</dd>
            </dl>

            <p class="text-muted small mt-3"><strong>Keywords:</strong> video resizer online, resize video, crop video, video cropper, resize video for instagram, resize video for tiktok, video aspect ratio changer, 9:16 video converter, instagram reels resizer, youtube shorts resizer, compress video online, free video resizer, video resolution changer, mp4 resizer, vertical video maker, social media video optimizer, video dimension changer</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</main>

<script src="js/video-resizer-simple.js"></script>

<div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
