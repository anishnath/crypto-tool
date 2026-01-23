/**
 * Quick Math Topics - Multiplication & Squares
 */

(function registerMultiplicationTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'multiply-11': {
            id: 'multiply-11',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply Any Number by 11 | Mental Math Trick',
            ctrHeadline: 'The Magic of 11: Multiply in 2 Seconds!',
            description: 'Master the "Split and Add" method to multiply any 2-digit number by 11 without paper.',
            difficulty: 'Beginner',
            formula: '23 × 11 → 2 [2+3] 3 → 253',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">To multiply a 2-digit number by 11, just <strong>Split and Add</strong>.</p>

                    <!-- SVG visual for 23 × 11 = 253 -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 420px; display: block; margin: 16px auto;">
                        <!-- Boxes for digits -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle" font-size="20">
                            <!-- Left digit -->
                            <rect x="40" y="25" width="70" height="50" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.9" />
                            <text x="75" y="58" fill="#fff">2</text>

                            <!-- Middle gap / sum -->
                            <rect x="145" y="25" width="70" height="50" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.9" />
                            <text x="180" y="48" fill="#fff" font-size="14">2 + 3</text>
                            <text x="180" y="68" fill="#fff">5</text>

                            <!-- Right digit -->
                            <rect x="250" y="25" width="70" height="50" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.9" />
                            <text x="285" y="58" fill="#fff">3</text>
                        </g>

                        <!-- Result label -->
                        <g font-size="16" font-weight="bold" fill="var(--success, #22c55e)">
                            <text x="180" y="100" text-anchor="middle">23 × 11 = 253</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">23 × 11 = ?</div>
                        <div class="step">Step 1: Write the digits with a space → <strong>2 _ 3</strong></div>
                        <div class="step">Step 2: Add digits → 2 + 3 = <strong>5</strong></div>
                        <div class="step">Step 3: Put 5 in the middle → <strong>2 5 3</strong></div>
                        <div class="result">Answer: 253</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>With carry:</strong> 58 × 11 → think 5 _ 8, 5+8=13, carry 1 → <strong>638</strong>.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 88) + 11;
                return {
                    text: `${a} × 11 = ?`,
                    answer: a * 11
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'square-5': {
            id: 'square-5',
            category: 'Speed Math',
            tags: ['multiplication', 'squares'],
            title: 'Square Numbers Ending in 5 | Mental Math',
            ctrHeadline: 'Square Numbers Ending in 5 Instantly!',
            description: 'Calculate squares like 35², 65², 95² in your head instantly with this simple trick.',
            difficulty: 'Intermediate',
            formula: 'N5² → (N × (N+1)) | 25',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Any number ending in 5, when squared, <strong>always ends in 25</strong>.</p>
                    <div class="example-box">
                        <div class="problem">35² = ?</div>
                        <div class="step">Step 1: Take the first digit → <strong>3</strong></div>
                        <div class="step">Step 2: Multiply it by the next number → 3 × 4 = <strong>12</strong></div>
                        <div class="step">Step 3: Append 25 to the result → <strong>12</strong> + <strong>25</strong></div>
                        <div class="result">Answer: 1225</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const roots = [15, 25, 35, 45, 55, 65, 75, 85, 95];
                const n = roots[Math.floor(Math.random() * roots.length)];
                return {
                    text: `${n}² = ?`,
                    answer: n * n
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-x4': {
            id: 'multiplication-x4',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply by 4 | Double Twice',
            ctrHeadline: 'Multiply by 4? Just Double-Double!',
            description: 'Don\'t memorize 4x tables for big numbers. Just double the number twice.',
            difficulty: 'Beginner',
            formula: '16 × 4 → 16 × 2 = 32 → 32 × 2 = 64',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">To multiply by 4, just <strong>Double</strong> and then <strong>Double again</strong>.</p>
                    <div class="example-box">
                        <div class="problem">36 × 4 = ?</div>
                        <div class="step">Step 1: Double once → 36 + 36 = <strong>72</strong></div>
                        <div class="step">Step 2: Double again → 72 + 72 = <strong>144</strong></div>
                        <div class="result">Answer: 144</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 40) + 12; // 12-51
                return {
                    text: `${a} × 4 = ?`,
                    answer: a * 4
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-x5': {
            id: 'multiplication-x5',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply by 5 | Halve & Ten',
            ctrHeadline: 'The x5 Trick: Cut in Half, Add a Zero',
            description: 'Multiplying by 5 is the same as multiplying by 10/2. Halve the number, then multiply by 10.',
            difficulty: 'Beginner',
            formula: '46 × 5 → 46/2 = 23 → 230',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">5 is half of 10. So <strong>Halve the number</strong> and multiply by 10.</p>
                    <div class="example-box">
                        <div class="problem">64 × 5 = ?</div>
                        <div class="step">Step 1: Halve it → 64 ÷ 2 = <strong>32</strong></div>
                        <div class="step">Step 2: Multiply by 10 (add 0) → <strong>320</strong></div>
                        <div class="result">Answer: 320</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Odd numbers?</strong> 37 × 5 → Half 37 is 18.5 → Move decimal = 185
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 80) + 12;
                return {
                    text: `${a} × 5 = ?`,
                    answer: a * 5
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-x9': {
            id: 'multiplication-x9',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply by 9 | The x10 - x1 Trick',
            ctrHeadline: 'Multiply by 9 without memorizing!',
            description: 'Multiply by 10 (easy) and subtract the original number once.',
            difficulty: 'Beginner',
            formula: '24 × 9 → 240 - 24 = 216',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">9 is (10 - 1). So multiply by 10, then <strong>subtract the number</strong>.</p>
                    <div class="example-box">
                        <div class="problem">24 × 9 = ?</div>
                        <div class="step">Step 1: Multiply by 10 → 240</div>
                        <div class="step">Step 2: Subtract original (24) → 240 - 24 = ?</div>
                        <div class="step">Step 3: (240 - 20 - 4) → 220 - 4 = <strong>216</strong></div>
                        <div class="result">Answer: 216</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 50) + 11;
                return {
                    text: `${a} × 9 = ?`,
                    answer: a * 9
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-teens': {
            id: 'multiplication-teens',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiplying Teens (12-19) | Mental Math',
            ctrHeadline: 'Multiply 12 to 19 Instantly!',
            description: 'A special "Base 10" trick to multiply numbers between 11 and 19 instantly.',
            difficulty: 'Intermediate',
            formula: '12 × 13 → (12+3) × 10 + (2×3) = 156',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For 12-19: Add the ones digit of one to the other number, then add the product of ones.</p>
                    <div class="example-box">
                        <div class="problem">12 × 13 = ?</div>
                        <div class="step">Step 1: Add unit digit of second to first → 12 + 3 = <strong>15</strong></div>
                        <div class="step">Step 2: Multiply by 10 → <strong>150</strong></div>
                        <div class="step">Step 3: Multiply unit digits → 2 × 3 = <strong>6</strong></div>
                        <div class="step">Step 4: Add them → 150 + 6 = <strong>156</strong></div>
                        <div class="result">Answer: 156</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 8) + 12; // 12-19
                const b = Math.floor(Math.random() * 8) + 12;
                return {
                    text: `${a} × ${b} = ?`,
                    answer: a * b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-base100': {
            id: 'multiplication-base100',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiplication Near 100 | Base Method',
            ctrHeadline: '96 × 97 in 3 Seconds? Yes!',
            description: 'The famous "Base Method". Find the deficit from 100, cross-subtract, and multiply deficits.',
            difficulty: 'Intermediate',
            formula: '96 × 97 → (-4, -3) → (96-3) | (-4*-3) → 9312',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Find how far each number is from 100. <strong>Cross-subtract</strong> to get the first part, <strong>Multiply deficits</strong> for the second.</p>
                    
                    <!-- SVG Base 100 Visual -->
                    <svg viewBox="0 0 320 160" style="width: 100%; max-width: 360px; display: block; margin: 16px auto;">
                        <defs>
                            <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="#888"/>
                            </marker>
                        </defs>

                        <!-- Numbers Column -->
                        <text x="60" y="30" font-weight="bold" fill="var(--text-secondary)" font-size="14" text-anchor="middle">Number</text>
                        <text x="60" y="60" font-weight="bold" fill="var(--text-primary)" font-size="24" text-anchor="middle">96</text>
                        <text x="60" y="100" font-weight="bold" fill="var(--text-primary)" font-size="24" text-anchor="middle">97</text>

                        <!-- Deficits Column -->
                        <text x="260" y="30" font-weight="bold" fill="var(--text-secondary)" font-size="14" text-anchor="middle">Deficit</text>
                        <text x="260" y="60" font-weight="bold" fill="var(--danger, #ef4444)" font-size="24" text-anchor="middle">-04</text>
                        <text x="260" y="100" font-weight="bold" fill="var(--danger, #ef4444)" font-size="24" text-anchor="middle">-03</text>

                        <!-- Cross Lines (Arrows) -->
                        <line x1="80" y1="55" x2="230" y2="100" stroke="var(--accent-primary, #6366f1)" stroke-width="2" opacity="0.4" marker-end="url(#arrowhead)"/>
                        <line x1="80" y1="95" x2="230" y2="50" stroke="var(--accent-primary, #6366f1)" stroke-width="2" opacity="0.4" marker-end="url(#arrowhead)"/>

                        <!-- Separation Line -->
                        <line x1="20" y1="120" x2="300" y2="120" stroke="var(--border)" stroke-width="2"/>

                        <!-- Result Row -->
                        <g font-size="28" font-weight="bold" font-family="monospace">
                            <!-- Left Part (96 - 3 = 93) -->
                            <text x="80" y="150" fill="var(--accent-primary, #6366f1)" text-anchor="middle">93</text>
                            
                            <!-- Divider -->
                            <line x1="160" y1="130" x2="160" y2="155" stroke="var(--border)" stroke-width="1" stroke-dasharray="4"/>

                            <!-- Right Part (4 * 3 = 12) -->
                            <text x="240" y="150" fill="var(--success, #22c55e)" text-anchor="middle">12</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">96 × 97 = ?</div>
                        <div class="step">Step 1: Deficits from 100 → <strong>-04</strong> and <strong>-03</strong></div>
                        <div class="step">Step 2: Cross Subtract (96 - 3 or 97 - 4) → <strong>93</strong></div>
                        <div class="step">Step 3: Multiply Deficits (-4 × -3) → <strong>12</strong></div>
                        <div class="result">Result: 9312</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 11) + 88; // 88-99
                const b = Math.floor(Math.random() * 11) + 88;
                return {
                    text: `${a} × ${b} = ?`,
                    answer: a * b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-crisscross': {
            id: 'multiplication-crisscross',
            category: 'Speed Math',
            tags: ['multiplication', 'advanced'],
            title: '2-Digit × 2-Digit | Criss-Cross Method',
            ctrHeadline: 'Multiply ANY 2-digit numbers mentally!',
            description: 'The "Master Key" of Vedic Math. Vertically and Crosswise.',
            difficulty: 'Advanced',
            formula: '21 × 32 → (2×3) | (2×2 + 1×3) | (1×2) → 672',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Visualize 3 patterns: <strong>Right</strong>, <strong>Cross</strong>, <strong>Left</strong>.</p>
                    
                    <!-- SVG Criss Cross Visual -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <!-- Pattern 1: Right Vertical -->
                        <g transform="translate(40, 20)">
                            <text x="30" y="-5" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Step 1</text>
                            <circle cx="15" cy="15" r="4" fill="#ddd" />
                            <circle cx="45" cy="15" r="4" fill="var(--accent-primary, #6366f1)" />
                            <circle cx="15" cy="55" r="4" fill="#ddd" />
                            <circle cx="45" cy="55" r="4" fill="var(--accent-primary, #6366f1)" />
                            <line x1="45" y1="15" x2="45" y2="55" stroke="var(--accent-primary, #6366f1)" stroke-width="3" />
                        </g>

                        <!-- Pattern 2: Criss Cross -->
                        <g transform="translate(140, 20)">
                            <text x="30" y="-5" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Step 2</text>
                            <circle cx="15" cy="15" r="4" fill="var(--warning, #f59e0b)" />
                            <circle cx="45" cy="15" r="4" fill="var(--warning, #f59e0b)" />
                            <circle cx="15" cy="55" r="4" fill="var(--warning, #f59e0b)" />
                            <circle cx="45" cy="55" r="4" fill="var(--warning, #f59e0b)" />
                            <line x1="15" y1="15" x2="45" y2="55" stroke="var(--warning, #f59e0b)" stroke-width="3" />
                            <line x1="45" y1="15" x2="15" y2="55" stroke="var(--warning, #f59e0b)" stroke-width="3" />
                        </g>

                        <!-- Pattern 3: Left Vertical -->
                        <g transform="translate(240, 20)">
                            <text x="30" y="-5" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Step 3</text>
                            <circle cx="15" cy="15" r="4" fill="var(--success, #22c55e)" />
                            <circle cx="45" cy="15" r="4" fill="#ddd" />
                            <circle cx="15" cy="55" r="4" fill="var(--success, #22c55e)" />
                            <circle cx="45" cy="55" r="4" fill="#ddd" />
                            <line x1="15" y1="15" x2="15" y2="55" stroke="var(--success, #22c55e)" stroke-width="3" />
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">21 × 23 = ?</div>
                        <div class="step">Step 1 (Right): Multiply right digits (1×3) = <strong>3</strong></div>
                        <div class="step">Step 2 (Cross): Crossiply & add (2×3) + (1×2) = 6+2 = <strong>8</strong></div>
                        <div class="step">Step 3 (Left): Multiply left digits (2×2) = <strong>4</strong></div>
                        <div class="result">Answer: 483</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 40) + 12;
                const b = Math.floor(Math.random() * 40) + 12;
                return {
                    text: `${a} × ${b} = ?`,
                    answer: a * b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-x2x3': {
            id: 'multiplication-x2x3',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply by 2 and 3 | Build from Doubling',
            ctrHeadline: '×2 and ×3 without “tables” – just doubling!',
            description: 'See ×2 as doubling and ×3 as double + original. A core building block for all mental multiplication.',
            difficulty: 'Beginner',
            formula: '37 × 3 → (37 × 2) + 37 → 74 + 37 = 111',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Instead of memorizing separate tables, <strong>build ×3 from ×2</strong>.</p>
                    <div class="example-box">
                        <div class="problem">37 × 3 = ?</div>
                        <div class="step">Step 1: Double 37 → 37 × 2 = <strong>74</strong></div>
                        <div class="step">Step 2: Add the original once more → 74 + 37 = <strong>111</strong></div>
                        <div class="result">Answer: 111</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Key idea:</strong> ×2 = double, ×3 = double + original.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 80) + 12; // 12–91
                const multipliers = [2, 3];
                const m = multipliers[Math.floor(Math.random() * multipliers.length)];
                return {
                    text: `${a} × ${m} = ?`,
                    answer: a * m
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-x6x8': {
            id: 'multiplication-x6x8',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply by 6 and 8 | Repeated Doubling',
            ctrHeadline: 'Turn ×6 and ×8 into simple doubling steps',
            description: 'See ×6 as (×3 then double) and ×8 as doubling three times. Great for larger numbers.',
            difficulty: 'Beginner',
            formula: '27 × 6 → (27 × 3) × 2 = 81 × 2 = 162',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Use <strong>repeated doubling</strong> so you never feel stuck on 6 or 8 times tables.</p>

                    <!-- SVG: Doubling chain visual -->
                    <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <!-- 19 × 8 chain: 19 → 38 → 76 → 152 -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle" font-size="16">
                            <circle cx="40" cy="60" r="18" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="40" y="64" fill="#fff">19</text>

                            <circle cx="130" cy="60" r="18" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="130" y="64" fill="#fff">38</text>

                            <circle cx="220" cy="60" r="18" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="220" y="64" fill="#fff">76</text>

                            <circle cx="310" cy="60" r="18" fill="var(--success, #22c55e)" opacity="0.95"/>
                            <text x="310" y="64" fill="#fff">152</text>
                        </g>

                        <!-- Arrows with ×2 labels -->
                        <g stroke="var(--text-muted, #888)" stroke-width="2" fill="none" marker-end="url(#arrowhead-x6x8)">
                            <defs>
                                <marker id="arrowhead-x6x8" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--text-muted, #888)"/>
                                </marker>
                            </defs>
                            <line x1="58" y1="60" x2="112" y2="60"/>
                            <line x1="148" y1="60" x2="202" y2="60"/>
                            <line x1="238" y1="60" x2="292" y2="60"/>

                            <text x="85" y="45" font-size="13" fill="var(--text-secondary, #666)">×2</text>
                            <text x="175" y="45" font-size="13" fill="var(--text-secondary, #666)">×2</text>
                            <text x="265" y="45" font-size="13" fill="var(--text-secondary, #666)">×2</text>
                        </g>

                        <text x="190" y="100" text-anchor="middle" font-size="14" fill="var(--text-secondary, #666)" font-weight="bold">
                            19 × 8 = double 3 times → 19 → 38 → 76 → 152
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">27 × 6 = ?</div>
                        <div class="step">Step 1: ×3 using double + original → 27 × 3 = (27 × 2) + 27 = 54 + 27 = <strong>81</strong></div>
                        <div class="step">Step 2: Double that for ×6 → 81 × 2 = <strong>162</strong></div>
                        <div class="result">Answer: 162</div>
                    </div>
                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">19 × 8 = ?</div>
                        <div class="step">Double 19 → 38</div>
                        <div class="step">Double again → 76</div>
                        <div class="step">Double a third time → <strong>152</strong></div>
                        <div class="result">Answer: 152</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 70) + 10; // 10–79
                const multipliers = [6, 8];
                const m = multipliers[Math.floor(Math.random() * multipliers.length)];
                return {
                    text: `${a} × ${m} = ?`,
                    answer: a * m
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-x25': {
            id: 'multiplication-x25',
            category: 'Speed Math',
            tags: ['multiplication', 'money'],
            title: 'Multiply by 25 | Quarter of 100',
            ctrHeadline: '×25? Divide by 4 and add two zeros!',
            description: '25 is one quarter of 100. Multiply by 100 (easy), then divide by 4.',
            difficulty: 'Intermediate',
            formula: '36 × 25 → 36 × 100 ÷ 4 = 3600 ÷ 4 = 900',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Use the fact that <strong>25 = 100 ÷ 4</strong>.</p>
                    <div class="example-box">
                        <div class="problem">36 × 25 = ?</div>
                        <div class="step">Step 1: Multiply 36 by 100 → <strong>3600</strong></div>
                        <div class="step">Step 2: Divide by 4 → 3600 ÷ 4 = <strong>900</strong></div>
                        <div class="result">Answer: 900</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Short way:</strong> Divide the number by 4, then add two zeros. 36 ÷ 4 = 9 → 900.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = (Math.floor(Math.random() * 30) + 4) * 4; // multiple of 4 for clean division
                return {
                    text: `${a} × 25 = ?`,
                    answer: a * 25
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-x99': {
            id: 'multiplication-x99',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply by 99 | “×100 − original”',
            ctrHeadline: 'Turn ×99 into “add two zeros and subtract once”',
            description: '99 is just 100 - 1. Multiply by 100, then subtract the original number.',
            difficulty: 'Intermediate',
            formula: '47 × 99 → 4700 - 47 = 4653',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Think of 99 as <strong>100 − 1</strong>.</p>
                    <div class="example-box">
                        <div class="problem">47 × 99 = ?</div>
                        <div class="step">Step 1: Multiply by 100 → 47 → <strong>4700</strong></div>
                        <div class="step">Step 2: Subtract the original once → 4700 - 47 = <strong>4653</strong></div>
                        <div class="result">Answer: 4653</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Same idea:</strong> 99 = 100 - 1, 999 = 1000 - 1.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 90) + 10; // 10–99
                return {
                    text: `${a} × 99 = ?`,
                    answer: a * 99
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-2digit-1digit': {
            id: 'multiplication-2digit-1digit',
            category: 'Speed Math',
            tags: ['multiplication'],
            title: 'Multiply 97×8 INSTANTLY! | Split Method Trick',
            ctrHeadline: '2-Digit × 1-Digit in Your HEAD? This Changes Everything! 🚀',
            description: 'Learn the tens-and-ones split method to multiply 2-digit by 1-digit numbers mentally for competitive exams. Essential speed math for SSC, Banking, and Railway exams.',
            difficulty: 'Beginner',
            formula: '34 × 7 → (30 × 7) + (4 × 7) = 210 + 28 = 238',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Turn any 2-digit × 1-digit into <strong>two easy mini problems</strong>.</p>

                    <!-- SVG: Split tens and ones -->
                    <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <!-- 34 split into 30 and 4 -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Whole number bar -->
                            <rect x="40" y="30" width="120" height="40" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.15"/>
                            <!-- Tens part -->
                            <rect x="40" y="30" width="80" height="40" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="80" y="56" font-size="18" fill="#fff">30</text>
                            <!-- Ones part -->
                            <rect x="120" y="30" width="40" height="40" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.95"/>
                            <text x="140" y="56" font-size="18" fill="#fff">4</text>

                            <!-- Multiplication by 7 -->
                            <text x="200" y="54" font-size="20" fill="var(--text-primary, #111)">× 7</text>

                            <!-- Results -->
                            <rect x="250" y="20" width="100" height="30" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="300" y="40" font-size="16" fill="#fff">30 × 7 = 210</text>

                            <rect x="250" y="60" width="100" height="30" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.9"/>
                            <text x="300" y="80" font-size="16" fill="#fff">4 × 7 = 28</text>
                        </g>

                        <text x="190" y="108" text-anchor="middle" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">
                            210 + 28 = 238
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">34 × 7 = ?</div>
                        <div class="step">Step 1: Split 34 into 30 and 4</div>
                        <div class="step">Step 2: Multiply tens → 30 × 7 = <strong>210</strong></div>
                        <div class="step">Step 3: Multiply ones → 4 × 7 = <strong>28</strong></div>
                        <div class="step">Step 4: Add them → 210 + 28 = <strong>238</strong></div>
                        <div class="result">Answer: 238</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 80) + 12; // 12–91
                const b = Math.floor(Math.random() * 8) + 2;  // 2–9
                return {
                    text: `${a} × ${b} = ?`,
                    answer: a * b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-decimal-scale': {
            id: 'multiplication-decimal-scale',
            category: 'Speed Math',
            tags: ['multiplication', 'decimals'],
            title: 'Decimals & Powers of 10 | Move the Dot',
            ctrHeadline: '×10, ×100, ×0.1 – just shift the decimal point',
            description: 'First multiply as if there were no decimals, then place the decimal point using place values.',
            difficulty: 'Beginner',
            formula: '3.4 × 50 → 34 × 5 ÷ 10 = 170 ÷ 10 = 17',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Handle the <strong>whole-number part</strong> first, then adjust the decimal.</p>

                    <!-- SVG for decimal point movement -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 420px; display: block; margin: 16px auto;">
                        <!-- Original expression -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <text x="60" y="40" font-size="20" fill="var(--text-primary, #111)">3.4</text>
                            <text x="105" y="40" font-size="18" fill="var(--text-secondary, #666)">×</text>
                            <text x="140" y="40" font-size="20" fill="var(--text-primary, #111)">50</text>
                        </g>

                        <!-- Whole-number product -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <rect x="40" y="55" width="80" height="32" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.1" />
                            <text x="80" y="76" font-size="18" fill="var(--accent-primary, #6366f1)">34 × 5 = 170</text>
                        </g>

                        <!-- Decimal shift arrow -->
                        <g stroke="var(--success, #22c55e)" stroke-width="2" marker-end="url(#arrowhead-decimal)">
                            <defs>
                                <marker id="arrowhead-decimal" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--success, #22c55e)"/>
                                </marker>
                            </defs>
                            <line x1="220" y1="70" x2="300" y2="70"/>
                        </g>

                        <!-- Final answer -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <text x="220" y="50" font-size="14" fill="var(--text-secondary, #666)">move decimal 1 place left</text>
                            <text x="300" y="76" font-size="22" fill="var(--success, #22c55e)">17.0 → 17</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">3.4 × 50 = ?</div>
                        <div class="step">Step 1: Ignore the decimal → 34 × 5 = <strong>170</strong></div>
                        <div class="step">Step 2: There is 1 decimal place in 3.4, and an extra ×10 from 50</div>
                        <div class="step">Step 3: Adjust by moving the decimal 1 place left → 170 → <strong>17.0</strong></div>
                        <div class="result">Answer: 17</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Rule of thumb:</strong> Count total decimal places in the factors and place them in the answer.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const whole = [20, 30, 40, 50, 200, 500][Math.floor(Math.random() * 6)];
                const decimal = (Math.floor(Math.random() * 90) + 11) / 10; // 1.1–10.0
                return {
                    text: `${decimal} × ${whole} = ?`,
                    answer: decimal * whole
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'square-near-base': {
            id: 'square-near-base',
            category: 'Speed Math',
            tags: ['multiplication', 'squares'],
            title: 'Squares Near 10 or 100 | (a ± b)² Trick',
            ctrHeadline: '41² or 99² in your head using “difference from base”',
            description: 'Use (a ± b)² = a² ± 2ab + b² for numbers close to 10 or 100.',
            difficulty: 'Intermediate',
            formula: '99² → (100 − 1)² = 10000 − 200 + 1 = 9801',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">If a number is very close to a power of 10, square the base and adjust.</p>

                    <!-- SVG: Decompose 99² with base 100 -->
                    <svg viewBox="0 0 380 150" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Number line style base and number -->
                            <text x="60" y="30" font-size="16" fill="var(--text-secondary, #666)">Base</text>
                            <circle cx="60" cy="60" r="18" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="60" y="64" fill="#fff">100</text>

                            <text x="170" y="30" font-size="16" fill="var(--text-secondary, #666)">Number</text>
                            <circle cx="170" cy="60" r="18" fill="var(--warning, #f59e0b)" opacity="0.95"/>
                            <text x="170" y="64" fill="#fff">99</text>

                            <!-- Difference label -->
                            <text x="115" y="52" font-size="14" fill="var(--danger, #ef4444)">−1</text>
                            <line x1="78" y1="60" x2="152" y2="60" stroke="var(--danger, #ef4444)" stroke-width="2" marker-end="url(#arrowhead-sqbase)"/>
                        </g>

                        <defs>
                            <marker id="arrowhead-sqbase" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--danger, #ef4444)"/>
                            </marker>
                        </defs>

                        <!-- Decomposition (100 − 1)² -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <rect x="30" y="90" width="90" height="30" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="75" y="110" font-size="14" fill="#fff">100² = 10000</text>

                            <rect x="140" y="90" width="100" height="30" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.9"/>
                            <text x="190" y="110" font-size="14" fill="#fff">−2×100×1 = −200</text>

                            <rect x="260" y="90" width="70" height="30" rx="6" ry="6" fill="var(--success, #22c55e)" opacity="0.9"/>
                            <text x="295" y="110" font-size="14" fill="#fff">1² = 1</text>
                        </g>

                        <text x="190" y="140" text-anchor="middle" font-size="16" fill="var(--success, #22c55e)" font-weight="bold">
                            10000 − 200 + 1 = 9801
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">99² = ?</div>
                        <div class="step">Step 1: Think of 99 as 100 − 1</div>
                        <div class="step">Step 2: (100 − 1)² = 100² − 2×100×1 + 1²</div>
                        <div class="step">Step 3: 10000 − 200 + 1 = <strong>9801</strong></div>
                        <div class="result">Answer: 9801</div>
                    </div>
                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">41² = ?</div>
                        <div class="step">Step 1: Think of 41 as 40 + 1</div>
                        <div class="step">Step 2: (40 + 1)² = 40² + 2×40×1 + 1²</div>
                        <div class="step">Step 3: 1600 + 80 + 1 = <strong>1681</strong></div>
                        <div class="result">Answer: 1681</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const candidates = [39, 41, 49, 51, 89, 91, 99, 101];
                const n = candidates[Math.floor(Math.random() * candidates.length)];
                return {
                    text: `${n}² = ?`,
                    answer: n * n
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'multiplication-verify9': {
            id: 'multiplication-verify9',
            category: 'Speed Math',
            tags: ['multiplication', 'verification'],
            title: 'Casting Out 9s for Multiplication | Quick Check',
            ctrHeadline: 'Check products in seconds using digit sums',
            description: 'Use the same casting out 9s idea from addition to quickly verify if a product is likely correct.',
            difficulty: 'Intermediate',
            formula: 'DigitSum(A) × DigitSum(B) and DigitSum(Product) should match (mod 9)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">If the reduced digit sums don&apos;t match, the multiplication is definitely wrong.</p>

                    <!-- SVG: Digit sum flow for 27 × 34 = 918 -->
                    <svg viewBox="0 0 380 150" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <!-- Columns: A, B, Product -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- A -->
                            <text x="60" y="30" font-size="14" fill="var(--text-secondary, #666)">A</text>
                            <rect x="30" y="40" width="60" height="32" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="60" y="61" font-size="18" fill="#fff">27</text>

                            <!-- B -->
                            <text x="190" y="30" font-size="14" fill="var(--text-secondary, #666)">B</text>
                            <rect x="160" y="40" width="60" height="32" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="190" y="61" font-size="18" fill="#fff">34</text>

                            <!-- Product -->
                            <text x="320" y="30" font-size="14" fill="var(--text-secondary, #666)">A × B</text>
                            <rect x="290" y="40" width="60" height="32" rx="6" ry="6" fill="var(--success, #22c55e)" opacity="0.9"/>
                            <text x="320" y="61" font-size="18" fill="#fff">918</text>
                        </g>

                        <!-- Digit sums -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Sum of digits of A -->
                            <rect x="30" y="85" width="60" height="28" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.9"/>
                            <text x="60" y="104" font-size="14" fill="#fff">2+7 = 9</text>

                            <!-- Sum of digits of B -->
                            <rect x="160" y="85" width="60" height="28" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.9"/>
                            <text x="190" y="104" font-size="14" fill="#fff">3+4 = 7</text>

                            <!-- Sum of digits of product -->
                            <rect x="290" y="85" width="60" height="28" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.9"/>
                            <text x="320" y="104" font-size="14" fill="#fff">9+1+8 = 18 → 9</text>
                        </g>

                        <text x="190" y="135" text-anchor="middle" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">
                            Remainder mod 9: (9 × 7) ≡ 0 and 918 ≡ 0 → match ✓
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Check: 27 × 34 = 918</div>
                        <div class="step">Step 1: Digit sum of 27 → 2 + 7 = 9 → treat as <strong>9</strong> (or 0 in mod 9)</div>
                        <div class="step">Step 2: Digit sum of 34 → 3 + 4 = <strong>7</strong></div>
                        <div class="step">Step 3: 9 × 7 has the same remainder as 0 × 7 → <strong>0 mod 9</strong></div>
                        <div class="step">Step 4: Digit sum of 918 → 9 + 1 + 8 = 18 → 1 + 8 = <strong>9</strong> → 0 mod 9</div>
                        <div class="result">Remainders match → product is likely correct.</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Warning:</strong> If they don&apos;t match, it&apos;s definitely wrong. If they match, it&apos;s probably right (but not 100% guaranteed).
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 80) + 12;
                const b = Math.floor(Math.random() * 80) + 12;
                const correct = a * b;
                const isCorrect = Math.random() > 0.4;
                const shown = isCorrect ? correct : correct + (Math.random() > 0.5 ? 9 : -9);
                return {
                    text: `Is ${a} × ${b} = ${shown} correct? (yes/no)`,
                    answer: isCorrect ? 'yes' : 'no'
                };
            },
            checkAnswer: (userAns, correctAns) => userAns.toLowerCase().trim() === correctAns
        }
    });
})();


