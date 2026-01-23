/**
 * Quick Math Topics - Probability, Height & Distance, Race
 */

(function registerAdvancedTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        // ===== PROBABILITY =====
        'probability-basics': {
            id: 'probability-basics',
            category: 'Advanced Topics',
            tags: ['probability', 'chance'],
            title: 'Probability Formulas | Favorable/Total',
            ctrHeadline: 'Calculate Any Probability in Seconds! 🎲',
            description: 'Master probability basics for competitive exams. Understand P(E) = Favorable/Total formula - essential logic for SSC, Banking, Railway questions.',
            difficulty: 'Intermediate',
            formula: 'P(E) = Favorable outcomes / Total outcomes',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Probability = <strong>How likely?</strong> Always ≤ 1</p>

                    <div class="example-box">
                        <div class="problem">Probability of getting a 6 on a die?</div>
                        <div class="step">Step 1: Favorable outcomes = 1 (only one 6)</div>
                        <div class="step">Step 2: Total outcomes = 6 (faces 1-6)</div>
                        <div class="step">Step 3: P(6) = 1/6 ≈ <strong>0.167</strong></div>
                        <div class="result">P = 1/6</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Key rules</div>
                        <div class="step">P(certain) = 1</div>
                        <div class="step">P(impossible) = 0</div>
                        <div class="step">P(A) + P(not A) = 1</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const scenarios = [
                    { text: 'Heads on a coin flip', fav: 1, total: 2 },
                    { text: 'Even number on die', fav: 3, total: 6 },
                    { text: 'Red card from deck', fav: 26, total: 52 }
                ];
                const s = scenarios[Math.floor(Math.random() * scenarios.length)];
                const prob = s.fav / s.total;

                return {
                    text: `P(${s.text})? (as fraction x/y)`,
                    answer: `${s.fav}/${s.total}`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        },
        'probability-cards': {
            id: 'probability-cards',
            category: 'Advanced Topics',
            tags: ['probability', 'cards'],
            title: 'Playing Cards Probability | 52 Card Deck',
            ctrHeadline: 'Solve Card Probability Questions Fast! ♠️',
            description: 'Master card probability problems (Kings, Hearts, Face cards) for competitive exams. Memorize the 52-card deck composition - SSC, Banking trick.',
            difficulty: 'Intermediate',
            formula: 'Deck: 52 cards, 4 suits, 13 ranks each',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Standard deck: <strong>52 cards</strong> = 4 suits × 13 ranks</p>

                    <div class="example-box">
                        <div class="problem">Key facts to memorize</div>
                        <div class="step">Total cards: 52</div>
                        <div class="step">Suits: Hearts, Diamonds (red), Clubs, Spades (black)</div>
                        <div class="step">Ranks: A, 2-10, J, Q, K (13 each)</div>
                        <div class="step">Face cards: J, Q, K (12 total)</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">P(drawing a King)?</div>
                        <div class="step">Favorable = 4 Kings</div>
                        <div class="step">Total = 52 cards</div>
                        <div class="step">P = 4/52 = <strong>1/13</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const questions = [
                    { text: 'King', fav: 4 },
                    { text: 'Heart', fav: 13 },
                    { text: 'Red card', fav: 26 },
                    { text: 'Face card (J,Q,K)', fav: 12 }
                ];
                const q = questions[Math.floor(Math.random() * questions.length)];

                return {
                    text: `P(${q.text}) from 52-card deck? (as fraction)`,
                    answer: `${q.fav}/52`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        },

        // ===== HEIGHT & DISTANCE =====
        'height-angle-elevation': {
            id: 'height-angle-elevation',
            category: 'Advanced Topics',
            tags: ['trigonometry', 'height', 'geometry'],
            title: 'Height & Distance Trick | Angle of Elevation',
            ctrHeadline: 'Find Height Without Measuring! tan(θ) Trick 📐',
            description: 'Master height and distance trigonometry problems for competitive exams. Use tan(theta) formula to find tower heights - essential for SSC CGL.',
            difficulty: 'Advanced',
            formula: 'tan(θ) = Height/Distance',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Angle of elevation</strong> = Looking UP from horizontal</p>

                    <div class="example-box">
                        <div class="problem">Tower height: 30° elevation from 50m away. Height?</div>
                        <div class="step">Step 1: tan(30°) = Height / Distance</div>
                        <div class="step">Step 2: Height = Distance × tan(30°)</div>
                        <div class="step">Step 3: tan(30°) = 1/√3 ≈ 0.577</div>
                        <div class="step">Step 4: Height = 50 × (1/√3) ≈ <strong>28.9m</strong></div>
                        <div class="result">Height: ~29m</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Standard angles (memorize!)</div>
                        <div class="step">tan(30°) = 1/√3, tan(45°) = 1, tan(60°) = √3</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const angles = [
                    { deg: 30, tan: 1 / Math.sqrt(3) },
                    { deg: 45, tan: 1 },
                    { deg: 60, tan: Math.sqrt(3) }
                ];
                const a = angles[Math.floor(Math.random() * angles.length)];
                const dist = [50, 100][Math.floor(Math.random() * 2)];
                const height = Math.round(dist * a.tan);

                return {
                    text: `${a.deg}° elevation from ${dist}m. Height (nearest m)?`,
                    answer: height
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseInt(userAns) - correctAns) <= 2
        },

        // ===== RACE & GAMES =====
        'race-head-start': {
            id: 'race-head-start',
            category: 'Word Problems',
            tags: ['race', 'speed', 'distance'],
            title: 'Race Problems | Head Start Calculations',
            ctrHeadline: 'Who Wins the Race? Head Start Logic! 🏃',
            description: 'Master linear race problems with head starts for competitive exams. Calculate relative speed and winning time - essential for SSC, Banking.',
            difficulty: 'Intermediate',
            formula: 'Relative speed determines winner',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Head start</strong> = One runner begins ahead on the track</p>

                    <div class="example-box">
                        <div class="problem">100m race: A runs 10m/s, B runs 8m/s. A gives B 10m start. Who wins?</div>
                        <div class="step">Step 1: A needs to cover 100m</div>
                        <div class="step">Step 2: B needs to cover 90m (10m head start)</div>
                        <div class="step">Step 3: A's time = 100/10 = <strong>10 sec</strong></div>
                        <div class="step">Step 4: B's time = 90/8 = <strong>11.25 sec</strong></div>
                        <div class="result">A wins!</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const speedA = 10;
                const speedB = 8;
                const distance = 100;
                const headStart = 10;

                const timeA = distance / speedA;
                const timeB = (distance - headStart) / speedB;

                const winner = timeA < timeB ? 'A' : 'B';

                return {
                    text: `100m race: A=10m/s, B=8m/s, B gets 10m start. Winner?`,
                    answer: winner
                };
            },
            checkAnswer: (userAns, correctAns) => {
                return userAns.trim().toUpperCase() === correctAns.trim().toUpperCase();
            }
        },
        'race-distance-game': {
            id: 'race-distance-game',
            category: 'Word Problems',
            tags: ['race', 'speed'],
            title: 'Race Games | "Beat by Distance" Trick',
            ctrHeadline: 'A Beats B by 10m? Find Speeds Instantly! 🏁',
            description: 'Master "beat by distance" race problems for competitive exams. Understand that Distance Ratio = Speed Ratio (same time) - key SSC concept.',
            difficulty: 'Advanced',
            formula: 'Speed ratio = Distance ratio',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">A beats B by 10m means: When A finishes 100m, B is at 90m</p>

                    <div class="example-box">
                        <div class="problem">100m race: A beats B by 10m. Find speed ratio.</div>
                        <div class="step">Step 1: When A covers 100m, B covers 90m</div>
                        <div class="step">Step 2: Same time, so Speed ∝ Distance</div>
                        <div class="step">Step 3: Speed ratio A:B = 100:90 = <strong>10:9</strong></div>
                        <div class="result">Ratio: 10:9</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const race = 100;
                const beats = [10, 20][Math.floor(Math.random() * 2)];
                const bDistance = race - beats;
                const ratio = `${race}:${bDistance}`;

                return {
                    text: `${race}m race: A beats B by ${beats}m. Speed ratio A:B?`,
                    answer: ratio
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        }
    });
})();
