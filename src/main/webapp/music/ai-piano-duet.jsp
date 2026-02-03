<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.*" %>
        <% String cacheVersion=String.valueOf(System.currentTimeMillis()); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta name="robots" content="index,follow">

                <jsp:include page="../modern/components/seo-tool-page.jsp">
                    <jsp:param name="toolName" value="AI Piano Duet - Play Piano with Artificial Intelligence" />
                    <jsp:param name="toolCategory" value="Music" />
                    <jsp:param name="toolDescription"
                        value="Play piano with AI! An intelligent neural network listens to your melody and creates a beautiful duet in real-time. Experience the future of music with Google Magenta AI technology." />
                    <jsp:param name="toolUrl" value="music/ai-piano-duet.jsp" />
                    <jsp:param name="toolKeywords"
                        value="ai piano, piano duet, artificial intelligence music, neural network piano, magenta ai, play piano with ai, interactive piano, music ai, machine learning piano, ai music generator" />
                    <jsp:param name="toolImage" value="ai-piano-duet.png" />
                    <jsp:param name="toolFeatures"
                        value="AI-powered duet,Real-time music generation,Neural network improvisation,MIDI keyboard support,Computer keyboard controls,Touch support,Temperature control,Live chord detection,Multiple instruments,Backing drums,Recording and download,Visual feedback,Google Magenta AI" />
                    <jsp:param name="hasSteps" value="false" />
                </jsp:include>

                <!-- Custom HowTo Schema -->
                <script type="application/ld+json">
                {
                  "@context": "https://schema.org",
                  "@type": "HowTo",
                  "name": "How to Play Piano Duet with AI",
                  "description": "Learn to play a real-time duet with Google Magenta's AI neural network.",
                  "totalTime": "PT5M",
                  "step": [
                    {"@type": "HowToStep", "position": 1, "name": "Wait for AI to load", "text": "The neural network model takes a few seconds to load. Wait until the 'Loading AI Model' message disappears."},
                    {"@type": "HowToStep", "position": 2, "name": "Play notes on the keyboard", "text": "Use your computer keyboard (A-K for white keys, W-E-T-Y-U for black keys) or connect a MIDI controller."},
                    {"@type": "HowToStep", "position": 3, "name": "Hold the keys", "text": "Press and HOLD your notes. The AI will start generating a response melody while you hold the keys down."},
                    {"@type": "HowToStep", "position": 4, "name": "Adjust AI creativity", "text": "Use the Temperature slider to control how creative the AI is. Lower (0.2) = predictable, Higher (2.0) = experimental."},
                    {"@type": "HowToStep", "position": 5, "name": "Watch the colors", "text": "Blue highlights show your notes, pink highlights show the AI's response. Create a musical conversation!"}
                  ]
                }
                </script>

                <!-- Custom FAQPage Schema -->
                <script type="application/ld+json">
                {
                  "@context": "https://schema.org",
                  "@type": "FAQPage",
                  "mainEntity": [
                    {
                      "@type": "Question",
                      "name": "What is AI Piano Duet?",
                      "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "AI Piano Duet is a web application that uses Google Magenta's neural network to create real-time musical duets. When you play notes, the AI analyzes your melody and chord, then generates a complementary response - like having a virtual jazz musician jamming with you."
                      }
                    },
                    {
                      "@type": "Question",
                      "name": "How does the AI generate music?",
                      "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "The AI uses an Improv RNN (Recurrent Neural Network) trained on thousands of jazz improvisations. It detects the chords you're playing, understands the musical context, and generates notes that harmonize with your melody using machine learning predictions."
                      }
                    },
                    {
                      "@type": "Question",
                      "name": "What is the Temperature setting?",
                      "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Temperature controls AI creativity. Low values (0.2-0.5) make the AI play safe, predictable notes. High values (1.5-2.0) make it experimental and surprising. Default (1.1) provides a good balance. It's like adjusting how 'adventurous' your AI partner is."
                      }
                    },
                    {
                      "@type": "Question",
                      "name": "Can I use a MIDI keyboard?",
                      "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes! Connect any MIDI keyboard to your computer and use Chrome, Edge, or Opera (browsers supporting Web MIDI API). The tool will detect your MIDI device automatically. This provides the most expressive and natural playing experience."
                      }
                    },
                    {
                      "@type": "Question",
                      "name": "Why does the AI only play when I hold keys?",
                      "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "The AI is designed to respond to your playing, not play alone. Hold notes to 'cue' the AI to continue. When you release all keys, the AI stops, waiting for your next musical phrase. This creates a true call-and-response duet experience."
                      }
                    },
                    {
                      "@type": "Question",
                      "name": "What technology powers this tool?",
                      "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "It uses Google Magenta.js for the AI model, TensorFlow.js for machine learning in the browser, Tone.js for professional audio synthesis, Tonal.js for chord detection, and Web MIDI API for controller support. All processing happens locally in your browser."
                      }
                    }
                  ]
                }
                </script>

                <!-- Fonts & CSS -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap"
                    rel="stylesheet">

                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">

                <%@ include file="../modern/ads/ad-init.jsp" %>


                <style>
                    .ai-piano-container {
                        max-width: 100%;
                        margin: 0;
                        padding: 0;
                    }

                    .container {
                        position: relative;
                        width: 100%;
                        height: 80vh;
                        min-height: 500px;
                        background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
                        overflow: hidden;
                    }

                    .machine-bg,
                    .human-bg {
                        position: absolute;
                        width: 100%;
                        height: 50%;
                        display: flex;
                        flex-direction: column;
                    }

                    .machine-bg {
                        top: 0;
                        background: linear-gradient(180deg, rgba(233, 30, 99, 0.15) 0%, rgba(233, 30, 99, 0.05) 100%);
                        border-bottom: 2px solid rgba(233, 30, 99, 0.3);
                    }

                    .human-bg {
                        bottom: 0;
                        background: linear-gradient(0deg, rgba(30, 136, 229, 0.15) 0%, rgba(30, 136, 229, 0.05) 100%);
                    }

                    .machine-bg .player,
                    .human-bg .player {
                        position: absolute;
                        left: 5%;
                        width: 90%;
                        top: 0;
                        bottom: 0;
                    }

                    .machine-bg .player .key,
                    .human-bg .player .key {
                        position: absolute;
                        top: 0;
                        height: 100%;
                    }

                    .machine-bg .player .key {
                        background-color: #e91e63;
                        opacity: 0;
                    }

                    .human-bg .player .key.down {
                        background-color: #64b5f6;
                        opacity: 0.9;
                    }

                    .controls {
                        z-index: 4;
                        font-size: 0.95rem;
                        text-align: center;
                        transition: opacity 0.5s ease-out;
                        opacity: 1;
                        color: rgba(255, 255, 255, 0.9);
                        padding: 1rem 2rem;
                        line-height: 1.6;
                    }

                    .machine-bg .controls {
                        margin-bottom: 125px;
                    }

                    .human-bg .controls {
                        margin-top: 125px;
                    }

                    .controls a {
                        color: #64b5f6;
                        text-decoration: none;
                    }

                    .controls a:hover {
                        text-decoration: underline;
                    }

                    .keyboard {
                        position: absolute;
                        left: 5%;
                        width: 90%;
                        top: calc(50% - 125px);
                        height: 250px;
                        opacity: 0;
                        transition: opacity 0.7s ease-in;
                    }

                    .keyboard.loaded {
                        opacity: 1;
                    }

                    .keyboard .key {
                        position: absolute;
                        top: 0;
                        height: 100%;
                        box-sizing: border-box;
                        z-index: 1;
                        background-color: white;
                        box-shadow: 0 0 5px #333;
                        border-radius: 3px;
                    }

                    .keyboard .key:hover {
                        background: #f5f5f5;
                    }

                    .keyboard .key.accidental {
                        height: 170px;
                        z-index: 2;
                        background-color: black;
                        box-shadow: none;
                        border-width: 0;
                        border-top-left-radius: 0;
                        border-top-right-radius: 0;
                    }

                    .loading {
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                        font-size: 2rem;
                        color: white;
                        font-weight: 600;
                        text-align: center;
                        z-index: 100;
                    }

                    .loading::after {
                        content: '';
                        animation: dots 1.5s steps(4, end) infinite;
                    }

                    @keyframes dots {

                        0%,
                        20% {
                            content: '';
                        }

                        40% {
                            content: '.';
                        }

                        60% {
                            content: '..';
                        }

                        80%,
                        100% {
                            content: '...';
                        }
                    }

                    .temperature-control {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .temperature-control label {
                        font-size: 0.95rem;
                    }

                    .temperature-control input[type="range"] {
                        width: 200px;
                        height: 6px;
                        -webkit-appearance: none;
                        appearance: none;
                        background: rgba(255, 255, 255, 0.3);
                        border-radius: 3px;
                        outline: none;
                        cursor: pointer;
                    }

                    .temperature-control input[type="range"]::-webkit-slider-thumb {
                        -webkit-appearance: none;
                        appearance: none;
                        width: 20px;
                        height: 20px;
                        background: #e91e63;
                        border-radius: 50%;
                        cursor: pointer;
                        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
                        transition: transform 0.1s ease;
                    }

                    .temperature-control input[type="range"]::-webkit-slider-thumb:hover {
                        transform: scale(1.1);
                    }

                    .temperature-control input[type="range"]::-moz-range-thumb {
                        width: 20px;
                        height: 20px;
                        background: #e91e63;
                        border-radius: 50%;
                        cursor: pointer;
                        border: none;
                        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
                    }

                    .temp-labels {
                        display: flex;
                        justify-content: space-between;
                        width: 200px;
                        font-size: 0.75rem;
                        opacity: 0.7;
                    }

                    .ui-hidden .controls {
                        opacity: 0;
                        transition: opacity 0.3s ease;
                    }

                    /* Chord Display */
                    .chord-display {
                        margin-bottom: 1rem;
                    }

                    .chord-label {
                        font-size: 0.9rem;
                        opacity: 0.8;
                    }

                    .chord-name {
                        display: inline-block;
                        font-size: 1.5rem;
                        font-weight: 700;
                        min-width: 80px;
                        padding: 0.25rem 0.75rem;
                        border-radius: 8px;
                        margin-left: 0.5rem;
                    }

                    .chord-name.ai {
                        color: #e91e63;
                        background: rgba(233, 30, 99, 0.2);
                    }

                    .chord-name.human {
                        color: #64b5f6;
                        background: rgba(100, 181, 246, 0.2);
                    }

                    .human-chord {
                        margin-bottom: 0.75rem;
                    }

                    /* Footer */
                    .page-footer {
                        background: var(--bg-secondary, #f8fafc);
                        border-top: 1px solid var(--border, #e2e8f0);
                        padding: 2rem;
                        text-align: center;
                        margin-top: 2rem;
                    }

                    .footer-content {
                        max-width: 1200px;
                        margin: 0 auto;
                    }

                    .footer-text {
                        color: var(--text-secondary, #64748b);
                        margin: 0 0 1rem 0;
                    }

                    .footer-links {
                        display: flex;
                        justify-content: center;
                        gap: 2rem;
                        flex-wrap: wrap;
                    }

                    .footer-link {
                        color: var(--text-secondary, #64748b);
                        text-decoration: none;
                        font-weight: 500;
                        transition: color 0.2s;
                    }

                    .footer-link:hover {
                        color: var(--primary, #6366f1);
                    }

                    /* Sheet Music Modal */
                    .sheet-modal {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.8);
                        z-index: 1000;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        padding: 1rem;
                    }

                    .sheet-modal-content {
                        background: white;
                        border-radius: 16px;
                        max-width: 95vw;
                        max-height: 90vh;
                        overflow: hidden;
                        display: flex;
                        flex-direction: column;
                    }

                    .sheet-modal-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 1rem 1.5rem;
                        border-bottom: 1px solid #e2e8f0;
                    }

                    .sheet-modal-header h3 {
                        margin: 0;
                        color: #1e293b;
                    }

                    .close-modal-btn {
                        background: none;
                        border: none;
                        font-size: 2rem;
                        cursor: pointer;
                        color: #64748b;
                        line-height: 1;
                    }

                    .close-modal-btn:hover {
                        color: #ef4444;
                    }

                    .sheet-modal-body {
                        padding: 1.5rem;
                        overflow: auto;
                        flex: 1;
                    }

                    .sheet-legend {
                        display: flex;
                        gap: 2rem;
                        margin-bottom: 1rem;
                        justify-content: center;
                    }

                    .legend-item {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        font-size: 0.9rem;
                        color: #475569;
                    }

                    .legend-color {
                        width: 16px;
                        height: 16px;
                        border-radius: 4px;
                    }

                    .legend-color.human {
                        background: #3b82f6;
                    }

                    .legend-color.ai {
                        background: #ec4899;
                    }

                    #sheetMusicContainer {
                        background: #fafafa;
                        border-radius: 8px;
                        padding: 1rem;
                        min-height: 200px;
                        overflow-x: auto;
                    }

                    .sheet-modal-footer {
                        display: flex;
                        gap: 1rem;
                        padding: 1rem 1.5rem;
                        border-top: 1px solid #e2e8f0;
                        justify-content: center;
                    }

                    .sheet-modal-footer .control-btn {
                        background: #6366f1;
                        color: white;
                        border: none;
                        padding: 0.75rem 1.5rem;
                        font-weight: 600;
                    }

                    .sheet-modal-footer .control-btn:hover {
                        background: #4f46e5;
                    }

                    /* Control Buttons */
                    .control-buttons {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 1rem;
                        justify-content: center;
                        align-items: center;
                        margin-top: 1rem;
                        padding-top: 1rem;
                        border-top: 1px solid rgba(255, 255, 255, 0.2);
                    }

                    .control-group {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .control-group label {
                        font-size: 0.85rem;
                        white-space: nowrap;
                    }

                    .control-group select {
                        background: rgba(255, 255, 255, 0.15);
                        color: white;
                        border: 1px solid rgba(255, 255, 255, 0.3);
                        border-radius: 6px;
                        padding: 0.4rem 0.6rem;
                        font-size: 0.85rem;
                        cursor: pointer;
                    }

                    .control-group select:hover {
                        background: rgba(255, 255, 255, 0.25);
                    }

                    .control-btn {
                        background: rgba(255, 255, 255, 0.15);
                        color: white;
                        border: 1px solid rgba(255, 255, 255, 0.3);
                        border-radius: 6px;
                        padding: 0.5rem 1rem;
                        font-size: 0.85rem;
                        cursor: pointer;
                        transition: all 0.2s ease;
                    }

                    .control-btn:hover:not(:disabled) {
                        background: rgba(255, 255, 255, 0.25);
                        transform: translateY(-1px);
                    }

                    .control-btn:disabled {
                        opacity: 0.5;
                        cursor: not-allowed;
                    }

                    .control-btn.active {
                        background: rgba(233, 30, 99, 0.5);
                        border-color: #e91e63;
                    }

                    .record-btn.recording {
                        background: rgba(244, 67, 54, 0.6);
                        border-color: #f44336;
                        animation: pulse-record 1s infinite;
                    }

                    @keyframes pulse-record {
                        0%, 100% { box-shadow: 0 0 0 0 rgba(244, 67, 54, 0.4); }
                        50% { box-shadow: 0 0 0 8px rgba(244, 67, 54, 0); }
                    }

                    .instrument-loading {
                        display: inline-block;
                        margin-left: 0.5rem;
                        font-size: 0.75rem;
                        color: #ffc107;
                        animation: blink 1s infinite;
                    }

                    @keyframes blink {
                        0%, 100% { opacity: 1; }
                        50% { opacity: 0.5; }
                    }

                    .feature-grid {
                        max-width: 1200px;
                        margin: 2rem auto;
                        padding: 0 2rem;
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                        gap: 1.5rem;
                    }

                    .tool-content {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 0 2rem 2rem;
                    }

                    .feature-card {
                        background: var(--bg-primary);
                        border: 1px solid var(--border);
                        border-radius: 12px;
                        padding: 1.5rem;
                    }

                    .feature-card h3 {
                        margin: 0 0 0.5rem 0;
                        color: var(--text-primary);
                        font-size: 1.125rem;
                    }

                    .feature-card p {
                        margin: 0;
                        color: var(--text-secondary);
                        font-size: 0.9rem;
                        line-height: 1.5;
                    }

                    #midi-inputs {
                        background: rgba(255, 255, 255, 0.1);
                        color: white;
                        border: 1px solid rgba(255, 255, 255, 0.3);
                        border-radius: 4px;
                        padding: 0.5rem;
                        margin: 0 0.5rem;
                    }

                    @media (max-width: 768px) {
                        .container {
                            height: 450px;
                        }

                        .keyboard {
                            height: 180px;
                            top: calc(50% - 90px);
                        }

                        .keyboard .key.accidental {
                            height: 110px;
                        }

                        .machine-bg .controls {
                            margin-bottom: 90px;
                        }

                        .human-bg .controls {
                            margin-top: 90px;
                        }

                        .controls {
                            padding: 0.75rem 1rem;
                            font-size: 0.8rem;
                        }

                        .temperature-control input[type="range"] {
                            width: 150px;
                        }

                        .temp-labels {
                            width: 150px;
                        }
                    }
                </style>
            </head>

            <body>
                <%@ include file="../modern/components/nav-header.jsp" %>

                    <header class="tool-page-header">
                        <div class="tool-page-header-inner">
                            <div>
                                <h1>🤖 AI Piano Duet</h1>
                                <p class="tool-description">Play piano with artificial intelligence - the AI listens and
                                    creates a beautiful duet with you in real-time!</p>
                            </div>
                        </div>
                    </header>

                    <!-- Breadcrumbs -->
                    <nav class="breadcrumb-nav" aria-label="Breadcrumb">
                        <div class="breadcrumb-container">
                            <ol class="breadcrumb" itemscope itemtype="https://schema.org/BreadcrumbList">
                                <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
                                    <a href="<%=request.getContextPath()%>/" itemprop="item"><span itemprop="name">Home</span></a>
                                    <meta itemprop="position" content="1" />
                                </li>
                                <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
                                    <a href="<%=request.getContextPath()%>/music/" itemprop="item"><span itemprop="name">Music Tools</span></a>
                                    <meta itemprop="position" content="2" />
                                </li>
                                <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
                                    <span itemprop="name">AI Piano Duet</span>
                                    <meta itemprop="position" content="3" />
                                </li>
                            </ol>
                        </div>
                    </nav>

                    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                    <main class="ai-piano-container">
                        <div class="container">
                            <div class="machine-bg">
                                <div class="player"></div>
                                <div class="controls">
                                    <!-- Chord Display -->
                                    <div class="chord-display">
                                        <span class="chord-label">AI Playing:</span>
                                        <span id="aiChord" class="chord-name ai">-</span>
                                    </div>

                                    <div class="temperature-control">
                                        <label for="temperature">
                                            <strong>AI Creativity:</strong> <span id="tempValue">1.1</span>
                                        </label>
                                        <input type="range" id="temperature"
                                            min="0.2" max="2" step="0.1" value="1.1"
                                            aria-label="AI creativity temperature">
                                        <div class="temp-labels">
                                            <span>Conservative</span>
                                            <span>Wild</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="human-bg">
                                <div class="player"></div>
                                <div class="controls">
                                    <div class="midi-not-supported">
                                        🎹 Play using your <strong>computer keyboard</strong> (A-K for white keys,
                                        W-E-T-Y-U for black keys),
                                        or connect a <strong>MIDI controller</strong> on a
                                        <a href="https://caniuse.com/#feat=midi" target="_blank">MIDI-capable
                                            browser</a>.
                                    </div>
                                    <div class="midi-supported-no-inputs" style="display: none">
                                        🎹 Play using your <strong>computer keyboard</strong> or connect a <strong>MIDI
                                            controller</strong>.
                                    </div>
                                    <div class="midi-supported-with-inputs" style="display: none">
                                        🎹 Play using MIDI controller
                                        <select id="midi-inputs"></select>
                                        or <strong>computer keyboard</strong>.
                                    </div>
                                    <!-- Your Chord Display -->
                                    <div class="chord-display human-chord">
                                        <span class="chord-label">You're Playing:</span>
                                        <span id="humanChord" class="chord-name human">-</span>
                                    </div>

                                    <!-- Control Buttons -->
                                    <div class="control-buttons">
                                        <!-- Instrument Selector -->
                                        <div class="control-group">
                                            <label for="instrumentSelect">🎹 Instrument:</label>
                                            <select id="instrumentSelect">
                                                <option value="marimba" selected>Marimba</option>
                                                <option value="piano">Piano</option>
                                                <option value="synth">Synth Pad</option>
                                            </select>
                                        </div>

                                        <!-- Drums Toggle -->
                                        <div class="control-group">
                                            <button id="drumsToggle" class="control-btn">
                                                🥁 Drums: OFF
                                            </button>
                                        </div>

                                        <!-- Recording Controls -->
                                        <div class="control-group">
                                            <button id="recordBtn" class="control-btn record-btn">
                                                ⏺️ Record
                                            </button>
                                            <button id="downloadBtn" class="control-btn download-btn" disabled>
                                                💾 JSON
                                            </button>
                                            <button id="sheetMusicBtn" class="control-btn sheet-btn" disabled>
                                                🎼 Sheet
                                            </button>
                                        </div>
                                    </div>
                                    <p style="font-size: 0.85rem; opacity: 0.8;">Powered by
                                        <a href="https://magenta.tensorflow.org/" target="_blank">Google Magenta</a> •
                                        <a href="https://goo.gl/magenta/js" target="_blank">Magenta.js</a> •
                                        <a href="https://js.tensorflow.org/" target="_blank">TensorFlow.js</a> •
                                        <a href="https://tonejs.github.io/" target="_blank">Tone.js</a>
                                    </p>
                                </div>
                            </div>
                            <div class="keyboard">
                            </div>
                            <div class="loading">
                                Loading AI Model
                            </div>
                        </div>

                        <div class="feature-grid">
                            <div class="feature-card">
                                <h3>🤖 Neural Network AI</h3>
                                <p>Uses Google Magenta's Improv RNN model trained on thousands of jazz improvisations to
                                    create intelligent musical responses.</p>
                            </div>
                            <div class="feature-card">
                                <h3>🎼 Real-Time Duet</h3>
                                <p>The AI listens to your playing, detects chords, and generates complementary melodies
                                    in real-time for a seamless duet experience.</p>
                            </div>
                            <div class="feature-card">
                                <h3>🎹 Multiple Input Methods</h3>
                                <p>Play with computer keyboard, MIDI controller, or touch screen. Full support for all
                                    input methods on compatible devices.</p>
                            </div>
                            <div class="feature-card">
                                <h3>🎨 Visual Feedback</h3>
                                <p>See exactly who's playing what with color-coded highlights - blue for you, pink for
                                    the AI.</p>
                            </div>
                        </div>

                        <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                        <!-- SEO Content -->
                        <div class="tool-content">
                            <h2>About AI Piano Duet</h2>
                            <p>Experience the cutting edge of music technology with our AI Piano Duet tool. This
                                innovative application uses Google's Magenta artificial intelligence to create a
                                real-time musical duet between you and a neural network.</p>

                            <h3>How It Works</h3>
                            <p>The AI Piano Duet uses a sophisticated neural network called Improv RNN (Recurrent Neural
                                Network) that has been trained on thousands of jazz improvisations. When you play a
                                melody or chord:</p>
                            <ol>
                                <li>The AI analyzes your notes in real-time</li>
                                <li>It detects the underlying chord progression</li>
                                <li>The neural network generates a complementary melody</li>
                                <li>The AI continues playing as long as you hold the keys</li>
                            </ol>

                            <h3>Features</h3>
                            <ul>
                                <li><strong>AI-Powered Music Generation:</strong> Google Magenta's Improv RNN model
                                    creates intelligent musical responses</li>
                                <li><strong>Real-Time Duet:</strong> Experience seamless collaboration between human and
                                    AI</li>
                                <li><strong>Temperature Control:</strong> Adjust AI creativity from conservative (0.2)
                                    to wild (2.0)</li>
                                <li><strong>Live Chord Detection:</strong> See what chords you and the AI are playing
                                    in real-time</li>
                                <li><strong>Multiple Instruments:</strong> Choose from Marimba, Piano (Salamander), or
                                    Synth Pad sounds</li>
                                <li><strong>Backing Drums:</strong> Toggle a drum beat to play along with your duet</li>
                                <li><strong>Recording & Download:</strong> Record your duet sessions and download them
                                    for later</li>
                                <li><strong>MIDI Support:</strong> Connect your MIDI keyboard for authentic playing
                                    experience</li>
                                <li><strong>Computer Keyboard:</strong> Play using standard QWERTY keyboard (A-K white
                                    keys, W-E-T-Y-U black keys)</li>
                                <li><strong>Touch Support:</strong> Works on tablets and touch devices</li>
                                <li><strong>Visual Feedback:</strong> Color-coded highlights - blue for you, pink for
                                    AI</li>
                            </ul>

                            <h3>Technology Stack</h3>
                            <p>This tool leverages cutting-edge web technologies:</p>
                            <ul>
                                <li><strong>Magenta.js:</strong> Google's music AI library for the web</li>
                                <li><strong>TensorFlow.js:</strong> Machine learning in the browser</li>
                                <li><strong>Tone.js:</strong> Professional audio synthesis and effects</li>
                                <li><strong>Web MIDI API:</strong> Native MIDI controller support</li>
                                <li><strong>AudioKeys:</strong> Computer keyboard to MIDI mapping</li>
                                <li><strong>Tonal.js:</strong> Music theory and chord detection</li>
                            </ul>

                            <h3>Use Cases</h3>
                            <ul>
                                <li><strong>Music Education:</strong> Learn improvisation by playing with AI</li>
                                <li><strong>Composition:</strong> Get inspiration for new melodies</li>
                                <li><strong>Practice:</strong> Practice playing with an always-available duet partner
                                </li>
                                <li><strong>Entertainment:</strong> Explore the creative possibilities of AI music</li>
                                <li><strong>Research:</strong> Understand how neural networks generate music</li>
                            </ul>

                            <h3>Tips for Best Results</h3>
                            <ul>
                                <li>Start with simple melodies to understand how the AI responds</li>
                                <li>Hold notes longer to give the AI more time to generate music</li>
                                <li>Experiment with different temperature settings for varied creativity</li>
                                <li>Try playing chords to hear how the AI harmonizes</li>
                                <li>Use a MIDI keyboard for the most expressive control</li>
                            </ul>

                            <h3>Browser Compatibility</h3>
                            <p>This tool works best on modern browsers with Web Audio API support. MIDI functionality
                                requires browsers that support the Web MIDI API (Chrome, Edge, Opera). The AI model
                                requires a stable internet connection for initial loading.</p>
                        </div>

                    </main>

                    <footer class="page-footer">
                        <div class="footer-content">
                            <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
                            <div class="footer-links">
                                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                                <a href="<%=request.getContextPath()%>/music/" class="footer-link">Music Tools</a>
                                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                            </div>
                        </div>
                    </footer>

                    <!-- Sheet Music Modal -->
                    <div id="sheetMusicModal" class="sheet-modal" style="display: none;">
                        <div class="sheet-modal-content">
                            <div class="sheet-modal-header">
                                <h3>🎼 Your Duet - Sheet Music</h3>
                                <button id="closeSheetModal" class="close-modal-btn">&times;</button>
                            </div>
                            <div class="sheet-modal-body">
                                <div class="sheet-legend">
                                    <span class="legend-item"><span class="legend-color human"></span> Your notes</span>
                                    <span class="legend-item"><span class="legend-color ai"></span> AI notes</span>
                                </div>
                                <div id="sheetMusicContainer"></div>
                            </div>
                            <div class="sheet-modal-footer">
                                <button id="downloadSheetBtn" class="control-btn">📥 Download PNG</button>
                                <button id="downloadMidiBtn" class="control-btn">🎹 Download MIDI</button>
                            </div>
                        </div>
                    </div>

                    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
                    <%@ include file="../modern/components/analytics.jsp" %>

                        <!-- External Libraries -->
                        <script src="https://cdn.jsdelivr.net/npm/vexflow@4.2.3/build/cjs/vexflow.js"></script>
                        <script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
                        <script src="https://cdn.jsdelivr.net/npm/tone@14.8.49/build/Tone.min.js"></script>
                        <script src="https://cdn.jsdelivr.net/npm/@magenta/music@^1.0.0"></script>
                        <script src="https://cdn.jsdelivr.net/gh/kylestetz/AudioKeys@master/dist/audiokeys.js"></script>
                        <script src="https://cdn.jsdelivr.net/npm/webmidi@2.5.3/dist/webmidi.min.js"></script>
                        <script src="https://cdn.jsdelivr.net/npm/tonal@2.2.2/build/transpiled.min.js"></script>
                        <script
                            src="https://cdn.jsdelivr.net/npm/startaudiocontext@1.2.1/StartAudioContext.min.js"></script>

                        <script
                            src="<%=request.getContextPath()%>/music/js/ai-piano-duet.js?v=<%=cacheVersion%>"></script>
            </body>

            </html>