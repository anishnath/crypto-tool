/**
 * Quick Math Topics - Boats & Streams, Partnership
 */

(function registerFinalTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        // ===== BOATS & STREAMS =====
        'boats-upstream-downstream': {
            id: 'boats-upstream-downstream',
            category: 'Word Problems',
            tags: ['boats', 'streams', 'speed'],
            title: 'Boats & Streams Formula | Upstream/Downstream',
            ctrHeadline: 'Solve Boat & Stream Problems in 30 Seconds! 🚤',
            description: 'Master upstream and downstream speed calculation for competitive exams. Find boat speed and stream speed instantly - essential for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'Down = b+s, Up = b-s',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>With current = faster</strong>, Against current = slower!</p>

                    <div class="example-box">
                        <div class="problem">Key formulas (b = boat, s = stream)</div>
                        <div class="step">Downstream speed = b + s</div>
                        <div class="step">Upstream speed = b - s</div>
                        <div class="step">Boat speed = (Down + Up) / 2</div>
                        <div class="step">Stream speed = (Down - Up) / 2</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Downstream 20 km/h, Upstream 12 km/h. Find boat & stream speed.</div>
                        <div class="step">Boat = (20 + 12) / 2 = <strong>16 km/h</strong></div>
                        <div class="step">Stream = (20 - 12) / 2 = <strong>4 km/h</strong></div>
                        <div class="result">Boat: 16, Stream: 4</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Shortcut:</strong> Average gives boat speed, difference gives stream!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const boat = (Math.floor(Math.random() * 5) + 10) * 2; // 20-28 even
                const stream = Math.floor(Math.random() * 3) + 2; // 2-4
                const down = boat + stream;
                const up = boat - stream;

                return {
                    text: `Down=${down} km/h, Up=${up} km/h. Boat speed?`,
                    answer: boat
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'boats-time-distance': {
            id: 'boats-time-distance',
            category: 'Word Problems',
            tags: ['boats', 'time', 'distance'],
            title: 'Boat Time & Distance Problems | Effective Speed',
            ctrHeadline: 'Calculate Boat Journey Time FAST! ⏱️',
            description: 'Master time and distance calculation for boats moving upstream/downstream. Use effective speed trick for competitive exams (SSC, Banking, Railway).',
            difficulty: 'Intermediate',
            formula: 'Time = Distance / (Boat ± Stream)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Use the <strong>effective speed</strong> (boat ± stream) for time calculation!</p>

                    <div class="example-box">
                        <div class="problem">Boat: 15 km/h, Stream: 3 km/h, Distance: 36 km. Time downstream?</div>
                        <div class="step">Downstream speed = 15 + 3 = <strong>18 km/h</strong></div>
                        <div class="step">Time = 36 / 18 = <strong>2 hours</strong></div>
                        <div class="result">Time: 2 hours</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Same journey upstream?</div>
                        <div class="step">Upstream speed = 15 - 3 = <strong>12 km/h</strong></div>
                        <div class="step">Time = 36 / 12 = <strong>3 hours</strong></div>
                        <div class="result">Time: 3 hours (longer!)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const boat = 15;
                const stream = 3;
                const distance = 36;
                const down = boat + stream;
                const time = distance / down;

                return {
                    text: `Boat=${boat}, Stream=${stream}, Distance=${distance}km. Time downstream (hr)?`,
                    answer: time
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        // ===== PARTNERSHIP =====
        'partnership-simple': {
            id: 'partnership-simple',
            category: 'Commercial Math',
            tags: ['partnership', 'profit', 'ratio'],
            title: 'Simple Partnership Problems | Profit Sharing',
            ctrHeadline: 'Split Profits Instantly by Investment Ratio! 💰',
            description: 'Master simple partnership profit distribution for competitive exams. Split profit based on investment ratio - essential shortcut for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'Profit ratio = Investment ratio (if same time)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Same time?</strong> Profit splits exactly as investment ratio!</p>

                    <div class="example-box">
                        <div class="problem">A invests ₹4000, B invests ₹6000. Profit ₹5000. How to split?</div>
                        <div class="step">Step 1: Investment ratio = 4000:6000 = <strong>2:3</strong></div>
                        <div class="step">Step 2: Total parts = 2 + 3 = 5</div>
                        <div class="step">Step 3: A's share = (2/5) × 5000 = <strong>₹2000</strong></div>
                        <div class="step">Step 4: B's share = (3/5) × 5000 = <strong>₹3000</strong></div>
                        <div class="result">A: ₹2000, B: ₹3000</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = (Math.floor(Math.random() * 5) + 2) * 1000;
                const b = (Math.floor(Math.random() * 5) + 2) * 1000;
                const profit = (Math.floor(Math.random() * 5) + 3) * 1000;
                const aShare = (a / (a + b)) * profit;

                return {
                    text: `A=₹${a}, B=₹${b}, Profit=₹${profit}. A's share?`,
                    answer: aShare
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'partnership-compound': {
            id: 'partnership-compound',
            category: 'Commercial Math',
            tags: ['partnership', 'profit', 'time'],
            title: 'Compound Partnership Problems | Time Factor',
            ctrHeadline: 'Solve Complex Partnership Questions Easily! 🤝',
            description: 'Master compound partnership problems where time periods differ. Learn the (Investment × Time) ratio trick for competitive exams - SSC, Banking, Railway.',
            difficulty: 'Advanced',
            formula: 'Profit ratio = (Investment₁ × Time₁) : (Investment₂ × Time₂)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Different time?</strong> Multiply investment by months!</p>

                    <div class="example-box">
                        <div class="problem">A invests ₹3000 for 8 months, B invests ₹5000 for 6 months. Profit ₹4400. Split?</div>
                        <div class="step">Step 1: A's capital × time = 3000 × 8 = <strong>24000</strong></div>
                        <div class="step">Step 2: B's capital × time = 5000 × 6 = <strong>30000</strong></div>
                        <div class="step">Step 3: Ratio = 24000:30000 = <strong>4:5</strong></div>
                        <div class="step">Step 4: A's share = (4/9) × 4400 = <strong>₹1955</strong></div>
                        <div class="result">A: ₹1955, B: ₹2444</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Key:</strong> Time matters! More time = more profit share
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = 3000;
                const aTime = 8;
                const b = 5000;
                const bTime = 6;
                const profit = 4400;
                const aCap = a * aTime;
                const bCap = b * bTime;
                const aShare = (aCap / (aCap + bCap)) * profit;

                return {
                    text: `A=₹3000×8mo, B=₹5000×6mo, Profit=₹4400. A's share?`,
                    answer: Math.round(aShare)
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseInt(userAns) - correctAns) <= 10
        }
    });
})();
