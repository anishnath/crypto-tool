/**
 * Quick Math Topics - Simple Interest
 */

(function registerSITopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'si-basic': {
            id: 'si-basic',
            category: 'Commercial Math',
            tags: ['simple-interest', 'money', 'interest'],
            title: 'Simple Interest Formula | SI = PRT/100',
            ctrHeadline: 'Calculate Interest Instantly! Easiest Formula! 💰',
            description: 'Master the Simple Interest formula for competitive exams. Calculate interest from Principal, Rate, Time instantly - essential for SSC, Banking, Railway.',
            difficulty: 'Beginner',
            formula: 'SI = (P × R × T) / 100',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Simple Interest is <strong>constant</strong> every year. Just multiply!</p>

                    <div class="example-box">
                        <div class="problem">P = ₹5000, R = 10% per year, T = 3 years. Find SI.</div>
                        <div class="step">Step 1: SI = (P × R × T) / 100</div>
                        <div class="step">Step 2: = (5000 × 10 × 3) / 100</div>
                        <div class="step">Step 3: = 150000 / 100 = <strong>₹1500</strong></div>
                        <div class="result">SI: ₹1500</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Total Amount = Principal + SI</div>
                        <div class="step">A = P + SI = 5000 + 1500 = <strong>₹6500</strong></div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Shortcut:</strong> If R = 10%, then SI = P × T / 10
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const p = (Math.floor(Math.random() * 10) + 5) * 1000; // 5000-15000
                const r = [5, 10, 20][Math.floor(Math.random() * 3)];
                const t = Math.floor(Math.random() * 4) + 2; // 2-5 years
                const si = (p * r * t) / 100;

                return {
                    text: `P=₹${p}, R=${r}%, T=${t}yr. SI?`,
                    answer: si
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'si-vs-ci': {
            id: 'si-vs-ci',
            category: 'Commercial Math',
            tags: ['simple-interest', 'compound-interest', 'comparison'],
            title: 'Simple vs Compound Interest Difference',
            ctrHeadline: 'SI vs CI: What\'s the Real Difference? 💸',
            description: 'Understand the difference between Simple and Compound Interest for competitive exams. Learn why CI grows faster - vital concept for SSC, Banking.',
            difficulty: 'Intermediate',
            formula: 'SI is same yearly, CI grows exponentially',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>SI:</strong> Same every year. <strong>CI:</strong> Compounds (interest on interest)!</p>

                    <div class="example-box">
                        <div class="problem">₹1000 at 10% for 2 years. Compare SI vs CI.</div>
                        <div class="step"><strong>Simple Interest:</strong></div>
                        <div class="step">Year 1: 10% of 1000 = 100</div>
                        <div class="step">Year 2: 10% of 1000 = 100</div>
                        <div class="step">Total SI = 200</div>
                        
                        <div class="step" style="margin-top: var(--space-2);"><strong>Compound Interest:</strong></div>
                        <div class="step">Year 1: 10% of 1000 = 100</div>
                        <div class="step">Year 2: 10% of 1100 = 110</div>
                        <div class="step">Total CI = 210</div>
                        
                        <div class="result">Difference = CI - SI = 10</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Remember:</strong> For 2 years, CI - SI = PR²/10000
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const p = (Math.floor(Math.random() * 5) + 5) * 1000;
                const r = [10, 20][Math.floor(Math.random() * 2)];
                const t = 2;
                const si = (p * r * t) / 100;

                return {
                    text: `P=₹${p}, R=${r}%, T=${t}yr. SI?`,
                    answer: si
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'si-find-rate': {
            id: 'si-find-rate',
            category: 'Commercial Math',
            tags: ['simple-interest', 'reverse'],
            title: 'Find Rate of Interest Formula (Simple Interest)',
            ctrHeadline: 'Calculate Interest Rate in Seconds! ⚡',
            description: 'Learn to find Rate (R%) when Principal, Time and Interest are given. Master reverse SI calculations for competitive exams (SSC, Banking).',
            difficulty: 'Intermediate',
            formula: 'R = (SI × 100) / (P × T)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Rearrange the SI formula to find <strong>Rate</strong>!</p>

                    <div class="example-box">
                        <div class="problem">SI = ₹600, P = ₹3000, T = 4 years. Find R.</div>
                        <div class="step">Step 1: R = (SI × 100) / (P × T)</div>
                        <div class="step">Step 2: = (600 × 100) / (3000 × 4)</div>
                        <div class="step">Step 3: = 60000 / 12000 = <strong>5%</strong></div>
                        <div class="result">Rate: 5% per year</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const p = (Math.floor(Math.random() * 5) + 2) * 1000;
                const r = [5, 10][Math.floor(Math.random() * 2)];
                const t = Math.floor(Math.random() * 3) + 2;
                const si = (p * r * t) / 100;

                return {
                    text: `SI=₹${si}, P=₹${p}, T=${t}yr. Rate%?`,
                    answer: r
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        }
    });
})();
