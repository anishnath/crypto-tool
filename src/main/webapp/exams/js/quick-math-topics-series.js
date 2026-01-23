/**
 * Quick Math Topics - Number Series & Progressions
 */

(function registerSeriesTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'series-ap-basics': {
            id: 'series-ap-basics',
            category: 'Number Series',
            tags: ['series', 'sequence', 'ap'],
            title: 'Arithmetic Progression (AP) | nth term',
            ctrHeadline: 'Find any term in an AP instantly!',
            description: 'AP has a constant difference. Use the formula: nth term = a + (n-1)d',
            difficulty: 'Intermediate',
            formula: 'aₙ = a + (n-1)d',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">In AP, each term increases by a <strong>constant difference (d)</strong>.</p>

                    <!-- SVG AP Visualization -->
                    <svg viewBox="0 0 400 120" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Terms -->
                            <circle cx="60" cy="60" r="20" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="60" y="52" font-size="11" fill="var(--text-secondary, #888)">a₁</text>
                            <text x="60" y="68" font-size="16" fill="var(--accent-primary, #6366f1)" font-weight="bold">3</text>
                            
                            <text x="100" y="65" font-size="20" fill="var(--success, #22c55e)">+d</text>
                            
                            <circle cx="140" cy="60" r="20" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="140" y="52" font-size="11" fill="var(--text-secondary, #888)">a₂</text>
                            <text x="140" y="68" font-size="16" fill="var(--accent-primary, #6366f1)" font-weight="bold">7</text>
                            
                            <text x="180" y="65" font-size="20" fill="var(--success, #22c55e)">+d</text>
                            
                            <circle cx="220" cy="60" r="20" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="220" y="52" font-size="11" fill="var(--text-secondary, #888)">a₃</text>
                            <text x="220" y="68" font-size="16" fill="var(--accent-primary, #6366f1)" font-weight="bold">11</text>
                            
                            <text x="260" y="65" font-size="20" fill="var(--success, #22c55e)">+d</text>
                            
                            <circle cx="300" cy="60" r="20" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="300" y="52" font-size="11" fill="var(--text-secondary, #888)">a₄</text>
                            <text x="300" y="68" font-size="16" fill="var(--accent-primary, #6366f1)" font-weight="bold">15</text>
                            
                            <!-- Difference label -->
                            <text x="200" y="100" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">Common difference d = 4</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">AP: 3, 7, 11, 15... Find 10th term?</div>
                        <div class="step">Step 1: First term a = 3, common difference d = 4</div>
                        <div class="step">Step 2: Use formula aₙ = a + (n-1)d</div>
                        <div class="step">Step 3: a₁₀ = 3 + (10-1)×4 = 3 + 36</div>
                        <div class="result">10th term = 39</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Quick check:</strong> If d is positive, series increases. If negative, it decreases!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 10) + 1;
                const d = Math.floor(Math.random() * 5) + 2;
                const n = Math.floor(Math.random() * 8) + 5; // 5-12
                const nth = a + (n - 1) * d;
                return {
                    text: `AP starts with ${a}, d=${d}. Find term ${n}?`,
                    answer: nth
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'series-ap-sum': {
            id: 'series-ap-sum',
            category: 'Number Series',
            tags: ['series', 'sequence', 'ap'],
            title: 'Sum of AP | Sₙ = n/2(2a + (n-1)d)',
            ctrHeadline: 'Add entire AP series in seconds!',
            description: 'Sum of first n terms of AP using the shortcut formula.',
            difficulty: 'Intermediate',
            formula: 'Sₙ = n/2 × (first + last) OR n/2 × (2a + (n-1)d)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Two formulas, same answer! Use whichever is <strong>faster</strong>.</p>

                    <div class="example-box">
                        <div class="problem">Sum of first 10 terms: 2, 5, 8, 11...</div>
                        <div class="step"><strong>Method 1 (if last term known):</strong></div>
                        <div class="step">Last term a₁₀ = 2 + 9×3 = 29</div>
                        <div class="step">Sum = n/2 × (first + last) = 10/2 × (2 + 29) = <strong>155</strong></div>
                        
                        <div class="step" style="margin-top: var(--space-2);"><strong>Method 2 (using d):</strong></div>
                        <div class="step">Sum = n/2 × (2a + (n-1)d)</div>
                        <div class="step">= 10/2 × (2×2 + 9×3) = 5 × 31 = <strong>155</strong></div>
                        <div class="result">Sum = 155</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Gauss trick:</strong> Pair first+last, second+second-last... All pairs sum to same value!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 5) + 1;
                const d = Math.floor(Math.random() * 4) + 2;
                const n = Math.floor(Math.random() * 6) + 5; // 5-10
                const sum = (n / 2) * (2 * a + (n - 1) * d);
                return {
                    text: `Sum of ${n} terms: ${a}, ${a + d}, ${a + 2 * d}...?`,
                    answer: sum
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'series-gp-basics': {
            id: 'series-gp-basics',
            category: 'Number Series',
            tags: ['series', 'sequence', 'gp'],
            title: 'Geometric Progression (GP) | nth term',
            ctrHeadline: 'Each term multiplied by a constant ratio!',
            description: 'GP has constant ratio r. Formula: nth term = a × r^(n-1)',
            difficulty: 'Intermediate',
            formula: 'aₙ = a × r^(n-1)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">In GP, each term is <strong>multiplied by constant ratio (r)</strong>.</p>

                    <!-- SVG GP Visualization -->
                    <svg viewBox="0 0 400 120" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <circle cx="60" cy="60" r="15" fill="var(--warning, #f59e0b)" opacity="0.2"/>
                            <text x="60" y="50" font-size="10" fill="var(--text-secondary, #888)">a₁</text>
                            <text x="60" y="66" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">2</text>
                            
                            <text x="95" y="65" font-size="16" fill="var(--success, #22c55e)">×r</text>
                            
                            <circle cx="130" cy="60" r="18" fill="var(--warning, #f59e0b)" opacity="0.2"/>
                            <text x="130" y="50" font-size="10" fill="var(--text-secondary, #888)">a₂</text>
                            <text x="130" y="66" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">6</text>
                            
                            <text x="170" y="65" font-size="16" fill="var(--success, #22c55e)">×r</text>
                            
                            <circle cx="210" cy="60" r="22" fill="var(--warning, #f59e0b)" opacity="0.2"/>
                            <text x="210" y="50" font-size="10" fill="var(--text-secondary, #888)">a₃</text>
                            <text x="210" y="66" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">18</text>
                            
                            <text x="255" y="65" font-size="16" fill="var(--success, #22c55e)">×r</text>
                            
                            <circle cx="300" cy="60" r="26" fill="var(--warning, #f59e0b)" opacity="0.2"/>
                            <text x="300" y="50" font-size="10" fill="var(--text-secondary, #888)">a₄</text>
                            <text x="300" y="66" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">54</text>
                            
                            <text x="200" y="100" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">Common ratio r = 3</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">GP: 2, 6, 18, 54... Find 6th term?</div>
                        <div class="step">Step 1: First term a = 2, ratio r = 3</div>
                        <div class="step">Step 2: aₙ = a × r^(n-1)</div>
                        <div class="step">Step 3: a₆ = 2 × 3^5 = 2 × 243</div>
                        <div class="result">6th term = 486</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = [1, 2, 3, 5][Math.floor(Math.random() * 4)];
                const r = [2, 3][Math.floor(Math.random() * 2)];
                const n = Math.floor(Math.random() * 3) + 4; // 4-6
                const nth = a * Math.pow(r, n - 1);
                return {
                    text: `GP: ${a}, ${a * r}, ${a * r * r}... Find term ${n}?`,
                    answer: nth
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'series-sum-natural': {
            id: 'series-sum-natural',
            category: 'Number Series',
            tags: ['series', 'formulas'],
            title: 'Sum of Natural Numbers | n(n+1)/2',
            ctrHeadline: '1+2+3+...+n? Use Gauss formula!',
            description: 'Sum of first n natural numbers using the famous Gauss shortcut.',
            difficulty: 'Beginner',
            formula: 'Σn = n(n+1)/2',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Young Gauss discovered this at age 10! <strong>Pair from ends</strong>.</p>

                    <!-- SVG Pairing -->
                    <svg viewBox="0 0 400 140" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <text x="200" y="25" font-size="14" fill="var(--text-secondary, #888)">Sum 1 to 10</text>
                            
                            <!-- First row -->
                            <text x="60" y="55" font-size="14" fill="var(--text-primary, #ddd)">1</text>
                            <text x="100" y="55" font-size="14" fill="var(--text-primary, #ddd)">2</text>
                            <text x="140" y="55" font-size="14" fill="var(--text-primary, #ddd)">3</text>
                            <text x="180" y="55" font-size="14" fill="var(--text-primary, #ddd)">4</text>
                            <text x="220" y="55" font-size="14" fill="var(--text-primary, #ddd)">5</text>
                            
                            <!-- Second row (reversed) -->
                            <text x="60" y="80" font-size="14" fill="var(--text-secondary, #888)">10</text>
                            <text x="100" y="80" font-size="14" fill="var(--text-secondary, #888)">9</text>
                            <text x="140" y="80" font-size="14" fill="var(--text-secondary, #888)">8</text>
                            <text x="180" y="80" font-size="14" fill="var(--text-secondary, #888)">7</text>
                            <text x="220" y="80" font-size="14" fill="var(--text-secondary, #888)">6</text>
                            
                            <!-- Sums -->
                            <line x1="50" y1="90" x2="230" y2="90" stroke="var(--success, #22c55e)" stroke-width="2"/>
                            <text x="60" y="110" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">11</text>
                            <text x="100" y="110" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">11</text>
                            <text x="140" y="110" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">11</text>
                            <text x="180" y="110" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">11</text>
                            <text x="220" y="110" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">11</text>
                        </g>
                        
                        <text x="200" y="130" text-anchor="middle" font-size="13" fill="var(--warning, #f59e0b)" font-weight="bold">
                            5 pairs × 11 = 55 (or 10×11/2 = 55)
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Sum 1 to 100?</div>
                        <div class="step">Step 1: Use n(n+1)/2</div>
                        <div class="step">Step 2: = 100 × 101 / 2</div>
                        <div class="step">Step 3: = 10100 / 2 = <strong>5050</strong></div>
                        <div class="result">Sum = 5050</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const n = (Math.floor(Math.random() * 10) + 5) * 10; // 50-140 (multiples of 10)
                const sum = (n * (n + 1)) / 2;
                return {
                    text: `Sum of 1 to ${n}?`,
                    answer: sum
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'series-pattern-recognition': {
            id: 'series-pattern-recognition',
            category: 'Number Series',
            tags: ['series', 'pattern', 'puzzle'],
            title: 'Pattern Recognition | Find the Rule',
            ctrHeadline: 'Spot the pattern, predict the next!',
            description: 'Look for differences, ratios, squares, or alternating patterns.',
            difficulty: 'Intermediate',
            formula: 'Check: AP? GP? Squares? Mix?',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Common patterns to check: <strong>differences, ratios, powers, alternating</strong>.</p>

                    <div class="example-box">
                        <div class="problem">Pattern Types</div>
                        <div class="step"><strong>AP:</strong> Constant difference (2, 5, 8, 11...)</div>
                        <div class="step"><strong>GP:</strong> Constant ratio (3, 9, 27, 81...)</div>
                        <div class="step"><strong>Squares:</strong> 1, 4, 9, 16, 25... (n²)</div>
                        <div class="step"><strong>Cubes:</strong> 1, 8, 27, 64... (n³)</div>
                        <div class="step"><strong>Fibonacci:</strong> Each = sum of previous two (1,1,2,3,5,8...)</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Find pattern: 2, 6, 12, 20, ?</div>
                        <div class="step">Differences: 4, 6, 8 (increasing by 2)</div>
                        <div class="step">Second difference: 2, 2 (constant!)</div>
                        <div class="step">Next difference: 8 + 2 = 10</div>
                        <div class="step">Next term: 20 + 10 = <strong>30</strong></div>
                        <div class="result">Pattern: n(n+1)</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Pro tip:</strong> Check differences first. If not constant, check second differences!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const patterns = [
                    { type: 'squares', gen: (n) => n * n, start: 1, count: 4 },
                    { type: 'doubled', gen: (n) => n * 2, start: 1, count: 5 },
                    { type: 'tripled', gen: (n) => n * 3, start: 1, count: 5 },
                    { type: 'add5', gen: (n) => 5 * n, start: 1, count: 5 }
                ];
                const pattern = patterns[Math.floor(Math.random() * patterns.length)];
                const series = [];
                for (let i = 0; i < pattern.count; i++) {
                    series.push(pattern.gen(pattern.start + i));
                }
                const next = pattern.gen(pattern.start + pattern.count);
                return {
                    text: `Next in series: ${series.join(', ')}, ?`,
                    answer: next
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        }
    });
})();
