/**
 * Quick Math Topics - HCF & LCM, Set Theory
 */

(function registerMathFoundations() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        // ===== HCF & LCM =====
        'hcf-lcm-relationship': {
            id: 'hcf-lcm-relationship',
            category: 'Number Theory',
            tags: ['hcf', 'lcm', 'gcd'],
            title: 'HCF × LCM Formula | Quick Trick',
            ctrHeadline: 'Know Any 3? Find the 4th Instantly! 💡',
            description: 'Master the HCF × LCM = a × b relationship for competitive exams. Find missing values instantly - essential shortcut for SSC, Banking, Railway number theory questions.',
            difficulty: 'Intermediate',
            formula: 'HCF × LCM = a × b',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Know any 3? Find the 4th using <strong>HCF × LCM = a × b</strong>!</p>

                    <div class="example-box">
                        <div class="problem">Two numbers are 12 and 18. HCF = 6. Find LCM.</div>
                        <div class="step">Step 1: Use formula HCF × LCM = a × b</div>
                        <div class="step">Step 2: 6 × LCM = 12 × 18</div>
                        <div class="step">Step 3: 6 × LCM = 216</div>
                        <div class="step">Step 4: LCM = 216/6 = <strong>36</strong></div>
                        <div class="result">LCM = 36</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Verify: 12 = 2² × 3, 18 = 2 × 3²</div>
                        <div class="step">HCF = 2 × 3 = 6 (common factors)</div>
                        <div class="step">LCM = 2² × 3² = 36 (highest powers)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const numbers = [[12, 18, 6], [15, 20, 5], [8, 12, 4]];
                const set = numbers[Math.floor(Math.random() * numbers.length)];
                const [a, b, hcf] = set;
                const lcm = (a * b) / hcf;

                return {
                    text: `Numbers: ${a}, ${b}. HCF=${hcf}. LCM?`,
                    answer: lcm
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'hcf-division-method': {
            id: 'hcf-division-method',
            category: 'Number Theory',
            tags: ['hcf', 'gcd', 'euclid'],
            title: 'HCF by Division Method (Euclid)',
            ctrHeadline: 'Divide larger by smaller, repeat!',
            description: 'Find HCF using Euclid\'s algorithm - divide and take remainder.',
            difficulty: 'Advanced',
            formula: 'HCF(a,b) = HCF(b, a mod b)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Keep dividing until <strong>remainder = 0</strong>. Last divisor is HCF!</p>

                    <div class="example-box">
                        <div class="problem">Find HCF of 48 and 18</div>
                        <div class="step">Step 1: 48 ÷ 18 = 2 remainder <strong>12</strong></div>
                        <div class="step">Step 2: 18 ÷ 12 = 1 remainder <strong>6</strong></div>
                        <div class="step">Step 3: 12 ÷ 6 = 2 remainder <strong>0</strong></div>
                        <div class="step">Step 4: Last divisor = <strong>6</strong></div>
                        <div class="result">HCF = 6</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Why it works:</strong> Based on Euclidean algorithm - very efficient!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const hcfs = [[48, 18, 6], [56, 24, 8], [72, 30, 6]];
                const set = hcfs[Math.floor(Math.random() * hcfs.length)];
                const [a, b, hcf] = set;

                return {
                    text: `HCF of ${a} and ${b}?`,
                    answer: hcf
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'lcm-prime-factorization': {
            id: 'lcm-prime-factorization',
            category: 'Number Theory',
            tags: ['lcm', 'primes'],
            title: 'LCM Using Prime Factors | Fast Method',
            ctrHeadline: 'Calculate LCM of ANY Numbers in 30 Seconds! ⚡',
            description: 'Learn to find LCM using prime factorization method for competitive exams. Break numbers into prime factors and take highest powers - crucial for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'LCM = product of highest powers',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Factor both numbers, take <strong>highest power</strong> of each prime!</p>

                    <div class="example-box">
                        <div class="problem">Find LCM of 12 and 18</div>
                        <div class="step">Step 1: 12 = 2² × 3¹</div>
                        <div class="step">Step 2: 18 = 2¹ × 3²</div>
                        <div class="step">Step 3: Take max powers: 2² and 3²</div>
                        <div class="step">Step 4: LCM = 4 × 9 = <strong>36</strong></div>
                        <div class="result">LCM = 36</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const problems = [[12, 18, 36], [15, 20, 60], [8, 12, 24]];
                const set = problems[Math.floor(Math.random() * problems.length)];
                const [a, b, lcm] = set;

                return {
                    text: `LCM of ${a} and ${b}?`,
                    answer: lcm
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },

        // ===== SET THEORY =====
        'set-union': {
            id: 'set-union',
            category: 'Logical Reasoning',
            tags: ['sets', 'venn', 'logic'],
            title: 'Set Union | n(A∪B) Formula',
            ctrHeadline: 'Union = A + B - Intersection!',
            description: 'Count elements in union: add both sets, subtract overlap.',
            difficulty: 'Intermediate',
            formula: 'n(A∪B) = n(A) + n(B) - n(A∩B)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Add both sets, but <strong>subtract overlap</strong> (counted twice!)</p>

                    <div class="example-box">
                        <div class="problem">25 students play cricket, 20 play football, 10 play both. Total players?</div>
                        <div class="step">Step 1: n(C) = 25, n(F) = 20, n(C∩F) = 10</div>
                        <div class="step">Step 2: n(C∪F) = n(C) + n(F) - n(C∩F)</div>
                        <div class="step">Step 3: = 25 + 20 - 10 = <strong>35 students</strong></div>
                        <div class="result">Total: 35</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Breakdown</div>
                        <div class="step">Only cricket: 25 - 10 = 15</div>
                        <div class="step">Only football: 20 - 10 = 10</div>
                        <div class="step">Both: 10</div>
                        <div class="step">Total: 15 + 10 + 10 = 35 ✓</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = (Math.floor(Math.random() * 5) + 3) * 5; // 15-35
                const b = (Math.floor(Math.random() * 4) + 3) * 5; // 15-30
                const both = Math.floor(Math.random() * 3) + 2; // 2-4 (small overlap)
                const union = a + b - both;

                return {
                    text: `n(A)=${a}, n(B)=${b}, n(A∩B)=${both}. n(A∪B)?`,
                    answer: union
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'set-three-sets': {
            id: 'set-three-sets',
            category: 'Logical Reasoning',
            tags: ['sets', 'venn', 'advanced'],
            title: 'Venn Diagram 3-Set Formula | Quick Trick',
            ctrHeadline: 'This 1 Formula Solves ALL Venn Diagram Problems! 🤯',
            description: 'Master the 3-set inclusion-exclusion formula for Venn diagrams in competitive exams. Calculate n(A∪B∪C) instantly - essential for SSC, Banking, and Railway quantitative aptitude.',
            difficulty: 'Advanced',
            formula: 'n(A∪B∪C) = n(A)+n(B)+n(C) - n(A∩B) - n(B∩C) - n(A∩C) + n(A∩B∩C)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Three sets? <strong>Inclusion-Exclusion</strong> principle!</p>

                    <div class="example-box">
                        <div class="problem">Formula breakdown</div>
                        <div class="step">Add all three: n(A) + n(B) + n(C)</div>
                        <div class="step">Subtract all pairs: - n(A∩B) - n(B∩C) - n(A∩C)</div>
                        <div class="step">Add back triple overlap: + n(A∩B∩C)</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Simple case: No triple overlap</div>
                        <div class="step">n(A)=20, n(B)=15, n(C)=10</div>
                        <div class="step">n(A∩B)=5, n(B∩C)=3, n(A∩C)=4, n(A∩B∩C)=0</div>
                        <div class="step">Union = 20+15+10 - 5-3-4 + 0 = <strong>33</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = 20, b = 15, c = 10;
                const ab = 5, bc = 3, ac = 4, abc = 0;
                const union = a + b + c - ab - bc - ac + abc;

                return {
                    text: `n(A)=20,n(B)=15,n(C)=10,n(A∩B)=5,n(B∩C)=3,n(A∩C)=4,n(A∩B∩C)=0. n(A∪B∪C)?`,
                    answer: union
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        }
    });
})();
