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
                <jsp:param name="toolName" value="Free Virtual Piano - Play Piano Online with Keyboard" />
                <jsp:param name="toolDescription"
                    value="Play piano online for free! Interactive virtual piano with 88 keys, multiple instruments, recording, MIDI support, and keyboard controls. Perfect for beginners and musicians." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/virtual-piano.jsp" />
                <jsp:param name="toolKeywords"
                    value="virtual piano, online piano, play piano online, piano keyboard, free piano, virtual keyboard, piano simulator, learn piano, piano practice, midi piano" />
                <jsp:param name="toolImage" value="virtual-piano.png" />
                <jsp:param name="toolFeatures"
                    value="88 piano keys,Learn popular songs,Song tutorials,Keyboard controls,Multiple instruments,Recording feature,Download recordings,Playback,MIDI support,Sustain pedal,Volume control,Mobile friendly,Free online piano,Interactive learning" />
            </jsp:include>

            <!-- Fonts & CSS -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap">

            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">



            <style>
                .piano-container {
                    max-width: 1400px;
                    margin: 0 auto;
                    padding: 2rem 1rem;
                }

                .piano-controls {
                    background: var(--bg-primary);
                    border-radius: 16px;
                    padding: 1.5rem;
                    border: 1px solid var(--border);
                    margin-bottom: 2rem;
                    display: flex;
                    flex-wrap: wrap;
                    gap: 1rem;
                    align-items: center;
                    justify-content: space-between;
                }

                .control-group {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                }

                .control-label {
                    font-weight: 600;
                    color: var(--text-secondary);
                    font-size: 0.875rem;
                }

                .control-select,
                .control-input {
                    padding: 0.5rem 1rem;
                    border: 2px solid var(--border);
                    border-radius: 8px;
                    background: var(--bg-secondary);
                    color: var(--text-primary);
                    font-weight: 600;
                    cursor: pointer;
                }

                .control-btn {
                    padding: 0.625rem 1.25rem;
                    border: 2px solid var(--border);
                    background: var(--bg-primary);
                    color: var(--text-primary);
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .control-btn:hover {
                    border-color: var(--primary);
                    color: var(--primary);
                }

                .control-btn.recording {
                    background: #ef4444;
                    color: white;
                    border-color: #ef4444;
                }

                .piano-wrapper {
                    background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
                    border-radius: 20px;
                    padding: 3rem 2rem;
                    box-shadow: 0 20px 60px -10px rgba(0, 0, 0, 0.3);
                    overflow-x: auto;
                    margin-bottom: 2rem;
                }

                .piano-keyboard {
                    display: flex;
                    position: relative;
                    min-width: 1200px;
                    height: 300px;
                    margin: 0 auto;
                    user-select: none;
                }

                .piano-key {
                    position: relative;
                    cursor: pointer;
                    transition: all 0.05s ease;
                }

                .white-key {
                    width: 60px;
                    height: 300px;
                    background: linear-gradient(to bottom, #ffffff 0%, #f5f5f5 100%);
                    border: 2px solid #333;
                    border-radius: 0 0 8px 8px;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                }

                .white-key:hover {
                    background: linear-gradient(to bottom, #f0f0f0 0%, #e5e5e5 100%);
                }

                .white-key.active {
                    background: linear-gradient(to bottom, #6366f1 0%, #4f46e5 100%);
                    transform: translateY(2px);
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
                }

                .black-key {
                    position: absolute;
                    width: 40px;
                    height: 180px;
                    background: linear-gradient(to bottom, #1a1a1a 0%, #000000 100%);
                    border: 2px solid #000;
                    border-radius: 0 0 6px 6px;
                    z-index: 2;
                    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.5);
                }

                .black-key:hover {
                    background: linear-gradient(to bottom, #2a2a2a 0%, #1a1a1a 100%);
                }

                .black-key.active {
                    background: linear-gradient(to bottom, #8b5cf6 0%, #7c3aed 100%);
                    transform: translateY(2px);
                    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.4);
                }

                .key-label {
                    position: absolute;
                    bottom: 10px;
                    left: 50%;
                    transform: translateX(-50%);
                    font-size: 0.75rem;
                    font-weight: 600;
                    color: #666;
                    pointer-events: none;
                }

                .black-key .key-label {
                    color: #999;
                    bottom: 8px;
                }

                .keyboard-shortcuts {
                    background: var(--bg-secondary);
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-top: 2rem;
                }

                .shortcuts-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1rem;
                    margin-top: 1rem;
                }

                .shortcut-item {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                }

                .shortcut-key {
                    background: var(--bg-primary);
                    border: 2px solid var(--border);
                    border-radius: 6px;
                    padding: 0.25rem 0.5rem;
                    font-family: 'Courier New', monospace;
                    font-weight: 700;
                    min-width: 30px;
                    text-align: center;
                }

                .shortcut-desc {
                    color: var(--text-secondary);
                    font-size: 0.875rem;
                }

                @media (max-width: 768px) {
                    .piano-wrapper {
                        padding: 1.5rem 1rem;
                    }

                    .piano-keyboard {
                        min-width: 800px;
                    }

                    .white-key {
                        width: 40px;
                        height: 200px;
                    }

                    .black-key {
                        width: 28px;
                        height: 120px;
                    }
                }

                .learn-songs-section {
                    background: var(--bg-primary);
                    border-radius: 16px;
                    padding: 2rem;
                    border: 1px solid var(--border);
                    margin-bottom: 2rem;
                }

                .songs-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 1rem;
                    margin-top: 1rem;
                }

                .song-card {
                    background: var(--bg-secondary);
                    border: 2px solid var(--border);
                    border-radius: 12px;
                    padding: 1.5rem;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .song-card:hover {
                    border-color: var(--primary);
                    transform: translateY(-2px);
                }

                .song-card.active {
                    border-color: #10b981;
                    background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(5, 150, 105, 0.05));
                }

                .song-title {
                    font-weight: 700;
                    color: var(--text-primary);
                    margin-bottom: 0.5rem;
                    font-size: 1.125rem;
                }

                .song-difficulty {
                    display: inline-block;
                    padding: 0.25rem 0.75rem;
                    border-radius: 6px;
                    font-size: 0.75rem;
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                }

                .difficulty-easy {
                    background: #10b981;
                    color: white;
                }

                .difficulty-medium {
                    background: #f59e0b;
                    color: white;
                }

                .song-notes {
                    font-family: 'Courier New', monospace;
                    color: var(--text-secondary);
                    font-size: 0.875rem;
                    margin-top: 0.5rem;
                }

                .highlight-key {
                    animation: highlightPulse 1s ease-in-out infinite;
                }

                @keyframes highlightPulse {

                    0%,
                    100% {
                        box-shadow: 0 0 20px rgba(16, 185, 129, 0.6);
                    }

                    50% {
                        box-shadow: 0 0 30px rgba(16, 185, 129, 0.9);
                    }
                }

                .keyboard-guide {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translateX(-50%);
                    font-size: 0.7rem;
                    font-weight: 700;
                    color: #6366f1;
                    background: rgba(255, 255, 255, 0.9);
                    padding: 0.15rem 0.35rem;
                    border-radius: 4px;
                    pointer-events: none;
                    opacity: 0;
                    transition: opacity 0.3s ease;
                }

                .show-keyboard-guide .keyboard-guide {
                    opacity: 1;
                }

                .black-key .keyboard-guide {
                    background: rgba(255, 255, 255, 0.95);
                    top: 30%;
                }

                .key-label {
                    opacity: 1;
                    transition: opacity 0.3s ease;
                }

                .hide-labels .key-label {
                    opacity: 0;
                }
            </style>

            <%@ include file="../modern/ads/ad-init.jsp" %>
        </head>

        <body>
            <%@ include file="../modern/components/nav-header.jsp" %>

                <header class="tool-page-header">
                    <div class="tool-page-header-inner">
                        <div>
                            <h1 class="tool-page-title">Virtual Piano</h1>
                            <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Play
                                piano online with your keyboard or mouse - 88 keys, multiple instruments</p>
                            <nav class="tool-breadcrumbs">
                                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                Virtual Piano
                            </nav>
                        </div>
                    </div>
                </header>

                <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                <main class="piano-container">

                    <!-- Controls -->
                    <div class="piano-controls">
                        <div class="control-group">
                            <label class="control-label">Instrument:</label>
                            <select class="control-select" id="instrumentSelect">
                                <option value="piano">Piano</option>
                                <option value="electric-piano">Electric Piano</option>
                                <option value="synth">Synth</option>
                                <option value="organ">Organ</option>
                                <option value="guitar">Guitar</option>
                                <option value="strings">Strings</option>
                                <option value="brass">Brass</option>
                                <option value="bass">Bass</option>
                                <option value="harpsichord">Harpsichord</option>
                            </select>
                        </div>

                        <div class="control-group">
                            <label class="control-label">Octave:</label>
                            <select class="control-select" id="octaveSelect">
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4" selected>4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                            </select>
                        </div>

                        <div class="control-group">
                            <label class="control-label">Reverb:</label>
                            <input type="range" class="control-input" id="reverbSlider" min="0" max="100" value="0"
                                style="width: 100px;">
                            <span id="reverbValue" style="min-width: 40px; font-weight: 600;">0%</span>
                        </div>

                        <div class="control-group">
                            <label class="control-label">Volume:</label>
                            <input type="range" class="control-input" id="volumeSlider" min="0" max="100" value="70"
                                style="width: 100px;">
                            <span id="volumeValue" style="min-width: 40px; font-weight: 600;">70%</span>
                        </div>

                        <div class="control-group">
                            <button class="control-btn" id="recordBtn">
                                <span>⏺️</span>
                                <span>Record</span>
                            </button>
                            <button class="control-btn" id="playBtn" style="display: none;">
                                <span>▶️</span>
                                <span>Play</span>
                            </button>
                            <button class="control-btn" id="clearBtn" style="display: none;">
                                <span>🗑️</span>
                                <span>Clear</span>
                            </button>
                            <button class="control-btn" id="downloadBtn" style="display: none;">
                                <span>💾</span>
                                <span>Download</span>
                            </button>
                        </div>

                        <div class="control-group">
                            <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="checkbox" id="sustainCheckbox">
                                <span class="control-label" style="margin: 0;">Sustain</span>
                            </label>
                            <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="checkbox" id="labelsCheckbox" checked>
                                <span class="control-label" style="margin: 0;">Labels</span>
                            </label>
                            <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="checkbox" id="keyboardGuideCheckbox">
                                <span class="control-label" style="margin: 0;">Keyboard Guide</span>
                            </label>
                        </div>
                    </div>

                    <!-- Piano Keyboard -->
                    <div class="piano-wrapper">
                        <div class="piano-keyboard" id="pianoKeyboard"></div>
                    </div>

                    <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                    <!-- Learn Songs Section -->
                    <div class="learn-songs-section">
                        <h3>🎵 Learn Popular Songs</h3>
                        <p style="color: var(--text-secondary); margin-top: 0.5rem;">Click a song to see
                            highlighted keys and learn to play!</p>
                        <div class="songs-grid">
                            <div class="song-card" data-song="happy-birthday">
                                <div class="song-title">Happy Birthday</div>
                                <span class="song-difficulty difficulty-easy">Easy</span>
                                <div class="song-notes">C C D C F E...</div>
                            </div>
                            <div class="song-card" data-song="twinkle">
                                <div class="song-title">Twinkle Twinkle</div>
                                <span class="song-difficulty difficulty-easy">Easy</span>
                                <div class="song-notes">C C G G A A G...</div>
                            </div>
                            <div class="song-card" data-song="mary-lamb">
                                <div class="song-title">Mary Had a Little Lamb</div>
                                <span class="song-difficulty difficulty-easy">Easy</span>
                                <div class="song-notes">E D C D E E E...</div>
                            </div>
                            <div class="song-card" data-song="jingle-bells">
                                <div class="song-title">Jingle Bells</div>
                                <span class="song-difficulty difficulty-medium">Medium</span>
                                <div class="song-notes">E E E E E E E G C D E...</div>
                            </div>
                            <div class="song-card" data-song="fur-elise">
                                <div class="song-title">Für Elise (Intro)</div>
                                <span class="song-difficulty difficulty-medium">Medium</span>
                                <div class="song-notes">E D# E D# E B D C A...</div>
                            </div>
                            <div class="song-card" data-song="ode-to-joy">
                                <div class="song-title">Ode to Joy</div>
                                <span class="song-difficulty difficulty-easy">Easy</span>
                                <div class="song-notes">E E F G G F E D...</div>
                            </div>
                        </div>
                    </div>



                    <!-- Keyboard Shortcuts -->
                    <div class="keyboard-shortcuts">
                        <h3>Keyboard Shortcuts</h3>
                        <div class="shortcuts-grid">
                            <div class="shortcut-item">
                                <span class="shortcut-key">A-K</span>
                                <span class="shortcut-desc">Play white keys</span>
                            </div>
                            <div class="shortcut-item">
                                <span class="shortcut-key">W E T Y U</span>
                                <span class="shortcut-desc">Play black keys</span>
                            </div>
                            <div class="shortcut-item">
                                <span class="shortcut-key">Z X</span>
                                <span class="shortcut-desc">Octave down/up</span>
                            </div>
                            <div class="shortcut-item">
                                <span class="shortcut-key">Space</span>
                                <span class="shortcut-desc">Sustain pedal</span>
                            </div>
                        </div>
                    </div>

                    <!-- SEO Content -->
                    <section class="tool-expertise-section" style="margin-top: 4rem;">
                        <h2>Free Virtual Piano - Play Online</h2>
                        <p>Welcome to our free virtual piano! Play piano online using your computer keyboard
                            or mouse. This interactive piano simulator features 88 keys, multiple instrument
                            sounds, recording capabilities, and full keyboard control support. Perfect for
                            beginners learning piano, musicians practicing on the go, or anyone who wants to
                            make music without a physical instrument.</p>

                        <h3 style="margin-top: 2rem;">Features</h3>
                        <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                            <li><strong>88 Piano Keys:</strong> Full-size piano keyboard with all notes</li>
                            <li><strong>Learn Popular Songs:</strong> Interactive tutorials for Happy
                                Birthday, Twinkle Twinkle, Für Elise, and more with highlighted keys</li>
                            <li><strong>Download Recordings:</strong> Save your performances as text files
                                for later reference</li>
                            <li><strong>Multiple Instruments:</strong> Piano, synth, organ, and guitar
                                sounds</li>
                            <li><strong>Keyboard Controls:</strong> Play using your computer keyboard (A-K
                                for white keys, W-E-T-Y-U for black keys)</li>
                            <li><strong>Recording:</strong> Record your performance and play it back</li>
                            <li><strong>Sustain Pedal:</strong> Hold the spacebar for sustained notes</li>
                            <li><strong>Octave Switching:</strong> Change octaves with Z/X keys or dropdown
                            </li>
                            <li><strong>Volume Control:</strong> Adjust playback volume</li>
                            <li><strong>Mobile Friendly:</strong> Works on tablets and touch devices</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Learn Songs</h3>
                        <p>Our new interactive song learning feature makes it easy to learn popular
                            melodies! Simply click on any song card below the piano, and watch as the keys
                            light up to show you which notes to play. The piano will automatically play
                            through the song, highlighting each note in sequence. Perfect for beginners who
                            want to learn:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                            <li><strong>Happy Birthday:</strong> The classic birthday song everyone knows
                            </li>
                            <li><strong>Twinkle Twinkle Little Star:</strong> A perfect first song for
                                beginners</li>
                            <li><strong>Mary Had a Little Lamb:</strong> Simple and memorable melody</li>
                            <li><strong>Jingle Bells:</strong> Festive holiday favorite</li>
                            <li><strong>Für Elise:</strong> Beethoven's famous piano piece (intro)</li>
                            <li><strong>Ode to Joy:</strong> Beautiful classical melody</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">How to Play</h3>
                        <ol style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                            <li><strong>Mouse:</strong> Click on any key to play a note</li>
                            <li><strong>Keyboard:</strong> Use keys A through K to play white keys (C to C)
                            </li>
                            <li><strong>Black Keys:</strong> Use W, E, T, Y, U for the black keys
                                (sharps/flats)</li>
                            <li><strong>Change Octave:</strong> Press Z to go down an octave, X to go up
                            </li>
                            <li><strong>Sustain:</strong> Hold the spacebar while playing for sustained
                                notes</li>
                            <li><strong>Record:</strong> Click Record, play your melody, then click Stop and
                                Play to hear it back</li>
                        </ol>

                        <h3 style="margin-top: 2rem;">Learning Piano Online</h3>
                        <p>Our virtual piano is an excellent tool for beginners learning piano basics:</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                            <li>Practice finger placement and hand position</li>
                            <li>Learn note names and keyboard layout</li>
                            <li>Experiment with melodies and chords</li>
                            <li>Develop ear training by playing songs by ear</li>
                            <li>Practice anywhere without needing a physical piano</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Piano Keyboard Layout</h3>
                        <p>The piano keyboard follows a repeating pattern of 12 notes (7 white keys and 5
                            black keys per octave):</p>
                        <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                            <li><strong>White Keys:</strong> C, D, E, F, G, A, B (natural notes)</li>
                            <li><strong>Black Keys:</strong> C#/Db, D#/Eb, F#/Gb, G#/Ab, A#/Bb (sharps and
                                flats)</li>
                            <li><strong>Middle C:</strong> The C note in the middle of the keyboard (C4)
                            </li>
                            <li><strong>Octaves:</strong> Each set of 12 notes is called an octave</li>
                        </ul>

                        <h3 style="margin-top: 2rem;">Tips for Playing</h3>
                        <ul style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                            <li>Start with simple melodies like "Mary Had a Little Lamb" or "Twinkle
                                Twinkle"</li>
                            <li>Practice scales to build muscle memory (C major: C D E F G A B C)</li>
                            <li>Use the recording feature to track your progress</li>
                            <li>Experiment with different instruments to find sounds you like</li>
                            <li>Practice regularly, even just 10-15 minutes a day makes a difference</li>
                        </ul>
                    </section>

                </main>

                <jsp:include page="../modern/components/related-tools.jsp">
                    <jsp:param name="currentToolUrl" value="music/virtual-piano.jsp" />
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
                        <script src="https://cdn.jsdelivr.net/npm/tone@14.7.77/build/Tone.js"></script>
                        <script
                            src="<%=request.getContextPath()%>/music/js/virtual-piano.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>