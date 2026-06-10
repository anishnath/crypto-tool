<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">

    <!-- Critical CSS — Wildflower Meadow design system base -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:oklch(0.292 0.046 164.9);background:oklch(0.982 0.006 137.8);margin:0}

        :root {
            --background: oklch(0.982 0.006 137.8);
            --foreground: oklch(0.292 0.046 164.9);
            --card: oklch(1.000 0.000 89.9);
            --card-foreground: oklch(0.292 0.046 164.9);
            --popover: oklch(1.000 0.000 89.9);
            --popover-foreground: oklch(0.292 0.046 164.9);
            --primary: oklch(0.605 0.215 27.7);
            --primary-foreground: oklch(0.982 0.006 137.8);
            --secondary: oklch(0.993 0.003 128.5);
            --secondary-foreground: oklch(0.292 0.046 164.9);
            --muted: oklch(0.996 0.003 128.5);
            --muted-foreground: oklch(0.292 0.046 164.9);
            --accent: oklch(0.536 0.190 259.9);
            --accent-foreground: oklch(0.292 0.046 164.9);
            --destructive: oklch(0.605 0.215 27.7);
            --border: oklch(0.922 0.004 134.8);
            --input: oklch(0.922 0.004 134.8);
            --ring: oklch(0.876 0.171 91.7);
            --radius: 0.5rem;

            --primary-dark: oklch(0.486 0.190 27.7);
            --bg-primary: var(--card);
            --bg-secondary: var(--background);
            --bg-tertiary: var(--muted);
            --text-primary: var(--foreground);
            --text-secondary: oklch(0.446 0.037 164.7);
            --text-muted: oklch(0.560 0.040 164.7);
        }

        .dark,
        [data-theme="dark"] {
            --background: oklch(0.292 0.046 164.9);
            --foreground: oklch(0.982 0.006 137.8);
            --card: oklch(0.292 0.046 164.9);
            --card-foreground: oklch(0.982 0.006 137.8);
            --popover: oklch(0.292 0.046 164.9);
            --popover-foreground: oklch(0.982 0.006 137.8);
            --primary: oklch(0.876 0.171 91.7);
            --primary-foreground: oklch(0.292 0.046 164.9);
            --secondary: oklch(0.446 0.037 164.7);
            --secondary-foreground: oklch(0.982 0.006 137.8);
            --muted: oklch(0.446 0.037 164.7);
            --muted-foreground: oklch(0.959 0.009 134.9);
            --accent: oklch(0.536 0.190 259.9);
            --destructive: oklch(0.605 0.215 27.7);
            --border: oklch(1 0 0 / 12%);
            --input: oklch(1 0 0 / 16%);
            --ring: oklch(0.876 0.171 91.7);
            --radius: 0.5rem;

            --primary-dark: oklch(0.760 0.171 91.7);
            --bg-primary: var(--card);
            --bg-secondary: var(--background);
            --bg-tertiary: var(--muted);
            --text-primary: var(--foreground);
            --text-secondary: oklch(0.959 0.009 134.9);
            --text-muted: oklch(0.820 0.020 134.9);
        }
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Video Resizer & Cropper Online - Free" />
        <jsp:param name="toolDescription" value="Resize and crop videos online for free. Auto-crop for Instagram Reels, TikTok, YouTube Shorts with 9:16, 16:9, 1:1 ratios. MP4 / MOV / WEBM, no watermarks, 100% in-browser." />
        <jsp:param name="toolCategory" value="Multimedia" />
        <jsp:param name="toolUrl" value="video-resizer.jsp" />
        <jsp:param name="toolKeywords" value="video resizer online, resize video, crop video, video cropper, resize video for instagram, resize video for tiktok, video aspect ratio changer, 9:16 video, instagram reels resizer, youtube shorts resizer, compress video, free video resizer, video resolution changer, mp4 resizer, vertical video maker" />
        <jsp:param name="toolImage" value="video-resizer-tool.png" />
        <jsp:param name="toolFeatures" value="Resize videos to 1080p / 720p / 480p / 360p,One-click social presets (Reels TikTok Shorts),Aspect ratios 9:16 16:9 1:1 4:3 4:5 21:9,Real-time video preview,MP4 MOV AVI WEBM MKV input,Custom width and height control,Quality control (High Medium Low),100% client-side — videos never leave your device,No watermarks,Instant download" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Upload video|Click Select Video File (or drag &amp; drop) and choose an MP4, MOV, AVI, WEBM, or MKV file.,Pick a preset|Choose a social preset like Instagram Reel, TikTok, or YouTube Short — or set width/height manually.,Adjust settings|Fine-tune dimensions, lock or unlock aspect ratio, and pick output quality and format.,Process|Click Resize &amp; Crop Video — everything runs in your browser, nothing is uploaded.,Download|When processing finishes, download the resized video instantly." />
        <jsp:param name="faq1q" value="Is this video resizer really free?" />
        <jsp:param name="faq1a" value="Yes, completely free with no hidden costs, watermarks, or usage limits." />
        <jsp:param name="faq2q" value="Do you upload my videos to your servers?" />
        <jsp:param name="faq2a" value="No. All processing happens in your browser using your device's CPU — your videos never leave your computer." />
        <jsp:param name="faq3q" value="What's the maximum video size?" />
        <jsp:param name="faq3a" value="You can process videos up to about 500MB. Larger or longer videos take more time depending on your device." />
        <jsp:param name="faq4q" value="Will resizing reduce video quality?" />
        <jsp:param name="faq4a" value="The tool uses high-quality encoding to preserve as much detail as possible. Choose the High quality setting for minimal loss." />
        <jsp:param name="faq5q" value="Which output format should I use?" />
        <jsp:param name="faq5a" value="WebM produces smaller files and is widely supported in-browser. MP4 offers the best compatibility across devices, but in-browser MP4 recording is limited — WebM is used as a fallback when MP4 isn't available." />
        <jsp:param name="faq6q" value="What aspect ratio should I pick for each platform?" />
        <jsp:param name="faq6a" value="Use 9:16 vertical (1080x1920) for Reels, TikTok, Shorts, and Stories; 16:9 horizontal (1920x1080) for YouTube; and 1:1 square (1080x1080) for Instagram and Facebook feed posts." />
        <jsp:param name="faq7q" value="Can I batch process multiple videos?" />
        <jsp:param name="faq7a" value="Currently you process one video at a time for the best performance and lowest memory use." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* Video-resizer accent — coral / magenta brand identity */
        :root {
            --tool-primary: #f5576c;
            --tool-primary-dark: #e04357;
            --tool-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --tool-light: #fff1f3;
            --tool-ring: rgba(245, 87, 108, 0.18);
        }
        .dark, [data-theme="dark"] {
            --tool-primary: #ff8094;
            --tool-primary-dark: #f5576c;
            --tool-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --tool-light: rgba(245, 87, 108, 0.16);
            --tool-ring: rgba(245, 87, 108, 0.30);
        }

        /* ---- Compact page header ---- */
        .tool-page-header { padding: 0.5rem 1rem !important; min-height: 0 !important; background: linear-gradient(135deg, oklch(0.993 0.002 145.6) 0%, oklch(0.982 0.006 137.8) 100%); border-bottom: 1px solid var(--border); }
        .tool-page-header-inner { display: flex !important; align-items: center !important; gap: 0.75rem; flex-wrap: wrap; padding: 0 !important; margin: 0 auto !important; max-width: 1400px; }
        .tool-page-header-inner > div:first-child { display: flex; align-items: baseline; gap: 0.75rem; flex-wrap: wrap; min-width: 0; }
        .tool-page-title { font-size: 1.05rem !important; font-weight: 700 !important; margin: 0 !important; line-height: 1.25 !important; letter-spacing: -0.01em; color: var(--foreground); }
        .tool-breadcrumbs { font-size: 0.72rem !important; line-height: 1.25 !important; margin: 0 !important; color: var(--text-secondary); }
        .tool-breadcrumbs a { color: var(--tool-primary); text-decoration: none; }
        .tool-breadcrumbs a:hover { text-decoration: underline; }
        .tool-header-pitch { font-size: 0.72rem; line-height: 1.25; color: var(--text-secondary); padding-left: 0.6rem; margin-left: 0.6rem; border-left: 1px solid var(--border); white-space: nowrap; }
        .tool-header-pitch a { color: var(--tool-primary); font-weight: 600; text-decoration: none; margin-left: 0.25rem; }
        .tool-header-pitch a:hover { text-decoration: underline; }
        .tool-page-badges { display: flex; gap: 0.3rem; margin-left: auto; flex-wrap: wrap; }
        .tool-badge { padding: 0.12rem 0.45rem !important; font-size: 0.68rem !important; line-height: 1.3 !important; border-radius: 9999px !important; display: inline-flex; align-items: center; gap: 0.25rem; background: var(--tool-light); color: var(--tool-primary-dark); border: 1px solid rgba(245,87,108,0.22); font-weight: 600; }
        .dark .tool-badge, [data-theme="dark"] .tool-badge { color: var(--tool-primary); border-color: rgba(245,87,108,0.32); }
        @media (max-width: 640px) {
            .tool-header-pitch { display: block; padding-left: 0; margin-left: 0; border-left: none; white-space: normal; margin-top: 0.15rem; }
            .tool-page-title { font-size: 0.95rem !important; }
            .tool-page-badges { margin-left: 0; }
        }
        .tool-description-section { padding: 0.5rem 1rem !important; }

        /* ---- Card spacing in input column ---- */
        .tool-input-column .tool-card { margin-bottom: 1rem; }

        /* ---- Upload area ---- */
        .upload-area { border: 2px dashed var(--tool-primary); border-radius: 0.75rem; padding: 1.75rem 1rem; text-align: center; background: var(--tool-light); cursor: pointer; transition: all 0.25s ease; }
        .upload-area:hover { border-color: var(--tool-primary-dark); transform: translateY(-1px); }
        .upload-area.dragover { transform: scale(1.01); border-color: var(--tool-primary-dark); box-shadow: 0 0 0 4px var(--tool-ring); }
        .upload-area svg { width: 52px; height: 52px; margin-bottom: 0.75rem; color: var(--tool-primary); }
        .upload-area h5 { font-size: 1.05rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.4rem; }
        .upload-area p { color: var(--text-muted); font-size: 0.82rem; margin-bottom: 1rem; }
        .btn-upload { background: var(--tool-gradient); color: #fff; border: none; padding: 0.65rem 1.6rem; font-weight: 600; font-size: 0.92rem; border-radius: 999px; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .btn-upload:hover { transform: translateY(-1px); box-shadow: 0 6px 18px var(--tool-ring); }

        /* ---- Presets ---- */
        .preset-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.5rem; }
        .preset-btn { padding: 0.6rem 0.4rem; border: 1.5px solid var(--border); background: var(--bg-primary); border-radius: 0.6rem; cursor: pointer; transition: all 0.18s; text-align: center; }
        .preset-btn:hover { border-color: var(--tool-primary); background: var(--tool-light); transform: translateY(-1px); }
        .preset-btn.active { border-color: var(--tool-primary); background: var(--tool-light); box-shadow: 0 0 0 3px var(--tool-ring); }
        .preset-btn .aspect-icon { font-size: 1.3rem; margin-bottom: 0.2rem; }
        .preset-btn strong { display: block; color: var(--tool-primary-dark); font-size: 0.82rem; font-weight: 700; margin-bottom: 0.15rem; }
        .dark .preset-btn strong, [data-theme="dark"] .preset-btn strong { color: var(--tool-primary); }
        .preset-btn small { color: var(--text-muted); font-size: 0.7rem; display: block; }
        .preset-btn * { pointer-events: none; }

        /* ---- Controls ---- */
        .control-group { margin-bottom: 1rem; }
        .control-group > label { font-size: 0.72rem; font-weight: 700; letter-spacing: 0.04em; text-transform: uppercase; color: var(--text-muted); margin-bottom: 0.35rem; display: block; }
        .slider-container { display: flex; gap: 0.5rem; align-items: center; }
        .slider-container input[type="range"] { flex: 1; height: 6px; -webkit-appearance: none; appearance: none; background: var(--tool-gradient); border-radius: 5px; outline: none; }
        .slider-container input[type="range"]::-webkit-slider-thumb { -webkit-appearance: none; width: 18px; height: 18px; background: #fff; border: 3px solid var(--tool-primary); border-radius: 50%; cursor: pointer; box-shadow: 0 2px 6px rgba(0,0,0,0.2); }
        .slider-container input[type="number"] { width: 78px; padding: 0.4rem; border: 1.5px solid var(--border); border-radius: 0.5rem; font-size: 0.85rem; text-align: center; background: var(--bg-primary); color: var(--text-primary); font-family: 'JetBrains Mono', monospace; }
        .slider-container input[type="number"]:focus { border-color: var(--tool-primary); outline: none; box-shadow: 0 0 0 3px var(--tool-ring); }
        .aspect-toggle { display: flex; align-items: center; gap: 0.5rem; padding: 0.55rem 0.65rem; background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 0.5rem; margin-bottom: 0.9rem; }
        .aspect-toggle input[type="checkbox"] { width: 17px; height: 17px; cursor: pointer; accent-color: var(--tool-primary); }
        .aspect-toggle label { font-size: 0.82rem; font-weight: 600; color: var(--text-primary); margin: 0; cursor: pointer; }
        .quality-selector { display: flex; gap: 0.5rem; }
        .quality-btn { flex: 1; padding: 0.5rem; border: 1.5px solid var(--border); background: var(--bg-primary); border-radius: 0.5rem; cursor: pointer; transition: all 0.18s; font-size: 0.82rem; font-weight: 600; text-align: center; color: var(--text-secondary); font-family: inherit; }
        .quality-btn:hover { border-color: var(--tool-primary); background: var(--tool-light); }
        .quality-btn.active { border-color: var(--tool-primary); background: var(--tool-light); color: var(--tool-primary-dark); box-shadow: 0 0 0 3px var(--tool-ring); }
        .dark .quality-btn.active, [data-theme="dark"] .quality-btn.active { color: var(--tool-primary); }
        .format-btn small { font-weight: 500; color: var(--text-muted); }
        .format-btn * { pointer-events: none; }

        /* ---- Preview ---- */
        .video-container { position: relative; background: #000; border-radius: 0.6rem; overflow: hidden; min-height: 360px; max-height: 70vh; display: flex; align-items: center; justify-content: center; }
        .video-container video { max-width: 100%; max-height: 70vh; width: auto; height: auto; display: block; }
        .welcome-screen { text-align: center; padding: 3rem 1rem; color: rgba(255,255,255,0.85); }
        .welcome-screen .welcome-icon { font-size: 3.5rem; margin-bottom: 0.75rem; }
        .welcome-screen h4 { color: #fff; font-weight: 700; margin-bottom: 0.6rem; font-size: 1.15rem; }
        .welcome-screen p { font-size: 0.85rem; line-height: 1.6; color: rgba(255,255,255,0.7); }
        .processing-overlay { position: absolute; inset: 0; background: rgba(0,0,0,0.85); display: flex; flex-direction: column; align-items: center; justify-content: center; color: #fff; z-index: 10; padding: 1rem; }
        .spinner { border: 4px solid rgba(255,255,255,0.25); border-top: 4px solid var(--tool-primary); border-radius: 50%; width: 48px; height: 48px; animation: vrspin 1s linear infinite; margin-bottom: 1rem; }
        @keyframes vrspin { to { transform: rotate(360deg); } }
        .processing-overlay h5 { font-size: 1rem; font-weight: 700; margin: 0; }
        .progress-bar-container { width: 80%; max-width: 320px; height: 8px; background: rgba(255,255,255,0.2); border-radius: 4px; overflow: hidden; margin-top: 1rem; }
        .progress-bar-fill { height: 100%; background: var(--tool-gradient); width: 0%; transition: width 0.3s; }
        .video-info { margin-top: 1rem; padding: 0.75rem 0.85rem; background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 0.5rem; font-size: 0.82rem; }
        .video-info strong { color: var(--text-secondary); }
        .video-info .info-row { display: flex; justify-content: space-between; gap: 1rem; flex-wrap: wrap; }
        .video-info .info-row + .info-row { margin-top: 0.35rem; }
        .video-info .info-row span span { color: var(--text-primary); font-family: 'JetBrains Mono', monospace; }

        /* ---- Action buttons ---- */
        .action-buttons { display: flex; gap: 0.6rem; margin-top: 1.25rem; flex-wrap: wrap; }
        .btn-process, .btn-download, .btn-reset { border: none; padding: 0.7rem 1.3rem; font-weight: 600; font-size: 0.92rem; border-radius: 0.6rem; cursor: pointer; transition: all 0.2s; font-family: inherit; color: #fff; }
        .btn-process { flex: 1; min-width: 160px; background: var(--tool-gradient); }
        .btn-process:hover { transform: translateY(-1px); box-shadow: 0 6px 18px var(--tool-ring); }
        .btn-process:disabled { opacity: 0.6; cursor: not-allowed; transform: none; box-shadow: none; }
        .btn-download { flex: 1; min-width: 160px; background: #16a34a; }
        .btn-download:hover { background: #15803d; transform: translateY(-1px); }
        .btn-reset { background: var(--bg-tertiary); color: var(--text-secondary); border: 1px solid var(--border); }
        .btn-reset:hover { color: var(--tool-primary); border-color: var(--tool-primary); }
        @media (max-width: 560px) { .action-buttons { flex-direction: column; } .btn-process, .btn-download { min-width: 0; } }

        /* ---- About content section ---- */
        .tool-content-section { padding: 2rem 1.5rem; max-width: 1200px; margin: 0 auto; }
        .tool-content-container { max-width: 900px; margin: 0 auto; }
        .tool-content-section .tool-card { background: var(--bg-primary); border: 1px solid var(--border); border-radius: 1rem; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .tool-content-section .tool-card-header { background: var(--tool-gradient); color: #fff; padding: 1rem 1.5rem; display: flex; align-items: center; gap: 0.5rem; font-weight: 600; font-size: 1.1rem; }
        .tool-content-section .tool-card-body { padding: 1.5rem; }
        .tool-section-title { font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-bottom: 1rem; }
        .tool-subsection-title { font-size: 1rem; font-weight: 600; color: var(--text-primary); margin: 1.5rem 0 0.75rem; }
        .tool-feature-list, .tool-steps-list { padding-left: 1.25rem; margin-bottom: 1rem; }
        .tool-feature-list li, .tool-steps-list li { margin-bottom: 0.5rem; color: var(--text-secondary); line-height: 1.6; }
        .tool-feature-list li strong, .tool-steps-list li strong { color: var(--text-primary); }
        .tool-use-cases-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        @media (max-width: 600px) { .tool-use-cases-grid { grid-template-columns: 1fr; } }
        .tool-use-cases-grid ul { padding-left: 1.25rem; margin: 0; }
        .tool-use-cases-grid li { color: var(--text-secondary); margin-bottom: 0.375rem; }
        .tool-highlight-box { background: var(--tool-light); border-left: 4px solid var(--tool-primary); padding: 1rem 1.25rem; border-radius: 0.5rem; margin-top: 1.5rem; color: var(--text-secondary); }
        .tool-highlight-box strong { color: var(--tool-primary-dark); }
        .dark .tool-highlight-box strong, [data-theme="dark"] .tool-highlight-box strong { color: var(--tool-primary); }
        .tool-content-section p { color: var(--text-secondary); line-height: 1.6; }
        .tool-content-section code { background: rgba(245,87,108,0.12); padding: 0.125rem 0.375rem; border-radius: 0.25rem; font-size: 0.875rem; color: var(--tool-primary-dark); }
        .dark .tool-content-section .tool-card, [data-theme="dark"] .tool-content-section .tool-card { background: var(--card); border-color: var(--border); }
        [data-theme="dark"] .tool-section-title,
        [data-theme="dark"] .tool-subsection-title,
        [data-theme="dark"] .tool-feature-list li strong,
        [data-theme="dark"] .tool-steps-list li strong { color: var(--text-primary); }
        [data-theme="dark"] .tool-feature-list li,
        [data-theme="dark"] .tool-steps-list li,
        [data-theme="dark"] .tool-use-cases-grid li,
        [data-theme="dark"] .tool-content-section p,
        [data-theme="dark"] .tool-highlight-box { color: var(--text-secondary); }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Video Resizer &amp; Cropper</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/">Home</a> /
                    <span>Video Resizer</span>
                </nav>
                <span class="tool-header-pitch">
                    Reels · TikTok · Shorts — <a href="#about">how it works &rarr;</a>
                </span>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">100% in-browser</span>
                <span class="tool-badge">No watermark</span>
                <span class="tool-badge">9:16 · 1:1 · 16:9</span>
                <span class="tool-badge">Free</span>
            </div>
        </div>
    </header>

    <!-- Top Ad Slot -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-ad" style="width:100%;">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Three-Column Layout: Controls | Preview | Ads -->
    <main class="tool-page-container">

        <!-- INPUT COLUMN: upload + presets + settings -->
        <div class="tool-input-column">
            <!-- Upload card -->
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z"/></svg>
                    Upload Video
                </div>
                <div class="tool-card-body">
                    <div class="upload-area" id="uploadArea">
                        <svg fill="currentColor" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                            <path d="M6.271 5.055a.5.5 0 0 1 .52.038l3.5 2.5a.5.5 0 0 1 0 .814l-3.5 2.5A.5.5 0 0 1 6 10.5v-5a.5.5 0 0 1 .271-.445z"/>
                        </svg>
                        <h5>Drop a video here</h5>
                        <p>MP4, MOV, AVI, WEBM, MKV &middot; up to 500MB</p>
                        <input type="file" id="videoInput" accept="video/*" hidden>
                        <button class="btn-upload" onclick="document.getElementById('videoInput').click()">
                            Select Video File
                        </button>
                    </div>
                </div>
            </div>

            <!-- Social Media Presets -->
            <div class="tool-card" id="presetsSection" style="display: none;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M11 2a3 3 0 0 1 3 3v6a3 3 0 0 1-3 3H5a3 3 0 0 1-3-3V5a3 3 0 0 1 3-3h6zm0 1H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2z"/><path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5z"/></svg>
                    Social Media Presets
                </div>
                <div class="tool-card-body">
                    <div class="preset-grid">
                        <div class="preset-btn" onclick="applyPreset('instagram-reel')"><div class="aspect-icon">&#128241;</div><strong>Instagram Reel</strong><small>1080&times;1920 (9:16)</small></div>
                        <div class="preset-btn" onclick="applyPreset('tiktok')"><div class="aspect-icon">&#127925;</div><strong>TikTok</strong><small>1080&times;1920 (9:16)</small></div>
                        <div class="preset-btn" onclick="applyPreset('youtube-short')"><div class="aspect-icon">&#9654;&#65039;</div><strong>YouTube Short</strong><small>1080&times;1920 (9:16)</small></div>
                        <div class="preset-btn" onclick="applyPreset('instagram-post')"><div class="aspect-icon">&#128247;</div><strong>Instagram Post</strong><small>1080&times;1080 (1:1)</small></div>
                        <div class="preset-btn" onclick="applyPreset('youtube')"><div class="aspect-icon">&#127909;</div><strong>YouTube</strong><small>1920&times;1080 (16:9)</small></div>
                        <div class="preset-btn" onclick="applyPreset('facebook')"><div class="aspect-icon">&#128077;</div><strong>Facebook</strong><small>1280&times;720 (16:9)</small></div>
                        <div class="preset-btn" onclick="applyPreset('twitter')"><div class="aspect-icon">&#128038;</div><strong>Twitter / X</strong><small>1280&times;720 (16:9)</small></div>
                        <div class="preset-btn" onclick="applyPreset('instagram-story')"><div class="aspect-icon">&#128214;</div><strong>IG Story</strong><small>1080&times;1920 (9:16)</small></div>
                    </div>
                </div>
            </div>

            <!-- Resize Settings -->
            <div class="tool-card" id="controlsSection" style="display: none;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319z"/></svg>
                    Resize Settings
                </div>
                <div class="tool-card-body">
                    <!-- Aspect Ratio Lock -->
                    <div class="aspect-toggle">
                        <input type="checkbox" id="aspectRatioLock" checked onchange="toggleAspectRatio()">
                        <label for="aspectRatioLock">&#128274; Lock aspect ratio</label>
                    </div>

                    <!-- Width -->
                    <div class="control-group">
                        <label>Width (px)</label>
                        <div class="slider-container">
                            <input type="range" id="widthSlider" min="240" max="1920" value="1080" step="10" oninput="updateWidth(this.value)">
                            <input type="number" id="widthInput" min="240" max="1920" value="1080" onchange="updateWidth(this.value)">
                        </div>
                    </div>

                    <!-- Height -->
                    <div class="control-group">
                        <label>Height (px)</label>
                        <div class="slider-container">
                            <input type="range" id="heightSlider" min="240" max="1920" value="1920" step="10" oninput="updateHeight(this.value)">
                            <input type="number" id="heightInput" min="240" max="1920" value="1920" onchange="updateHeight(this.value)">
                        </div>
                    </div>

                    <!-- Quality -->
                    <div class="control-group">
                        <label>Output Quality</label>
                        <div class="quality-selector">
                            <button class="quality-btn" onclick="setQuality('low')">Low</button>
                            <button class="quality-btn active" onclick="setQuality('medium')">Medium</button>
                            <button class="quality-btn" onclick="setQuality('high')">High</button>
                        </div>
                    </div>

                    <!-- Format -->
                    <div class="control-group">
                        <label>Output Format</label>
                        <div class="quality-selector format-selector">
                            <button class="quality-btn format-btn active" onclick="setFormat('mp4')"><strong>MP4</strong><br><small>Best compatibility</small></button>
                            <button class="quality-btn format-btn" onclick="setFormat('webm')"><strong>WebM</strong><br><small>Smaller size</small></button>
                        </div>
                        <p class="tool-highlight-box" style="margin-top:0.75rem;font-size:0.75rem;padding:0.6rem 0.8rem;">MP4 is the default for best compatibility. If your browser can't record MP4, WebM is used automatically.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN: preview -->
        <div class="tool-output-column">
            <div class="tool-card" style="flex:1;display:flex;flex-direction:column;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M0 5a2 2 0 0 1 2-2h7.5a2 2 0 0 1 1.983 1.738l3.11-1.382A1 1 0 0 1 16 4.269v7.462a1 1 0 0 1-1.406.913l-3.111-1.382A2 2 0 0 1 9.5 13H2a2 2 0 0 1-2-2V5z"/></svg>
                    Video Preview
                    <span id="videoStatus" style="margin-left:auto;font-size:0.75rem;font-weight:500;color:rgba(255,255,255,0.9);"></span>
                </div>
                <div class="tool-card-body">
                    <div class="video-container" id="videoContainer">
                        <!-- Welcome Screen -->
                        <div class="welcome-screen" id="welcomeScreen">
                            <div class="welcome-icon">&#127916;</div>
                            <h4>Upload a video to get started</h4>
                            <p>Resize and crop for social platforms.<br>Supports MP4, MOV, AVI, WEBM, MKV.</p>
                        </div>

                        <!-- Original Video -->
                        <video id="originalVideo" controls style="display: none;"></video>

                        <!-- Processing Overlay -->
                        <div class="processing-overlay" id="processingOverlay" style="display: none;">
                            <div class="spinner"></div>
                            <h5 id="processingText">Processing Video…</h5>
                            <p id="processingStatus" style="opacity:0.8;font-size:0.85rem;margin-top:0.25rem;"></p>
                            <div class="progress-bar-container"><div class="progress-bar-fill" id="progressBar"></div></div>
                            <p id="progressText" style="margin-top:0.5rem;font-size:0.8rem;opacity:0.7;">0%</p>
                        </div>
                    </div>

                    <!-- Video Info -->
                    <div class="video-info" id="videoInfo" style="display: none;">
                        <div class="info-row">
                            <span><strong>Original:</strong> <span id="originalDimensions">-</span></span>
                            <span><strong>Duration:</strong> <span id="videoDuration">-</span></span>
                        </div>
                        <div class="info-row">
                            <span><strong>New size:</strong> <span id="newDimensions">-</span></span>
                            <span><strong>File size:</strong> <span id="fileSize">-</span></span>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons" id="actionButtons" style="display: none;">
                        <button class="btn-process" id="processBtn" onclick="processVideo()">&#10024; Resize &amp; Crop Video</button>
                        <button class="btn-download" id="downloadBtn" onclick="downloadVideo()" style="display: none;">&#11015;&#65039; Download Video</button>
                        <button class="btn-reset" onclick="resetTool()">&#128260; Reset</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <aside class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </aside>

    </main>

    <!-- Mobile Ad -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="video-resizer.jsp"/>
        <jsp:param name="category" value="Multimedia"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- About -->
    <section class="tool-content-section" id="about">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/></svg>
                    About the Video Resizer
                </div>
                <div class="tool-card-body">
                    <h2 class="tool-section-title">Resize &amp; Crop Videos for Social Media — Free, In Your Browser</h2>
                    <p>Convert any clip into the right size and aspect ratio for Instagram Reels, TikTok, YouTube Shorts, and more. Everything runs locally in your browser via the canvas + MediaRecorder APIs — your video is never uploaded to a server, there are no watermarks, and it's completely free.</p>

                    <h3 class="tool-subsection-title">Key Features</h3>
                    <ul class="tool-feature-list">
                        <li><strong>One-click social presets:</strong> Reels, TikTok, Shorts, Stories, square posts, and 16:9</li>
                        <li><strong>Any aspect ratio:</strong> 9:16, 16:9, 1:1, 4:3, 4:5, 21:9 — or set custom width/height</li>
                        <li><strong>Real-time preview</strong> with original vs. new dimensions and estimated file size</li>
                        <li><strong>Quality &amp; format control:</strong> High / Medium / Low, WebM or MP4 output</li>
                        <li><strong>Private by design:</strong> 100% client-side, no uploads, no watermark</li>
                    </ul>

                    <h3 class="tool-subsection-title">Common Use Cases</h3>
                    <div class="tool-use-cases-grid">
                        <ul>
                            <li>Landscape → 9:16 vertical for Reels &amp; TikTok</li>
                            <li>YouTube Shorts (1080&times;1920)</li>
                            <li>Square videos for the Instagram feed</li>
                        </ul>
                        <ul>
                            <li>Standard 16:9 for YouTube (1920&times;1080)</li>
                            <li>Facebook &amp; X video posts (1280&times;720)</li>
                            <li>Full-screen Instagram / Snapchat Stories</li>
                        </ul>
                    </div>

                    <h3 class="tool-subsection-title">How to Use</h3>
                    <ol class="tool-steps-list">
                        <li><strong>Upload:</strong> drop a file or click <strong>Select Video File</strong> (<code>MP4 / MOV / AVI / WEBM / MKV</code>)</li>
                        <li><strong>Pick a preset</strong> like Instagram Reel or TikTok — or set width &amp; height manually</li>
                        <li><strong>Adjust:</strong> lock/unlock aspect ratio and choose quality and format</li>
                        <li><strong>Process &amp; download:</strong> click <strong>Resize &amp; Crop Video</strong>, then download the result</li>
                    </ol>

                    <p class="tool-highlight-box"><strong>Why in-browser?</strong> Unlike desktop apps that need installing or cloud services that upload your footage, this tool processes everything on your own device — faster turnaround, full privacy, and no file leaving your computer.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Tool Utilities -->
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

    <!-- Video resizer engine -->
    <script src="<%=request.getContextPath()%>/js/video-resizer-simple.js"></script>
</body>
</html>
