<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <!-- SEO -->
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Video Resizer & Cropper Online - Free" />
        <jsp:param name="toolDescription" value="Resize and crop videos online for free. Auto-crop for Instagram Reels, TikTok, YouTube Shorts with 9:16, 16:9, 1:1 ratios. MP4 / MOV / WEBM, no watermarks, 100% in-browser." />
        <jsp:param name="toolCategory" value="Video &amp; Audio" />
        <jsp:param name="toolUrl" value="video-resizer.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="video/" />
        <jsp:param name="toolImage" value="video-resizer-tool.png" />
        <jsp:param name="toolKeywords" value="video resizer online, resize video, crop video, video cropper, resize video for instagram, resize video for tiktok, video aspect ratio changer, 9:16 video, instagram reels resizer, youtube shorts resizer, compress video, free video resizer, video resolution changer, mp4 resizer, vertical video maker" />
        <jsp:param name="toolFeatures" value="Resize videos to 1080p / 720p / 480p / 360p,One-click social presets (Reels TikTok Shorts),Aspect ratios 9:16 16:9 1:1 4:3 4:5 21:9,Real-time video preview,MP4 MOV AVI WEBM MKV input,Custom width and height control,Quality control (High Medium Low),100% client-side — videos never leave your device,No watermarks,Instant download" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Upload video|Click the drop zone (or drag &amp; drop) and choose an MP4, MOV, AVI, WEBM, or MKV file.,Pick a preset|Choose a social preset like Instagram Reel, TikTok, or YouTube Short — or set width/height manually.,Adjust settings|Fine-tune dimensions, lock or unlock aspect ratio, and pick output quality and format.,Process|Click Resize &amp; Crop Video — everything runs in your browser, nothing is uploaded.,Download|When processing finishes, download the resized video instantly." />
        <jsp:param name="faq1q" value="Is this video resizer really free?" />
        <jsp:param name="faq1a" value="Yes, completely free with no hidden costs, watermarks, or usage limits." />
        <jsp:param name="faq2q" value="Do you upload my videos to your servers?" />
        <jsp:param name="faq2a" value="No. All processing happens in your browser using your device's CPU — your videos never leave your computer." />
        <jsp:param name="faq3q" value="What's the maximum video size?" />
        <jsp:param name="faq3a" value="You can process videos up to about 500MB. Larger or longer videos take more time depending on your device." />
        <jsp:param name="faq4q" value="Will resizing reduce video quality?" />
        <jsp:param name="faq4a" value="The tool uses high-quality encoding to preserve as much detail as possible. Choose the High quality setting for minimal loss." />
        <jsp:param name="faq5q" value="Which output format should I use?" />
        <jsp:param name="faq5a" value="MP4 offers the best compatibility across devices and is the default. WebM produces smaller files; if your browser can't record MP4, WebM is used automatically." />
        <jsp:param name="faq6q" value="What aspect ratio should I pick for each platform?" />
        <jsp:param name="faq6a" value="Use 9:16 vertical (1080x1920) for Reels, TikTok, Shorts, and Stories; 16:9 horizontal (1920x1080) for YouTube; and 1:1 square (1080x1080) for Instagram and Facebook feed posts." />
        <jsp:param name="faq7q" value="Can I batch process multiple videos?" />
        <jsp:param name="faq7a" value="Currently you process one video at a time for the best performance and lowest memory use." />
    </jsp:include>

    <!-- Navigation (kept consistent with the rest of the site) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <!-- Ad system styling -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <!-- Independent studio styling — does NOT extend design-system.css -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/video/css/video-studio.css">

    <%@ include file="/modern/ads/ad-init.jsp" %>

    <!-- Resize & Crop widgets — themed with the studio's --vs-* tokens -->
    <style>
        .vr-status { display:inline-block; margin-top:0.6rem; font-size:0.8rem; color:var(--vs-text-soft); }

        /* Drop zone */
        .vr-drop {
            display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;
            border:2px dashed var(--vs-dash); border-radius:0.75rem; background:var(--vs-bg-inset);
            padding:1.75rem 1rem; cursor:pointer; transition:border-color .2s, background .2s, transform .2s;
        }
        .vr-drop:hover { border-color:var(--vs-accent); background:var(--vs-bg-tint); }
        .vr-drop.dragover { border-color:var(--vs-accent); background:var(--vs-bg-tint-hover); transform:scale(1.01); }
        .vr-drop-icon { width:42px; height:42px; color:var(--vs-accent); margin-bottom:0.6rem; }
        .vr-drop-title { font-size:1rem; font-weight:600; color:var(--vs-text); margin:0 0 0.25rem; }
        .vr-drop-hint { font-size:0.8rem; color:var(--vs-text-soft); margin:0; }
        .vr-link { color:var(--vs-link); font-weight:600; }

        /* Presets */
        .vr-preset-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:0.5rem; }
        @media (min-width:560px){ .vr-preset-grid { grid-template-columns:repeat(4,1fr); } }
        .preset-btn {
            padding:0.6rem 0.4rem; border:1.5px solid var(--vs-border-strong); background:var(--vs-bg-inset);
            border-radius:0.6rem; cursor:pointer; transition:all .18s; text-align:center;
        }
        .preset-btn:hover { border-color:var(--vs-accent); background:var(--vs-bg-tint); transform:translateY(-1px); }
        .preset-btn.active { border-color:var(--vs-accent); background:var(--vs-bg-soft); }
        .preset-btn .aspect-icon { font-size:1.25rem; margin-bottom:0.2rem; }
        .preset-btn strong { display:block; color:var(--vs-text); font-size:0.8rem; font-weight:700; margin-bottom:0.1rem; }
        .preset-btn small { color:var(--vs-text-soft); font-size:0.68rem; display:block; }
        .preset-btn * { pointer-events:none; }

        /* Controls */
        .vr-group { margin-bottom:1rem; }
        .vr-group > label { display:block; font-size:0.72rem; font-weight:700; letter-spacing:0.04em; text-transform:uppercase; color:var(--vs-text-soft); margin-bottom:0.35rem; }
        .vr-slider { display:flex; gap:0.5rem; align-items:center; }
        .vr-slider input[type="range"]{ flex:1; height:6px; -webkit-appearance:none; appearance:none; background:linear-gradient(90deg,var(--vs-accent-2),var(--vs-accent)); border-radius:5px; outline:none; }
        .vr-slider input[type="range"]::-webkit-slider-thumb{ -webkit-appearance:none; width:18px; height:18px; background:#fff; border:3px solid var(--vs-accent); border-radius:50%; cursor:pointer; box-shadow:0 2px 6px rgba(0,0,0,0.3); }
        .vr-slider input[type="number"]{ width:78px; padding:0.4rem; border:1.5px solid var(--vs-border-strong); border-radius:0.5rem; font-size:0.85rem; text-align:center; background:var(--vs-bg-input); color:var(--vs-text); font-family:'JetBrains Mono',monospace; }
        .vr-slider input[type="number"]:focus{ border-color:var(--vs-accent); outline:none; }
        .vr-toggle { display:flex; align-items:center; gap:0.5rem; padding:0.55rem 0.65rem; background:var(--vs-bg-inset); border:1px solid var(--vs-border); border-radius:0.5rem; margin-bottom:0.9rem; }
        .vr-toggle input[type="checkbox"]{ width:17px; height:17px; cursor:pointer; accent-color:var(--vs-accent); }
        .vr-toggle label { font-size:0.82rem; font-weight:600; color:var(--vs-text-dim); margin:0; cursor:pointer; }
        .vr-segment { display:flex; gap:0.5rem; }
        .quality-btn { flex:1; padding:0.5rem; border:1.5px solid var(--vs-border-strong); background:var(--vs-bg-btn); border-radius:0.5rem; cursor:pointer; transition:all .18s; font-size:0.82rem; font-weight:600; text-align:center; color:var(--vs-text-dim); font-family:inherit; }
        .quality-btn:hover { border-color:var(--vs-accent); background:var(--vs-bg-tint); }
        .quality-btn.active { border-color:var(--vs-accent); background:var(--vs-bg-soft); color:var(--vs-text); }
        .format-btn small { font-weight:500; color:var(--vs-text-soft); }
        .format-btn * { pointer-events:none; }
        .vr-note { margin-top:0.75rem; font-size:0.75rem; color:var(--vs-text-soft); background:var(--vs-bg-tint); border-left:3px solid var(--vs-accent); border-radius:0.4rem; padding:0.55rem 0.7rem; }

        /* Preview */
        .vr-preview-wrap { position:relative; background:#000; border-radius:0.6rem; overflow:hidden; min-height:340px; max-height:70vh; display:flex; align-items:center; justify-content:center; }
        .vr-preview-wrap video { max-width:100%; max-height:70vh; width:auto; height:auto; display:block; }
        .welcome-screen { text-align:center; padding:3rem 1rem; color:rgba(255,255,255,0.85); }
        .welcome-screen .welcome-icon { font-size:3.25rem; margin-bottom:0.6rem; }
        .welcome-screen h4 { color:#fff; font-weight:700; margin:0 0 0.5rem; font-size:1.1rem; }
        .welcome-screen p { font-size:0.85rem; line-height:1.6; color:rgba(255,255,255,0.7); margin:0; }
        .processing-overlay { position:absolute; inset:0; background:rgba(0,0,0,0.85); display:flex; flex-direction:column; align-items:center; justify-content:center; color:#fff; z-index:10; padding:1rem; }
        .vr-spinner { border:4px solid rgba(255,255,255,0.25); border-top:4px solid var(--vs-accent); border-radius:50%; width:46px; height:46px; animation:vrspin 1s linear infinite; margin-bottom:1rem; }
        @keyframes vrspin { to { transform:rotate(360deg); } }
        .processing-overlay h5 { font-size:1rem; font-weight:700; margin:0; }
        .vr-progress-track { width:80%; max-width:320px; height:8px; background:rgba(255,255,255,0.2); border-radius:4px; overflow:hidden; margin-top:1rem; }
        .vr-progress-fill { height:100%; background:linear-gradient(90deg,var(--vs-accent-2),var(--vs-accent)); width:0%; transition:width .3s; }
        .vr-info { margin-top:1rem; padding:0.75rem 0.85rem; background:var(--vs-bg-inset); border:1px solid var(--vs-border); border-radius:0.5rem; font-size:0.82rem; }
        .vr-info strong { color:var(--vs-text-soft); }
        .vr-info .vr-row { display:flex; justify-content:space-between; gap:1rem; flex-wrap:wrap; }
        .vr-info .vr-row + .vr-row { margin-top:0.35rem; }
        .vr-info .vr-row span span { color:var(--vs-text); font-family:'JetBrains Mono',monospace; }

        /* Action buttons (reuse studio button look) */
        .vr-actions { display:flex; gap:0.6rem; margin-top:1.25rem; flex-wrap:wrap; }
        .btn-process, .btn-download, .btn-reset { border:none; padding:0.7rem 1.3rem; font-weight:600; font-size:0.9rem; border-radius:0.55rem; cursor:pointer; transition:all .2s; font-family:inherit; }
        .btn-process { flex:1; min-width:160px; background:linear-gradient(135deg,var(--vs-accent-2),var(--vs-accent-strong)); color:#fff; }
        .btn-process:hover { filter:brightness(1.08); transform:translateY(-1px); }
        .btn-process:disabled { opacity:0.6; cursor:not-allowed; transform:none; filter:none; }
        .btn-download { flex:1; min-width:160px; background:#16a34a; color:#fff; }
        .btn-download:hover { background:#15803d; transform:translateY(-1px); }
        .btn-reset { background:var(--vs-bg-btn); color:var(--vs-text-dim); border:1px solid var(--vs-border-strong); }
        .btn-reset:hover { background:var(--vs-bg-btn-hover); color:var(--vs-text); }
        @media (max-width:560px){ .vr-actions { flex-direction:column; } .btn-process, .btn-download { min-width:0; } }

        /* ── Two-pane workspace: controls (left) + sticky preview (right) — less scrolling ── */
        .vs-workspace { overflow: visible; }                 /* allow the preview to stick to the viewport */
        .vr-layout { display:grid; grid-template-columns:1fr; gap:1rem; }
        .vr-col-controls { display:flex; flex-direction:column; gap:1rem; min-width:0; }
        .vr-col-controls .vs-card, .vr-col-preview .vs-card { margin-bottom:0; }
        .vr-preset-grid { grid-template-columns:repeat(2,1fr) !important; }   /* keep 2-up inside the narrow controls column */
        .vs-view-header { margin-bottom:1rem; padding-bottom:1rem; }          /* tighter header */
        @media (min-width:1100px) {
            .vr-layout { grid-template-columns:340px minmax(0,1fr); align-items:start; }
            .vr-col-preview { position:sticky; top:88px; }                   /* stays visible while you tweak settings */
        }
    </style>
</head>

<body class="vs-body">

    <!-- Shared modern navigation header -->
    <jsp:include page="/modern/components/nav-header.jsp" />

    <!-- Hero banner -->
    <div class="vs-hero">
        <%@ include file="/modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="vs-main">

        <!-- Shared sidebar (highlight Resize) -->
        <% request.setAttribute("activeService", "resize"); %>
        <jsp:include page="/video/partials/sidebar.jsp" />

        <!-- Workspace -->
        <section class="vs-workspace">
            <div class="vs-view active" data-service="resize" role="tabpanel">
                <header class="vs-view-header">
                    <div>
                        <h1 class="vs-view-title">Resize &amp; Crop Video</h1>
                        <p class="vs-view-subtitle">
                            Resize and crop any clip for Instagram Reels, TikTok, and YouTube Shorts —
                            9:16, 1:1, 16:9 and custom sizes. Everything runs in your browser; nothing is uploaded.
                        </p>
                    </div>
                </header>

                <div class="vr-layout">
                <div class="vr-col-controls">

                <!-- 1 · Upload -->
                <div class="vs-card">
                    <p class="vs-card-title">1 &middot; Upload</p>
                    <div class="vr-drop" id="uploadArea" onclick="document.getElementById('videoInput').click()">
                        <svg class="vr-drop-icon" fill="currentColor" viewBox="0 0 16 16" aria-hidden="true">
                            <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                            <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z"/>
                        </svg>
                        <p class="vr-drop-title">Drop a video here</p>
                        <p class="vr-drop-hint">or <span class="vr-link">browse</span> &middot; MP4, MOV, AVI, WEBM, MKV &middot; up to 500MB</p>
                        <input type="file" id="videoInput" accept="video/*" hidden>
                    </div>
                    <span id="videoStatus" class="vr-status"></span>
                </div>

                <!-- 2 · Social Presets -->
                <div class="vs-card" id="presetsSection" style="display: none;">
                    <p class="vs-card-title">2 &middot; Social Presets</p>
                    <div class="vr-preset-grid">
                        <div class="preset-btn" onclick="applyPreset('instagram-reel')"><div class="aspect-icon">&#128241;</div><strong>Instagram Reel</strong><small>1080&#215;1920 &#183; 9:16</small></div>
                        <div class="preset-btn" onclick="applyPreset('tiktok')"><div class="aspect-icon">&#127925;</div><strong>TikTok</strong><small>1080&#215;1920 &#183; 9:16</small></div>
                        <div class="preset-btn" onclick="applyPreset('youtube-short')"><div class="aspect-icon">&#9654;&#65039;</div><strong>YouTube Short</strong><small>1080&#215;1920 &#183; 9:16</small></div>
                        <div class="preset-btn" onclick="applyPreset('instagram-post')"><div class="aspect-icon">&#128247;</div><strong>Instagram Post</strong><small>1080&#215;1080 &#183; 1:1</small></div>
                        <div class="preset-btn" onclick="applyPreset('youtube')"><div class="aspect-icon">&#127909;</div><strong>YouTube</strong><small>1920&#215;1080 &#183; 16:9</small></div>
                        <div class="preset-btn" onclick="applyPreset('facebook')"><div class="aspect-icon">&#128077;</div><strong>Facebook</strong><small>1280&#215;720 &#183; 16:9</small></div>
                        <div class="preset-btn" onclick="applyPreset('twitter')"><div class="aspect-icon">&#128038;</div><strong>Twitter / X</strong><small>1280&#215;720 &#183; 16:9</small></div>
                        <div class="preset-btn" onclick="applyPreset('instagram-story')"><div class="aspect-icon">&#128214;</div><strong>IG Story</strong><small>1080&#215;1920 &#183; 9:16</small></div>
                    </div>
                </div>

                <!-- 3 · Resize Settings -->
                <div class="vs-card" id="controlsSection" style="display: none;">
                    <p class="vs-card-title">3 &middot; Resize Settings</p>

                    <div class="vr-toggle">
                        <input type="checkbox" id="aspectRatioLock" checked onchange="toggleAspectRatio()">
                        <label for="aspectRatioLock">&#128274; Lock aspect ratio</label>
                    </div>

                    <div class="vr-group">
                        <label>Width (px)</label>
                        <div class="vr-slider">
                            <input type="range" id="widthSlider" min="240" max="1920" value="1080" step="10" oninput="updateWidth(this.value)">
                            <input type="number" id="widthInput" min="240" max="1920" value="1080" onchange="updateWidth(this.value)">
                        </div>
                    </div>

                    <div class="vr-group">
                        <label>Height (px)</label>
                        <div class="vr-slider">
                            <input type="range" id="heightSlider" min="240" max="1920" value="1920" step="10" oninput="updateHeight(this.value)">
                            <input type="number" id="heightInput" min="240" max="1920" value="1920" onchange="updateHeight(this.value)">
                        </div>
                    </div>

                    <div class="vr-group">
                        <label>Output Quality</label>
                        <div class="vr-segment">
                            <button class="quality-btn" onclick="setQuality('low')">Low</button>
                            <button class="quality-btn active" onclick="setQuality('medium')">Medium</button>
                            <button class="quality-btn" onclick="setQuality('high')">High</button>
                        </div>
                    </div>

                    <div class="vr-group">
                        <label>Output Format</label>
                        <div class="vr-segment">
                            <button class="quality-btn format-btn active" onclick="setFormat('mp4')"><strong>MP4</strong><br><small>Best compatibility</small></button>
                            <button class="quality-btn format-btn" onclick="setFormat('webm')"><strong>WebM</strong><br><small>Smaller size</small></button>
                        </div>
                        <p class="vr-note">MP4 is the default for best compatibility. If your browser can't record MP4, WebM is used automatically.</p>
                    </div>
                </div>

                </div><!-- /vr-col-controls -->

                <div class="vr-col-preview">
                <!-- Preview -->
                <div class="vs-card">
                    <p class="vs-card-title">Preview</p>
                    <div class="vr-preview-wrap" id="videoContainer">
                        <div class="welcome-screen" id="welcomeScreen">
                            <div class="welcome-icon">&#127916;</div>
                            <h4>Upload a video to get started</h4>
                            <p>Resize and crop for social platforms.<br>Supports MP4, MOV, AVI, WEBM, MKV.</p>
                        </div>

                        <video id="originalVideo" controls style="display: none;"></video>

                        <div class="processing-overlay" id="processingOverlay" style="display: none;">
                            <div class="vr-spinner"></div>
                            <h5 id="processingText">Processing Video&hellip;</h5>
                            <p id="processingStatus" style="opacity:0.8;font-size:0.85rem;margin-top:0.25rem;"></p>
                            <div class="vr-progress-track"><div class="vr-progress-fill" id="progressBar"></div></div>
                            <p id="progressText" style="margin-top:0.5rem;font-size:0.8rem;opacity:0.7;">0%</p>
                        </div>
                    </div>

                    <div class="vr-info" id="videoInfo" style="display: none;">
                        <div class="vr-row">
                            <span><strong>Original:</strong> <span id="originalDimensions">-</span></span>
                            <span><strong>Duration:</strong> <span id="videoDuration">-</span></span>
                        </div>
                        <div class="vr-row">
                            <span><strong>New size:</strong> <span id="newDimensions">-</span></span>
                            <span><strong>File size:</strong> <span id="fileSize">-</span></span>
                        </div>
                    </div>

                    <div class="vr-actions" id="actionButtons" style="display: none;">
                        <button class="btn-process" id="processBtn" onclick="processVideo()">&#10024; Resize &amp; Crop Video</button>
                        <button class="btn-download" id="downloadBtn" onclick="downloadVideo()" style="display: none;">&#11015;&#65039; Download Video</button>
                        <button class="btn-reset" onclick="resetTool()">&#128260; Reset</button>
                    </div>
                </div>
                </div><!-- /vr-col-preview -->
                </div><!-- /vr-layout -->
            </div>

            <!-- In-content ad (shown under workspace where rail is hidden) -->
            <div class="vs-inline-ad">
                <%@ include file="/modern/ads/ad-in-content-mid.jsp" %>
            </div>
        </section>

        <!-- Right ad rail (desktop ≥1280px only) -->
        <aside class="vs-rail" aria-label="Advertisements">
            <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Ads -->
    <%@ include file="/modern/ads/ad-sticky-footer.jsp" %>

    <!-- Analytics -->
    <%@ include file="/modern/components/analytics.jsp" %>

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/js/video-resizer-simple.js"></script>
</body>
</html>
