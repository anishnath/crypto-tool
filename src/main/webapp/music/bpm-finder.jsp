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
                <jsp:param name="toolName" value="Free BPM Finder - Tap Tempo & Beat Counter Online" />
                <jsp:param name="toolDescription"
                    value="Find the BPM (beats per minute) of any song by tapping along. Free online tap tempo tool with accurate beat detection. Perfect for DJs, musicians, and producers." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/bpm-finder.jsp" />
                <jsp:param name="toolKeywords"
                    value="bpm finder, tap tempo, beat counter, bpm calculator, tempo finder, beats per minute, tap bpm, music tempo, song bpm, free bpm tool" />
                <jsp:param name="toolImage" value="bpm-finder.png" />
                <jsp:param name="toolFeatures"
                    value="Tap tempo detection,Accurate BPM calculation,Real-time beat counter,Average BPM display,Tap history,Reset function,Mobile friendly,No download required,Works for any song,Free online tool" />
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

            <%@ include file="../modern/ads/ad-init.jsp" %>

                <style>
                    .bpm-container {
                        max-width: 800px;
                        margin: 0 auto;
                        padding: 2rem 1rem;
                    }

                    .bpm-display-card {
                        background: var(--bg-primary);
                        border-radius: 24px;
                        padding: 3rem 2rem;
                        text-align: center;
                        box-shadow: 0 10px 40px -10px rgba(0, 0, 0, 0.1);
                        border: 1px solid var(--border);
                        margin-bottom: 2rem;
                    }

                    .bpm-value {
                        font-size: 8rem;
                        font-weight: 800;
                        line-height: 1;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        margin-bottom: 0.5rem;
                    }

                    .bpm-label {
                        font-size: 1.5rem;
                        color: var(--text-secondary);
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.1em;
                    }

                    .tap-button {
                        width: 100%;
                        max-width: 400px;
                        height: 200px;
                        margin: 2rem auto;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        border: none;
                        border-radius: 20px;
                        color: white;
                        font-size: 2rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        box-shadow: 0 10px 30px -5px rgba(99, 102, 241, 0.4);
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        gap: 1rem;
                    }

                    .tap-button:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 15px 40px -5px rgba(99, 102, 241, 0.5);
                    }

                    .tap-button:active {
                        transform: translateY(-2px) scale(0.98);
                    }

                    .tap-button.tapped {
                        transform: scale(0.95);
                        box-shadow: 0 5px 20px -5px rgba(99, 102, 241, 0.6);
                    }

                    .tap-icon {
                        font-size: 4rem;
                    }

                    .stats-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                        gap: 1rem;
                        margin: 2rem 0;
                    }

                    .stat-card {
                        background: var(--bg-secondary);
                        border: 1px solid var(--border);
                        border-radius: 12px;
                        padding: 1.5rem;
                        text-align: center;
                    }

                    .stat-value {
                        font-size: 2rem;
                        font-weight: 700;
                        color: var(--primary);
                        margin-bottom: 0.25rem;
                    }

                    .stat-label {
                        font-size: 0.875rem;
                        color: var(--text-secondary);
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                    }

                    .control-buttons {
                        display: flex;
                        gap: 1rem;
                        justify-content: center;
                        margin-top: 2rem;
                    }

                    .control-btn {
                        padding: 0.875rem 2rem;
                        border: 2px solid var(--border);
                        background: var(--bg-primary);
                        color: var(--text-primary);
                        border-radius: 12px;
                        font-size: 1rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .control-btn:hover {
                        border-color: var(--primary);
                        color: var(--primary);
                        transform: translateY(-2px);
                    }

                    .tempo-guide {
                        margin-top: 3rem;
                        background: var(--bg-secondary);
                        border-radius: 16px;
                        padding: 2rem;
                    }

                    .tempo-guide h3 {
                        margin-bottom: 1rem;
                    }

                    .tempo-list {
                        display: grid;
                        gap: 0.75rem;
                    }

                    .tempo-item {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 0.75rem 1rem;
                        background: var(--bg-primary);
                        border-radius: 8px;
                        border: 1px solid var(--border);
                    }

                    .tempo-name {
                        font-weight: 600;
                        color: var(--text-primary);
                    }

                    .tempo-range {
                        color: var(--text-secondary);
                        font-size: 0.875rem;
                    }

                    @media (max-width: 768px) {
                        .bpm-container {
                            padding: 1rem 0.5rem;
                        }

                        .bpm-display-card {
                            padding: 2rem 1rem;
                        }

                        .bpm-value {
                            font-size: 5rem;
                        }

                        .bpm-label {
                            font-size: 1.125rem;
                        }

                        .tap-button {
                            height: 150px;
                            font-size: 1.25rem;
                            max-width: 100%;
                        }

                        .tap-icon {
                            font-size: 2.5rem;
                        }

                        .stats-grid {
                            grid-template-columns: repeat(3, 1fr);
                            gap: 0.5rem;
                        }

                        .stat-card {
                            padding: 1rem;
                        }

                        .stat-value {
                            font-size: 1.5rem;
                        }

                        .stat-label {
                            font-size: 0.75rem;
                        }

                        .control-buttons {
                            flex-direction: column;
                        }

                        .control-btn {
                            width: 100%;
                        }

                        .tempo-guide {
                            padding: 1.5rem;
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
                                <h1 class="tool-page-title">BPM Finder</h1>
                                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Find the
                                    tempo of any song by tapping along to the beat</p>
                                <nav class="tool-breadcrumbs">
                                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                    <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                    BPM Finder
                                </nav>
                            </div>
                        </div>
                    </header>

                    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                        <main class="bpm-container">

                            <!-- BPM Display -->
                            <div class="bpm-display-card">
                                <div class="bpm-value" id="bpmValue">0</div>
                                <div class="bpm-label">Beats Per Minute</div>
                            </div>

                            <!-- Tap Button -->
                            <button class="tap-button" id="tapButton">
                                <div class="tap-icon">👆</div>
                                <div>Tap Here</div>
                                <div style="font-size: 1rem; opacity: 0.9;">Tap along to the beat</div>
                            </button>

                            <!-- Stats -->
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-value" id="tapCount">0</div>
                                    <div class="stat-label">Taps</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-value" id="avgBpm">0</div>
                                    <div class="stat-label">Average BPM</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-value" id="tempoName">-</div>
                                    <div class="stat-label">Tempo</div>
                                </div>
                            </div>

                            <!-- Controls -->
                            <div class="control-buttons">
                                <button class="control-btn" id="resetBtn">
                                    <span>🔄</span>
                                    <span>Reset</span>
                                </button>
                            </div>

                            <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                                <!-- Tempo Guide -->
                                <div class="tempo-guide">
                                    <h3>Tempo Guide</h3>
                                    <div class="tempo-list">
                                        <div class="tempo-item">
                                            <span class="tempo-name">Grave</span>
                                            <span class="tempo-range">
                                                < 40 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Largo</span>
                                            <span class="tempo-range">40-60 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Adagio</span>
                                            <span class="tempo-range">60-80 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Andante</span>
                                            <span class="tempo-range">80-100 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Moderato</span>
                                            <span class="tempo-range">100-120 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Allegro</span>
                                            <span class="tempo-range">120-140 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Vivace</span>
                                            <span class="tempo-range">140-160 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Presto</span>
                                            <span class="tempo-range">160-200 BPM</span>
                                        </div>
                                        <div class="tempo-item">
                                            <span class="tempo-name">Prestissimo</span>
                                            <span class="tempo-range">> 200 BPM</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- SEO Content -->
                                <section class="tool-expertise-section" style="margin-top: 4rem;">
                                    <h2>What is BPM?</h2>
                                    <p>BPM stands for "Beats Per Minute" and is the standard unit for measuring tempo in
                                        music. It tells you how many beats occur in one minute, which determines how
                                        fast or slow a song feels. For example, a slow ballad might be 60-80 BPM, while
                                        an upbeat dance track could be 120-140 BPM.</p>

                                    <h3 style="margin-top: 2rem;">How to Use the BPM Finder</h3>
                                    <p>Using our tap tempo tool is simple:</p>
                                    <ol
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Play the song you want to measure</li>
                                        <li>Tap the button in rhythm with the beat</li>
                                        <li>Keep tapping for at least 4-8 beats for accuracy</li>
                                        <li>The BPM will be calculated and displayed automatically</li>
                                        <li>Click Reset to start over with a new song</li>
                                    </ol>

                                    <h3 style="margin-top: 2rem;">Why Find BPM?</h3>
                                    <p>Knowing the BPM of a song is useful for:</p>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>DJs:</strong> Beatmatching and mixing songs with similar tempos</li>
                                        <li><strong>Musicians:</strong> Learning to play songs at the correct speed</li>
                                        <li><strong>Producers:</strong> Setting project tempo for remixes or covers</li>
                                        <li><strong>Dancers:</strong> Choreographing routines to specific tempos</li>
                                        <li><strong>Fitness:</strong> Creating workout playlists with consistent energy
                                        </li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Common Song Tempos</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>Hip-Hop:</strong> 70-100 BPM</li>
                                        <li><strong>Pop:</strong> 100-130 BPM</li>
                                        <li><strong>Rock:</strong> 110-140 BPM</li>
                                        <li><strong>House:</strong> 120-130 BPM</li>
                                        <li><strong>Techno:</strong> 120-150 BPM</li>
                                        <li><strong>Drum & Bass:</strong> 160-180 BPM</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Tips for Accurate BPM Detection</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Tap on the main beat (usually the kick drum or snare)</li>
                                        <li>Tap at least 8 times for better accuracy</li>
                                        <li>Keep your tapping consistent and steady</li>
                                        <li>If the BPM seems double or half, you may be tapping on the wrong beat
                                            division</li>
                                        <li>Use headphones for clearer beat detection</li>
                                    </ul>
                                </section>

                        </main>

                        <jsp:include page="../modern/components/related-tools.jsp">
                            <jsp:param name="currentToolUrl" value="music/bpm-finder.jsp" />
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
                                        src="<%=request.getContextPath()%>/music/js/bpm-finder.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>