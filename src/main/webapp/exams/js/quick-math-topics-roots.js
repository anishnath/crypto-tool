/**
 * Quick Math Topics - Roots
 */

(function registerRootsTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'cube-roots': {
            id: 'cube-roots',
            category: 'Powers & Roots',
            tags: ['roots'],
            title: 'Estimate Cube Roots Quickly',
            ctrHeadline: 'Find Cube Roots of Big Numbers!',
            description: 'Learn to estimate perfect cube roots by looking at the last digit.',
            difficulty: 'Advanced',
            formula: 'Ends in 8? Root ends in 2. Ends in 4? Root ends in 4.',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">The last digit of a perfect cube tells you the last digit of its root!</p>
                    <div class="example-box">
                        <div class="problem">∛512 = ?</div>
                        <div class="step">Step 1: Look at last digit of 512 → <strong>2</strong></div>
                        <div class="step">Step 2: Digit mapping: 2 ↔ 8, 3 ↔ 7, others stay same</div>
                        <div class="step">Step 3: Since it ends in 2, root ends in <strong>8</strong></div>
                        <div class="step">Step 4: 512 is between 1³=1 and 10³=1000, so root is single digit → <strong>8</strong></div>
                        <div class="result">Answer: 8</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 9) + 2;
                return {
                    text: `∛${n * n * n} = ?`,
                    answer: n
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'square-root-perfect': {
            id: 'square-root-perfect',
            category: 'Powers & Roots',
            tags: ['roots', 'squares'],
            title: 'Perfect Squares Recognition',
            ctrHeadline: 'Know √144, √256, √625 instantly!',
            description: 'Memorize perfect squares 1-20 and recognize them in problems.',
            difficulty: 'Beginner',
            formula: 'Memorize: 12²=144, 13²=169, 14²=196, 15²=225...',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Memorize the <strong>first 20 perfect squares</strong> and roots become instant.</p>
                    
                    <div class="example-box">
                        <div class="problem">Perfect Squares Reference (1-20)</div>
                        <div class="step">11² = 121, 12² = 144, 13² = 169, 14² = 196, 15² = 225</div>
                        <div class="step">16² = 256, 17² = 289, 18² = 324, 19² = 361, 20² = 400</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">√196 = ?</div>
                        <div class="step">Step 1: Recognize 196 in the list</div>
                        <div class="step">Step 2: 196 = 14²</div>
                        <div class="result">Answer: 14</div>
                    </div>
                    
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Pro Tip:</strong> Notice patterns - squares ending in 1: 1, 81, 121, 361, 441...
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 10) + 11; // 11-20
                return {
                    text: `√${n * n} = ?`,
                    answer: n
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'square-root-estimate': {
            id: 'square-root-estimate',
            category: 'Powers & Roots',
            tags: ['roots', 'estimation'],
            title: 'Estimate Square Roots | Sandwich Method',
            ctrHeadline: 'Find √50 without a calculator!',
            description: 'Estimate any square root by finding the perfect squares it sits between.',
            difficulty: 'Intermediate',
            formula: 'a² < N < b² → √N is between a and b',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Find two perfect squares that <strong>sandwich</strong> your number.</p>

                    <!-- SVG Sandwich Visual -->
                    <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Number line -->
                            <line x1="50" y1="60" x2="330" y2="60" stroke="var(--text-secondary, #666)" stroke-width="3"/>
                            
                            <!-- Left bound (7²=49) -->
                            <circle cx="90" cy="60" r="8" fill="var(--accent-primary, #6366f1)"/>
                            <text x="90" y="45" font-size="14" fill="var(--accent-primary, #6366f1)">7² = 49</text>
                            <text x="90" y="85" font-size="16" fill="var(--accent-primary, #6366f1)">√49 = 7</text>
                            
                            <!-- Target (50) -->
                            <circle cx="95" cy="60" r="6" fill="var(--warning, #f59e0b)"/>
                            <text x="95" y="105" font-size="18" fill="var(--warning, #f59e0b)">50</text>
                            
                            <!-- Right bound (8²=64) -->
                            <circle cx="290" cy="60" r="8" fill="var(--success, #22c55e)"/>
                            <text x="290" y="45" font-size="14" fill="var(--success, #22c55e)">8² = 64</text>
                            <text x="290" y="85" font-size="16" fill="var(--success, #22c55e)">√64 = 8</text>
                        </g>
                        
                        <text x="190" y="25" text-anchor="middle" font-size="14" fill="var(--text-secondary, #888)">
                            √50 is slightly more than 7
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Estimate √50</div>
                        <div class="step">Step 1: Find perfect squares nearby → 49 and 64</div>
                        <div class="step">Step 2: So 7² < 50 < 8²</div>
                        <div class="step">Step 3: √50 is between 7 and 8</div>
                        <div class="step">Step 4: 50 is close to 49, so <strong>≈ 7.1</strong></div>
                        <div class="result">Estimate: 7.1 (actual: 7.07)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const base = Math.floor(Math.random() * 8) + 6; // 6-13
                const offset = Math.floor(Math.random() * (2 * base - 1)) + 1;
                const num = base * base + offset;
                return {
                    text: `Estimate √${num} (to 1 decimal)`,
                    answer: base + (offset / (2 * base)) // Linear approximation
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const diff = Math.abs(parseFloat(userAns) - Math.sqrt(correctAns));
                return diff < 0.5; // Accept if within 0.5
            }
        },
        'square-root-division': {
            id: 'square-root-division',
            category: 'Powers & Roots',
            tags: ['roots', 'advanced'],
            title: 'Square Root by Division Method',
            ctrHeadline: 'Calculate √2 to any precision manually!',
            description: 'The ancient long-division-style method for finding exact square roots.',
            difficulty: 'Advanced',
            formula: 'Pair digits from right, find largest square ≤ pair',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">This is the <strong>manual method</strong> used before calculators. Works for any number!</p>
                    
                    <div class="example-box">
                        <div class="problem">√484 = ?</div>
                        <div class="step">Step 1: Group from right → 4|84</div>
                        <div class="step">Step 2: Largest square ≤ 4 is 2² = 4</div>
                        <div class="step">Step 3: Bring down 84 → remainder 084</div>
                        <div class="step">Step 4: Double 2 = 4, find d where 4d × d ≤ 84</div>
                        <div class="step">Step 5: 42 × 2 = 84 ✓</div>
                        <div class="result">Answer: 22</div>
                    </div>
                    
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Note:</strong> This method is powerful but slow. Use estimation for speed!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 20) + 10; // 10-29
                return {
                    text: `√${n * n} = ?`,
                    answer: n
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'square-root-simplify': {
            id: 'square-root-simplify',
            category: 'Powers & Roots',
            tags: ['roots', 'algebra'],
            title: 'Simplify √72 in SECONDS! | Perfect Square Method',
            ctrHeadline: 'The Square Root Simplification Secret You NEED to Know! ✨',
            description: 'Learn to simplify complex square roots by extracting perfect squares for competitive exams. Quick method for SSC, Banking, Railway algebra and arithmetic questions.',
            difficulty: 'Intermediate',
            formula: '√(a²×b) = a√b',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Look for <strong>perfect square factors</strong> and pull them out.</p>
                    
                    <div class="example-box">
                        <div class="problem">Simplify √48</div>
                        <div class="step">Step 1: Factor 48 → 16 × 3</div>
                        <div class="step">Step 2: Recognize 16 = 4²</div>
                        <div class="step">Step 3: √48 = √(16 × 3) = √16 × √3</div>
                        <div class="step">Step 4: √16 = 4, so <strong>4√3</strong></div>
                        <div class="result">Answer: 4√3</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Common perfect square factors</div>
                        <div class="step">4, 9, 16, 25, 36, 49, 64, 81, 100...</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const squares = [4, 9, 16, 25];
                const sq = squares[Math.floor(Math.random() * squares.length)];
                const other = Math.floor(Math.random() * 7) + 2; // 2-8
                const num = sq * other;
                return {
                    text: `Simplify √${num} (format: a√b)`,
                    answer: `${Math.sqrt(sq)}√${other}`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                return userAns.trim() === correctAns.trim();
            }
        }
    });
})();


