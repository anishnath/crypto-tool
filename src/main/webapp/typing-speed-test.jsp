<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Free Typing Speed Test Online | Multi-Language WPM Test with Keyboard Layouts | 8gwifi.org</title>
    <meta name="description" content="Free advanced typing speed test with 5 keyboard layouts (QWERTY, Dvorak, Colemak, AZERTY, QWERTZ), 4 languages (English, Spanish, French, German), specialized topics (programming, medical, legal, scientific), live WPM graph, keyboard heatmap. Track history and personal best. No signup.">
    <meta name="keywords" content="typing speed test, wpm test, free typing test, words per minute test, keyboard speed test, typing practice online, typing accuracy test, how fast can i type, typing test online free, keyboard typing practice, improve typing speed, live wpm graph, keyboard heatmap, typing history tracker, code typing test, quote typing test, typing difficulty levels, dvorak typing test, colemak typing test, azerty typing test, qwertz typing test, spanish typing test, french typing test, german typing test, medical typing test, legal typing test, programming typing test, scientific typing practice, multilingual typing test">
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">
    <link rel="canonical" href="https://8gwifi.org/typing-speed-test.jsp">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Free Multi-Language Typing Speed Test",
        "alternateName": ["WPM Test", "Typing Test Online", "Keyboard Speed Test", "Dvorak Typing Test", "Colemak Typing Test", "Spanish Typing Test", "French Typing Test", "German Typing Test", "Medical Typing Test", "Programming Typing Test"],
        "description": "Advanced free typing speed test with 5 keyboard layouts (QWERTY, Dvorak, Colemak, AZERTY, QWERTZ), 4 languages, specialized topics, live WPM graph, keyboard heatmap, and progress tracking.",
        "url": "https://8gwifi.org/typing-speed-test.jsp",
        "applicationCategory": "UtilitiesApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
        "datePublished": "2025-12-01",
        "dateModified": "2025-12-03",
        "featureList": [
            "5 keyboard layouts: QWERTY, Dvorak, Colemak, AZERTY, QWERTZ",
            "4 languages: English, Spanish, French, German",
            "Specialized topics: Programming, Medical, Legal, Scientific",
            "Real-time WPM calculation with live graph",
            "Accuracy tracking and keystroke counting",
            "Multiple test modes: Time, Words, Quotes, Code snippets",
            "Time options: 15s, 30s, 60s, 120s",
            "Word count options: 10, 25, 50, 100 words",
            "Difficulty levels: Easy, Medium, Hard (500+ words each)",
            "Optional punctuation, numbers, and capitals",
            "Keyboard heatmap showing key accuracy per layout",
            "History tracking with personal best and averages",
            "LocalStorage persistence - no signup required",
            "Typing sounds with toggle option",
            "Share results on Twitter",
            "Mobile responsive design"
        ]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Take a Typing Speed Test",
        "description": "Step-by-step guide to measure your typing speed in Words Per Minute (WPM) with live tracking",
        "totalTime": "PT2M",
        "step": [
            {"@type": "HowToStep", "name": "Choose test mode", "text": "Select Time (15s-120s), Words (10-100), Quote, or Code mode based on your practice goals", "position": 1},
            {"@type": "HowToStep", "name": "Set difficulty", "text": "Choose Easy, Medium, or Hard difficulty. Optionally enable punctuation, numbers, or capitals", "position": 2},
            {"@type": "HowToStep", "name": "Start typing", "text": "Begin typing the highlighted word. The timer starts automatically. Press SPACE to move to the next word", "position": 3},
            {"@type": "HowToStep", "name": "Monitor progress", "text": "Watch your live WPM graph and keyboard heatmap to identify weak keys", "position": 4},
            {"@type": "HowToStep", "name": "View results", "text": "See your final WPM, accuracy, and keystroke stats. Results are saved to your history automatically", "position": 5}
        ]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is a good typing speed (WPM)?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Average typing speed is 40 WPM. 60-70 WPM is considered good for most jobs. Professional typists often achieve 80-100+ WPM. Competitive typists can reach 150+ WPM."
                }
            },
            {
                "@type": "Question",
                "name": "How is WPM calculated?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "WPM is calculated by dividing the total number of correct characters typed by 5 (standard word length), then dividing by the time elapsed in minutes. Formula: (Correct Characters / 5) / Time in Minutes."
                }
            },
            {
                "@type": "Question",
                "name": "How can I improve my typing speed?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Practice regularly, use proper finger positioning (home row), don't look at the keyboard, focus on accuracy before speed, and take typing tests daily to track progress."
                }
            },
            {
                "@type": "Question",
                "name": "What is typing accuracy and why does it matter?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Typing accuracy is the percentage of correct keystrokes out of total keystrokes. High accuracy (95%+) is crucial because errors slow you down with corrections. It's better to type accurately at 50 WPM than sloppily at 70 WPM."
                }
            },
            {
                "@type": "Question",
                "name": "What are the different typing test modes available?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "This typing test offers 4 modes: Time mode (15s, 30s, 60s, 120s countdown), Words mode (type 10, 25, 50, or 100 words), Quote mode (type famous quotes), and Code mode (practice typing programming code snippets)."
                }
            },
            {
                "@type": "Question",
                "name": "What does the keyboard heatmap show?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The keyboard heatmap visually shows your typing accuracy for each key. Green keys indicate high accuracy, while red/hot keys show which letters you frequently mistype. This helps identify weak spots to practice."
                }
            },
            {
                "@type": "Question",
                "name": "Is my typing history saved?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, your typing test results are automatically saved to your browser's local storage. You can view your personal best WPM, average WPM, average accuracy, and total tests taken. No account or signup required."
                }
            },
            {
                "@type": "Question",
                "name": "What keyboard layouts are supported?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "This typing test supports 5 keyboard layouts: QWERTY (standard US/UK), Dvorak (alternative ergonomic), Colemak (modern alternative), AZERTY (French), and QWERTZ (German/Central European). The keyboard heatmap updates to match your selected layout."
                }
            },
            {
                "@type": "Question",
                "name": "Can I practice typing in other languages?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes! The typing test supports 4 languages: English (with 500+ words across Easy/Medium/Hard levels), Spanish, French, and German. Each language has its own word dictionary for authentic practice."
                }
            },
            {
                "@type": "Question",
                "name": "What specialized typing topics are available?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Beyond general vocabulary, you can practice specialized terminology: Programming (functions, variables, DevOps terms), Medical (diagnoses, anatomy, procedures), Legal (court terms, contracts, litigation), and Scientific (research methodology, lab terms)."
                }
            }
        ]
    }
    </script>

    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

            <style>
                body {
                    background: #f8fafc;
                }

                .stats-card {
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
                    padding: 1rem;
                    display: flex;
                    justify-content: space-around;
                    align-items: center;
                    text-align: center;
                }

                .stat-item h3 {
                    font-size: 1.75rem;
                    font-weight: 700;
                    color: #4a5568;
                    margin: 0;
                }

                .stat-item p {
                    color: #718096;
                    font-size: 0.65rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin: 0;
                }

                .typing-area {
                    background: #1e293b;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
                    padding: 0.75rem 1.25rem;
                    position: relative;
                    min-height: 140px;
                    font-family: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
                    cursor: text;
                }

                /* Current word display - big and clear */
                .current-word-display {
                    text-align: center;
                    padding: 0.75rem 0;
                    border-bottom: 1px solid #334155;
                    margin-bottom: 0.5rem;
                }

                .current-word-display .label {
                    font-size: 0.65rem;
                    color: #64748b;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                    margin-bottom: 0.2rem;
                }

                .current-word-display .word {
                    font-size: 1.75rem;
                    font-weight: 600;
                    letter-spacing: 3px;
                    color: #94a3b8;
                }

                .current-word-display .word .char {
                    display: inline-block;
                    transition: color 0.1s;
                }

                .current-word-display .word .char.correct {
                    color: #10b981;
                }

                .current-word-display .word .char.incorrect {
                    color: #ef4444;
                    text-decoration: underline;
                }

                .current-word-display .word .char.current {
                    border-left: 2px solid #60a5fa;
                    animation: blink 1s infinite;
                    margin-left: -1px;
                    padding-left: 1px;
                }

                .current-word-display .space-hint {
                    display: inline-block;
                    color: #475569;
                    font-size: 1.2rem;
                    margin-left: 6px;
                    padding: 0 6px;
                    border: 1px dashed #475569;
                    border-radius: 4px;
                    vertical-align: middle;
                }

                .current-word-display .space-hint.ready {
                    color: #10b981;
                    border-color: #10b981;
                    background: rgba(16, 185, 129, 0.1);
                }

                /* Upcoming words - smaller below */
                .upcoming-words {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 4px 8px;
                    justify-content: center;
                    padding: 0.3rem 0;
                    max-height: 40px;
                    overflow: hidden;
                }

                .upcoming-words .word {
                    color: #475569;
                    font-size: 0.8rem;
                    padding: 2px 5px;
                    border-radius: 4px;
                }

                .upcoming-words .word:first-child {
                    color: #60a5fa;
                    background: rgba(96, 165, 250, 0.15);
                    border: 1px solid rgba(96, 165, 250, 0.3);
                    font-weight: 600;
                }

                .upcoming-words .word:nth-child(2) {
                    color: #94a3b8;
                }

                .upcoming-words .word:nth-child(3) {
                    color: #64748b;
                }

                /* Instructions hint */
                .typing-hint {
                    text-align: center;
                    color: #64748b;
                    font-size: 0.75rem;
                    padding-top: 0.5rem;
                    border-top: 1px solid #334155;
                }

                .typing-hint kbd {
                    background: #334155;
                    padding: 2px 8px;
                    border-radius: 4px;
                    font-family: inherit;
                }

                /* Mode & Settings Controls */
                .settings-row {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 0.3rem 0.75rem;
                    justify-content: center;
                    align-items: center;
                    padding: 0.35rem 0.5rem;
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                }

                .setting-group {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .setting-group label {
                    font-size: 0.75rem;
                    color: #64748b;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin: 0;
                }

                .pill-selector {
                    display: flex;
                    background: #e2e8f0;
                    border-radius: 20px;
                    padding: 3px;
                }

                .pill-btn {
                    border: none;
                    background: transparent;
                    padding: 4px 12px;
                    border-radius: 15px;
                    cursor: pointer;
                    font-size: 0.8rem;
                    font-weight: 500;
                    color: #64748b;
                    transition: all 0.2s;
                }

                .pill-btn.active {
                    background: #fff;
                    color: #3b82f6;
                    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                }

                .pill-btn:hover:not(.active) {
                    color: #475569;
                }

                /* Checkbox toggles */
                .toggle-options {
                    display: flex;
                    gap: 1rem;
                }

                .toggle-option {
                    display: flex;
                    align-items: center;
                    gap: 0.3rem;
                    font-size: 0.8rem;
                    color: #64748b;
                    cursor: pointer;
                }

                .toggle-option input {
                    cursor: pointer;
                }

                /* Live WPM Chart */
                .chart-container {
                    background: #fff;
                    border-radius: 8px;
                    padding: 0.5rem;
                    box-shadow: 0 1px 4px rgba(0,0,0,0.06);
                    height: 120px;
                }

                .chart-container h6 {
                    margin: 0 0 0.2rem 0;
                    color: #64748b;
                    font-size: 0.65rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }

                /* Keyboard Heatmap */
                .keyboard-container {
                    background: #fff;
                    border-radius: 8px;
                    padding: 0.5rem;
                    box-shadow: 0 1px 4px rgba(0,0,0,0.06);
                }

                .keyboard-container h6 {
                    margin: 0 0 0.3rem 0;
                    color: #64748b;
                    font-size: 0.65rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }

                .keyboard {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                    align-items: center;
                }

                .keyboard-row {
                    display: flex;
                    gap: 2px;
                }

                .key {
                    width: 24px;
                    height: 24px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: #e2e8f0;
                    border-radius: 3px;
                    font-size: 0.6rem;
                    font-weight: 600;
                    color: #475569;
                    text-transform: uppercase;
                    transition: all 0.2s;
                }

                .key.space {
                    width: 120px;
                }

                .key.correct {
                    background: #d1fae5;
                    color: #059669;
                }

                .key.error {
                    background: #fee2e2;
                    color: #dc2626;
                }

                .key.hot {
                    background: #fecaca;
                    color: #b91c1c;
                }

                /* History Panel */
                .history-panel {
                    background: #fff;
                    border-radius: 8px;
                    padding: 0.5rem;
                    box-shadow: 0 1px 4px rgba(0,0,0,0.06);
                }

                .history-panel h6 {
                    margin: 0 0 0.3rem 0;
                    color: #64748b;
                    font-size: 0.65rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .history-panel .clear-btn {
                    font-size: 0.65rem;
                    color: #94a3b8;
                    cursor: pointer;
                    border: none;
                    background: none;
                }

                .history-panel .clear-btn:hover {
                    color: #ef4444;
                }

                .history-stats {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 0.3rem;
                    margin-bottom: 0.3rem;
                    padding-bottom: 0.3rem;
                    border-bottom: 1px solid #e2e8f0;
                }

                .history-stat {
                    text-align: center;
                }

                .history-stat .value {
                    font-size: 1rem;
                    font-weight: 700;
                    color: #1e293b;
                }

                .history-stat .label {
                    font-size: 0.55rem;
                    color: #94a3b8;
                    text-transform: uppercase;
                }

                .history-list {
                    max-height: 100px;
                    overflow-y: auto;
                }

                .history-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 0.3rem 0.4rem;
                    border-radius: 4px;
                    font-size: 0.75rem;
                }

                .history-item:nth-child(odd) {
                    background: #f8fafc;
                }

                .history-item .wpm {
                    font-weight: 600;
                    color: #3b82f6;
                }

                .history-item .accuracy {
                    color: #10b981;
                }

                .history-item .date {
                    color: #94a3b8;
                    font-size: 0.75rem;
                }

                /* Custom text modal */
                .custom-text-input {
                    width: 100%;
                    min-height: 100px;
                    padding: 1rem;
                    border: 1px solid #e2e8f0;
                    border-radius: 8px;
                    font-family: inherit;
                    font-size: 0.9rem;
                    resize: vertical;
                }

                .custom-text-input:focus {
                    outline: none;
                    border-color: #3b82f6;
                }

                .sound-toggle {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    font-size: 0.85rem;
                    color: #718096;
                }

                .sound-toggle input {
                    cursor: pointer;
                }

                /* Progress bar */
                .progress-bar-wrapper {
                    height: 3px;
                    background: #e2e8f0;
                    border-radius: 2px;
                    margin-top: 0.5rem;
                    overflow: hidden;
                }

                .progress-bar-fill {
                    height: 100%;
                    background: linear-gradient(90deg, #4299e1, #667eea);
                    border-radius: 2px;
                    transition: width 0.3s ease;
                    width: 100%;
                }

                @keyframes blink {
                    0%, 100% { opacity: 1; }
                    50% { opacity: 0; }
                }

                .hidden-input {
                    opacity: 0;
                    position: absolute;
                    z-index: -1;
                }

                .controls {
                    display: flex;
                    justify-content: center;
                    gap: 1rem;
                    margin-top: 2rem;
                }

                .time-selector {
                    display: flex;
                    background: #edf2f7;
                    border-radius: 20px;
                    padding: 5px;
                }

                .time-btn {
                    border: none;
                    background: transparent;
                    padding: 5px 15px;
                    border-radius: 15px;
                    cursor: pointer;
                    font-weight: 600;
                    color: #718096;
                    transition: all 0.2s;
                }

                .time-btn.active {
                    background: #fff;
                    color: #4299e1;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .result-modal {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    z-index: 1000;
                    justify-content: center;
                    align-items: center;
                }

                .result-content {
                    background: #fff;
                    padding: 2rem;
                    border-radius: 10px;
                    text-align: center;
                    max-width: 500px;
                    width: 90%;
                    animation: slideIn 0.3s ease-out;
                }

                @keyframes slideIn {
                    from {
                        transform: translateY(-20px);
                        opacity: 0;
                    }

                    to {
                        transform: translateY(0);
                        opacity: 1;
                    }
                }

                .result-score {
                    font-size: 4rem;
                    font-weight: 800;
                    color: #4299e1;
                    margin: 1rem 0;
                }

            </style>
    </head>
<body>
<%@ include file="navigation.jsp" %>


<div class="container-fluid px-lg-4" style="margin-top: 60px;">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-1">
        <div>
            <h1 class="h5 mb-0">Typing Speed Test</h1>
        </div>
        <div>
            <span class="badge badge-secondary"><i class="fas fa-user"></i> <a href="https://x.com/anish2good" target="_blank" class="text-white">@anish2good</a></span>
        </div>
    </div>

    <div class="row">
        <!-- LEFT COLUMN: Typing Area -->
        <div class="col-lg-7">
            <!-- Settings Row -->
            <div class="settings-row mb-1 py-1">
                <div class="setting-group">
                    <label>Mode</label>
                    <div class="pill-selector" id="modeSelector">
                        <button class="pill-btn active" data-mode="time">Time</button>
                        <button class="pill-btn" data-mode="words">Words</button>
                        <button class="pill-btn" data-mode="quote">Quote</button>
                        <button class="pill-btn" data-mode="code">Code</button>
                    </div>
                </div>
                <div class="setting-group" id="timeSetting">
                    <label>Duration</label>
                    <div class="pill-selector" id="timeSelector">
                        <button class="pill-btn" data-time="15">15s</button>
                        <button class="pill-btn" data-time="30">30s</button>
                        <button class="pill-btn active" data-time="60">60s</button>
                        <button class="pill-btn" data-time="120">120s</button>
                    </div>
                </div>
                <div class="setting-group" id="wordsSetting" style="display:none;">
                    <label>Words</label>
                    <div class="pill-selector" id="wordsSelector">
                        <button class="pill-btn" data-words="10">10</button>
                        <button class="pill-btn active" data-words="25">25</button>
                        <button class="pill-btn" data-words="50">50</button>
                        <button class="pill-btn" data-words="100">100</button>
                    </div>
                </div>
                <div class="setting-group">
                    <label>Difficulty</label>
                    <div class="pill-selector" id="difficultySelector">
                        <button class="pill-btn active" data-diff="easy">Easy</button>
                        <button class="pill-btn" data-diff="medium">Medium</button>
                        <button class="pill-btn" data-diff="hard">Hard</button>
                    </div>
                </div>
            </div>

            <!-- Options Row -->
            <div class="settings-row mb-1 py-1">
                <div class="setting-group">
                    <label>Language</label>
                    <div class="pill-selector" id="languageSelector">
                        <button class="pill-btn active" data-lang="english">EN</button>
                        <button class="pill-btn" data-lang="spanish">ES</button>
                        <button class="pill-btn" data-lang="french">FR</button>
                        <button class="pill-btn" data-lang="german">DE</button>
                    </div>
                </div>
                <div class="setting-group">
                    <label>Topic</label>
                    <div class="pill-selector" id="topicSelector">
                        <button class="pill-btn active" data-topic="general">General</button>
                        <button class="pill-btn" data-topic="programming">Code</button>
                        <button class="pill-btn" data-topic="medical">Medical</button>
                        <button class="pill-btn" data-topic="legal">Legal</button>
                        <button class="pill-btn" data-topic="scientific">Science</button>
                    </div>
                </div>
                <div class="setting-group">
                    <label>Keyboard</label>
                    <div class="pill-selector" id="layoutSelector">
                        <button class="pill-btn active" data-layout="qwerty">QWERTY</button>
                        <button class="pill-btn" data-layout="dvorak">Dvorak</button>
                        <button class="pill-btn" data-layout="colemak">Colemak</button>
                        <button class="pill-btn" data-layout="azerty">AZERTY</button>
                        <button class="pill-btn" data-layout="qwertz">QWERTZ</button>
                    </div>
                </div>
            </div>

            <!-- Toggles Row -->
            <div class="settings-row mb-1 py-1">
                <div class="toggle-options">
                    <label class="toggle-option"><input type="checkbox" id="punctuationToggle"> Punctuation</label>
                    <label class="toggle-option"><input type="checkbox" id="numbersToggle"> Numbers</label>
                    <label class="toggle-option"><input type="checkbox" id="capsToggle"> Capitals</label>
                    <label class="toggle-option"><input type="checkbox" id="soundToggle" checked> <i class="fas fa-volume-up"></i></label>
                </div>
                <button class="btn btn-primary btn-sm rounded-pill px-3" onclick="resetTest()"><i class="fas fa-redo-alt"></i> Restart</button>
            </div>

            <!-- Typing Area -->
            <div class="typing-area" id="typingArea" onclick="focusInput()">
                <div class="current-word-display">
                    <div class="label">Type this word:</div>
                    <div class="word" id="currentWordDisplay"></div>
                    <span class="space-hint" id="spaceHint">SPACE</span>
                </div>
                <div class="upcoming-words" id="upcomingWords"></div>
                <div class="typing-hint">Type each letter → press <kbd>SPACE</kbd> to go to next word</div>
                <input type="text" id="hiddenInput" class="hidden-input" autocomplete="off" spellcheck="false" aria-label="Type words here">
            </div>

            <!-- Progress Bar -->
            <div class="progress-bar-wrapper">
                <div class="progress-bar-fill" id="progressBar"></div>
            </div>

            <!-- Keyboard Heatmap -->
            <div class="keyboard-container mt-1">
                <h6><i class="fas fa-keyboard"></i> Key Accuracy</h6>
                <div class="keyboard" id="keyboard">
                    <div class="keyboard-row">
                        <div class="key" data-key="q">q</div><div class="key" data-key="w">w</div><div class="key" data-key="e">e</div><div class="key" data-key="r">r</div><div class="key" data-key="t">t</div><div class="key" data-key="y">y</div><div class="key" data-key="u">u</div><div class="key" data-key="i">i</div><div class="key" data-key="o">o</div><div class="key" data-key="p">p</div>
                    </div>
                    <div class="keyboard-row">
                        <div class="key" data-key="a">a</div><div class="key" data-key="s">s</div><div class="key" data-key="d">d</div><div class="key" data-key="f">f</div><div class="key" data-key="g">g</div><div class="key" data-key="h">h</div><div class="key" data-key="j">j</div><div class="key" data-key="k">k</div><div class="key" data-key="l">l</div>
                    </div>
                    <div class="keyboard-row">
                        <div class="key" data-key="z">z</div><div class="key" data-key="x">x</div><div class="key" data-key="c">c</div><div class="key" data-key="v">v</div><div class="key" data-key="b">b</div><div class="key" data-key="n">n</div><div class="key" data-key="m">m</div>
                    </div>
                    <div class="keyboard-row">
                        <div class="key space" data-key=" ">space</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT COLUMN: Stats & Chart -->
        <div class="col-lg-5">
            <!-- Stats Card -->
            <div class="stats-card mb-1">
                <div class="stat-item">
                    <h3 id="timer">60</h3>
                    <p>Seconds</p>
                </div>
                <div class="stat-item">
                    <h3 id="wpm">0</h3>
                    <p>WPM</p>
                </div>
                <div class="stat-item">
                    <h3 id="accuracy">100%</h3>
                    <p>Accuracy</p>
                </div>
            </div>

            <!-- Live WPM Chart -->
            <div class="chart-container mb-1">
                <h6><i class="fas fa-chart-line"></i> Live WPM</h6>
                <canvas id="wpmChart"></canvas>
            </div>

            <!-- History Panel -->
            <div class="history-panel">
                <h6>
                    <span><i class="fas fa-history"></i> Your History</span>
                    <button class="clear-btn" onclick="clearHistory()">Clear All</button>
                </h6>
                <div class="history-stats">
                    <div class="history-stat">
                        <div class="value" id="historyBestWpm">-</div>
                        <div class="label">Best</div>
                    </div>
                    <div class="history-stat">
                        <div class="value" id="historyAvgWpm">-</div>
                        <div class="label">Avg</div>
                    </div>
                    <div class="history-stat">
                        <div class="value" id="historyAvgAcc">-</div>
                        <div class="label">Acc</div>
                    </div>
                    <div class="history-stat">
                        <div class="value" id="historyTests">0</div>
                        <div class="label">Tests</div>
                    </div>
                </div>
                <div class="history-list" id="historyList">
                    <div class="text-muted text-center py-1" style="font-size:0.75rem;">No tests yet.</div>
                </div>
            </div>
        </div>
    </div>

            <!-- Result Modal -->
            <div class="result-modal" id="resultModal">
                <div class="result-content">
                    <h2 class="mb-4">Test Complete!</h2>
                    <div class="row">
                        <div class="col-6">
                            <p class="text-muted mb-0">WPM</p>
                            <div class="result-score" id="finalWpm">0</div>
                        </div>
                        <div class="col-6">
                            <p class="text-muted mb-0">Accuracy</p>
                            <div class="result-score text-success" id="finalAccuracy"
                                style="font-size: 3rem; margin-top: 0.5rem;">100%</div>
                        </div>
                    </div>
                    <div class="row mb-4">
                        <div class="col-4">
                            <small class="text-muted">Keystrokes</small>
                            <h5 id="finalKeystrokes">0</h5>
                        </div>
                        <div class="col-4">
                            <small class="text-muted">Correct</small>
                            <h5 class="text-success" id="finalCorrect">0</h5>
                        </div>
                        <div class="col-4">
                            <small class="text-muted">Wrong</small>
                            <h5 class="text-danger" id="finalWrong">0</h5>
                        </div>
                    </div>
                    <button class="btn btn-primary btn-lg rounded-pill px-5" onclick="closeModal()">Try Again</button>
                    <div class="mt-3">
                        <button class="btn btn-outline-info btn-sm" onclick="shareResult()"><i
                                class="fab fa-twitter"></i> Share Result</button>
                    </div>
                </div>
            </div>
</div>

<%@ include file="footer_adsense.jsp" %>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
                    // Keyboard layouts configuration
                    const keyboardLayouts = {
                        qwerty: {
                            name: 'QWERTY',
                            rows: [
                                ['q','w','e','r','t','y','u','i','o','p'],
                                ['a','s','d','f','g','h','j','k','l'],
                                ['z','x','c','v','b','n','m']
                            ]
                        },
                        dvorak: {
                            name: 'Dvorak',
                            rows: [
                                ['\'',',','.',':','p','y','f','g','c','r','l'],
                                ['a','o','e','u','i','d','h','t','n','s'],
                                [';','q','j','k','x','b','m','w','v','z']
                            ]
                        },
                        colemak: {
                            name: 'Colemak',
                            rows: [
                                ['q','w','f','p','g','j','l','u','y',';'],
                                ['a','r','s','t','d','h','n','e','i','o'],
                                ['z','x','c','v','b','k','m']
                            ]
                        },
                        azerty: {
                            name: 'AZERTY',
                            rows: [
                                ['a','z','e','r','t','y','u','i','o','p'],
                                ['q','s','d','f','g','h','j','k','l','m'],
                                ['w','x','c','v','b','n']
                            ]
                        },
                        qwertz: {
                            name: 'QWERTZ',
                            rows: [
                                ['q','w','e','r','t','z','u','i','o','p'],
                                ['a','s','d','f','g','h','j','k','l'],
                                ['y','x','c','v','b','n','m']
                            ]
                        }
                    };
                    let currentLayout = 'qwerty';

                    // Expanded word lists by difficulty (500+ words each)
                    const easyWords = ["the","be","of","and","a","to","in","he","have","it","that","for","they","with","as","not","on","she","at","by","this","we","you","do","but","from","or","one","all","will","there","say","who","make","when","can","more","if","no","man","out","other","so","what","time","up","go","about","than","into","only","new","year","some","take","come","these","know","see","use","get","like","then","first","any","work","now","may","give","over","think","most","even","find","day","also","after","way","many","must","look","before","back","long","where","much","well","down","own","just","good","each","how","too","little","very","still","hand","old","life","tell","here","show","both","need","call","under","last","right","move","thing","same","part","real","want","off","few","small","ask","late","home","large","end","open","keep","face","fact","play","help","line","turn","big","such","put","set","try","again","why","ask","men","went","read","long","need","land","side","been","name","said","word","own","find","made","did","sound","each","form","two","three","way","more","long","been","call","first","who","may","down","side","been","now","find","long","down","day","did","get","come","made","may","part","over","new","sound","take","only","little","work","know","place","year","live","me","back","give","most","very","after","thing","our","just","name","good","sentence","man","think","say","great","where","help","through","much","before","line","right","too","mean","old","any","same","tell","boy","follow","came","want","show","also","around","form","three","small","set","put","end","does","another","well","large","must","big","even","such","because","turn","here","why","ask","went","men","read","need","land","different","home","us","move","try","kind","hand","picture","again","change","off","play","spell","air","away","animal","house","point","page","letter","mother","answer","found","study","still","learn","should","America","world","high","every","near","add","food","between","own","below","country","plant","last","school","father","keep","tree","never","start","city","earth","eye","light","thought","head","under","story","saw","left","late","run","while","press","close","night","real","life","few","north","book","carry","took","science","eat","room","friend","began","idea","fish","mountain","stop","once","base","hear","horse","cut","sure","watch","color","face","wood","main","enough","plain","girl","usual","young","ready","above","ever","red","list","though","feel","talk","bird","soon","body","dog","family","direct","pose","leave","song","measure","door","product","black","short","numeral","class","wind","question","happen","complete","ship","area","half","rock","order","fire","south","problem","piece","told","knew","pass","since","top","whole","king","space","heard","best","hour","better","true","during","hundred","five","remember","step","early","hold","west","ground","interest","reach","fast","verb","sing","listen","six","table","travel","less","morning","ten","simple","several","vowel","toward","war","lay","against","pattern","slow","center","love","person","money","serve","appear","road","map","rain","rule","govern","pull","cold","notice","voice","unit","power","town","fine","certain","fly","fall","lead","cry","dark","machine","note","wait","plan","figure","star","box","noun","field","rest","correct","able","pound","done","beauty","drive","stood","contain","front","teach","week","final","gave","green","quick","develop","ocean","warm","free","minute","strong","special","mind","behind","clear","tail","produce","fact","street","inch","multiply","nothing","course","stay","wheel","full","force","blue","object","decide","surface","deep","moon","island","foot","system","busy","test","record","boat","common","gold","possible","plane","stead","dry","wonder","laugh","thousand","ago","ran","check","game","shape","equate","hot","miss","brought","heat","snow","tire","bring","yes","distant","fill","east","paint","language","among","grand","ball","yet","wave","drop","heart","present","heavy","dance","engine","position","arm","wide","sail","material","size","vary","settle","speak","weight","general","ice","matter","circle","pair","include","divide","syllable","felt","perhaps","pick","sudden","count","square","reason","length","represent","art","subject","region","energy","hunt","probable","bed","brother","egg","ride","cell","believe","fraction","forest","sit","race","window","store","summer","train","sleep","prove","lone","leg","exercise","wall","catch","mount","wish","sky","board","joy","winter","sat","written","wild","instrument","kept","glass","grass","cow","job","edge","sign","visit","past","soft","fun","bright","gas","weather","month","million","bear","finish","happy","hope","flower","clothe","strange","gone","trade","melody","trip","office","receive","row","mouth","exact","symbol","die","least","trouble","shout","except","wrote","seed","tone","join","suggest","clean","break","lady","yard","rise","bad","blow","oil","blood","touch","grew","cent","mix","team","wire","cost","lost","brown","wear","garden","equal","sent","choose","fell","fit","flow","fair","bank","collect","save","control","decimal","gentle","woman","captain","practice","separate","difficult","doctor","please","protect","noon","whose","locate","ring","character","insect","caught","period","indicate","radio","spoke","atom","human","history","effect","electric","expect","crop","modern","element","hit","student","corner","party","supply","bone","rail","imagine","provide","agree","thus","capital","chair","danger","fruit","rich","thick","soldier","process","operate","guess","necessary","sharp","wing","create","neighbor","wash","bat","rather","crowd","corn","compare","poem","string","bell","depend","meat","rub","tube","famous","dollar","stream","fear","sight","thin","triangle","planet","hurry","chief","colony","clock","mine","tie","enter","major","fresh","search","send","yellow","gun","allow","print","dead","spot","desert","suit","current","lift","rose","continue","block","chart","hat","sell","success","company","subtract","event","particular","deal","swim","term","opposite","wife","shoe","shoulder","spread","arrange","camp","invent","cotton","born","determine","quart","nine","truck","noise","level","chance","gather","shop","stretch","throw","shine","property","column","molecule","select","wrong","gray","repeat","require","broad","prepare","salt","nose","plural","anger","claim","continent","oxygen","sugar","death","pretty","skill","women","season","solution","magnet","silver","thank","branch","match","suffix","especially","fig","afraid","huge","sister","steel","discuss","forward","similar","guide","experience","score","apple","bought","led","pitch","coat","mass","card","band","rope","slip","win","dream","evening","condition","feed","tool","total","basic","smell","valley","nor","double","seat","arrive","master","track","parent","shore","division","sheet","substance","favor","connect","post","spend","chord","fat","glad","original","share","station","dad","bread","charge","proper","bar","offer","segment","slave","duck","instant","market","degree","populate","chick","dear","enemy","reply","drink","occur","support","speech","nature","range","steam","motion","path","liquid","log","meant","quotient","teeth","shell","neck"];

                    const mediumWords = ["which","would","could","state","become","house","between","develop","general","school","never","another","begin","while","number","turn","leave","might","point","form","child","since","against","interest","person","public","follow","during","present","without","again","hold","govern","around","possible","head","consider","program","problem","however","system","order","group","stand","increase","early","course","change","through","great","should","people","because","those","feel","seem","high","place","world","nation","write","mean","different","important","every","together","often","question","example","include","government","company","country","story","until","always","city","mother","father","water","earth","money","picture","study","paper","ability","absolute","accept","accident","account","achieve","acquire","across","action","active","actual","address","admit","advance","advice","affect","afford","afraid","agency","agent","agree","ahead","allow","almost","alone","along","already","although","always","amount","analysis","ancient","animal","announce","annual","answer","anxiety","anybody","anymore","anything","anyway","anywhere","apart","appear","application","apply","approach","appropriate","argue","argument","around","arrange","arrest","arrive","article","artist","aspect","assault","assert","assess","assign","assist","associate","assume","attach","attack","attempt","attend","attention","attitude","attract","audience","author","authority","available","average","avoid","award","aware","beautiful","before","begin","behavior","behind","believe","belong","below","benefit","beside","better","between","beyond","billion","birthday","board","border","borrow","bother","bottom","branch","break","bridge","brief","bright","bring","broad","brother","budget","build","building","burden","business","cabinet","camera","campaign","cancer","candidate","capable","capacity","capital","captain","capture","carbon","career","careful","carrier","carry","category","cause","celebrate","center","central","century","certain","chain","chair","chairman","challenge","chamber","champion","chance","change","channel","chapter","character","charge","charity","cheap","check","chemical","chief","child","childhood","chinese","choice","choose","church","cigarette","circle","circumstance","citizen","civil","claim","class","classic","classroom","clean","clear","clearly","client","climate","climb","clinical","clock","close","closely","clothes","coach","coalition","coast","coffee","cognitive","collapse","colleague","collect","collection","college","colonial","color","column","combination","combine","comedy","comfort","comfortable","command","commander","comment","commercial","commission","commit","commitment","committee","common","communicate","communication","community","compare","comparison","compete","competition","competitive","complain","complaint","complete","completely","complex","complicated","component","comprehensive","computer","concentrate","concentration","concept","concern","concerned","concert","conclude","conclusion","concrete","condition","conduct","conference","confidence","confident","confirm","conflict","confront","confusion","congress","congressional","connect","connection","conscious","consciousness","consensus","consequence","conservative","consider","considerable","consideration","consist","consistent","constant","constantly","constitute","constitutional","construct","construction","consultant","consumer","consumption","contact","contain","container","contemporary","content","contest","context","continue","contract","contrast","contribute","contribution","control","controversial","controversy","convention","conventional","conversation","convert","conviction","convince","corporate","corporation","correct","correspondent","counter","county","couple","courage","course","court","cover","coverage","create","creation","creative","creature","credit","crime","criminal","crisis","criteria","critic","critical","criticism","criticize","cross","crowd","crucial","cultural","culture","curious","current","currently","curriculum","customer","cycle","damage","dance","danger","dangerous","database","daughter","dealer","debate","decade","decide","decision","declare","decline","decrease","deeply","defeat","defend","defendant","defense","defensive","deficit","define","definitely","definition","degree","deliver","delivery","demand","democracy","democrat","democratic","demonstrate","demonstration","deny","department","depend","dependent","depending","depict","depression","depth","deputy","derive","describe","description","desert","deserve","design","designer","desire","desperate","despite","destroy","destruction","detail","detailed","detect","determine","develop","developer","development","device","devote","dialogue","difference","different","differently","difficult","difficulty","digital","dimension","dinner","direct","direction","directly","director","dirty","disappear","disaster","discipline","discourse","discover","discovery","discrimination","discuss","discussion","disease","dismiss","disorder","display","dispute","distance","distant","distinct","distinction","distinguish","distribute","distribution","district","diverse","diversity","divide","division","divorce","doctor","document","dollar","domain","domestic","dominant","dominate","donate","double","doubt","downtown","dozen","draft","drama","dramatic","dramatically","drawing","dream","dress","drink","drive","driver","during","earthquake","easily","eastern","economic","economics","economy","editor","education","educational","educator","effect","effective","effectively","efficiency","efficient","effort","either","elaborate","elderly","election","electric","electricity","electronic","element","elementary","eliminate","elite","emerge","emergency","emission","emotion","emotional","emphasis","emphasize","empire","employ","employee","employer","employment","empty","enable","encounter","encourage","enforcement","engage","engagement","engine","engineer","engineering","enhance","enjoy","enormous","enough","ensure","enter","enterprise","entertainment","entire","entirely","entrance","entry","environment","environmental","episode","equal","equally","equipment","equity","equivalent","error","escape","especially","essay","essential","essentially","establish","establishment","estate","estimate","ethnic","evaluate","evaluation","evening","event","eventually","every","everybody","everyday","everyone","everything","everywhere","evidence","evolution","evolve","exact","exactly","examination","examine","example","exceed","excellent","except","exception","exchange","exciting","executive","exercise","exhibit","exhibition","exist","existence","existing","expand","expansion","expect","expectation","expense","expensive","experience","experiment","experimental","expert","explain","explanation","explicit","explore","explosion","export","expose","exposure","express","expression","extend","extension","extensive","extent","external","extra","extraordinary","extreme","extremely","fabric","facility","factor","factory","faculty","failure","fairly","faith","familiar","family","famous","fantasy","farmer","fashion","father","fault","favor","favorite","feature","federal","feedback","feeling","fellow","female","feminist","fiction","field","fifteen","fifth","fifty","fight","fighter","fighting","figure","final","finally","finance","financial","finding","finger","finish","fishing","fitness","flight","floor","focus","follow","following","football","force","foreign","forest","forever","forget","formal","formation","former","formula","forth","fortune","forward","foster","found","foundation","founder","fourth","frame","framework","freedom","frequently","fresh","friend","friendly","friendship","front","fruit","frustration","function","fundamental","funding","funeral","funny","furniture","furthermore","future","galaxy","gallery","garden","garlic","gather","gender","general","generally","generate","generation","genetic","gentleman","gently","genuine","ghost","giant","girlfriend","global","glory","golden","gonna","goods","gospel","government","governor","graduate","grain","grand","grandfather","grandmother","grant","grass","grave","great","greatest","green","grocery","ground","group","growing","growth","guarantee","guard","guess","guest","guidance","guide","guideline","guilty","guitar","habit","habitat","handle","happen","happy","harbor","hardly","hardware","harmony","headline","headquarters","health","healthy","hearing","heart","heaven","heavily","heavy","height","helicopter","hello","helpful","heritage","hidden","highlight","highly","highway","historian","historic","historical","history","holder","holiday","homeless","honest","honey","honor","horizon","horror","horse","hospital","hostage","hotel","household","housing","however","human","humor","hundred","hungry","hunter","hunting","husband","hypothesis","identity","ideology","ignore","illegal","illness","illustrate","image","imagination","imagine","immediate","immediately","immigrant","immigration","impact","implement","implementation","implication","imply","importance","important","impose","impossible","impress","impression","impressive","improve","improvement","incident","include","including","income","incorporate","increase","increased","increasing","increasingly","incredible","indeed","independence","independent","index","indian","indicate","indication","indicator","individual","industrial","industry","infant","infection","inflation","influence","inform","information","initial","initially","initiative","injury","inner","innocent","innovation","input","inquiry","inside","insight","insist","inspection","inspector","inspiration","install","instance","instead","institute","institution","institutional","instruction","instructor","instrument","insurance","intellectual","intelligence","intend","intense","intensity","intention","interaction","interest","interested","interesting","internal","international","internet","interpretation","intervention","interview","introduce","introduction","invasion","invest","investigate","investigation","investigator","investment","investor","invite","involve","involved","involvement","iraqi","island","isolation","issue","jacket","japanese","jersey","joint","joke","journal","journalist","journey","judge","judgment","juice","junior","jurisdiction","justice","justify","keeper","killing","kitchen","knee","knife","knock","knowledge","label","labor","laboratory","landscape","language","laptop","large","largely","laser","later","latest","latin","latter","laugh","launch","lawsuit","lawyer","layer","leader","leadership","leading","league","learn","learning","least","leather","leave","lecture","legal","legend","legislation","legislative","legislature","legitimate","length","lesson","letter","level","liberal","library","license","lifestyle","lifetime","light","likely","limit","limitation","limited","linear","lineup","little","living","lobby","local","locate","location","long","longer","loose","lord","lose","loss","lots","loud","love","lovely","lover","lower","luck","lunch","lung","machine","magazine","magic","mail","main","mainly","mainstream","maintain","maintenance","major","majority","maker","makeup","male","manager","manner","manufacturer","manufacturing","marble","margin","marine","mark","market","marketing","marriage","married","marry","mask","mass","massive","master","match","mate","material","matter","maybe","mayor","meaning","meaningful","means","meanwhile","measure","measurement","mechanism","media","medical","medication","medicine","medium","member","membership","memory","mental","mention","mentor","merchant","merely","merge","merit","mess","message","metal","meter","method","mexican","middle","might","migration","military","milk","million","mind","mine","mineral","minimum","minister","ministry","minor","minority","minute","miracle","mirror","missile","missing","mission","mistake","mixture","mobile","model","moderate","modern","modest","modify","molecular","moment","momentum","money","monitor","month","monthly","mood","moon","moral","moreover","morning","mortgage","mostly","mother","motion","motivation","motor","mount","mountain","mouse","mouth","move","movement","movie","multiple","murder","muscle","museum","music","musical","musician","muslim","mutual","myself","mystery","myth","naked","narrative","narrow","nation","national","native","natural","naturally","nature","near","nearby","nearly","necessarily","necessary","necessity","negative","negotiate","negotiation","neighbor","neighborhood","neither","nerve","nervous","network","never","nevertheless","newly","night","nightmare","nobody","noise","nomination","none","nonetheless","nonprofit","normal","normally","north","northern","nose","notable","note","nothing","notice","notion","novel","nowhere","nuclear","number","numerous","nurse","nursing","object","objective","obligation","observation","observe","observer","obtain","obvious","obviously","occasion","occupation","occupy","occur","ocean","offensive","offer","office","officer","official","often","okay","ongoing","online","open","opening","operate","operating","operation","operational","operator","opinion","opponent","opportunity","oppose","opposite","opposition","option","orange","orbit","ordinary","organic","organization","organize","orientation","origin","original","originally","other","others","otherwise","ought","ourselves","outcome","outdoor","outer","outlet","outline","output","outside","outstanding","overall","overcome","overlook","overnight","overseas","overwhelming","owner","ownership","oxygen","package","paint","painter","painting","pair","panel","paper","paragraph","parent","parking","parliament","partial","partially","participant","participate","participation","particular","particularly","partly","partner","partnership","party","passage","passenger","passion","patch","path","patient","pattern","peace","peaceful","peak","penalty","people","pepper","percentage","perception","perfect","perfectly","perform","performance","perhaps","period","permanent","permission","permit","person","personal","personality","personally","personnel","perspective","persuade","phase","phenomenon","philosophy","phone","photo","photograph","photographer","phrase","physical","physically","physician","piano","picture","piece","pilot","pine","pink","pioneer","pitch","place","plaintiff","plane","planet","planning","plant","plastic","plate","platform","player","please","pleasure","plenty","plot","pocket","poem","poet","poetry","point","pole","police","policy","political","politically","politician","politics","pollution","pool","poor","popular","popularity","population","porch","port","portion","portray","portrait","pose","position","positive","possess","possibility","possible","possibly","post","pot","potato","potential","potentially","poverty","powder","power","powerful","practical","practice","prayer","precisely","predict","prediction","prefer","preference","pregnancy","pregnant","preliminary","premier","premise","premium","preparation","prepare","prescription","presence","present","presentation","preserve","president","presidential","press","pressure","pretend","pretty","prevent","previous","previously","price","pride","priest","primarily","primary","prime","principal","principle","print","prior","priority","prison","prisoner","privacy","private","privilege","probably","probe","problem","procedure","proceed","process","processing","produce","producer","product","production","profession","professional","professor","profile","profit","profound","program","progress","project","prominent","promise","promote","promotion","prompt","proof","proper","properly","property","proportion","proposal","propose","proposed","proposition","prosecutor","prospect","protect","protection","protein","protest","proud","prove","provide","provider","province","provision","psychological","psychologist","psychology","public","publication","publicity","publicly","publish","publisher","pull","punishment","purchase","pure","purple","purpose","pursue","pursuit","push","qualify","quality","quarter","question","quick","quickly","quiet","quite","quote","race","racial","radical","radio","rage","raise","range","rank","rapid","rapidly","rare","rarely","rate","rather","rating","ratio","reach","react","reaction","reader","reading","ready","real","realistic","reality","realize","really","realm","reason","reasonable","recall","receive","recent","recently","recipe","recognition","recognize","recommend","recommendation","record","recording","recover","recovery","recruit","reduce","reduction","refer","reference","reflect","reflection","reform","refugee","refuse","regard","regarding","regardless","regime","region","regional","register","regular","regularly","regulate","regulation","reinforce","reject","relate","related","relation","relationship","relative","relatively","relax","release","relevant","relief","religion","religious","rely","remain","remaining","remarkable","remember","remind","remote","remove","repeat","replace","replacement","reply","report","reporter","represent","representation","representative","republic","republican","reputation","request","require","requirement","research","researcher","reserve","resident","residential","resist","resistance","resolution","resolve","resort","resource","respond","respondent","response","responsibility","responsible","rest","restaurant","restore","restriction","result","retain","retire","retirement","return","reveal","revenue","reverse","review","revolution","revolutionary","rhythm","rice","rich","ride","rifle","right","ring","rise","risk","river","road","robot","rock","role","roll","romantic","roof","room","root","rope","rose","rough","roughly","round","route","routine","royal","ruin","rule","running","rural","rush","russian","sacred","sacrifice","sadly","safe","safety","saint","sake","salad","salary","sale","sales","salt","sample","sanction","sand","satellite","satisfaction","satisfy","sauce","save","saving","scale","scandal","scared","scenario","scene","schedule","scheme","scholar","scholarship","school","science","scientific","scientist","scope","score","screen","script","search","season","seat","second","secondary","secret","secretary","section","sector","secure","security","seek","seem","segment","seize","select","selection","self","sell","senate","senator","send","senior","sense","sensitive","sentence","separate","sequence","series","serious","seriously","servant","serve","server","service","session","setting","settle","settlement","seven","several","severe","sexual","shade","shadow","shake","shall","shape","share","shareholder","sharp","sheet","shelf","shell","shelter","shift","shine","ship","shirt","shock","shoe","shoot","shooting","shop","shopping","shore","short","shortly","shot","should","shoulder","shout","show","shower","shut","sick","side","sight","sign","signal","significance","significant","significantly","silence","silent","silk","silly","silver","similar","similarly","simple","simply","since","sing","singer","single","sink","sister","site","situation","skill","skin","sleep","slice","slide","slight","slightly","slip","slow","slowly","small","smart","smell","smile","smoke","smooth","snap","snow","social","society","soft","software","soil","solar","soldier","solid","solution","solve","somebody","somehow","someone","something","sometimes","somewhat","somewhere","song","soon","sophisticated","sorry","sort","soul","sound","source","south","southern","soviet","space","speak","speaker","special","specialist","species","specific","specifically","spectrum","speech","speed","spend","spending","spin","spirit","spiritual","split","spokesman","sponsor","sport","spot","spread","spring","square","squeeze","stability","stable","staff","stage","stake","stand","standard","standing","star","stare","start","state","statement","station","statistical","statistics","status","stay","steady","steal","steel","step","stick","still","stock","stomach","stone","stop","storage","store","storm","story","straight","strange","stranger","strategic","strategy","stream","street","strength","strengthen","stress","stretch","strict","strike","string","strip","stroke","strong","strongly","structure","struggle","student","studio","study","stuff","stupid","style","subject","submit","subsequent","substance","substantial","succeed","success","successful","successfully","such","sudden","suddenly","suffer","sufficient","sugar","suggest","suggestion","suicide","suit","suitable","suite","summer","summit","super","supply","support","supporter","suppose","supposed","supreme","sure","surely","surface","surgery","surprise","surprised","surprising","surprisingly","surround","survey","survival","survive","survivor","suspect","suspend","sustain","sweep","sweet","swim","swing","switch","symbol","symptom","system","table","tablespoon","tactic","tail","take","tale","talent","talk","tall","tank","tape","target","task","taste","teach","teacher","teaching","team","teaspoon","technical","technique","technology","teenage","teenager","telephone","telescope","television","tell","temperature","temporary","tend","tendency","tender","tennis","tension","tent","term","terms","terrible","territory","terror","terrorism","terrorist","test","testify","testimony","testing","text","than","thank","that","theater","their","them","theme","themselves","then","theory","therapy","there","therefore","thick","thin","thing","think","thinking","third","thirty","this","thorough","those","though","thought","thousand","threat","threaten","three","throat","through","throughout","throw","thus","ticket","tight","time","tiny","tired","tissue","title","tobacco","today","together","tomato","tomorrow","tone","tongue","tonight","tool","tooth","topic","total","totally","touch","tough","tour","tourist","tournament","toward","towards","tower","town","trace","track","trade","tradition","traditional","traffic","tragedy","trail","train","trainer","training","trait","transfer","transform","transformation","transition","translate","translation","transmission","transmit","transport","transportation","travel","treat","treatment","treaty","tree","tremendous","trend","trial","tribe","trick","trip","troop","tropical","trouble","truck","true","truly","trust","truth","turn","twice","twin","type","typical","typically","ugly","ultimate","ultimately","unable","uncle","under","undergo","understand","understanding","unfortunately","uniform","union","unique","unit","united","unity","universal","universe","university","unknown","unless","unlike","unlikely","until","unusual","upper","urban","urge","used","useful","user","usual","usually","utility","vacation","valley","valuable","value","variable","variation","variety","various","vary","vast","vegetable","vehicle","venture","version","versus","very","vessel","veteran","victim","victory","video","view","viewer","village","violate","violation","violence","violent","virtually","virtue","virus","visible","vision","visit","visitor","visual","vital","voice","volume","volunteer","vote","voter","vulnerable","wage","wait","wake","walk","wall","wander","want","war","warm","warn","warning","wash","waste","watch","water","wave","way","weak","wealth","wealthy","weapon","wear","weather","wedding","week","weekend","weekly","weigh","weight","weird","welcome","welfare","well","west","western","wet","what","whatever","wheat","wheel","when","whenever","where","whereas","wherever","whether","which","while","whisper","white","whole","whom","whose","why","wide","widely","widespread","wife","wild","will","willing","wind","window","wine","wing","winner","winter","wire","wisdom","wise","wish","with","withdraw","within","without","witness","woman","wonder","wonderful","wood","wooden","word","work","worker","working","workout","workplace","workshop","world","worried","worry","worse","worst","worth","worthy","would","wound","wrap","write","writer","writing","wrong","yard","yeah","year","yellow","yesterday","yet","yield","young","youth","zone"];

                    const hardWords = ["algorithm","asynchronous","bureaucracy","catastrophic","conscientious","circumstantial","entrepreneurship","extraordinary","fluorescent","guarantee","hierarchical","idiosyncratic","juxtaposition","kaleidoscope","miscellaneous","nevertheless","onomatopoeia","pharmaceutical","quintessential","reconnaissance","serendipitous","simultaneously","sophisticated","surveillance","synonymous","technological","temperamental","ubiquitous","unequivocally","vulnerability","authentication","configuration","documentation","implementation","infrastructure","optimization","parallelization","synchronization","visualization","encapsulation","polymorphism","abstraction","inheritance","methodology","architecture","microservices","containerization","orchestration","deployment","acknowledgment","acquaintance","advantageous","advertisement","approximately","archaeological","autobiography","biodegradable","cardiovascular","characteristics","chronological","claustrophobic","commemorative","comprehensive","confidentiality","congratulations","conscientiously","constitutional","contamination","correspondence","counterproductive","crystallization","decentralization","decommissioning","decontamination","defragmentation","demilitarization","democratization","denominations","departmentalization","dermatologist","desensitization","deterioration","deterministic","developmental","differentiation","disadvantageous","disambiguation","discontinuation","discriminatory","disenfranchised","disillusionment","disproportionate","distinguishable","diversification","documentation","domestication","ecclesiastical","electromagnetic","embarrassingly","encouragement","endocrinologist","enthusiastically","entrepreneurial","environmental","epidemiologist","epistemological","establishment","ethereal","euphemistically","excommunication","excruciatingly","exemplification","experimentation","extraordinarily","familiarization","fundamentalist","gastroenterology","generalization","geographically","gerrymandering","globalization","gubernatorial","hallucination","hemoglobin","heterogeneous","hierarchically","historiography","homogenization","hospitalization","humanitarianism","hypersensitivity","hypothetically","identification","ideologically","idiosyncrasies","immaterialized","immunodeficiency","impersonation","implementation","inaccessibility","inappropriately","incommensurable","incompatibility","incomprehensible","inconsiderable","inconsequential","incontrovertible","incorrigibility","indecipherable","indefatigable","indemnification","indeterminacy","indiscriminate","individualistic","industrialization","ineffectiveness","inexplicability","inflammability","informativeness","infrastructural","inquisitiveness","inseparability","insignificance","institutionalized","instrumentation","insubordination","insurmountable","intellectualism","intelligibility","interchangeable","intercontinental","interdependence","intergovernmental","intermediaries","internationalism","interpenetration","interpretation","interrelationship","interventionism","introspectively","irreconcilable","irreproachable","irresponsibility","jurisdictional","jurisprudential","justifiability","knowledgeable","legitimization","lexicographical","liberalization","macroeconomics","maldistribution","malfunctioning","maneuverability","marginalization","materialization","mathematician","meaningfulness","mechanization","melodramatically","metamorphosis","meteorological","methodological","microbiologist","microeconomics","microprocessor","misapprehension","misappropriation","miscalculation","miscommunication","misinterpretation","misrepresentation","multiculturalism","multidimensional","multidisciplinary","multinational","nanotechnology","nationalization","neurobiological","neuropsychology","neuroscientist","noncommunicable","nongovernmental","nonproliferation","nutritionist","objectification","obligatoriness","obsequiousness","observationally","obstructionist","oceanographer","ombudsperson","operationalize","ophthalmologist","opportunistically","organizational","osteoporosis","otherworldliness","outmaneuvering","overgeneralization","overrepresentation","overwhelmingly","paleontologist","paradoxically","parliamentarian","particularistic","pathophysiology","perfectionism","permissibility","personalization","perspicaciously","persuasiveness","pessimistically","petrochemical","pharmaceutical","phenomenological","philanthropist","philosophically","photosynthesis","physiologically","plagiarism","plenipotentiary","pluralistic","pneumatically","polarization","politicization","polysyllabic","posthumously","postmodernism","practicability","pragmatically","precariousness","precipitously","preconditioned","predestination","predominantly","preferentially","prejudicially","preoccupation","preponderance","prepositional","prerequisite","presumptuously","pretentiousness","prioritization","privatization","probabilistic","problematically","procrastination","professionalism","profitability","prognostication","progressiveness","prohibitionist","proliferation","proportionally","proprietorship","prospectively","protectionism","provisionally","psychoanalysis","psychologically","psychotherapist","quadrilateral","qualifications","quantification","quarantine","questionnaire","quintessentially","radioactivity","rationalization","reaccreditation","rearrangement","reasonableness","recapitalization","receptiveness","reciprocation","reclassification","recommendation","reconciliation","reconnaissance","reconstruction","reconsideration","recoverability","redistribution","reforestation","refrigeration","rehabilitation","reimbursement","reincarnation","reinforcement","reinterpretation","rejuvenation","relatedness","religiousness","reminiscence","remonstration","remuneration","reorganization","representation","representative","reproducibility","republicanism","resourcefulness","respectability","responsibility","restrictiveness","resuscitation","retrospectively","revitalization","revolutionary","romanticization","rudimentary","sacramentally","sanctimoniously","satisfactorily","schematically","scholastically","scientifically","secularization","sedimentary","seismological","semiconductor","sentimentality","simultaneously","socioeconomic","sophistication","specialization","specifications","spectacularly","speechlessness","spokesperson","sportsmanship","standardization","statistically","stereotypically","stigmatization","straightforward","stratification","subconsciously","subordination","substantiation","substitutability","suburbanization","suggestiveness","supercomputer","superficiality","superintendent","supplementary","sustainability","syllabification","symbolically","sympathetically","symptomatically","synchronization","systematically","telecommunications","temperamentally","terminological","territoriality","thankfulness","theoretically","therapeutically","thoughtfulness","thunderstorm","traditionalism","transcendental","transferability","transformation","transgenerational","transliteration","transportation","tremendously","triangulation","trustworthiness","ultraviolet","unacceptability","unaccountability","unapproachable","uncharacteristic","uncomfortable","unconditionally","unconscionably","unconstitutional","uncontrollability","unconventionally","underemployment","underestimation","undergraduate","underrepresented","understanding","understatement","underutilization","undifferentiated","unenforceable","unexpectedness","unforgettable","unfortunately","unintelligible","universality","unnecessarily","unprecedented","unpredictability","unpretentious","unquestionably","unreasonableness","unrecognizable","unsatisfactory","unsophisticated","unsubstantiated","unsuccessfully","unsustainability","utilitarianism","vascularization","ventriloquism","verifiability","vernacularism","victimization","videoconferencing","visualization","vivisectionist","voluntariness","weatherization","whistleblower","wholesomeness","workmanship","worthlessness","xenophobically","zoologically"];

                    // Specialized dictionaries
                    const programmingWords = ["function","variable","constant","array","object","string","integer","boolean","null","undefined","class","method","property","constructor","prototype","inheritance","polymorphism","encapsulation","abstraction","interface","module","import","export","async","await","promise","callback","closure","scope","hoisting","recursion","iteration","loop","conditional","operator","expression","statement","declaration","assignment","comparison","logical","bitwise","ternary","spread","destructuring","template","literal","arrow","generator","iterator","symbol","proxy","reflect","map","set","weakmap","weakset","buffer","stream","event","listener","emit","subscribe","observer","middleware","router","controller","model","view","component","directive","service","dependency","injection","singleton","factory","decorator","mixin","trait","generic","type","enum","union","intersection","tuple","interface","namespace","module","package","library","framework","runtime","compiler","interpreter","transpiler","bundler","minifier","linter","formatter","debugger","profiler","testing","unit","integration","end-to-end","mock","stub","spy","fixture","assertion","coverage","continuous","deployment","version","control","repository","branch","merge","rebase","commit","push","pull","fetch","clone","fork","issue","request","review","release","tag","semantic","changelog","readme","license","contributing","dockerfile","container","image","volume","network","compose","kubernetes","pod","service","deployment","configmap","secret","ingress","helm","terraform","ansible","jenkins","pipeline","artifact","registry","monitoring","logging","tracing","metrics","alerting","dashboard","grafana","prometheus","elasticsearch","kibana","redis","memcached","rabbitmq","kafka","nginx","apache","loadbalancer","reverse","proxy","ssl","tls","certificate","encryption","authentication","authorization","oauth","jwt","token","session","cookie","cors","csrf","xss","injection","sanitization","validation","hashing","salting","bcrypt","argon","algorithm","complexity","optimization","caching","indexing","query","database","schema","migration","seed","transaction","isolation","consistency","availability","partition","replication","sharding","backup","restore","failover","recovery"];

                    const medicalWords = ["diagnosis","prognosis","symptom","syndrome","pathology","etiology","epidemiology","pharmacology","therapeutics","anesthesia","cardiology","neurology","oncology","pediatrics","geriatrics","psychiatry","dermatology","ophthalmology","otolaryngology","gastroenterology","endocrinology","nephrology","pulmonology","rheumatology","hematology","immunology","infectious","radiology","ultrasound","tomography","resonance","biopsy","autopsy","histology","cytology","microbiology","virology","bacteriology","parasitology","toxicology","anatomy","physiology","biochemistry","genetics","genomics","proteomics","metabolism","homeostasis","inflammation","infection","immunity","antibody","antigen","vaccine","antibiotic","antiviral","antifungal","chemotherapy","radiation","surgery","transplant","prosthesis","rehabilitation","physical","occupational","speech","therapy","nursing","pharmacy","prescription","dosage","contraindication","interaction","adverse","effect","allergy","hypersensitivity","anaphylaxis","edema","hemorrhage","thrombosis","embolism","ischemia","infarction","necrosis","fibrosis","cirrhosis","stenosis","hypertension","hypotension","tachycardia","bradycardia","arrhythmia","murmur","angina","myocardial","cardiac","coronary","vascular","arterial","venous","capillary","lymphatic","respiratory","ventilation","oxygenation","perfusion","diffusion","compliance","resistance","obstruction","restriction","pneumonia","bronchitis","asthma","emphysema","fibrosis","tuberculosis","influenza","coronavirus","hepatitis","cirrhosis","pancreatitis","appendicitis","colitis","gastritis","ulcer","reflux","hernia","obstruction","perforation","abscess","fistula","hemorrhoid","polyp","adenoma","carcinoma","sarcoma","lymphoma","leukemia","melanoma","metastasis","staging","grading","remission","relapse","palliative","hospice","terminal","chronic","acute","subacute","congenital","hereditary","acquired","idiopathic","iatrogenic","nosocomial","comorbidity","mortality","morbidity","incidence","prevalence","screening","prevention","prophylaxis","immunization","quarantine","isolation","sterilization","disinfection","antiseptic","aseptic","sterile","contamination","cross-infection"];

                    const legalWords = ["jurisdiction","litigation","arbitration","mediation","adjudication","prosecution","defense","plaintiff","defendant","appellant","appellee","petitioner","respondent","claimant","litigant","counsel","attorney","solicitor","barrister","advocate","paralegal","notary","magistrate","judge","justice","tribunal","court","bench","chamber","hearing","trial","verdict","judgment","sentence","appeal","review","certiorari","mandamus","injunction","restraining","subpoena","summons","complaint","petition","motion","brief","memorandum","affidavit","deposition","interrogatory","discovery","evidence","testimony","witness","expert","hearsay","admissible","relevant","material","probative","prejudicial","circumstantial","direct","documentary","demonstrative","stipulation","objection","sustained","overruled","sidebar","recess","continuance","mistrial","dismissal","acquittal","conviction","sentence","probation","parole","incarceration","restitution","damages","compensatory","punitive","nominal","liquidated","specific","performance","rescission","reformation","injunctive","declaratory","relief","remedy","statute","regulation","ordinance","precedent","doctrine","principle","rule","standard","test","burden","proof","preponderance","reasonable","doubt","prima","facie","res","judicata","stare","decisis","habeas","corpus","due","process","equal","protection","probable","cause","warrant","search","seizure","arrest","detention","bail","arraignment","indictment","plea","guilty","innocent","nolo","contendere","bargain","negotiate","settlement","agreement","contract","breach","tort","negligence","malpractice","defamation","libel","slander","fraud","misrepresentation","conversion","trespass","nuisance","strict","liability","vicarious","contributory","comparative","assumption","risk","waiver","release","indemnity","insurance","subrogation","bankruptcy","insolvency","creditor","debtor","secured","unsecured","priority","discharge","reorganization","liquidation","trustee","receiver","fiduciary","executor","administrator","guardian","conservator","power","attorney","will","testament","trust","estate","probate","intestate","heir","beneficiary","bequest","devise","legacy","inheritance","succession","adoption","custody","support","alimony","divorce","annulment","prenuptial","postnuptial","community","property","equitable","distribution"];

                    const scientificWords = ["hypothesis","theory","experiment","observation","measurement","variable","control","dependent","independent","correlation","causation","regression","analysis","synthesis","methodology","protocol","procedure","apparatus","instrument","calibration","accuracy","precision","error","uncertainty","significance","probability","distribution","deviation","variance","mean","median","mode","range","outlier","sample","population","random","systematic","bias","validity","reliability","replication","peer","review","publication","citation","abstract","introduction","methods","results","discussion","conclusion","acknowledgment","reference","appendix","supplementary","figure","table","graph","chart","diagram","schematic","illustration","photograph","micrograph","spectrum","chromatogram","electropherogram","sequence","alignment","phylogeny","taxonomy","nomenclature","classification","kingdom","phylum","class","order","family","genus","species","subspecies","strain","isolate","specimen","sample","extract","purify","concentrate","dilute","dissolve","precipitate","centrifuge","filter","distill","evaporate","crystallize","lyophilize","homogenize","sonicate","vortex","incubate","culture","inoculate","transfect","transform","clone","express","purify","characterize","quantify","identify","detect","amplify","sequence","annotate","predict","model","simulate","optimize","validate","standardize","normalize","calibrate","interpolate","extrapolate","integrate","differentiate","correlate","regress","cluster","classify","discriminate","predict","forecast","estimate","calculate","compute","derive","deduce","infer","conclude","hypothesize","postulate","theorize","speculate","propose","suggest","demonstrate","prove","disprove","refute","confirm","verify","validate","corroborate","contradict","challenge","question","investigate","explore","examine","analyze","interpret","evaluate","assess","compare","contrast","distinguish","differentiate","categorize","organize","summarize","synthesize","integrate","apply","implement","develop","design","create","innovate","discover","invent","patent","license","commercialize","translate","disseminate","communicate","educate","train","mentor","collaborate","cooperate","coordinate","facilitate","moderate","mediate","arbitrate","negotiate","advocate","promote","support","fund","grant","award","recognize","honor","celebrate","commemorate"];

                    // Language dictionaries
                    const spanishWords = ["hola","gracias","por","favor","bueno","malo","grande","casa","tiempo","agua","comida","trabajo","familia","amigo","ciudad","pais","mundo","vida","amor","feliz","triste","nuevo","viejo","primero","ultimo","siempre","nunca","ahora","despues","antes","dentro","fuera","arriba","abajo","cerca","lejos","mucho","poco","todo","nada","algo","alguien","nadie","donde","cuando","como","porque","aunque","mientras","desde","hasta","entre","sobre","bajo","junto","contra","hacia","para","sin","con","pero","sino","tambien","ademas","todavia","incluso","apenas","quizas","acaso","ojala","buenas","noches","dias","tardes","manana","semana","mes","ano","hoy","ayer","lunes","martes","miercoles","jueves","viernes","sabado","domingo","enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre","rojo","azul","verde","amarillo","blanco","negro","gris","rosa","naranja","morado","claro","oscuro","bonito","feo","alto","bajo","gordo","flaco","joven","viejo","rapido","lento","facil","dificil","barato","caro","libre","ocupado","abierto","cerrado","lleno","vacio","limpio","sucio","caliente","frio","dulce","salado","amargo","picante","suave","duro","blando","fuerte","debil","sano","enfermo","cansado","despierto","dormido","hambriento","sediento","contento","enojado","asustado","preocupado","sorprendido","confundido","aburrido","interesado","emocionado","tranquilo","nervioso","seguro","peligroso","importante","necesario","posible","imposible","probable","cierto","falso","verdadero","correcto","incorrecto","igual","diferente","similar","mismo","otro","proximo","anterior","siguiente","final","inicial","central","principal","secundario","especial","general","particular","comun","raro","normal","extraano","conocido","desconocido","publico","privado","personal","social","cultural","natural","artificial","moderno","antiguo","actual","futuro","pasado","presente"];

                    const frenchWords = ["bonjour","merci","beaucoup","comment","allez","vous","bien","maison","temps","eau","nourriture","travail","famille","ami","ville","pays","monde","vie","amour","heureux","triste","nouveau","vieux","premier","dernier","toujours","jamais","maintenant","apres","avant","dedans","dehors","dessus","dessous","pres","loin","beaucoup","peu","tout","rien","quelque","chose","quelqu","personne","ou","quand","comment","pourquoi","bien","que","pendant","depuis","jusqu","entre","sur","sous","avec","sans","pour","contre","vers","chez","dans","hors","sauf","selon","malgre","aussi","encore","deja","peut","etre","bonsoir","bonne","nuit","jour","matin","soir","semaine","mois","annee","aujourd","hui","hier","demain","lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche","janvier","fevrier","mars","avril","mai","juin","juillet","aout","septembre","octobre","novembre","decembre","rouge","bleu","vert","jaune","blanc","noir","gris","rose","orange","violet","clair","fonce","beau","laid","grand","petit","gros","mince","jeune","age","rapide","lent","facile","difficile","bon","marche","cher","libre","occupe","ouvert","ferme","plein","vide","propre","sale","chaud","froid","doux","amer","epice","sucre","moelleux","dur","fort","faible","sain","malade","fatigue","eveille","endormi","affame","assoiffe","content","fache","effraye","inquiet","surpris","confus","ennuye","interesse","excite","calme","nerveux","sur","dangereux","important","necessaire","possible","impossible","probable","certain","faux","vrai","correct","incorrect","egal","different","similaire","meme","autre","prochain","precedent","suivant","final","initial","central","principal","secondaire","special","general","particulier","commun","rare","normal","etrange","connu","inconnu","public","prive","personnel","social","culturel","naturel","artificiel","moderne","ancien","actuel","futur","passe","present"];

                    const germanWords = ["hallo","danke","bitte","gut","schlecht","gross","klein","haus","zeit","wasser","essen","arbeit","familie","freund","stadt","land","welt","leben","liebe","gluecklich","traurig","neu","alt","erste","letzte","immer","nie","jetzt","nachher","vorher","drinnen","draussen","oben","unten","nahe","weit","viel","wenig","alles","nichts","etwas","jemand","niemand","wo","wann","wie","warum","obwohl","waehrend","seit","bis","zwischen","ueber","unter","neben","gegen","nach","fuer","ohne","mit","aber","sondern","auch","ausserdem","noch","sogar","kaum","vielleicht","guten","morgen","abend","nacht","tag","woche","monat","jahr","heute","gestern","montag","dienstag","mittwoch","donnerstag","freitag","samstag","sonntag","januar","februar","maerz","april","mai","juni","juli","august","september","oktober","november","dezember","rot","blau","gruen","gelb","weiss","schwarz","grau","rosa","orange","lila","hell","dunkel","schoen","haesslich","hoch","niedrig","dick","duenn","jung","schnell","langsam","leicht","schwer","billig","teuer","frei","besetzt","offen","geschlossen","voll","leer","sauber","schmutzig","heiss","kalt","suess","salzig","bitter","scharf","weich","hart","stark","schwach","gesund","krank","muede","wach","schlafend","hungrig","durstig","zufrieden","wuetend","aengstlich","besorgt","ueberrascht","verwirrt","gelangweilt","interessiert","aufgeregt","ruhig","nervoes","sicher","gefaehrlich","wichtig","notwendig","moeglich","unmoeglich","wahrscheinlich","gewiss","falsch","wahr","richtig","gleich","verschieden","aehnlich","selbe","andere","naechste","vorherige","folgende","endgueltig","anfaenglich","zentral","haupt","sekundaer","besondere","allgemein","bestimmt","gemeinsam","selten","normal","seltsam","bekannt","unbekannt","oeffentlich","privat","persoenlich","sozial","kulturell","natuerlich","kuenstlich","modern","antik","aktuell","zukuenftig","vergangen","gegenwaertig"];

                    const quotes = [
                        "The only way to do great work is to love what you do.",
                        "Innovation distinguishes between a leader and a follower.",
                        "Stay hungry, stay foolish.",
                        "The future belongs to those who believe in the beauty of their dreams.",
                        "It does not matter how slowly you go as long as you do not stop.",
                        "Success is not final, failure is not fatal: it is the courage to continue that counts.",
                        "The only thing we have to fear is fear itself.",
                        "In the middle of difficulty lies opportunity.",
                        "Life is what happens when you are busy making other plans.",
                        "The best time to plant a tree was twenty years ago. The second best time is now.",
                        "Be yourself; everyone else is already taken.",
                        "Two things are infinite: the universe and human stupidity.",
                        "You only live once, but if you do it right, once is enough.",
                        "Be the change that you wish to see in the world.",
                        "In three words I can sum up everything I have learned about life: it goes on.",
                        "If you tell the truth, you do not have to remember anything.",
                        "A friend is someone who knows all about you and still loves you.",
                        "To live is the rarest thing in the world. Most people exist, that is all.",
                        "Always forgive your enemies; nothing annoys them so much.",
                        "Live as if you were to die tomorrow. Learn as if you were to live forever."
                    ];

                    const codeSnippets = [
                        "function add(a, b) { return a + b; }",
                        "const arr = [1, 2, 3].map(x => x * 2);",
                        "if (condition) { doSomething(); }",
                        "for (let i = 0; i < 10; i++) { }",
                        "const obj = { key: 'value', num: 42 };",
                        "async function fetch() { await api(); }",
                        "const [first, ...rest] = array;",
                        "class User { constructor(name) { } }",
                        "export default function App() { }",
                        "import { useState } from 'react';",
                        "const handleClick = (e) => e.preventDefault();",
                        "try { riskyOperation(); } catch (err) { }",
                        "const result = items.filter(x => x > 5);",
                        "const sum = arr.reduce((a, b) => a + b, 0);",
                        "Object.keys(obj).forEach(key => { });",
                        "const { name, age } = person;",
                        "return condition ? valueA : valueB;",
                        "const promise = new Promise((resolve) => { });",
                        "setTimeout(() => console.log('done'), 1000);",
                        "const regex = /^[a-z]+$/i.test(str);"
                    ];

                    const punctuation = [".", ",", "!", "?", ";", ":", "'", '"'];
                    const numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

                    // Current language/topic setting
                    let currentLanguage = 'english';
                    let currentTopic = 'general';

                    // Settings state
                    let currentMode = 'time'; // time, words, quote, code
                    let currentDifficulty = 'easy';
                    let timeLimit = 60;
                    let wordLimit = 25;
                    let usePunctuation = false;
                    let useNumbers = false;
                    let useCaps = false;

                    // Test state
                    let timeLeft = 60;
                    let timer = null;
                    let isRunning = false;
                    let currentWordIndex = 0;
                    let correctKeystrokes = 0;
                    let totalKeystrokes = 0;
                    let wrongKeystrokes = 0;
                    let generatedWords = [];
                    let wpmHistory = [];
                    let keyStats = {}; // Track correct/error per key

                    // DOM Elements
                    const currentWordDisplay = document.getElementById('currentWordDisplay');
                    const upcomingWords = document.getElementById('upcomingWords');
                    const spaceHint = document.getElementById('spaceHint');
                    const input = document.getElementById('hiddenInput');
                    const timerDisplay = document.getElementById('timer');
                    const wpmDisplay = document.getElementById('wpm');
                    const accuracyDisplay = document.getElementById('accuracy');
                    const resultModal = document.getElementById('resultModal');
                    const typingArea = document.getElementById('typingArea');
                    const soundToggle = document.getElementById('soundToggle');
                    const progressBar = document.getElementById('progressBar');

                    // Chart setup
                    let wpmChart = null;
                    const ctx = document.getElementById('wpmChart').getContext('2d');

                    function initChart() {
                        if (wpmChart) wpmChart.destroy();
                        wpmChart = new Chart(ctx, {
                            type: 'line',
                            data: {
                                labels: [],
                                datasets: [{
                                    label: 'WPM',
                                    data: [],
                                    borderColor: '#3b82f6',
                                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                                    fill: true,
                                    tension: 0.3,
                                    pointRadius: 2
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { display: false } },
                                scales: {
                                    x: { display: false },
                                    y: { beginAtZero: true, grid: { color: '#e2e8f0' } }
                                },
                                animation: { duration: 0 }
                            }
                        });
                    }

                    function updateChart(wpm) {
                        const elapsed = timeLimit - timeLeft;
                        wpmChart.data.labels.push(elapsed + 's');
                        wpmChart.data.datasets[0].data.push(wpm);
                        wpmChart.update('none');
                    }

                    // Keyboard heatmap
                    function updateKeyboard(key, isCorrect) {
                        key = key.toLowerCase();
                        if (!keyStats[key]) keyStats[key] = { correct: 0, error: 0 };
                        if (isCorrect) {
                            keyStats[key].correct++;
                        } else {
                            keyStats[key].error++;
                        }
                        renderKeyboard();
                    }

                    function renderKeyboard() {
                        document.querySelectorAll('.key').forEach(keyEl => {
                            const key = keyEl.dataset.key;
                            const stats = keyStats[key];
                            keyEl.classList.remove('correct', 'error', 'hot');
                            if (stats) {
                                const total = stats.correct + stats.error;
                                if (total > 0) {
                                    const errorRate = stats.error / total;
                                    if (errorRate > 0.3) {
                                        keyEl.classList.add('hot');
                                    } else if (errorRate > 0.1) {
                                        keyEl.classList.add('error');
                                    } else {
                                        keyEl.classList.add('correct');
                                    }
                                }
                            }
                        });
                    }

                    function resetKeyboard() {
                        keyStats = {};
                        document.querySelectorAll('.key').forEach(k => k.classList.remove('correct', 'error', 'hot'));
                    }

                    // History management (localStorage)
                    function loadHistory() {
                        const saved = localStorage.getItem('typingTestHistory');
                        return saved ? JSON.parse(saved) : [];
                    }

                    function saveToHistory(wpm, accuracy, mode, difficulty) {
                        const history = loadHistory();
                        history.unshift({
                            wpm, accuracy, mode, difficulty,
                            date: new Date().toISOString()
                        });
                        // Keep last 50 results
                        if (history.length > 50) history.pop();
                        localStorage.setItem('typingTestHistory', JSON.stringify(history));
                        renderHistory();
                    }

                    function clearHistory() {
                        localStorage.removeItem('typingTestHistory');
                        renderHistory();
                    }

                    function renderHistory() {
                        const history = loadHistory();
                        const listEl = document.getElementById('historyList');
                        const bestWpmEl = document.getElementById('historyBestWpm');
                        const avgWpmEl = document.getElementById('historyAvgWpm');
                        const avgAccEl = document.getElementById('historyAvgAcc');
                        const testsEl = document.getElementById('historyTests');

                        if (history.length === 0) {
                            listEl.innerHTML = '<div class="text-muted text-center py-3" style="font-size:0.85rem;">No tests yet.</div>';
                            bestWpmEl.textContent = '-';
                            avgWpmEl.textContent = '-';
                            avgAccEl.textContent = '-';
                            testsEl.textContent = '0';
                            return;
                        }

                        // Calculate stats
                        const wpms = history.map(h => h.wpm);
                        const accs = history.map(h => h.accuracy);
                        bestWpmEl.textContent = Math.max(...wpms);
                        avgWpmEl.textContent = Math.round(wpms.reduce((a,b) => a+b, 0) / wpms.length);
                        avgAccEl.textContent = Math.round(accs.reduce((a,b) => a+b, 0) / accs.length) + '%';
                        testsEl.textContent = history.length;

                        // Render list (last 10)
                        listEl.innerHTML = history.slice(0, 10).map(h => {
                            const date = new Date(h.date);
                            const dateStr = date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                            return '<div class="history-item"><span class="wpm">' + h.wpm + ' WPM</span><span class="accuracy">' + h.accuracy + '%</span><span class="date">' + dateStr + '</span></div>';
                        }).join('');
                    }

                    // Settings event handlers
                    document.getElementById('modeSelector').addEventListener('click', e => {
                        if (e.target.classList.contains('pill-btn')) {
                            document.querySelectorAll('#modeSelector .pill-btn').forEach(b => b.classList.remove('active'));
                            e.target.classList.add('active');
                            currentMode = e.target.dataset.mode;

                            // Show/hide time or words selector
                            document.getElementById('timeSetting').style.display = currentMode === 'time' ? 'flex' : 'none';
                            document.getElementById('wordsSetting').style.display = currentMode === 'words' ? 'flex' : 'none';

                            resetTest();
                        }
                    });

                    document.getElementById('timeSelector').addEventListener('click', e => {
                        if (e.target.classList.contains('pill-btn')) {
                            document.querySelectorAll('#timeSelector .pill-btn').forEach(b => b.classList.remove('active'));
                            e.target.classList.add('active');
                            timeLimit = parseInt(e.target.dataset.time);
                            resetTest();
                        }
                    });

                    document.getElementById('wordsSelector').addEventListener('click', e => {
                        if (e.target.classList.contains('pill-btn')) {
                            document.querySelectorAll('#wordsSelector .pill-btn').forEach(b => b.classList.remove('active'));
                            e.target.classList.add('active');
                            wordLimit = parseInt(e.target.dataset.words);
                            resetTest();
                        }
                    });

                    document.getElementById('difficultySelector').addEventListener('click', e => {
                        if (e.target.classList.contains('pill-btn')) {
                            document.querySelectorAll('#difficultySelector .pill-btn').forEach(b => b.classList.remove('active'));
                            e.target.classList.add('active');
                            currentDifficulty = e.target.dataset.diff;
                            resetTest();
                        }
                    });

                    document.getElementById('punctuationToggle').addEventListener('change', e => { usePunctuation = e.target.checked; resetTest(); });
                    document.getElementById('numbersToggle').addEventListener('change', e => { useNumbers = e.target.checked; resetTest(); });
                    document.getElementById('capsToggle').addEventListener('change', e => { useCaps = e.target.checked; resetTest(); });

                    // Language selector
                    document.getElementById('languageSelector').addEventListener('click', e => {
                        if (e.target.classList.contains('pill-btn')) {
                            document.querySelectorAll('#languageSelector .pill-btn').forEach(b => b.classList.remove('active'));
                            e.target.classList.add('active');
                            currentLanguage = e.target.dataset.lang;
                            resetTest();
                        }
                    });

                    // Topic selector
                    document.getElementById('topicSelector').addEventListener('click', e => {
                        if (e.target.classList.contains('pill-btn')) {
                            document.querySelectorAll('#topicSelector .pill-btn').forEach(b => b.classList.remove('active'));
                            e.target.classList.add('active');
                            currentTopic = e.target.dataset.topic;
                            resetTest();
                        }
                    });

                    // Keyboard layout selector
                    document.getElementById('layoutSelector').addEventListener('click', e => {
                        if (e.target.classList.contains('pill-btn')) {
                            document.querySelectorAll('#layoutSelector .pill-btn').forEach(b => b.classList.remove('active'));
                            e.target.classList.add('active');
                            currentLayout = e.target.dataset.layout;
                            renderKeyboardLayout();
                        }
                    });

                    // Render keyboard based on selected layout
                    function renderKeyboardLayout() {
                        const layout = keyboardLayouts[currentLayout];
                        const keyboard = document.getElementById('keyboard');
                        keyboard.innerHTML = '';

                        layout.rows.forEach(row => {
                            const rowDiv = document.createElement('div');
                            rowDiv.className = 'keyboard-row';
                            row.forEach(key => {
                                const keyDiv = document.createElement('div');
                                keyDiv.className = 'key';
                                keyDiv.dataset.key = key;
                                keyDiv.textContent = key;
                                rowDiv.appendChild(keyDiv);
                            });
                            keyboard.appendChild(rowDiv);
                        });

                        // Add space bar
                        const spaceRow = document.createElement('div');
                        spaceRow.className = 'keyboard-row';
                        const spaceKey = document.createElement('div');
                        spaceKey.className = 'key space';
                        spaceKey.dataset.key = ' ';
                        spaceKey.textContent = 'space';
                        spaceRow.appendChild(spaceKey);
                        keyboard.appendChild(spaceRow);

                        // Re-apply key stats colors
                        renderKeyboard();
                    }

                    // Get word list based on settings
                    function getWordList() {
                        if (currentMode === 'quote') return null; // Special handling
                        if (currentMode === 'code') return null; // Special handling

                        // If topic is specialized, return that dictionary
                        if (currentTopic !== 'general') {
                            switch (currentTopic) {
                                case 'programming': return programmingWords;
                                case 'medical': return medicalWords;
                                case 'legal': return legalWords;
                                case 'scientific': return scientificWords;
                            }
                        }

                        // If language is not English, return that language's dictionary
                        if (currentLanguage !== 'english') {
                            switch (currentLanguage) {
                                case 'spanish': return spanishWords;
                                case 'french': return frenchWords;
                                case 'german': return germanWords;
                            }
                        }

                        // Default: English by difficulty
                        switch (currentDifficulty) {
                            case 'hard': return hardWords;
                            case 'medium': return mediumWords;
                            default: return easyWords;
                        }
                    }

                    function transformWord(word) {
                        let result = word;
                        if (useCaps && Math.random() < 0.2) {
                            result = result.charAt(0).toUpperCase() + result.slice(1);
                        }
                        if (usePunctuation && Math.random() < 0.15) {
                            result += punctuation[Math.floor(Math.random() * punctuation.length)];
                        }
                        if (useNumbers && Math.random() < 0.1) {
                            result += numbers[Math.floor(Math.random() * numbers.length)];
                        }
                        return result;
                    }

                    // Audio Context for typing sounds
                    let audioContext = null;

                    function initAudio() {
                        if (!audioContext) {
                            audioContext = new (window.AudioContext || window.webkitAudioContext)();
                        }
                    }

                    function playKeySound(isCorrect = true) {
                        if (!soundToggle.checked) return;
                        initAudio();

                        const oscillator = audioContext.createOscillator();
                        const gainNode = audioContext.createGain();

                        oscillator.connect(gainNode);
                        gainNode.connect(audioContext.destination);

                        // Different sounds for correct vs error
                        if (isCorrect) {
                            oscillator.frequency.value = 800 + Math.random() * 200; // Higher pitch click
                            oscillator.type = 'sine';
                        } else {
                            oscillator.frequency.value = 200; // Lower pitch for error
                            oscillator.type = 'square';
                        }

                        gainNode.gain.setValueAtTime(0.1, audioContext.currentTime);
                        gainNode.gain.exponentialRampToValueAtTime(0.001, audioContext.currentTime + 0.05);

                        oscillator.start(audioContext.currentTime);
                        oscillator.stop(audioContext.currentTime + 0.05);
                    }

                    function playSpaceSound() {
                        if (!soundToggle.checked) return;
                        initAudio();

                        const oscillator = audioContext.createOscillator();
                        const gainNode = audioContext.createGain();

                        oscillator.connect(gainNode);
                        gainNode.connect(audioContext.destination);

                        oscillator.frequency.value = 600;
                        oscillator.type = 'sine';

                        gainNode.gain.setValueAtTime(0.08, audioContext.currentTime);
                        gainNode.gain.exponentialRampToValueAtTime(0.001, audioContext.currentTime + 0.08);

                        oscillator.start(audioContext.currentTime);
                        oscillator.stop(audioContext.currentTime + 0.08);
                    }

                    function playErrorSound() {
                        if (!soundToggle.checked) return;
                        initAudio();

                        const oscillator = audioContext.createOscillator();
                        const gainNode = audioContext.createGain();

                        oscillator.connect(gainNode);
                        gainNode.connect(audioContext.destination);

                        oscillator.frequency.value = 150;
                        oscillator.type = 'sawtooth';

                        gainNode.gain.setValueAtTime(0.15, audioContext.currentTime);
                        gainNode.gain.exponentialRampToValueAtTime(0.001, audioContext.currentTime + 0.15);

                        oscillator.start(audioContext.currentTime);
                        oscillator.stop(audioContext.currentTime + 0.15);
                    }

                    function init() {
                        // Generate words based on mode
                        generatedWords = [];

                        if (currentMode === 'quote') {
                            // Pick a random quote and split into words
                            const quote = quotes[Math.floor(Math.random() * quotes.length)];
                            generatedWords = quote.split(' ');
                        } else if (currentMode === 'code') {
                            // Pick random code snippets
                            const snippet = codeSnippets[Math.floor(Math.random() * codeSnippets.length)];
                            generatedWords = snippet.split(' ');
                        } else {
                            // Time or Words mode - generate from word list
                            const wordList = getWordList();
                            const count = currentMode === 'words' ? wordLimit : 200;
                            for (let i = 0; i < count; i++) {
                                const randomIndex = Math.floor(Math.random() * wordList.length);
                                generatedWords.push(transformWord(wordList[randomIndex]));
                            }
                        }

                        // Reset stats
                        currentWordIndex = 0;
                        correctKeystrokes = 0;
                        totalKeystrokes = 0;
                        wrongKeystrokes = 0;
                        wpmHistory = [];

                        // Set time display based on mode
                        if (currentMode === 'time') {
                            timeLeft = timeLimit;
                            timerDisplay.innerText = timeLeft;
                        } else {
                            timeLeft = 0; // Count up for other modes
                            timerDisplay.innerText = '0';
                        }

                        wpmDisplay.innerText = '0';
                        accuracyDisplay.innerText = '100%';
                        input.value = '';
                        isRunning = false;
                        clearInterval(timer);

                        // Reset progress bar
                        progressBar.style.width = currentMode === 'time' ? '100%' : '0%';
                        progressBar.style.background = 'linear-gradient(90deg, #4299e1, #667eea)';

                        // Reset space hint
                        spaceHint.classList.remove('ready');

                        // Reset chart and keyboard
                        initChart();
                        resetKeyboard();

                        // Update display
                        updateCurrentWordDisplay('');
                        updateUpcomingWords();
                    }

                    // Render current word with character highlighting
                    function updateCurrentWordDisplay(typedValue) {
                        const currentWord = generatedWords[currentWordIndex];
                        let html = '';

                        for (let i = 0; i < currentWord.length; i++) {
                            let charClass = 'char';

                            if (i < typedValue.length) {
                                // Character has been typed
                                if (typedValue[i] === currentWord[i]) {
                                    charClass += ' correct';
                                } else {
                                    charClass += ' incorrect';
                                }
                            } else if (i === typedValue.length) {
                                // Current cursor position
                                charClass += ' current';
                            }

                            html += '<span class="' + charClass + '">' + currentWord[i] + '</span>';
                        }

                        currentWordDisplay.innerHTML = html;

                        // Update space hint - show ready when word is typed correctly
                        if (typedValue === currentWord) {
                            spaceHint.classList.add('ready');
                        } else {
                            spaceHint.classList.remove('ready');
                        }
                    }

                    // Show upcoming words
                    function updateUpcomingWords() {
                        let html = '';
                        const start = currentWordIndex + 1;
                        const end = Math.min(start + 10, generatedWords.length);

                        for (let i = start; i < end; i++) {
                            html += '<span class="word">' + generatedWords[i] + '</span>';
                        }

                        upcomingWords.innerHTML = html;
                    }

                    let startTime = null;

                    function startTimer() {
                        if (!isRunning) {
                            isRunning = true;
                            startTime = Date.now();

                            timer = setInterval(() => {
                                if (currentMode === 'time') {
                                    timeLeft--;
                                    timerDisplay.innerText = timeLeft;
                                    if (timeLeft === 0) finishTest();
                                } else {
                                    timeLeft++;
                                    timerDisplay.innerText = timeLeft;
                                }

                                updateStats();
                            }, 1000);
                        }
                    }

                    function updateStats() {
                        let timeElapsed;
                        if (currentMode === 'time') {
                            timeElapsed = timeLimit - timeLeft;
                        } else {
                            timeElapsed = timeLeft;
                        }

                        if (timeElapsed > 0) {
                            const wpm = Math.round((correctKeystrokes / 5) / (timeElapsed / 60));
                            wpmDisplay.innerText = wpm;
                            updateChart(wpm);
                        }

                        const accuracy = totalKeystrokes > 0 ? Math.round((correctKeystrokes / totalKeystrokes) * 100) : 100;
                        accuracyDisplay.innerText = accuracy + '%';

                        // Update progress bar
                        if (currentMode === 'time') {
                            const progress = (timeLeft / timeLimit) * 100;
                            progressBar.style.width = progress + '%';
                            if (timeLeft <= 10) {
                                progressBar.style.background = 'linear-gradient(90deg, #ef4444, #f97316)';
                            } else if (timeLeft <= 20) {
                                progressBar.style.background = 'linear-gradient(90deg, #f97316, #eab308)';
                            }
                        } else if (currentMode === 'words') {
                            const progress = (currentWordIndex / wordLimit) * 100;
                            progressBar.style.width = progress + '%';
                        } else {
                            const progress = (currentWordIndex / generatedWords.length) * 100;
                            progressBar.style.width = progress + '%';
                        }
                    }

                    function finishTest() {
                        clearInterval(timer);
                        isRunning = false;
                        input.blur();

                        let timeElapsed;
                        if (currentMode === 'time') {
                            timeElapsed = timeLimit;
                        } else {
                            timeElapsed = timeLeft > 0 ? timeLeft : 1;
                        }

                        const wpm = Math.round((correctKeystrokes / 5) / (timeElapsed / 60));
                        const accuracy = totalKeystrokes > 0 ? Math.round((correctKeystrokes / totalKeystrokes) * 100) : 100;

                        document.getElementById('finalWpm').innerText = wpm;
                        document.getElementById('finalAccuracy').innerText = accuracy + '%';
                        document.getElementById('finalKeystrokes').innerText = totalKeystrokes;
                        document.getElementById('finalCorrect').innerText = correctKeystrokes;
                        document.getElementById('finalWrong').innerText = wrongKeystrokes;

                        // Save to history
                        saveToHistory(wpm, accuracy, currentMode, currentDifficulty);

                        resultModal.style.display = 'flex';
                    }

                    function closeModal() {
                        resultModal.style.display = 'none';
                        resetTest();
                    }

                    function resetTest() {
                        clearInterval(timer);
                        init();
                        focusInput();
                    }

                    function focusInput() {
                        input.focus();
                    }

                    function shareResult() {
                        const wpm = document.getElementById('finalWpm').innerText;
                        const accuracy = document.getElementById('finalAccuracy').innerText;
                        const text = "I just scored " + wpm + " WPM with " + accuracy + " accuracy on the Typing Speed Test by @anish2good! 🎯⌨️\n\nCan you beat my score?\n\nhttps://8gwifi.org/typing-speed-test.jsp";
                        const url = "https://twitter.com/intent/tweet?text=" + encodeURIComponent(text) + "&hashtags=TypingTest,WPM,DevTools";
                        window.open(url, '_blank');
                    }

                    input.addEventListener('input', () => {
                        // Start timer on first keystroke
                        if (!isRunning) {
                            if (currentMode === 'time' && timeLeft > 0) {
                                startTimer();
                            } else if (currentMode !== 'time') {
                                startTimer();
                            }
                        }

                        const currentWord = generatedWords[currentWordIndex];
                        if (!currentWord) return; // Test complete

                        const typedValue = input.value;

                        // Handle space (end of word)
                        if (typedValue.endsWith(' ')) {
                            const trimmedValue = typedValue.trim();

                            // Track keyboard for space
                            updateKeyboard(' ', trimmedValue === currentWord);

                            // Check if word is correct
                            if (trimmedValue === currentWord) {
                                correctKeystrokes += currentWord.length + 1;
                                totalKeystrokes += currentWord.length + 1;
                                playSpaceSound();
                            } else {
                                wrongKeystrokes++;
                                totalKeystrokes += trimmedValue.length + 1;
                                playErrorSound();
                            }

                            // Move to next word
                            currentWordIndex++;
                            input.value = '';

                            // Check if test is complete (for non-time modes)
                            if (currentMode !== 'time' && currentWordIndex >= generatedWords.length) {
                                finishTest();
                                return;
                            }

                            // Update displays
                            updateCurrentWordDisplay('');
                            updateUpcomingWords();
                        } else {
                            // Update current word display with typed characters
                            updateCurrentWordDisplay(typedValue);

                            // Sound and keyboard feedback
                            if (typedValue.length > 0) {
                                const lastChar = typedValue[typedValue.length - 1];
                                const expectedChar = currentWord[typedValue.length - 1];
                                const isCorrect = lastChar === expectedChar;

                                updateKeyboard(lastChar, isCorrect);
                                playKeySound(isCorrect);
                            }
                        }
                    });

                    // Prevent space scrolling
                    window.addEventListener('keydown', function (e) {
                        if (e.key === ' ' && e.target === document.body) {
                            e.preventDefault();
                        }
                    });

                    // Initialize on load
                    init();
                    renderHistory();
                    renderKeyboardLayout();

                    // Auto-focus input so user can start typing immediately
                    setTimeout(() => focusInput(), 100);

</script>
<%@ include file="thanks.jsp" %>
</body>
</html>