/**
 * Quick Math Topics - Pipes & Cisterns (Streams)
 */

(function registerStreamTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'pipes-two-filling': {
            id: 'pipes-two-filling',
            category: 'Word Problems',
            tags: ['pipes', 'streams', 'time-work'],
            title: 'Two Pipes Filling Together | Work Formula',
            ctrHeadline: 'Solve Pipe Filing Problems in SECONDS! 🚰',
            description: 'Master the two pipes filling formula for competitive exams. Calculate combined filling time instantly - essential trick for SSC, Banking, Railway aptitude.',
            difficulty: 'Intermediate',
            formula: '1/T = 1/A + 1/B, so T = (A×B)/(A+B)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Two pipes filling? Add their <strong>rates</strong> (portions per hour)!</p>

                    <!-- SVG Two Pipes Visual -->
                    <svg viewBox="0 0 400 140" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <defs>
                            <linearGradient id="water-grad" x1="0%" y1="0%" x2="0%" y2="100%">
                                <stop offset="0%" style="stop-color:#06b6d4;stop-opacity:0.8" />
                                <stop offset="100%" style="stop-color:#0891b2;stop-opacity:1" />
                            </linearGradient>
                        </defs>
                        
                        <!-- Tank -->
                        <rect x="150" y="60" width="100" height="70" fill="none" stroke="var(--text-secondary, #666)" stroke-width="3"/>
                        <rect x="150" y="100" width="100" height="30" fill="url(#water-grad)"/>
                        
                        <!-- Pipe A -->
                        <line x1="50" y1="80" x2="150" y2="80" stroke="var(--accent-primary, #6366f1)" stroke-width="4"/>
                        <text x="100" y="70" font-size="12" fill="var(--accent-primary, #6366f1)" text-anchor="middle" font-weight="bold">Pipe A</text>
                        <text x="100" y="100" font-size="11" fill="var(--text-secondary, #888)" text-anchor="middle">6 hours</text>
                        
                        <!-- Pipe B -->
                        <line x1="50" y1="110" x2="150" y2="110" stroke="var(--success, #22c55e)" stroke-width="4"/>
                        <text x="100" y="125" font-size="12" fill="var(--success, #22c55e)" text-anchor="middle" font-weight="bold">Pipe B</text>
                        <text x="100" y="145" font-size="11" fill="var(--text-secondary, #888)" text-anchor="middle">12 hours</text>
                        
                        <!-- Flow arrows -->
                        <polygon points="145,80 150,77 150,83" fill="var(--accent-primary, #6366f1)"/>
                        <polygon points="145,110 150,107 150,113" fill="var(--success, #22c55e)"/>
                        
                        <!-- Result -->
                        <text x="300" y="95" font-size="14" fill="var(--warning, #f59e0b)" text-anchor="middle" font-weight="bold">Together?</text>
                        <text x="300" y="112" font-size="16" fill="var(--warning, #f59e0b)" text-anchor="middle" font-weight="bold">4 hours</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Pipe A fills in 6 hrs, Pipe B in 12 hrs. Together?</div>
                        <div class="step">Step 1: A's rate = 1/6 tank/hr, B's rate = 1/12 tank/hr</div>
                        <div class="step">Step 2: Combined rate = 1/6 + 1/12 = 3/12 = <strong>1/4 tank/hr</strong></div>
                        <div class="step">Step 3: Time = 1 ÷ (1/4) = <strong>4 hours</strong></div>
                        <div class="result">Answer: 4 hours</div>
                    </div>
                    
                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Shortcut:</strong> T = (A×B)/(A+B) → (6×12)/(6+12) = 72/18 = 4
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const a = (Math.floor(Math.random() * 4) + 2) * 3; // 6,9,12,15
                const b = a * 2; // Double of a
                const t = (a * b) / (a + b);
                return {
                    text: `Pipe A fills tank in ${a} hrs, B in ${b} hrs. Together (hours)?`,
                    answer: t
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'pipes-inlet-outlet': {
            id: 'pipes-inlet-outlet',
            category: 'Word Problems',
            tags: ['pipes', 'streams', 'advanced'],
            title: 'Inlet & Outlet Pipes | Net Rate Trick',
            ctrHeadline: 'Inlet Fills, Outlet Empties? Solve it FAST! ⚡',
            description: 'Learn to solve inlet-outlet pipe problems for competitive exams. Master the net rate subtraction method - crucial for SSC, Banking, Railway word problems.',
            difficulty: 'Advanced',
            formula: 'Net rate = 1/Fill - 1/Empty',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Inlet fills, outlet drains. <strong>Subtract</strong> the rates!</p>

                    <!-- SVG Inlet Outlet Visual -->
                    <svg viewBox="0 0 380 140" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <defs>
                            <linearGradient id="water-grad2" x1="0%" y1="0%" x2="0%" y2="100%">
                                <stop offset="0%" style="stop-color:#06b6d4;stop-opacity:0.8" />
                                <stop offset="100%" style="stop-color:#0891b2;stop-opacity:1" />
                            </linearGradient>
                        </defs>
                        
                        <!-- Tank -->
                        <rect x="140" y="50" width="100" height="80" fill="none" stroke="var(--text-secondary, #666)" stroke-width="3"/>
                        <rect x="140" y="90" width="100" height="40" fill="url(#water-grad2)"/>
                        
                        <!-- Inlet (top) -->
                        <line x1="50" y1="70" x2="140" y2="70" stroke="var(--success, #22c55e)" stroke-width="4"/>
                        <polygon points="135,70 140,67 140,73" fill="var(--success, #22c55e)"/>
                        <text x="95" y="60" font-size="12" fill="var(--success, #22c55e)" text-anchor="middle" font-weight="bold">Inlet</text>
                        <text x="95" y="85" font-size="11" fill="var(--text-secondary, #888)" text-anchor="middle">(fills: 6 hrs)</text>
                        
                        <!-- Outlet (bottom) -->
                        <line x1="240" y1="120" x2="320" y2="120" stroke="var(--danger, #ef4444)" stroke-width="4"/>
                        <polygon points="245,120 240,117 240,123" fill="var(--danger, #ef4444)"/>
                        <text x="280" y="110" font-size="12" fill="var(--danger, #ef4444)" text-anchor="middle" font-weight="bold">Outlet</text>
                        <text x="280" y="135" font-size="11" fill="var(--text-secondary, #888)" text-anchor="middle">(empties: 12 hrs)</text>
                        
                        <!-- Net effect -->
                        <text x="190" y="25" font-size="14" fill="var(--warning, #f59e0b)" text-anchor="middle" font-weight="bold">Net: Fill in 12 hrs</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Inlet fills in 6 hrs, outlet empties in 12 hrs. Both open, time to fill?</div>
                        <div class="step">Step 1: Inlet rate = +1/6, Outlet rate = -1/12</div>
                        <div class="step">Step 2: Net rate = 1/6 - 1/12 = 2/12 - 1/12 = <strong>1/12</strong></div>
                        <div class="step">Step 3: Time = 1 ÷ (1/12) = <strong>12 hours</strong></div>
                        <div class="result">Answer: 12 hours</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const fill = (Math.floor(Math.random() * 3) + 2) * 3; // 6,9,12
                const empty = fill * 2; // Double
                const net = (fill * empty) / (empty - fill);
                return {
                    text: `Inlet fills in ${fill} hrs, outlet empties in ${empty} hrs. Both open, fill time (hours)?`,
                    answer: net
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'pipes-leak': {
            id: 'pipes-leak',
            category: 'Word Problems',
            tags: ['pipes', 'streams'],
            title: 'Tank with Leak Problem | Time Calculation',
            ctrHeadline: 'Solve Leaking Tank Problems Instantly! 💧',
            description: 'Master leak problems in pipes and cisterns for competitive exams. Calculate time to fill with a leak - essential technique for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'With leak: Time = 1/(1/Fill - 1/Leak)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Leak = negative work. Subtract the leak rate from pipe rate!</p>

                    <div class="example-box">
                        <div class="problem">Pipe fills tank in 8 hrs. Leak empties in 24 hrs. Time to fill with leak?</div>
                        <div class="step">Step 1: Pipe rate = +1/8, Leak rate = -1/24</div>
                        <div class="step">Step 2: Net rate = 1/8 - 1/24 = 3/24 - 1/24 = <strong>2/24 = 1/12</strong></div>
                        <div class="step">Step 3: Time = 1 ÷ (1/12) = <strong>12 hours</strong></div>
                        <div class="result">Answer: 12 hours (slower due to leak)</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Remember:</strong> Without leak = 8 hrs, with leak = 12 hrs (takes longer!)
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const fill = (Math.floor(Math.random() * 3) + 2) * 4; // 8,12,16
                const leak = fill * 3; // Triple
                const net = (fill * leak) / (leak - fill);
                return {
                    text: `Pipe fills in ${fill} hrs. Leak empties in ${leak} hrs. Time to fill with leak (hours)?`,
                    answer: net
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'pipes-alternating': {
            id: 'pipes-alternating',
            category: 'Word Problems',
            tags: ['pipes', 'streams', 'advanced'],
            title: 'Alternating Pipes | Cycle Method Trick',
            ctrHeadline: 'Pipes Opening Alternately? Use This Cycle Trick! 🔄',
            description: 'Master the alternating pipes method for competitive exams. Solve complex pipe cycle problems in steps - advanced technique for SSC CGL, Banking PO.',
            difficulty: 'Advanced',
            formula: 'Work in 1 cycle = A\'s share + B\'s share',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Pipes work in turns? Find <strong>work per cycle</strong>, then calculate total cycles needed!</p>

                    <!-- SVG Alternating Pattern -->
                    <svg viewBox="0 0 380 100" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" text-anchor="middle">
                            <!-- Hour 1 -->
                            <rect x="30" y="40" width="60" height="30" rx="3" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="60" y="30" font-size="11" fill="var(--text-muted, #888)">Hour 1</text>
                            <text x="60" y="60" font-size="13" fill="var(--accent-primary, #6366f1)" font-weight="bold">Pipe A</text>
                            
                            <!-- Hour 2 -->
                            <rect x="110" y="40" width="60" height="30" rx="3" fill="var(--success, #22c55e)" opacity="0.2"/>
                            <text x="140" y="30" font-size="11" fill="var(--text-muted, #888)">Hour 2</text>
                            <text x="140" y="60" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">Pipe B</text>
                            
                            <!-- Hour 3 -->
                            <rect x="190" y="40" width="60" height="30" rx="3" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="220" y="30" font-size="11" fill="var(--text-muted, #888)">Hour 3</text>
                            <text x="220" y="60" font-size="13" fill="var(--accent-primary, #6366f1)" font-weight="bold">Pipe A</text>
                            
                            <!-- Hour 4 -->
                            <rect x="270" y="40" width="60" height="30" rx="3" fill="var(--success, #22c55e)" opacity="0.2"/>
                            <text x="300" y="30" font-size="11" fill="var(--text-muted, #888)">Hour 4</text>
                            <text x="300" y="60" font-size="13" fill="var(--success, #22c55e)" font-weight="bold">Pipe B</text>
                            
                            <!-- Cycle bracket -->
                            <line x1="30" y1="85" x2="170" y2="85" stroke="var(--warning, #f59e0b)" stroke-width="2"/>
                            <text x="100" y="95" font-size="12" fill="var(--warning, #f59e0b)" font-weight="bold">1 Cycle (2 hrs)</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">A fills in 6 hrs, B in 12 hrs. Opened alternately, 1 hr each. Time to fill?</div>
                        <div class="step">Step 1: In 1 cycle (2 hrs): A works 1 hr + B works 1 hr</div>
                        <div class="step">Step 2: Work done = 1/6 + 1/12 = 2/12 + 1/12 = <strong>3/12 = 1/4</strong></div>
                        <div class="step">Step 3: Cycles needed = 1 ÷ (1/4) = 4 cycles</div>
                        <div class="step">Step 4: Time = 4 cycles × 2 hrs = <strong>8 hours</strong></div>
                        <div class="result">Answer: 8 hours</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = 6;
                const b = 12;
                const workPerCycle = 1 / a + 1 / b;
                const cycles = Math.ceil(1 / workPerCycle);
                const time = cycles * 2;
                return {
                    text: `A fills in ${a} hrs, B in ${b} hrs. Alternating 1hr each. Total time (hours)?`,
                    answer: time
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'pipes-partial-work': {
            id: 'pipes-partial-work',
            category: 'Word Problems',
            tags: ['pipes', 'streams'],
            title: 'Partial Work in Pipes | Remaining Time',
            ctrHeadline: 'Pipe Stops Halfway? Find Remaining Time! ⏱️',
            description: 'Learn to solve partial work pipe problems for competitive exams. Calculate remaining time when one pipe stops - essential for SSC, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'Remaining = 1 - (time₁/total₁)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Find <strong>remaining work</strong> after first pipe, then let second pipe finish it!</p>

                    <div class="example-box">
                        <div class="problem">A fills tank in 12 hrs. After 4 hrs, A is closed and B (fills in 8 hrs) opens. Total time?</div>
                        <div class="step">Step 1: A's work in 4 hrs = 4/12 = <strong>1/3 filled</strong></div>
                        <div class="step">Step 2: Remaining = 1 - 1/3 = <strong>2/3</strong></div>
                        <div class="step">Step 3: B fills full tank in 8 hrs, so 2/3 takes: (2/3) × 8 = <strong>16/3 ≈ 5.33 hrs</strong></div>
                        <div class="step">Step 4: Total = 4 + 5.33 = <strong>9.33 hours</strong></div>
                        <div class="result">Answer: ~9.33 hours</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const a = 12;
                const aTime = 4;
                const b = 8;
                const workDone = aTime / a;
                const remaining = 1 - workDone;
                const bTime = remaining * b;
                const total = aTime + bTime;
                return {
                    text: `A fills in ${a} hrs. After ${aTime} hrs, A closes, B (fills in ${b} hrs) opens. Total time?`,
                    answer: Math.round(total * 100) / 100
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 0.5
        }
    });
})();
