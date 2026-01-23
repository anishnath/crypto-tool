/**
 * Quick Math Topics - Data Analysis & Statistics
 */

(function registerDataTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'data-mean-shortcut': {
            id: 'data-mean-shortcut',
            category: 'Data Analysis',
            tags: ['data', 'average', 'statistics'],
            title: 'Mean (Average) Shortcut | Deviation Method',
            ctrHeadline: 'Calculate Average Without Adding Numbers! 📊',
            description: 'Master the deviation method to find the mean (average) quickly for competitive exams. Avoid big calculations with this statistical trick - SSC, Banking.',
            difficulty: 'Intermediate',
            formula: 'Mean = Base + (Sum of deviations / Count)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Don't add big numbers! Use the <strong>deviation method</strong> for quick averages.</p>

                    <div class="example-box">
                        <div class="problem">Find average of 48, 52, 47, 53, 50</div>
                        <div class="step">Step 1: Pick base = 50 (middle value)</div>
                        <div class="step">Step 2: Deviations: -2, +2, -3, +3, 0</div>
                        <div class="step">Step 3: Sum of deviations = 0</div>
                        <div class="step">Step 4: Mean = 50 + (0/5) = <strong>50</strong></div>
                        <div class="result">Average: 50</div>
                    </div>

                    <!-- SVG Deviation Visualization -->
                    <svg viewBox="0 0 400 120" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Base line -->
                            <line x1="40" y1="60" x2="360" y2="60" stroke="var(--warning, #f59e0b)" stroke-width="3"/>
                            <text x="200" y="50" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">Base = 50</text>
                            
                            <!-- Values above and below -->
                            <circle cx="100" cy="75" r="8" fill="var(--danger, #ef4444)"/>
                            <text x="100" y="95" font-size="12" fill="var(--danger, #ef4444)">48 (-2)</text>
                            
                            <circle cx="160" cy="45" r="8" fill="var(--success, #22c55e)"/>
                            <text x="160" y="35" font-size="12" fill="var(--success, #22c55e)">52 (+2)</text>
                            
                            <circle cx="220" cy="78" r="8" fill="var(--danger, #ef4444)"/>
                            <text x="220" y="98" font-size="12" fill="var(--danger, #ef4444)">47 (-3)</text>
                            
                            <circle cx="280" cy="42" r="8" fill="var(--success, #22c55e)"/>
                            <text x="280" y="32" font-size="12" fill="var(--success, #22c55e)">53 (+3)</text>
                            
                            <circle cx="340" cy="60" r="8" fill="var(--accent-primary, #6366f1)"/>
                            <text x="340" y="80" font-size="12" fill="var(--accent-primary, #6366f1)">50 (0)</text>
                        </g>
                        
                        <text x="200" y="115" text-anchor="middle" font-size="12" fill="var(--text-secondary, #888)">
                            Deviations cancel out → Mean = Base
                        </text>
                    </svg>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Pro tip:</strong> Choose base near middle for smaller deviations!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const base = (Math.floor(Math.random() * 10) + 5) * 10; // 50-140
                const deviations = [-3, -2, 0, 2, 3];
                const values = deviations.map(d => base + d);
                const mean = values.reduce((a, b) => a + b, 0) / values.length;
                return {
                    text: `Average of ${values.join(', ')}?`,
                    answer: mean
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'data-median': {
            id: 'data-median',
            category: 'Data Analysis',
            tags: ['data', 'median', 'statistics'],
            title: 'Median Formula | Finding the Middle Value',
            ctrHeadline: 'Find the Median in Seconds! (Odd & Even) ↔️',
            description: 'Master finding the median for odd and even datasets for competitive exams. Learn to sort and pick the middle value instantly - SSC, Banking, Railway.',
            difficulty: 'Beginner',
            formula: 'Median = Middle value (after sorting)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Median is the <strong>middle value</strong> when data is sorted!</p>

                    <!-- SVG Odd Count -->
                    <svg viewBox="0 0 400 100" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <text x="200" y="20" font-size="14" fill="var(--text-secondary, #888)">Odd count (5 numbers)</text>
                            
                            <circle cx="80" cy="50" r="15" fill="var(--accent-primary, #6366f1)" opacity="0.3"/>
                            <text x="80" y="55" font-size="14" fill="var(--text-primary, #ddd)">12</text>
                            
                            <circle cx="140" cy="50" r="15" fill="var(--accent-primary, #6366f1)" opacity="0.3"/>
                            <text x="140" y="55" font-size="14" fill="var(--text-primary, #ddd)">15</text>
                            
                            <circle cx="200" cy="50" r="18" fill="var(--success, #22c55e)" opacity="0.8"/>
                            <text x="200" y="55" font-size="16" fill="white" font-weight="bold">18</text>
                            <text x="200" y="85" font-size="12" fill="var(--success, #22c55e)" font-weight="bold">MEDIAN</text>
                            
                            <circle cx="260" cy="50" r="15" fill="var(--accent-primary, #6366f1)" opacity="0.3"/>
                            <text x="260" y="55" font-size="14" fill="var(--text-primary, #ddd)">22</text>
                            
                            <circle cx="320" cy="50" r="15" fill="var(--accent-primary, #6366f1)" opacity="0.3"/>
                            <text x="320" y="55" font-size="14" fill="var(--text-primary, #ddd)">25</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Find median of 23, 15, 12, 25, 18, 22 (even count)</div>
                        <div class="step">Step 1: Sort → 12, 15, 18, 22, 23, 25</div>
                        <div class="step">Step 2: Middle two values → 18, 22</div>
                        <div class="step">Step 3: Median = (18 + 22) / 2 = <strong>20</strong></div>
                        <div class="result">Median: 20</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const isOdd = Math.random() > 0.5;
                const count = isOdd ? 5 : 6;
                const values = [];
                for (let i = 0; i < count; i++) {
                    values.push(Math.floor(Math.random() * 30) + 10);
                }
                values.sort((a, b) => a - b);
                const median = isOdd
                    ? values[Math.floor(count / 2)]
                    : (values[count / 2 - 1] + values[count / 2]) / 2;

                // Shuffle for question
                const shuffled = [...values].sort(() => Math.random() - 0.5);
                return {
                    text: `Median of ${shuffled.join(', ')}?`,
                    answer: median
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'data-mode': {
            id: 'data-mode',
            category: 'Data Analysis',
            tags: ['data', 'mode', 'statistics'],
            title: 'Mode Formula | Most Frequent Value',
            ctrHeadline: 'Find the Most Frequent Number Instantly! 🔝',
            description: 'Master finding the mode (most frequent value) in a dataset for competitive exams. Simple statistics concept essential for SSC CGL, Banking, Railway.',
            difficulty: 'Beginner',
            formula: 'Mode = Most frequently occurring value',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Mode = <strong>Most common</strong> value. Count the frequencies!</p>

                    <!-- SVG Frequency Chart -->
                    <svg viewBox="0 0 400 140" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <text x="200" y="20" font-size="14" fill="var(--text-secondary, #888)">Data: 12, 15, 12, 18, 12, 20</text>
                            
                            <!-- Bar for 12 -->
                            <rect x="50" y="40" width="40" height="60" fill="var(--success, #22c55e)" opacity="0.8"/>
                            <text x="70" y="110" font-size="12" fill="var(--text-primary, #ddd)">12</text>
                            <text x="70" y="125" font-size="11" fill="var(--success, #22c55e)" font-weight="bold">3 times</text>
                            
                            <!-- Bar for 15 -->
                            <rect x="130" y="80" width="40" height="20" fill="var(--accent-primary, #6366f1)" opacity="0.5"/>
                            <text x="150" y="110" font-size="12" fill="var(--text-primary, #ddd)">15</text>
                            <text x="150" y="125" font-size="11" fill="var(--text-secondary, #888)">1 time</text>
                            
                            <!-- Bar for 18 -->
                            <rect x="210" y="80" width="40" height="20" fill="var(--accent-primary, #6366f1)" opacity="0.5"/>
                            <text x="230" y="110" font-size="12" fill="var(--text-primary, #ddd)">18</text>
                            <text x="230" y="125" font-size="11" fill="var(--text-secondary, #888)">1 time</text>
                            
                            <!-- Bar for 20 -->
                            <rect x="290" y="80" width="40" height="20" fill="var(--accent-primary, #6366f1)" opacity="0.5"/>
                            <text x="310" y="110" font-size="12" fill="var(--text-primary, #ddd)">20</text>
                            <text x="310" y="125" font-size="11" fill="var(--text-secondary, #888)">1 time</text>
                            
                            <!-- Mode label -->
                            <text x="70" y="35" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">MODE</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Find mode of 5, 8, 5, 12, 8, 5, 6</div>
                        <div class="step">Step 1: Count frequencies → 5 appears 3 times, 8 appears 2 times</div>
                        <div class="step">Step 2: Most frequent = <strong>5</strong></div>
                        <div class="result">Mode: 5</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Note:</strong> Can have multiple modes (bimodal, multimodal) or no mode if all frequencies are equal!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const mode = Math.floor(Math.random() * 20) + 10;
                const values = [mode, mode, mode]; // Mode appears 3 times

                // Add other unique values
                for (let i = 0; i < 4; i++) {
                    let val = Math.floor(Math.random() * 20) + 10;
                    while (val === mode) val = Math.floor(Math.random() * 20) + 10;
                    values.push(val);
                }

                const shuffled = [...values].sort(() => Math.random() - 0.5);
                return {
                    text: `Mode of ${shuffled.join(', ')}?`,
                    answer: mode
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'data-range': {
            id: 'data-range',
            category: 'Data Analysis',
            tags: ['data', 'statistics'],
            title: 'Range Statistic Formula | Max - Min',
            ctrHeadline: 'Calculate Data Range (Max - Min) Quickly! 📏',
            description: 'Master calculating the range of a dataset for competitive exams. Simple subtraction of minimum from maximum value - key statistics concept.',
            difficulty: 'Beginner',
            formula: 'Range = Maximum - Minimum',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Range measures <strong>spread</strong>. Find max and min, then subtract!</p>

                    <!-- SVG Range Visualization -->
                    <svg viewBox="0 0 400 100" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace">
                            <!-- Number line -->
                            <line x1="50" y1="50" x2="350" y2="50" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                            
                            <!-- Min -->
                            <circle cx="80" cy="50" r="12" fill="var(--accent-primary, #6366f1)"/>
                            <text x="80" y="55" text-anchor="middle" font-size="12" fill="white" font-weight="bold">12</text>
                            <text x="80" y="75" text-anchor="middle" font-size="11" fill="var(--accent-primary, #6366f1)">MIN</text>
                            
                            <!-- Max -->
                            <circle cx="320" cy="50" r="12" fill="var(--success, #22c55e)"/>
                            <text x="320" y="55" text-anchor="middle" font-size="12" fill="white" font-weight="bold">28</text>
                            <text x="320" y="75" text-anchor="middle" font-size="11" fill="var(--success, #22c55e)">MAX</text>
                            
                            <!-- Range bracket -->
                            <line x1="80" y1="30" x2="320" y2="30" stroke="var(--warning, #f59e0b)" stroke-width="3"/>
                            <line x1="80" y1="25" x2="80" y2="35" stroke="var(--warning, #f59e0b)" stroke-width="3"/>
                            <line x1="320" y1="25" x2="320" y2="35" stroke="var(--warning, #f59e0b)" stroke-width="3"/>
                            <text x="200" y="20" text-anchor="middle" font-size="13" fill="var(--warning, #f59e0b)" font-weight="bold">Range = 28 - 12 = 16</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Find range of 45, 32, 56, 41, 38, 52</div>
                        <div class="step">Step 1: Max = 56</div>
                        <div class="step">Step 2: Min = 32</div>
                        <div class="step">Step 3: Range = 56 - 32 = <strong>24</strong></div>
                        <div class="result">Range: 24</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const min = Math.floor(Math.random() * 30) + 10;
                const range = Math.floor(Math.random() * 20) + 10;
                const max = min + range;
                const values = [min, max];

                // Add middle values
                for (let i = 0; i < 4; i++) {
                    values.push(Math.floor(Math.random() * (max - min)) + min);
                }

                const shuffled = [...values].sort(() => Math.random() - 0.5);
                return {
                    text: `Range of ${shuffled.join(', ')}?`,
                    answer: range
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'data-weighted-average': {
            id: 'data-weighted-average',
            category: 'Data Analysis',
            tags: ['data', 'average', 'weighted'],
            title: 'Weighted Average Formula | Mean',
            ctrHeadline: 'Calculate Weighted Mean Like a Pro! ⚖️',
            description: 'Master weighted average calculations for competitive exams. Handle values with different importance (weights) easily - essential for SSC, Banking.',
            difficulty: 'Intermediate',
            formula: 'Weighted Avg = Σ(value × weight) / Σ(weights)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Each value has a <strong>weight</strong> (importance). Multiply and sum!</p>

                    <div class="example-box">
                        <div class="problem">Exam scores: 80 (weight 3), 90 (weight 2), 70 (weight 1). Weighted average?</div>
                        <div class="step">Step 1: Multiply each score by weight</div>
                        <div class="step">→ (80 × 3) + (90 × 2) + (70 × 1)</div>
                        <div class="step">→ 240 + 180 + 70 = <strong>490</strong></div>
                        <div class="step">Step 2: Sum of weights = 3 + 2 + 1 = <strong>6</strong></div>
                        <div class="step">Step 3: Weighted avg = 490 / 6 = <strong>81.67</strong></div>
                        <div class="result">Weighted Average: 81.67</div>
                    </div>

                    <!-- SVG Weight Visualization -->
                    <svg viewBox="0 0 400 100" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Weight 3 -->
                            <circle cx="80" cy="50" r="25" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="80" y="45" font-size="14" fill="var(--accent-primary, #6366f1)" font-weight="bold">80</text>
                            <text x="80" y="60" font-size="11" fill="var(--text-secondary, #888)">weight: 3</text>
                            
                            <!-- Weight 2 -->
                            <circle cx="200" cy="50" r="20" fill="var(--success, #22c55e)" opacity="0.2"/>
                            <text x="200" y="45" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">90</text>
                            <text x="200" y="60" font-size="11" fill="var(--text-secondary, #888)">weight: 2</text>
                            
                            <!-- Weight 1 -->
                            <circle cx="320" cy="50" r="15" fill="var(--warning, #f59e0b)" opacity="0.2"/>
                            <text x="320" y="45" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">70</text>
                            <text x="320" y="60" font-size="11" fill="var(--text-secondary, #888)">weight: 1</text>
                        </g>
                        
                        <text x="200" y="90" text-anchor="middle" font-size="12" fill="var(--text-secondary, #888)">
                            Larger circle = more weight/importance
                        </text>
                    </svg>
                </div>
            `,
            generateQuestion: () => {
                const v1 = (Math.floor(Math.random() * 4) + 6) * 10; // 60-90
                const v2 = (Math.floor(Math.random() * 4) + 6) * 10;
                const w1 = Math.floor(Math.random() * 3) + 2; // 2-4
                const w2 = Math.floor(Math.random() * 3) + 1; // 1-3
                const weighted = (v1 * w1 + v2 * w2) / (w1 + w2);
                return {
                    text: `Weighted avg: ${v1} (weight ${w1}), ${v2} (weight ${w2})?`,
                    answer: Math.round(weighted * 100) / 100
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 0.5
        }
    });
})();
