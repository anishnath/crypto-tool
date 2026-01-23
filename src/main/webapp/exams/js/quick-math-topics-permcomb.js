/**
 * Quick Math Topics - Permutations & Combinations
 */

(function registerPermCombTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'permutation-basics': {
            id: 'permutation-basics',
            category: 'Advanced Topics',
            tags: ['permutation', 'combination', 'counting'],
            title: 'Permutation | Order Matters!',
            ctrHeadline: 'nPr = n!/(n-r)! when arrangement matters',
            description: 'Count arrangements where order is important.',
            difficulty: 'Advanced',
            formula: 'nPr = n!/(n-r)!',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Permutation:</strong> ABC ≠ BAC (order matters!)</p>

                    <div class="example-box">
                        <div class="problem">How many ways to arrange 3 people in 3 seats?</div>
                        <div class="step">Step 1: First seat: 3 choices</div>
                        <div class="step">Step 2: Second seat: 2 choices</div>
                        <div class="step">Step 3: Third seat: 1 choice</div>
                        <div class="step">Step 4: Total = 3 × 2 × 1 = 3! = <strong>6 ways</strong></div>
                        <div class="result">Answer: 6</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Choose 2 from 5 people for President & VP?</div>
                        <div class="step">5P2 = 5!/(5-2)! = 5!/3! = 5 × 4 = <strong>20 ways</strong></div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Shortcut:</strong> nPr = n × (n-1) × (n-2) × ... × (n-r+1) (r terms)
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 3) + 5; // 5-7
                const r = Math.floor(Math.random() * 2) + 2; // 2-3
                let result = 1;
                for (let i = 0; i < r; i++) {
                    result *= (n - i);
                }

                return {
                    text: `${n}P${r} = ?`,
                    answer: result
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'combination-basics': {
            id: 'combination-basics',
            category: 'Advanced Topics',
            tags: ['permutation', 'combination', 'counting'],
            title: 'Combination | Order Doesn\'t Matter',
            ctrHeadline: 'nCr = n!/[r!(n-r)!] when selection only',
            description: 'Count selections where order is NOT important.',
            difficulty: 'Advanced',
            formula: 'nCr = n!/[r!(n-r)!]',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Combination:</strong> {A,B,C} = {B,A,C} (order doesn't matter!)</p>

                    <div class="example-box">
                        <div class="problem">Choose 2 friends from 4 for a team?</div>
                        <div class="step">Step 1: 4C2 = 4!/(2! × 2!)</div>
                        <div class="step">Step 2: = (4 × 3)/(2 × 1) = 12/2</div>
                        <div class="step">Step 3: = <strong>6 ways</strong></div>
                        <div class="result">Answer: 6</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Mental shortcut for nCr</div>
                        <div class="step">nCr = nC(n-r) (symmetry!)</div>
                        <div class="step">10C8 = 10C2 = 45 (easier!)</div>
                        <div class="step">nC1 = n (always!)</div>
                        <div class="step">nC0 = 1, nCn = 1</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 3) + 5; // 5-7
                const r = 2; // Keep simple for mental math
                const result = (n * (n - 1)) / 2;

                return {
                    text: `${n}C${r} = ?`,
                    answer: result
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'permutation-circular': {
            id: 'permutation-circular',
            category: 'Advanced Topics',
            tags: ['permutation', 'circular'],
            title: 'Circular Permutation | (n-1)!',
            ctrHeadline: 'Round table? Fix one position!',
            description: 'Arrange items in a circle: (n-1)! arrangements.',
            difficulty: 'Advanced',
            formula: 'Circular = (n-1)!',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">In a circle, rotations are <strong>same</strong>! Fix one position.</p>

                    <div class="example-box">
                        <div class="problem">Arrange 5 people around a circular table?</div>
                        <div class="step">Step 1: Fix one person (to avoid counting rotations)</div>
                        <div class="step">Step 2: Arrange remaining 4 people = 4!</div>
                        <div class="step">Step 3: = 4 × 3 × 2 × 1 = <strong>24 ways</strong></div>
                        <div class="result">Answer: 24</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Why?</strong> ABCDE = BCDEA = CDEAB in a circle (same arrangement!)
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const n = Math.floor(Math.random() * 3) + 4; // 4-6
                let factorial = 1;
                for (let i = 1; i < n; i++) {
                    factorial *= i;
                }

                return {
                    text: `Arrange ${n} people in a circle?`,
                    answer: factorial
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        }
    });
})();
