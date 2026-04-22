<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AI Video to Text &amp; Subtitle Generator" />
        <jsp:param name="toolDescription" value="Transcribe or translate any video in minutes. 90+ languages. Export plain text, SRT or VTT subtitles. Free, no signup." />
        <jsp:param name="toolCategory" value="Video &amp; Audio AI" />
        <jsp:param name="toolUrl" value="video/" />
        <jsp:param name="breadcrumbCategoryUrl" value="video/" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolKeywords" value="transcribe video to text, ai video transcription, video to text, speech to text, mp4 to text, translate video to english, youtube video transcription, video subtitle generator, video to srt, srt generator free, vtt subtitles, video caption generator, audio to text converter, free transcription, otter alternative free, rev alternative" />
        <jsp:param name="toolFeatures" value="Transcribe video or audio to accurate text,Translate speech to English from 90+ languages,Export as plain text SRT VTT or JSON,Time-stamped subtitle segments ready for editors,Works in any modern browser — no install,Your video stays on your device,Up to 25 MB per clip,Free and no signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Upload a file|Drop a video (MP4 MOV WebM) or audio file (MP3 WAV M4A OGG FLAC) into the studio,Pick a task|Choose Transcribe to keep the original language or Translate to convert speech to English,Choose output format|TXT for plain text SRT for subtitles VTT for web video or JSON for machine parsing,Run and download|Hit Transcribe wait 1-4 minutes then Copy or Download the result" />
        <jsp:param name="faq1q" value="How accurate is AI video transcription?" />
        <jsp:param name="faq1a" value="Very accurate — typically 95%+ on clear speech recorded in a quiet environment. Accuracy drops with heavy accents, multiple overlapping speakers, or loud background noise. Best results come from a single speaker close to the microphone." />
        <jsp:param name="faq2q" value="Can I transcribe a YouTube video?" />
        <jsp:param name="faq2a" value="Yes. Download the video first (many free tools can do this), then upload the file here. We don't pull directly from YouTube in order to respect their terms of service — but once you have the file, transcription is one click." />
        <jsp:param name="faq3q" value="Which languages does it support?" />
        <jsp:param name="faq3a" value="90+ languages for transcription, plus one-click translation from any of them to English. Includes Spanish, French, German, Italian, Portuguese, Hindi, Mandarin, Cantonese, Japanese, Korean, Arabic, Russian, Dutch, Polish, Turkish and many more." />
        <jsp:param name="faq4q" value="Do I need to install anything?" />
        <jsp:param name="faq4a" value="No. Everything runs in your browser — no downloads, no plugins, no signup, no account. Just drop a file and go." />
        <jsp:param name="faq5q" value="What file formats and size are supported?" />
        <jsp:param name="faq5a" value="Video: MP4, MOV, WebM, MKV and anything your browser can play. Audio: MP3, WAV, M4A, WebM, OGG, FLAC. The limit is 25 MB of processed audio — roughly 30 minutes of speech." />
        <jsp:param name="faq6q" value="Can I export subtitles for my video?" />
        <jsp:param name="faq6a" value="Yes. Choose SRT or VTT in the Output Format dropdown and hit Download. The file is ready to drop into any video editor (Premiere, DaVinci Resolve, Final Cut, CapCut) or web video player that supports captions." />
        <jsp:param name="faq7q" value="Will you store my video or audio?" />
        <jsp:param name="faq7a" value="No. Your video stays on your device. Only the audio needed for transcription is processed, and nothing is stored after the transcript is returned to you." />
        <jsp:param name="faq8q" value="Is it really free?" />
        <jsp:param name="faq8a" value="Yes, completely free with no signup and no credit card. Usage is rate-limited to keep the service stable for everyone, but there's no daily cap and no paid tier." />
    </jsp:include>

    <!-- Navigation (kept consistent with the rest of the site) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">

    <!-- Ad system styling -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">

    <!-- Shared AI progress bar (reused from CAD text-AI flow) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ai-progress-bar.css">

    <!-- Independent studio styling — does NOT extend design-system.css -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/video/css/video-studio.css">

    <%@ include file="/modern/ads/ad-init.jsp" %>
</head>

<body class="vs-body">

    <!-- Shared modern navigation header -->
    <jsp:include page="/modern/components/nav-header.jsp" />

    <!-- Hero banner (above the grid, full-width) -->
    <div class="vs-hero">
        <%@ include file="/modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="vs-main">

        <!-- Shared sidebar (highlight current tool) -->
        <% request.setAttribute("activeService", "transcribe"); %>
        <jsp:include page="/video/partials/sidebar.jsp" />

        <!-- ── Workspace: active service ───────────────────────────── -->
        <section class="vs-workspace">

            <!-- ── Transcribe view ────────────────────────────────── -->
            <div class="vs-view active" data-service="transcribe" role="tabpanel">
                <header class="vs-view-header">
                    <div>
                        <h1 class="vs-view-title">Free AI Video Transcription &amp; Translation</h1>
                        <p class="vs-view-subtitle">
                            Upload a video or audio file and get an accurate transcript — or translate
                            it straight to English. Export as plain text or subtitles.
                        </p>
                    </div>
                </header>

                <!-- Drop zone -->
                <div class="vs-card">
                    <p class="vs-card-title">1 &middot; Upload</p>
                    <label class="vs-drop">
                        <svg class="vs-drop-icon" width="42" height="42" fill="currentColor" viewBox="0 0 16 16" aria-hidden="true">
                            <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                            <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z"/>
                        </svg>
                        <p class="vs-drop-title">Drop a video or audio file</p>
                        <p class="vs-drop-hint">
                            or <span class="vs-drop-link">browse</span> &middot;
                            MP4, MOV, WebM, MP3, WAV, M4A, OGG, FLAC &middot;
                            up to 200 MB raw / 25 MB extracted
                        </p>
                        <input type="file" class="vs-drop-file"
                               accept="video/*,audio/*,.mp4,.mov,.webm,.mkv,.mp3,.wav,.m4a,.ogg,.flac" />
                    </label>

                    <div class="vs-preview" aria-live="polite">
                        <div class="vs-preview-icon">
                            <svg width="22" height="22" fill="currentColor" viewBox="0 0 16 16" aria-hidden="true">
                                <path d="M6 3.5A1.5 1.5 0 0 1 7.5 2h1A1.5 1.5 0 0 1 10 3.5v9a1.5 1.5 0 0 1-1.5 1.5h-1A1.5 1.5 0 0 1 6 12.5v-9zM3.5 5A1.5 1.5 0 0 0 2 6.5v3A1.5 1.5 0 0 0 3.5 11h1A1.5 1.5 0 0 0 6 9.5v-3A1.5 1.5 0 0 0 4.5 5h-1zm9 0A1.5 1.5 0 0 0 11 6.5v3a1.5 1.5 0 0 0 1.5 1.5h1A1.5 1.5 0 0 0 15 9.5v-3A1.5 1.5 0 0 0 13.5 5h-1z"/>
                            </svg>
                        </div>
                        <div class="vs-preview-meta">
                            <p class="vs-preview-name"></p>
                            <p class="vs-preview-stats"></p>
                        </div>
                        <button type="button" class="vs-preview-remove">Remove</button>
                    </div>
                </div>

                <!-- Options -->
                <div class="vs-card">
                    <p class="vs-card-title">2 &middot; Options</p>
                    <div class="vs-options">
                        <div class="vs-option">
                            <label for="vs-task">Task</label>
                            <select id="vs-task">
                                <option value="transcribe">Transcribe (keep original language)</option>
                                <option value="translate">Translate to English</option>
                            </select>
                        </div>
                        <div class="vs-option">
                            <label for="vs-language">Source language</label>
                            <input type="text" id="vs-language" placeholder="auto-detect" maxlength="24" />
                        </div>
                        <div class="vs-option">
                            <label for="vs-output-fmt">Output format</label>
                            <select id="vs-output-fmt">
                                <option value="txt">Plain text (TXT)</option>
                                <option value="srt">Subtitles (SRT)</option>
                                <option value="vtt">Web subtitles (VTT)</option>
                                <option value="json">Raw JSON</option>
                            </select>
                        </div>
                    </div>

                    <div class="vs-actions">
                        <button id="vs-transcribe-submit" class="vs-btn vs-btn-primary" type="button" disabled>
                            Transcribe
                        </button>
                    </div>

                    <!-- Horizontal progress bar mounts here (AIProgressBar.attach) -->
                    <div class="vs-progress-host"></div>

                    <div class="vs-error" role="alert"></div>
                </div>

                <!-- Output -->
                <div class="vs-output" aria-live="polite">
                    <div class="vs-output-header">
                        <p class="vs-output-title">Result</p>
                        <div class="vs-output-actions">
                            <button id="vs-output-copy" class="vs-btn" type="button">Copy</button>
                            <button id="vs-output-download" class="vs-btn" type="button">Download</button>
                        </div>
                    </div>
                    <div class="vs-output-body"></div>
                    <div class="vs-output-meta"></div>
                </div>
            </div>

            <!-- In-content ad: shown under workspace on screens <1280px where the rail is hidden -->
            <div class="vs-inline-ad">
                <%@ include file="/modern/ads/ad-in-content-mid.jsp" %>
            </div>

        </section>

        <!-- ── Right ad rail (desktop ≥1280px only) ───────────────── -->
        <aside class="vs-rail" aria-label="Advertisements">
            <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Ads -->
    <%@ include file="/modern/ads/ad-sticky-footer.jsp" %>

    <!-- Analytics -->
    <%@ include file="/modern/components/analytics.jsp" %>

    <!-- Scripts (order matters: progress bar + extractor before the controller) -->
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/ai-progress-bar.js" defer></script>
    <script src="<%=request.getContextPath()%>/video/js/video-audio-extract.js" defer></script>
    <script src="<%=request.getContextPath()%>/video/js/video-studio.js" defer></script>
</body>
</html>
