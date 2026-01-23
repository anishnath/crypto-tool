/**
 * Quick Math Topics - Trigonometry Shortcuts
 */

(function registerTrigTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'trig-standard-angles': {
            id: 'trig-standard-angles',
            category: 'Advanced Topics',
            tags: ['trigonometry', 'memorization'],
            title: 'Standard Angles | 0°, 30°, 45°, 60°, 90°',
            ctrHeadline: 'Memorize these 5 angles and ace trig!',
            description: 'The fundamental values every student must know by heart.',
            difficulty: 'Beginner',
            formula: 'Pattern: √0, √1, √2, √3, √4 divided by 2',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Memorize using the <strong>√n/2 pattern</strong> for sin values!</p>

                    <!-- SVG Table -->
                    <svg viewBox="0 0 400 160" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Headers -->
                            <text x="50" y="25" font-size="13" fill="var(--text-secondary, #888)" font-weight="bold">Angle</text>
                            <text x="150" y="25" font-size="13" fill="var(--accent-primary, #6366f1)" font-weight="bold">sin θ</text>
                            <text x="250" y="25" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">cos θ</text>
                            <text x="350" y="25" font-size="13" fill="var(--warning, #f59e0b)" font-weight="bold">tan θ</text>

                            <!-- 0° -->
                            <text x="50" y="50" font-size="12" fill="var(--text-primary, #ddd)">0°</text>
                            <text x="150" y="50" font-size="12" fill="var(--accent-primary, #6366f1)">0</text>
                            <text x="250" y="50" font-size="12" fill="var(--success, #22c55e)">1</text>
                            <text x="350" y="50" font-size="12" fill="var(--warning, #f59e0b)">0</text>

                            <!-- 30° -->
                            <text x="50" y="75" font-size="12" fill="var(--text-primary, #ddd)">30°</text>
                            <text x="150" y="75" font-size="12" fill="var(--accent-primary, #6366f1)">1/2</text>
                            <text x="250" y="75" font-size="12" fill="var(--success, #22c55e)">√3/2</text>
                            <text x="350" y="75" font-size="12" fill="var(--warning, #f59e0b)">1/√3</text>

                            <!-- 45° -->
                            <text x="50" y="100" font-size="12" fill="var(--text-primary, #ddd)">45°</text>
                            <text x="150" y="100" font-size="12" fill="var(--accent-primary, #6366f1)">1/√2</text>
                            <text x="250" y="100" font-size="12" fill="var(--success, #22c55e)">1/√2</text>
                            <text x="350" y="100" font-size="12" fill="var(--warning, #f59e0b)">1</text>

                            <!-- 60° -->
                            <text x="50" y="125" font-size="12" fill="var(--text-primary, #ddd)">60°</text>
                            <text x="150" y="125" font-size="12" fill="var(--accent-primary, #6366f1)">√3/2</text>
                            <text x="250" y="125" font-size="12" fill="var(--success, #22c55e)">1/2</text>
                            <text x="350" y="125" font-size="12" fill="var(--warning, #f59e0b)">√3</text>

                            <!-- 90° -->
                            <text x="50" y="150" font-size="12" fill="var(--text-primary, #ddd)">90°</text>
                            <text x="150" y="150" font-size="12" fill="var(--accent-primary, #6366f1)">1</text>
                            <text x="250" y="150" font-size="12" fill="var(--success, #22c55e)">0</text>
                            <text x="350" y="150" font-size="12" fill="var(--warning, #f59e0b)">∞</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Memory Trick for sin values</div>
                        <div class="step">sin 0° = √0/2 = 0</div>
                        <div class="step">sin 30° = √1/2 = 1/2</div>
                        <div class="step">sin 45° = √2/2 = 1/√2</div>
                        <div class="step">sin 60° = √3/2</div>
                        <div class="step">sin 90° = √4/2 = 1</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Trick:</strong> For cos, reverse the pattern! cos θ = sin(90° - θ)
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const angles = [
                    { deg: 0, sin: 0, cos: 1, tan: 0 },
                    { deg: 30, sin: 0.5, cos: 0.866, tan: 0.577 },
                    { deg: 45, sin: 0.707, cos: 0.707, tan: 1 },
                    { deg: 60, sin: 0.866, cos: 0.5, tan: 1.732 },
                    { deg: 90, sin: 1, cos: 0, tan: Infinity }
                ];
                const types = ['sin', 'cos', 'tan'];
                const angle = angles[Math.floor(Math.random() * 4)]; // Skip 90 for tan
                const type = types[Math.floor(Math.random() * types.length)];

                if (type === 'tan' && angle.deg === 90) {
                    return {
                        text: `tan 90° = ?`,
                        answer: 'undefined'
                    };
                }

                return {
                    text: `${type} ${angle.deg}° = ?`,
                    answer: angle[type]
                };
            },
            checkAnswer: (userAns, correctAns) => {
                if (correctAns === 'undefined') return userAns.toLowerCase().includes('undef') || userAns === '∞';
                return Math.abs(parseFloat(userAns) - correctAns) <= 0.01;
            }
        },
        'trig-complementary': {
            id: 'trig-complementary',
            category: 'Advanced Topics',
            tags: ['trigonometry', 'identities'],
            title: 'Complementary Angles | Co-functions',
            ctrHeadline: 'sin θ = cos(90° - θ) and vice versa!',
            description: 'Complementary angle relationships make trig calculations instant.',
            difficulty: 'Intermediate',
            formula: 'sin θ = cos(90° - θ), tan θ = cot(90° - θ)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Complementary angles</strong> add to 90°. Their trig values swap!</p>

                    <!-- SVG Right Triangle -->
                    <svg viewBox="0 0 380 180" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace">
                            <!-- Right Triangle -->
                            <path d="M100,140 L280,140 L100,40 Z" fill="none" stroke="var(--accent-primary, #6366f1)" stroke-width="3"/>
                            
                            <!-- Right angle marker -->
                            <rect x="100" y="130" width="10" height="10" fill="none" stroke="var(--text-secondary, #666)" stroke-width="1"/>
                            
                            <!-- Angle θ -->
                            <path d="M120,140 A20,20 0 0,1 110,125" fill="none" stroke="var(--warning, #f59e0b)" stroke-width="2"/>
                            <text x="130" y="135" font-size="14" fill="var(--warning, #f59e0b)">θ</text>
                            
                            <!-- Angle (90-θ) -->
                            <path d="M100,60 A20,20 0 0,1 115,65" fill="none" stroke="var(--success, #22c55e)" stroke-width="2"/>
                            <text x="85" y="55" font-size="14" fill="var(--success, #22c55e)">90-θ</text>
                            
                            <!-- Sides -->
                            <text x="190" y="155" font-size="12" fill="var(--text-secondary, #888)" text-anchor="middle">Adjacent (for θ)</text>
                            <text x="75" y="90" font-size="12" fill="var(--text-secondary, #888)" text-anchor="end">Opposite (for θ)</text>
                            <text x="200" y="85" font-size="12" fill="var(--text-secondary, #888)" text-anchor="middle">Hypotenuse</text>
                        </g>

                        <g text-anchor="middle">
                            <text x="190" y="20" font-size="14" fill="var(--danger, #ef4444)" font-weight="bold">
                                For θ: Opposite = Hypotenuse × sin θ
                            </text>
                            <text x="190" y="175" font-size="14" fill="var(--danger, #ef4444)" font-weight="bold">
                                For (90-θ): Adjacent becomes Opposite!
                            </text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Quick identities</div>
                        <div class="step">sin 30° = cos 60° = 1/2</div>
                        <div class="step">sin 45° = cos 45° = 1/√2</div>
                        <div class="step">sin 60° = cos 30° = √3/2</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">What is cos 25°?</div>
                        <div class="step">cos 25° = sin(90° - 25°) = sin 65°</div>
                        <div class="result">Answer: sin 65°</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const angle = (Math.floor(Math.random() * 8) + 1) * 10; // 10-80
                const complement = 90 - angle;
                const types = [
                    { q: `sin`, a: `cos` },
                    { q: `cos`, a: `sin` },
                    { q: `tan`, a: `cot` },
                    { q: `cot`, a: `tan` }
                ];
                const type = types[Math.floor(Math.random() * types.length)];
                return {
                    text: `${type.q} ${angle}° = ${type.a} ?`,
                    answer: complement
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'trig-pythagorean': {
            id: 'trig-pythagorean',
            category: 'Advanced Topics',
            tags: ['trigonometry', 'identities'],
            title: 'Pythagorean Identity | sin² + cos² = 1',
            ctrHeadline: 'The most important identity in trigonometry!',
            description: 'If you know sin, you can find cos instantly (and vice versa).',
            difficulty: 'Intermediate',
            formula: 'sin²θ + cos²θ = 1',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">The <strong>fundamental identity</strong> that connects sin and cos!</p>

                    <div class="example-box">
                        <div class="problem">If sin θ = 3/5, find cos θ</div>
                        <div class="step">Step 1: Use sin²θ + cos²θ = 1</div>
                        <div class="step">Step 2: (3/5)² + cos²θ = 1</div>
                        <div class="step">Step 3: 9/25 + cos²θ = 1</div>
                        <div class="step">Step 4: cos²θ = 1 - 9/25 = 16/25</div>
                        <div class="step">Step 5: cos θ = ±4/5</div>
                        <div class="result">Answer: cos θ = 4/5 (assuming first quadrant)</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Derived forms:</strong> 1 + tan²θ = sec²θ, 1 + cot²θ = csc²θ
                    </p>
                </div>
            `,
            generateQuestion: () => {
                // Generate Pythagorean triples
                const triples = [[3, 4, 5], [5, 12, 13], [8, 15, 17]];
                const triple = triples[Math.floor(Math.random() * triples.length)];
                const sinValue = triple[0] / triple[2];
                const cosValue = triple[1] / triple[2];

                const isGivenSin = Math.random() > 0.5;
                if (isGivenSin) {
                    return {
                        text: `If sin θ = ${triple[0]}/${triple[2]}, find cos θ`,
                        answer: cosValue
                    };
                } else {
                    return {
                        text: `If cos θ = ${triple[1]}/${triple[2]}, find sin θ`,
                        answer: sinValue
                    };
                }
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 0.01
        },
        'trig-tan-formula': {
            id: 'trig-tan-formula',
            category: 'Advanced Topics',
            tags: ['trigonometry'],
            title: 'tan θ = sin θ / cos θ',
            ctrHeadline: 'Don\'t memorize tan! Calculate it!',
            description: 'tan is just the ratio of sin to cos. Use this to find tan values quickly.',
            difficulty: 'Beginner',
            formula: 'tan θ = sin θ / cos θ',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Never forget: <strong>tan = sin/cos</strong>. It's that simple!</p>

                    <div class="example-box">
                        <div class="problem">Find tan 60°</div>
                        <div class="step">Step 1: sin 60° = √3/2</div>
                        <div class="step">Step 2: cos 60° = 1/2</div>
                        <div class="step">Step 3: tan 60° = (√3/2) ÷ (1/2)</div>
                        <div class="step">Step 4: = (√3/2) × (2/1) = <strong>√3</strong></div>
                        <div class="result">Answer: √3 ≈ 1.732</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Verify tan 45° = 1</div>
                        <div class="step">sin 45° = cos 45° = 1/√2</div>
                        <div class="step">tan 45° = (1/√2) ÷ (1/√2) = <strong>1</strong> ✓</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const angles = [30, 45, 60];
                const angle = angles[Math.floor(Math.random() * angles.length)];
                const values = {
                    30: { sin: 0.5, cos: 0.866, tan: 0.577 },
                    45: { sin: 0.707, cos: 0.707, tan: 1 },
                    60: { sin: 0.866, cos: 0.5, tan: 1.732 }
                };
                return {
                    text: `Calculate tan ${angle}° using sin/cos`,
                    answer: values[angle].tan
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 0.05
        },
        'trig-allied-angles': {
            id: 'trig-allied-angles',
            category: 'Advanced Topics',
            tags: ['trigonometry', 'advanced', 'identities'],
            title: 'Allied Angles | Sign Changes',
            ctrHeadline: 'Master (90±θ), (180±θ), (270±θ) instantly!',
            description: 'Learn the pattern: which function changes and what sign to use.',
            difficulty: 'Advanced',
            formula: 'ASTC rule: All, Sin, Tan, Cos positive',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Use the <strong>ASTC rule</strong> to remember signs in each quadrant!</p>

                    <!-- SVG Quadrant Circle -->
                    <svg viewBox="0 0 360 200" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Axes -->
                            <line x1="30" y1="100" x2="330" y2="100" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                            <line x1="180" y1="20" x2="180" y2="180" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                            
                            <!-- Quadrants -->
                            <!-- Q1 -->
                            <circle cx="255" cy="60" r="50" fill="var(--success, #22c55e)" opacity="0.1"/>
                            <text x="255" y="55" font-size="16" fill="var(--success, #22c55e)" font-weight="bold">ALL +</text>
                            <text x="255" y="72" font-size="11" fill="var(--text-secondary, #888)">0° to 90°</text>
                            
                            <!-- Q2 -->
                            <circle cx="105" cy="60" r="50" fill="var(--accent-primary, #6366f1)" opacity="0.1"/>
                            <text x="105" y="55" font-size="16" fill="var(--accent-primary, #6366f1)" font-weight="bold">SIN +</text>
                            <text x="105" y="72" font-size="11" fill="var(--text-secondary, #888)">90° to 180°</text>
                            
                            <!-- Q3 -->
                            <circle cx="105" cy="140" r="50" fill="var(--warning, #f59e0b)" opacity="0.1"/>
                            <text x="105" y="135" font-size="16" fill="var(--warning, #f59e0b)" font-weight="bold">TAN +</text>
                            <text x="105" y="152" font-size="11" fill="var(--text-secondary, #888)">180° to 270°</text>
                            
                            <!-- Q4 -->
                            <circle cx="255" cy="140" r="50" fill="var(--danger, #ef4444)" opacity="0.1"/>
                            <text x="255" y="135" font-size="16" fill="var(--danger, #ef4444)" font-weight="bold">COS +</text>
                            <text x="255" y="152" font-size="11" fill="var(--text-secondary, #888)">270° to 360°</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Key Rules (memorize these!)</div>
                        <div class="step">sin(90° - θ) = cos θ</div>
                        <div class="step">sin(90° + θ) = cos θ</div>
                        <div class="step">sin(180° - θ) = sin θ</div>
                        <div class="step">sin(180° + θ) = -sin θ</div>
                        <div class="step">cos(180° - θ) = -cos θ</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Trick:</strong> (90±θ) and (270±θ) → function changes (sin↔cos, tan↔cot)
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const angle = (Math.floor(Math.random() * 6) + 1) * 10; // 10-60
                const formulas = [
                    { text: `sin(90° - ${angle}°)`, answer: `cos ${angle}°` },
                    { text: `cos(90° - ${angle}°)`, answer: `sin ${angle}°` },
                    { text: `sin(180° - ${angle}°)`, answer: `sin ${angle}°` },
                    { text: `cos(180° - ${angle}°)`, answer: `-cos ${angle}°` }
                ];
                const formula = formulas[Math.floor(Math.random() * formulas.length)];
                return {
                    text: `${formula.text} = ?`,
                    answer: formula.answer
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '').toLowerCase();
                return clean(userAns) === clean(correctAns);
            }
        }
    });
})();
