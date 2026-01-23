/**
 * Quick Math Topics - Number Patterns & Decimal/Fraction Shortcuts
 */

(function registerFinalMathTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        // ===== NUMBER PATTERNS =====
        'number-units-digit': {
            id: 'number-units-digit',
            category: 'Number Theory',
            tags: ['number-system', 'pattern', 'cyclicity'],
            title: 'Find Last Digit of 7^99 INSTANTLY! | Cyclicity Trick',
            ctrHeadline: 'Crack Any "Last Digit" Question in Seconds! 🎯',
            description: 'Discover the cyclicity pattern method to find units digit of large powers for competitive exams. Essential trick for SSC CGL, Banking PO, Railway number theory questions.',
            difficulty: 'Intermediate',
            formula: 'Each digit has a cycle pattern',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Powers of digits <strong>repeat in cycles</strong>! Memorize the patterns.</p>

                    <div class="example-box">
                        <div class="problem">Cyclicity patterns (memorize!)</div>
                        <div class="step"><strong>0, 1, 5, 6:</strong> Always same (cycle length 1)</div>
                        <div class="step"><strong>2:</strong> 2, 4, 8, 6 (cycle: 4)</div>
                        <div class="step"><strong>3:</strong> 3, 9, 7, 1 (cycle: 4)</div>
                        <div class="step"><strong>4:</strong> 4, 6 (cycle: 2)</div>
                        <div class="step"><strong>7:</strong> 7, 9, 3, 1 (cycle: 4)</div>
                        <div class="step"><strong>8:</strong> 8, 4, 2, 6 (cycle: 4)</div>
                        <div class="step"><strong>9:</strong> 9, 1 (cycle: 2)</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Find units digit of 7³⁴</div>
                        <div class="step">Step 1: Cycle of 7 is: 7, 9, 3, 1 (length 4)</div>
                        <div class="step">Step 2: Divide power by cycle: 34 ÷ 4 = 8 remainder <strong>2</strong></div>
                        <div class="step">Step 3: Position 2 in cycle → <strong>9</strong></div>
                        <div class="result">Units digit: 9</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Trick:</strong> If remainder = 0, use last in cycle!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const patterns = {
                    2: [2, 4, 8, 6],
                    3: [3, 9, 7, 1],
                    7: [7, 9, 3, 1],
                    8: [8, 4, 2, 6]
                };
                const bases = [2, 3, 7, 8];
                const base = bases[Math.floor(Math.random() * bases.length)];
                const power = Math.floor(Math.random() * 20) + 10; // 10-29
                const cycle = patterns[base];
                const remainder = power % cycle.length;
                const position = remainder === 0 ? cycle.length - 1 : remainder - 1;
                const units = cycle[position];

                return {
                    text: `Units digit of ${base}^${power}?`,
                    answer: units
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'number-odd-even': {
            id: 'number-odd-even',
            category: 'Number Theory',
            tags: ['number-system', 'odd', 'even'],
            title: 'Odd & Even Number Rules | Mental Math Shortcut',
            ctrHeadline: 'Never Get Odd/Even Questions Wrong Again! ✅',
            description: 'Learn the complete odd and even number rules for addition, multiplication, subtraction for competitive exams. Essential basics for SSC, Banking, Railway math.',
            difficulty: 'Beginner',
            formula: 'Learn the combination rules',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Simple rules help solve problems <strong>instantly</strong>!</p>

                    <div class="example-box">
                        <div class="problem">Addition Rules</div>
                        <div class="step">Odd + Odd = <strong>Even</strong></div>
                        <div class="step">Even + Even = <strong>Even</strong></div>
                        <div class="step">Odd + Even = <strong>Odd</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Multiplication Rules</div>
                        <div class="step">Odd × Odd = <strong>Odd</strong></div>
                        <div class="step">Even × Even = <strong>Even</strong></div>
                        <div class="step">Odd × Even = <strong>Even</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Is 137 + 246 + 359 odd or even?</div>
                        <div class="step">Odd + Even + Odd = Odd + Odd = <strong>Even</strong></div>
                        <div class="step">No calculation needed!</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const operations = [
                    { text: 'Odd + Odd', answer: 'Even' },
                    { text: 'Even + Even', answer: 'Even' },
                    { text: 'Odd + Even', answer: 'Odd' },
                    { text: 'Odd × Odd', answer: 'Odd' },
                    { text: 'Even × Odd', answer: 'Even' }
                ];
                const op = operations[Math.floor(Math.random() * operations.length)];

                return {
                    text: `${op.text} = ?`,
                    answer: op.answer
                };
            },
            checkAnswer: (userAns, correctAns) => {
                return userAns.trim().toLowerCase() === correctAns.trim().toLowerCase();
            }
        },
        'number-sum-of-digits': {
            id: 'number-sum-of-digits',
            category: 'Number Theory',
            tags: ['number-system', 'divisibility'],
            title: 'Divisibility by 3 & 9 in SECONDS! | Digit Sum Trick',
            ctrHeadline: 'This Digit Trick Solves Divisibility in Your Head! 🧠',
            description: 'Master the sum-of-digits method to check divisibility by 3 and 9 instantly for competitive exams. Fast technique for SSC, Banking, Railway number system questions.',
            difficulty: 'Beginner',
            formula: 'Sum of digits determines div by 3, 9',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Sum of digits</strong> reveals divisibility!</p>

                    <div class="example-box">
                        <div class="problem">Is 12345 divisible by 9?</div>
                        <div class="step">Sum of digits = 1+2+3+4+5 = <strong>15</strong></div>
                        <div class="step">15 ÷ 9 = Not divisible</div>
                        <div class="step">But 15 ÷ 3 = Yes! So 12345 divisible by 3</div>
                        <div class="result">Div by 3: Yes, Div by 9: No</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Rules</div>
                        <div class="step">Sum divisible by 9 → Number divisible by 9</div>
                        <div class="step">Sum divisible by 3 → Number divisible by 3</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const numbers = [
                    { num: 12345, sum: 15, div9: false, div3: true },
                    { num: 54321, sum: 15, div9: false, div3: true },
                    { num: 99999, sum: 45, div9: true, div3: true }
                ];
                const n = numbers[Math.floor(Math.random() * numbers.length)];

                return {
                    text: `Sum of digits of ${n.num}?`,
                    answer: n.sum
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },

        // ===== DECIMAL/FRACTION =====
        'decimal-recurring': {
            id: 'decimal-recurring',
            category: 'Number Theory',
            tags: ['decimal', 'fraction', 'conversion'],
            title: 'Convert Recurring Decimals INSTANTLY! | Quick Trick',
            ctrHeadline: '0.333... = ? Solve It in 2 Seconds! 🔢',
            description: 'Master the technique to convert recurring decimals to fractions instantly for competitive exams. Essential shortcut for SSC, Banking, Railway quantitative aptitude questions.',
            difficulty: 'Intermediate',
            formula: 'Memorize patterns',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Memorize</strong> these common recurring decimals!</p>

                    <div class="example-box">
                        <div class="problem">Common recurring decimals (essential!)</div>
                        <div class="step">0.333... = <strong>1/3</strong></div>
                        <div class="step">0.666... = <strong>2/3</strong></div>
                        <div class="step">0.111... = <strong>1/9</strong></div>
                        <div class="step">0.142857... = <strong>1/7</strong></div>
                        <div class="step">0.090909... = <strong>1/11</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Multiples of 1/9</div>
                        <div class="step">1/9 = 0.111..., 2/9 = 0.222..., 3/9 = 0.333...</div>
                        <div class="step">4/9 = 0.444..., 5/9 = 0.555..., etc.</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">What is 0.666... as a fraction?</div>
                        <div class="step">Answer: <strong>2/3</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const decimals = [
                    { dec: '0.333...', frac: '1/3' },
                    { dec: '0.666...', frac: '2/3' },
                    { dec: '0.111...', frac: '1/9' },
                    { dec: '0.222...', frac: '2/9' }
                ];
                const d = decimals[Math.floor(Math.random() * decimals.length)];

                return {
                    text: `${d.dec} as fraction?`,
                    answer: d.frac
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        },
        'fraction-to-decimal': {
            id: 'fraction-to-decimal',
            category: 'Number Theory',
            tags: ['decimal', 'fraction', 'conversion'],
            title: 'Convert Fractions to Decimals INSTANTLY! | Quick Trick',
            ctrHeadline: 'Memorize Common Conversions for Lightning Speed! ⚡',
            description: 'Master fraction to decimal conversions for competitive exams. Memorize 1/8 = 0.125, 1/5 = 0.2 shortcuts - essential speed math for SSC, Banking, Railway.',
            difficulty: 'Beginner',
            formula: 'Memorize patterns',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Memorize</strong> for instant conversions!</p>

                    <div class="example-box">
                        <div class="problem">Halves, Quarters, Fifths</div>
                        <div class="step">1/2 = <strong>0.5</strong></div>
                        <div class="step">1/4 = <strong>0.25</strong>, 3/4 = <strong>0.75</strong></div>
                        <div class="step">1/5 = <strong>0.2</strong>, 2/5 = <strong>0.4</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Eighths</div>
                        <div class="step">1/8 = <strong>0.125</strong></div>
                        <div class="step">3/8 = <strong>0.375</strong></div>
                        <div class="step">5/8 = <strong>0.625</strong></div>
                        <div class="step">7/8 = <strong>0.875</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Thirds</div>
                        <div class="step">1/3 ≈ <strong>0.333</strong></div>
                        <div class="step">2/3 ≈ <strong>0.667</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const fractions = [
                    { frac: '1/2', dec: 0.5 },
                    { frac: '1/4', dec: 0.25 },
                    { frac: '3/4', dec: 0.75 },
                    { frac: '1/5', dec: 0.2 },
                    { frac: '1/8', dec: 0.125 }
                ];
                const f = fractions[Math.floor(Math.random() * fractions.length)];

                return {
                    text: `${f.frac} as decimal?`,
                    answer: f.dec
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'percentage-fraction-decimal': {
            id: 'percentage-fraction-decimal',
            category: 'Commercial Math',
            tags: ['percentage', 'fraction', 'decimal'],
            title: 'Connect Percentages, Fractions & Decimals | Master Conversion',
            ctrHeadline: 'Switch Between %, Fractions & Decimals Instantly! 🔄',
            description: 'Learn to convert between percentage, fraction, and decimal forms for competitive exams. Master the relationships (50%=0.5=1/2) for SSC, Banking, Railway math.',
            difficulty: 'Beginner',
            formula: 'Memorize common conversions',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Same value, <strong>three forms</strong>! Master the conversions.</p>

                    <div class="example-box">
                        <div class="problem">Common conversions (memorize!)</div>
                        <div class="step">50% = 1/2 = <strong>0.5</strong></div>
                        <div class="step">25% = 1/4 = <strong>0.25</strong></div>
                        <div class="step">20% = 1/5 = <strong>0.2</strong></div>
                        <div class="step">10% = 1/10 = <strong>0.1</strong></div>
                        <div class="step">75% = 3/4 = <strong>0.75</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Conversions</div>
                        <div class="step">Decimal → %: Multiply by 100</div>
                        <div class="step">% → Decimal: Divide by 100</div>
                        <div class="step">Fraction → %: (Numerator/Denominator) × 100</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">What is 3/4 as percentage?</div>
                        <div class="step">(3/4) × 100 = 0.75 × 100 = <strong>75%</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const conversions = [
                    { text: '50% as decimal', answer: 0.5 },
                    { text: '25% as decimal', answer: 0.25 },
                    { text: '1/4 as %', answer: 25 },
                    { text: '1/2 as %', answer: 50 }
                ];
                const c = conversions[Math.floor(Math.random() * conversions.length)];

                return {
                    text: c.text,
                    answer: c.answer
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        }
    });
})();
