/**
 * Quick Math Topics - Algebra / Word Problems
 */

(function registerAlgebraTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'time-work-basic': {
            id: 'time-work-basic',
            category: 'Advanced Topics',
            tags: ['algebra'],
            title: 'Time & Work Formula | Product÷Sum Method',
            ctrHeadline: 'Solve ANY Time & Work Problem in 10 Seconds! ⚡',
            description: 'Master the Product÷Sum formula to solve time and work problems instantly for competitive exams. Essential shortcut for SSC, Banking, Railway word problem questions.',
            difficulty: 'Advanced',
            formula: '(A × B) / (A + B)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">When two people work together, use the <strong>Product ÷ Sum</strong> formula.</p>
                    <div class="example-box">
                        <div class="problem">A takes 10 days, B takes 15 days. Together?</div>
                        <div class="step">Step 1: Multiply their times → 10 × 15 = <strong>150</strong></div>
                        <div class="step">Step 2: Add their times → 10 + 15 = <strong>25</strong></div>
                        <div class="step">Step 3: Divide → 150 ÷ 25 = <strong>6</strong></div>
                        <div class="result">Answer: 6 days</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const pairs = [[6, 3], [12, 6], [10, 10], [12, 4], [20, 5]];
                const pair = pairs[Math.floor(Math.random() * pairs.length)];
                return {
                    text: `A takes ${pair[0]} days, B takes ${pair[1]} days. How long together?`,
                    answer: (pair[0] * pair[1]) / (pair[0] + pair[1])
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'algebra-linear': {
            id: 'algebra-linear',
            category: 'Algebra',
            tags: ['algebra', 'equations'],
            title: 'Simple Linear Equations | Balance Method',
            ctrHeadline: 'The "Balance Scale" Trick for Equations',
            description: 'Visualize an equation as a balance scale. What you do to one side, you must do to the other.',
            difficulty: 'Beginner',
            formula: '2x + 5 = 15 → 2x = 10 → x = 5',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Think of an equation as a <strong>Balanced Scale</strong>. Keep it level!</p>

                    <!-- SVG Balance Scale -->
                    <svg viewBox="0 0 380 140" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Base -->
                            <path d="M190,130 L170,140 L210,140 Z" fill="var(--text-secondary, #666)"/>
                            <line x1="190" y1="40" x2="190" y2="130" stroke="var(--text-secondary, #666)" stroke-width="4"/>
                            
                            <!-- Beam -->
                            <line x1="60" y1="40" x2="320" y2="40" stroke="var(--text-primary, #ddd)" stroke-width="4"/>
                            
                            <!-- Left Pan (2x + 5) -->
                            <line x1="80" y1="40" x2="80" y2="90" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                            <rect x="50" y="90" width="60" height="10" fill="var(--text-secondary, #666)"/>
                            
                            <!-- Items on Left -->
                            <rect x="55" y="70" width="20" height="20" fill="var(--accent-primary, #6366f1)" stroke="#fff"/>
                            <text x="65" y="85" font-size="12" fill="#fff">x</text>
                            <rect x="75" y="70" width="20" height="20" fill="var(--accent-primary, #6366f1)" stroke="#fff"/>
                             <text x="85" y="85" font-size="12" fill="#fff">x</text>
                            
                            <circle cx="95" cy="80" r="8" fill="var(--warning, #f59e0b)"/>
                            <text x="95" y="84" font-size="10" fill="#fff">+5</text>

                            <!-- Right Pan (15) -->
                            <line x1="300" y1="40" x2="300" y2="90" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                            <rect x="270" y="90" width="60" height="10" fill="var(--text-secondary, #666)"/>
                            
                            <!-- Items on Right -->
                             <circle cx="300" cy="80" r="15" fill="var(--success, #22c55e)"/>
                             <text x="300" y="85" font-size="14" fill="#fff">15</text>
                        </g>

                        <!-- Action Arrow -->
                        <g transform="translate(0, 10)">
                             <text x="190" y="20" font-size="14" fill="var(--danger, #ef4444)">Remove 5 from both sides</text>
                             <path d="M110,80 Q190,10 270,80" fill="none" stroke="var(--danger, #ef4444)" stroke-dasharray="4"/>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">2x + 5 = 15</div>
                        <div class="step">Step 1: Remove 5 from both sides → 2x = 10</div>
                        <div class="step">Step 2: Divide both sides by 2 → x = <strong>5</strong></div>
                        <div class="result">Answer: x = 5</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const x = Math.floor(Math.random() * 9) + 2; // answer
                const m = Math.floor(Math.random() * 4) + 2; // multiplier
                const c = Math.floor(Math.random() * 10) + 1; // constant
                const rhs = (m * x) + c;
                return {
                    text: `${m}x + ${c} = ${rhs}, find x`,
                    answer: x
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'algebra-diff-squares': {
            id: 'algebra-diff-squares',
            category: 'Algebra',
            tags: ['algebra', 'squares'],
            title: 'Difference of Squares | a² - b² Trick',
            ctrHeadline: 'Calculate 52² - 48² in your head!',
            description: 'Use the algebraic identity a² - b² = (a - b)(a + b) to simplify calculations.',
            difficulty: 'Intermediate',
            formula: 'a² - b² = (a - b)(a + b)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Don't square the numbers! Just <strong>Subtract</strong> them and <strong>Add</strong> them, then multiply.</p>

                    <div class="example-box">
                        <div class="problem">52² - 48² = ?</div>
                        <div class="step">Step 1: Identify a=52, b=48</div>
                        <div class="step">Step 2: Find (a - b) → 52 - 48 = <strong>4</strong></div>
                        <div class="step">Step 3: Find (a + b) → 52 + 48 = <strong>100</strong></div>
                        <div class="step">Step 4: Multiply results → 4 × 100 = <strong>400</strong></div>
                        <div class="result">Answer: 400</div>
                    </div>
                     <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        Often used when numbers are equally far from a base (e.g. 50+2 and 50-2).
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const base = Math.floor(Math.random() * 50) + 20;
                const diff = Math.floor(Math.random() * 5) + 1;
                const a = base + diff;
                const b = base - diff;
                return {
                    text: `${a}² - ${b}² = ?`,
                    answer: (a * a) - (b * b)
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'algebra-quad-roots': {
            id: 'algebra-quad-roots',
            category: 'Algebra',
            tags: ['algebra', 'quadratics'],
            title: 'Roots of Quadratics | Sum & Product',
            ctrHeadline: 'Solve x² - 7x + 12 = 0 instantly',
            description: 'For x² - Sx + P = 0, the roots sum to S and multiply to P. Find the numbers!',
            difficulty: 'Advanced',
            formula: 'x² - (a+b)x + ab = 0 → Roots are a, b',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Look at the middle number (Sum) and last number (Product). Find <strong>two numbers</strong> that fit.</p>

                    <!-- SVG Logic Flow -->
                     <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <text x="190" y="30" font-size="20" fill="var(--text-primary, #ddd)">x² - 7x + 12 = 0</text>
                            
                            <!-- Arrows -->
                            <line x1="170" y1="40" x2="130" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2" marker-end="url(#arrow-q)"/>
                            <line x1="250" y1="40" x2="290" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2" marker-end="url(#arrow-q)"/>
                            
                             <defs>
                                <marker id="arrow-q" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--text-secondary, #666)"/>
                                </marker>
                            </defs>

                            <!-- Labels -->
                            <g transform="translate(100, 80)">
                                <text x="0" y="10" font-size="14" fill="var(--accent-primary, #6366f1)">Sum = 7</text>
                                <text x="0" y="30" font-size="12" fill="var(--text-secondary, #888)">(Change Sign)</text>
                            </g>

                            <g transform="translate(280, 80)">
                                <text x="0" y="10" font-size="14" fill="var(--success, #22c55e)">Product = 12</text>
                                <text x="0" y="30" font-size="12" fill="var(--text-secondary, #888)">(Same Sign)</text>
                            </g>
                        </g>
                     </svg>

                    <div class="example-box">
                        <div class="problem">Solve x² - 7x + 12 = 0</div>
                        <div class="step">Step 1: We need two numbers that <strong>Multiply to 12</strong></div>
                        <div class="step">Step 2: And <strong>Add up to 7</strong> (sign of middle term flipped)</div>
                        <div class="step">Step 3: Try factors of 12: (1,12) no, (2,6) no, (3,4) → 3+4=7! Yes.</div>
                        <div class="result">Roots: 3, 4</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const r1 = Math.floor(Math.random() * 8) + 1;
                const r2 = Math.floor(Math.random() * 8) + 1;
                const sum = r1 + r2;
                const prod = r1 * r2;
                return {
                    text: `Roots of x² - ${sum}x + ${prod} = 0 are? (comma separated)`,
                    answer: [r1, r2] // Logic check handles array/string match
                };
            },
            checkAnswer: (userAns, correctAns) => {
                // correctAns is array [r1, r2]
                const nums = userAns.split(',').map(n => parseInt(n.trim())).sort((a, b) => a - b);
                const expected = correctAns.sort((a, b) => a - b);
                return nums[0] === expected[0] && nums[1] === expected[1];
            }
        },

        // ==========================================
        // NEW ALGEBRA TRICKS
        // ==========================================

        'speed-distance-time': {
            id: 'speed-distance-time',
            category: 'Word Problems',
            tags: ['algebra', 'speed'],
            title: 'Speed-Distance-Time | Magic Triangle Trick',
            ctrHeadline: 'NEVER Confuse S=D/T Again! The Triangle Secret! 🔺',
            description: 'Master the SDT triangle method for competitive exams. Solve speed, distance, time problems instantly - crucial for SSC, Banking, Railway word problems.',
            difficulty: 'Beginner',
            formula: 'D = S × T | S = D ÷ T | T = D ÷ S',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Draw the <strong>SDT Triangle</strong>. Cover what you want to find!</p>

                    <!-- SVG Triangle -->
                    <svg viewBox="0 0 300 180" style="width: 100%; max-width: 320px; display: block; margin: 16px auto;">
                        <!-- Triangle -->
                        <polygon points="150,20 50,150 250,150" fill="none" stroke="var(--accent-primary, #6366f1)" stroke-width="3"/>

                        <!-- Horizontal line dividing -->
                        <line x1="50" y1="150" x2="250" y2="150" stroke="var(--accent-primary, #6366f1)" stroke-width="3"/>
                        <line x1="150" y1="85" x2="150" y2="150" stroke="var(--text-secondary, #666)" stroke-width="2" stroke-dasharray="5"/>

                        <!-- Labels -->
                        <text x="150" y="65" text-anchor="middle" font-size="24" font-weight="bold" fill="var(--warning, #f59e0b)">D</text>
                        <text x="90" y="135" text-anchor="middle" font-size="24" font-weight="bold" fill="var(--success, #22c55e)">S</text>
                        <text x="210" y="135" text-anchor="middle" font-size="24" font-weight="bold" fill="var(--danger, #ef4444)">T</text>

                        <!-- Multiplication sign -->
                        <text x="150" y="140" text-anchor="middle" font-size="18" fill="var(--text-secondary, #888)">×</text>

                        <!-- Instructions -->
                        <text x="150" y="175" text-anchor="middle" font-size="11" fill="var(--text-muted, #666)">Cover D → See S × T</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">A car travels 240 km in 4 hours. What's its speed?</div>
                        <div class="step">Step 1: Cover S in the triangle</div>
                        <div class="step">Step 2: You see D ÷ T</div>
                        <div class="step">Step 3: Calculate → 240 ÷ 4 = <strong>60</strong></div>
                        <div class="result">Speed = 60 km/h</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const types = ['speed', 'distance', 'time'];
                const type = types[Math.floor(Math.random() * types.length)];
                const speed = [40, 50, 60, 70, 80, 90][Math.floor(Math.random() * 6)];
                const time = [2, 3, 4, 5, 6][Math.floor(Math.random() * 5)];
                const distance = speed * time;

                if (type === 'speed') {
                    return { text: 'Distance = ' + distance + ' km, Time = ' + time + ' hrs. Speed = ?', answer: speed };
                } else if (type === 'distance') {
                    return { text: 'Speed = ' + speed + ' km/h, Time = ' + time + ' hrs. Distance = ?', answer: distance };
                } else {
                    return { text: 'Distance = ' + distance + ' km, Speed = ' + speed + ' km/h. Time = ?', answer: time };
                }
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        'ratio-proportion': {
            id: 'ratio-proportion',
            category: 'Word Problems',
            tags: ['algebra', 'ratio'],
            title: 'Ratio & Proportion | Cross Multiply Method',
            ctrHeadline: 'Solve ANY Ratio Problem Using Cross Multiplication! ✖️',
            description: 'Master the cross multiplication technique for ratios and proportions in competitive exams. Essential shortcut for SSC, Banking, Railway quantitative aptitude.',
            difficulty: 'Beginner',
            formula: 'a/b = c/x → x = bc/a',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">When two ratios are equal, <strong>Cross Multiply</strong> to find the unknown.</p>

                    <!-- SVG Cross Multiply -->
                    <svg viewBox="0 0 320 120" style="width: 100%; max-width: 340px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Fraction bars -->
                            <text x="80" y="35" font-size="28" font-weight="bold" fill="var(--accent-primary, #6366f1)">3</text>
                            <line x1="60" y1="45" x2="100" y2="45" stroke="var(--text-primary, #ddd)" stroke-width="2"/>
                            <text x="80" y="75" font-size="28" font-weight="bold" fill="var(--accent-primary, #6366f1)">4</text>

                            <text x="160" y="55" font-size="24" fill="var(--text-secondary, #888)">=</text>

                            <text x="240" y="35" font-size="28" font-weight="bold" fill="var(--success, #22c55e)">x</text>
                            <line x1="220" y1="45" x2="260" y2="45" stroke="var(--text-primary, #ddd)" stroke-width="2"/>
                            <text x="240" y="75" font-size="28" font-weight="bold" fill="var(--warning, #f59e0b)">20</text>

                            <!-- Cross lines -->
                            <line x1="90" y1="30" x2="230" y2="80" stroke="var(--danger, #ef4444)" stroke-width="2" stroke-dasharray="5"/>
                            <line x1="90" y1="80" x2="230" y2="30" stroke="var(--danger, #ef4444)" stroke-width="2" stroke-dasharray="5"/>
                        </g>

                        <text x="160" y="105" text-anchor="middle" font-size="12" fill="var(--text-muted, #888)">3 × 20 = 4 × x → x = 15</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">If 3/4 = x/20, find x</div>
                        <div class="step">Step 1: Cross multiply → 3 × 20 = 4 × x</div>
                        <div class="step">Step 2: Simplify → 60 = 4x</div>
                        <div class="step">Step 3: Divide → x = 60 ÷ 4 = <strong>15</strong></div>
                        <div class="result">x = 15</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 8) + 2;
                const b = Math.floor(Math.random() * 8) + 2;
                const multiplier = Math.floor(Math.random() * 5) + 2;
                const d = b * multiplier;
                const x = a * multiplier;
                return {
                    text: 'If ' + a + '/' + b + ' = x/' + d + ', find x',
                    answer: x
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },

        'profit-loss': {
            id: 'profit-loss',
            category: 'Word Problems',
            tags: ['algebra', 'percentage', 'money'],
            title: 'Profit & Loss Formulas | Short Tricks',
            ctrHeadline: 'Calculate Profit/Loss% in Seconds! 💰',
            description: 'Master profit and loss shortcuts for competitive exams. Learn to find CP, SP, and Profit% instantly - essential for SSC, Banking, Railway quantitative aptitude.',
            difficulty: 'Intermediate',
            formula: 'Profit% = (SP - CP)/CP × 100',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Remember: <strong>Profit is based on Cost Price (CP)</strong>, not Selling Price!</p>

                    <div class="example-box">
                        <div class="problem">Bought for ₹400, Sold for ₹500. Profit%?</div>
                        <div class="step">Step 1: Find Profit → 500 - 400 = <strong>₹100</strong></div>
                        <div class="step">Step 2: Divide by CP → 100 ÷ 400 = <strong>0.25</strong></div>
                        <div class="step">Step 3: Multiply by 100 → 0.25 × 100 = <strong>25%</strong></div>
                        <div class="result">Profit = 25%</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-4);">Quick Formula: <strong>Profit% = (Profit/CP) × 100</strong></p>

                    <p style="font-size: var(--text-sm); color: var(--text-muted); margin-top: var(--space-2);">
                        💡 <em>Shortcut:</em> If SP is 1.25× of CP, profit is 25%. If SP is 0.8× of CP, loss is 20%.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const cp = [100, 200, 250, 400, 500, 800][Math.floor(Math.random() * 6)];
                const profitPercent = [10, 15, 20, 25, 30, 40][Math.floor(Math.random() * 6)];
                const sp = cp * (100 + profitPercent) / 100;
                return {
                    text: 'CP = ₹' + cp + ', SP = ₹' + sp + '. Profit% = ?',
                    answer: profitPercent
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        'simple-interest': {
            id: 'simple-interest',
            category: 'Word Problems',
            tags: ['algebra', 'percentage', 'money'],
            title: 'Simple Interest & Rule of 72',
            ctrHeadline: 'How Long to Double Your Money?',
            description: 'SI = PRT/100. Rule of 72: Years to double ≈ 72 ÷ Rate%',
            difficulty: 'Intermediate',
            formula: 'SI = (P × R × T) / 100',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For Simple Interest, use <strong>PRT/100</strong>. For doubling time, use <strong>Rule of 72</strong>!</p>

                    <!-- SVG Rule of 72 -->
                    <svg viewBox="0 0 320 80" style="width: 100%; max-width: 340px; display: block; margin: 16px auto;">
                        <rect x="10" y="10" width="300" height="60" rx="10" fill="var(--bg-tertiary, #1a1a2e)" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                        <text x="160" y="35" text-anchor="middle" font-size="14" fill="var(--text-secondary, #888)">Years to Double ≈</text>
                        <text x="160" y="58" text-anchor="middle" font-size="22" font-weight="bold" fill="var(--warning, #f59e0b)">72 ÷ Interest Rate%</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">₹10,000 at 8% for 3 years. SI = ?</div>
                        <div class="step">Step 1: P=10000, R=8, T=3</div>
                        <div class="step">Step 2: SI = (10000 × 8 × 3) / 100</div>
                        <div class="step">Step 3: SI = 240000 / 100 = <strong>₹2400</strong></div>
                        <div class="result">Simple Interest = ₹2400</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-4);">
                        <div class="problem">At 6% interest, how long to double?</div>
                        <div class="step">Using Rule of 72: 72 ÷ 6 = <strong>12 years</strong></div>
                        <div class="result">≈ 12 years to double</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const type = Math.random() > 0.5 ? 'si' : 'double';
                if (type === 'si') {
                    const p = [1000, 2000, 5000, 10000][Math.floor(Math.random() * 4)];
                    const r = [5, 6, 8, 10, 12][Math.floor(Math.random() * 5)];
                    const t = [2, 3, 4, 5][Math.floor(Math.random() * 4)];
                    const si = (p * r * t) / 100;
                    return {
                        text: 'P = ₹' + p + ', R = ' + r + '%, T = ' + t + ' years. SI = ?',
                        answer: si
                    };
                } else {
                    const r = [4, 6, 8, 9, 12][Math.floor(Math.random() * 5)];
                    const years = 72 / r;
                    return {
                        text: 'At ' + r + '% interest, approx years to double? (Rule of 72)',
                        answer: years
                    };
                }
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        'average-shortcut': {
            id: 'average-shortcut',
            category: 'Word Problems',
            tags: ['algebra', 'average'],
            title: 'Average Shortcuts | Sequence Trick',
            ctrHeadline: 'Find Average of 1 to 100 Instantly!',
            description: 'For consecutive numbers: Average = (First + Last) / 2',
            difficulty: 'Beginner',
            formula: 'Avg of AP = (First + Last) / 2',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For any <strong>Arithmetic Sequence</strong>, the average is simply the middle value!</p>

                    <!-- SVG Number Line -->
                    <svg viewBox="0 0 340 70" style="width: 100%; max-width: 360px; display: block; margin: 16px auto;">
                        <line x1="20" y1="35" x2="320" y2="35" stroke="var(--text-secondary, #666)" stroke-width="2"/>

                        <!-- Points -->
                        <circle cx="40" cy="35" r="8" fill="var(--accent-primary, #6366f1)"/>
                        <text x="40" y="58" text-anchor="middle" font-size="12" fill="var(--text-primary, #ddd)">1</text>

                        <circle cx="170" cy="35" r="10" fill="var(--warning, #f59e0b)"/>
                        <text x="170" y="58" text-anchor="middle" font-size="12" font-weight="bold" fill="var(--warning, #f59e0b)">50.5</text>
                        <text x="170" y="18" text-anchor="middle" font-size="10" fill="var(--text-muted, #888)">AVG</text>

                        <circle cx="300" cy="35" r="8" fill="var(--success, #22c55e)"/>
                        <text x="300" y="58" text-anchor="middle" font-size="12" fill="var(--text-primary, #ddd)">100</text>

                        <!-- Bracket -->
                        <path d="M40 25 Q170 5 300 25" fill="none" stroke="var(--danger, #ef4444)" stroke-width="1.5" stroke-dasharray="4"/>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Average of numbers from 1 to 100?</div>
                        <div class="step">Step 1: First = 1, Last = 100</div>
                        <div class="step">Step 2: Average = (1 + 100) / 2 = 101/2</div>
                        <div class="result">Average = 50.5</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Average of 15, 20, 25, 30, 35?</div>
                        <div class="step">It's an AP! Avg = (15 + 35) / 2 = <strong>25</strong></div>
                        <div class="result">Average = 25 (the middle term!)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const start = Math.floor(Math.random() * 20) + 1;
                const end = start + Math.floor(Math.random() * 50) + 20;
                const avg = (start + end) / 2;
                return {
                    text: 'Average of all integers from ' + start + ' to ' + end + '?',
                    answer: avg
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        'mixture-alligation': {
            id: 'mixture-alligation',
            category: 'Word Problems',
            tags: ['algebra', 'ratio'],
            title: 'Mixture & Alligation | Criss-Cross',
            ctrHeadline: 'Mix Solutions Like a Pro!',
            description: 'To find mixing ratio: Criss-cross the differences from the mean.',
            difficulty: 'Advanced',
            formula: 'Ratio = (Mean - Cheaper) : (Dearer - Mean)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Use the <strong>Criss-Cross</strong> (Alligation) method to find mixing ratios.</p>

                    <!-- SVG Alligation Diagram -->
                    <svg viewBox="0 0 300 150" style="width: 100%; max-width: 320px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Cheaper -->
                            <circle cx="60" cy="40" r="25" fill="var(--success, #22c55e)" opacity="0.8"/>
                            <text x="60" y="45" font-size="16" font-weight="bold" fill="white">₹40</text>
                            <text x="60" y="80" font-size="10" fill="var(--text-muted, #888)">Cheaper</text>

                            <!-- Dearer -->
                            <circle cx="240" cy="40" r="25" fill="var(--danger, #ef4444)" opacity="0.8"/>
                            <text x="240" y="45" font-size="16" font-weight="bold" fill="white">₹60</text>
                            <text x="240" y="80" font-size="10" fill="var(--text-muted, #888)">Dearer</text>

                            <!-- Mean -->
                            <circle cx="150" cy="100" r="25" fill="var(--warning, #f59e0b)"/>
                            <text x="150" y="105" font-size="16" font-weight="bold" fill="white">₹45</text>
                            <text x="150" y="140" font-size="10" fill="var(--text-muted, #888)">Mean/Target</text>

                            <!-- Cross lines -->
                            <line x1="80" y1="55" x2="130" y2="85" stroke="var(--text-secondary, #888)" stroke-width="2"/>
                            <line x1="220" y1="55" x2="170" y2="85" stroke="var(--text-secondary, #888)" stroke-width="2"/>

                            <!-- Differences -->
                            <text x="90" y="105" font-size="14" font-weight="bold" fill="var(--accent-primary, #6366f1)">15</text>
                            <text x="210" y="105" font-size="14" font-weight="bold" fill="var(--accent-primary, #6366f1)">5</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Mix ₹40/kg and ₹60/kg rice to get ₹45/kg. Ratio?</div>
                        <div class="step">Step 1: Cheaper = 40, Dearer = 60, Mean = 45</div>
                        <div class="step">Step 2: Diff from mean: |45-40| = 5, |60-45| = 15</div>
                        <div class="step">Step 3: Ratio = 15 : 5 = <strong>3 : 1</strong></div>
                        <div class="result">Mix in ratio 3:1 (Cheaper : Dearer)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const cheaper = [20, 30, 40, 50][Math.floor(Math.random() * 4)];
                const dearer = cheaper + [20, 30, 40][Math.floor(Math.random() * 3)];
                const mean = cheaper + Math.floor((dearer - cheaper) * (Math.random() * 0.6 + 0.2));
                const r1 = dearer - mean;
                const r2 = mean - cheaper;
                const gcd = (a, b) => b === 0 ? a : gcd(b, a % b);
                const g = gcd(r1, r2);
                return {
                    text: 'Mix ₹' + cheaper + '/kg and ₹' + dearer + '/kg to get ₹' + mean + '/kg. Ratio? (a:b format)',
                    answer: [r1 / g, r2 / g]
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const parts = userAns.split(':').map(n => parseInt(n.trim()));
                return parts[0] === correctAns[0] && parts[1] === correctAns[1];
            }
        },

        'pipes-cisterns': {
            id: 'pipes-cisterns',
            category: 'Word Problems',
            tags: ['algebra'],
            title: 'Pipes & Cisterns | Fill Rate Trick',
            ctrHeadline: 'Tank Filling Problems Made Easy!',
            description: 'Similar to Time-Work. Combined rate = 1/A + 1/B (or minus for outlet).',
            difficulty: 'Intermediate',
            formula: 'Time together = (A × B) / (A + B)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Same as Time & Work! <strong>Inlet adds, Outlet subtracts</strong>.</p>

                    <!-- SVG Tank -->
                    <svg viewBox="0 0 280 140" style="width: 100%; max-width: 300px; display: block; margin: 16px auto;">
                        <!-- Tank -->
                        <rect x="80" y="40" width="120" height="80" fill="none" stroke="var(--text-secondary, #888)" stroke-width="3" rx="5"/>

                        <!-- Water level -->
                        <rect x="83" y="70" width="114" height="47" fill="var(--accent-primary, #6366f1)" opacity="0.3" rx="3"/>

                        <!-- Inlet pipe A -->
                        <path d="M60 30 L60 50 L80 50" fill="none" stroke="var(--success, #22c55e)" stroke-width="4"/>
                        <circle cx="50" cy="30" r="12" fill="var(--success, #22c55e)"/>
                        <text x="50" y="35" text-anchor="middle" font-size="12" font-weight="bold" fill="white">A</text>
                        <text x="30" y="60" font-size="9" fill="var(--text-muted, #888)">6 hrs</text>

                        <!-- Inlet pipe B -->
                        <path d="M220 30 L220 50 L200 50" fill="none" stroke="var(--warning, #f59e0b)" stroke-width="4"/>
                        <circle cx="230" cy="30" r="12" fill="var(--warning, #f59e0b)"/>
                        <text x="230" y="35" text-anchor="middle" font-size="12" font-weight="bold" fill="white">B</text>
                        <text x="245" y="60" font-size="9" fill="var(--text-muted, #888)">3 hrs</text>

                        <!-- Label -->
                        <text x="140" y="135" text-anchor="middle" font-size="11" fill="var(--text-secondary, #888)">Together: 2 hrs</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Pipe A fills in 6 hrs, Pipe B in 3 hrs. Together?</div>
                        <div class="step">Step 1: Use formula (A × B) / (A + B)</div>
                        <div class="step">Step 2: (6 × 3) / (6 + 3) = 18 / 9</div>
                        <div class="result">Together = 2 hours</div>
                    </div>

                    <p style="font-size: var(--text-sm); color: var(--text-muted); margin-top: var(--space-3);">
                        💡 <em>If one is an outlet:</em> Use (A × B) / (A - B) instead!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const pairs = [[6, 3], [12, 4], [10, 5], [8, 8], [15, 10], [12, 6]];
                const pair = pairs[Math.floor(Math.random() * pairs.length)];
                const together = (pair[0] * pair[1]) / (pair[0] + pair[1]);
                return {
                    text: 'Pipe A fills tank in ' + pair[0] + ' hrs, Pipe B in ' + pair[1] + ' hrs. Together?',
                    answer: together
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        'ages-problems': {
            id: 'ages-problems',
            category: 'Word Problems',
            tags: ['algebra', 'equations'],
            title: 'Ages Problems | Setup Trick',
            ctrHeadline: 'Decode Age Puzzles Systematically!',
            description: 'Let present age = x. Past = x - years, Future = x + years. Setup equation!',
            difficulty: 'Intermediate',
            formula: 'Present = x, Past = x - n, Future = x + n',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Use a <strong>variable for present age</strong>, then translate words to equations.</p>

                    <!-- Timeline SVG -->
                    <svg viewBox="0 0 340 80" style="width: 100%; max-width: 360px; display: block; margin: 16px auto;">
                        <line x1="30" y1="40" x2="310" y2="40" stroke="var(--text-secondary, #666)" stroke-width="2" marker-end="url(#arrow-age)"/>
                        <defs>
                            <marker id="arrow-age" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--text-secondary, #666)"/>
                            </marker>
                        </defs>

                        <!-- Past -->
                        <circle cx="70" cy="40" r="6" fill="var(--danger, #ef4444)"/>
                        <text x="70" y="65" text-anchor="middle" font-size="11" fill="var(--text-muted, #888)">5 yrs ago</text>
                        <text x="70" y="25" text-anchor="middle" font-size="12" font-weight="bold" fill="var(--danger, #ef4444)">x - 5</text>

                        <!-- Present -->
                        <circle cx="170" cy="40" r="8" fill="var(--accent-primary, #6366f1)"/>
                        <text x="170" y="65" text-anchor="middle" font-size="11" fill="var(--text-muted, #888)">Now</text>
                        <text x="170" y="25" text-anchor="middle" font-size="14" font-weight="bold" fill="var(--accent-primary, #6366f1)">x</text>

                        <!-- Future -->
                        <circle cx="270" cy="40" r="6" fill="var(--success, #22c55e)"/>
                        <text x="270" y="65" text-anchor="middle" font-size="11" fill="var(--text-muted, #888)">In 3 yrs</text>
                        <text x="270" y="25" text-anchor="middle" font-size="12" font-weight="bold" fill="var(--success, #22c55e)">x + 3</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">A is twice B's age. 5 years ago, A was 3× B's age. B's age now?</div>
                        <div class="step">Step 1: Let B = x, then A = 2x (now)</div>
                        <div class="step">Step 2: 5 years ago: A was 2x-5, B was x-5</div>
                        <div class="step">Step 3: Equation: 2x - 5 = 3(x - 5)</div>
                        <div class="step">Step 4: 2x - 5 = 3x - 15 → x = <strong>10</strong></div>
                        <div class="result">B is 10 years old</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                // Simple age problem: "In X years, I'll be Y times my current age"
                const age = Math.floor(Math.random() * 15) + 5; // 5-20
                const years = Math.floor(Math.random() * 10) + 2; // 2-12
                const futureAge = age + years;
                const ratio = Math.floor(futureAge / age);
                if (ratio >= 2 && futureAge === ratio * age) {
                    return {
                        text: 'In ' + years + ' years, I will be ' + ratio + ' times my current age. How old am I?',
                        answer: age
                    };
                }
                // Fallback: Father-son type
                const sonAge = Math.floor(Math.random() * 10) + 5;
                const fatherAge = sonAge * 3;
                return {
                    text: 'Father is ' + fatherAge + ' yrs old, son is ' + sonAge + '. In how many years will father be twice son\'s age?',
                    answer: fatherAge - 2 * sonAge
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'ages-difference': {
            id: 'ages-difference',
            category: 'Word Problems',
            tags: ['algebra', 'ages'],
            title: 'Age Difference Trick | Constant Method',
            ctrHeadline: 'This Age Trick NEVER Fails! The Difference is Key! 🔑',
            description: 'Learn the constant age difference shortcut for competitive exams. Solve age problems instantly - essential for SSC, Banking, Railway algebra questions.',
            difficulty: 'Beginner',
            formula: 'Age difference = Constant (never changes)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Key insight:</strong> Age difference is <strong>constant</strong> - it never changes!</p>

                    <!-- SVG Age Difference Visual -->
                    <svg viewBox="0 0 360 140" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Timeline -->
                            <line x1="30" y1="70" x2="330" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                            
                            <!-- Now -->
                            <g transform="translate(100, 0)">
                                <text x="0" y="30" font-size="12" fill="var(--text-muted, #888)">Now</text>
                                <circle cx="0" cy="50" r="15" fill="var(--accent-primary, #6366f1)"/>
                                <text x="0" y="55" font-size="11" font-weight="bold" fill="white">A: 30</text>
                                <circle cx="0" cy="90" r="15" fill="var(--warning, #f59e0b)"/>
                                <text x="0" y="95" font-size="11" font-weight="bold" fill="white">B: 20</text>
                                <line x1="-15" y1="50" x2="-15" y2="90" stroke="var(--success, #22c55e)" stroke-width="3"/>
                                <text x="-25" y="70" font-size="12" font-weight="bold" fill="var(--success, #22c55e)">10</text>
                            </g>

                            <!-- 5 years later -->
                            <g transform="translate(260, 0)">
                                <text x="0" y="30" font-size="12" fill="var(--text-muted, #888)">+5 yrs</text>
                                <circle cx="0" cy="50" r="15" fill="var(--accent-primary, #6366f1)"/>
                                <text x="0" y="55" font-size="11" font-weight="bold" fill="white">A: 35</text>
                                <circle cx="0" cy="90" r="15" fill="var(--warning, #f59e0b)"/>
                                <text x="0" y="95" font-size="11" font-weight="bold" fill="white">B: 25</text>
                                <line x1="-15" y1="50" x2="-15" y2="90" stroke="var(--success, #22c55e)" stroke-width="3"/>
                                <text x="-25" y="70" font-size="12" font-weight="bold" fill="var(--success, #22c55e)">10</text>
                            </g>

                            <!-- Arrow -->
                            <line x1="115" y1="70" x2="245" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2" marker-end="url(#arrow-diff)"/>
                            <defs>
                                <marker id="arrow-diff" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--text-secondary, #666)"/>
                                </marker>
                            </defs>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">A is 5 years older than B. Sum of ages is 35. Find their ages.</div>
                        <div class="step">Step 1: Let B = x, then A = x + 5</div>
                        <div class="step">Step 2: Sum: x + (x + 5) = 35</div>
                        <div class="step">Step 3: 2x + 5 = 35 → 2x = 30 → x = <strong>15</strong></div>
                        <div class="step">Step 4: B = 15, A = 20</div>
                        <div class="result">A is 20, B is 15</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Shortcut:</strong> If sum is S and difference is D, then older = (S+D)/2, younger = (S-D)/2
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const diff = Math.floor(Math.random() * 8) + 3; // 3-10
                const sum = Math.floor(Math.random() * 30) + 20; // 20-50
                const older = (sum + diff) / 2;
                const younger = (sum - diff) / 2;
                return {
                    text: 'A is ' + diff + ' years older than B. Sum of ages is ' + sum + '. B\'s age?',
                    answer: younger
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'ages-ratio': {
            id: 'ages-ratio',
            category: 'Word Problems',
            tags: ['algebra', 'ages', 'ratio'],
            title: 'Age Ratio Problems | Quick Formula Trick',
            ctrHeadline: 'Solve Age Ratio Questions in SECONDS! 💡',
            description: 'Master age ratio problems using the constant difference trick for competitive exams. Essential technique for SSC, Banking, Railway algebra word problems.',
            difficulty: 'Intermediate',
            formula: 'Ratio now vs ratio then, difference constant',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Ratios change, but <strong>difference stays constant</strong>. Use both facts!</p>

                    <!-- SVG Ratio Change -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Now -->
                            <text x="90" y="25" font-size="12" fill="var(--text-muted, #888)">Now</text>
                            <rect x="40" y="35" width="100" height="30" rx="5" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="90" y="55" font-size="14" font-weight="bold" fill="var(--accent-primary, #6366f1)">A : B = 3 : 2</text>

                            <!-- 5 years ago -->
                            <text x="270" y="25" font-size="12" fill="var(--text-muted, #888)">5 yrs ago</text>
                            <rect x="220" y="35" width="100" height="30" rx="5" fill="var(--warning, #f59e0b)" opacity="0.2"/>
                            <text x="270" y="55" font-size="14" font-weight="bold" fill="var(--warning, #f59e0b)">A : B = 5 : 3</text>

                            <!-- Difference arrow -->
                            <line x1="140" y1="50" x2="220" y2="50" stroke="var(--text-secondary, #666)" stroke-width="2" marker-end="url(#arrow-ratio)"/>
                            <defs>
                                <marker id="arrow-ratio" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--text-secondary, #666)"/>
                                </marker>
                            </defs>

                            <!-- Key insight -->
                            <text x="180" y="90" font-size="11" fill="var(--success, #22c55e)" font-weight="bold">Difference stays same!</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">A:B = 3:2 now. 5 years ago, A:B = 5:3. Find their ages.</div>
                        <div class="step">Step 1: Let A = 3x, B = 2x (now)</div>
                        <div class="step">Step 2: Difference = 3x - 2x = x (constant!)</div>
                        <div class="step">Step 3: 5 years ago: A = 3x-5, B = 2x-5</div>
                        <div class="step">Step 4: Ratio then: (3x-5)/(2x-5) = 5/3</div>
                        <div class="step">Step 5: Cross multiply: 9x - 15 = 10x - 25 → x = <strong>10</strong></div>
                        <div class="result">A = 30, B = 20</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const ratioNow = [3, 4, 5][Math.floor(Math.random() * 3)];
                const ratioThen = [2, 3, 4][Math.floor(Math.random() * 3)];
                const years = Math.floor(Math.random() * 5) + 3; // 3-7
                // Let A = ratioNow * x, B = x (now)
                // Then (ratioNow * x - years) / (x - years) = ratioThen / 1
                // Solve for x
                const x = years * (ratioThen - 1) / (ratioNow - ratioThen);
                if (x > 0 && x % 1 === 0) {
                    const a = ratioNow * x;
                    const b = x;
                    return {
                        text: 'A:B = ' + ratioNow + ':1 now. ' + years + ' years ago, A:B = ' + ratioThen + ':1. B\'s age now?',
                        answer: b
                    };
                }
                // Fallback
                return {
                    text: 'A:B = 3:2 now. 5 years ago, A:B = 5:3. B\'s age now?',
                    answer: 20
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'ages-sum': {
            id: 'ages-sum',
            category: 'Word Problems',
            tags: ['algebra', 'ages'],
            title: 'Age Sum Problems | Multiple People',
            ctrHeadline: 'Solve Age Sums with Multiple People!',
            description: 'When sum of ages is given, set up equations for each person and solve.',
            difficulty: 'Beginner',
            formula: 'Sum of all ages = Total',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">When multiple people are involved, set up equations for <strong>each person</strong>.</p>

                    <!-- SVG Multiple People -->
                    <svg viewBox="0 0 360 100" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Person 1 -->
                            <circle cx="80" cy="40" r="20" fill="var(--accent-primary, #6366f1)" opacity="0.8"/>
                            <text x="80" y="46" font-size="14" font-weight="bold" fill="white">A</text>
                            <text x="80" y="75" font-size="12" fill="var(--text-primary, #ddd)">x</text>

                            <!-- Person 2 -->
                            <circle cx="180" cy="40" r="20" fill="var(--warning, #f59e0b)" opacity="0.8"/>
                            <text x="180" y="46" font-size="14" font-weight="bold" fill="white">B</text>
                            <text x="180" y="75" font-size="12" fill="var(--text-primary, #ddd)">x + 5</text>

                            <!-- Person 3 -->
                            <circle cx="280" cy="40" r="20" fill="var(--success, #22c55e)" opacity="0.8"/>
                            <text x="280" y="46" font-size="14" font-weight="bold" fill="white">C</text>
                            <text x="280" y="75" font-size="12" fill="var(--text-primary, #ddd)">x + 10</text>

                            <!-- Plus signs -->
                            <text x="130" y="50" font-size="20" fill="var(--text-secondary, #666)">+</text>
                            <text x="230" y="50" font-size="20" fill="var(--text-secondary, #666)">+</text>

                            <!-- Sum -->
                            <text x="180" y="95" font-size="12" fill="var(--text-muted, #888)">Sum = 3x + 15</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">A, B, C ages sum to 60. B is 5 years older than A, C is 10 years older than A. Find A's age.</div>
                        <div class="step">Step 1: Let A = x, then B = x + 5, C = x + 10</div>
                        <div class="step">Step 2: Sum: x + (x + 5) + (x + 10) = 60</div>
                        <div class="step">Step 3: 3x + 15 = 60 → 3x = 45</div>
                        <div class="step">Step 4: x = <strong>15</strong></div>
                        <div class="result">A is 15 years old</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 15) + 10; // 10-25
                const diff1 = Math.floor(Math.random() * 5) + 3; // 3-7
                const diff2 = Math.floor(Math.random() * 5) + 6; // 6-10
                const sum = a + (a + diff1) + (a + diff2);
                return {
                    text: 'A, B, C ages sum to ' + sum + '. B is ' + diff1 + ' yrs older than A, C is ' + diff2 + ' yrs older than A. A\'s age?',
                    answer: a
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },

        'lcm-shortcut': {
            id: 'lcm-shortcut',
            category: 'Number Theory',
            tags: ['algebra', 'lcm'],
            title: 'LCM Shortcut Method | Product ÷ GCD',
            ctrHeadline: 'Find LCM of ANY 2 Numbers Instantly! 🚀',
            description: 'Learn the "Product ÷ GCD" shortcut to find LCM instantly for competitive exams. Fast technique for SSC, Banking, Railway number system questions.',
            difficulty: 'Intermediate',
            formula: 'LCM = (a × b) / GCD',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For two numbers: <strong>LCM = Product ÷ GCD</strong></p>

                    <div class="example-box">
                        <div class="problem">Find LCM of 12 and 18</div>
                        <div class="step">Step 1: Find GCD(12, 18)</div>
                        <div class="step visual-row">
                            <span>12 = 2 × 2 × 3</span>
                            <span>18 = 2 × 3 × 3</span>
                        </div>
                        <div class="step">Common: 2 × 3 = <strong>GCD = 6</strong></div>
                        <div class="step">Step 2: LCM = (12 × 18) ÷ 6 = 216 ÷ 6</div>
                        <div class="result">LCM = 36</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-4);">Quick GCD by subtraction:</p>
                    <div class="example-box">
                        <div class="step">GCD(18, 12) → 18-12=6 → GCD(12,6) → 12-6=6 → GCD(6,6) = <strong>6</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const gcd = (a, b) => b === 0 ? a : gcd(b, a % b);
                const a = Math.floor(Math.random() * 20) + 8;
                const b = Math.floor(Math.random() * 20) + 8;
                const lcm = (a * b) / gcd(a, b);
                return {
                    text: 'Find LCM of ' + a + ' and ' + b,
                    answer: lcm
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },

        'successive-discounts': {
            id: 'successive-discounts',
            category: 'Word Problems',
            tags: ['algebra', 'percentage', 'money'],
            title: 'Successive Discounts | Not Additive!',
            ctrHeadline: '20% + 10% off ≠ 30% off!',
            description: 'Multiple discounts compound. 20% then 10% = 28% total, not 30%!',
            difficulty: 'Intermediate',
            formula: 'Final = Original × (1 - d₁) × (1 - d₂)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Successive discounts don't add!</strong> Apply each to the reduced price.</p>

                    <!-- SVG Waterfall -->
                    <svg viewBox="0 0 320 120" style="width: 100%; max-width: 340px; display: block; margin: 16px auto;">
                        <g font-family="sans-serif" text-anchor="middle">
                            <!-- Original -->
                            <rect x="20" y="20" width="70" height="40" fill="var(--text-secondary, #666)" rx="5"/>
                            <text x="55" y="45" font-size="14" font-weight="bold" fill="white">₹100</text>
                            <text x="55" y="75" font-size="10" fill="var(--text-muted, #888)">Original</text>

                            <!-- Arrow 1 -->
                            <path d="M95 40 L115 40" stroke="var(--danger, #ef4444)" stroke-width="2" marker-end="url(#arr-d)"/>
                            <text x="105" y="30" font-size="9" fill="var(--danger, #ef4444)">-20%</text>

                            <!-- After first -->
                            <rect x="120" y="25" width="70" height="35" fill="var(--warning, #f59e0b)" rx="5"/>
                            <text x="155" y="47" font-size="13" font-weight="bold" fill="white">₹80</text>
                            <text x="155" y="75" font-size="10" fill="var(--text-muted, #888)">After 20%</text>

                            <!-- Arrow 2 -->
                            <path d="M195 42 L215 42" stroke="var(--danger, #ef4444)" stroke-width="2" marker-end="url(#arr-d)"/>
                            <text x="205" y="32" font-size="9" fill="var(--danger, #ef4444)">-10%</text>

                            <!-- Final -->
                            <rect x="220" y="30" width="70" height="30" fill="var(--success, #22c55e)" rx="5"/>
                            <text x="255" y="50" font-size="12" font-weight="bold" fill="white">₹72</text>
                            <text x="255" y="75" font-size="10" fill="var(--text-muted, #888)">Final</text>

                            <defs>
                                <marker id="arr-d" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto">
                                    <polygon points="0 0, 6 3, 0 6" fill="var(--danger, #ef4444)"/>
                                </marker>
                            </defs>
                        </g>

                        <text x="160" y="110" text-anchor="middle" font-size="11" fill="var(--accent-primary, #6366f1)" font-weight="bold">Total discount = 28%, NOT 30%!</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">₹100 with 20% off, then 10% off. Final price?</div>
                        <div class="step">Step 1: After 20% off → ₹100 × 0.80 = ₹80</div>
                        <div class="step">Step 2: After 10% off on ₹80 → ₹80 × 0.90 = <strong>₹72</strong></div>
                        <div class="result">Final = ₹72 (28% total discount)</div>
                    </div>

                    <p style="font-size: var(--text-sm); color: var(--text-muted); margin-top: var(--space-3);">
                        💡 <em>Quick formula:</em> Total discount% = d₁ + d₂ - (d₁ × d₂)/100
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const original = [100, 200, 500, 1000][Math.floor(Math.random() * 4)];
                const d1 = [10, 15, 20, 25][Math.floor(Math.random() * 4)];
                const d2 = [5, 10, 15, 20][Math.floor(Math.random() * 4)];
                const final = original * (1 - d1 / 100) * (1 - d2 / 100);
                return {
                    text: '₹' + original + ' with ' + d1 + '% off, then ' + d2 + '% off. Final price?',
                    answer: final
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        }
    });
})();


