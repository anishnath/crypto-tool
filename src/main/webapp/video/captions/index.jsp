<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // Enable cross-origin isolation so SharedArrayBuffer is available — ffmpeg.wasm
    // runs much faster multi-threaded. Same pattern as /video-trim.jsp.
    response.setHeader("Cross-Origin-Opener-Policy", "same-origin");
    response.setHeader("Cross-Origin-Embedder-Policy", "require-corp");
    response.setHeader("Cross-Origin-Resource-Policy", "same-origin");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Auto-Caption Generator: Add Subtitles" />
        <jsp:param name="toolDescription" value="Free auto-caption generator. Add animated TikTok-style subtitles to any video and export a captioned MP4, all in your browser. No signup." />
        <jsp:param name="toolCategory" value="Video &amp; Audio AI" />
        <jsp:param name="toolUrl" value="video/captions/" />
        <jsp:param name="breadcrumbCategoryUrl" value="video/" />
        <jsp:param name="toolImage" value="auto-captions-og.jpg" />
        <jsp:param name="toolKeywords" value="auto caption generator, add subtitles to video, tiktok captions, reels captions free, video subtitle maker, burn subtitles, subtitle generator ai, captions for video, animated subtitles, karaoke subtitles, video caption ai, captions.ai alternative, submagic alternative, free subtitle app, srt vtt export, word highlight subtitles" />
        <jsp:param name="toolFeatures" value="AI transcription with word-level timing,Instant TikTok-style caption preview,Karaoke and word-pop highlight modes,Style presets: TikTok Bold / Podcast Clean / Minimal,Export as burned-in MP4,Works entirely in your browser — video never uploaded,Supports MP4 MOV WebM,Free and no signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Upload your video|Drop a clip (MP4 MOV WebM) — it stays on your device,Transcription runs automatically|AI extracts speech and times every word — takes 30s to 2min depending on length,Pick a caption style|Choose TikTok Bold Podcast Clean or Minimal — change position color and highlight live,Export the captioned MP4|Click Export and download a new video with captions burned in" />
        <jsp:param name="faq1q" value="How are the captions so well-timed?" />
        <jsp:param name="faq1a" value="We transcribe your audio and run a second pass that pins every spoken word to a precise timestamp — usually within 100 milliseconds of the actual mouth movement. That's what lets captions highlight one word at a time as the speaker says it." />
        <jsp:param name="faq2q" value="Does my video leave my device?" />
        <jsp:param name="faq2a" value="No. We only send a small piece of the audio to our servers — just enough to generate the transcript. Everything else happens inside your browser: playback, caption styling, and creating the final video. The original video never leaves your device." />
        <jsp:param name="faq3q" value="Can I edit the AI-generated captions?" />
        <jsp:param name="faq3a" value="Yes — click Edit transcript after the captions load. You can fix a misheard word, adjust timing, add a missed word by typing in a gap, or delete an extra one. Changes show up in the preview live, so the exported MP4 matches exactly what you see." />
        <jsp:param name="faq4q" value="How long can the video be?" />
        <jsp:param name="faq4a" value="Under 10 minutes works great on a modern laptop. Longer clips or very high-resolution video can take several minutes and might slow down your browser. For TikTok and Reels clips (usually under 3 minutes), you'll have your captioned video in 1 to 3 minutes." />
        <jsp:param name="faq5q" value="Can I translate captions to another language?" />
        <jsp:param name="faq5a" value="In the Auto-Captions editor, captions stay in the source language. To get English captions from non-English audio, use the Transcribe tab in Translate mode first — copy the English text back in, or export SRT from there and import into a video editor of your choice." />
        <jsp:param name="faq6q" value="What formats are supported?" />
        <jsp:param name="faq6a" value="Upload: MP4, MOV, WebM and anything your browser can play. You'll get back an MP4 with the original audio and captions written directly onto the video — no separate subtitle file needed." />
        <jsp:param name="faq7q" value="Is it really free?" />
        <jsp:param name="faq7a" value="Yes — fully free, no signup, no watermark. We keep costs down by doing most of the work right inside your browser." />
        <jsp:param name="faq8q" value="Why does it run in my browser instead of the cloud?" />
        <jsp:param name="faq8a" value="Three reasons: privacy (your video stays on your device), speed (no waiting in a queue behind other users), and no cost to you (we don't charge because we're not renting servers per export). The tradeoff is that export time depends on your computer — a recent laptop handles a 3-minute clip in 1 to 3 minutes." />
    </jsp:include>

    <!-- Shared navigation chrome -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">

    <!-- Ad system styling -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">

    <!-- Shared progress bar + shared video-studio shell (sidebar, cards, tokens) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ai-progress-bar.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/video/css/video-studio.css">

    <!-- Captions-specific editor styles -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/video/captions/css/captions.css">

    <%@ include file="/modern/ads/ad-init.jsp" %>
</head>

<body class="vs-body">

    <!-- Shared modern navigation header -->
    <jsp:include page="/modern/components/nav-header.jsp" />

    <!-- Hero banner ad -->
    <div class="vs-hero">
        <%@ include file="/modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="vs-main">

        <!-- Shared sidebar — flag Auto-Captions as the active tool -->
        <% request.setAttribute("activeService", "captions"); %>
        <jsp:include page="/video/partials/sidebar.jsp" />

        <!-- ── Workspace: Auto-Captions editor ─────────────────────── -->
        <section class="vs-workspace">

            <div class="vs-view active" data-service="captions" role="tabpanel">
                <!-- Live region for screen-reader announcements of state transitions -->
                <div id="cap-live" class="sr-only" role="status" aria-live="polite" aria-atomic="true"></div>

                <header class="vs-view-header">
                    <div>
                        <h1 class="vs-view-title">Free AI Auto-Caption Generator</h1>
                        <p class="vs-view-subtitle">
                            Add animated TikTok-style subtitles to any video. AI transcribes the
                            speech, you pick a style, your browser burns them into an MP4.
                            The video never leaves your device.
                            Looking for plain text instead?
                            <a href="<%=request.getContextPath()%>/video/">Use Transcribe</a>.
                        </p>
                    </div>
                </header>

                <!-- ── State 1: Empty — drop zone ───────────────────── -->
                <div class="vs-card cap-empty" id="cap-empty">
                    <p class="vs-card-title">1 &middot; Upload</p>
                    <label class="vs-drop">
                        <svg class="vs-drop-icon" width="42" height="42" fill="currentColor" viewBox="0 0 16 16" aria-hidden="true">
                            <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                            <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z"/>
                        </svg>
                        <p class="vs-drop-title">Drop a video to start</p>
                        <p class="vs-drop-hint">
                            or <span class="vs-drop-link">browse</span> &middot;
                            MP4, MOV, WebM &middot; up to ~10 min recommended
                        </p>
                        <input type="file" class="vs-drop-file" id="cap-file-input"
                               accept="video/*,.mp4,.mov,.webm,.mkv" />
                    </label>
                    <div class="vs-error" id="cap-upload-error" role="alert"></div>
                </div>

                <!-- ── State 2: Transcribing — progress bar only ────── -->
                <div class="vs-card cap-loading" id="cap-loading" hidden>
                    <p class="vs-card-title">2 &middot; Transcribing</p>
                    <div class="cap-loading-meta">
                        <span class="cap-loading-filename" id="cap-loading-filename"></span>
                    </div>
                    <div class="cap-progress-host" id="cap-init-progress"></div>
                    <div class="vs-error" id="cap-init-error" role="alert"></div>
                </div>

                <!-- ── State 3: Ready — editor ──────────────────────── -->
                <div class="cap-editor" id="cap-editor" hidden>

                    <div class="cap-editor-grid">
                        <!-- LEFT COLUMN: preview + timeline + word strip -->
                        <div class="cap-left">
                            <div class="cap-preview">
                                <video class="cap-video" id="cap-video" controls playsinline></video>
                                <canvas class="cap-canvas" id="cap-canvas"></canvas>
                            </div>

                            <div class="cap-transcript">
                                <div class="cap-transcript-head">
                                    <span class="cap-transcript-title">Transcript</span>
                                    <span class="cap-transcript-hint" id="cap-transcript-hint"></span>
                                    <button type="button" class="vs-btn cap-edit-toggle" id="cap-edit-toggle">
                                        Edit transcript
                                    </button>
                                </div>
                                <div class="cap-strip" id="cap-strip"
                                     aria-label="Transcript — click a word to seek the video"></div>
                                <div class="cap-edit-list" id="cap-edit-list" hidden
                                     aria-label="Editable transcript — change text, adjust timing, insert or delete words"></div>
                            </div>
                        </div>

                        <!-- RIGHT COLUMN: style picker + controls -->
                        <aside class="cap-controls">
                            <p class="vs-card-title">Style</p>
                            <div class="cap-presets" id="cap-presets" role="radiogroup" aria-label="Caption style presets">
                                <!-- buttons injected by captions.js -->
                            </div>

                            <p class="vs-card-title" style="margin-top:1.25rem;">Position</p>
                            <div class="cap-radio-row" role="radiogroup">
                                <label><input type="radio" name="cap-pos" value="top"> Top</label>
                                <label><input type="radio" name="cap-pos" value="middle"> Middle</label>
                                <label><input type="radio" name="cap-pos" value="bottom" checked> Bottom</label>
                            </div>

                            <p class="vs-card-title" style="margin-top:1rem;">Highlight</p>
                            <div class="cap-radio-row" role="radiogroup">
                                <label><input type="radio" name="cap-hl" value="karaoke"> Karaoke</label>
                                <label><input type="radio" name="cap-hl" value="pop" checked> Word-pop</label>
                                <label><input type="radio" name="cap-hl" value="off"> Off</label>
                            </div>

                            <p class="vs-card-title" style="margin-top:1rem;">Words per line</p>
                            <div class="cap-seg-row">
                                <button type="button" data-words="1">1</button>
                                <button type="button" data-words="2">2</button>
                                <button type="button" data-words="3" class="active">3</button>
                                <button type="button" data-words="4">4</button>
                            </div>

                            <p class="vs-card-title" style="margin-top:1rem;">Text color</p>
                            <div class="cap-swatch-row">
                                <button type="button" class="active" style="background:#ffffff" data-color="#ffffff" aria-label="White"></button>
                                <button type="button" style="background:#fde047" data-color="#fde047" aria-label="Yellow"></button>
                                <button type="button" style="background:#22d3ee" data-color="#22d3ee" aria-label="Cyan"></button>
                                <button type="button" style="background:#f472b6" data-color="#f472b6" aria-label="Pink"></button>
                                <button type="button" style="background:#a3e635" data-color="#a3e635" aria-label="Lime"></button>
                            </div>

                            <p class="vs-card-title" style="margin-top:1rem;">Highlight color</p>
                            <div class="cap-swatch-row">
                                <button type="button" class="active" style="background:#fde047" data-hlcolor="#fde047" aria-label="Yellow"></button>
                                <button type="button" style="background:#22d3ee" data-hlcolor="#22d3ee" aria-label="Cyan"></button>
                                <button type="button" style="background:#f472b6" data-hlcolor="#f472b6" aria-label="Pink"></button>
                                <button type="button" style="background:#a3e635" data-hlcolor="#a3e635" aria-label="Lime"></button>
                                <button type="button" style="background:#f97316" data-hlcolor="#f97316" aria-label="Orange"></button>
                            </div>
                        </aside>
                    </div>

                    <!-- Export action bar -->
                    <div class="cap-actions">
                        <button type="button" class="vs-btn" id="cap-reset">Start over</button>
                        <div style="flex:1"></div>
                        <button type="button" class="vs-btn vs-btn-primary" id="cap-export">
                            Export captioned MP4
                        </button>
                    </div>

                </div>

                <!-- ── State 4: Exporting — wasm render progress ────── -->
                <div class="vs-card cap-exporting" id="cap-exporting" hidden>
                    <p class="vs-card-title">Making your captioned video</p>
                    <div class="cap-progress-host" id="cap-export-progress"></div>
                    <div class="cap-export-meta" id="cap-export-meta"></div>
                    <div class="cap-export-actions">
                        <button type="button" class="vs-btn" id="cap-export-cancel">Cancel</button>
                    </div>
                    <div class="vs-error" id="cap-export-error" role="alert"></div>
                </div>

            </div>

            <!-- In-content ad (shown when rail is hidden) -->
            <div class="vs-inline-ad">
                <%@ include file="/modern/ads/ad-in-content-mid.jsp" %>
            </div>

        </section>

        <!-- Right ad rail (desktop ≥1280px) -->
        <aside class="vs-rail" aria-label="Advertisements">
            <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Error modal — used for transcribe/export failures. The X contact CTA
         is only shown for rate-limit / capacity-related errors where reaching
         out is genuinely useful. -->
    <div class="cap-modal" id="cap-modal" role="dialog" aria-modal="true"
         aria-labelledby="cap-modal-title" hidden>
        <div class="cap-modal-card">
            <div class="cap-modal-icon" aria-hidden="true">&#9888;</div>
            <h3 class="cap-modal-title" id="cap-modal-title">Something went wrong</h3>
            <p class="cap-modal-body" id="cap-modal-body"></p>

            <div class="cap-modal-cta" id="cap-modal-cta" hidden>
                <strong>Need higher limits, stuck, or want to share feedback?</strong>
                <p>
                    DM me on X — I'm happy to bump limits for your account, look into
                    specific failures, or hear what you'd like next.
                </p>
                <a class="cap-modal-xlink" href="https://x.com/anish2good"
                   target="_blank" rel="noopener noreferrer">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                    </svg>
                    <span>@anish2good</span>
                </a>
            </div>

            <div class="cap-modal-actions">
                <button type="button" class="vs-btn" id="cap-modal-dismiss">Close</button>
            </div>
        </div>
    </div>

    <%@ include file="/modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="/modern/components/analytics.jsp" %>

    <!-- Shared libs (theme + progress bar + audio extractor) -->
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/ai-progress-bar.js" defer></script>
    <script src="<%=request.getContextPath()%>/video/js/video-audio-extract.js" defer></script>

    <!-- ffmpeg.wasm (reused from video-trim.jsp) — loaded lazily inside captions.js -->
    <script src="<%=request.getContextPath()%>/js/ffmpeg/ffmpeg.min.js" defer></script>

    <!-- Captions editor (core: UI, transcribe, preview) -->
    <script src="<%=request.getContextPath()%>/video/captions/js/captions.js" defer></script>

    <!-- Captions export module (loads ffmpeg.wasm on first Export click) -->
    <script src="<%=request.getContextPath()%>/video/captions/js/captions-export.js" defer></script>
</body>
</html>
