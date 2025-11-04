<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Enable cross-origin isolation so SharedArrayBuffer is available if needed
  response.setHeader("Cross-Origin-Opener-Policy", "same-origin");
  response.setHeader("Cross-Origin-Embedder-Policy", "require-corp");
  // Optional hardening for assets served from same origin
  response.setHeader("Cross-Origin-Resource-Policy", "same-origin");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free Online Video Trimmer & Cutter",
      "description": "Trim and cut videos online in your browser. No upload required. Supports MP4, WebM, AVI, MOV. Private and secure using FFmpeg.wasm.",
      "url": "https://8gwifi.org/video-trim.jsp",
      "applicationCategory": "MultimediaApplication",
      "operatingSystem": "Web Browser",
      "offers": {"@type": "Offer","price": "0","priceCurrency": "USD"},
      "creator": {"@type": "Organization","name": "8gwifi.org"},
      "keywords": "trim video online, cut video online, video trimmer, video cutter, mp4 trimmer, webm trimmer, online video editor, no upload video editor"
    }
    </script>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {"@type":"Question","name":"How do I trim a video online?","acceptedAnswer":{"@type":"Answer","text":"Upload a video, set the start and end time, then click Process Video to cut the clip in your browser."}},
        {"@type":"Question","name":"Do I need to upload my video?","acceptedAnswer":{"@type":"Answer","text":"No. All processing occurs locally in your browser using WebAssembly (FFmpeg.wasm). Your video never leaves your device."}},
        {"@type":"Question","name":"Which formats are supported?","acceptedAnswer":{"@type":"Answer","text":"MP4, WebM, AVI, MOV, MKV and more. Output can be MP4, WebM or audio-only when Extract Audio is enabled."}},
        {"@type":"Question","name":"Is it free and secure?","acceptedAnswer":{"@type":"Answer","text":"Yes. It’s free and runs fully client‑side, so your content stays private and secure."}}
      ]
    }
    </script>

    <title>Trim Video Online – Free Video Trimmer & Cutter (No Upload) | 8gwifi.org</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Trim and cut videos online for free. No upload required. Fast, secure, client‑side video trimmer for MP4, WebM, AVI, MOV with start/end selection and export.">
    <meta name="keywords" content="trim video online, cut video online, free video trimmer, video cutter, mp4 trimmer, webm trimmer, browser video editor, no upload video editor, ffmpeg wasm, online video cutting tool">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <!-- OpenGraph -->
    <meta property="og:title" content="Trim Video Online – Free Video Trimmer (No Upload)">
    <meta property="og:description" content="Cut videos in your browser. No upload. Supports MP4, WebM, AVI, MOV.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/video-trim.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Free Online Video Trimmer & Cutter Tool">
    <meta name="twitter:description" content="Trim videos online in your browser without uploading. Fast and secure.">

    <link rel="canonical" href="https://8gwifi.org/video-trim.jsp">

    <%@ include file="header-script.jsp"%>

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }

        h1 {
            color: #2d3748;
            font-size: 2rem;
            font-weight: 700;
        }

        .info-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .info-box h3 {
            margin-top: 0;
            font-size: 1.3rem;
        }

        .panel {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }

        .panel h3 {
            color: #2d3748;
            font-size: 1.1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .uploader {
            text-align: center;
            padding: 40px;
            border: 3px dashed #cbd5e0;
            border-radius: 8px;
            background: #f7fafc;
            transition: all 0.3s;
            margin-bottom: 25px;
        }

        .uploader:hover {
            border-color: #667eea;
            background: #edf2f7;
        }

        .uploader input[type="file"] {
            display: none;
        }

        .uploader label {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            transition: transform 0.2s;
        }

        .uploader label:hover {
            transform: translateY(-2px);
        }

        .hidden {
            display: none;
        }

        #editor {
            margin-top: 25px;
        }

        video {
            width: 100%;
            max-width: 800px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            margin: 20px 0;
            background: #000;
        }

        .trim-controls {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 25px 0;
            padding: 20px;
            background: #f7fafc;
            border-radius: 8px;
        }

        .trim-controls label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .trim-controls input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 16px;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .trim-controls input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 35px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            transition: transform 0.2s;
            display: inline-block;
            text-decoration: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
        }

        .btn-primary:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        #output {
            margin-top: 30px;
            padding: 25px;
            background: #f0fff4;
            border-radius: 8px;
            border: 2px solid #48bb78;
        }

        #output h2 {
            color: #22543d;
            margin-top: 0;
        }

        #message {
            padding: 20px;
            background: #edf2f7;
            border-radius: 8px;
            margin: 25px 0;
            border-left: 4px solid #667eea;
        }

        #message p {
            margin: 8px 0;
            color: #4a5568;
        }

        #log-message {
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            color: #667eea;
            font-weight: 600;
        }

        /* First-visit full-screen overlay */
        #first-visit-overlay {
            position: fixed;
            inset: 0;
            z-index: 9999;
            background: radial-gradient(1200px 800px at 20% 0%, #4f46e5 0%, #312e81 35%, #111827 100%);
            color: #e5e7eb;
            display: none; /* toggled via JS */
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 24px;
        }
        #first-visit-overlay .inner { max-width: 720px; }
        #first-visit-overlay h1 { color: #ffffff; font-size: 2rem; margin-bottom: 8px; }
        #first-visit-overlay p { color: #cbd5e1; }
        .loader-ring { width: 64px; height: 64px; border: 6px solid rgba(255,255,255,0.2); border-top-color: #60a5fa; border-radius: 50%; margin: 18px auto; animation: spin 1s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
        .overlay-btn { display: inline-block; background: linear-gradient(135deg, #60a5fa 0%, #a78bfa 100%); border: none; color: #0f172a; font-weight: 700; padding: 12px 22px; border-radius: 8px; cursor: pointer; margin-top: 10px; }

        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e2e8f0;
            border-radius: 4px;
            overflow: hidden;
            margin: 15px 0;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            width: 0%;
            transition: width 0.3s;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 25px 0;
        }

        .feature-item {
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .feature-item h4 {
            color: #667eea;
            margin-top: 0;
            font-size: 1.1rem;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-info {
            background: #dbeafe;
            border-left: 4px solid #3b82f6;
            color: #1e3a8a;
        }

        .alert-success {
            background: #d1fae5;
            border-left: 4px solid #10b981;
            color: #065f46;
        }

        .alert-warning {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            color: #78350f;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
            font-size: 13px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .advanced-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin: 20px 0;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            cursor: pointer;
            font-size: 14px;
            color: #2d3748;
        }

        .checkbox-label input[type="checkbox"] {
            margin-right: 10px;
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .checkbox-label span {
            user-select: none;
        }

        .btn-secondary {
            background: white;
            color: #4a5568;
            padding: 10px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
        }

        .segments-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-height: 50px;
        }

        .segment-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 15px;
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
        }

        .segment-item span {
            font-size: 14px;
            color: #2d3748;
            font-weight: 500;
        }

        .btn-remove {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-remove:hover {
            background: #fca5a5;
            color: #7f1d1d;
        }

        .video-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            padding: 15px;
            background: #f7fafc;
            border-radius: 6px;
        }

        .video-info-grid div {
            font-size: 14px;
            color: #4a5568;
        }

        .video-info-grid strong {
            color: #2d3748;
            font-weight: 600;
        }

        .playback-controls {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
            margin: 20px 0;
            padding: 15px;
            background: #f7fafc;
            border-radius: 8px;
        }

        .control-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .control-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }

        .control-btn:active {
            transform: translateY(0);
        }

        .control-btn.mark-in {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }

        .control-btn.mark-out {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        }

        .control-btn-small {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .control-btn-small:hover {
            background: #667eea;
            color: white;
        }

        .timeline-container {
            margin: 25px 0;
            padding: 20px;
            background: #1e1e1e;
            border-radius: 8px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.3);
        }

        .timeline-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            color: #e2e8f0;
        }

        .timeline-label {
            font-weight: 600;
            font-size: 14px;
            color: #a0aec0;
        }

        .current-time {
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 16px;
            font-weight: 700;
            color: #667eea;
            background: #2d3748;
            padding: 5px 12px;
            border-radius: 4px;
        }

        .timeline-wrapper {
            position: relative;
            width: 100%;
        }

        .waveform-canvas {
            width: 100%;
            height: 60px;
            display: block;
            border-radius: 4px;
            background: #2d3748;
            margin-bottom: 5px;
        }

        .timeline-track {
            position: relative;
            width: 100%;
            height: 40px;
            background: #2d3748;
            border-radius: 4px;
            overflow: hidden;
            cursor: pointer;
            user-select: none;
        }

        .timeline-progress {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            background: rgba(102, 126, 234, 0.2);
            pointer-events: none;
            transition: width 0.1s linear;
        }

        .timeline-selection {
            position: absolute;
            top: 0;
            height: 100%;
            background: rgba(102, 126, 234, 0.3);
            border-left: 2px solid #10b981;
            border-right: 2px solid #f59e0b;
            pointer-events: none;
        }

        .timeline-in-marker,
        .timeline-out-marker {
            position: absolute;
            top: 0;
            width: 3px;
            height: 100%;
            cursor: ew-resize;
            z-index: 10;
        }

        .timeline-in-marker {
            background: #10b981;
            box-shadow: 0 0 8px rgba(16, 185, 129, 0.6);
        }

        .timeline-out-marker {
            background: #f59e0b;
            box-shadow: 0 0 8px rgba(245, 158, 11, 0.6);
        }

        .timeline-in-marker::before {
            content: '[';
            position: absolute;
            top: -20px;
            left: -3px;
            color: #10b981;
            font-size: 18px;
            font-weight: bold;
        }

        .timeline-out-marker::before {
            content: ']';
            position: absolute;
            top: -20px;
            right: -3px;
            color: #f59e0b;
            font-size: 18px;
            font-weight: bold;
        }

        .timeline-handle {
            position: absolute;
            top: -10px;
            width: 2px;
            height: calc(100% + 20px);
            cursor: ew-resize;
            z-index: 15;
        }

        .handle-line {
            width: 2px;
            height: 100%;
            background: #ef4444;
            box-shadow: 0 0 10px rgba(239, 68, 68, 0.8);
        }

        .handle-head {
            position: absolute;
            top: 0;
            left: -6px;
            width: 14px;
            height: 14px;
            background: #ef4444;
            border-radius: 50%;
            border: 2px solid white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.4);
        }

        .timeline-ticks {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
            padding: 0 5px;
        }

        .timeline-tick {
            font-size: 11px;
            color: #a0aec0;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .shortcuts-hint {
            margin-top: 15px;
            padding: 12px;
            background: #edf2f7;
            border-radius: 6px;
            font-size: 13px;
            color: #4a5568;
            text-align: center;
        }

        .shortcuts-hint strong {
            color: #2d3748;
            margin-right: 8px;
        }

        .shortcuts-hint span {
            margin: 0 5px;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        /* ===== COMPACT LAYOUT STYLES ===== */

        .editor-layout {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 20px;
            margin: 20px 0;
        }

        .editor-main {
            min-width: 0;
        }

        .editor-sidebar {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .compact-panel {
            padding: 15px;
            margin-bottom: 0;
        }

        .panel-title-compact {
            margin: 0 0 12px 0;
            font-size: 1rem;
            color: #2d3748;
        }

        .video-container {
            text-align: center;
            margin-bottom: 12px;
        }

        .compact-info {
            font-size: 12px;
            padding: 8px;
            background: #edf2f7;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .compact-info strong {
            color: #2d3748;
        }

        .playback-controls-compact {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 10px;
            background: #f7fafc;
            border-radius: 6px;
            margin-bottom: 12px;
        }

        .control-btn-compact {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s;
            min-width: 40px;
        }

        .control-btn-compact:hover {
            transform: translateY(-1px);
        }

        .control-btn-compact.play-btn {
            padding: 8px 16px;
            font-size: 18px;
        }

        .control-btn-compact.mark-in {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }

        .control-btn-compact.mark-out {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        }

        .control-btn-compact-small {
            background: white;
            color: #667eea;
            border: 1px solid #667eea;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
        }

        .control-btn-compact-small:hover {
            background: #667eea;
            color: white;
        }

        .control-divider {
            width: 1px;
            height: 24px;
            background: #cbd5e0;
            margin: 0 4px;
        }

        .current-time-compact {
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            font-weight: 700;
            color: #667eea;
            background: white;
            padding: 4px 10px;
            border-radius: 4px;
            margin-left: 8px;
        }

        .timeline-container-compact {
            padding: 12px;
            background: #1e1e1e;
            border-radius: 6px;
            margin-bottom: 12px;
        }

        .waveform-canvas-compact {
            width: 100%;
            height: 40px;
            display: block;
            border-radius: 4px;
            background: #2d3748;
            margin-bottom: 5px;
        }

        .time-inputs-inline {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px;
            background: #f7fafc;
            border-radius: 6px;
            margin-bottom: 10px;
        }

        .time-input-group {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .time-input-group label {
            font-size: 12px;
            font-weight: 600;
            color: #4a5568;
            min-width: 24px;
        }

        .time-input-group input {
            width: 80px;
            padding: 6px 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 13px;
        }

        .duration-badge {
            margin-left: auto;
            font-size: 12px;
            color: #667eea;
            font-weight: 600;
            background: white;
            padding: 6px 12px;
            border-radius: 4px;
        }

        .shortcuts-compact {
            text-align: center;
            font-size: 11px;
            color: #718096;
            padding: 8px;
            background: #edf2f7;
            border-radius: 4px;
        }

        .shortcuts-compact strong {
            color: #2d3748;
            font-family: 'Monaco', monospace;
        }

        .form-group-compact {
            margin-bottom: 10px;
        }

        .form-group-compact label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 4px;
        }

        .form-group-compact select,
        .form-group-compact input {
            width: 100%;
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 13px;
        }

        .checkbox-group-compact {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-top: 10px;
        }

        .checkbox-label-compact {
            display: flex;
            align-items: center;
            font-size: 12px;
            color: #2d3748;
            cursor: pointer;
        }

        .checkbox-label-compact input {
            margin-right: 6px;
            width: 16px;
            height: 16px;
        }

        .accordion-header {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            padding: 10px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            color: #2d3748;
            transition: all 0.2s;
        }

        .accordion-header:hover {
            background: #edf2f7;
        }

        .accordion-icon {
            font-size: 10px;
            transition: transform 0.3s;
        }

        .accordion-header.active .accordion-icon {
            transform: rotate(180deg);
        }

        .accordion-content {
            padding: 12px 0;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .btn-secondary-compact {
            width: 100%;
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-secondary-compact:hover {
            background: #667eea;
            color: white;
        }

        .segments-container-compact {
            max-height: 200px;
            overflow-y: auto;
            margin: 10px 0;
        }

        .btn-primary-large {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary-large:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .progress-compact {
            margin-top: 12px;
        }

        .progress-compact p {
            text-align: center;
            font-size: 12px;
            color: #4a5568;
            margin-top: 8px;
        }

        .output-section {
            margin-top: 20px;
            padding: 20px;
            background: #f0fff4;
            border: 2px solid #48bb78;
            border-radius: 8px;
        }

        .output-section h3 {
            color: #22543d;
            margin: 0 0 15px 0;
            text-align: center;
        }

        .output-container {
            text-align: center;
        }

        @media (max-width: 1024px) {
            .editor-layout {
                grid-template-columns: 1fr;
            }

            .editor-sidebar {
                order: 2;
            }
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 1.5rem;
            }

            .trim-controls {
                grid-template-columns: 1fr;
            }

            .feature-grid {
                grid-template-columns: 1fr;
            }

            .advanced-grid {
                grid-template-columns: 1fr;
            }

            .video-info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Free Online Video Trimmer & Cutter</h1>
<p>Trim/edit and cut videos directly </p>

<hr>



<!-- First visit splash/loader (hidden by default; shown on first visit) -->
<div id="first-visit-overlay" style="display:none; position:fixed; inset:0; z-index:9999; background: radial-gradient(1200px 800px at 20% 0%, #4f46e5 0%, #312e81 35%, #111827 100%); color:#e5e7eb; text-align:center; padding:24px; display:none; align-items:center; justify-content:center;">
    <div class="inner" style="max-width:720px; margin:0 auto;">
        <h1 style="color:#fff; font-size:2rem; margin-bottom:8px;">Video Trimmer is Loading</h1>
        <p>We load FFmpeg in your browser for private, on‑device editing. This initial load can take a moment.</p>
        <div class="loader-ring" style="width:64px; height:64px; border:6px solid rgba(255,255,255,0.2); border-top-color:#60a5fa; border-radius:50%; margin:18px auto; animation: spin 1s linear infinite;"></div>
        <style>@keyframes spin{to{transform:rotate(360deg)}}</style>
        <p id="first-visit-status">Fetching FFmpeg core…</p>
        <button id="first-visit-continue" class="overlay-btn" style="display:inline-block; background:linear-gradient(135deg,#60a5fa 0%,#a78bfa 100%); border:none; color:#0f172a; font-weight:700; padding:12px 22px; border-radius:8px; cursor:pointer; margin-top:10px;">Continue</button>
    </div>
</div>

<div class="panel" id="uploader-panel">
    <h3>Step 1: Upload Your Video</h3>
    <div class="uploader">
        <input type="file" id="video-upload" accept="video/*">
        <label for="video-upload">Choose a Video File</label>
        <p style="margin-top: 15px; color: #718096; font-size: 14px;">Supports: MP4, WebM, AVI, MOV, MKV, and more</p>
    </div>
</div>

<div id="editor" class="hidden">
    <!-- Main Editor Layout -->
    <div class="editor-layout">
        <!-- Left Side: Video Player & Timeline -->
        <div class="editor-main">
            <div class="panel compact-panel">
                <!-- Video Info (Compact) -->
                <div id="video-info" class="hidden compact-info"></div>

                <!-- Video Player -->
                <div class="video-container">
                    <video id="video-player" controls></video>
                </div>

                <!-- Playback Controls (Compact) -->
                <div class="playback-controls-compact">
                    <button id="frame-back" class="control-btn-compact" title="Previous Frame (←)">⏮</button>
                    <button id="play-pause" class="control-btn-compact play-btn" title="Play/Pause (Space)">▶</button>
                    <button id="frame-forward" class="control-btn-compact" title="Next Frame (→)">⏭</button>
                    <div class="control-divider"></div>
                    <button id="set-in" class="control-btn-compact mark-in" title="Set In Point (I)">[</button>
                    <button id="set-out" class="control-btn-compact mark-out" title="Set Out Point (O)">]</button>
                    <button id="go-to-in" class="control-btn-compact-small" title="Go to In (Shift+I)">↻I</button>
                    <button id="go-to-out" class="control-btn-compact-small" title="Go to Out (Shift+O)">↻O</button>
                    <span class="current-time-compact" id="current-time-display">00:00:00</span>
                </div>

                <!-- Timeline (Compact) -->
                <div class="timeline-container-compact">
                    <canvas id="waveform-canvas" class="waveform-canvas-compact"></canvas>
                    <div class="timeline-track" id="timeline-track">
                        <div class="timeline-progress" id="timeline-progress"></div>
                        <div class="timeline-in-marker" id="timeline-in-marker" style="left: 0%"></div>
                        <div class="timeline-out-marker" id="timeline-out-marker" style="left: 100%"></div>
                        <div class="timeline-selection" id="timeline-selection"></div>
                        <div class="timeline-handle" id="timeline-handle" style="left: 0%">
                            <div class="handle-line"></div>
                            <div class="handle-head"></div>
                        </div>
                    </div>
                    <div class="timeline-ticks" id="timeline-ticks"></div>
                </div>

                <!-- In/Out Time Inputs (Inline) -->
                <div class="time-inputs-inline">
                    <div class="time-input-group">
                        <label>In:</label>
                        <input type="number" id="start-time" value="0" min="0" step="0.033">
                    </div>
                    <div class="time-input-group">
                        <label>Out:</label>
                        <input type="number" id="end-time" value="5" min="0" step="0.033">
                    </div>
                    <div class="duration-badge">
                        Duration: <span id="duration-display">5.00s</span>
                    </div>
                </div>

                <!-- Shortcuts Hint (Compact) -->
                <div class="shortcuts-compact">
                    ⌨️ <strong>Space</strong> Play • <strong>I/O</strong> Mark • <strong>← →</strong> Frame
                </div>
            </div>
        </div>

        <!-- Right Side: Options & Controls -->
        <div class="editor-sidebar">
            <!-- Quick Options -->
            <div class="panel compact-panel">
                <h3 class="panel-title-compact">Quick Settings</h3>

                <div class="form-group-compact">
                    <label>Format:</label>
                    <select id="output-format">
                        <option value="mp4">MP4</option>
                        <option value="webm">WebM</option>
                        <option value="avi">AVI</option>
                        <option value="mkv">MKV</option>
                    </select>
                </div>

                <div class="form-group-compact">
                    <label>Quality:</label>
                    <select id="video-quality">
                        <option value="high">High</option>
                        <option value="medium" selected>Medium</option>
                        <option value="low">Low</option>
                    </select>
                </div>

                <div class="form-group-compact">
                    <label>Codec:</label>
                    <select id="video-codec">
                        <option value="copy">Copy (Fast)</option>
                        <option value="libx264">H.264</option>
                        <option value="libx265">H.265</option>
                        <option value="libvpx-vp9">VP9</option>
                    </select>
                </div>

                <div class="checkbox-group-compact">
                    <label class="checkbox-label-compact">
                        <input type="checkbox" id="mute-video">
                        <span>Mute Audio</span>
                    </label>
                    <label class="checkbox-label-compact">
                        <input type="checkbox" id="extract-audio">
                        <span>Extract Audio</span>
                    </label>
                </div>
            </div>

            <!-- Collapsible Advanced Options -->
            <div class="panel compact-panel">
                <button class="accordion-header" onclick="toggleAccordion('advanced-opts')">
                    <span>⚙️ Advanced Options</span>
                    <span class="accordion-icon">▼</span>
                </button>
                <div id="advanced-opts" class="accordion-content" style="display: none;">
                    <div class="form-group-compact">
                        <label>Speed:</label>
                        <select id="video-speed">
                            <option value="0.5">0.5x</option>
                            <option value="1" selected>1x</option>
                            <option value="1.5">1.5x</option>
                            <option value="2">2x</option>
                        </select>
                    </div>

                    <div class="form-group-compact">
                        <label>Rotation:</label>
                        <select id="video-rotate">
                            <option value="0" selected>None</option>
                            <option value="90">90°</option>
                            <option value="180">180°</option>
                            <option value="270">270°</option>
                        </select>
                    </div>

                    <div class="form-group-compact">
                        <label>Resolution:</label>
                        <select id="video-scale">
                            <option value="original" selected>Original</option>
                            <option value="1920:1080">1080p</option>
                            <option value="1280:720">720p</option>
                            <option value="854:480">480p</option>
                        </select>
                    </div>

                    <div class="form-group-compact">
                        <label>FPS:</label>
                        <select id="video-fps">
                            <option value="original" selected>Original</option>
                            <option value="24">24</option>
                            <option value="30">30</option>
                            <option value="60">60</option>
                        </select>
                    </div>

                    <div class="form-group-compact">
                        <label>Audio Bitrate:</label>
                        <select id="audio-bitrate">
                            <option value="96k">96k</option>
                            <option value="128k" selected>128k</option>
                            <option value="192k">192k</option>
                            <option value="256k">256k</option>
                        </select>
                    </div>

                    <label class="checkbox-label-compact">
                        <input type="checkbox" id="add-watermark">
                        <span>Add Watermark</span>
                    </label>

                    <div class="form-group-compact" id="watermark-group" style="display: none;">
                        <input type="text" id="watermark-text" placeholder="Watermark text">
                        <div style="margin-top:8px"></div>
                        <label style="display:block; margin-bottom:6px;">Position:</label>
                        <select id="watermark-position">
                            <option value="tl" selected>Top-Left</option>
                            <option value="tr">Top-Right</option>
                            <option value="bl">Bottom-Left</option>
                            <option value="br">Bottom-Right</option>
                            <option value="center">Center</option>
                            <option value="custom">Custom (x,y)</option>
                        </select>
                        <div id="watermark-custom-pos" style="display:none; margin-top:8px;">
                            <div style="display:flex; gap:8px;">
                                <input type="number" id="watermark-x" placeholder="x (px)" value="10" style="flex:1;">
                                <input type="number" id="watermark-y" placeholder="y (px)" value="10" style="flex:1;">
                            </div>
                        </div>
                    </div>

                    <label class="checkbox-label-compact">
                        <input type="checkbox" id="use-overlay-watermark">
                        <span>Use image overlay for watermark (compatibility)</span>
                    </label>
                </div>
            </div>

            <!-- Multi-Segment -->
            <div class="panel compact-panel">
                <button class="accordion-header" onclick="toggleAccordion('multi-segment')">
                    <span>✂️ Multi-Segment</span>
                    <span class="accordion-icon">▼</span>
                </button>
                <div id="multi-segment" class="accordion-content" style="display: none;">
                    <button id="add-segment-btn" class="btn-secondary-compact">➕ Add Segment</button>
                    <div id="trim-segments" class="segments-container-compact"></div>
                    <button id="multi-trim-btn" class="btn-secondary-compact" style="margin-top: 10px;">Process Segments</button>
                </div>
            </div>

            <!-- Process Button -->
            <button id="trim-btn" class="btn-primary-large">
                Process Video
            </button>

            <div id="progress" class="hidden progress-compact">
                <div class="progress-bar">
                    <div class="progress-bar-fill" id="progress-fill"></div>
                </div>
                <p id="progress-text">Processing...</p>
            </div>
        </div>
    </div>

    <!-- Output Section (Full Width Below) -->
    <div id="output" class="hidden output-section">
        <h3>✓ Processed Video Ready</h3>
        <div class="output-container">
            <video id="output-video" controls></video>
        </div>
        <div style="text-align: center; margin-top: 15px;">
            <a id="download-link" class="btn-primary hidden" href="#">💾 Download Video</a>
        </div>
    </div>
</div>

<div id="message">
    <p>Loading FFmpeg... This may take a moment on the first visit.</p>
    <p id="log-message"></p>
</div>

<h2 class="mt-4">Features</h2>
<div class="feature-grid">
    <div class="feature-item">
        <h4>Professional Timeline Editor</h4>
        <p>Visual timeline with waveform display, draggable in/out markers, frame-by-frame navigation, and keyboard shortcuts - just like professional editors.</p>
    </div>
    <div class="feature-item">
        <h4>Frame-Accurate Cutting</h4>
        <p>Navigate frame-by-frame using arrow keys or buttons. Set precise in/out points with visual markers for pixel-perfect cuts.</p>
    </div>
    <div class="feature-item">
        <h4>Advanced Video Processing</h4>
        <p>Quality control, codec selection, resolution scaling, rotation, speed adjustment, and text watermarks - full professional editing suite.</p>
    </div>
    <div class="feature-item">
        <h4>Multi-Segment Editing</h4>
        <p>Add multiple time ranges and merge them into a single video. Perfect for creating highlight reels and compilations.</p>
    </div>
    <div class="feature-item">
        <h4>100% Client-Side</h4>
        <p>All video processing happens in your browser. Your videos are never uploaded to any server, ensuring complete privacy and security.</p>
    </div>
    <div class="feature-item">
        <h4>FFmpeg Powered</h4>
        <p>Built on FFmpeg.wasm, bringing the power of FFmpeg video processing to your browser with WebAssembly technology.</p>
    </div>
    <div class="feature-item">
        <h4>Multiple Formats</h4>
        <p>Support for all popular video formats including MP4, WebM, AVI, MOV, MKV. Export to various codecs like H.264, H.265, VP9.</p>
    </div>
    <div class="feature-item">
        <h4>Audio Extraction</h4>
        <p>Extract audio tracks from videos or mute videos completely. Adjust audio bitrate and quality settings.</p>
    </div>
    <div class="feature-item">
        <h4>Keyboard Shortcuts</h4>
        <p>Professional keyboard shortcuts: Space (play/pause), I/O (set in/out points), arrow keys (frame navigation) for fast editing.</p>
    </div>
</div>

<h2 class="mt-4">How to Use</h2>
<ul>
    <li><strong>Step 1:</strong> Click "Choose a Video File" and select the video you want to edit</li>
    <li><strong>Step 2:</strong> Use the visual timeline to navigate your video - drag the red playhead or click anywhere on the timeline</li>
    <li><strong>Step 3:</strong> Set In/Out points by clicking the green "[ In Point" and orange "Out Point ]" buttons, or press I and O keys</li>
    <li><strong>Step 4:</strong> Navigate frame-by-frame using arrow keys or the frame buttons for precise cuts</li>
    <li><strong>Step 5:</strong> Adjust advanced options like quality, format, rotation, speed, or add watermarks</li>
    <li><strong>Step 6:</strong> Click "Process Video" to render your edit</li>
    <li><strong>Step 7:</strong> Preview the result and download it to your device</li>
</ul>

<h3 class="mt-3">Pro Tips</h3>
<ul>
    <li>Use <strong>Space bar</strong> to quickly play/pause while reviewing your video</li>
    <li>Press <strong>I</strong> to mark the in point and <strong>O</strong> for the out point at the current playhead position</li>
    <li>Use <strong>Arrow keys (← →)</strong> to navigate frame-by-frame for pixel-perfect cuts</li>
    <li>Drag the <strong>green and orange markers</strong> on the timeline to visually adjust in/out points</li>
    <li>For multi-segment editing, set your in/out points, click "Add Current Segment", then repeat for other clips</li>
    <li>Choose "Copy" codec for fastest processing when you don't need to re-encode</li>
</ul>

<div class="alert alert-info">
    <span>ℹ️</span>
    <div>
        <strong>Note:</strong> Processing time depends on your video size and device performance. The first load may take longer as FFmpeg.wasm needs to initialize.
    </div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- The core FFmpeg library (served from same origin) -->
<script src="js/ffmpeg/ffmpeg.min.js"></script>
<script src="js/video_code.js"></script>
<script src="js/timeline-editor.js"></script>

<script>
// Accordion toggle function
function toggleAccordion(id) {
    const content = document.getElementById(id);
    const header = event.currentTarget;

    if (content.style.display === 'none') {
        content.style.display = 'block';
        header.classList.add('active');
    } else {
        content.style.display = 'none';
        header.classList.remove('active');
    }
}

// Initialize timeline editor after video loads
document.addEventListener('DOMContentLoaded', () => {
    window.timelineEditor.setup();
    // First-visit overlay: show once and while FFmpeg loads
    try {
        const key = 'vt_first_visit_shown';
        const overlay = document.getElementById('first-visit-overlay');
        const status = document.getElementById('first-visit-status');
        const btn = document.getElementById('first-visit-continue');
        const isFirst = !localStorage.getItem(key);
        if (overlay) {
            const show = () => { overlay.style.display = 'flex'; };
            const hide = () => { overlay.style.display = 'none'; };
            if (isFirst) show();
            if (btn) btn.addEventListener('click', () => { localStorage.setItem(key, '1'); hide(); });
            // Hook ffmpeg load progress if available
            const log = document.getElementById('log-message');
            const msg = document.getElementById('message');
            const observer = new MutationObserver(() => {
                if (!status) return;
                // Mirror log or message into overlay status on first visit
                const txt = (log && log.textContent) ? log.textContent : (msg && msg.textContent) ? msg.textContent : '';
                if (txt) status.textContent = txt;
                // Hide overlay when editor is visible
                const editor = document.getElementById('editor');
                if (editor && !editor.classList.contains('hidden')) hide();
            });
            if (log) observer.observe(log, { childList: true, subtree: true, characterData: true });
            if (msg) observer.observe(msg, { childList: true, subtree: true, characterData: true });
            // Fallback auto-hide after 10s even if ffmpeg logs are blocked
            setTimeout(() => { if (isFirst) { localStorage.setItem(key, '1'); hide(); } }, 10000);
        }
    } catch (e) { /* no-op */ }
});
</script>

</div>
<%@ include file="body-close.jsp"%>
