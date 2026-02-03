<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">

    <!-- SEO -->
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Online Tuner - Guitar, Violin, Ukulele & All Instruments" />
        <jsp:param name="toolDescription"
            value="Free online chromatic tuner for guitar, violin, ukulele, bass, cello, and all instruments. Accurate pitch detection using your microphone. No download required." />
        <jsp:param name="toolCategory" value="Music" />
        <jsp:param name="toolUrl" value="music/tuner.jsp" />
        <jsp:param name="toolKeywords"
            value="online tuner, guitar tuner, chromatic tuner, violin tuner, ukulele tuner, bass tuner, instrument tuner, free tuner, pitch detection, tune guitar online" />
        <jsp:param name="toolImage" value="tuner-tool.png" />
        <jsp:param name="toolFeatures"
            value="Chromatic pitch detection,Real-time tuning feedback,Visual tuning meter,Guitar tuning E A D G B E,Violin tuning G D A E,Ukulele tuning G C E A,Bass guitar tuning,Works on all instruments,Mobile friendly,No download required" />
        <jsp:param name="hasSteps" value="false" />
        <jsp:param name="faq1q" value="What is a chromatic tuner?" />
        <jsp:param name="faq1a"
            value="A chromatic tuner detects all 12 musical notes (C, C#, D, D#, E, F, F#, G, G#, A, A#, B) and shows whether your note is sharp, flat, or in tune. Unlike instrument-specific tuners, it works for any instrument." />
        <jsp:param name="faq2q" value="How do I tune my guitar with this online tuner?" />
        <jsp:param name="faq2a"
            value="Click Start Tuning, allow microphone access, then play each string one at a time. Standard guitar tuning from lowest to highest is E A D G B E. Adjust each string until the tuner shows green (in tune)." />
        <jsp:param name="faq3q" value="Why is my tuner not detecting the note?" />
        <jsp:param name="faq3a"
            value="Make sure you're in a quiet environment, play one string at a time, and let the note ring clearly. Check that your browser has microphone permission enabled for this site." />
        <jsp:param name="faq4q" value="What is the standard tuning for ukulele?" />
        <jsp:param name="faq4a"
            value="Standard ukulele tuning is G C E A (from top string to bottom when holding the ukulele). Note that the G string is higher pitched than the C string - this is called re-entrant tuning." />
    </jsp:include>

    <!-- Custom HowTo Schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Tune Your Instrument with an Online Tuner",
      "description": "Learn how to use an online chromatic tuner to tune your guitar, violin, ukulele, or any string instrument.",
      "totalTime": "PT3M",
      "step": [
        {
          "@type": "HowToStep",
          "name": "Start the Tuner",
          "text": "Click the green 'Start Tuning' button and allow microphone access when prompted by your browser."
        },
        {
          "@type": "HowToStep",
          "name": "Play a String",
          "text": "Pluck or bow one string at a time. Let the note ring clearly so the tuner can detect the pitch."
        },
        {
          "@type": "HowToStep",
          "name": "Read the Display",
          "text": "The tuner shows the detected note and whether it's sharp (too high), flat (too low), or in tune (green)."
        },
        {
          "@type": "HowToStep",
          "name": "Adjust the Pitch",
          "text": "Turn the tuning peg to raise or lower the pitch until the meter is centered and shows 'In Tune'."
        },
        {
          "@type": "HowToStep",
          "name": "Repeat for All Strings",
          "text": "Tune each string from lowest to highest. Double-check all strings as tuning one can affect others."
        }
      ]
    }
    </script>

    <!-- Fonts & CSS -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <style>
        .tuner-card {
            background: var(--bg-primary);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border);
        }

        .tuner-display {
            text-align: center;
            margin-bottom: 2rem;
        }

        .note-display {
            font-size: 8rem;
            font-weight: 800;
            color: var(--primary);
            line-height: 1;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(99, 102, 241, 0.2);
        }

        .frequency-display {
            font-size: 1.5rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .tuning-meter {
            position: relative;
            width: 100%;
            max-width: 500px;
            height: 100px;
            margin: 2rem auto;
            background: var(--bg-secondary);
            border-radius: 12px;
            overflow: hidden;
            border: 2px solid var(--border);
        }

        .meter-ticks {
            position: absolute;
            top: 15px;
            left: 0;
            right: 0;
            display: flex;
            justify-content: space-between;
            padding: 0 10%;
        }

        .meter-tick {
            width: 2px;
            height: 20px;
            background: var(--text-tertiary);
        }

        .meter-tick.center {
            height: 30px;
            width: 3px;
            background: #22c55e;
        }

        .meter-labels {
            position: absolute;
            bottom: 10px;
            left: 0;
            right: 0;
            display: flex;
            justify-content: space-between;
            padding: 0 8%;
            font-size: 0.75rem;
            color: var(--text-secondary);
        }

        .meter-needle {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 4px;
            height: 50px;
            background: linear-gradient(to bottom, var(--primary), var(--primary-dark));
            transform: translateX(-50%) translateY(-40%) rotate(0deg);
            transform-origin: bottom center;
            transition: transform 0.1s ease;
            border-radius: 2px;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.5);
        }

        .tuning-status {
            text-align: center;
            font-size: 1.25rem;
            font-weight: 600;
            margin-top: 1rem;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .tuning-status.flat {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
        }

        .tuning-status.sharp {
            background: rgba(251, 191, 36, 0.1);
            color: #f59e0b;
        }

        .tuning-status.in-tune {
            background: rgba(34, 197, 94, 0.1);
            color: #22c55e;
        }

        .tuner-controls {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin: 2rem 0;
        }

        .tuner-btn {
            padding: 1rem 2.5rem;
            font-size: 1.125rem;
            font-weight: 600;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .tuner-btn.start {
            background: #22c55e;
            color: white;
        }

        .tuner-btn.start:hover {
            background: #16a34a;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(34, 197, 94, 0.4);
        }

        .tuner-btn.stop {
            background: #ef4444;
            color: white;
        }

        .tuner-btn.stop:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        }

        .listening-indicator {
            display: none;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            font-size: 1rem;
            margin-top: 1rem;
        }

        .listening-indicator.active {
            display: flex;
        }

        .pulse-dot {
            width: 12px;
            height: 12px;
            background: #22c55e;
            border-radius: 50%;
            animation: pulse 1.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.5; transform: scale(1.2); }
        }

        .instrument-presets {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .preset-card {
            background: var(--bg-secondary);
            border: 2px solid var(--border);
            border-radius: 12px;
            padding: 1.25rem;
            text-align: center;
            transition: all 0.3s ease;
        }

        .preset-card:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.15);
        }

        .preset-card h3 {
            font-size: 1rem;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        .preset-notes {
            font-family: 'Courier New', monospace;
            color: var(--primary);
            font-size: 0.9rem;
            font-weight: 600;
            letter-spacing: 0.05em;
        }

        /* Mobile */
        @media (max-width: 600px) {
            .tuner-card {
                padding: 1.5rem;
            }
            .note-display {
                font-size: 5rem;
            }
            .tuner-btn {
                padding: 0.875rem 1.5rem;
                font-size: 1rem;
            }
            .instrument-presets {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>

<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- Side Rails Ads (Desktop Only) -->
    <%@ include file="../modern/ads/ad-side-rails.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Free Online Tuner</h1>
                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Chromatic tuner for guitar, violin, ukulele, bass & all instruments</p>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                    Tuner
                </nav>
            </div>
        </div>
    </header>

    <!-- Top Ad -->
    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

    <main class="tool-page-content" style="max-width: 900px; margin: 0 auto; padding: 2rem 1rem;">

        <!-- Tuner Card -->
        <section class="tuner-card">

            <!-- Tuner Display -->
            <div class="tuner-display">
                <div class="note-display" id="noteDisplay">-</div>
                <div class="frequency-display" id="frequencyDisplay">0 Hz</div>
            </div>

            <!-- Tuning Meter -->
            <div class="tuning-meter">
                <div class="meter-ticks">
                    <div class="meter-tick"></div>
                    <div class="meter-tick"></div>
                    <div class="meter-tick center"></div>
                    <div class="meter-tick"></div>
                    <div class="meter-tick"></div>
                </div>
                <div class="meter-labels">
                    <span>Flat</span>
                    <span>In Tune</span>
                    <span>Sharp</span>
                </div>
                <div class="meter-needle" id="meterNeedle"></div>
            </div>

            <!-- Tuning Status -->
            <div style="text-align: center;">
                <div class="tuning-status" id="tuningStatus">Click Start to begin tuning</div>
            </div>

            <!-- Controls -->
            <div class="tuner-controls">
                <button class="tuner-btn start" id="startBtn">
                    <span style="font-size: 1.5rem;">🎤</span>
                    <span>Start Tuning</span>
                </button>
                <button class="tuner-btn stop" id="stopBtn" style="display: none;">
                    <span style="font-size: 1.5rem;">⏹️</span>
                    <span>Stop Tuning</span>
                </button>
            </div>

            <!-- Listening Indicator -->
            <div class="listening-indicator" id="listeningIndicator">
                <div class="pulse-dot"></div>
                <span>Listening...</span>
            </div>

        </section>

        <!-- Mobile Banner Ad -->
        <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

        <!-- Instrument Tunings -->
        <section style="margin-top: 3rem;">
            <h2>Common Instrument Tunings</h2>
            <p style="color: var(--text-secondary); margin-bottom: 1rem;">Notes listed from lowest to highest string (except ukulele and banjo which have re-entrant tuning).</p>
            <div class="instrument-presets">
                <div class="preset-card">
                    <h3>🎸 Guitar</h3>
                    <div class="preset-notes">E A D G B E</div>
                </div>
                <div class="preset-card">
                    <h3>🎸 Bass Guitar</h3>
                    <div class="preset-notes">E A D G</div>
                </div>
                <div class="preset-card">
                    <h3>🪕 Ukulele</h3>
                    <div class="preset-notes">G C E A</div>
                </div>
                <div class="preset-card">
                    <h3>🪕 Banjo</h3>
                    <div class="preset-notes">G D G B D</div>
                </div>
                <div class="preset-card">
                    <h3>🎻 Mandolin</h3>
                    <div class="preset-notes">G G D D A A E E</div>
                </div>
                <div class="preset-card">
                    <h3>🎻 Violin</h3>
                    <div class="preset-notes">G D A E</div>
                </div>
                <div class="preset-card">
                    <h3>🎻 Viola</h3>
                    <div class="preset-notes">C G D A</div>
                </div>
                <div class="preset-card">
                    <h3>🎻 Cello</h3>
                    <div class="preset-notes">C G D A</div>
                </div>
                <div class="preset-card">
                    <h3>🎻 Double Bass</h3>
                    <div class="preset-notes">E A D G</div>
                </div>
            </div>
        </section>

        <!-- SEO Content -->
        <section class="tool-expertise-section" style="margin-top: 4rem;">
            <h2>What is a Tuner?</h2>
            <p>A tuner is a device that detects a note's pitch when played on a musical instrument, and compares it to the desired pitch. The tuner indicates whether the note is too high (sharp), too low (flat), or in tune, helping musicians tune their instruments easily.</p>

            <p style="margin-top: 1rem;">It's most common to use a tuner for string instruments such as guitars and violins. Over time, the strings stretch and loosen, and the instruments need to be tuned regularly to maintain optimal sound. Most tuners are "chromatic tuners" and detect all 12 distinct notes in Western music.</p>

            <h3 style="margin-top: 2rem;">Using the Online Tuner</h3>
            <p>To tune your instrument, click the green microphone button. You will be asked to allow access to your device's microphone so the tuner can hear what you play. As you play a note on your instrument, adjust the pitch until the tuner indicates the note is in tune (green indicator, centered needle).</p>

            <h3 style="margin-top: 2rem;">Standard Tunings by Instrument</h3>
            <p>You can use a tuner for all musical instruments. The notes are written from lowest to highest, except for the ukulele and banjo that don't have strings ordered by pitch:</p>
            <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary); line-height: 1.8;">
                <li><strong>Guitar:</strong> E A D G B E (standard tuning for classical, acoustic, and electric)</li>
                <li><strong>Bass Guitar:</strong> E A D G (4-string), B E A D G (5-string)</li>
                <li><strong>Ukulele:</strong> G C E A (re-entrant tuning - G is higher than C)</li>
                <li><strong>Banjo:</strong> G D G B D (open G tuning)</li>
                <li><strong>Mandolin:</strong> G G D D A A E E (paired strings tuned in unison)</li>
                <li><strong>Violin:</strong> G D A E (perfect fifths)</li>
                <li><strong>Viola:</strong> C G D A (a fifth below violin)</li>
                <li><strong>Cello:</strong> C G D A (an octave below viola)</li>
                <li><strong>Double Bass:</strong> E A D G (same as bass guitar)</li>
            </ul>

            <h3 style="margin-top: 2rem;">Tips for Best Results</h3>
            <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                <li><strong>Quiet environment:</strong> Background noise can interfere with pitch detection</li>
                <li><strong>One string at a time:</strong> Mute other strings while tuning</li>
                <li><strong>Let notes ring:</strong> Give the tuner time to analyze the pitch</li>
                <li><strong>Tune up to pitch:</strong> If a string is sharp, loosen it below the target note and tune up</li>
                <li><strong>Double-check:</strong> Tuning one string can affect others, so check all strings again</li>
            </ul>

            <h3 style="margin-top: 2rem;">Why Do Instruments Go Out of Tune?</h3>
            <p>String instruments go out of tune due to several factors:</p>
            <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                <li><strong>String stretching:</strong> New strings need time to settle and will go flat frequently</li>
                <li><strong>Temperature changes:</strong> Heat causes strings to expand (go flat), cold causes contraction (go sharp)</li>
                <li><strong>Humidity:</strong> Affects the wood of the instrument, changing string tension</li>
                <li><strong>Playing:</strong> Bending notes and heavy playing gradually pull strings out of tune</li>
                <li><strong>Tuning peg slippage:</strong> Mechanical issues can cause tuning instability</li>
            </ul>
        </section>

    </main>

    <!-- Related Tools -->
    <jsp:include page="../modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="music/tuner.jsp" />
        <jsp:param name="keyword" value="music" />
        <jsp:param name="limit" value="6" />
    </jsp:include>

    <%@ include file="../modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            </div>
        </div>
    </footer>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/music/js/tuner.js?v=<%=cacheVersion%>"></script>
</body>

</html>
