/**
 * Quick Math Topics - Percentages
 */

(function registerPercentageTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'percentages-split': {
            id: 'percentages-split',
            category: 'Commercial Math',
            tags: ['percentage'],
            title: 'Calculate Percentages Mentally | Split Method',
            ctrHeadline: 'Calculate 15% of ANY Number in 3 Seconds! ⚡',
            description: 'Master the percentage split method for competitive exams. Find 15%, 20% or 50% instantly without multiplying - essential shortcut for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: '15% = 10% + 5%',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Break percentages into easy chunks: <strong>10% + 5%</strong> or <strong>50% ÷ 2</strong></p>
                    <div class="example-box">
                        <div class="problem">15% of 80 = ?</div>
                        <div class="step">Step 1: Find 10% → move decimal left → 80 → <strong>8</strong></div>
                        <div class="step">Step 2: Find 5% → half of 10% → 8 ÷ 2 = <strong>4</strong></div>
                        <div class="step">Step 3: Add them → 8 + 4 = <strong>12</strong></div>
                        <div class="result">Answer: 12</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const pct = [10, 20, 50, 25, 15];
                const p = pct[Math.floor(Math.random() * pct.length)];
                const n = (Math.floor(Math.random() * 20) + 1) * 10;
                return {
                    text: `${p}% of ${n} = ?`,
                    answer: (p / 100) * n
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'percentages-reverse': {
            id: 'percentages-reverse',
            category: 'Commercial Math',
            tags: ['percentage', 'advanced'],
            title: 'Reverse Percentages Trick | x% of y = y% of x',
            ctrHeadline: 'Solve 16% of 25 Without Formulas! 🤯',
            description: 'Learn the "Switching" percentage trick for competitive exams. Understand why X% of Y = Y% of X and solve instantly - key technique for SSC, Banking, Railway.',
            difficulty: 'Advanced',
            formula: 'X% of Y = Y% of X',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">This is PURE MAGIC. <strong>Swap the numbers</strong> if it makes it easier!</p>

                    <!-- SVG Swap Visual -->
                    <svg viewBox="0 0 380 140" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Original -->
                            <text x="80" y="40" font-size="20" fill="var(--accent-primary, #6366f1)">16%</text>
                            <text x="130" y="40" font-size="16" fill="var(--text-secondary, #888)">of</text>
                            <text x="180" y="40" font-size="20" fill="var(--success, #22c55e)">25</text>
                            
                            <!-- Swap Arrow -->
                            <path d="M85,55 Q130,80 175,55" fill="none" stroke="var(--warning, #f59e0b)" stroke-width="3" marker-end="url(#arrow-swap)"/>
                            <path d="M175,25 Q130,0 85,25" fill="none" stroke="var(--warning, #f59e0b)" stroke-width="3" marker-end="url(#arrow-swap)"/>
                            
                            <defs>
                                <marker id="arrow-swap" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                                </marker>
                            </defs>

                            <!-- Result -->
                            <text x="280" y="40" font-size="20" fill="var(--success, #22c55e)">25%</text>
                            <text x="330" y="40" font-size="16" fill="var(--text-secondary, #888)">of</text>
                            <text x="80" y="100" font-size="20" fill="var(--accent-primary, #6366f1)">16</text>
                            
                            <!-- Equals -->
                            <text x="190" y="100" font-size="28" fill="var(--text-primary, #ddd)">=</text>
                            
                            <!-- Final Answer -->
                            <circle cx="300" cy="95" r="25" fill="var(--success, #22c55e)" opacity="0.2"/>
                            <text x="300" y="100" font-size="24" fill="var(--success, #22c55e)">4</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">16% of 25 = ?</div>
                        <div class="step">Step 1: Hard to do 16% mentally...</div>
                        <div class="step">Step 2: <strong>Swap!</strong> 25% of 16 is WAY easier</div>
                        <div class="step">Step 3: 25% = ¼, so 16 ÷ 4 = <strong>4</strong></div>
                        <div class="result">Answer: 4</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        This works because multiplication is commutative: (16/100) × 25 = (25/100) × 16
                    </p>
                </div>
            `,
            generateQuestion: () => {
                // Generate pairs where swapping makes it easier
                const pairs = [[4, 50], [8, 25], [12, 25], [16, 25], [20, 50], [24, 25]];
                const pair = pairs[Math.floor(Math.random() * pairs.length)];
                return {
                    text: `${pair[0]}% of ${pair[1]} = ?`,
                    answer: (pair[0] / 100) * pair[1]
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'percentages-1percent': {
            id: 'percentages-1percent',
            category: 'Commercial Math',
            tags: ['percentage'],
            title: 'Find 1% First | Foundation Method',
            ctrHeadline: 'Master ANY percentage by finding 1% first',
            description: 'The secret to all percentage calculations: Find 1%, then multiply.',
            difficulty: 'Beginner',
            formula: '1% = Number ÷ 100, then multiply',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>1% is your anchor.</strong> Divide by 100, then scale up.</p>
                    <div class="example-box">
                        <div class="problem">7% of 200 = ?</div>
                        <div class="step">Step 1: Find 1% → 200 ÷ 100 = <strong>2</strong></div>
                        <div class="step">Step 2: Multiply by 7 → 2 × 7 = <strong>14</strong></div>
                        <div class="result">Answer: 14</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Pro tip:</strong> To divide by 100, just move the decimal point 2 places left.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const pct = Math.floor(Math.random() * 15) + 1;
                const base = (Math.floor(Math.random() * 20) + 1) * 10;
                return {
                    text: `${pct}% of ${base} = ?`,
                    answer: (pct / 100) * base
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'percentages-fractions': {
            id: 'percentages-fractions',
            category: 'Commercial Math',
            tags: ['percentage', 'fractions'],
            title: 'Percentages to Fractions Shortcut | 33⅓% = ⅓',
            ctrHeadline: 'Memorize Common Percentages for Speed Math! 🚀',
            description: 'Convert common percentages to fractions instantly for competitive exams. Memorize 33.33%, 16.66% shortcuts - essential table for SSC, Banking, Railway.',
            difficulty: 'Beginner',
            formula: '50% = ½, 25% = ¼, 75% = ¾, 33⅓% = ⅓',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Memorize these <strong>magic fractions</strong> and percentages become easy.</p>
                    
                    <div class="example-box">
                        <div class="problem">Reference Table</div>
                        <div class="step"><strong>50%</strong> = ½ → Just divide by 2</div>
                        <div class="step"><strong>25%</strong> = ¼ → Divide by 4</div>
                        <div class="step"><strong>75%</strong> = ¾ → 3 quarters</div>
                        <div class="step"><strong>33⅓%</strong> = ⅓ → Divide by 3</div>
                        <div class="step"><strong>66⅔%</strong> = ⅔ → 2 thirds</div>
                        <div class="step"><strong>20%</strong> = ⅕ → Divide by 5</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">25% of 84 = ?</div>
                        <div class="step">Step 1: 25% = ¼</div>
                        <div class="step">Step 2: 84 ÷ 4 = <strong>21</strong></div>
                        <div class="result">Answer: 21</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const percentages = [
                    { pct: 50, frac: 2 },
                    { pct: 25, frac: 4 },
                    { pct: 75, frac: 4, mult: 3 },
                    { pct: 20, frac: 5 }
                ];
                const p = percentages[Math.floor(Math.random() * percentages.length)];
                const base = (Math.floor(Math.random() * 20) + 1) * p.frac;
                return {
                    text: `${p.pct}% of ${base} = ?`,
                    answer: (p.pct / 100) * base
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'percentages-change': {
            id: 'percentages-change',
            category: 'Commercial Math',
            tags: ['percentage', 'money'],
            title: 'Percentage Increase & Decrease | Quick Method',
            ctrHeadline: 'Add or Remove 15% in Your Head! 💸',
            description: 'Master percentage increase and decrease mental calculations for competitive exams. Solve price change problems instantly - crucial for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'Increase by X%: Original + (Original × X/100)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Find the percentage, then <strong>Add (increase)</strong> or <strong>Subtract (decrease)</strong>.</p>
                    
                    <div class="example-box">
                        <div class="problem">Increase $40 by 15%</div>
                        <div class="step">Step 1: Find 10% → $40 ÷ 10 = <strong>$4</strong></div>
                        <div class="step">Step 2: Find 5% → $4 ÷ 2 = <strong>$2</strong></div>
                        <div class="step">Step 3: 15% → $4 + $2 = <strong>$6</strong></div>
                        <div class="step">Step 4: Add to original → $40 + $6 = <strong>$46</strong></div>
                        <div class="result">Answer: $46</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Decrease $50 by 20%</div>
                        <div class="step">Step 1: 20% of $50 → $50 ÷ 5 = <strong>$10</strong></div>
                        <div class="step">Step 2: Subtract → $50 - $10 = <strong>$40</strong></div>
                        <div class="result">Answer: $40</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const isIncrease = Math.random() > 0.5;
                const base = (Math.floor(Math.random() * 20) + 1) * 10;
                const pct = [10, 20, 25, 50][Math.floor(Math.random() * 4)];
                const change = (base * pct) / 100;
                const answer = isIncrease ? base + change : base - change;
                return {
                    text: `${isIncrease ? 'Increase' : 'Decrease'} ${base} by ${pct}% = ?`,
                    answer: answer
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'compound-interest-rule72': {
            id: 'compound-interest-rule72',
            category: 'Commercial Math',
            tags: ['percentage', 'compound-interest', 'money'],
            title: 'Rule of 72 | Doubling Time',
            ctrHeadline: 'Find when your money doubles in seconds!',
            description: 'Divide 72 by the interest rate to find how many years it takes to double your money.',
            difficulty: 'Beginner',
            formula: 'Doubling Time ≈ 72 ÷ Interest Rate',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Want to know when your investment doubles? Use the <strong>Rule of 72</strong>!</p>

                    <!-- SVG Doubling Visual -->
                    <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Initial Amount -->
                            <circle cx="80" cy="60" r="30" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="80" y="50" font-size="12" fill="var(--text-secondary, #888)">Start</text>
                            <text x="80" y="70" font-size="20" fill="var(--accent-primary, #6366f1)">₹1000</text>

                            <!-- Arrow with years -->
                            <line x1="115" y1="60" x2="245" y2="60" stroke="var(--warning, #f59e0b)" stroke-width="3" marker-end="url(#arrow-ci)"/>
                            <text x="180" y="50" font-size="14" fill="var(--warning, #f59e0b)">72 ÷ 8 = 9 years</text>
                            
                            <defs>
                                <marker id="arrow-ci" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                                </marker>
                            </defs>

                            <!-- Doubled Amount -->
                            <circle cx="300" cy="60" r="30" fill="var(--success, #22c55e)" opacity="0.2"/>
                            <text x="300" y="50" font-size="12" fill="var(--text-secondary, #888)">After 9 yrs</text>
                            <text x="300" y="70" font-size="20" fill="var(--success, #22c55e)">₹2000</text>
                        </g>

                        <text x="190" y="100" text-anchor="middle" font-size="12" fill="var(--text-muted, #888)">
                            @ 8% per year (compounded)
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">At 8% compound interest, when does ₹1000 become ₹2000?</div>
                        <div class="step">Step 1: Use Rule of 72 → 72 ÷ 8 = <strong>9 years</strong></div>
                        <div class="result">Answer: ~9 years (exact: 9.01 years)</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Quick Reference</div>
                        <div class="step">6% → 72÷6 = 12 years to double</div>
                        <div class="step">9% → 72÷9 = 8 years to double</div>
                        <div class="step">12% → 72÷12 = 6 years to double</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const rates = [6, 8, 9, 12];
                const rate = rates[Math.floor(Math.random() * rates.length)];
                const years = 72 / rate;
                return {
                    text: `At ${rate}% compound interest, money doubles in how many years?`,
                    answer: years
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'compound-interest-2year': {
            id: 'compound-interest-2year',
            category: 'Commercial Math',
            tags: ['percentage', 'compound-interest', 'money'],
            title: '2-Year Compound Interest | Quick Formula',
            ctrHeadline: 'Calculate 2-year CI without lengthy formulas!',
            description: 'For 2 years: CI = P × R × (2 + R/100) / 100',
            difficulty: 'Intermediate',
            formula: 'CI (2 years) = P × R × (200 + R) / 10000',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">The <strong>2-year CI formula</strong> skips the power calculations!</p>

                    <div class="example-box">
                        <div class="problem">₹5000 at 10% for 2 years. Find CI.</div>
                        <div class="step">Step 1: Formula → P × R × (200 + R) / 10000</div>
                        <div class="step">Step 2: Substitute → 5000 × 10 × (200 + 10) / 10000</div>
                        <div class="step">Step 3: 5000 × 10 × 210 / 10000</div>
                        <div class="step">Step 4: 50 × 210 = <strong>₹1050</strong></div>
                        <div class="result">CI = ₹1050</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Why it works:</strong> CI = P[(1+R/100)² - 1] expands to this simpler form
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const principal = [1000, 2000, 5000, 10000][Math.floor(Math.random() * 4)];
                const rate = [5, 10, 20][Math.floor(Math.random() * 3)];
                const ci = (principal * rate * (200 + rate)) / 10000;
                return {
                    text: `₹${principal} at ${rate}% for 2 years. Find CI.`,
                    answer: ci
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'compound-interest-vs-simple': {
            id: 'compound-interest-vs-simple',
            category: 'Commercial Math',
            tags: ['percentage', 'compound-interest', 'money'],
            title: 'CI vs SI Difference | 2-Year Trick',
            ctrHeadline: 'The difference between CI and SI for 2 years',
            description: 'Difference = P × (R/100)² for 2 years',
            difficulty: 'Intermediate',
            formula: 'CI - SI (2 years) = P × R² / 10000',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For 2 years, the <strong>difference</strong> between CI and SI has a simple formula!</p>

                    <div class="example-box">
                        <div class="problem">₹10000 at 10% for 2 years. Find CI - SI.</div>
                        <div class="step">Step 1: Formula → P × R² / 10000</div>
                        <div class="step">Step 2: 10000 × 10² / 10000</div>
                        <div class="step">Step 3: 10000 × 100 / 10000 = <strong>₹100</strong></div>
                        <div class="result">Difference = ₹100</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Key:</strong> The difference is "interest on first year's interest"
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const principal = [5000, 10000, 20000][Math.floor(Math.random() * 3)];
                const rate = [10, 20][Math.floor(Math.random() * 2)];
                const diff = (principal * rate * rate) / 10000;
                return {
                    text: `₹${principal} at ${rate}% for 2 years. CI - SI = ?`,
                    answer: diff
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        }
    });
})();


