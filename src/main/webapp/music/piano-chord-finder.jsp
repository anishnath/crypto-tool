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

            <!-- Resource Hints -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

            <!-- Critical CSS -->
            <style>
                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0
                }

                html {
                    scroll-behavior: smooth;
                    -webkit-text-size-adjust: 100%;
                    -webkit-font-smoothing: antialiased
                }

                body {
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    font-size: 1rem;
                    line-height: 1.5;
                    color: #0f172a;
                    background: #f8fafc;
                    margin: 0
                }

                :root {
                    --primary: #667eea;
                    --primary-dark: #5a67d8;
                    --bg-primary: #fff;
                    --bg-secondary: #f8fafc;
                    --text-primary: #0f172a;
                    --text-secondary: #475569;
                    --border: #e2e8f0
                }
            </style>

            <!-- SEO -->
            <jsp:include page="../modern/components/seo-tool-page.jsp">
                <jsp:param name="toolName" value="Interactive Piano Chord Finder Online (Free + MIDI Support)" />
                <jsp:param name="toolDescription"
                    value="Instantly find any piano chord with our free interactive tool. Connect your MIDI keyboard, hear realistic audio, and learn proper fingering and inversions. The ultimate online piano companion." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/piano-chord-finder.jsp" />
                <jsp:param name="toolKeywords"
                    value="piano chord finder, midi piano online, interactive piano chart, piano chords for beginners, piano fingering guide, chord inversions, online keyboard tool" />
                <jsp:param name="toolImage" value="piano-chord-tool.png" />
                <jsp:param name="toolFeatures"
                    value="100+ piano chord shapes with proper fingering,Major Minor 7th Maj7 m7 Dim Aug Sus Add9 chords,Interactive piano keyboard with 3 octaves,Audio playback with realistic piano sound,Chord inversions (root 1st 2nd 3rd position),Left and right hand fingering guides,Chord progressions database for popular songs,Sharp and flat chords included,Beginner to advanced difficulty ratings,Keyboard shortcuts for quick access" />
                <jsp:param name="hasSteps" value="false" />
            </jsp:include>

            <!-- Fonts -->
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"
                media="print" onload="this.media='all'">
            <noscript>
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap">
            </noscript>

            <!-- CSS -->
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/music/css/piano-chord-finder.css?v=<%=cacheVersion%>">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style"
                onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <noscript>
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
            </noscript>

            <%@ include file="../modern/ads/ad-init.jsp" %>
        </head>

        <body>
            <!-- Navigation -->
            <%@ include file="../modern/components/nav-header.jsp" %>

                <!-- Page Header -->
                <header class="tool-page-header">
                    <div class="tool-page-header-inner">
                        <div>
                            <h1 class="tool-page-title">Interactive Piano Chord Finder & Free Chart</h1>
                            <nav class="tool-breadcrumbs">
                                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                Piano Chord Chart
                            </nav>
                        </div>
                        <div class="tool-page-badges">
                            <span class="tool-badge">100+ Chords</span>
                            <span class="tool-badge">Inversions</span>
                            <span class="tool-badge">Fingering Guides</span>
                        </div>
                    </div>
                </header>

                <!-- Tool Description -->
                <section class="tool-description-section">
                    <div class="tool-description-inner">
                        <div class="tool-description-content">
                            <p><strong>Master piano chords instantly.</strong> This isn't just a chart – it's a fully
                                interactive learning tool. <strong>Connect your MIDI keyboard</strong> to see your keys
                                light up on screen, or use the realistic audio engine to hear complex jazz voicings.
                                With support for inversions, left/right hand fingering, and popular progressions, it's
                                the perfect companion for pianists of all levels.</p>
                        </div>
                    </div>
                </section>

                <!-- Main Tool Area -->
                <main class="piano-tool-container">
                    <!-- Left Column: Controls -->
                    <div class="piano-control-panel">
                        <!-- Search Section -->
                        <div class="chord-search-card">
                            <div class="chord-search-input">
                                <input type="text" id="chordInput" placeholder="Search chord: Am, C7, Dmaj7..."
                                    autocomplete="off">
                                <button onclick="searchChord()">
                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                        <path
                                            d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z" />
                                    </svg>
                                </button>
                            </div>

                            <!-- Quick Access Chords -->
                            <div class="quick-access-section">
                                <strong>Popular Chords</strong>
                                <div class="quick-chords-grid" id="quickChords"></div>
                            </div>

                            <!-- Chord Type Selector -->
                            <div class="quick-access-section">
                                <strong>Chord Types</strong>
                                <div class="chord-type-selector" id="chordTypes"></div>
                            </div>
                        </div>

                        <!-- Inversion Selector -->
                        <div class="inversion-card">
                            <div class="inversion-header">
                                <strong>Chord Inversion</strong>
                                <span id="inversionLabel">Root Position</span>
                            </div>
                            <div class="inversion-buttons" id="inversionButtons">
                                <button class="inversion-btn active" data-inversion="0"
                                    onclick="changeInversion(0)">Root</button>
                                <button class="inversion-btn" data-inversion="1"
                                    onclick="changeInversion(1)">1st</button>
                                <button class="inversion-btn" data-inversion="2"
                                    onclick="changeInversion(2)">2nd</button>
                                <button class="inversion-btn" data-inversion="3" onclick="changeInversion(3)"
                                    style="display: none;">3rd</button>
                            </div>
                            <small class="inversion-hint">Inversions change which note is on the bottom</small>
                        </div>

                        <!-- Hand Selector -->
                        <div class="hand-selector-card">
                            <strong>Fingering Hand</strong>
                            <div class="hand-buttons">
                                <button class="hand-btn active" data-hand="rh" onclick="selectHand('rh')">
                                    <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                                        <path
                                            d="M8.5 1.75a.75.75 0 0 1 .75.75V6h3.5a.75.75 0 0 1 0 1.5h-3.5v6a.75.75 0 0 1-1.5 0v-6H4.25a.75.75 0 0 1 0-1.5h3.5V2.5a.75.75 0 0 1 .75-.75z" />
                                    </svg>
                                    Right Hand
                                </button>
                                <button class="hand-btn" data-hand="lh" onclick="selectHand('lh')">
                                    <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                                        <path
                                            d="M7.5 1.75a.75.75 0 0 0-.75.75V6H3.25a.75.75 0 0 0 0 1.5h3.5v6a.75.75 0 0 0 1.5 0v-6h3.5a.75.75 0 0 0 0-1.5h-3.5V2.5a.75.75 0 0 0-.75-.75z" />
                                    </svg>
                                    Left Hand
                                </button>
                            </div>
                        </div>

                        <!-- Settings/Options Panel -->
                        <div class="settings-panel">
                            <div class="settings-header">
                                <strong>Options</strong>
                                <small class="keyboard-hint">Keys: A-G, Shift=minor, Space=play, 0-3=inversions</small>
                            </div>
                            <div class="settings-toggles">
                                <label class="setting-toggle" title="Play notes one at a time (P)">
                                    <input type="checkbox" id="arpeggioToggle" onchange="toggleArpeggio()">
                                    <span>Arpeggio</span>
                                </label>
                                <label class="setting-toggle" title="Enable/disable sound (M)">
                                    <input type="checkbox" id="soundToggle" onchange="toggleSound()" checked>
                                    <span>Sound</span>
                                </label>
                            </div>
                            <!-- MIDI Status -->
                            <div class="midi-status-container" id="midiStatusContainer"
                                style="display: none; margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border);">
                                <div class="midi-status-header"
                                    style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 4px;">
                                    <span style="font-size: 0.9rem; font-weight: 500;">MIDI Input</span>
                                    <span class="status-badge" id="midiStatusBadge"
                                        style="font-size: 0.7rem; padding: 2px 6px; border-radius: 4px; background: #e2e8f0; color: #64748b;">Not
                                        Connected</span>
                                </div>
                                <small style="color: var(--text-secondary); font-size: 0.75rem;">Play keys on your real
                                    keyboard to see them light up!</small>
                            </div>
                        </div>

                        <!-- View Favorites Button -->
                        <div class="favorites-section">
                            <button class="favorites-btn" onclick="openFavoritesManager()"
                                title="View your saved favorite chords">
                                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16"
                                    style="margin-right: 0.375rem;">
                                    <path
                                        d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z" />
                                </svg>
                                View Favorites
                            </button>
                        </div>

                        <!-- In-content Ad for Desktop -->
                        <div class="tool-desktop-ad-container" style="margin-top: 1rem;">
                            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
                        </div>
                    </div>

                    <!-- Right Column: Piano Display -->
                    <div class="piano-display-panel">
                        <!-- Welcome Instructions (shown initially) -->
                        <div class="chord-display-card" id="welcomeInstructions">
                            <div class="welcome-section">
                                <h4>Learn Piano Chords - Start Here!</h4>
                                <p>Click on a chord or search to see the keys to press and hear how it sounds</p>
                                <div class="welcome-tip">
                                    <strong>New to piano?</strong> Start with <strong>"C"</strong> or
                                    <strong>"Am"</strong> - these are the easiest beginner chords!
                                    <br><small style="margin-top: 0.5rem; display: block;">Use <strong>keyboard
                                            shortcuts</strong> (A-G keys) for quick access. Press <strong>0-3</strong>
                                        for inversions.</small>
                                </div>
                            </div>
                        </div>

                        <!-- Chord Display -->
                        <div class="chord-display-card" id="chordDisplay" style="display: none;">
                            <!-- Chord Header with Play Button -->
                            <div class="chord-header">
                                <div class="chord-info-box">
                                    <div class="chord-title-row">
                                        <h3 id="chordName">C Major</h3>
                                        <span id="difficultyBadge"
                                            class="difficulty-badge difficulty-beginner">Beginner</span>
                                    </div>
                                    <div class="chord-notes" id="chordNotes">C - E - G</div>
                                </div>
                                <div style="text-align: center;">
                                    <button class="play-btn" onclick="playPianoChord()" title="Play Chord (Space)">
                                        &#9654;
                                    </button>
                                    <div class="play-label">Play</div>
                                </div>
                            </div>

                            <!-- Piano Keyboard -->
                            <div class="piano-section">
                                <h6>Piano Keyboard</h6>
                                <div class="piano-keyboard-container">
                                    <div class="piano-keyboard" id="pianoKeyboard">
                                        <!-- Keys generated by JavaScript -->
                                    </div>
                                </div>
                            </div>

                            <!-- Fingering Section -->
                            <div class="fingering-section">
                                <div id="fingeringDisplay">
                                    <!-- Finger positions generated by JavaScript -->
                                </div>
                            </div>

                            <!-- Note Colors Legend -->
                            <div class="note-colors-legend">
                                <span class="note-color root">Root</span>
                                <span class="note-color third">3rd</span>
                                <span class="note-color fifth">5th</span>
                                <span class="note-color seventh">7th</span>
                            </div>

                            <!-- Action Buttons -->
                            <div class="chord-actions-section">
                                <button class="chord-action-btn action-share" onclick="shareChord()"
                                    title="Share this chord">
                                    <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                        <path
                                            d="M11 2.5a2.5 2.5 0 1 1 .603 1.628l-6.718 3.12a2.499 2.499 0 0 1 0 1.504l6.718 3.12a2.5 2.5 0 1 1-.488.876l-6.718-3.12a2.5 2.5 0 1 1 0-3.256l6.718-3.12A2.5 2.5 0 0 1 11 2.5z" />
                                    </svg>
                                    Share
                                </button>
                                <button class="chord-action-btn action-copy" onclick="copyChordInfo()"
                                    title="Copy chord info">
                                    <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                        <path
                                            d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z" />
                                        <path
                                            d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z" />
                                    </svg>
                                    Copy
                                </button>
                                <button class="chord-action-btn action-favorite" onclick="saveFavorite()"
                                    title="Save to favorites">
                                    <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                        <path
                                            d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z" />
                                    </svg>
                                    Favorite
                                </button>
                            </div>
                        </div>
                    </div>
                </main>

                <!-- In-Content Ad (Mobile Fallback) -->
                <div class="tool-mobile-ad-container" style="max-width: 1400px; margin: 1rem auto; padding: 0 1rem;">
                    <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
                </div>

                <!-- Chord Progressions Section (Full Width) -->
                <section class="progressions-section-full">
                    <div class="progressions-section-inner">
                        <div class="progressions-section-header">
                            <div class="progressions-title">
                                <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                    <path
                                        d="M6 13c0 1.105-1.12 2-2.5 2S1 14.105 1 13c0-1.104 1.12-2 2.5-2s2.5.896 2.5 2zm9-2c0 1.105-1.12 2-2.5 2s-2.5-.895-2.5-2 1.12-2 2.5-2 2.5.895 2.5 2z" />
                                    <path fill-rule="evenodd" d="M14 11V2h1v9h-1zM6 3v10H5V3h1z" />
                                    <path d="M5 2.905a1 1 0 0 1 .9-.995l8-.8a1 1 0 0 1 1.1.995V3L5 4V2.905z" />
                                </svg>
                                <div>
                                    <h2>Popular Piano Chord Progressions - Learn Songs Fast</h2>
                                    <p>Master these chord sequences used in hundreds of hit songs. Click any progression
                                        to load and practice with audio.</p>
                                </div>
                            </div>
                            <div class="key-selector-large">
                                <label for="keySelect">Select Key:</label>
                                <select id="keySelect" onchange="changeKey(this.value)">
                                    <option value="C" selected>C Major</option>
                                    <option value="G">G Major</option>
                                    <option value="D">D Major</option>
                                    <option value="A">A Major</option>
                                    <option value="E">E Major</option>
                                    <option value="F">F Major</option>
                                    <option value="Bb">Bb Major</option>
                                    <option value="Eb">Eb Major</option>
                                </select>
                            </div>
                        </div>
                        <div class="progressions-grid" id="progressionsContainer">
                            <!-- Populated by JavaScript -->
                        </div>
                    </div>
                </section>

                <!-- Related Tools -->
                <jsp:include page="../modern/components/related-tools.jsp">
                    <jsp:param name="currentToolUrl" value="music/piano-chord-finder.jsp" />
                    <jsp:param name="keyword" value="music" />
                    <jsp:param name="limit" value="6" />
                </jsp:include>

                <!-- SEO Content Section -->
                <section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
                    <div class="tool-card" style="padding: 2rem;">
                        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">How to Learn Piano Chords - Complete
                            Interactive Piano Chord Finder?</h2>
                        <p style="margin-bottom: 1rem; color: var(--text-secondary);">Unlike static PDF charts, our tool
                            offers a dynamic learning experience. The new <strong>MIDI support</strong> allows you to
                            use your own digital piano or keyboard controller to interact with the browser. Real-time
                            audio feedback helps train your ear, while the inversion toggles show you how to play
                            smoothly across the keyboard.</p>

                        <div
                            style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                            <div>
                                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Complete Chord Library</h3>
                                <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                                    <li><strong>100+ Chord Shapes:</strong> Major, Minor, 7th, Maj7, m7, Dim, Aug, Sus,
                                        Add9</li>
                                    <li><strong>All 12 Keys:</strong> Every chord in all sharp and flat keys</li>
                                    <li><strong>Inversions:</strong> Root, 1st, 2nd, and 3rd position for each chord
                                    </li>
                                    <li><strong>Fingering Guides:</strong> Proper finger numbers for both hands</li>
                                    <li><strong>Jazz Chords:</strong> 9th, 11th, 13th, m7b5, dim7 voicings</li>
                                    <li><strong>Extended Chords:</strong> Add9, Add11, Sus2, Sus4 variations</li>
                                </ul>
                            </div>
                            <div>
                                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">5 Easy Piano Chords Every Beginner
                                    Should Know</h3>
                                <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                                    <li><strong>C Major (C-E-G):</strong> The foundation chord - all white keys</li>
                                    <li><strong>G Major (G-B-D):</strong> Essential chord for countless songs</li>
                                    <li><strong>F Major (F-A-C):</strong> Completes the I-IV-V progression</li>
                                    <li><strong>A Minor (A-C-E):</strong> First minor chord most pianists learn</li>
                                    <li><strong>D Minor (D-F-A):</strong> Beautiful melancholy sound</li>
                                </ul>
                            </div>
                        </div>

                        <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">Understanding Piano Chord Inversions</h3>
                        <p style="margin-bottom: 0.75rem; color: var(--text-secondary); font-size: 0.9rem;">Inversions
                            are different ways to play the same chord by changing which note is on the bottom. They make
                            chord transitions smoother and are essential for good piano playing:</p>
                        <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                            <li><strong>Root Position:</strong> C-E-G (root note C is the lowest)</li>
                            <li><strong>1st Inversion:</strong> E-G-C (third E is the lowest)</li>
                            <li><strong>2nd Inversion:</strong> G-C-E (fifth G is the lowest)</li>
                            <li><strong>Why Use Inversions:</strong> Minimize hand movement between chords, create
                                smoother bass lines</li>
                        </ul>

                        <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">Popular Piano Chord Progressions for
                            Beginners</h3>
                        <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                            <li><strong>Pop Classic (I-V-vi-IV):</strong> C - G - Am - F (used in "Let It Be", "Someone
                                Like You", "No Woman No Cry")</li>
                            <li><strong>50s Progression:</strong> C - Am - F - G (used in "Stand By Me", "Every Breath
                                You Take")</li>
                            <li><strong>Pachelbel Canon:</strong> C - G - Am - Em - F - C - F - G (beautiful classical
                                progression)</li>
                            <li><strong>Jazz ii-V-I:</strong> Dm7 - G7 - Cmaj7 (essential jazz progression)</li>
                            <li><strong>12-Bar Blues:</strong> C7 - F7 - G7 (foundation of blues and rock)</li>
                        </ul>

                        <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">Tips for Learning Piano Chords Faster
                        </h3>
                        <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                            <li><strong>Start with triads:</strong> Learn 3-note chords before 7ths</li>
                            <li><strong>Practice inversions:</strong> Play each chord in all positions</li>
                            <li><strong>Use proper fingering:</strong> Our tool shows optimal finger placement</li>
                            <li><strong>Listen and compare:</strong> Use the audio feature to train your ear</li>
                            <li><strong>Learn songs you love:</strong> Motivation matters - pick music that excites you
                            </li>
                        </ul>

                        <div
                            style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                            <div>
                                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">About This Tool</h3>
                                <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                                    <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank"
                                            rel="noopener" style="color: var(--piano-primary);">Anish Nath</a></li>
                                    <li><strong>Reviewed by:</strong> 8gwifi.org team</li>
                                    <li><strong>Last updated:</strong> February 2025</li>
                                    <li><strong>User rating:</strong> 4.9/5 (523 ratings)</li>
                                </ul>
                            </div>
                            <div>
                                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Privacy & Offline Use</h3>
                                <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                                    <li>100% browser-based - no data sent to servers</li>
                                    <li>Works offline after first page load</li>
                                    <li>Save favorite chords locally on your device</li>
                                    <li>No account required - start learning immediately</li>
                                </ul>
                            </div>
                        </div>

                        <h3 style="font-size: 1rem; margin: 1.5rem 0 0.75rem;">Resources for Learning Piano</h3>
                        <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                            <li><a href="https://en.wikipedia.org/wiki/Chord_(music)" rel="nofollow noopener"
                                    target="_blank" style="color: var(--piano-primary);">Understanding chord theory and
                                    intervals</a></li>
                            <li><a href="https://en.wikipedia.org/wiki/Inversion_(music)" rel="nofollow noopener"
                                    target="_blank" style="color: var(--piano-primary);">Chord inversions explained in
                                    depth</a></li>
                            <li><a href="https://www.musictheory.net/lessons" rel="nofollow noopener" target="_blank"
                                    style="color: var(--piano-primary);">Free music theory lessons for pianists</a></li>
                        </ul>
                    </div>
                </section>

                <!-- Support Section -->
                <%@ include file="../modern/components/support-section.jsp" %>

                    <!-- Footer -->
                    <footer class="page-footer">
                        <div class="footer-content">
                            <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
                            <div class="footer-links">
                                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener"
                                    class="footer-link">Twitter</a>
                            </div>
                        </div>
                    </footer>

                    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
                        <%@ include file="../modern/components/analytics.jsp" %>

                            <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"
                                defer></script>
                            <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"
                                defer></script>
                            <script
                                src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
                            <!-- Tone.js for realistic piano audio synthesis -->
                            <script src="https://unpkg.com/tone@14.7.77/build/Tone.js"></script>
                            <script
                                src="<%=request.getContextPath()%>/music/js/piano-chord-finder.js?v=<%=cacheVersion%>"></script>

                            <!-- Custom HowTo Schema (more detailed than generic) -->
                            <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Learn Piano Chords for Beginners",
  "description": "Step-by-step guide to learning piano chords using our free interactive chord chart with audio playback",
  "totalTime": "PT10M",
  "estimatedCost": {
    "@type": "MonetaryAmount",
    "currency": "USD",
    "value": "0"
  },
  "supply": [
    {"@type": "HowToSupply", "name": "Piano or keyboard"},
    {"@type": "HowToSupply", "name": "Computer or mobile device"}
  ],
  "tool": [
    {"@type": "HowToTool", "name": "8gwifi.org Piano Chord Chart"}
  ],
  "step": [
    {"@type": "HowToStep", "position": 1, "name": "Choose a chord to learn", "text": "Start with easy beginner chords like C, G, F, Am, or Dm. Click on the chord name or type it in the search box."},
    {"@type": "HowToStep", "position": 2, "name": "Study the keyboard diagram", "text": "Look at the highlighted keys showing which notes to play. Colors indicate the role of each note: red=root, green=third, blue=fifth, orange=seventh."},
    {"@type": "HowToStep", "position": 3, "name": "Position your fingers", "text": "Follow the fingering guide showing which finger plays each note. Numbers indicate: 1=Thumb, 2=Index, 3=Middle, 4=Ring, 5=Pinky."},
    {"@type": "HowToStep", "position": 4, "name": "Play and compare with audio", "text": "Press the keys on your piano and click the play button to hear how the chord should sound. Adjust if needed."},
    {"@type": "HowToStep", "position": 5, "name": "Practice inversions and progressions", "text": "Once comfortable with root position, learn inversions using the inversion buttons. Then practice chord progressions to play real songs."}
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
      "name": "What are the easiest piano chords for beginners?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The easiest piano chords for beginners are: C Major (C-E-G) using all white keys, G Major (G-B-D), F Major (F-A-C), A Minor (A-C-E), and D Minor (D-F-A). These triads use simple hand positions and are the foundation for thousands of songs."
      }
    },
    {
      "@type": "Question",
      "name": "What are piano chord inversions?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Inversions are different ways to play the same chord by changing which note is on the bottom. For C Major: Root position is C-E-G, 1st inversion is E-G-C, 2nd inversion is G-C-E. Inversions make chord transitions smoother by minimizing hand movement between chords."
      }
    },
    {
      "@type": "Question",
      "name": "How long does it take to learn piano chords?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Most beginners can play basic triads (C, G, F, Am, Dm) within 1-2 weeks of daily 15-30 minute practice. Learning all major and minor chords in root position takes 1-2 months. Adding 7th chords, inversions, and smooth transitions may take 3-6 months of regular practice."
      }
    },
    {
      "@type": "Question",
      "name": "What is the proper fingering for piano chords?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "For most 3-note chords (triads) in root position, use fingers 1-3-5 (thumb-middle-pinky) for both hands. For 4-note chords (7ths), use 1-2-3-5 or 1-2-4-5 depending on the chord shape. Our tool shows the optimal fingering for each chord and inversion."
      }
    },
    {
      "@type": "Question",
      "name": "What chord progression should I learn first on piano?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Start with the C-F-G progression - it's the I-IV-V in C major and used in countless songs. Next, learn C-G-Am-F (the '4 chord' pop progression used in Let It Be, Someone Like You, and hundreds of hits). Then try C-Am-F-G for songs like Stand By Me."
      }
    },
    {
      "@type": "Question",
      "name": "Should I learn chords with my right or left hand first?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Start with your right hand for chord shapes, as it's typically the dominant hand for most people. Once comfortable, learn the same chords with your left hand. Eventually, you'll play chords with your left hand while your right hand plays melody - this is the foundation of piano playing."
      }
    },
    {
      "@type": "Question",
      "name": "What's the difference between major and minor piano chords?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Major chords sound bright and happy, while minor chords sound sad or melancholy. The difference is the middle note (the third): C Major is C-E-G (E is a major third above C), C Minor is C-Eb-G (Eb is a minor third above C). The third is lowered by one half step in minor chords."
      }
    },
    {
      "@type": "Question",
      "name": "How do I play 7th chords on piano?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "7th chords add a fourth note to a triad. For C7 (dominant 7th): C-E-G-Bb. For Cmaj7 (major 7th): C-E-G-B. For Cm7 (minor 7th): C-Eb-G-Bb. These chords have a richer, jazzier sound and are essential for jazz, blues, and R&B music."
      }
    },
    {
      "@type": "Question",
      "name": "Why do pianists use inversions instead of root position?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Inversions minimize hand movement between chords, making progressions smoother. For example, going from C (root) to F (root) requires jumping your hand. But C (root: C-E-G) to F (2nd inversion: C-F-A) keeps the C note in place. This creates a smoother bass line and easier transitions."
      }
    },
    {
      "@type": "Question",
      "name": "What songs can I play with 4 easy piano chords?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "With C, G, Am, and F you can play: Let It Be (Beatles), Someone Like You (Adele), No Woman No Cry (Bob Marley), With or Without You (U2), When I Come Around (Green Day), She Will Be Loved (Maroon 5), and literally hundreds more pop songs that use this I-V-vi-IV progression."
      }
    }
  ]
}
    </script>
        </body>

        </html>