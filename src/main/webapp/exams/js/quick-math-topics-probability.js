/**
 * Quick Math Topics - Probability
 */

(function registerProbabilityTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'probability-basic': {
            id: 'probability-basic',
            category: 'Probability & Statistics',
            tags: ['probability'],
            title: 'Basic Probability Formula | Quick Method',
            ctrHeadline: 'Master Probability in 5 Minutes! 🎲',
            description: 'Learn the fundamental probability formula (Favorable/Total) for competitive exams. Essential concept for SSC, Banking, Railway quantitative aptitude probability questions.',
            difficulty: 'Beginner',
            formula: 'P(Event) = Favorable Outcomes / Total Outcomes',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Probability is simply <strong>how many ways you can win</strong> divided by <strong>all possible ways</strong>.</p>

                    <!-- SVG Visual -->
                    <svg viewBox="0 0 360 140" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Total outcomes -->
                            <rect x="20" y="20" width="140" height="50" rx="8" fill="var(--bg-tertiary, #1a1a2e)" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                            <text x="90" y="40" font-size="12" fill="var(--text-muted, #888)">Total Outcomes</text>
                            <text x="90" y="60" font-size="24" font-weight="bold" fill="var(--accent-primary, #6366f1)">6</text>

                            <!-- Favorable outcomes -->
                            <rect x="200" y="20" width="140" height="50" rx="8" fill="var(--bg-tertiary, #1a1a2e)" stroke="var(--success, #22c55e)" stroke-width="2"/>
                            <text x="270" y="40" font-size="12" fill="var(--text-muted, #888)">Favorable</text>
                            <text x="270" y="60" font-size="24" font-weight="bold" fill="var(--success, #22c55e)">3</text>

                            <!-- Division line -->
                            <line x1="90" y1="85" x2="270" y2="85" stroke="var(--text-secondary, #666)" stroke-width="2"/>

                            <!-- Result -->
                            <text x="180" y="115" font-size="20" font-weight="bold" fill="var(--warning, #f59e0b)">P = 3/6 = 0.5</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Rolling a die, probability of getting an even number?</div>
                        <div class="step">Step 1: Total outcomes = 6 (faces 1-6)</div>
                        <div class="step">Step 2: Favorable outcomes = 3 (2, 4, 6)</div>
                        <div class="step">Step 3: P(Even) = 3/6 = <strong>1/2</strong> or 0.5</div>
                        <div class="result">Probability = 0.5 (50%)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const scenarios = [
                    { total: 6, favorable: 3, desc: 'even number on a die' },
                    { total: 6, favorable: 2, desc: 'number greater than 4 on a die' },
                    { total: 52, favorable: 13, desc: 'heart from a deck of cards' },
                    { total: 52, favorable: 4, desc: 'ace from a deck of cards' },
                    { total: 2, favorable: 1, desc: 'heads on a coin flip' }
                ];
                const s = scenarios[Math.floor(Math.random() * scenarios.length)];
                return {
                    text: `Probability of getting ${s.desc}? (as fraction like 1/2)`,
                    answer: `${s.favorable}/${s.total}`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const [uN, uD] = userAns.split('/').map(n => parseInt(n.trim()));
                const [cN, cD] = correctAns.split('/').map(n => parseInt(n.trim()));
                return (uN * cD) === (uD * cN);
            }
        },
        'probability-complement': {
            id: 'probability-complement',
            category: 'Probability & Statistics',
            tags: ['probability'],
            title: 'Complementary Probability | 1 - P',
            ctrHeadline: 'P(not A) = 1 - P(A)',
            description: 'Instead of counting what you want, count what you DON\'T want and subtract from 1.',
            difficulty: 'Beginner',
            formula: 'P(not A) = 1 - P(A)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Sometimes it's <strong>easier to find what you DON'T want</strong>!</p>

                    <!-- SVG Complement Visual -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Circle representing all outcomes -->
                            <circle cx="180" cy="60" r="50" fill="none" stroke="var(--accent-primary, #6366f1)" stroke-width="3"/>
                            <text x="180" y="65" font-size="14" fill="var(--text-primary, #ddd)">All = 1</text>

                            <!-- Event A (shaded) -->
                            <path d="M 180,10 A 50,50 0 0,1 180,110 A 50,50 0 0,1 180,10" fill="var(--success, #22c55e)" opacity="0.3"/>
                            <text x="180" y="45" font-size="12" font-weight="bold" fill="var(--success, #22c55e)">P(A) = 0.3</text>

                            <!-- Complement (not A) -->
                            <path d="M 180,10 A 50,50 0 1,1 180,110 A 50,50 0 1,1 180,10" fill="var(--warning, #f59e0b)" opacity="0.3"/>
                            <text x="180" y="85" font-size="12" font-weight="bold" fill="var(--warning, #f59e0b)">P(not A) = 0.7</text>

                            <!-- Equation -->
                            <text x="180" y="110" font-size="14" fill="var(--text-secondary, #888)">0.3 + 0.7 = 1</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Probability of NOT getting a 6 on a die?</div>
                        <div class="step">Step 1: P(6) = 1/6</div>
                        <div class="step">Step 2: P(not 6) = 1 - 1/6 = <strong>5/6</strong></div>
                        <div class="result">Probability = 5/6</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Why use this?</strong> Sometimes counting "not A" is easier than counting all favorable cases!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const scenarios = [
                    { p: 1 / 6, desc: 'NOT getting a 6 on a die' },
                    { p: 1 / 4, desc: 'NOT getting heads on a coin' },
                    { p: 13 / 52, desc: 'NOT getting a heart from cards' },
                    { p: 4 / 52, desc: 'NOT getting an ace from cards' }
                ];
                const s = scenarios[Math.floor(Math.random() * scenarios.length)];
                const answer = 1 - s.p;
                return {
                    text: `Probability of ${s.desc}? (as decimal)`,
                    answer: answer
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) < 0.01
        },
        'probability-independent': {
            id: 'probability-independent',
            category: 'Probability & Statistics',
            tags: ['probability'],
            title: 'Independent Events Probability | Multiply Method',
            ctrHeadline: 'Solve Independent Events INSTANTLY! Just Multiply! ✨',
            description: 'Master the multiplication rule for independent events in competitive exams. Learn when events don\'t affect each other - crucial for SSC, Banking, Railway probability.',
            difficulty: 'Intermediate',
            formula: 'P(A and B) = P(A) × P(B)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For <strong>independent events</strong> (one doesn't affect the other), <strong>multiply</strong> probabilities.</p>

                    <!-- SVG Independent Events -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Event A -->
                            <rect x="30" y="30" width="100" height="50" rx="8" fill="var(--accent-primary, #6366f1)" opacity="0.3"/>
                            <text x="80" y="55" font-size="14" font-weight="bold" fill="var(--accent-primary, #6366f1)">P(A) = 1/2</text>

                            <!-- Multiply sign -->
                            <text x="160" y="55" font-size="24" fill="var(--text-secondary, #666)">×</text>

                            <!-- Event B -->
                            <rect x="230" y="30" width="100" height="50" rx="8" fill="var(--success, #22c55e)" opacity="0.3"/>
                            <text x="280" y="55" font-size="14" font-weight="bold" fill="var(--success, #22c55e)">P(B) = 1/3</text>

                            <!-- Equals -->
                            <text x="180" y="100" font-size="18" font-weight="bold" fill="var(--warning, #f59e0b)">P(A and B) = 1/6</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Flip a coin (heads) AND roll a die (even). Probability?</div>
                        <div class="step">Step 1: P(Heads) = 1/2 (independent)</div>
                        <div class="step">Step 2: P(Even) = 3/6 = 1/2 (independent)</div>
                        <div class="step">Step 3: P(Heads AND Even) = (1/2) × (1/2) = <strong>1/4</strong></div>
                        <div class="result">Probability = 1/4</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Key:</strong> Events are independent if one doesn't change the probability of the other.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const scenarios = [
                    { p1: 1 / 2, p2: 1 / 2, desc: 'heads on coin AND even on die' },
                    { p1: 1 / 2, p2: 1 / 6, desc: 'heads on coin AND 6 on die' },
                    { p1: 1 / 3, p2: 1 / 3, desc: 'red ball AND blue ball (from different bags)' }
                ];
                const s = scenarios[Math.floor(Math.random() * scenarios.length)];
                const answer = s.p1 * s.p2;
                return {
                    text: `Probability of ${s.desc}? (as decimal)`,
                    answer: answer
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) < 0.01
        },
        'probability-mutually-exclusive': {
            id: 'probability-mutually-exclusive',
            category: 'Probability & Statistics',
            tags: ['probability'],
            title: 'Mutually Exclusive Events | Addition Rule',
            ctrHeadline: 'P(A or B) Made EASY! Just Add Them! 👍',
            description: 'Learn the addition rule for mutually exclusive events for competitive exams. Master when events can\'t happen together - essential for SSC, Banking, Railway probability.',
            difficulty: 'Intermediate',
            formula: 'P(A or B) = P(A) + P(B)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For <strong>mutually exclusive events</strong> (can't both happen), <strong>add</strong> probabilities.</p>

                    <!-- SVG Mutually Exclusive -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Event A -->
                            <circle cx="90" cy="50" r="30" fill="var(--accent-primary, #6366f1)" opacity="0.3"/>
                            <text x="90" y="55" font-size="12" font-weight="bold" fill="var(--accent-primary, #6366f1)">P(A) = 1/6</text>

                            <!-- Plus sign -->
                            <text x="180" y="55" font-size="24" fill="var(--text-secondary, #666)">+</text>

                            <!-- Event B -->
                            <circle cx="270" cy="50" r="30" fill="var(--success, #22c55e)" opacity="0.3"/>
                            <text x="270" y="55" font-size="12" font-weight="bold" fill="var(--success, #22c55e)">P(B) = 1/6</text>

                            <!-- Note: No overlap -->
                            <text x="180" y="95" font-size="11" fill="var(--text-muted, #888)">No overlap (mutually exclusive)</text>

                            <!-- Result -->
                            <text x="180" y="115" font-size="16" font-weight="bold" fill="var(--warning, #f59e0b)">P(A or B) = 1/3</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Rolling a die, probability of getting 2 OR 5?</div>
                        <div class="step">Step 1: P(2) = 1/6</div>
                        <div class="step">Step 2: P(5) = 1/6</div>
                        <div class="step">Step 3: Can't get both at once (mutually exclusive)</div>
                        <div class="step">Step 4: P(2 OR 5) = 1/6 + 1/6 = <strong>2/6 = 1/3</strong></div>
                        <div class="result">Probability = 1/3</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Key:</strong> Mutually exclusive = can't happen at the same time (like rolling 2 and 5 simultaneously).
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const scenarios = [
                    { p1: 1 / 6, p2: 1 / 6, desc: 'getting 2 OR 5 on a die' },
                    { p1: 1 / 6, p2: 1 / 6, desc: 'getting 1 OR 6 on a die' },
                    { p1: 13 / 52, p2: 13 / 52, desc: 'getting heart OR spade from cards' }
                ];
                const s = scenarios[Math.floor(Math.random() * scenarios.length)];
                const answer = s.p1 + s.p2;
                return {
                    text: `Probability of ${s.desc}? (as fraction like 1/3)`,
                    answer: answer === 1 / 3 ? '1/3' : answer === 2 / 6 ? '2/6' : answer.toString()
                };
            },
            checkAnswer: (userAns, correctAns) => {
                if (userAns.includes('/')) {
                    const [uN, uD] = userAns.split('/').map(n => parseInt(n.trim()));
                    if (correctAns === 1 / 3) return (uN === 1 && uD === 3) || (uN === 2 && uD === 6);
                    if (correctAns === 1 / 2) return (uN === 1 && uD === 2) || (uN === 26 && uD === 52);
                }
                return Math.abs(parseFloat(userAns) - correctAns) < 0.01;
            }
        },
        'probability-conditional': {
            id: 'probability-conditional',
            category: 'Probability & Statistics',
            tags: ['probability', 'advanced'],
            title: 'Conditional Probability | P(A|B)',
            ctrHeadline: 'P(A given B) = P(A and B) / P(B)',
            description: 'When one event affects another, use conditional probability.',
            difficulty: 'Advanced',
            formula: 'P(A|B) = P(A and B) / P(B)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Conditional probability: <strong>What's the chance of A, given that B already happened?</strong></p>

                    <!-- SVG Conditional -->
                    <svg viewBox="0 0 360 140" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Event B (larger circle) -->
                            <circle cx="180" cy="60" r="45" fill="var(--success, #22c55e)" opacity="0.2" stroke="var(--success, #22c55e)" stroke-width="2"/>
                            <text x="180" y="65" font-size="12" fill="var(--success, #22c55e)">B happened</text>

                            <!-- Event A (smaller, inside B) -->
                            <circle cx="180" cy="60" r="25" fill="var(--accent-primary, #6366f1)" opacity="0.5"/>
                            <text x="180" y="65" font-size="11" font-weight="bold" fill="white">A and B</text>

                            <!-- Formula -->
                            <text x="180" y="110" font-size="14" fill="var(--text-secondary, #888)">P(A|B) = P(A∩B) / P(B)</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">From a deck, if you drew a red card, what's P(Heart)?</div>
                        <div class="step">Step 1: P(Red) = 26/52 = 1/2</div>
                        <div class="step">Step 2: P(Heart AND Red) = 13/52 = 1/4</div>
                        <div class="step">Step 3: P(Heart | Red) = (1/4) / (1/2) = <strong>1/2</strong></div>
                        <div class="result">Given it's red, P(Heart) = 1/2</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Intuition:</strong> If you know B happened, focus only on outcomes where B is true.
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const scenarios = [
                    { desc: 'heart given red card', answer: 0.5 },
                    { desc: 'ace given face card', answer: 0 } // No aces are face cards
                ];
                const s = scenarios[Math.floor(Math.random() * scenarios.length)];
                return {
                    text: `From a deck, if you drew a red card, probability of ${s.desc}? (as decimal)`,
                    answer: s.answer
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) < 0.01
        },
        'probability-dice': {
            id: 'probability-dice',
            category: 'Probability & Statistics',
            tags: ['probability'],
            title: 'Dice Probability | Sum Shortcuts',
            ctrHeadline: 'Probability of Rolling a Sum',
            description: 'Quick ways to find probability of getting a specific sum when rolling dice.',
            difficulty: 'Intermediate',
            formula: 'Count favorable combinations / Total outcomes',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For dice sums, <strong>count favorable combinations</strong>.</p>

                    <!-- SVG Dice Sums -->
                    <svg viewBox="0 0 360 140" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Die 1 -->
                            <rect x="50" y="40" width="50" height="50" rx="5" fill="var(--accent-primary, #6366f1)" opacity="0.3" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                            <text x="75" y="70" font-size="16" font-weight="bold" fill="var(--accent-primary, #6366f1)">1-6</text>

                            <!-- Plus -->
                            <text x="130" y="65" font-size="20" fill="var(--text-secondary, #666)">+</text>

                            <!-- Die 2 -->
                            <rect x="160" y="40" width="50" height="50" rx="5" fill="var(--success, #22c55e)" opacity="0.3" stroke="var(--success, #22c55e)" stroke-width="2"/>
                            <text x="185" y="70" font-size="16" font-weight="bold" fill="var(--success, #22c55e)">1-6</text>

                            <!-- Equals -->
                            <text x="240" y="65" font-size="20" fill="var(--text-secondary, #666)">=</text>

                            <!-- Sum -->
                            <text x="300" y="65" font-size="18" font-weight="bold" fill="var(--warning, #f59e0b)">Sum</text>

                            <!-- Total outcomes -->
                            <text x="180" y="110" font-size="12" fill="var(--text-muted, #888)">Total = 6 × 6 = 36 outcomes</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Rolling 2 dice, probability of sum = 7?</div>
                        <div class="step">Step 1: Total outcomes = 6 × 6 = 36</div>
                        <div class="step">Step 2: Ways to get 7: (1,6), (2,5), (3,4), (4,3), (5,2), (6,1) = <strong>6 ways</strong></div>
                        <div class="step">Step 3: P(Sum=7) = 6/36 = <strong>1/6</strong></div>
                        <div class="result">Probability = 1/6</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Pattern:</strong> Sum of 7 is most likely (6 ways). Sums near edges (2, 12) are least likely (1 way each).
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const sums = [
                    { sum: 7, favorable: 6 },
                    { sum: 6, favorable: 5 },
                    { sum: 8, favorable: 5 },
                    { sum: 5, favorable: 4 },
                    { sum: 9, favorable: 4 }
                ];
                const s = sums[Math.floor(Math.random() * sums.length)];
                return {
                    text: `Rolling 2 dice, probability of sum = ${s.sum}? (as fraction)`,
                    answer: `${s.favorable}/36`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const [uN, uD] = userAns.split('/').map(n => parseInt(n.trim()));
                const [cN, cD] = correctAns.split('/').map(n => parseInt(n.trim()));
                return (uN * cD) === (uD * cN);
            }
        },
        'probability-at-least-one': {
            id: 'probability-at-least-one',
            category: 'Probability & Statistics',
            tags: ['probability', 'advanced'],
            title: 'At Least One | Use Complement',
            ctrHeadline: 'P(at least one) = 1 - P(none)',
            description: 'Finding "at least one" is easier by finding "none" and subtracting from 1.',
            difficulty: 'Advanced',
            formula: 'P(at least one) = 1 - P(all fail)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">For "at least one", use the <strong>complement trick</strong>: Find P(none) and subtract!</p>

                    <!-- SVG At Least One -->
                    <svg viewBox="0 0 360 120" style="width: 100%; max-width: 400px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- All outcomes -->
                            <rect x="20" y="20" width="320" height="50" rx="8" fill="var(--bg-tertiary, #1a1a2e)" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                            <text x="180" y="45" font-size="14" fill="var(--text-primary, #ddd)">All Possible Outcomes</text>

                            <!-- None (shaded) -->
                            <rect x="30" y="30" width="140" height="30" rx="5" fill="var(--danger, #ef4444)" opacity="0.3"/>
                            <text x="100" y="50" font-size="12" font-weight="bold" fill="var(--danger, #ef4444)">P(none) = ?</text>

                            <!-- At least one -->
                            <rect x="190" y="30" width="140" height="30" rx="5" fill="var(--success, #22c55e)" opacity="0.3"/>
                            <text x="260" y="50" font-size="12" font-weight="bold" fill="var(--success, #22c55e)">P(at least 1) = 1 - P(none)</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">3 coin flips, probability of at least one head?</div>
                        <div class="step">Step 1: P(no heads) = P(all tails) = (1/2)³ = 1/8</div>
                        <div class="step">Step 2: P(at least one head) = 1 - 1/8 = <strong>7/8</strong></div>
                        <div class="result">Probability = 7/8</div>
                    </div>
                    <p class="step-intro" style="margin-top: var(--space-4); font-size: var(--text-sm);">
                        <strong>Why this works:</strong> "At least one" means "not zero", so use complement rule!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 3) + 2; // 2-4
                const pFail = 1 / 2; // For coin flips
                const pNone = Math.pow(pFail, n);
                const pAtLeastOne = 1 - pNone;
                return {
                    text: `${n} coin flips, probability of at least one head? (as fraction)`,
                    answer: pAtLeastOne === 3 / 4 ? '3/4' : pAtLeastOne === 7 / 8 ? '7/8' : pAtLeastOne.toString()
                };
            },
            checkAnswer: (userAns, correctAns) => {
                if (userAns.includes('/')) {
                    const [uN, uD] = userAns.split('/').map(n => parseInt(n.trim()));
                    if (correctAns === 3 / 4) return (uN === 3 && uD === 4);
                    if (correctAns === 7 / 8) return (uN === 7 && uD === 8);
                }
                return Math.abs(parseFloat(userAns) - correctAns) < 0.01;
            }
        }
    });
})();

