<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <% String cacheVersion=String.valueOf(System.currentTimeMillis()); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="robots" content="index,follow">
            <meta name="googlebot" content="index,follow">
            <meta name="resource-type" content="document">
            <meta name="classification" content="tools">
            <meta name="language" content="en">
            <meta name="author" content="Anish Nath">

            <!-- SEO -->
            <jsp:include page="../modern/components/seo-tool-page.jsp">
                <jsp:param name="toolName" value="Free Online Metronome - BPM Counter, Tap Tempo & Click Track" />
                <jsp:param name="toolDescription"
                    value="Free online metronome with tap tempo, adjustable BPM (30-250), time signatures, and click track. Perfect for guitar, drums, piano practice. No download required." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/metronome.jsp" />
                <jsp:param name="toolKeywords"
                    value="metronome online, free metronome, bpm counter, tap tempo, click track, metronome for guitar, metronome for drums, online metronome free, rhythm practice, 120 bpm metronome" />
                <jsp:param name="toolImage" value="metronome-tool.png" />
                <jsp:param name="toolFeatures"
                    value="High-precision Web Audio timing,Tap Tempo BPM detection,Visual beat counter,Time signatures (4/4 3/4 6/8 5/4),Subdivisions (quarter eighth triplet sixteenth),Practice mode with gradual tempo increase,Accent pattern customization,Keyboard shortcuts,Mobile responsive,No download required" />
                <jsp:param name="hasSteps" value="false" />
                <jsp:param name="faq1q" value="Is this online metronome accurate?" />
                <jsp:param name="faq1a"
                    value="Yes, our metronome uses the Web Audio API for sample-accurate timing, avoiding the drift issues common in simpler JavaScript timers. It maintains rock-solid timing even during long practice sessions." />
                <jsp:param name="faq2q" value="How do I use the Tap Tempo feature?" />
                <jsp:param name="faq2a"
                    value="Simply tap the Tap Tempo button (or press T on your keyboard) in time with any song. After 2-4 taps, the metronome will automatically calculate and set the BPM." />
                <jsp:param name="faq3q" value="Can I use this metronome for guitar practice?" />
                <jsp:param name="faq3a"
                    value="Absolutely! This metronome is perfect for guitar practice. Use 4/4 time for most rock and pop songs, 3/4 for waltzes, and try the subdivision feature for practicing scales and arpeggios." />
                <jsp:param name="faq4q" value="What BPM should I practice at as a beginner?" />
                <jsp:param name="faq4a"
                    value="Start slow at 60-80 BPM to build accuracy, then gradually increase. Use our Practice Mode to automatically increase tempo over time - a proven technique for building speed." />
                <jsp:param name="faq5q" value="Does this work on mobile phones?" />
                <jsp:param name="faq5a"
                    value="Yes! This metronome is fully mobile-responsive and works on iPhone, Android, and tablets. Tap anywhere on the screen to start, and use the large visual beat counter for easy viewing." />
                <jsp:param name="faq6q" value="What is the difference between 4/4 and 6/8 time?" />
                <jsp:param name="faq6a"
                    value="4/4 time has 4 beats per measure (most common in rock, pop, jazz). 6/8 time has 6 eighth-note beats grouped in two, creating a flowing feel common in ballads and folk music." />
            </jsp:include>

            <!-- Custom HowTo Schema (more specific than generic) -->
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Use an Online Metronome",
      "description": "Learn how to use a metronome for music practice to improve your timing and rhythm.",
      "totalTime": "PT2M",
      "step": [
        {
          "@type": "HowToStep",
          "name": "Set Your Tempo",
          "text": "Use the slider or +/- buttons to set your desired BPM (beats per minute). Start slow (60-80 BPM) if you're a beginner."
        },
        {
          "@type": "HowToStep",
          "name": "Choose Time Signature",
          "text": "Select your time signature: 4/4 for most popular music, 3/4 for waltzes, or 6/8 for compound rhythms."
        },
        {
          "@type": "HowToStep",
          "name": "Press Play",
          "text": "Click the play button or press Spacebar to start the metronome. The beat counter will show the current beat."
        },
        {
          "@type": "HowToStep",
          "name": "Practice with the Beat",
          "text": "Play your instrument in time with the clicks. The first beat of each measure has a higher pitch accent."
        }
      ]
    }
    </script>

            <!-- Fonts & CSS -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap">

            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/business/css/salary-calc.css?v=<%=cacheVersion%>">
            <!-- Borrow layout helpers -->
            <link rel="stylesheet" href="<%=request.getContextPath()%>/music/css/metronome.css?v=<%=cacheVersion%>">

            <%@ include file="../modern/ads/ad-init.jsp" %>
        </head>

        <body>
            <%@ include file="../modern/components/nav-header.jsp" %>

                <!-- Side Rails Ads (Desktop Only - Left & Right) -->
                <%@ include file="../modern/ads/ad-side-rails.jsp" %>

                <header class="tool-page-header">
                    <div class="tool-page-header-inner">
                        <div>
                            <h1 class="tool-page-title">Free Online Metronome with Tap Tempo</h1>
                            <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Accurate BPM counter & click track for guitar, drums, and piano practice</p>
                            <nav class="tool-breadcrumbs">
                                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                Metronome
                            </nav>
                        </div>
                    </div>
                </header>

                <!-- Top Ad - Leaderboard -->
                <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                <main class="tool-page-content" style="max-width: 1000px; margin: 0 auto; padding: 2rem 1rem;">

                    <!-- Metronome App Card -->
                    <section class="metronome-container">
                        <div class="metronome-card">

                                <div class="metronome-layout"
                                style="display: grid; grid-template-columns: 1fr 400px; gap: 1.5rem; max-width: 1200px; margin: 0 auto;">

                                <!-- LEFT: Visualization -->
                                <div>
                                    <!-- Beat Counter for Minimal Mode -->
                                    <div id="beatCounter"
                                        style="display: flex; width: 100%; height: 400px; margin-bottom: 1rem; border-radius: 12px; background: var(--bg-secondary); border: 2px solid var(--border); align-items: center; justify-content: center; font-size: 12rem; font-weight: 800; color: var(--text-primary); transition: all 0.1s ease;">
                                        1
                                    </div>

                                    <!-- Accent Pattern Selector -->
                                    <div style="margin-bottom: 1rem;">
                                        <label
                                            style="display: block; font-size: 0.875rem; color: var(--text-secondary); margin-bottom: 0.5rem; font-weight: 500;">
                                            Accent Pattern (Click beats to accent)
                                        </label>
                                        <div id="accentPatternSelector"
                                            style="display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap;">
                                            <!-- Beat buttons will be inserted by JS -->
                                        </div>
                                    </div>
                                </div>

                                <!-- RIGHT: All Controls -->
                                <div style="display: flex; flex-direction: column; gap: 1rem;">

                                    <!-- Tempo Display -->
                                    <div class="bpm-display-container" style="margin-bottom: 0;">
                                        <div class="bpm-value" id="bpmDisplay" onclick="togglePlay()">120</div>
                                        <div class="bpm-label" id="bpmLabel">Moderato</div>
                                    </div>

                                    <!-- Slider & Play Controls -->
                                    <div class="tempo-slider-container" style="margin-bottom: 0;">
                                        <input type="range" min="30" max="250" value="120" class="tempo-range"
                                            id="tempoRange">
                                        <div class="tempo-controls">
                                            <button class="tempo-btn" id="decreaseTempo" title="Decrease Tempo (-1)">
                                                <svg width="24" height="24" fill="none" stroke="currentColor"
                                                    stroke-width="2" viewBox="0 0 24 24">
                                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                                </svg>
                                            </button>
                                            <button class="play-btn-large" id="playBtn" onclick="togglePlay()"
                                                title="Play (Space)">
                                                <svg class="play-icon" viewBox="0 0 24 24" fill="currentColor">
                                                    <path d="M8 5v14l11-7z" />
                                                </svg>
                                                <svg class="pause-icon" viewBox="0 0 24 24" fill="currentColor">
                                                    <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z" />
                                                </svg>
                                            </button>
                                            <button class="tempo-btn" id="increaseTempo" title="Increase Tempo (+1)">
                                                <svg width="24" height="24" fill="none" stroke="currentColor"
                                                    stroke-width="2" viewBox="0 0 24 24">
                                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                                </svg>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Settings Grid (2x2) -->
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                                        <div class="control-group" style="margin-bottom: 0;">
                                            <label class="control-label">Time Signature</label>
                                            <select class="control-select" id="measureSelect">
                                                <option value="1">1/4</option>
                                                <option value="2">2/4</option>
                                                <option value="3">3/4 (Waltz)</option>
                                                <option value="4" selected>4/4 (Common)</option>
                                                <option value="5">5/4</option>
                                                <option value="6">6/8 (Compound)</option>
                                            </select>
                                        </div>
                                        <div class="control-group" style="margin-bottom: 0;">
                                            <label class="control-label">Subdivision</label>
                                            <select class="control-select" id="subdivisionSelect">
                                                <option value="1" selected>Quarter (♩)</option>
                                                <option value="2">Eighth (♪)</option>
                                                <option value="3">Triplets</option>
                                                <option value="4">Sixteenths</option>
                                            </select>
                                        </div>
                                        <div class="control-group" style="margin-bottom: 0;">
                                            <label class="control-label">Sound</label>
                                            <select class="control-select" id="soundSelect">
                                                <option value="click" selected>Digital Click</option>
                                                <option value="woodblock">Woodblock</option>
                                                <option value="drum">Drum Kit</option>
                                                <option value="beep">Simple Beep</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Tap Tempo -->
                                    <button class="tap-tempo-btn" id="tapBtn" title="Tap 'T' on keyboard">Tap
                                        Tempo</button>

                                    <!-- Advanced Features (3 buttons) -->
                                    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 0.5rem;">
                                        <button class="tap-tempo-btn" id="visualFlashBtn" onclick="toggleVisualFlash()"
                                            title="Press 'V'" style="font-size: 0.85rem; padding: 0.6rem;">
                                            👁️ Flash
                                        </button>
                                        <button class="tap-tempo-btn" id="savePresetBtn" onclick="saveCurrentAsPreset()"
                                            title="Press 'S'" style="font-size: 0.85rem; padding: 0.6rem;">
                                            💾 Save
                                        </button>
                                        <button class="tap-tempo-btn" id="loadPresetBtn" onclick="showPresetModal()"
                                            title="Load presets" style="font-size: 0.85rem; padding: 0.6rem;">
                                            📂 Load
                                        </button>
                                    </div>

                                    <!-- Practice Mode (Compact) -->
                                    <div
                                        style="padding: 0.75rem; background: var(--surface); border-radius: 8px; border: 1px solid var(--border);">
                                        <div
                                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                            <label
                                                style="font-size: 0.875rem; font-weight: 500; color: var(--text-primary);">📈
                                                Practice Mode</label>
                                            <button id="practiceModeBtn" onclick="togglePracticeMode()"
                                                style="background: var(--primary); color: white; border: none; padding: 0.35rem 0.75rem; border-radius: 6px; cursor: pointer; font-size: 0.8rem;">Start</button>
                                        </div>
                                        <div
                                            style="display: flex; gap: 0.4rem; font-size: 0.75rem; align-items: center;">
                                            <input type="number" id="practiceStart" value="60" min="30" max="250"
                                                style="width: 55px; padding: 0.25rem; border-radius: 4px; border: 1px solid var(--border); font-size: 0.75rem;"
                                                placeholder="Start">
                                            <span style="color: var(--text-secondary);">→</span>
                                            <input type="number" id="practiceEnd" value="120" min="30" max="250"
                                                style="width: 55px; padding: 0.25rem; border-radius: 4px; border: 1px solid var(--border); font-size: 0.75rem;"
                                                placeholder="End">
                                            <span style="color: var(--text-secondary);">in</span>
                                            <input type="number" id="practiceDuration" value="5" min="1" max="30"
                                                style="width: 45px; padding: 0.25rem; border-radius: 4px; border: 1px solid var(--border); font-size: 0.75rem;"
                                                placeholder="Min">
                                            <span style="color: var(--text-secondary);">min</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </section>

                    <!-- Preset Modal -->
                    <div id="presetModal"
                        style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 9999; justify-content: center; align-items: center;">
                        <div
                            style="background: var(--card-bg); border-radius: 16px; padding: 2rem; max-width: 500px; width: 90%; max-height: 80vh; overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
                            <div
                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                                <h3 style="margin: 0; color: var(--text-primary);">Saved Presets</h3>
                                <button onclick="closePresetModal()"
                                    style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--text-secondary);">×</button>
                            </div>
                            <div id="presetList" style="display: flex; flex-direction: column; gap: 0.75rem;">
                                <!-- Presets will be inserted here -->
                            </div>
                        </div>
                    </div>

                    <!-- Mobile Banner Ad -->
                    <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                    <!-- Tempo Presets -->
                    <section style="margin-top: 3rem;">
                        <h2>Common Tempo Markings</h2>
                        <div class="tempo-markings">
                            <div class="tempo-marking-card" onclick="loadPreset(45)">
                                <span class="marking-name">Largo</span>
                                <span class="marking-range">40-60 BPM</span>
                            </div>
                            <div class="tempo-marking-card" onclick="loadPreset(66)">
                                <span class="marking-name">Adagio</span>
                                <span class="marking-range">66-76 BPM</span>
                            </div>
                            <div class="tempo-marking-card" onclick="loadPreset(90)">
                                <span class="marking-name">Andante</span>
                                <span class="marking-range">76-108 BPM</span>
                            </div>
                            <div class="tempo-marking-card" onclick="loadPreset(110)">
                                <span class="marking-name">Moderato</span>
                                <span class="marking-range">108-120 BPM</span>
                            </div>
                            <div class="tempo-marking-card" onclick="loadPreset(140)">
                                <span class="marking-name">Allegro</span>
                                <span class="marking-range">120-156 BPM</span>
                            </div>
                            <div class="tempo-marking-card" onclick="loadPreset(180)">
                                <span class="marking-name">Presto</span>
                                <span class="marking-range">168-200 BPM</span>
                            </div>
                        </div>
                    </section>

                    <!-- SEO Content -->
                    <section class="tool-expertise-section" style="margin-top: 4rem;">
                        <h2>Why Use an Online Metronome?</h2>
                        <p>A metronome is the most important practice tool for any musician. Whether you're learning guitar, drums, piano, or any other instrument, practicing with a metronome builds the internal clock that separates amateur players from professionals. Our <strong>free online metronome</strong> uses the Web Audio API for sample-accurate timing that won't drift, even during hour-long practice sessions.</p>

                        <h3 style="margin-top: 2rem;">How to Use This Metronome</h3>
                        <ol style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary); line-height: 1.8;">
                            <li><strong>Set your tempo</strong> using the slider (30-250 BPM) or use Tap Tempo to match a song</li>
                            <li><strong>Choose a time signature</strong> - 4/4 for most music, 3/4 for waltzes, 6/8 for compound rhythms</li>
                            <li><strong>Click Play</strong> or press Spacebar to start the click track</li>
                            <li><strong>Practice slowly first</strong> - accuracy at 60 BPM beats sloppiness at 120 BPM</li>
                            <li><strong>Use Practice Mode</strong> to gradually increase tempo as you improve</li>
                        </ol>

                        <h3 style="margin-top: 2rem;">Metronome for Guitar Practice</h3>
                        <p>Guitar players benefit enormously from metronome practice. Use it for:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.5rem; color: var(--text-secondary);">
                            <li><strong>Scale exercises:</strong> Set subdivisions to sixteenths and practice scales evenly</li>
                            <li><strong>Chord changes:</strong> Practice switching chords on beat 1 at a slow tempo</li>
                            <li><strong>Strumming patterns:</strong> Lock in your down-up strumming with the click</li>
                            <li><strong>Speed building:</strong> Use Practice Mode to increase from 60 to 120 BPM over 5 minutes</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Metronome for Drummers</h3>
                        <p>Every professional drummer practices with a click track. This metronome helps you:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.5rem; color: var(--text-secondary);">
                            <li><strong>Develop internal timing:</strong> The visual beat counter helps you internalize the pulse</li>
                            <li><strong>Practice odd time signatures:</strong> 5/4, 7/8, and other complex meters</li>
                            <li><strong>Subdivisions:</strong> Practice ghost notes with eighth or sixteenth subdivisions</li>
                            <li><strong>Recording preparation:</strong> Get comfortable playing to a click before studio sessions</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Common BPM Tempo Guide</h3>
                        <p>Different musical styles typically use specific tempo ranges:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.5rem; color: var(--text-secondary);">
                            <li><strong>60-70 BPM:</strong> Ballads, slow songs, meditation music</li>
                            <li><strong>80-100 BPM:</strong> Hip-hop, R&B, reggae</li>
                            <li><strong>100-120 BPM:</strong> Pop, rock, most popular music</li>
                            <li><strong>120-140 BPM:</strong> Dance, electronic, upbeat pop</li>
                            <li><strong>140-180 BPM:</strong> Punk, metal, fast jazz</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Tap Tempo: Find Any Song's BPM</h3>
                        <p>Don't know the tempo of a song? Use our <strong>Tap Tempo</strong> feature. Simply tap the button (or press 'T') in time with the music, and the metronome will calculate the exact BPM. This is perfect for:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.5rem; color: var(--text-secondary);">
                            <li>Learning songs by ear</li>
                            <li>Matching tempo for DJ mixing</li>
                            <li>Finding the right practice speed</li>
                            <li>Analyzing music for transcription</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Practice Mode: Build Speed Safely</h3>
                        <p>Our unique <strong>Practice Mode</strong> gradually increases the tempo over time. This technique, used by professional musicians and music teachers worldwide, helps you:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.5rem; color: var(--text-secondary);">
                            <li>Build speed without sacrificing accuracy</li>
                            <li>Avoid injury from sudden tempo jumps</li>
                            <li>Track your progress over practice sessions</li>
                            <li>Stay motivated with achievable incremental goals</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Keyboard Shortcuts</h3>
                        <p>For faster workflow, use these keyboard shortcuts:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.5rem; color: var(--text-secondary);">
                            <li><strong>Spacebar:</strong> Play/Pause</li>
                            <li><strong>Arrow Up/Down:</strong> Increase/Decrease BPM by 1</li>
                            <li><strong>T:</strong> Tap Tempo</li>
                            <li><strong>V:</strong> Toggle Visual Flash</li>
                            <li><strong>S:</strong> Save current settings as preset</li>
                        </ul>
                    </section>

                </main>

                <!-- Related Tools -->
                <jsp:include page="../modern/components/related-tools.jsp">
                    <jsp:param name="currentToolUrl" value="music/metronome.jsp" />
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

                            <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"
                                defer></script>
                            <script
                                src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
                            <script src="https://unpkg.com/tone@14.7.77/build/Tone.js"></script>
                            <!-- Three.js will be lazy loaded when switching to Orb mode -->
                            <script
                                src="<%=request.getContextPath()%>/music/js/metronome.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>