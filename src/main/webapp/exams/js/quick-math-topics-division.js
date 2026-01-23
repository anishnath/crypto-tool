/**
 * Quick Math Topics - Division / Divisibility
 */

(function registerDivisionTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'divisibility-master': {
            id: 'divisibility-master',
            category: 'Speed Math',
            tags: ['division'],
            title: 'Master Divisibility Rules (2-11)',
            ctrHeadline: 'Is it Divisible? Know in 0.5 Seconds!',
            description: 'Learn the secret rules to check divisibility for 2, 3, 4, 5, 9, and 10 instantly.',
            difficulty: 'Beginner',
            formula: 'Div by 3? Sum of digits. Div by 4? Last 2 digits. Div by 5? Last digit 0 or 5.',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Memorize a few <strong>digit-check rules</strong> and most divisibility questions become instant.</p>
                    
                    <div class="example-box">
                        <div class="problem">Is 246 divisible by 3?</div>
                        <div class="step"><strong>Rule for 3:</strong> Sum of all digits must be divisible by 3</div>
                        <div class="step">Calculate: 2 + 4 + 6 = <strong>12</strong></div>
                        <div class="step">Is 12 divisible by 3? → 12 ÷ 3 = 4 → <strong>Yes!</strong></div>
                        <div class="result">246 IS divisible by 3</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Quick rules to remember</div>
                        <div class="step"><strong>Divisible by 2:</strong> last digit is even (0,2,4,6,8)</div>
                        <div class="step"><strong>Divisible by 3:</strong> sum of digits divisible by 3</div>
                        <div class="step"><strong>Divisible by 4:</strong> last two digits form a number divisible by 4 (e.g. 16, 24, 32)</div>
                        <div class="step"><strong>Divisible by 5:</strong> last digit is 0 or 5</div>
                        <div class="step"><strong>Divisible by 9:</strong> sum of digits divisible by 9</div>
                        <div class="step"><strong>Divisible by 10:</strong> last digit is 0</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const divisors = [3, 4, 5, 9];
                const d = divisors[Math.floor(Math.random() * divisors.length)];
                const isDivisible = Math.random() > 0.5;
                let n = Math.floor(Math.random() * 500) + 100;

                if (isDivisible) {
                    n = n - (n % d);
                } else if (n % d === 0) {
                    n += 1;
                }

                return {
                    text: `Is ${n} divisible by ${d}? (yes/no)`,
                    answer: isDivisible ? 'yes' : 'no'
                };
            },
            checkAnswer: (userAns, correctAns) => userAns.toLowerCase().trim() === correctAns
        },
        'division-by-5': {
            id: 'division-by-5',
            category: 'Speed Math',
            tags: ['division'],
            title: 'Divide by 5 | Double & Point',
            ctrHeadline: 'Divide by 5 instantly: Double it and shift!',
            description: 'Dividing by 5 is hard. Multiplying by 2 is easy. Double the number and move the decimal point.',
            difficulty: 'Beginner',
            formula: '23 ÷ 5 → 23 × 2 = 46 → 4.6',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Instead of dividing by 5, <strong>multiply by 2</strong> and move the decimal.</p>
                    
                    <!-- SVG Visual for Divide by 5 -->
                    <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Original Number -->
                            <rect x="30" y="40" width="80" height="40" rx="6" ry="6" fill="var(--accent-primary, #6366f1)" opacity="0.1"/>
                            <text x="70" y="66" font-size="20" fill="var(--text-primary, #ddd)">124</text>
                            <text x="70" y="30" font-size="14" fill="var(--text-secondary, #888)">Start</text>
                        </g>

                        <!-- Arrow x2 -->
                        <g>
                            <line x1="120" y1="60" x2="160" y2="60" stroke="var(--success, #22c55e)" stroke-width="2" marker-end="url(#arrowhead-div5)"/>
                            <text x="140" y="50" text-anchor="middle" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">×2</text>
                        </g>

                        <defs>
                            <marker id="arrowhead-div5" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--success, #22c55e)"/>
                            </marker>
                        </defs>

                        <!-- Doubled Number -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <rect x="170" y="40" width="80" height="40" rx="6" ry="6" fill="var(--success, #22c55e)" opacity="0.1"/>
                            <text x="210" y="66" font-size="20" fill="var(--success, #22c55e)">248</text>
                            <text x="210" y="30" font-size="14" fill="var(--text-secondary, #888)">Double</text>
                        </g>

                         <!-- Arrow Move Decimal -->
                        <g>
                            <line x1="260" y1="60" x2="300" y2="60" stroke="var(--warning, #f59e0b)" stroke-width="2" marker-end="url(#arrowhead-div5-dec)"/>
                            <text x="280" y="50" text-anchor="middle" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">÷10</text>
                        </g>

                        <defs>
                            <marker id="arrowhead-div5-dec" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                            </marker>
                        </defs>

                        <!-- Final Result -->
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <rect x="310" y="40" width="80" height="40" rx="6" ry="6" fill="var(--warning, #f59e0b)" opacity="0.15"/>
                            <text x="350" y="66" font-size="20" fill="var(--warning, #f59e0b)">24.8</text>
                             <text x="350" y="30" font-size="14" fill="var(--text-secondary, #888)">Result</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">124 ÷ 5 = ?</div>
                        <div class="step">Step 1: Double the number → 124 × 2 = <strong>248</strong></div>
                        <div class="step">Step 2: Move decimal 1 place left → <strong>24.8</strong></div>
                        <div class="result">Answer: 24.8</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 200) + 12; // 12-211
                return {
                    text: `${a} ÷ 5 = ?`,
                    answer: a / 5
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'division-by-25': {
            id: 'division-by-25',
            category: 'Speed Math',
            tags: ['division'],
            title: 'Divide by 25 | Times 4',
            ctrHeadline: 'Divide by 25? Multiply by 4!',
            description: '25 is 100/4. So to divide by 25, just multiply by 4 and divide by 100.',
            difficulty: 'Intermediate',
            formula: '6 ÷ 25 → 6 × 4 = 24 → 0.24',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Don't divide. <strong>Multiply by 4</strong> and move the decimal 2 spots.</p>
                    <div class="example-box">
                        <div class="problem">320 ÷ 25 = ?</div>
                        <div class="step">Step 1: Multiply by 4 → 320 × 4 = 1280</div>
                        <div class="step">Step 2: Move decimal 2 places left → 12.80</div>
                        <div class="result">Answer: 12.8</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = (Math.floor(Math.random() * 40) + 1) * 10; // 10-400
                return {
                    text: `${a} ÷ 25 = ?`,
                    answer: a / 25
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'division-split': {
            id: 'division-split',
            category: 'Speed Math',
            tags: ['division', 'intermediate'],
            title: 'Divide Large Numbers FAST! | Split Method',
            ctrHeadline: 'Divide 639÷3 in Your Head Using This Trick! 🧠',
            description: 'Master the decomposition method to divide large numbers mentally for competitive exams. Break numbers into easy chunks - essential for SSC, Banking, Railway math.',
            difficulty: 'Intermediate',
            formula: '639 ÷ 3 → 600÷3 + 30÷3 + 9÷3',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Break the big number into <strong>easy chunks</strong> that are multiples of the divisor.</p>
                    
                     <!-- SVG Visual for Split Method using 639 / 3 -->
                    <svg viewBox="0 0 380 160" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Top Nuimber -->
                            <text x="190" y="30" font-size="24" fill="var(--text-primary, #fff)">639</text>
                            
                            <!-- Split Arrows -->
                            <line x1="180" y1="40" x2="100" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2" />
                            <line x1="190" y1="40" x2="190" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2" />
                            <line x1="200" y1="40" x2="280" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2" />
                            
                            <!-- Chunks -->
                            <circle cx="100" cy="90" r="25" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="100" y="96" font-size="18" fill="var(--accent-primary, #6366f1)">600</text>
                            
                            <circle cx="190" cy="90" r="25" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="190" y="96" font-size="18" fill="var(--accent-primary, #6366f1)">30</text>
                            
                            <circle cx="280" cy="90" r="25" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="280" y="96" font-size="18" fill="var(--accent-primary, #6366f1)">9</text>
                            
                            <!-- Divisor Label -->
                             <text x="190" y="125" font-size="14" fill="var(--text-secondary, #888)">Divide each by 3</text>
                             
                             <!-- Results -->
                             <text x="100" y="150" font-size="20" fill="var(--success, #22c55e)">200</text>
                             <text x="190" y="150" font-size="20" fill="var(--success, #22c55e)">10</text>
                             <text x="280" y="150" font-size="20" fill="var(--success, #22c55e)">3</text>
                             
                             <!-- Plus Signs -->
                             <text x="145" y="150" font-size="20" fill="var(--text-secondary, #666)">+</text>
                             <text x="235" y="150" font-size="20" fill="var(--text-secondary, #666)">+</text>
                             
                             <!-- Final Equals -->
                             <text x="340" y="150" font-size="24" fill="var(--success, #22c55e)">= 213</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">639 ÷ 3 = ?</div>
                        <div class="step">Step 1: Split 639 into 600 + 30 + 9</div>
                        <div class="step">Step 2: Divide each: 200 + 10 + 3</div>
                        <div class="step">Step 3: Add them up → <strong>213</strong></div>
                        <div class="result">Answer: 213</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 300) + 100;
                // Make sure it's divisible by 3 for easy start
                const dividend = a * 3;
                return {
                    text: `${dividend} ÷ 3 = ?`,
                    answer: dividend / 3
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'division-factors': {
            id: 'division-factors',
            category: 'Speed Math',
            tags: ['division', 'intermediate'],
            title: 'Division Using Factors | Quick Cancellation',
            ctrHeadline: 'Divide by 12 or 15 INSTANTLY! Break It Down! 💡',
            description: 'Learn to divide by breaking divisors into smaller factors for competitive exams. Simplify tough divisions - crucial shortcut for SSC, Banking, Railway quantitative aptitude.',
            difficulty: 'Intermediate',
            formula: '144 ÷ 12 → (144 ÷ 2) ÷ 6 → 72 ÷ 6 = 12',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">If dividing by a big number is hard, <strong>break the divisor</strong> into smaller factors.</p>
                    <div class="example-box">
                        <div class="problem">216 ÷ 12 = ?</div>
                        <div class="step">Step 1: 12 is 2 × 6</div>
                        <div class="step">Step 2: Divide by 2 first → 216 / 2 = 108</div>
                        <div class="step">Step 3: Now divide by 6 → 108 / 6 = <strong>18</strong></div>
                        <div class="result">Answer: 18</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const answer = Math.floor(Math.random() * 20) + 10;
                const divisor = [12, 14, 15, 16, 18, 24][Math.floor(Math.random() * 6)];
                const dividend = answer * divisor;
                return {
                    text: `${dividend} ÷ ${divisor} = ?`,
                    answer: answer
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'division-halving': {
            id: 'division-halving',
            category: 'Speed Math',
            tags: ['division'],
            title: 'Divide by 2, 4, 8 Using Halving | Mental Math',
            ctrHeadline: 'Divide by Powers of 2 WITHOUT Long Division! ⚡',
            description: 'Master repeated halving to divide by 2, 4, 8 instantly for competitive exams. No long division needed - essential speed technique for SSC, Banking, Railway.',
            difficulty: 'Beginner',
            formula: '96 ÷ 4 → 96 ÷ 2 = 48 → 48 ÷ 2 = 24',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Every time you <strong>halve</strong> a number, you divide it by 2. Do it twice for ÷4, three times for ÷8.</p>

                    <!-- SVG: Halving chain visual for 72 ÷ 8 -->
                    <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle" font-size="16">
                            <circle cx="40" cy="60" r="18" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="40" y="64" fill="#fff">72</text>

                            <circle cx="140" cy="60" r="18" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="140" y="64" fill="#fff">36</text>

                            <circle cx="240" cy="60" r="18" fill="var(--accent-primary, #6366f1)" opacity="0.9"/>
                            <text x="240" y="64" fill="#fff">18</text>

                            <circle cx="340" cy="60" r="18" fill="var(--success, #22c55e)" opacity="0.95"/>
                            <text x="340" y="64" fill="#fff">9</text>
                        </g>

       	             <!-- Arrows with ÷2 labels -->
                        <g stroke="var(--text-muted, #888)" stroke-width="2" fill="none" marker-end="url(#arrowhead-halving)">
                            <defs>
                                <marker id="arrowhead-halving" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--text-muted, #888)"/>
                                </marker>
                            </defs>
                            <line x1="58" y1="60" x2="122" y2="60"/>
                            <line x1="158" y1="60" x2="222" y2="60"/>
                            <line x1="258" y1="60" x2="322" y2="60"/>

                            <text x="90" y="45" font-size="13" fill="var(--text-secondary, #666)">÷2</text>
                            <text x="200" y="45" font-size="13" fill="var(--text-secondary, #666)">÷2</text>
                            <text x="300" y="45" font-size="13" fill="var(--text-secondary, #666)">÷2</text>
                        </g>

                        <text x="190" y="100" text-anchor="middle" font-size="14" fill="var(--text-secondary, #666)" font-weight="bold">
                            72 ÷ 8 = 72 ÷ 2 ÷ 2 ÷ 2 = 9
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">96 ÷ 4 = ?</div>
                        <div class="step">Step 1: Halve 96 → 96 ÷ 2 = <strong>48</strong></div>
                        <div class="step">Step 2: Halve again (that&apos;s ÷4) → 48 ÷ 2 = <strong>24</strong></div>
                        <div class="result">Answer: 24</div>
                    </div>
                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">72 ÷ 8 = ?</div>
                        <div class="step">Step 1: Halve 72 → <strong>36</strong> (÷2)</div>
                        <div class="step">Step 2: Halve 36 → <strong>18</strong> (÷4)</div>
                        <div class="step">Step 3: Halve 18 → <strong>9</strong> (÷8)</div>
                        <div class="result">Answer: 9</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const divisors = [2, 4, 8];
                const d = divisors[Math.floor(Math.random() * divisors.length)];
                // ensure dividend is divisible by d
                let n = Math.floor(Math.random() * 200) + 20; // 20–219
                n = n - (n % d);
                if (n === 0) n = d * 2;
                return {
                    text: `${n} ÷ ${d} = ?`,
                    answer: n / d
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'division-fractions': {
            id: 'division-fractions',
            category: 'Speed Math',
            tags: ['division', 'fractions'],
            title: 'Divide Fractions Using Flip Method | Quick Shortcut',
            ctrHeadline: 'This Division Trick Makes Hard Problems EASY! 💪',
            description: 'Master the fraction conversion technique to simplify complex divisions for competitive exams. Essential method for SSC, Banking, Railway quantitative aptitude.',
            difficulty: 'Intermediate',
            formula: '(A/B) ÷ (C/D) → (A/B) × (D/C)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">To divide by a fraction, multiply by its <strong>reciprocal</strong> (flip it).</p>

                    <!-- SVG Visual for Keep Change Flip -->
                    <svg viewBox="0 0 400 140" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle" font-size="20">
                            <!-- Fraction 1: 2/3 -->
                            <text x="50" y="55" fill="var(--text-primary, #ddd)">2</text>
                            <line x1="35" y1="65" x2="65" y2="65" stroke="var(--text-primary, #ddd)" stroke-width="2"/>
                            <text x="50" y="90" fill="var(--text-primary, #ddd)">3</text>

                            <!-- Sign: Divide -->
                            <text x="100" y="80" font-size="28" fill="var(--warning, #f59e0b)">÷</text>

                            <!-- Fraction 2: 4/5 -->
                            <g transform="translate(150, 0)">
                                <text x="25" y="55" fill="var(--text-primary, #ddd)">4</text>
                                <line x1="10" y1="65" x2="40" y2="65" stroke="var(--text-primary, #ddd)" stroke-width="2"/>
                                <text x="25" y="90" fill="var(--text-primary, #ddd)">5</text>
                            </g>

                            <!-- Arrow -->
                            <line x1="210" y1="70" x2="250" y2="70" stroke="var(--text-secondary, #666)" stroke-width="2" marker-end="url(#arrowhead-flip)"/>

                            <defs>
                                <marker id="arrowhead-flip" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--text-secondary, #666)"/>
                                </marker>
                            </defs>

                            <!-- Result: 2/3 * 5/4 -->
                             <g transform="translate(260, 0)">
                                <!-- 2/3 Keep -->
                                <text x="25" y="55" fill="var(--success, #22c55e)">2</text>
                                <line x1="10" y1="65" x2="40" y2="65" stroke="var(--success, #22c55e)" stroke-width="2"/>
                                <text x="25" y="90" fill="var(--success, #22c55e)">3</text>

                                <!-- Sign: Multiply -->
                                <text x="65" y="80" font-size="28" fill="var(--success, #22c55e)">×</text>

                                <!-- 5/4 Flip -->
                                <text x="105" y="55" fill="var(--accent-primary, #6366f1)">5</text>
                                <line x1="90" y1="65" x2="120" y2="65" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                                <text x="105" y="90" fill="var(--accent-primary, #6366f1)">4</text>
                            </g>
                        </g>

                        <text x="200" y="125" text-anchor="middle" font-size="16" fill="var(--text-secondary, #aaa)">
                            Keep <tspan fill="var(--success, #22c55e)">Change</tspan> <tspan fill="var(--accent-primary, #6366f1)">Flip</tspan>
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">2/3 ÷ 4/5 = ?</div>
                        <div class="step">Step 1: <strong>Keep</strong> 2/3</div>
                        <div class="step">Step 2: <strong>Change</strong> ÷ to ×</div>
                        <div class="step">Step 3: <strong>Flip</strong> 4/5 to 5/4</div>
                        <div class="step">Step 4: Multiply → (2×5)/(3×4) = 10/12</div>
                        <div class="result">Answer: 10/12 (or 5/6)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const n1 = Math.floor(Math.random() * 5) + 1;
                const d1 = Math.floor(Math.random() * 5) + 2;
                const n2 = Math.floor(Math.random() * 5) + 1;
                const d2 = Math.floor(Math.random() * 5) + 2;

                const ansNum = n1 * d2;
                const ansDen = d1 * n2;

                return {
                    text: `${n1}/${d1} ÷ ${n2}/${d2} = ?`,
                    answer: `${ansNum}/${ansDen}`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                if (!userAns.includes('/')) return false;
                let [uN, uD] = userAns.split('/').map(n => parseInt(n.trim()));
                let [cN, cD] = correctAns.split('/').map(n => parseInt(n.trim()));
                if (isNaN(uN) || isNaN(uD)) return false;
                return (uN * cD) === (uD * cN); // Cross multiply rule for fraction equality
            }
        }
    });
})();


