/**
 * Quick Math Topics - Surds & Radicals
 */

(function registerSurdTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'surds-rationalize': {
            id: 'surds-rationalize',
            category: 'Advanced Topics',
            tags: ['surds', 'radicals', 'algebra'],
            title: 'Rationalizing Denominators | Remove Surds',
            ctrHeadline: 'Remove Square Roots from Bottom! Magic! ✨',
            description: 'Master denominator rationalization for competitive exams. Learn to eliminate surds from the bottom of fractions - essential algebra skill.',
            difficulty: 'Intermediate',
            formula: '1/√a = √a/a',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Denominators must be <strong>rational</strong>. Multiply top and bottom by the surd!</p>

                    <div class="example-box">
                        <div class="problem">Rationalize 1/√2</div>
                        <div class="step">Step 1: Multiply by √2/√2</div>
                        <div class="step">= (1 × √2) / (√2 × √2)</div>
                        <div class="step">= √2 / 2</div>
                        <div class="result">Answer: √2/2</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Rationalize 5/√3</div>
                        <div class="step">Step 1: Multiply by √3/√3</div>
                        <div class="step">= (5√3) / 3</div>
                        <div class="result">Answer: 5√3/3</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Key:</strong> √a × √a = a (the surd disappears!)
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const numerators = [1, 2, 3, 5];
                const surds = [2, 3, 5];
                const num = numerators[Math.floor(Math.random() * numerators.length)];
                const surd = surds[Math.floor(Math.random() * surds.length)];

                return {
                    text: `Rationalize ${num}/√${surd} (format: a√b/c)`,
                    answer: `${num}√${surd}/${surd}`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        },
        'surds-conjugate': {
            id: 'surds-conjugate',
            category: 'Advanced Topics',
            tags: ['surds', 'radicals', 'algebra'],
            title: 'Conjugate Pairs Formula | Surd Differences',
            ctrHeadline: 'Make Surds Disappear with Conjugates! 🎩',
            description: 'Learn the conjugate trick (a+√b)(a-√b) to remove square roots. Essential technique for simplifying complex algebra in SSC, Banking, Railway exams.',
            difficulty: 'Advanced',
            formula: '(a+√b)(a-√b) = a² - b',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Conjugate pairs make surds <strong>disappear</strong> using difference of squares!</p>

                    <!-- SVG Conjugate Pattern -->
                    <svg viewBox="0 0 400 120" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- First bracket -->
                            <text x="80" y="50" font-size="18" fill="var(--accent-primary, #6366f1)" font-weight="bold">(5 + √3)</text>
                            
                            <!-- Multiply sign -->
                            <text x="160" y="50" font-size="20" fill="var(--text-secondary, #888)">×</text>
                            
                            <!-- Second bracket -->
                            <text x="240" y="50" font-size="18" fill="var(--success, #22c55e)" font-weight="bold">(5 - √3)</text>
                            
                            <!-- Sign change arrow -->
                            <path d="M210,25 Q240,10 270,25" fill="none" stroke="var(--warning, #f59e0b)" stroke-width="2" marker-end="url(#arrow-conj)"/>
                            <text x="240" y="15" font-size="11" fill="var(--warning, #f59e0b)">Sign flips!</text>
                            
                            <defs>
                                <marker id="arrow-conj" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                                </marker>
                            </defs>
                            
                            <!-- Equals -->
                            <text x="310" y="50" font-size="20" fill="var(--text-secondary, #888)">=</text>
                            
                            <!-- Result -->
                            <text x="350" y="50" font-size="18" fill="var(--danger, #ef4444)" font-weight="bold">22</text>
                            
                            <!-- Formula below -->
                            <text x="200" y="85" font-size="14" fill="var(--text-primary, #ddd)">5² - (√3)² = 25 - 3 = 22</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Multiply (7 + √2)(7 - √2)</div>
                        <div class="step">Step 1: Use (a+√b)(a-√b) = a² - b</div>
                        <div class="step">Step 2: a = 7, b = 2</div>
                        <div class="step">Step 3: = 7² - 2 = 49 - 2</div>
                        <div class="result">Answer: 47</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Use for:</strong> Rationalizing denominators with two terms!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 8) + 3; // 3-10
                const b = [2, 3, 5][Math.floor(Math.random() * 3)];
                const answer = a * a - b;

                return {
                    text: `(${a} + √${b})(${a} - √${b}) = ?`,
                    answer: answer
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'surds-simplify': {
            id: 'surds-simplify',
            category: 'Advanced Topics',
            tags: ['surds', 'radicals'],
            title: 'Simplifying Surds Method | Extract Squares',
            ctrHeadline: 'Simplify √72 in Seconds! Easy Trick! ⚡',
            description: 'Master the art of simplifying surds (radicals) for competitive exams. Factor out perfect squares instantly - core skill for SSC CGL, Banking.',
            difficulty: 'Intermediate',
            formula: '√(a²×b) = a√b',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Look for <strong>perfect square factors</strong> and pull them out!</p>

                    <div class="example-box">
                        <div class="problem">Simplify √48</div>
                        <div class="step">Step 1: Factor 48 = 16 × 3</div>
                        <div class="step">Step 2: Recognize 16 = 4²</div>
                        <div class="step">Step 3: √48 = √(16 × 3) = √16 × √3</div>
                        <div class="step">Step 4: = 4√3</div>
                        <div class="result">Answer: 4√3</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Simplify √72</div>
                        <div class="step">Step 1: Factor 72 = 36 × 2 (or 4 × 18, or 9 × 8)</div>
                        <div class="step">Step 2: Use largest perfect square: 36 = 6²</div>
                        <div class="step">Step 3: √72 = 6√2</div>
                        <div class="result">Answer: 6√2</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Common perfect squares to memorize</div>
                        <div class="step">4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144...</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const perfectSquares = [4, 9, 16, 25, 36];
                const remainders = [2, 3, 5, 7];
                const perfect = perfectSquares[Math.floor(Math.random() * perfectSquares.length)];
                const remainder = remainders[Math.floor(Math.random() * remainders.length)];
                const number = perfect * remainder;
                const simplified = `${Math.sqrt(perfect)}√${remainder}`;

                return {
                    text: `Simplify √${number} (format: a√b)`,
                    answer: simplified
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        },
        'surds-operations': {
            id: 'surds-operations',
            category: 'Advanced Topics',
            tags: ['surds', 'radicals'],
            title: 'Surd Operations Rules | Multiply & Divide',
            ctrHeadline: 'Multiply & Divide Roots Correctly! ✅',
            description: 'Understand addition, subtraction, multiplication, and division rules for surds. Avoid common mistakes in competitive math exams (SSC, Banking).',
            difficulty: 'Intermediate',
            formula: '√a × √b = √(ab), √a ÷ √b = √(a/b)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Surds have simple rules for <strong>multiplication and division</strong>!</p>

                    <div class="example-box">
                        <div class="problem">Multiplication Rules</div>
                        <div class="step">√2 × √3 = √(2×3) = √6</div>
                        <div class="step">√8 × √2 = √(8×2) = √16 = 4</div>
                        <div class="step">2√3 × 5√2 = (2×5)(√3×√2) = 10√6</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Division Rules</div>
                        <div class="step">√12 ÷ √3 = √(12/3) = √4 = 2</div>
                        <div class="step">√50 ÷ √2 = √(50/2) = √25 = 5</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">⚠️ Addition/Subtraction (ONLY like surds!)</div>
                        <div class="step">3√2 + 5√2 = 8√2 ✓</div>
                        <div class="step">√3 + √5 = √3 + √5 (cannot simplify!) ✗</div>
                        <div class="step">√8 + √2 = 2√2 + √2 = 3√2 ✓ (after simplifying)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const operations = [
                    { type: 'multiply', a: 2, b: 8, answer: 4 },
                    { type: 'multiply', a: 3, b: 12, answer: 6 },
                    { type: 'multiply', a: 5, b: 5, answer: 5 },
                    { type: 'divide', a: 18, b: 2, answer: 3 },
                    { type: 'divide', a: 50, b: 2, answer: 5 }
                ];

                const op = operations[Math.floor(Math.random() * operations.length)];
                const symbol = op.type === 'multiply' ? '×' : '÷';

                return {
                    text: `√${op.a} ${symbol} √${op.b} = ?`,
                    answer: op.answer
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'surds-compare': {
            id: 'surds-compare',
            category: 'Advanced Topics',
            tags: ['surds', 'radicals', 'comparison'],
            title: 'Comparing Surds Trick | Which is Larger',
            ctrHeadline: 'Compare √50 vs 7 Instantly! 🔍',
            description: 'Master the trick to compare sizes of square roots for competitive exams. Learn to square both sides for easy comparison - SSC, Banking trick.',
            difficulty: 'Intermediate',
            formula: 'To compare √a and b, check if a > b²',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Can't tell which is bigger? <strong>Square both</strong> and compare!</p>

                    <div class="example-box">
                        <div class="problem">Which is larger: √50 or 7?</div>
                        <div class="step">Method 1: Square both</div>
                        <div class="step">(√50)² = 50</div>
                        <div class="step">7² = 49</div>
                        <div class="step">Since 50 > 49, √50 > 7 ✓</div>
                        <div class="result">√50 is larger</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Which is larger: 2√3 or √15?</div>
                        <div class="step">Method 1: Square both</div>
                        <div class="step">(2√3)² = 4 × 3 = 12</div>
                        <div class="step">(√15)² = 15</div>
                        <div class="step">Since 15 > 12, √15 > 2√3</div>
                        <div class="result">√15 is larger</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Method 2: Convert to same radical</div>
                        <div class="step">2√3 = √(4×3) = √12</div>
                        <div class="step">Compare √12 vs √15 → 15 > 12</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const surds = [
                    { surd: 50, int: 7 },
                    { surd: 30, int: 5 },
                    { surd: 80, int: 9 },
                    { surd: 20, int: 4 }
                ];

                const q = surds[Math.floor(Math.random() * surds.length)];
                const larger = q.surd > q.int * q.int ? `√${q.surd}` : `${q.int}`;

                return {
                    text: `Which is larger: √${q.surd} or ${q.int}?`,
                    answer: larger
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '').toLowerCase();
                return clean(userAns) === clean(correctAns);
            }
        }
    });
})();
