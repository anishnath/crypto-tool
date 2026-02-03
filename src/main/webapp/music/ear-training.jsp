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
                <jsp:param name="toolName" value="Free Ear Training - Learn Musical Intervals Online" />
                <jsp:param name="toolDescription"
                    value="Improve your musical ear with our free ear training tool. Practice interval recognition, chord identification, and develop perfect pitch. Interactive exercises for musicians." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/ear-training.jsp" />
                <jsp:param name="toolKeywords"
                    value="ear training, interval training, music ear training, learn intervals, perfect pitch, relative pitch, music theory practice, interval recognition" />
                <jsp:param name="toolImage" value="ear-training.png" />
                <jsp:param name="toolFeatures"
                    value="Interval recognition,3 difficulty levels,Ascending/descending modes,Progress tracking,Score & streak system,Keyboard shortcuts,Save progress,Free ear training" />
                <jsp:param name="hasSteps" value="false" />
            </jsp:include>

            <!-- Custom HowTo Schema -->
            <script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "HowTo",
              "name": "How to Practice Ear Training for Musical Intervals",
              "description": "Learn to identify musical intervals by ear using our free interactive ear training tool.",
              "totalTime": "PT15M",
              "step": [
                {"@type": "HowToStep", "position": 1, "name": "Select difficulty level", "text": "Choose Beginner (5 intervals), Intermediate (7 intervals), or Advanced (all 12 intervals) based on your experience."},
                {"@type": "HowToStep", "position": 2, "name": "Choose direction mode", "text": "Select Ascending (low to high), Descending (high to low), or Random to practice all directions."},
                {"@type": "HowToStep", "position": 3, "name": "Click Play Interval", "text": "Press the Play button or Spacebar to hear two notes played in sequence."},
                {"@type": "HowToStep", "position": 4, "name": "Identify the interval", "text": "Listen carefully and click the button matching the interval you heard (e.g., Perfect 5th, Major 3rd)."},
                {"@type": "HowToStep", "position": 5, "name": "Learn from feedback", "text": "See if you're correct and learn the song association for each interval to help remember it."},
                {"@type": "HowToStep", "position": 6, "name": "Track your progress", "text": "Watch your score, streak, and accuracy improve over time. Progress is saved automatically."}
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
                  "name": "What is ear training?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Ear training is the practice of developing your ability to identify musical elements by ear, including intervals (distance between two notes), chords, scales, and rhythms. It's essential for musicians who want to play by ear, transcribe music, improvise, and deeply understand music theory."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What are musical intervals?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A musical interval is the distance between two notes, measured in semitones (half steps). For example, a Perfect 5th is 7 semitones apart (like C to G), while a Major 3rd is 4 semitones (like C to E). There are 12 basic intervals within an octave."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How do I memorize intervals?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Associate each interval with a familiar song. For example: Perfect 5th = Star Wars theme, Perfect 4th = Here Comes the Bride, Major 3rd = When the Saints Go Marching In, Minor 3rd = Greensleeves, Octave = Somewhere Over the Rainbow. Our tool shows these associations."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Which intervals should beginners learn first?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Start with the easiest to distinguish: Octave (very wide), Perfect 5th (Star Wars), Perfect 4th (Here Comes the Bride), Major 3rd (happy sound), and Major 2nd (whole step). Our Beginner mode includes exactly these 5 intervals."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How long does it take to develop good ear training?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "With daily practice of 10-15 minutes, most people can reliably identify basic intervals (4ths, 5ths, octaves) within 2-4 weeks. Mastering all 12 intervals typically takes 2-3 months of consistent practice. The key is regular, focused practice rather than long sessions."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What's the difference between ascending and descending intervals?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Ascending intervals go from a lower note to a higher note (the second note is higher). Descending intervals go from higher to lower (the second note is lower). The same interval can sound quite different ascending vs descending, so practicing both directions is important."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Is my progress saved?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes! Your score, best streak, total attempts, accuracy, and settings are automatically saved in your browser. When you return, you'll continue from where you left off. Use the Reset button if you want to start fresh."
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
                    .ear-container {
                        max-width: 900px;
                        margin: 0 auto;
                        padding: 2rem 1rem;
                    }

                    .exercise-card {
                        background: var(--bg-primary);
                        border-radius: 20px;
                        padding: 3rem 2rem;
                        border: 1px solid var(--border);
                        text-align: center;
                        margin-bottom: 2rem;
                    }

                    .exercise-title {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: 1rem;
                    }

                    .play-interval-btn {
                        padding: 1.5rem 3rem;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        color: white;
                        border: none;
                        border-radius: 16px;
                        font-size: 1.5rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        margin: 2rem 0;
                    }

                    .play-interval-btn:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 12px 30px rgba(99, 102, 241, 0.4);
                    }

                    .answer-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                        gap: 1rem;
                        margin-top: 2rem;
                    }

                    .answer-btn {
                        padding: 1.25rem;
                        background: var(--bg-secondary);
                        border: 2px solid var(--border);
                        border-radius: 12px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .answer-btn:hover {
                        border-color: var(--primary);
                        transform: translateY(-2px);
                    }

                    .answer-btn.correct {
                        background: #10b981;
                        color: white;
                        border-color: #10b981;
                    }

                    .answer-btn.incorrect {
                        background: #ef4444;
                        color: white;
                        border-color: #ef4444;
                    }

                    .answer-key {
                        display: inline-block;
                        width: 20px;
                        height: 20px;
                        line-height: 20px;
                        background: var(--bg-primary);
                        border: 1px solid var(--border);
                        border-radius: 4px;
                        font-size: 0.7rem;
                        font-family: monospace;
                        margin-right: 0.5rem;
                        text-align: center;
                    }

                    .answer-btn.correct .answer-key,
                    .answer-btn.incorrect .answer-key {
                        background: rgba(255,255,255,0.2);
                        border-color: rgba(255,255,255,0.3);
                    }

                    .score-panel {
                        display: flex;
                        justify-content: space-around;
                        background: var(--bg-secondary);
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-bottom: 2rem;
                    }

                    .score-item {
                        text-align: center;
                    }

                    .score-value {
                        font-size: 2.5rem;
                        font-weight: 800;
                        color: var(--primary);
                    }

                    .score-label {
                        color: var(--text-secondary);
                        font-size: 0.875rem;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                    }

                    .feedback-message {
                        font-size: 1.25rem;
                        font-weight: 600;
                        margin-top: 1rem;
                        min-height: 2rem;
                    }

                    .feedback-message.correct {
                        color: #10b981;
                    }

                    .feedback-message.incorrect {
                        color: #ef4444;
                    }

                    /* Settings Panel */
                    .settings-panel {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 1rem;
                        align-items: center;
                        justify-content: center;
                        background: var(--bg-secondary);
                        border-radius: 12px;
                        padding: 1rem 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    .setting-group {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .setting-label {
                        font-weight: 600;
                        color: var(--text-secondary);
                        font-size: 0.875rem;
                    }

                    .setting-select {
                        padding: 0.5rem 1rem;
                        border: 2px solid var(--border);
                        border-radius: 8px;
                        background: var(--bg-primary);
                        color: var(--text-primary);
                        font-weight: 600;
                        cursor: pointer;
                    }

                    .setting-checkbox {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        cursor: pointer;
                        font-weight: 600;
                        color: var(--text-secondary);
                        font-size: 0.875rem;
                    }

                    .reset-btn {
                        padding: 0.5rem 1rem;
                        border: 2px solid var(--border);
                        border-radius: 8px;
                        background: var(--bg-primary);
                        color: var(--text-secondary);
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s ease;
                    }

                    .reset-btn:hover {
                        border-color: #ef4444;
                        color: #ef4444;
                    }

                    /* Button Row */
                    .button-row {
                        display: flex;
                        gap: 1rem;
                        justify-content: center;
                        align-items: center;
                        flex-wrap: wrap;
                        margin: 2rem 0;
                    }

                    .replay-btn, .next-btn {
                        padding: 1rem 2rem;
                        border: 2px solid var(--border);
                        background: var(--bg-secondary);
                        border-radius: 12px;
                        font-size: 1.1rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        color: var(--text-primary);
                    }

                    .replay-btn:hover {
                        border-color: var(--primary);
                        color: var(--primary);
                    }

                    .next-btn {
                        background: linear-gradient(135deg, #10b981, #059669);
                        border-color: transparent;
                        color: white;
                    }

                    .next-btn:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
                    }

                    /* Shortcuts Hint */
                    .shortcuts-hint {
                        margin-top: 2rem;
                        padding: 0.75rem 1rem;
                        background: var(--bg-secondary);
                        border-radius: 8px;
                        font-size: 0.8rem;
                        color: var(--text-secondary);
                    }

                    .shortcuts-hint kbd {
                        display: inline-block;
                        padding: 0.15rem 0.4rem;
                        background: var(--bg-primary);
                        border: 1px solid var(--border);
                        border-radius: 4px;
                        font-family: monospace;
                        font-size: 0.75rem;
                        margin-right: 0.25rem;
                    }

                    @media (max-width: 768px) {
                        .ear-container {
                            padding: 1rem 0.5rem;
                        }

                        .exercise-card {
                            padding: 2rem 1rem;
                        }

                        .exercise-title {
                            font-size: 1.25rem;
                        }

                        .play-interval-btn {
                            padding: 1.25rem 2rem;
                            font-size: 1.25rem;
                            width: 100%;
                            max-width: 300px;
                        }

                        .answer-grid {
                            grid-template-columns: repeat(2, 1fr);
                            gap: 0.75rem;
                        }

                        .answer-btn {
                            padding: 1rem;
                            font-size: 0.875rem;
                        }

                        .score-panel {
                            flex-direction: row;
                            gap: 0.5rem;
                            padding: 1rem;
                        }

                        .score-value {
                            font-size: 2rem;
                        }

                        .score-label {
                            font-size: 0.75rem;
                        }

                        .feedback-message {
                            font-size: 1rem;
                        }

                        .settings-panel {
                            flex-direction: column;
                            gap: 0.75rem;
                        }

                        .setting-group {
                            width: 100%;
                            justify-content: space-between;
                        }

                        .setting-select {
                            flex: 1;
                            max-width: 180px;
                        }

                        .button-row {
                            flex-direction: column;
                            gap: 0.75rem;
                        }

                        .play-interval-btn,
                        .replay-btn,
                        .next-btn {
                            width: 100%;
                            max-width: 280px;
                        }

                        .shortcuts-hint {
                            display: none;
                        }
                    }
                </style>
        </head>

        <body>
            <%@ include file="../modern/components/nav-header.jsp" %>
                <%@ include file="../modern/ads/ad-side-rails.jsp" %>

                    <header class="tool-page-header">
                        <div class="tool-page-header-inner">
                            <div>
                                <h1 class="tool-page-title">Ear Training</h1>
                                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Practice
                                    interval recognition and develop your musical ear</p>
                                <nav class="tool-breadcrumbs">
                                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                    <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                    Ear Training
                                </nav>
                            </div>
                        </div>
                    </header>

                    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                        <main class="ear-container">

                            <!-- Settings Panel -->
                            <div class="settings-panel">
                                <div class="setting-group">
                                    <label class="setting-label">Difficulty:</label>
                                    <select class="setting-select" id="difficultySelect">
                                        <option value="beginner">Beginner (5 intervals)</option>
                                        <option value="intermediate">Intermediate (7 intervals)</option>
                                        <option value="advanced">Advanced (12 intervals)</option>
                                    </select>
                                </div>
                                <div class="setting-group">
                                    <label class="setting-label">Direction:</label>
                                    <select class="setting-select" id="directionSelect">
                                        <option value="ascending">Ascending ↑</option>
                                        <option value="descending">Descending ↓</option>
                                        <option value="random">Random ↕</option>
                                    </select>
                                </div>
                                <div class="setting-group">
                                    <label class="setting-checkbox">
                                        <input type="checkbox" id="autoAdvanceCheckbox" checked>
                                        <span>Auto-advance</span>
                                    </label>
                                </div>
                                <button class="reset-btn" id="resetBtn" title="Reset progress">🔄 Reset</button>
                            </div>

                            <!-- Score Panel -->
                            <div class="score-panel">
                                <div class="score-item">
                                    <div class="score-value" id="scoreValue">0</div>
                                    <div class="score-label">Score</div>
                                </div>
                                <div class="score-item">
                                    <div class="score-value" id="streakValue">0</div>
                                    <div class="score-label">Streak</div>
                                </div>
                                <div class="score-item">
                                    <div class="score-value" id="bestStreakValue">0</div>
                                    <div class="score-label">Best</div>
                                </div>
                                <div class="score-item">
                                    <div class="score-value" id="accuracyValue">0%</div>
                                    <div class="score-label">Accuracy</div>
                                </div>
                            </div>

                            <!-- Exercise Card -->
                            <div class="exercise-card">
                                <div class="exercise-title">Identify the Interval</div>

                                <div class="button-row">
                                    <button class="play-interval-btn" id="playBtn">
                                        🔊 Play Interval
                                    </button>
                                    <button class="replay-btn" id="replayBtn" style="display: none;">
                                        🔁 Replay
                                    </button>
                                    <button class="next-btn" id="nextBtn" style="display: none;">
                                        Next ➡️
                                    </button>
                                </div>

                                <div class="feedback-message" id="feedbackMessage"></div>

                                <div class="answer-grid" id="answerGrid"></div>

                                <div class="shortcuts-hint">
                                    <kbd>Space</kbd> Play &nbsp; <kbd>1-9</kbd> Answer &nbsp; <kbd>N</kbd> Next
                                </div>
                            </div>

                            <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                                <!-- SEO Content -->
                                <section class="tool-expertise-section" style="margin-top: 4rem;">
                                    <h2>What is Ear Training?</h2>
                                    <p>Ear training is the process of developing your ability to identify musical
                                        elements by ear, such as intervals, chords, scales, and rhythms. It's an
                                        essential skill for all musicians, helping you play by ear, transcribe music,
                                        improvise, and understand music theory more deeply.</p>

                                    <h3 style="margin-top: 2rem;">Musical Intervals Explained</h3>
                                    <p>An interval is the distance between two notes. Here are the basic intervals:</p>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>Minor 2nd (1 semitone):</strong> Jaws theme, very tense</li>
                                        <li><strong>Major 2nd (2 semitones):</strong> Happy Birthday, "Hap-py"</li>
                                        <li><strong>Minor 3rd (3 semitones):</strong> Greensleeves, sad sound</li>
                                        <li><strong>Major 3rd (4 semitones):</strong> When the Saints, happy sound</li>
                                        <li><strong>Perfect 4th (5 semitones):</strong> Here Comes the Bride</li>
                                        <li><strong>Tritone (6 semitones):</strong> The Simpsons, very dissonant</li>
                                        <li><strong>Perfect 5th (7 semitones):</strong> Star Wars theme, powerful</li>
                                        <li><strong>Minor 6th (8 semitones):</strong> The Entertainer</li>
                                        <li><strong>Major 6th (9 semitones):</strong> My Bonnie, bright sound</li>
                                        <li><strong>Minor 7th (10 semitones):</strong> Star Trek theme</li>
                                        <li><strong>Major 7th (11 semitones):</strong> Take On Me, very tense</li>
                                        <li><strong>Octave (12 semitones):</strong> Somewhere Over the Rainbow</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">How to Practice Ear Training</h3>
                                    <ol
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Start with simple intervals (octave, perfect 5th, perfect 4th)</li>
                                        <li>Practice daily for 10-15 minutes</li>
                                        <li>Sing the intervals to internalize the sound</li>
                                        <li>Associate intervals with familiar songs</li>
                                        <li>Gradually add more difficult intervals</li>
                                        <li>Practice both ascending and descending intervals</li>
                                    </ol>

                                    <h3 style="margin-top: 2rem;">Benefits of Ear Training</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Play songs by ear without sheet music</li>
                                        <li>Transcribe music more accurately</li>
                                        <li>Improvise with more confidence</li>
                                        <li>Tune your instrument better</li>
                                        <li>Communicate better with other musicians</li>
                                        <li>Understand music theory more deeply</li>
                                    </ul>
                                </section>

                        </main>

                        <jsp:include page="../modern/components/related-tools.jsp">
                            <jsp:param name="currentToolUrl" value="music/ear-training.jsp" />
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
                                        src="<%=request.getContextPath()%>/music/js/ear-training.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>