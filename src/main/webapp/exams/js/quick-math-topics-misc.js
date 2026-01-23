/**
 * Quick Math Topics - Clocks, Calendar, and Ratio
 */

(function registerMiscTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        // ===== CLOCKS =====
        'clocks-angle': {
            id: 'clocks-angle',
            category: 'Logical Reasoning',
            tags: ['clocks', 'angles', 'time'],
            title: 'Angle Between Clock Hands',
            ctrHeadline: 'Angle = |11m - 60h| / 2',
            description: 'Calculate the angle between hour and minute hands at any time.',
            difficulty: 'Intermediate',
            formula: 'Angle = |11m - 60h| / 2 (in degrees)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">The <strong>magic formula</strong> for clock angles!</p>

                    <div class="example-box">
                        <div class="problem">Find angle at 3:30</div>
                        <div class="step">Step 1: h = 3, m = 30</div>
                        <div class="step">Step 2: Angle = |11m - 60h| / 2</div>
                        <div class="step">Step 3: = |11(30) - 60(3)| / 2</div>
                        <div class="step">Step 4: = |330 - 180| / 2 = 150 / 2</div>
                        <div class="result">Angle: 75°</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Key facts</div>
                        <div class="step">Minute hand: 6°/min (360°/60min)</div>
                        <div class="step">Hour hand: 0.5°/min (30°/60min)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const h = Math.floor(Math.random() * 12);
                const m = [0, 15, 30, 45][Math.floor(Math.random() * 4)];
                const angle = Math.abs(11 * m - 60 * h) / 2;
                const finalAngle = angle > 180 ? 360 - angle : angle;

                return {
                    text: `Angle between hands at ${h}:${m.toString().padStart(2, '0')}?`,
                    answer: finalAngle
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 1
        },

        // ===== CALENDAR =====
        'calendar-odd-days': {
            id: 'calendar-odd-days',
            category: 'Logical Reasoning',
            tags: ['calendar', 'days', 'dates'],
            title: 'Odd Days Method | Find Day of Week',
            ctrHeadline: 'Count odd days after dividing by 7!',
            description: 'Find the day of the week using odd days technique.',
            difficulty: 'Advanced',
            formula: 'Ordinary year = 1 odd day, Leap year = 2 odd days',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Odd days</strong> = Days remaining after dividing by 7!</p>

                    <div class="example-box">
                        <div class="problem">Key Rules</div>
                        <div class="step">365 days = 52 weeks + 1 day → <strong>1 odd day</strong> (ordinary year)</div>
                        <div class="step">366 days = 52 weeks + 2 days → <strong>2 odd days</strong> (leap year)</div>
                        <div class="step">Century: 100 years = 76 ordinary + 24 leap = <strong>5 odd days</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Day code: 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">If today is Monday, what day after 10 days?</div>
                        <div class="step">10 days = 1 week + 3 days</div>
                        <div class="step">3 odd days after Monday = <strong>Thursday</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                const today = Math.floor(Math.random() * 7);
                const after = Math.floor(Math.random() * 20) + 5;
                const futureDay = (today + after) % 7;

                return {
                    text: `Today is ${days[today]}. Day after ${after} days?`,
                    answer: days[futureDay]
                };
            },
            checkAnswer: (userAns, correctAns) => {
                return userAns.trim().toLowerCase() === correctAns.trim().toLowerCase();
            }
        },

        // ===== RATIO & PROPORTION =====
        'ratio-basics': {
            id: 'ratio-basics',
            category: 'Commercial Math',
            tags: ['ratio', 'proportion'],
            title: 'Ratio Basics | a:b = a/b',
            ctrHeadline: 'Ratio is just a fraction!',
            description: 'Understand ratios as fractions and proportions.',
            difficulty: 'Beginner',
            formula: 'a:b = a/b',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Ratio <strong>a:b</strong> means "a parts to b parts"</p>

                    <div class="example-box">
                        <div class="problem">Divide 100 in ratio 2:3</div>
                        <div class="step">Step 1: Total parts = 2 + 3 = <strong>5</strong></div>
                        <div class="step">Step 2: 1 part = 100/5 = <strong>20</strong></div>
                        <div class="step">Step 3: First share = 2 × 20 = <strong>40</strong></div>
                        <div class="step">Step 4: Second share = 3 × 20 = <strong>60</strong></div>
                        <div class="result">Shares: 40 and 60</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const r1 = Math.floor(Math.random() * 4) + 1;
                const r2 = Math.floor(Math.random() * 4) + 1;
                const total = (r1 + r2) * (Math.floor(Math.random() * 10) + 5);
                const first = (total / (r1 + r2)) * r1;

                return {
                    text: `Divide ${total} in ratio ${r1}:${r2}. First share?`,
                    answer: first
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        'ratio-proportion': {
            id: 'ratio-proportion',
            category: 'Commercial Math',
            tags: ['ratio', 'proportion'],
            title: 'Direct & Inverse Proportion',
            ctrHeadline: 'More workers → Less time (inverse!)',
            description: 'Distinguish between direct and inverse proportions.',
            difficulty: 'Intermediate',
            formula: 'Direct: y ∝ x, Inverse: y ∝ 1/x',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro"><strong>Direct:</strong> Both increase/decrease together. <strong>Inverse:</strong> One up, other down!</p>

                    <div class="example-box">
                        <div class="problem">Direct Proportion: More items → More cost</div>
                        <div class="step">5 books cost ₹100, 10 books cost?</div>
                        <div class="step">Double books → Double cost = <strong>₹200</strong></div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Inverse Proportion: More speed → Less time</div>
                        <div class="step">60 km/h takes 2 hours, 120 km/h takes?</div>
                        <div class="step">Double speed → Half time = <strong>1 hour</strong></div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const speed1 = 60;
                const time1 = 2;
                const speed2 = speed1 * 2;
                const time2 = time1 / 2;

                return {
                    text: `${speed1} km/h takes ${time1}hr. ${speed2} km/h takes (hours)?`,
                    answer: time2
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },

        'ratio-componendo-dividendo': {
            id: 'ratio-componendo-dividendo',
            category: 'Commercial Math',
            tags: ['ratio', 'algebra', 'advanced'],
            title: 'Componendo-Dividendo | Ratio Trick',
            ctrHeadline: 'a/b = c/d → (a+b)/(a-b) = (c+d)/(c-d)',
            description: 'Advanced ratio manipulation technique.',
            difficulty: 'Advanced',
            formula: 'If a/b = c/d, then (a+b)/(a-b) = (c+d)/(c-d)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">A powerful <strong>algebraic shortcut</strong> for ratio problems!</p>

                    <div class="example-box">
                        <div class="problem">If x/y = 3/2, find (x+y)/(x-y)</div>
                        <div class="step">Step 1: Apply componendo-dividendo</div>
                        <div class="step">Step 2: (x+y)/(x-y) = (3+2)/(3-2)</div>
                        <div class="step">Step 3: = 5/1 = <strong>5</strong></div>
                        <div class="result">Answer: 5</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Saves time!</strong> No need to substitute and solve!
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = Math.floor(Math.random() * 5) + 2;
                const b = Math.floor(Math.random() * 4) + 1;
                const result = (a + b) / (a - b);

                return {
                    text: `If x/y = ${a}/${b}, find (x+y)/(x-y)`,
                    answer: Math.round(result * 100) / 100
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 0.1
        }
    });
})();
