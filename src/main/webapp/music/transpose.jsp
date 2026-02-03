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
                <jsp:param name="toolName" value="Free Music Transpose Tool - Change Song Key Online" />
                <jsp:param name="toolDescription"
                    value="Transpose chords and notes to any key instantly. Free online music transposition tool for musicians. Change song keys, transpose guitar chords, and convert between keys easily." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/transpose.jsp" />
                <jsp:param name="toolKeywords"
                    value="transpose music, change key, transpose chords, music transposer, chord transposer, key changer, transpose guitar, transpose piano, music key converter" />
                <jsp:param name="toolImage" value="transpose-tool.png" />
                <jsp:param name="toolFeatures"
                    value="Transpose to any key,Chord transposition,Note conversion,Up or down semitones,Capo suggestions,Instant results,Copy transposed chords,Mobile friendly,Free online tool,No download required" />
                <jsp:param name="hasSteps" value="false" />
            </jsp:include>

            <!-- Custom HowTo Schema -->
            <script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "HowTo",
              "name": "How to Transpose Music to a Different Key",
              "description": "Learn to transpose chords and notes to any key using our free online transpose tool.",
              "totalTime": "PT2M",
              "step": [
                {"@type": "HowToStep", "position": 1, "name": "Enter your chords", "text": "Paste or type your chord progression in the input box. The tool recognizes standard chord notation like C, Am, G7, Cmaj7, Dm/F, etc."},
                {"@type": "HowToStep", "position": 2, "name": "Select original key", "text": "Choose the original key of your song from the 'From Key' dropdown (C, C#, D, etc.)."},
                {"@type": "HowToStep", "position": 3, "name": "Select target key", "text": "Choose your desired key from the 'To Key' dropdown, or click a semitone button to transpose up/down by a specific interval."},
                {"@type": "HowToStep", "position": 4, "name": "View transposed chords", "text": "The transposed chords appear instantly in the output box. Check the capo suggestion if you want easier chord shapes on guitar."},
                {"@type": "HowToStep", "position": 5, "name": "Copy the result", "text": "Click the Copy button to copy the transposed chords to your clipboard."}
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
                  "name": "What does it mean to transpose music?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Transposing music means moving all the notes and chords up or down by the same interval, changing the key while keeping the relationships between notes the same. For example, transposing C-Am-F-G up by 2 semitones gives D-Bm-G-A."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Why would I need to transpose a song?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Common reasons: 1) Match a singer's vocal range, 2) Use easier chord shapes on guitar, 3) Play with a capo, 4) Match another instrument's key, 5) Avoid difficult barre chords. Transposing lets you play any song in a comfortable key."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What is a semitone?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A semitone (half step) is the smallest interval in Western music. On piano, it's the distance between any key and the very next key (including black keys). On guitar, it's one fret. There are 12 semitones in an octave. C to C# is one semitone, C to D is two semitones."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How do I use a capo with transposition?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A capo raises all strings by the number of frets it's placed on. If a song is in G but you want to play C chord shapes, put a capo on fret 5 (G is 5 semitones up from C). Our tool suggests capo positions automatically when you transpose."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What chord formats does this tool support?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The tool recognizes: major chords (C, G), minor chords (Am, Dm), seventh chords (G7, Cmaj7, Am7), extended chords (Cadd9, G6), suspended chords (Dsus4, Asus2), diminished/augmented (Bdim, Caug), and slash chords (C/G, Am/E)."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What are the easiest guitar keys to play in?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The easiest keys for guitar are C, G, D, A, and E major because they use open chord shapes. If your song has difficult chords (like Bb, Eb, Ab), transpose it to one of these keys or use a capo. For example, transpose Bb to G and use capo on fret 3."
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
                    .transpose-container {
                        max-width: 900px;
                        margin: 0 auto;
                        padding: 2rem 1rem;
                    }

                    .transpose-controls {
                        background: var(--bg-primary);
                        border-radius: 16px;
                        padding: 2rem;
                        border: 1px solid var(--border);
                        margin-bottom: 2rem;
                    }

                    .control-row {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    .control-group {
                        display: flex;
                        flex-direction: column;
                        gap: 0.5rem;
                    }

                    .control-label {
                        font-weight: 600;
                        color: var(--text-primary);
                        font-size: 0.875rem;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                    }

                    .control-select {
                        padding: 0.875rem 1rem;
                        border: 2px solid var(--border);
                        border-radius: 8px;
                        background: var(--bg-secondary);
                        color: var(--text-primary);
                        font-size: 1rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .control-select:focus {
                        outline: none;
                        border-color: var(--primary);
                    }

                    .swap-btn {
                        width: 50px;
                        height: 50px;
                        border: 2px solid var(--border);
                        background: var(--bg-secondary);
                        border-radius: 8px;
                        font-size: 1.5rem;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        color: var(--text-primary);
                    }

                    .swap-btn:hover {
                        border-color: var(--primary);
                        color: var(--primary);
                        transform: rotate(180deg);
                    }

                    .semitone-buttons {
                        display: flex;
                        gap: 0.5rem;
                        flex-wrap: wrap;
                    }

                    .semitone-btn {
                        flex: 1;
                        min-width: 60px;
                        padding: 0.75rem;
                        border: 2px solid var(--border);
                        background: var(--bg-secondary);
                        color: var(--text-primary);
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .semitone-btn:hover {
                        border-color: var(--primary);
                        color: var(--primary);
                    }

                    .semitone-btn.active {
                        background: var(--primary);
                        color: white;
                        border-color: var(--primary);
                    }

                    .input-section,
                    .output-section {
                        background: var(--bg-primary);
                        border-radius: 16px;
                        padding: 2rem;
                        border: 1px solid var(--border);
                        margin-bottom: 2rem;
                    }

                    .section-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 1rem;
                    }

                    .section-title {
                        font-size: 1.25rem;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .copy-btn {
                        padding: 0.5rem 1rem;
                        background: var(--primary);
                        color: white;
                        border: none;
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .copy-btn:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
                    }

                    .chord-textarea {
                        width: 100%;
                        min-height: 200px;
                        padding: 1rem;
                        border: 2px solid var(--border);
                        border-radius: 8px;
                        background: var(--bg-secondary);
                        color: var(--text-primary);
                        font-family: 'Courier New', monospace;
                        font-size: 1rem;
                        line-height: 1.8;
                        resize: vertical;
                    }

                    .chord-textarea:focus {
                        outline: none;
                        border-color: var(--primary);
                    }

                    .output-textarea {
                        background: var(--bg-secondary);
                        cursor: text;
                    }

                    .capo-suggestion {
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        color: white;
                        padding: 1rem 1.5rem;
                        border-radius: 12px;
                        margin-top: 1rem;
                        text-align: center;
                        font-weight: 600;
                    }

                    .quick-examples {
                        margin-top: 2rem;
                    }

                    .example-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                        gap: 1rem;
                        margin-top: 1rem;
                    }

                    .example-card {
                        background: var(--bg-secondary);
                        border: 1px solid var(--border);
                        border-radius: 12px;
                        padding: 1rem;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .example-card:hover {
                        border-color: var(--primary);
                        transform: translateY(-2px);
                    }

                    .example-title {
                        font-weight: 600;
                        color: var(--text-primary);
                        margin-bottom: 0.5rem;
                    }

                    .example-chords {
                        font-family: 'Courier New', monospace;
                        color: var(--text-secondary);
                        font-size: 0.875rem;
                    }

                    @media (max-width: 768px) {
                        .transpose-container {
                            padding: 1rem 0.5rem;
                        }

                        .transpose-controls,
                        .input-section,
                        .output-section {
                            padding: 1.5rem 1rem;
                        }

                        .control-row {
                            grid-template-columns: 1fr;
                            gap: 1rem;
                        }

                        .semitone-buttons {
                            gap: 0.25rem;
                        }

                        .semitone-btn {
                            min-width: 50px;
                            padding: 0.5rem;
                            font-size: 0.875rem;
                        }

                        .section-header {
                            flex-direction: column;
                            align-items: flex-start;
                            gap: 0.75rem;
                        }

                        .copy-btn {
                            width: 100%;
                        }

                        .chord-textarea {
                            font-size: 0.875rem;
                            min-height: 150px;
                        }

                        .example-grid {
                            grid-template-columns: 1fr;
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
                                <h1 class="tool-page-title">Music Transpose Tool</h1>
                                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Change
                                    the key of any song instantly - transpose chords and notes</p>
                                <nav class="tool-breadcrumbs">
                                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                    <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                    Transpose
                                </nav>
                            </div>
                        </div>
                    </header>

                    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                        <main class="transpose-container">

                            <!-- Controls -->
                            <div class="transpose-controls">
                                <div class="control-row">
                                    <div class="control-group">
                                        <label class="control-label">From Key</label>
                                        <select class="control-select" id="fromKey">
                                            <option value="C">C</option>
                                            <option value="C#">C# / Db</option>
                                            <option value="D">D</option>
                                            <option value="D#">D# / Eb</option>
                                            <option value="E">E</option>
                                            <option value="F">F</option>
                                            <option value="F#">F# / Gb</option>
                                            <option value="G">G</option>
                                            <option value="G#">G# / Ab</option>
                                            <option value="A">A</option>
                                            <option value="A#">A# / Bb</option>
                                            <option value="B">B</option>
                                        </select>
                                    </div>

                                    <div class="control-group" style="display: flex; align-items: flex-end;">
                                        <button class="swap-btn" id="swapKeys" title="Swap keys">⇄</button>
                                    </div>

                                    <div class="control-group">
                                        <label class="control-label">To Key</label>
                                        <select class="control-select" id="toKey">
                                            <option value="C">C</option>
                                            <option value="C#">C# / Db</option>
                                            <option value="D">D</option>
                                            <option value="D#">D# / Eb</option>
                                            <option value="E">E</option>
                                            <option value="F">F</option>
                                            <option value="F#">F# / Gb</option>
                                            <option value="G" selected>G</option>
                                            <option value="G#">G# / Ab</option>
                                            <option value="A">A</option>
                                            <option value="A#">A# / Bb</option>
                                            <option value="B">B</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="control-group">
                                    <label class="control-label">Or Transpose by Semitones</label>
                                    <div class="semitone-buttons">
                                        <button class="semitone-btn" data-semitones="-12">-12</button>
                                        <button class="semitone-btn" data-semitones="-7">-7</button>
                                        <button class="semitone-btn" data-semitones="-5">-5</button>
                                        <button class="semitone-btn" data-semitones="-3">-3</button>
                                        <button class="semitone-btn" data-semitones="-1">-1</button>
                                        <button class="semitone-btn" data-semitones="0">0</button>
                                        <button class="semitone-btn" data-semitones="+1">+1</button>
                                        <button class="semitone-btn" data-semitones="+3">+3</button>
                                        <button class="semitone-btn" data-semitones="+5">+5</button>
                                        <button class="semitone-btn" data-semitones="+7">+7</button>
                                        <button class="semitone-btn" data-semitones="+12">+12</button>
                                    </div>
                                </div>

                                <div id="capoSuggestion" class="capo-suggestion" style="display: none;"></div>
                            </div>

                            <!-- Input -->
                            <div class="input-section">
                                <div class="section-header">
                                    <h2 class="section-title">Original Chords</h2>
                                </div>
                                <textarea class="chord-textarea" id="inputChords"
                                    placeholder="Paste your chords here...&#10;&#10;Example:&#10;C  Am  F  G&#10;Dm  G  C  C7&#10;&#10;Or enter full lyrics with chords above words"></textarea>
                            </div>

                            <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                                <!-- Output -->
                                <div class="output-section">
                                    <div class="section-header">
                                        <h2 class="section-title">Transposed Chords</h2>
                                        <button class="copy-btn" id="copyBtn">📋 Copy</button>
                                    </div>
                                    <textarea class="chord-textarea output-textarea" id="outputChords" readonly
                                        placeholder="Transposed chords will appear here..."></textarea>
                                </div>

                                <!-- Quick Examples -->
                                <div class="quick-examples">
                                    <h3>Quick Examples</h3>
                                    <div class="example-grid">
                                        <div class="example-card" data-example="C Am F G">
                                            <div class="example-title">Pop Progression</div>
                                            <div class="example-chords">C - Am - F - G</div>
                                        </div>
                                        <div class="example-card" data-example="G D Em C">
                                            <div class="example-title">Classic Rock</div>
                                            <div class="example-chords">G - D - Em - C</div>
                                        </div>
                                        <div class="example-card" data-example="Am F C G">
                                            <div class="example-title">Sad Ballad</div>
                                            <div class="example-chords">Am - F - C - G</div>
                                        </div>
                                        <div class="example-card" data-example="D A Bm G">
                                            <div class="example-title">Country</div>
                                            <div class="example-chords">D - A - Bm - G</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- SEO Content -->
                                <section class="tool-expertise-section" style="margin-top: 4rem;">
                                    <h2>What is Music Transposition?</h2>
                                    <p>Transposition is the process of moving a piece of music from one key to another.
                                        When you transpose music, you shift all the notes and chords up or down by the
                                        same interval, maintaining the relationships between notes while changing the
                                        overall pitch.</p>

                                    <h3 style="margin-top: 2rem;">Why Transpose Music?</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>Vocal Range:</strong> Match the song to a singer's comfortable range
                                        </li>
                                        <li><strong>Instrument Limitations:</strong> Adapt music for different
                                            instruments</li>
                                        <li><strong>Easier Chords:</strong> Change to a key with simpler chord shapes
                                        </li>
                                        <li><strong>Capo Use:</strong> Find keys that work well with a guitar capo</li>
                                        <li><strong>Collaboration:</strong> Match keys when playing with other musicians
                                        </li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">How to Use the Transpose Tool</h3>
                                    <ol
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Enter or paste your chords in the input box</li>
                                        <li>Select the original key (From Key)</li>
                                        <li>Select the target key (To Key)</li>
                                        <li>Or click a semitone button to transpose up/down</li>
                                        <li>The transposed chords appear instantly in the output box</li>
                                        <li>Click Copy to copy the transposed chords</li>
                                    </ol>

                                    <h3 style="margin-top: 2rem;">Understanding Semitones</h3>
                                    <p>A semitone (also called a half-step) is the smallest interval in Western music.
                                        On a piano, it's the distance from one key to the very next key (including black
                                        keys). On a guitar, it's one fret. Here are common transposition intervals:</p>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>+1 semitone:</strong> One half-step up (e.g., C to C#)</li>
                                        <li><strong>+3 semitones:</strong> Minor third up (e.g., C to Eb)</li>
                                        <li><strong>+5 semitones:</strong> Perfect fourth up (e.g., C to F)</li>
                                        <li><strong>+7 semitones:</strong> Perfect fifth up (e.g., C to G)</li>
                                        <li><strong>+12 semitones:</strong> One octave up (same note, higher)</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Capo and Transposition</h3>
                                    <p>A capo is a device that clamps across the guitar neck to raise the pitch. Using a
                                        capo is a form of transposition. For example, if you place a capo on the 2nd
                                        fret and play a C chord shape, you're actually playing a D chord. This tool can
                                        suggest capo positions for easier chord shapes.</p>

                                    <h3 style="margin-top: 2rem;">Tips for Transposing</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Transpose to keys with fewer sharps/flats for easier reading</li>
                                        <li>For guitar, keys like G, C, D, A, and E often have easier chord shapes</li>
                                        <li>When transposing for vocals, move in small steps (1-2 semitones) to find the
                                            sweet spot</li>
                                        <li>Remember that transposing changes the feel of a song - some keys sound
                                            brighter or darker</li>
                                    </ul>
                                </section>

                        </main>

                        <jsp:include page="../modern/components/related-tools.jsp">
                            <jsp:param name="currentToolUrl" value="music/transpose.jsp" />
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
                                    <script
                                        src="<%=request.getContextPath()%>/music/js/transpose.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>