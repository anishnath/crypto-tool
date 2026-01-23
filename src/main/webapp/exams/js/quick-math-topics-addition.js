/**
 * Quick Math Topics - Addition & Subtraction
 */

(function registerAdditionTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'addition-rapid': {
            id: 'addition-rapid',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Rapid Addition Tricks | Mental Math Practice',
            ctrHeadline: 'Add Numbers Faster Than a Calculator!',
            description: 'Learn the Left-to-Right addition trick to solve 2-digit and 3-digit additions instantly.',
            difficulty: 'Beginner',
            formula: 'Break numbers: 47 + 32 → (40+30) + (7+2) = 79',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Traditional addition goes Right-to-Left. <strong>Fast addition goes Left-to-Right.</strong></p>
                    <div class="example-box">
                        <div class="problem">47 + 32 = ?</div>
                        <div class="step">Step 1: Split into tens and ones → <strong>40 + 7</strong> and <strong>30 + 2</strong></div>
                        <div class="step">Step 2: Add the tens → 40 + 30 = <strong>70</strong></div>
                        <div class="step">Step 3: Add the ones → 7 + 2 = <strong>9</strong></div>
                        <div class="step">Step 4: Combine → 70 + 9 = <strong>79</strong></div>
                        <div class="result">Answer: 79</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 80) + 10;
                const b = Math.floor(Math.random() * 80) + 10;
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-add9': {
            id: 'addition-add9',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Add 9 Instantly | Mental Math Trick',
            ctrHeadline: 'The +9 Shortcut: Add 10, Subtract 1!',
            description: 'Adding 9 is easy when you add 10 first and subtract 1. Works for 19, 29, 99 too!',
            difficulty: 'Beginner',
            formula: 'N + 9 = N + 10 - 1',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Adding 9 is hard. Adding 10 is easy. <strong>So add 10, then subtract 1!</strong></p>
                    <div class="example-box">
                        <div class="problem">47 + 9 = ?</div>
                        <div class="step">Step 1: Instead of +9, think <strong>+10 - 1</strong></div>
                        <div class="step">Step 2: Add 10 → 47 + 10 = <strong>57</strong></div>
                        <div class="step">Step 3: Subtract 1 → 57 - 1 = <strong>56</strong></div>
                        <div class="result">Answer: 56</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Works for:</strong> +19 = +20-1 | +29 = +30-1 | +99 = +100-1
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 90) + 10;
                const nines = [9, 19, 29, 39, 49];
                const b = nines[Math.floor(Math.random() * nines.length)];
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-doubles': {
            id: 'addition-doubles',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Doubles & Near-Doubles | Mental Math',
            ctrHeadline: 'Double It! The Near-Doubles Trick',
            description: 'Adding numbers that are close together? Double one and adjust!',
            difficulty: 'Beginner',
            formula: '45 + 46 = (45 × 2) + 1 = 91',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">When two numbers are close, <strong>double one and adjust</strong>.</p>
                    <div class="example-box">
                        <div class="problem">45 + 46 = ?</div>
                        <div class="step">Step 1: Notice 46 is just 45 + 1</div>
                        <div class="step">Step 2: Double the smaller → 45 × 2 = <strong>90</strong></div>
                        <div class="step">Step 3: Add the difference → 90 + 1 = <strong>91</strong></div>
                        <div class="result">Answer: 91</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Also works:</strong> 38 + 40 = 38×2 + 2 = 78
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 45) + 15;
                const diff = Math.floor(Math.random() * 3) + 1; // 1, 2, or 3
                const b = a + diff;
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-complement100': {
            id: 'addition-complement100',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Complements to 100 | Mental Math',
            ctrHeadline: 'What + What = 100? Find It Instantly!',
            description: 'Quickly find what number adds to 100. Essential for making change and quick calculations.',
            difficulty: 'Beginner',
            formula: '100 - 37 → (9-3)(10-7) → 63',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">To find what adds to 100, use the <strong>"9 and 10" rule</strong>.</p>
                    <div class="example-box">
                        <div class="problem">37 + ? = 100</div>
                        <div class="step">Step 1: Subtract tens digit from 9 → 9 - 3 = <strong>6</strong></div>
                        <div class="step">Step 2: Subtract ones digit from 10 → 10 - 7 = <strong>3</strong></div>
                        <div class="step">Step 3: Combine → <strong>63</strong></div>
                        <div class="result">Answer: 63 (check: 37 + 63 = 100)</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Exception:</strong> If ones digit is 0, use (10-tens) and 0. e.g., 40 → 60
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 89) + 11; // 11 to 99
                return {
                    text: `${a} + ? = 100`,
                    answer: 100 - a
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-near100': {
            id: 'addition-near100',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Add Numbers Near 100 | Mental Math',
            ctrHeadline: 'Adding 97 + 98? Use the Deficit Method!',
            description: 'Add numbers close to 100 by finding how far each is from 100.',
            difficulty: 'Intermediate',
            formula: '96 + 97 = 200 - 4 - 3 = 193',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For numbers near 100, find <strong>how much each is short of 100</strong>.</p>
                    <div class="example-box">
                        <div class="problem">96 + 97 = ?</div>
                        <div class="step">Step 1: Find deficits → 96 is <strong>4</strong> short, 97 is <strong>3</strong> short</div>
                        <div class="step">Step 2: Start with 200 (two hundreds)</div>
                        <div class="step">Step 3: Subtract both deficits → 200 - 4 - 3 = <strong>193</strong></div>
                        <div class="result">Answer: 193</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Formula:</strong> 200 - (100-a) - (100-b) = a + b
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 12) + 88; // 88 to 99
                const b = Math.floor(Math.random() * 12) + 88;
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-3digit': {
            id: 'addition-3digit',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Rapid 3-Digit Addition | Mental Math',
            ctrHeadline: 'Add Big Numbers Instantly (Left-to-Right)! 🚀',
            description: 'Master adding 3-digit numbers by breaking them down from hundreds to ones.',
            difficulty: 'Intermediate',
            formula: '425 + 132 → (400+100) + (20+30) + (5+2) → 557',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For big numbers, <strong>always go Left-to-Right</strong> (Hundreds, then Tens, then Ones).</p>
                    <div class="example-box">
                        <div class="problem">425 + 362 = ?</div>
                        <div class="step">Step 1: Add Hundreds → 400 + 300 = <strong>700</strong></div>
                        <div class="step">Step 2: Add Tens → 20 + 60 = <strong>80</strong> → Running Total: <strong>780</strong></div>
                        <div class="step">Step 3: Add Ones → 5 + 2 = <strong>7</strong></div>
                        <div class="step">Step 4: Combine → 780 + 7 = <strong>787</strong></div>
                        <div class="result">Answer: 787</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 800) + 100; // 100-899
                const b = Math.floor(Math.random() * 800) + 100;
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-round': {
            id: 'addition-round',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Rounding & Adjusting | Mental Math',
            ctrHeadline: 'Add Numbers Ending in 7, 8, 9 Fast!',
            description: 'Don\'t struggle with messy numbers. Round up to the nearest 10, then subtract the excess.',
            difficulty: 'Beginner',
            formula: 'N + 38 → N + 40 - 2',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">If a number ends in 7, 8, or 9, <strong>round UP</strong> and subtract later.</p>
                    <div class="example-box">
                        <div class="problem">145 + 38 = ?</div>
                        <div class="step">Step 1: Round 38 to <strong>40</strong> (added 2)</div>
                        <div class="step">Step 2: Add easy number → 145 + 40 = <strong>185</strong></div>
                        <div class="step">Step 3: Subtract the 2 you borrowed → 185 - 2 = <strong>183</strong></div>
                        <div class="result">Answer: 183</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 200) + 50;
                const base = Math.floor(Math.random() * 8) + 1; // 1-8 tens
                const suffix = Math.floor(Math.random() * 3) + 7; // 7,8,9
                const b = (base * 10) + suffix;
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-make10': {
            id: 'addition-make10',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Making 10s Strategy | Mental Math',
            ctrHeadline: 'Add Lists of Numbers Like a Pro!',
            description: 'Adding a list? Don\'t go in order. Spot pairs that equal 10 (7+3, 6+4).',
            difficulty: 'Beginner',
            formula: '7 + 5 + 3 → (7+3) + 5 → 10 + 5',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Look for <strong>Complements of 10</strong> before adding anything else.</p>

                    <!-- SVG Grouping Circles Visual -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <!-- Initial numbers as circles -->
                        <g class="make10-initial">
                            <circle cx="40" cy="40" r="22" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="40" y="46" text-anchor="middle" fill="white" font-weight="bold" font-size="16">8</text>

                            <circle cx="100" cy="40" r="22" fill="var(--warning, #f59e0b)" opacity="0.9"/>
                            <text x="100" y="46" text-anchor="middle" fill="white" font-weight="bold" font-size="16">5</text>

                            <circle cx="160" cy="40" r="22" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="160" y="46" text-anchor="middle" fill="white" font-weight="bold" font-size="16">2</text>

                            <circle cx="220" cy="40" r="22" fill="var(--warning, #f59e0b)" opacity="0.9"/>
                            <text x="220" y="46" text-anchor="middle" fill="white" font-weight="bold" font-size="16">5</text>

                            <circle cx="280" cy="40" r="22" fill="var(--text-muted, #888)" opacity="0.9"/>
                            <text x="280" y="46" text-anchor="middle" fill="white" font-weight="bold" font-size="16">4</text>
                        </g>

                        <!-- Grouping brackets (hidden initially) -->
                        <g class="make10-group1" opacity="0">
                            <path d="M 15 70 Q 15 85 40 85 L 160 85 Q 185 85 185 70" fill="none" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                            <text x="100" y="105" text-anchor="middle" fill="var(--accent-primary, #6366f1)" font-weight="bold" font-size="14">= 10</text>
                        </g>

                        <g class="make10-group2" opacity="0">
                            <path d="M 75 70 Q 75 95 100 95 L 220 95 Q 245 95 245 70" fill="none" stroke="var(--warning, #f59e0b)" stroke-width="2" transform="translate(60, 0)"/>
                            <text x="220" y="115" text-anchor="middle" fill="var(--warning, #f59e0b)" font-weight="bold" font-size="14">= 10</text>
                        </g>

                        <!-- Result equation -->
                        <g class="make10-result" opacity="0">
                            <text x="320" y="46" text-anchor="middle" fill="var(--success, #22c55e)" font-weight="bold" font-size="14">+4</text>
                            <text x="320" y="80" text-anchor="middle" fill="var(--success, #22c55e)" font-weight="bold" font-size="16">=24</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">8 + 5 + 2 + 5 + 4 = ?</div>
                        <div class="step">Step 1: Spot pairs that make 10 → <strong>8+2</strong> and <strong>5+5</strong></div>
                        <div class="step">Step 2: Group 8 and 2 → <strong>10</strong></div>
                        <div class="step">Step 3: Group 5 and 5 → <strong>10</strong></div>
                        <div class="step">Step 4: Add leftovers → 10 + 10 + 4 = <strong>24</strong></div>
                        <div class="result">Answer: 24</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Pairs to memorize:</strong> 1+9, 2+8, 3+7, 4+6, 5+5
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const pairs = [
                    [1, 9], [2, 8], [3, 7], [4, 6], [5, 5]
                ];
                const p1 = pairs[Math.floor(Math.random() * pairs.length)];
                const p2 = pairs[Math.floor(Math.random() * pairs.length)];
                const leftover = Math.floor(Math.random() * 9) + 1;

                const nums = [...p1, ...p2, leftover];
                for (let i = nums.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [nums[i], nums[j]] = [nums[j], nums[i]];
                }

                return {
                    text: `${nums.join(' + ')} = ?`,
                    answer: nums.reduce((a, b) => a + b, 0)
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-sum-sequence': {
            id: 'addition-sum-sequence',
            category: 'Speed Math',
            tags: ['addition', 'sequence'],
            title: 'Sum of 1 to N (Gauss Trick) | Mental Math',
            ctrHeadline: 'Add 1 to 100 in Seconds! 🤯',
            description: 'The famous trick young Gauss used. Multiply the last number by the next, then divide by 2.',
            difficulty: 'Advanced',
            formula: 'Sum = n × (n + 1) / 2',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Young Gauss discovered: pair up numbers from opposite ends - they all equal the same!</p>

                    <!-- SVG Gauss Pairing Diagram -->
                    <svg viewBox="0 0 380 140" style="width: 100%; max-width: 420px; display: block; margin: 16px auto;">
                        <!-- Top row: 1, 2, 3, 4, 5 -->
                        <g font-size="16" font-weight="bold" text-anchor="middle">
                            <circle cx="40" cy="30" r="20" fill="var(--accent-primary, #6366f1)"/>
                            <text x="40" y="36" fill="white">1</text>

                            <circle cx="100" cy="30" r="20" fill="var(--accent-primary, #6366f1)"/>
                            <text x="100" y="36" fill="white">2</text>

                            <circle cx="160" cy="30" r="20" fill="var(--accent-primary, #6366f1)"/>
                            <text x="160" y="36" fill="white">3</text>

                            <circle cx="220" cy="30" r="20" fill="var(--accent-primary, #6366f1)"/>
                            <text x="220" y="36" fill="white">4</text>

                            <circle cx="280" cy="30" r="20" fill="var(--accent-primary, #6366f1)"/>
                            <text x="280" y="36" fill="white">5</text>
                        </g>

                        <!-- Bottom row: 10, 9, 8, 7, 6 -->
                        <g font-size="16" font-weight="bold" text-anchor="middle">
                            <circle cx="40" cy="100" r="20" fill="var(--warning, #f59e0b)"/>
                            <text x="40" y="106" fill="white">10</text>

                            <circle cx="100" cy="100" r="20" fill="var(--warning, #f59e0b)"/>
                            <text x="100" y="106" fill="white">9</text>

                            <circle cx="160" cy="100" r="20" fill="var(--warning, #f59e0b)"/>
                            <text x="160" y="106" fill="white">8</text>

                            <circle cx="220" cy="100" r="20" fill="var(--warning, #f59e0b)"/>
                            <text x="220" y="106" fill="white">7</text>

                            <circle cx="280" cy="100" r="20" fill="var(--warning, #f59e0b)"/>
                            <text x="280" y="106" fill="white">6</text>
                        </g>

                        <!-- Connecting lines showing pairs -->
                        <g stroke="var(--text-muted, #888)" stroke-width="2" stroke-dasharray="4" class="gauss-lines" opacity="0.3">
                            <line x1="40" y1="50" x2="40" y2="80"/>
                            <line x1="100" y1="50" x2="100" y2="80"/>
                            <line x1="160" y1="50" x2="160" y2="80"/>
                            <line x1="220" y1="50" x2="220" y2="80"/>
                            <line x1="280" y1="50" x2="280" y2="80"/>
                        </g>

                        <!-- Sum labels -->
                        <g font-size="12" fill="var(--success, #22c55e)" font-weight="bold" text-anchor="middle" class="gauss-sums" opacity="0">
                            <text x="40" y="70">=11</text>
                            <text x="100" y="70">=11</text>
                            <text x="160" y="70">=11</text>
                            <text x="220" y="70">=11</text>
                            <text x="280" y="70">=11</text>
                        </g>

                        <!-- Result -->
                        <g class="gauss-result" opacity="0">
                            <text x="340" y="50" font-size="13" fill="var(--text-secondary, #666)" text-anchor="middle">5 pairs</text>
                            <text x="340" y="70" font-size="13" fill="var(--text-secondary, #666)" text-anchor="middle">× 11</text>
                            <line x1="320" y1="78" x2="360" y2="78" stroke="var(--text-secondary, #666)" stroke-width="1"/>
                            <text x="340" y="95" font-size="18" fill="var(--success, #22c55e)" font-weight="bold" text-anchor="middle">55</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Sum of 1 to 10 = ?</div>
                        <div class="step">Step 1: Pair numbers from ends: (1+10), (2+9), (3+8), (4+7), (5+6)</div>
                        <div class="step">Step 2: Each pair sums to <strong>11</strong></div>
                        <div class="step">Step 3: Count pairs → 10 ÷ 2 = <strong>5 pairs</strong></div>
                        <div class="step">Step 4: Multiply → 5 × 11 = <strong>55</strong></div>
                        <div class="result">Answer: 55</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Formula:</strong> n × (n + 1) ÷ 2 &nbsp;|&nbsp; <strong>1 to 100?</strong> 100 × 101 ÷ 2 = 5050
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 20) + 10; // 10 to 29
                return {
                    text: `Sum of 1 to ${n} = ?`,
                    answer: (n * (n + 1)) / 2
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-compensation': {
            id: 'addition-compensation',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Compensation Method | Mental Math',
            ctrHeadline: 'Round BOTH Numbers for Easy Math!',
            description: 'Round both numbers to friendly values, add them, then adjust for the difference.',
            difficulty: 'Intermediate',
            formula: '48 + 37 → 50 + 40 - 2 - 3 = 85',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Round BOTH numbers to the nearest 10, then <strong>subtract what you added</strong>.</p>
                    <div class="example-box">
                        <div class="problem">48 + 37 = ?</div>
                        <div class="step">Step 1: Round 48 up to <strong>50</strong> (added 2)</div>
                        <div class="step">Step 2: Round 37 up to <strong>40</strong> (added 3)</div>
                        <div class="step">Step 3: Add friendly numbers → 50 + 40 = <strong>90</strong></div>
                        <div class="step">Step 4: Subtract what you added → 90 - 2 - 3 = <strong>85</strong></div>
                        <div class="result">Answer: 85</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const endings = [1, 2, 3, 4, 6, 7, 8, 9];
                const a = (Math.floor(Math.random() * 8) + 2) * 10 + endings[Math.floor(Math.random() * endings.length)];
                const b = (Math.floor(Math.random() * 8) + 2) * 10 + endings[Math.floor(Math.random() * endings.length)];
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-carrying': {
            id: 'addition-carrying',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Mental Carrying | Advanced Addition',
            ctrHeadline: 'Handle Carries Like a Pro!',
            description: 'When digit sums exceed 9, adjust on the fly. The key skill for complex mental math.',
            difficulty: 'Intermediate',
            formula: '78 + 56 → 70+50=120, 8+6=14, 120+14=134',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">When ones add to 10+, <strong>add the extra 10 to your running total</strong>.</p>
                    <div class="example-box">
                        <div class="problem">78 + 56 = ?</div>
                        <div class="step">Step 1: Add tens → 70 + 50 = <strong>120</strong> (running total)</div>
                        <div class="step">Step 2: Add ones → 8 + 6 = <strong>14</strong></div>
                        <div class="step">Step 3: 14 is 10 + 4, so add 10 to total → 120 + 10 = <strong>130</strong></div>
                        <div class="step">Step 4: Add remaining 4 → 130 + 4 = <strong>134</strong></div>
                        <div class="result">Answer: 134</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Quick way:</strong> 78 + 56 → 78 + 50 = 128, then + 6 = 134
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const onesA = Math.floor(Math.random() * 4) + 6; // 6-9
                const onesB = Math.floor(Math.random() * 4) + 6; // 6-9
                const tensA = Math.floor(Math.random() * 7) + 2; // 2-8
                const tensB = Math.floor(Math.random() * 7) + 2;
                const a = tensA * 10 + onesA;
                const b = tensB * 10 + onesB;
                return {
                    text: `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-verify9': {
            id: 'addition-verify9',
            category: 'Speed Math',
            tags: ['addition', 'verification'],
            title: 'Casting Out 9s | Verify Your Answer',
            ctrHeadline: 'Check Your Math in 3 Seconds!',
            description: 'A quick way to verify if your addition is correct by using digit sums.',
            difficulty: 'Intermediate',
            formula: 'If digit sums match, answer is likely correct',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Add digit sums of both numbers. If it matches the digit sum of your answer, you're <strong>probably right</strong>!</p>
                    <div class="example-box">
                        <div class="problem">Verify: 47 + 38 = 85</div>
                        <div class="step">Step 1: Digit sum of 47 → 4 + 7 = <strong>11</strong> → 1 + 1 = <strong>2</strong></div>
                        <div class="step">Step 2: Digit sum of 38 → 3 + 8 = <strong>11</strong> → 1 + 1 = <strong>2</strong></div>
                        <div class="step">Step 3: Sum of digit sums → 2 + 2 = <strong>4</strong></div>
                        <div class="step">Step 4: Digit sum of answer 85 → 8 + 5 = <strong>13</strong> → 1 + 3 = <strong>4</strong></div>
                        <div class="result">4 = 4 ✓ Answer is correct!</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 80) + 20;
                const b = Math.floor(Math.random() * 80) + 20;
                const correctSum = a + b;
                const isCorrect = Math.random() > 0.3;
                const shownAnswer = isCorrect ? correctSum : correctSum + (Math.random() > 0.5 ? 10 : -10);
                return {
                    text: `Is ${a} + ${b} = ${shownAnswer} correct? (yes/no)`,
                    answer: isCorrect ? 'yes' : 'no'
                };
            },
            checkAnswer: (userAns, correctAns) => userAns.toLowerCase().trim() === correctAns
        },
        'addition-bridge10': {
            id: 'addition-bridge10',
            category: 'Speed Math',
            tags: ['addition'],
            title: 'Bridge Through 10 | Foundation Trick',
            ctrHeadline: 'The Secret Behind Fast Addition!',
            description: 'Split one number to make 10 first, then add the rest. The foundation of all mental math.',
            difficulty: 'Beginner',
            formula: '8 + 5 → 8 + 2 + 3 → 10 + 3 = 13',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">First make <strong>10</strong>, then add what's left. This is how experts add!</p>

                    <!-- SVG Number Line Visual -->
                    <svg viewBox="0 0 340 100" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <!-- Number line -->
                        <line x1="20" y1="60" x2="320" y2="60" stroke="var(--text-muted, #888)" stroke-width="2"/>

                        <!-- Tick marks and numbers -->
                        <g font-size="14" text-anchor="middle" fill="var(--text-primary, #333)">
                            <line x1="50" y1="55" x2="50" y2="65" stroke="var(--text-muted, #888)" stroke-width="2"/>
                            <text x="50" y="80">8</text>

                            <line x1="140" y1="55" x2="140" y2="65" stroke="var(--accent-primary, #6366f1)" stroke-width="3"/>
                            <text x="140" y="80" fill="var(--accent-primary, #6366f1)" font-weight="bold">10</text>

                            <line x1="275" y1="55" x2="275" y2="65" stroke="var(--success, #22c55e)" stroke-width="3"/>
                            <text x="275" y="80" fill="var(--success, #22c55e)" font-weight="bold">13</text>
                        </g>

                        <!-- Arc 1: 8 to 10 (+2) -->
                        <path d="M 50 55 Q 95 20 140 55" fill="none" stroke="var(--accent-primary, #6366f1)" stroke-width="3" stroke-dasharray="200" stroke-dashoffset="200" class="viz-arc1"/>
                        <text x="95" y="25" text-anchor="middle" font-size="13" fill="var(--accent-primary, #6366f1)" font-weight="bold" class="viz-label1" opacity="0">+2</text>

                        <!-- Arc 2: 10 to 13 (+3) -->
                        <path d="M 140 55 Q 207 15 275 55" fill="none" stroke="var(--success, #22c55e)" stroke-width="3" stroke-dasharray="200" stroke-dashoffset="200" class="viz-arc2"/>
                        <text x="207" y="20" text-anchor="middle" font-size="13" fill="var(--success, #22c55e)" font-weight="bold" class="viz-label2" opacity="0">+3</text>

                        <!-- Dots -->
                        <circle cx="50" cy="60" r="6" fill="var(--text-primary, #333)"/>
                        <circle cx="140" cy="60" r="6" fill="var(--accent-primary, #6366f1)" class="viz-dot10" opacity="0.3"/>
                        <circle cx="275" cy="60" r="6" fill="var(--success, #22c55e)" class="viz-dot13" opacity="0.3"/>
                    </svg>

                    <div class="example-box">
                        <div class="problem">8 + 5 = ?</div>
                        <div class="step" data-viz="arc1">Step 1: How much does 8 need to make 10? → <strong>2</strong></div>
                        <div class="step">Step 2: Break 5 into 2 and 3 → 5 = <strong>2 + 3</strong></div>
                        <div class="step" data-viz="dot10">Step 3: Add 2 to 8 → 8 + 2 = <strong>10</strong> (the bridge!)</div>
                        <div class="step" data-viz="arc2">Step 4: Add the remaining 3 → 10 + 3 = <strong>13</strong></div>
                        <div class="result" data-viz="dot13">Answer: 13</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Works great for:</strong> 7+6, 9+4, 8+7, 6+5...
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const pairs = [
                    [8, 5], [8, 6], [8, 7], [8, 9],
                    [7, 5], [7, 6], [7, 8], [7, 9],
                    [6, 5], [6, 7], [6, 8], [6, 9],
                    [9, 4], [9, 5], [9, 6], [9, 7], [9, 8]
                ];
                const [a, b] = pairs[Math.floor(Math.random() * pairs.length)];
                const swap = Math.random() > 0.5;
                return {
                    text: swap ? `${b} + ${a} = ?` : `${a} + ${b} = ?`,
                    answer: a + b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'addition-money': {
            id: 'addition-money',
            category: 'Commercial Math',
            tags: ['addition', 'money'],
            title: 'Adding Money | Practical Math',
            ctrHeadline: 'Add Prices & Make Change Fast!',
            description: 'Add dollars and cents separately. Essential for shopping, tips, and budgeting.',
            difficulty: 'Beginner',
            formula: '$4.75 + $2.50 → $6 + $1.25 = $7.25',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Add <strong>dollars first</strong>, then <strong>cents</strong>. If cents exceed 100, carry $1.</p>
                    <div class="example-box">
                        <div class="problem">$4.75 + $2.50 = ?</div>
                        <div class="step">Step 1: Add dollars → $4 + $2 = <strong>$6</strong></div>
                        <div class="step">Step 2: Add cents → 75¢ + 50¢ = <strong>125¢</strong></div>
                        <div class="step">Step 3: 125¢ = $1.25, carry the dollar → $6 + $1 = <strong>$7</strong></div>
                        <div class="step">Step 4: Add remaining cents → $7 + 25¢ = <strong>$7.25</strong></div>
                        <div class="result">Answer: $7.25</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const dollars1 = Math.floor(Math.random() * 9) + 1;
                const cents1 = [25, 50, 75, 99, 49, 95, 29, 79][Math.floor(Math.random() * 8)];
                const dollars2 = Math.floor(Math.random() * 9) + 1;
                const cents2 = [25, 50, 75, 99, 49, 95, 29, 79][Math.floor(Math.random() * 8)];

                const total = (dollars1 * 100 + cents1 + dollars2 * 100 + cents2) / 100;

                return {
                    text: `$${dollars1}.${cents1.toString().padStart(2, '0')} + $${dollars2}.${cents2.toString().padStart(2, '0')} = ?`,
                    answer: total
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const cleaned = userAns.replace(/[$,]/g, '').trim();
                return parseFloat(cleaned) === correctAns;
            }
        },
        'subtraction-by-addition': {
            id: 'subtraction-by-addition',
            category: 'Speed Math',
            tags: ['subtraction', 'addition'],
            title: 'Subtraction by Addition | Mental Math',
            ctrHeadline: 'Don\'t Subtract... Add Up!',
            description: 'Subtraction is hard. Counting up is easy. Solves 73 - 48 by going 48 → 50 → 70 → 73.',
            difficulty: 'Beginner',
            formula: '73 - 48 → 48 (+2) 50 (+20) 70 (+3) 73 → Sum = 25',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Instead of taking away, start at the small number and <strong>add up</strong> to the big one.</p>
                    <div class="example-box">
                        <div class="problem">73 - 48 = ?</div>
                        <div class="step">Step 1: Start at <strong>48</strong>. Add to get to nearest 10 → 48 + <strong>2</strong> = 50</div>
                        <div class="step">Step 2: Add to get close to 73 → 50 + <strong>20</strong> = 70</div>
                        <div class="step">Step 3: Add to hit the target → 70 + <strong>3</strong> = 73</div>
                        <div class="step">Step 4: Sum your jumps → 2 + 20 + 3 = <strong>25</strong></div>
                        <div class="result">Answer: 25</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const b = Math.floor(Math.random() * 50) + 10;
                const diff = Math.floor(Math.random() * 40) + 10;
                const a = b + diff;
                return {
                    text: `${a} - ${b} = ?`,
                    answer: a - b
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        }
    });
})();


