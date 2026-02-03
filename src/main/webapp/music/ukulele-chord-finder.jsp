<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <% String cacheVersion=String.valueOf(System.currentTimeMillis()); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="robots" content="index,follow">
            <meta name="googlebot" content="index,follow">

            <!-- SEO -->
            <jsp:include page="../modern/components/seo-tool-page.jsp">
                <jsp:param name="toolName" value="Free Ukulele Chord Chart - 100+ Chords with Audio & Diagrams" />
                <jsp:param name="toolDescription"
                    value="Learn 100+ ukulele chords with interactive diagrams, audio playback, and fingering positions. Perfect for beginners learning GCEA tuning. Free online ukulele chord finder." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/ukulele-chord-finder.jsp" />
                <jsp:param name="toolKeywords"
                    value="ukulele chords, ukulele chord chart, uke chords, ukulele chord finder, learn ukulele, ukulele for beginners, GCEA tuning, ukulele fingering, free ukulele chords" />
                <jsp:param name="toolImage" value="ukulele-chords.png" />
                <jsp:param name="toolFeatures"
                    value="100+ ukulele chords,Interactive chord diagrams,Audio playback,Fingering positions,Major and minor chords,7th chords,Suspended chords,Chord progressions,GCEA standard tuning,Beginner friendly" />
                <jsp:param name="hasSteps" value="false" />
            </jsp:include>

            <!-- Custom HowTo Schema -->
            <script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "HowTo",
              "name": "How to Play Ukulele Chords for Beginners",
              "description": "Learn to play ukulele chords with our free interactive chord chart featuring diagrams and audio.",
              "totalTime": "PT10M",
              "step": [
                {"@type": "HowToStep", "position": 1, "name": "Select a root note", "text": "Click on a root note (C, D, E, F, G, A, B) or sharp/flat note to start building your chord."},
                {"@type": "HowToStep", "position": 2, "name": "Choose chord type", "text": "Select the chord type: Major, Minor, 7th, Major 7th, Minor 7th, Sus2, or Sus4."},
                {"@type": "HowToStep", "position": 3, "name": "Study the diagram", "text": "Look at the chord diagram showing finger positions on the 4 strings (G C E A). Numbers indicate which finger to use."},
                {"@type": "HowToStep", "position": 4, "name": "Position your fingers", "text": "Place your fingers on your ukulele matching the diagram. Press firmly just behind the fret."},
                {"@type": "HowToStep", "position": 5, "name": "Play and compare", "text": "Strum all 4 strings and click 'Play Chord' to hear how it should sound. Adjust if needed."}
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
                  "name": "What is standard ukulele tuning?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Standard ukulele tuning is G-C-E-A (from top to bottom string). This is called 're-entrant' tuning because the G string (4th string) is higher in pitch than the C string (3rd string), giving the ukulele its bright, cheerful sound."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What are the easiest ukulele chords for beginners?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The easiest ukulele chords are C Major (0003 - one finger), Am (2000 - one finger), F Major (2010 - two fingers), and G Major (0232 - three fingers). These four chords let you play hundreds of songs!"
                  }
                },
                {
                  "@type": "Question",
                  "name": "How do I read a ukulele chord diagram?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Vertical lines represent the 4 strings (G C E A from left to right). Horizontal lines are frets. Dots show where to place fingers. Numbers indicate which finger: 1=index, 2=middle, 3=ring, 4=pinky. 'O' means open string, 'X' means don't play that string."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How long does it take to learn ukulele chords?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Most beginners can play basic chords (C, Am, F, G) within 1-2 weeks of daily practice. Smooth chord transitions take about a month. The ukulele is one of the easiest instruments to learn, with most people playing simple songs within their first week!"
                  }
                },
                {
                  "@type": "Question",
                  "name": "What songs can I play with C, G, Am, and F chords?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "With just C, G, Am, and F you can play: 'Somewhere Over the Rainbow', 'I'm Yours' (Jason Mraz), 'Riptide' (Vance Joy), 'Let It Be' (Beatles), 'No Woman No Cry', 'Country Roads', and hundreds more pop songs that use this I-V-vi-IV progression."
                  }
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
            <link rel="stylesheet" href="<%=request.getContextPath()%>/music/css/chord-finder.css?v=<%=cacheVersion%>">

            <%@ include file="../modern/ads/ad-init.jsp" %>
        </head>

        <body>
            <%@ include file="../modern/components/nav-header.jsp" %>

                <!-- Side Rails Ads -->
                <%@ include file="../modern/ads/ad-side-rails.jsp" %>

                    <header class="tool-page-header">
                        <div class="tool-page-header-inner">
                            <div>
                                <h1 class="tool-page-title">Ukulele Chord Chart</h1>
                                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Learn
                                    100+ ukulele chords with interactive diagrams & audio</p>
                                <nav class="tool-breadcrumbs">
                                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                    <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                    Ukulele Chords
                                </nav>
                            </div>
                        </div>
                    </header>

                    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                        <main class="tool-page-content">
                            <div class="chord-finder-container">

                                <!-- Chord Selector -->
                                <section class="chord-selector-section">
                                    <div class="selector-group">
                                        <label class="selector-label">Root Note</label>
                                        <div class="note-buttons" id="rootNoteButtons"></div>
                                    </div>

                                    <div class="selector-group">
                                        <label class="selector-label">Chord Type</label>
                                        <div class="chord-type-buttons" id="chordTypeButtons"></div>
                                    </div>
                                </section>

                                <!-- Current Chord Display -->
                                <section class="current-chord-section">
                                    <h2 class="current-chord-name" id="currentChordName">C Major</h2>

                                    <!-- Ukulele Diagram -->
                                    <div class="ukulele-diagram-container">
                                        <canvas id="ukuleleCanvas" width="300" height="400"></canvas>
                                    </div>

                                    <!-- Chord Info -->
                                    <div class="chord-info">
                                        <div class="chord-info-item">
                                            <span class="info-label">Notes:</span>
                                            <span class="info-value" id="chordNotes">C E G</span>
                                        </div>
                                        <div class="chord-info-item">
                                            <span class="info-label">Fingering:</span>
                                            <span class="info-value" id="chordFingering">0 0 0 3</span>
                                        </div>
                                    </div>

                                    <!-- Play Button -->
                                    <button class="play-chord-btn" id="playChordBtn">
                                        <span>🔊</span>
                                        <span>Play Chord</span>
                                    </button>
                                </section>

                                <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                                    <!-- Popular Progressions -->
                                    <section class="progressions-section">
                                        <h3>Popular Ukulele Progressions</h3>
                                        <div class="progression-grid">
                                            <button class="progression-btn" data-progression="C,G,Am,F">C - G - Am -
                                                F</button>
                                            <button class="progression-btn" data-progression="G,D,Em,C">G - D - Em -
                                                C</button>
                                            <button class="progression-btn" data-progression="C,Am,F,G">C - Am - F -
                                                G</button>
                                            <button class="progression-btn" data-progression="F,C,G,Am">F - C - G -
                                                Am</button>
                                        </div>
                                    </section>

                                    <!-- SEO Content -->
                                    <section class="tool-expertise-section">
                                        <h2>Learn Ukulele Chords</h2>
                                        <p>Welcome to our free ukulele chord chart! Whether you're a complete beginner
                                            or looking to expand your chord vocabulary, this interactive tool helps you
                                            learn over 100 ukulele chords with visual diagrams, fingering positions, and
                                            audio playback.</p>

                                        <h3 style="margin-top: 2rem;">Standard Ukulele Tuning (GCEA)</h3>
                                        <p>The standard ukulele tuning is G-C-E-A (from top to bottom when holding the
                                            ukulele). This is called "re-entrant" tuning because the G string (4th
                                            string) is actually higher in pitch than the C string (3rd string). This
                                            unique tuning gives the ukulele its characteristic bright, cheerful sound.
                                        </p>

                                        <h3 style="margin-top: 2rem;">How to Read Ukulele Chord Diagrams</h3>
                                        <ul
                                            style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                            <li><strong>Vertical lines:</strong> Represent the 4 strings (G C E A from
                                                left to right)</li>
                                            <li><strong>Horizontal lines:</strong> Represent the frets</li>
                                            <li><strong>Dots:</strong> Show where to place your fingers</li>
                                            <li><strong>Numbers:</strong> Indicate which finger to use (1=index,
                                                2=middle, 3=ring, 4=pinky)</li>
                                            <li><strong>O:</strong> Open string (play without pressing)</li>
                                            <li><strong>X:</strong> Don't play this string</li>
                                        </ul>

                                        <h3 style="margin-top: 2rem;">Essential Beginner Chords</h3>
                                        <p>Start with these easy ukulele chords that appear in thousands of songs:</p>
                                        <ul
                                            style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                            <li><strong>C Major:</strong> 0003 - One finger on the 3rd fret of the A
                                                string</li>
                                            <li><strong>G Major:</strong> 0232 - Three fingers, easy shape</li>
                                            <li><strong>Am (A minor):</strong> 2000 - One finger on the 2nd fret of the
                                                G string</li>
                                            <li><strong>F Major:</strong> 2010 - Two fingers, common chord</li>
                                            <li><strong>D Major:</strong> 2220 - Three fingers in a row</li>
                                        </ul>

                                        <h3 style="margin-top: 2rem;">Tips for Learning Ukulele Chords</h3>
                                        <ul
                                            style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                            <li>Press strings firmly just behind the fret (not on top of it)</li>
                                            <li>Keep your thumb on the back of the neck for support</li>
                                            <li>Strum all four strings to hear the full chord</li>
                                            <li>Practice chord transitions slowly before speeding up</li>
                                            <li>Learn songs you love to stay motivated</li>
                                        </ul>
                                    </section>

                            </div>
                        </main>

                        <jsp:include page="../modern/components/related-tools.jsp">
                            <jsp:param name="currentToolUrl" value="music/ukulele-chord-finder.jsp" />
                            <jsp:param name="keyword" value="music" />
                            <jsp:param name="limit" value="6" />
                        </jsp:include>

                        <%@ include file="../modern/components/support-section.jsp" %>

                            <footer class="page-footer">
                                <div class="footer-content">
                                    <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
                                    <div class="footer-links">
                                        <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                                        <a href="<%=request.getContextPath()%>/tutorials/"
                                            class="footer-link">Tutorials</a>
                                    </div>
                                </div>
                            </footer>

                            <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
                                <%@ include file="../modern/components/analytics.jsp" %>

                                    <script
                                        src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"
                                        defer></script>
                                    <script
                                        src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
                                    <script src="https://cdn.jsdelivr.net/npm/tone@14.7.77/build/Tone.js"></script>
                                    <script
                                        src="<%=request.getContextPath()%>/music/js/ukulele-chord-finder.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>