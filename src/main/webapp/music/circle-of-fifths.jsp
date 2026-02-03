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
                <jsp:param name="toolName" value="Interactive Circle of Fifths - Music Theory Tool" />
                <jsp:param name="toolDescription"
                    value="Learn music theory with our interactive Circle of Fifths. Explore key signatures, chord progressions, scales, and relationships between keys. Perfect for musicians and composers." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/circle-of-fifths.jsp" />
                <jsp:param name="toolKeywords"
                    value="circle of fifths, music theory, key signatures, chord progressions, scales, major keys, minor keys, music education, learn music theory" />
                <jsp:param name="toolImage" value="circle-of-fifths.png" />
                <jsp:param name="toolFeatures"
                    value="Interactive circle,Key signatures,Chord progressions,Scale degrees,Major and minor keys,Audio playback,Relative keys,Parallel keys,Music theory education,Free online tool" />
                <jsp:param name="hasSteps" value="false" />
            </jsp:include>

            <!-- Custom HowTo Schema -->
            <script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "HowTo",
              "name": "How to Use the Circle of Fifths for Music Theory",
              "description": "Learn to use the Circle of Fifths to understand key signatures, find related chords, and compose music.",
              "totalTime": "PT10M",
              "step": [
                {"@type": "HowToStep", "position": 1, "name": "Click on a key", "text": "Click any key in the circle to select it. The outer ring shows major keys (C, G, D...), the inner ring shows minor keys (Am, Em, Bm...)."},
                {"@type": "HowToStep", "position": 2, "name": "View key signature", "text": "See how many sharps or flats are in the selected key. Moving clockwise adds sharps; counter-clockwise adds flats."},
                {"@type": "HowToStep", "position": 3, "name": "Learn the scale notes", "text": "View all 7 notes in the major or minor scale for the selected key."},
                {"@type": "HowToStep", "position": 4, "name": "Find chords in key", "text": "See all 7 chords that naturally occur in the key (I, ii, iii, IV, V, vi, vii°). These chords will sound good together."},
                {"@type": "HowToStep", "position": 5, "name": "Play the scale", "text": "Click 'Play Scale' to hear the notes of the scale played in order. This helps with ear training."},
                {"@type": "HowToStep", "position": 6, "name": "Explore relative keys", "text": "Find the relative minor/major key - they share the same notes and key signature but have different root notes."}
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
                  "name": "What is the Circle of Fifths?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The Circle of Fifths is a visual diagram showing the relationships between the 12 musical keys. Each key is a 'perfect fifth' (7 semitones) from its neighbors. It's the most important tool in music theory for understanding key signatures, chord relationships, and transposition."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Why is it called the Circle of Fifths?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Moving clockwise around the circle, each key is a perfect fifth (5 scale degrees, 7 semitones) higher than the previous. C→G→D→A→E→B→F#. A fifth is one of the most consonant intervals in music, which is why these key relationships sound so natural."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How do I memorize key signatures using the circle?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Start at C (no sharps/flats). Moving clockwise: each step adds 1 sharp (G=1#, D=2#, A=3#...). Moving counter-clockwise: each step adds 1 flat (F=1b, Bb=2b, Eb=3b...). The order of sharps is F-C-G-D-A-E-B; flats are the reverse: B-E-A-D-G-C-F."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What are relative major and minor keys?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Relative keys share the same notes and key signature but have different root notes. Every major key has a relative minor 3 semitones below it (or the 6th degree of the scale). For example: C major and A minor are relatives (both have no sharps/flats). G major and E minor are relatives (both have F#)."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How do I use the Circle of Fifths for chord progressions?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Keys next to each other on the circle share many common chords and transition smoothly. The I-IV-V progression uses three adjacent keys (e.g., C-F-G). For modulation, move to neighboring keys for smooth transitions. Common progressions like I-V-vi-IV use chords all found within one key."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What are the 7 chords in a major key?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "In any major key, the 7 diatonic chords are: I (major), ii (minor), iii (minor), IV (major), V (major), vi (minor), vii° (diminished). In C major: C, Dm, Em, F, G, Am, Bdim. These chords naturally fit together because they use only notes from the scale."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How does the Circle help with transposition?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "To transpose, count how many steps around the circle you need to move. Moving one step clockwise transposes up a fifth (+7 semitones). To transpose from C to D (2 semitones), every chord moves 2 positions clockwise on the circle. The circle shows you which sharps/flats the new key will have."
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

            <%@ include file="../modern/ads/ad-init.jsp" %>

                <style>
                    .circle-container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 2rem 1rem;
                    }

                    .circle-wrapper {
                        display: grid;
                        grid-template-columns: 1fr 400px;
                        gap: 2rem;
                        margin-bottom: 2rem;
                    }

                    .circle-canvas-container {
                        background: var(--bg-primary);
                        border-radius: 20px;
                        padding: 2rem;
                        border: 1px solid var(--border);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    #circleCanvas {
                        max-width: 100%;
                        cursor: pointer;
                    }

                    .key-info-panel {
                        background: var(--bg-primary);
                        border-radius: 20px;
                        padding: 2rem;
                        border: 1px solid var(--border);
                    }

                    .key-name {
                        font-size: 3rem;
                        font-weight: 800;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        margin-bottom: 0.5rem;
                    }

                    .key-type {
                        color: var(--text-secondary);
                        font-size: 1.25rem;
                        margin-bottom: 2rem;
                    }

                    .info-section {
                        margin-bottom: 2rem;
                    }

                    .info-label {
                        font-weight: 700;
                        color: var(--text-primary);
                        font-size: 0.875rem;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.5rem;
                    }

                    .info-value {
                        color: var(--text-secondary);
                        font-size: 1rem;
                        line-height: 1.6;
                    }

                    .chord-list {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 0.5rem;
                    }

                    .chord-badge {
                        background: var(--bg-secondary);
                        border: 1px solid var(--border);
                        padding: 0.5rem 1rem;
                        border-radius: 8px;
                        font-weight: 600;
                        font-size: 0.875rem;
                    }

                    .play-buttons {
                        display: flex;
                        gap: 0.75rem;
                        margin-top: 1rem;
                    }

                    .play-scale-btn,
                    .play-progression-btn {
                        flex: 1;
                        padding: 1rem;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        color: white;
                        border: none;
                        border-radius: 12px;
                        font-weight: 700;
                        font-size: 0.9rem;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .play-scale-btn:hover,
                    .play-progression-btn:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
                    }

                    .play-progression-btn {
                        background: linear-gradient(135deg, #10b981, #059669);
                    }

                    .play-progression-btn:hover {
                        box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
                    }

                    .play-scale-btn:disabled,
                    .play-progression-btn:disabled {
                        opacity: 0.6;
                        cursor: not-allowed;
                        transform: none;
                    }

                    .legend {
                        background: var(--bg-secondary);
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-top: 2rem;
                    }

                    .legend-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 1rem;
                        margin-top: 1rem;
                    }

                    .legend-item {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                    }

                    .legend-color {
                        width: 30px;
                        height: 30px;
                        border-radius: 6px;
                        border: 2px solid var(--border);
                    }

                    @media (max-width: 968px) {
                        .circle-wrapper {
                            grid-template-columns: 1fr;
                        }

                        .key-info-panel {
                            order: -1;
                        }
                    }
                </style>
        </head>

        <body>
            <%@ include file="../modern/components/nav-header.jsp" %>

                <!-- Side Rails Ads -->
                <%@ include file="../modern/ads/ad-side-rails.jsp" %>

                    <header class="tool-page-header">
                        <div class="tool-page-header-inner">
                            <div>
                                <h1 class="tool-page-title">Circle of Fifths</h1>
                                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">
                                    Interactive music theory tool - explore keys, scales, and chord progressions</p>
                                <nav class="tool-breadcrumbs">
                                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                    <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                    Circle of Fifths
                                </nav>
                            </div>
                        </div>
                    </header>

                    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                        <main class="circle-container">

                            <div class="circle-wrapper">
                                <!-- Circle Canvas -->
                                <div class="circle-canvas-container">
                                    <canvas id="circleCanvas" width="600" height="600"></canvas>
                                </div>

                                <!-- Key Info Panel -->
                                <div class="key-info-panel">
                                    <div class="key-name" id="keyName">C Major</div>
                                    <div class="key-type" id="keyType">Major Key</div>

                                    <div class="info-section">
                                        <div class="info-label">Key Signature</div>
                                        <div class="info-value" id="keySignature">No sharps or flats</div>
                                    </div>

                                    <div class="info-section">
                                        <div class="info-label">Scale Notes</div>
                                        <div class="info-value" id="scaleNotes">C D E F G A B</div>
                                    </div>

                                    <div class="info-section">
                                        <div class="info-label">Chords in Key</div>
                                        <div class="chord-list" id="chordList"></div>
                                    </div>

                                    <div class="info-section">
                                        <div class="info-label">Relative Key</div>
                                        <div class="info-value" id="relativeKey">A minor</div>
                                    </div>

                                    <div class="play-buttons">
                                        <button class="play-scale-btn" id="playScaleBtn">
                                            🔊 Play Scale
                                        </button>
                                        <button class="play-progression-btn" id="playProgressionBtn">
                                            🎵 Play I-IV-V-I
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                                <!-- Legend -->
                                <div class="legend">
                                    <h3>How to Use</h3>
                                    <p style="color: var(--text-secondary); margin-top: 0.5rem;">Click on any key in the
                                        circle to explore its scale, chords, and relationships. The outer ring shows
                                        major keys, and the inner ring shows their relative minor keys.</p>

                                    <div class="legend-grid" style="margin-top: 1.5rem;">
                                        <div class="legend-item">
                                            <div class="legend-color"
                                                style="background: linear-gradient(135deg, #6366f1, #8b5cf6);"></div>
                                            <span>Major Keys (Outer)</span>
                                        </div>
                                        <div class="legend-item">
                                            <div class="legend-color"
                                                style="background: linear-gradient(135deg, #ec4899, #db2777);"></div>
                                            <span>Minor Keys (Inner)</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- SEO Content -->
                                <section class="tool-expertise-section" style="margin-top: 4rem;">
                                    <h2>What is the Circle of Fifths?</h2>
                                    <p>The Circle of Fifths is one of the most important tools in music theory. It's a
                                        visual representation of the relationships between the 12 tones of the chromatic
                                        scale, their key signatures, and their associated major and minor keys. Moving
                                        clockwise around the circle, each key is a perfect fifth (7 semitones) higher
                                        than the previous one.</p>

                                    <h3 style="margin-top: 2rem;">Why is it Important?</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>Key Signatures:</strong> Quickly identify how many sharps or flats
                                            are in any key</li>
                                        <li><strong>Chord Progressions:</strong> Find chords that sound good together
                                        </li>
                                        <li><strong>Transposition:</strong> Easily transpose music to different keys
                                        </li>
                                        <li><strong>Composition:</strong> Discover harmonic relationships for
                                            songwriting</li>
                                        <li><strong>Improvisation:</strong> Understand which scales work over which
                                            chords</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">How to Read the Circle</h3>
                                    <p><strong>Outer Ring - Major Keys:</strong> The outer ring displays the 12 major
                                        keys. Starting at C (12 o'clock) and moving clockwise, each key adds one sharp.
                                        Moving counter-clockwise from C, each key adds one flat.</p>

                                    <p style="margin-top: 1rem;"><strong>Inner Ring - Minor Keys:</strong> The inner
                                        ring shows the relative minor keys. Each minor key shares the same key signature
                                        as its relative major (the major key directly outside it in the outer ring).</p>

                                    <p style="margin-top: 1rem;"><strong>Sharps and Flats:</strong></p>
                                    <ul style="padding-left: 1.5rem; margin-top: 0.5rem; color: var(--text-secondary);">
                                        <li>Moving clockwise: C (0♯) → G (1♯) → D (2♯) → A (3♯) → E (4♯) → B (5♯) → F♯
                                            (6♯)</li>
                                        <li>Moving counter-clockwise: C (0♭) → F (1♭) → B♭ (2♭) → E♭ (3♭) → A♭ (4♭) → D♭
                                            (5♭) → G♭ (6♭)</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Chord Progressions</h3>
                                    <p>Keys that are close together on the circle share many common notes and chords,
                                        making them sound harmonious together. Common chord progressions often use keys
                                        that are adjacent or nearby on the circle:</p>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>I-IV-V:</strong> The three major chords in any key (e.g., C-F-G in C
                                            major)</li>
                                        <li><strong>I-vi-IV-V:</strong> Classic pop progression (e.g., C-Am-F-G)</li>
                                        <li><strong>ii-V-I:</strong> Jazz progression using adjacent keys</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Relative and Parallel Keys</h3>
                                    <p><strong>Relative Keys:</strong> A major key and its relative minor share the same
                                        notes and key signature. For example, C major and A minor both have no sharps or
                                        flats. The relative minor is always 3 semitones (a minor third) below the major
                                        key.</p>

                                    <p style="margin-top: 1rem;"><strong>Parallel Keys:</strong> Parallel keys share the
                                        same root note but have different key signatures. For example, C major and C
                                        minor are parallel keys. They have the same tonic but different scales.</p>

                                    <h3 style="margin-top: 2rem;">Practical Applications</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>Songwriting:</strong> Use adjacent keys for modulation or key
                                            changes</li>
                                        <li><strong>Improvisation:</strong> Know which scales fit over chord
                                            progressions</li>
                                        <li><strong>Ear Training:</strong> Understand the sound of different key
                                            relationships</li>
                                        <li><strong>Composition:</strong> Create interesting harmonic movement</li>
                                        <li><strong>Learning Scales:</strong> Practice scales in the order of the circle
                                        </li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Tips for Using the Circle</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Start by memorizing the major keys going clockwise (C, G, D, A, E, B, F♯)
                                        </li>
                                        <li>Remember: each step clockwise adds one sharp, counter-clockwise adds one
                                            flat</li>
                                        <li>Use the circle to find common chords between keys for smooth transitions
                                        </li>
                                        <li>Practice scales in circle order to build muscle memory</li>
                                        <li>The circle works the same for all instruments - it's universal music theory
                                        </li>
                                    </ul>
                                </section>

                        </main>

                        <jsp:include page="../modern/components/related-tools.jsp">
                            <jsp:param name="currentToolUrl" value="music/circle-of-fifths.jsp" />
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
                                        src="<%=request.getContextPath()%>/music/js/circle-of-fifths.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>