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
                <jsp:param name="toolName" value="Free Online Drum Machine - Beat Maker & Sequencer" />
                <jsp:param name="toolDescription"
                    value="Create beats online with our free drum machine. 16-step sequencer, multiple drum kits, tempo control, and pattern saving. Perfect for producers and beatmakers." />
                <jsp:param name="toolCategory" value="Music" />
                <jsp:param name="toolUrl" value="music/drum-machine.jsp" />
                <jsp:param name="toolKeywords"
                    value="drum machine, beat maker, online drum machine, drum sequencer, make beats online, free drum machine, beat creator, rhythm maker, drum patterns" />
                <jsp:param name="toolImage" value="drum-machine.png" />
                <jsp:param name="toolFeatures"
                    value="16-step sequencer,Multiple drum kits,Tempo control,Pattern saving,8 drum sounds,Real-time playback,Loop mode,Share patterns,Keyboard shortcuts,Free beat maker" />
                <jsp:param name="hasSteps" value="false" />
            </jsp:include>

            <!-- Custom HowTo Schema -->
            <script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "HowTo",
              "name": "How to Create Drum Beats with Online Drum Machine",
              "description": "Learn to create professional drum patterns using our free 16-step sequencer with multiple drum kits.",
              "totalTime": "PT5M",
              "step": [
                {"@type": "HowToStep", "position": 1, "name": "Select a drum kit", "text": "Choose from Acoustic, Electronic, 808, or Trap drum kits using the Kit dropdown. Each kit has unique sounds."},
                {"@type": "HowToStep", "position": 2, "name": "Set your tempo", "text": "Adjust the BPM (beats per minute) from 40-240. Use Tap Tempo to tap your desired speed."},
                {"@type": "HowToStep", "position": 3, "name": "Click cells to add hits", "text": "Click on the grid to add drum hits. Each row is a different sound (kick, snare, hi-hat). Each column is a step in the sequence."},
                {"@type": "HowToStep", "position": 4, "name": "Press Play to hear", "text": "Click Play or press Spacebar to hear your pattern loop. The highlighted column shows the current position."},
                {"@type": "HowToStep", "position": 5, "name": "Adjust and refine", "text": "Use volume sliders for each track, mute tracks, add swing, or try preset patterns as starting points."},
                {"@type": "HowToStep", "position": 6, "name": "Save and share", "text": "Save your pattern locally, or click Share to get a link you can send to others."}
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
                  "name": "What is a drum machine?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A drum machine is an electronic instrument that creates drum sounds and beats. Our online drum machine uses a 16-step sequencer where you click to place drum hits in a grid, creating patterns that loop automatically. It's used for music production, practice, and creating beats."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What is a 16-step sequencer?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A 16-step sequencer divides one measure of music into 16 equal parts (16th notes). Each step can have drum hits. At 120 BPM, all 16 steps play in 2 seconds. This format is standard in drum machines like the Roland TR-808 and modern DAWs."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What is BPM and how do I choose the right tempo?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "BPM means Beats Per Minute - how fast your pattern plays. Common tempos: 70-90 BPM for hip-hop/R&B, 100-120 BPM for pop/rock, 120-130 BPM for house music, 140-160 BPM for drum & bass, 140-180 BPM for trap. Use Tap Tempo to match a song's speed."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What is swing in drum programming?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Swing delays the off-beat notes slightly, creating a 'shuffle' or 'groove' feel instead of robotic timing. 0% swing is straight/mechanical, 20-40% adds subtle groove (great for house/techno), 50-70% creates strong shuffle (jazz/swing feel). It humanizes your beats."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What are the differences between drum kits?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Acoustic: Natural drum sounds for rock/pop. Electronic: Crisp, tight sounds for EDM. 808: Deep, booming kicks and punchy sounds (hip-hop/trap). Trap: Hard-hitting with tight hi-hats for modern hip-hop/trap music. Each kit has different attack, decay, and tonal characteristics."
                  }
                },
                {
                  "@type": "Question",
                  "name": "How do I create a basic drum pattern?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Start with kick on steps 1 and 9 (beats 1 and 3), snare on steps 5 and 13 (beats 2 and 4), and hi-hats on every other step (1,3,5,7,9,11,13,15). This is a classic rock/pop beat. Add variations by moving the second kick or adding ghost notes."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Can I save my drum patterns?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes! Click 'Save' to store your pattern in your browser's local storage. Click 'Load' to retrieve it later. You can also click 'Share' to get a URL that contains your entire pattern - send it to friends or save the link to access from any device."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What keyboard shortcuts are available?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Press Spacebar to Play/Stop. Press keys 1-8 to play individual drum sounds (1=Kick, 2=Snare, 3=Closed Hi-Hat, 4=Open Hi-Hat, 5=Clap, 6=Tom, 7=Crash, 8=Rim). Great for jamming and testing sounds without clicking."
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
                    .drum-container {
                        max-width: 1400px;
                        margin: 0 auto;
                        padding: 2rem 1rem;
                    }

                    .drum-controls {
                        background: var(--bg-primary);
                        border-radius: 16px;
                        padding: 1.5rem;
                        border: 1px solid var(--border);
                        margin-bottom: 2rem;
                        display: flex;
                        flex-wrap: wrap;
                        gap: 1rem;
                        align-items: center;
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
                    }

                    .play-btn {
                        padding: 0.75rem 2rem;
                        background: linear-gradient(135deg, #10b981, #059669);
                        color: white;
                        border: none;
                        border-radius: 12px;
                        font-weight: 700;
                        font-size: 1.125rem;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .play-btn:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
                    }

                    .play-btn.playing {
                        background: linear-gradient(135deg, #ef4444, #dc2626);
                    }

                    .sequencer-wrapper {
                        background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
                        border-radius: 20px;
                        padding: 2rem;
                        box-shadow: 0 20px 60px -10px rgba(0, 0, 0, 0.3);
                        margin-bottom: 2rem;
                        overflow-x: auto;
                    }

                    .sequencer-grid {
                        display: grid;
                        grid-template-columns: 160px repeat(16, 50px);
                        gap: 4px;
                        min-width: 980px;
                    }

                    .track-label {
                        display: flex;
                        align-items: center;
                        padding: 0.5rem 0.75rem;
                        background: var(--bg-secondary);
                        border-radius: 8px;
                        font-weight: 600;
                        color: var(--text-primary);
                        font-size: 0.875rem;
                        min-height: 50px;
                    }

                    .step-cell {
                        aspect-ratio: 1;
                        background: rgba(255, 255, 255, 0.05);
                        border: 2px solid rgba(255, 255, 255, 0.1);
                        border-radius: 8px;
                        cursor: pointer;
                        transition: all 0.15s ease;
                        position: relative;
                    }

                    .step-cell:hover {
                        background: rgba(255, 255, 255, 0.1);
                        border-color: rgba(255, 255, 255, 0.3);
                    }

                    .step-cell.active {
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        border-color: #6366f1;
                        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
                    }

                    .step-cell.current {
                        border-color: #10b981;
                        border-width: 3px;
                    }

                    .step-cell.beat-4 {
                        background: rgba(255, 255, 255, 0.08);
                    }

                    .pattern-actions {
                        display: flex;
                        gap: 1rem;
                        margin-top: 2rem;
                    }

                    .action-btn {
                        padding: 0.75rem 1.5rem;
                        border: 2px solid var(--border);
                        background: var(--bg-primary);
                        color: var(--text-primary);
                        border-radius: 12px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .action-btn:hover {
                        border-color: var(--primary);
                        color: var(--primary);
                    }

                    .preset-patterns {
                        background: var(--bg-secondary);
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-top: 2rem;
                    }

                    .preset-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 1rem;
                        margin-top: 1rem;
                    }

                    .preset-btn {
                        padding: 1rem;
                        background: var(--bg-primary);
                        border: 2px solid var(--border);
                        border-radius: 12px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        text-align: left;
                    }

                    .preset-btn:hover {
                        border-color: var(--primary);
                        transform: translateY(-2px);
                    }

                    .preset-name {
                        font-size: 1rem;
                        color: var(--text-primary);
                        margin-bottom: 0.25rem;
                    }

                    .preset-desc {
                        font-size: 0.75rem;
                        color: var(--text-secondary);
                    }

                    /* Tap Tempo Button */
                    .tap-tempo-btn {
                        padding: 0.5rem 1rem;
                        background: var(--bg-secondary);
                        border: 2px solid var(--border);
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.15s ease;
                        color: var(--text-primary);
                    }

                    .tap-tempo-btn:hover {
                        border-color: var(--primary);
                        background: rgba(99, 102, 241, 0.1);
                    }

                    .tap-tempo-btn:active {
                        transform: scale(0.95);
                        background: var(--primary);
                        color: white;
                    }

                    /* Track Label with Controls */
                    .track-label-content {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        width: 100%;
                    }

                    .track-name {
                        flex: 1;
                        font-size: 0.8rem;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .mute-btn {
                        width: 28px;
                        height: 28px;
                        border: none;
                        background: transparent;
                        cursor: pointer;
                        font-size: 0.9rem;
                        padding: 0;
                        border-radius: 4px;
                        transition: all 0.15s ease;
                        flex-shrink: 0;
                    }

                    .mute-btn:hover {
                        background: rgba(255, 255, 255, 0.1);
                    }

                    .mute-btn.muted {
                        opacity: 0.5;
                    }

                    .track-volume {
                        width: 50px !important;
                        height: 4px;
                        -webkit-appearance: none;
                        appearance: none;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 2px;
                        cursor: pointer;
                        flex-shrink: 0;
                    }

                    .track-volume::-webkit-slider-thumb {
                        -webkit-appearance: none;
                        width: 12px;
                        height: 12px;
                        background: var(--primary);
                        border-radius: 50%;
                        cursor: pointer;
                    }

                    .track-volume::-moz-range-thumb {
                        width: 12px;
                        height: 12px;
                        background: var(--primary);
                        border-radius: 50%;
                        cursor: pointer;
                        border: none;
                    }

                    .track-label-content.key-pressed {
                        background: rgba(99, 102, 241, 0.3);
                        border-radius: 4px;
                    }

                    /* Updated Pattern Actions */
                    .pattern-actions {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 0.75rem;
                        margin-top: 2rem;
                    }

                    .action-btn.primary {
                        background: linear-gradient(135deg, #6366f1, #4f46e5);
                        border-color: transparent;
                        color: white;
                    }

                    .action-btn.primary:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
                    }

                    /* Keyboard Shortcuts Hint */
                    .shortcuts-hint {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 1rem;
                        margin-top: 1rem;
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
                        .sequencer-grid {
                            grid-template-columns: 100px repeat(16, 40px);
                            gap: 2px;
                        }

                        .track-label {
                            font-size: 0.75rem;
                            padding: 0.5rem;
                        }

                        .track-name {
                            font-size: 0.7rem;
                        }

                        .track-volume {
                            width: 40px !important;
                        }

                        .mute-btn {
                            width: 24px;
                            height: 24px;
                            font-size: 0.75rem;
                        }

                        .drum-controls {
                            justify-content: center;
                        }

                        .pattern-actions {
                            justify-content: center;
                        }

                        .shortcuts-hint {
                            display: none;
                        }
                    }

                    @media (max-width: 480px) {
                        .sequencer-grid {
                            grid-template-columns: 80px repeat(16, 35px);
                            min-width: 660px;
                        }

                        .track-label-content {
                            flex-wrap: wrap;
                            gap: 0.25rem;
                        }

                        .track-volume {
                            width: 100% !important;
                            order: 3;
                        }

                        .action-btn {
                            padding: 0.5rem 0.75rem;
                            font-size: 0.8rem;
                        }
                    }
                </style>
        </head>

        <body>
            <%@ include file="../modern/components/nav-header.jsp" %>

                <header class="tool-page-header">
                        <div class="tool-page-header-inner">
                            <div>
                                <h1 class="tool-page-title">Drum Machine</h1>
                                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Create
                                    beats online - 16-step sequencer with multiple drum kits</p>
                                <nav class="tool-breadcrumbs">
                                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                    <a href="<%=request.getContextPath()%>/music/">Music Tools</a> /
                                    Drum Machine
                                </nav>
                            </div>
                        </div>
                    </header>

                    <%@ include file="../modern/ads/ad-leaderboard.jsp" %>

                        <main class="drum-container">

                            <!-- Controls -->
                            <div class="drum-controls">
                                <button class="play-btn" id="playBtn">
                                    <span>▶️</span>
                                    <span>Play</span>
                                </button>

                                <div class="control-group">
                                    <label class="control-label">BPM:</label>
                                    <input type="number" class="control-input" id="bpmInput" value="120" min="40"
                                        max="240" style="width: 80px;">
                                </div>

                                <div class="control-group">
                                    <label class="control-label">Kit:</label>
                                    <select class="control-select" id="kitSelect">
                                        <option value="acoustic">Acoustic</option>
                                        <option value="electronic">Electronic</option>
                                        <option value="808">808</option>
                                        <option value="trap">Trap</option>
                                    </select>
                                </div>

                                <div class="control-group">
                                    <label class="control-label">Swing:</label>
                                    <input type="range" class="control-input" id="swingSlider" min="0" max="100"
                                        value="0" style="width: 100px;">
                                    <span id="swingValue">0%</span>
                                </div>

                                <button class="tap-tempo-btn" id="tapTempoBtn" title="Tap to set tempo">
                                    👆 Tap Tempo
                                </button>
                            </div>

                            <!-- Sequencer -->
                            <div class="sequencer-wrapper">
                                <div class="sequencer-grid" id="sequencerGrid"></div>
                            </div>

                            <!-- Pattern Actions -->
                            <div class="pattern-actions">
                                <button class="action-btn" id="clearBtn">🗑️ Clear</button>
                                <button class="action-btn" id="randomBtn">🎲 Randomize</button>
                                <button class="action-btn" id="copyBtn">📋 Copy JSON</button>
                                <button class="action-btn" id="savePatternBtn">💾 Save</button>
                                <button class="action-btn" id="loadPatternBtn">📂 Load</button>
                                <button class="action-btn primary" id="sharePatternBtn">🔗 Share</button>
                            </div>

                            <!-- Keyboard Shortcuts Help -->
                            <div class="shortcuts-hint">
                                <span>⌨️ Shortcuts:</span>
                                <span><kbd>Space</kbd> Play/Stop</span>
                                <span><kbd>1-8</kbd> Play Sounds</span>
                            </div>

                            <%@ include file="../modern/ads/ad-mobile-banner.jsp" %>

                                <!-- Preset Patterns -->
                                <div class="preset-patterns">
                                    <h3>Preset Patterns</h3>
                                    <div class="preset-grid">
                                        <button class="preset-btn" data-preset="basic">
                                            <div class="preset-name">Basic Rock</div>
                                            <div class="preset-desc">Classic 4/4 rock beat</div>
                                        </button>
                                        <button class="preset-btn" data-preset="hiphop">
                                            <div class="preset-name">Hip Hop</div>
                                            <div class="preset-desc">Boom bap pattern</div>
                                        </button>
                                        <button class="preset-btn" data-preset="house">
                                            <div class="preset-name">House</div>
                                            <div class="preset-desc">Four-on-the-floor</div>
                                        </button>
                                        <button class="preset-btn" data-preset="trap">
                                            <div class="preset-name">Trap</div>
                                            <div class="preset-desc">Modern trap hi-hats</div>
                                        </button>
                                        <button class="preset-btn" data-preset="dnb">
                                            <div class="preset-name">Drum & Bass</div>
                                            <div class="preset-desc">Fast breakbeat</div>
                                        </button>
                                        <button class="preset-btn" data-preset="funk">
                                            <div class="preset-name">Funk</div>
                                            <div class="preset-desc">Syncopated groove</div>
                                        </button>
                                    </div>
                                </div>

                                <!-- SEO Content -->
                                <section class="tool-expertise-section" style="margin-top: 4rem;">
                                    <h2>Free Online Drum Machine</h2>
                                    <p>Create professional drum patterns with our free online drum machine and beat
                                        maker. This 16-step sequencer features multiple drum kits, tempo control, swing
                                        adjustment, and preset patterns. Perfect for music producers, beatmakers, and
                                        anyone learning rhythm programming.</p>

                                    <h3 style="margin-top: 2rem;">How to Use the Drum Machine</h3>
                                    <ol
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li>Click on the grid cells to activate drum hits</li>
                                        <li>Each row represents a different drum sound (kick, snare, hi-hat, etc.)</li>
                                        <li>Each column represents a step in the 16-step sequence</li>
                                        <li>Click Play to hear your pattern loop</li>
                                        <li>Adjust BPM (tempo) to speed up or slow down</li>
                                        <li>Try different drum kits for various sounds</li>
                                        <li>Use preset patterns as starting points</li>
                                    </ol>

                                    <h3 style="margin-top: 2rem;">Drum Sounds Explained</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>Kick (Bass Drum):</strong> The low, punchy sound that drives the
                                            beat</li>
                                        <li><strong>Snare:</strong> Sharp, cracking sound typically on beats 2 and 4
                                        </li>
                                        <li><strong>Closed Hi-Hat:</strong> Short, tight cymbal sound for rhythm</li>
                                        <li><strong>Open Hi-Hat:</strong> Longer, ringing cymbal sound</li>
                                        <li><strong>Clap:</strong> Hand clap sound, often used with or instead of snare
                                        </li>
                                        <li><strong>Tom:</strong> Melodic drum sound for fills</li>
                                        <li><strong>Crash:</strong> Loud cymbal for accents and transitions</li>
                                        <li><strong>Rim:</strong> Rim shot or percussion accent</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Beat Making Tips</h3>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>Start Simple:</strong> Begin with kick and snare, then add hi-hats
                                        </li>
                                        <li><strong>Use the Grid:</strong> Steps 1, 5, 9, 13 are strong beats
                                            (downbeats)</li>
                                        <li><strong>Snare Placement:</strong> Typically on beats 2 and 4 (steps 5 and
                                            13)</li>
                                        <li><strong>Hi-Hat Patterns:</strong> 8th notes (every other step) or 16th notes
                                            (every step)</li>
                                        <li><strong>Add Variation:</strong> Remove or add hits to create dynamics</li>
                                        <li><strong>Experiment with Swing:</strong> Add groove by delaying off-beat hits
                                        </li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">Common Drum Patterns</h3>
                                    <p><strong>Basic Rock Beat:</strong> Kick on 1 and 9, snare on 5 and 13, hi-hats on
                                        every other step</p>
                                    <p><strong>Four-on-the-Floor (House):</strong> Kick on every beat (1, 5, 9, 13),
                                        hi-hats on off-beats</p>
                                    <p><strong>Hip-Hop Boom Bap:</strong> Kick on 1 and 11, snare on 5 and 13, hi-hats
                                        scattered</p>
                                    <p><strong>Trap:</strong> Kick on 1, snare on 5 and 13, rapid hi-hat rolls</p>

                                    <h3 style="margin-top: 2rem;">Understanding BPM and Tempo</h3>
                                    <p>BPM (Beats Per Minute) controls how fast your pattern plays:</p>
                                    <ul
                                        style="padding-left: 1.5rem; margin-top: 0.75rem; color: var(--text-secondary);">
                                        <li><strong>60-80 BPM:</strong> Slow (ballads, downtempo)</li>
                                        <li><strong>80-100 BPM:</strong> Medium-slow (hip-hop, R&B)</li>
                                        <li><strong>100-120 BPM:</strong> Medium (pop, rock)</li>
                                        <li><strong>120-140 BPM:</strong> Fast (house, techno)</li>
                                        <li><strong>140-180 BPM:</strong> Very fast (drum & bass, hardcore)</li>
                                    </ul>

                                    <h3 style="margin-top: 2rem;">What is Swing?</h3>
                                    <p>Swing adds a "shuffle" feel to your beat by slightly delaying the off-beat notes.
                                        This creates a more human, groovy feel. Try 20-40% swing for a subtle groove, or
                                        60-80% for a heavy shuffle feel.</p>
                                </section>

                        </main>

                        <jsp:include page="../modern/components/related-tools.jsp">
                            <jsp:param name="currentToolUrl" value="music/drum-machine.jsp" />
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
                                        src="<%=request.getContextPath()%>/music/js/drum-machine.js?v=<%=cacheVersion%>"></script>
        </body>

        </html>