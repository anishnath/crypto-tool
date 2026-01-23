/**
 * Quick Math Topics - Profit, Loss & Discount
 */

(function registerProfitTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'profit-loss-percentage': {
            id: 'profit-loss-percentage',
            category: 'Commercial Math',
            tags: ['profit', 'loss', 'percentage', 'money'],
            title: 'Profit & Loss Percentage | Base Method',
            ctrHeadline: 'Calculate Profit% Instantly! (Always on CP) 💰',
            description: 'Master profit/loss percentage calculations for competitive exams. Remember CP is always the base - key concept for SSC, Banking, Railway quantitative aptitude.',
            difficulty: 'Intermediate',
            formula: 'Profit% = (SP - CP)/CP × 100',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Cost Price (CP)</strong> is always the base for percentage!</p>

                    <!-- SVG Profit/Loss Diagram -->
                    <svg viewBox="0 0 400 140" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Cost Price -->
                            <rect x="80" y="60" width="80" height="40" fill="var(--accent-primary, #6366f1)" opacity="0.2" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                            <text x="120" y="50" font-size="12" fill="var(--text-secondary, #888)">Cost Price</text>
                            <text x="120" y="85" font-size="16" fill="var(--accent-primary, #6366f1)" font-weight="bold">₹500</text>
                            
                            <!-- Profit portion -->
                            <rect x="160" y="60" width="40" height="40" fill="var(--success, #22c55e)" opacity="0.3" stroke="var(--success, #22c55e)" stroke-width="2"/>
                            <text x="180" y="85" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">+100</text>
                            
                            <!-- Selling Price bracket -->
                            <line x1="80" y1="110" x2="200" y2="110" stroke="var(--warning, #f59e0b)" stroke-width="2"/>
                            <text x="140" y="125" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">SP = ₹600</text>
                            
                            <!-- Calculation -->
                            <text x="300" y="80" font-size="13" fill="var(--text-primary, #ddd)" text-anchor="start">Profit = 600 - 500 = 100</text>
                            <text x="300" y="100" font-size="13" fill="var(--success, #22c55e)" text-anchor="start" font-weight="bold">Profit% = 100/500 × 100 = 20%</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">CP = ₹800, SP = ₹1000. Find profit%</div>
                        <div class="step">Step 1: Profit = SP - CP = 1000 - 800 = <strong>₹200</strong></div>
                        <div class="step">Step 2: Profit% = (200/800) × 100</div>
                        <div class="step">Step 3: = (1/4) × 100 = <strong>25%</strong></div>
                        <div class="result">Profit: 25%</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Quick trick:</strong> SP = CP(100 + Profit%)/100 or CP(100 - Loss%)/100
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const cp = (Math.floor(Math.random() * 20) + 10) * 100; // 1000-3000
                const profitPercent = [10, 20, 25, 50][Math.floor(Math.random() * 4)];
                const profit = (cp * profitPercent) / 100;
                const sp = cp + profit;

                return {
                    text: `CP=₹${cp}, SP=₹${sp}. Profit%?`,
                    answer: profitPercent
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'profit-marked-price': {
            id: 'profit-marked-price',
            category: 'Commercial Math',
            tags: ['profit', 'discount', 'money'],
            title: 'Marked Price & Discount | Formula',
            ctrHeadline: 'Solve Discount Problems Quickly! (MP to SP) 🏷️',
            description: 'Master marked price and discount calculations for competitive exams. Find selling price after discount instantly - essential for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'SP = MP - Discount = MP(100 - d%)/100',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Marked Price</strong> → Apply discount → <strong>Selling Price</strong></p>

                    <div class="example-box">
                        <div class="problem">MP = ₹1200, Discount = 10%. Find SP.</div>
                        <div class="step">Step 1: Discount = 10% of 1200 = <strong>₹120</strong></div>
                        <div class="step">Step 2: SP = MP - Discount = 1200 - 120</div>
                        <div class="step">Step 3: = <strong>₹1080</strong></div>
                        <div class="result">SP: ₹1080</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Quick formula</div>
                        <div class="step">SP = MP × (100 - Discount%)/100</div>
                        <div class="step">= 1200 × 90/100 = 1200 × 0.9 = 1080</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const mp = (Math.floor(Math.random() * 10) + 10) * 100; // 1000-2000
                const discount = [10, 20, 25][Math.floor(Math.random() * 3)];
                const sp = mp * (100 - discount) / 100;

                return {
                    text: `MP=₹${mp}, Discount=${discount}%. SP?`,
                    answer: sp
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'profit-successive-discount': {
            id: 'profit-successive-discount',
            category: 'Commercial Math',
            tags: ['profit', 'discount', 'advanced'],
            title: 'Successive Discounts Trick | Formula',
            ctrHeadline: '20% + 10% ≠ 30%! Learn the Real Trick! 📉',
            description: 'Master successive discount calculations for competitive exams. Use the ab/100 formula for quick answers - key shortcut for SSC CGL, Banking, Railway.',
            difficulty: 'Advanced',
            formula: 'Single equivalent = a + b - ab/100',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Two discounts <strong>compound</strong> like percentages!</p>

                    <div class="example-box">
                        <div class="problem">Discounts of 20% and 10% on ₹1000. Final price?</div>
                        <div class="step">Step 1: After 20% → 1000 × 80/100 = <strong>₹800</strong></div>
                        <div class="step">Step 2: Now 10% on 800 → 800 × 90/100 = <strong>₹720</strong></div>
                        <div class="step">Note: NOT 30% discount! (that would be ₹700)</div>
                        <div class="result">Final price: ₹720</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Single Equivalent Discount Formula</div>
                        <div class="step">For a% and b% successive discounts:</div>
                        <div class="step">Equivalent = a + b - (a×b)/100</div>
                        <div class="step">= 20 + 10 - 200/100 = 30 - 2 = <strong>28%</strong></div>
                        <div class="step">Verify: 1000 × 72/100 = 720 ✓</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Remember:</strong> Successive discounts are always LESS than sum!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const price = 1000;
                const d1 = [10, 20][Math.floor(Math.random() * 2)];
                const d2 = [10, 20][Math.floor(Math.random() * 2)];
                const equivalent = d1 + d2 - (d1 * d2) / 100;
                const finalPrice = price * (100 - equivalent) / 100;

                return {
                    text: `₹${price} with ${d1}% then ${d2}% discount. Final price?`,
                    answer: finalPrice
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'profit-cp-from-sp': {
            id: 'profit-cp-from-sp',
            category: 'Commercial Math',
            tags: ['profit', 'reverse'],
            title: 'Find Cost Price from Selling Price | Reverse',
            ctrHeadline: 'Given SP and Profit%? Find CP Instantly! 🔙',
            description: 'Master reverse profit calculations (finding CP from SP) for competitive exams. Essential arithmetic trick for SSC, Banking, Railway quantitative aptitude.',
            difficulty: 'Intermediate',
            formula: 'CP = SP × 100/(100 + Profit%)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Given SP and profit%, <strong>reverse</strong> the calculation!</p>

                    <div class="example-box">
                        <div class="problem">SP = ₹600, Profit = 20%. Find CP.</div>
                        <div class="step">Method 1: Use formula</div>
                        <div class="step">CP = SP × 100/(100 + Profit%)</div>
                        <div class="step">= 600 × 100/120 = 600 × 5/6</div>
                        <div class="step">= <strong>₹500</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Method 2: Logic</div>
                        <div class="step">If CP = 100, then SP = 120 (20% profit)</div>
                        <div class="step">When SP = 120, CP = 100</div>
                        <div class="step">When SP = 600, CP = 600 × 100/120 = 500</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const profitPercent = [20, 25, 50][Math.floor(Math.random() * 3)];
                const cp = (Math.floor(Math.random() * 10) + 5) * 100;
                const sp = cp * (100 + profitPercent) / 100;

                return {
                    text: `SP=₹${sp}, Profit=${profitPercent}%. CP?`,
                    answer: cp
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'profit-false-weight': {
            id: 'profit-false-weight',
            category: 'Commercial Math',
            tags: ['profit', 'trick', 'advanced'],
            title: 'Dishonest Seller (False Weight) Trick',
            ctrHeadline: 'Seller Cheating with Weight? Find Profit%! ⚖️',
            description: 'Master "Dishonest Seller" problems for competitive exams. Calculate profit percentage when false weights are used - advanced trick for SSC CGL, Banking.',
            difficulty: 'Advanced',
            formula: 'Profit% = (Error/True weight) × 100',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Seller <strong>cheats</strong> by using wrong weight. Calculate the profit!</p>

                    <div class="example-box">
                        <div class="problem">Seller uses 900g weight but claims to sell 1kg. Profit%?</div>
                        <div class="step">Step 1: Customer pays for 1000g but gets 900g</div>
                        <div class="step">Step 2: Extra profit = 100g on 900g base</div>
                        <div class="step">Step 3: Profit% = (100/900) × 100</div>
                        <div class="step">Step 4: = 100/9 ≈ <strong>11.11%</strong></div>
                        <div class="result">Profit: ~11.11%</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Quick formula</div>
                        <div class="step">Profit% = (True - False)/False × 100</div>
                        <div class="step">= (1000 - 900)/900 × 100 = 100/9%</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const trueWeight = 1000;
                const falseWeights = [800, 900, 950];
                const falseWeight = falseWeights[Math.floor(Math.random() * falseWeights.length)];
                const profitPercent = ((trueWeight - falseWeight) / falseWeight) * 100;

                return {
                    text: `Uses ${falseWeight}g, claims ${trueWeight}g. Profit%?`,
                    answer: Math.round(profitPercent * 100) / 100
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 0.5
        }
    });
})();
