/**
 * Quick Math Topics - Trains & Relative Speed
 */

(function registerTrainTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'trains-relative-meeting': {
            id: 'trains-relative-meeting',
            category: 'Word Problems',
            tags: ['trains', 'speed'],
            title: 'Trains Meeting Problems | Relative Speed Trick',
            ctrHeadline: 'Solve Train Meeting Questions in 10 Seconds! 🚄',
            description: 'Master relative speed concepts for trains meeting in opposite directions. Essential word problem trick for SSC, Banking, Railway quantitative aptitude.',
            difficulty: 'Intermediate',
            formula: 'Relative Speed = Speed₁ + Speed₂',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Trains moving <strong>towards each other</strong>? They're closing the gap faster!</p>

                    <!-- SVG Train Meeting Visual -->
                    <svg viewBox="0 0 400 140" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <defs>
                            <marker id="arrow-train" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                            </marker>
                        </defs>
                        
                        <!-- Track -->
                        <line x1="50" y1="70" x2="350" y2="70" stroke="var(--text-secondary, #666)" stroke-width="4"/>
                        <line x1="50" y1="75" x2="350" y2="75" stroke="var(--text-secondary, #666)" stroke-width="4"/>
                        
                        <!-- Train A (left) -->
                        <rect x="70" y="50" width="50" height="20" rx="3" fill="var(--accent-primary, #6366f1)"/>
                        <text x="95" y="65" font-size="14" font-weight="bold" fill="#fff" text-anchor="middle">A</text>
                        <text x="95" y="40" font-size="12" fill="var(--accent-primary, #6366f1)" text-anchor="middle">60 km/h</text>
                        
                        <!-- Arrow A -->
                        <line x1="125" y1="60" x2="155" y2="60" stroke="var(--warning, #f59e0b)" stroke-width="2" marker-end="url(#arrow-train)"/>
                        
                        <!-- Train B (right) -->
                        <rect x="280" y="50" width="50" height="20" rx="3" fill="var(--success, #22c55e)"/>
                        <text x="305" y="65" font-size="14" font-weight="bold" fill="#fff" text-anchor="middle">B</text>
                        <text x="305" y="40" font-size="12" fill="var(--success, #22c55e)" text-anchor="middle">40 km/h</text>
                        
                        <!-- Arrow B -->
                        <line x1="275" y1="60" x2="245" y2="60" stroke="var(--warning, #f59e0b)" stroke-width="2" marker-end="url(#arrow-train)"/>
                        
                        <!-- Distance label -->
                        <text x="200" y="100" font-size="14" fill="var(--text-secondary, #888)" text-anchor="middle">Distance: 200 km</text>
                        
                        <!-- Result -->
                        <text x="200" y="125" font-size="16" fill="var(--warning, #f59e0b)" text-anchor="middle" font-weight="bold">
                            Relative Speed = 60 + 40 = 100 km/h
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Train A: 60 km/h, Train B: 40 km/h, Distance: 200 km. When do they meet?</div>
                        <div class="step">Step 1: Add speeds (opposite directions) → 60 + 40 = <strong>100 km/h</strong></div>
                        <div class="step">Step 2: Time = Distance ÷ Speed → 200 ÷ 100 = <strong>2 hours</strong></div>
                        <div class="result">Answer: 2 hours</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const s1 = (Math.floor(Math.random() * 6) + 4) * 10; // 40-90
                const s2 = (Math.floor(Math.random() * 6) + 4) * 10;
                const time = Math.floor(Math.random() * 4) + 2; // 2-5 hours
                const dist = (s1 + s2) * time;
                return {
                    text: `Train A at ${s1} km/h, B at ${s2} km/h, ${dist} km apart. When meet (hours)?`,
                    answer: time
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'trains-relative-overtake': {
            id: 'trains-relative-overtake',
            category: 'Word Problems',
            tags: ['trains', 'speed'],
            title: 'Trains Overtaking Trick | Subtract Speeds',
            ctrHeadline: 'Solve Overtaking Problems Mentally! ⚡',
            description: 'Learn the relative speed subtraction trick for trains moving in the same direction. Solve overtaking problems without formulas - essential for SSC, Banking.',
            difficulty: 'Intermediate',
            formula: 'Relative Speed = Speed₁ - Speed₂',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Trains moving <strong>same direction</strong>? The faster train is closing in slowly.</p>

                    <!-- SVG Train Overtaking Visual -->
                    <svg viewBox="0 0 400 140" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <defs>
                            <marker id="arrow-same" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                            </marker>
                        </defs>
                        
                        <!-- Track -->
                        <line x1="50" y1="70" x2="350" y2="70" stroke="var(--text-secondary, #666)" stroke-width="4"/>
                        <line x1="50" y1="75" x2="350" y2="75" stroke="var(--text-secondary, #666)" stroke-width="4"/>
                        
                        <!-- Fast Train (behind) -->
                        <rect x="70" y="50" width="50" height="20" rx="3" fill="var(--success, #22c55e)"/>
                        <text x="95" y="65" font-size="14" font-weight="bold" fill="#fff" text-anchor="middle">Fast</text>
                        <text x="95" y="40" font-size="12" fill="var(--success, #22c55e)" text-anchor="middle">80 km/h</text>
                        
                        <!-- Arrow Fast -->
                        <line x1="125" y1="60" x2="180" y2="60" stroke="var(--warning, #f59e0b)" stroke-width="3" marker-end="url(#arrow-same)"/>
                        
                        <!-- Slow Train (ahead) -->
                        <rect x="240" y="50" width="50" height="20" rx="3" fill="var(--accent-primary, #6366f1)"/>
                        <text x="265" y="65" font-size="14" font-weight="bold" fill="#fff" text-anchor="middle">Slow</text>
                        <text x="265" y="40" font-size="12" fill="var(--accent-primary, #6366f1)" text-anchor="middle">60 km/h</text>
                        
                        <!-- Arrow Slow -->
                        <line x1="295" y1="60" x2="325" y2="60" stroke="var(--text-muted, #888)" stroke-width="2" marker-end="url(#arrow-same)"/>
                        
                        <!-- Result -->
                        <text x="200" y="115" font-size="16" fill="var(--warning, #f59e0b)" text-anchor="middle" font-weight="bold">
                            Relative Speed = 80 - 60 = 20 km/h
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Fast train: 80 km/h, Slow: 60 km/h, 100 km gap. When does fast overtake?</div>
                        <div class="step">Step 1: Subtract speeds (same direction) → 80 - 60 = <strong>20 km/h</strong></div>
                        <div class="step">Step 2: Time = Distance ÷ Speed → 100 ÷ 20 = <strong>5 hours</strong></div>
                        <div class="result">Answer: 5 hours</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const fast = (Math.floor(Math.random() * 5) + 6) * 10; // 60-100
                const slow = fast - (Math.floor(Math.random() * 3) + 2) * 10; // 20-30 less
                const time = Math.floor(Math.random() * 4) + 2;
                const dist = (fast - slow) * time;
                return {
                    text: `Fast: ${fast} km/h, Slow: ${slow} km/h, ${dist} km gap. Overtake time (hours)?`,
                    answer: time
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'trains-platform': {
            id: 'trains-platform',
            category: 'Word Problems',
            tags: ['trains', 'length'],
            title: 'Train Crossing Platform Formula | Total Distance',
            ctrHeadline: 'Platform Crossing? Just Add the Lengths! 🚉',
            description: 'Master the train crossing platform formula (Train + Platform Length) for competitive exams. Solve time and distance problems instantly for SSC, Banking.',
            difficulty: 'Intermediate',
            formula: 'Total Distance = Train Length + Platform Length',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">The train must <strong>completely pass</strong> the platform, so add both lengths!</p>

                    <!-- SVG Platform Crossing Visual -->
                    <svg viewBox="0 0 400 160" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <!-- Platform -->
                        <rect x="150" y="80" width="200" height="40" fill="var(--bg-tertiary, #333)" stroke="var(--border, #555)" stroke-width="2"/>
                        <text x="250" y="125" font-size="14" fill="var(--text-secondary, #888)" text-anchor="middle">Platform: 300m</text>
                        
                        <!-- Train -->
                        <rect x="50" y="50" width="100" height="30" rx="3" fill="var(--accent-primary, #6366f1)"/>
                        <text x="100" y="70" font-size="14" font-weight="bold" fill="#fff" text-anchor="middle">Train</text>
                        <text x="100" y="40" font-size="12" fill="var(--accent-primary, #6366f1)" text-anchor="middle">200m, 60 km/h</text>
                        
                        <!-- Movement Arrow -->
                        <defs>
                            <marker id="arrow-platform" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                            </marker>
                        </defs>
                        <line x1="155" y1="65" x2="340" y2="65" stroke="var(--warning, #f59e0b)" stroke-width="3" marker-end="url(#arrow-platform)"/>
                        
                        <!-- Distance calculation -->
                        <text x="200" y="150" font-size="14" fill="var(--success, #22c55e)" text-anchor="middle" font-weight="bold">
                            Total Distance = 200 + 300 = 500m
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Train: 200m long, 60 km/h. Platform: 300m. Time to cross?</div>
                        <div class="step">Step 1: Total distance = Train + Platform → 200 + 300 = <strong>500m</strong></div>
                        <div class="step">Step 2: Convert speed → 60 km/h = 60000m/60min = <strong>1000 m/min</strong></div>
                        <div class="step">Step 3: Time = 500 ÷ 1000 = <strong>0.5 min</strong> = 30 sec</div>
                        <div class="result">Answer: 30 seconds</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const trainLen = (Math.floor(Math.random() * 3) + 1) * 100; // 100-300
                const platformLen = (Math.floor(Math.random() * 4) + 2) * 100; // 200-500
                const speedKmh = (Math.floor(Math.random() * 4) + 4) * 10; // 40-70
                const speedMs = (speedKmh * 1000) / 3600; // m/s
                const time = (trainLen + platformLen) / speedMs;
                return {
                    text: `Train: ${trainLen}m, ${speedKmh} km/h. Platform: ${platformLen}m. Time (seconds)?`,
                    answer: Math.round(time)
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseInt(userAns) - correctAns) <= 1
        },
        'trains-speed-conversion': {
            id: 'trains-speed-conversion',
            category: 'Word Problems',
            tags: ['trains', 'speed', 'conversion'],
            title: 'Speed Conversion Trick | km/h to m/s',
            ctrHeadline: 'Convert km/h to m/s in ONE Second! ⚡',
            description: 'Memorize the 5/18 and 18/5 magic multipliers for speed conversion. Essential zero-calculation trick for SSC, Banking, Railway train problems.',
            difficulty: 'Beginner',
            formula: 'km/h → m/s: ×(5/18) | m/s → km/h: ×(18/5)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Train problems love mixing units. Master this conversion!</p>
                    
                    <div class="example-box">
                        <div class="problem">Convert 72 km/h to m/s</div>
                        <div class="step">Step 1: Multiply by 5/18 → 72 × 5 = 360</div>
                        <div class="step">Step 2: Divide by 18 → 360 ÷ 18 = <strong>20 m/s</strong></div>
                        <div class="result">Answer: 20 m/s</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Convert 15 m/s to km/h</div>
                        <div class="step">Step 1: Multiply by 18/5 → 15 × 18 = 270</div>
                        <div class="step">Step 2: Divide by 5 → 270 ÷ 5 = <strong>54 km/h</strong></div>
                        <div class="result">Answer: 54 km/h</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Why?</strong> 1 km = 1000m, 1 hour = 3600s, so 1 km/h = 1000/3600 = 5/18 m/s
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const isKmToM = Math.random() > 0.5;
                if (isKmToM) {
                    const kmh = (Math.floor(Math.random() * 10) + 4) * 18; // Multiples of 18
                    const ms = (kmh * 5) / 18;
                    return {
                        text: `Convert ${kmh} km/h to m/s`,
                        answer: ms
                    };
                } else {
                    const ms = (Math.floor(Math.random() * 15) + 5) * 5; // Multiples of 5
                    const kmh = (ms * 18) / 5;
                    return {
                        text: `Convert ${ms} m/s to km/h`,
                        answer: kmh
                    };
                }
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'trains-passing': {
            id: 'trains-passing',
            category: 'Word Problems',
            tags: ['trains', 'speed', 'advanced'],
            title: 'Trains Passing Problems | Combined Length',
            ctrHeadline: 'Solve Train Crossing Problems Like a Pro! 🚅',
            description: 'Master advanced train passing problems by combining lengths and relative speeds. Essential technique for complex SSC CGL, Banking, Railway questions.',
            difficulty: 'Advanced',
            formula: 'Distance = Length₁ + Length₂, Speed = Relative Speed',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For trains to <strong>completely pass</strong>, add both lengths and use relative speed.</p>

                    <div class="example-box">
                        <div class="problem">Train A: 120m, 54 km/h. Train B: 180m, 36 km/h (opposite). Time to pass?</div>
                        <div class="step">Step 1: Combined length → 120 + 180 = <strong>300m</strong></div>
                        <div class="step">Step 2: Relative speed (opposite) → 54 + 36 = <strong>90 km/h</strong></div>
                        <div class="step">Step 3: Convert to m/s → 90 × 5/18 = <strong>25 m/s</strong></div>
                        <div class="step">Step 4: Time = 300m ÷ 25 m/s = <strong>12 seconds</strong></div>
                        <div class="result">Answer: 12 seconds</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Remember:</strong> Opposite directions? Add speeds. Same direction? Subtract speeds.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const len1 = (Math.floor(Math.random() * 3) + 1) * 60; // 60-180
                const len2 = (Math.floor(Math.random() * 3) + 1) * 60;
                const s1 = (Math.floor(Math.random() * 4) + 3) * 18; // Multiples of 18
                const s2 = (Math.floor(Math.random() * 4) + 2) * 18;
                const isOpposite = Math.random() > 0.5;
                const relSpeed = isOpposite ? s1 + s2 : Math.abs(s1 - s2);
                const relSpeedMs = (relSpeed * 5) / 18;
                const time = (len1 + len2) / relSpeedMs;
                return {
                    text: `A: ${len1}m, ${s1} km/h. B: ${len2}m, ${s2} km/h (${isOpposite ? 'opposite' : 'same'}). Pass time (sec)?`,
                    answer: Math.round(time)
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseInt(userAns) - correctAns) <= 1
        }
    });
})();
