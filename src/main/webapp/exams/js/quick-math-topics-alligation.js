/**
 * Quick Math Topics - Alligation & Mixtures
 */

(function registerAlligationTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'alligation-basic': {
            id: 'alligation-basic',
            category: 'Commercial Math',
            tags: ['alligation', 'mixtures', 'ratio'],
            title: 'Alligation Basic | The Cross Method',
            ctrHeadline: 'Mix two items? Use the magical cross!',
            description: 'Find the ratio to mix two ingredients using the alligation cross method.',
            difficulty: 'Intermediate',
            formula: 'Ratio = (Higher - Mean) : (Mean - Lower)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">The <strong>Alligation Cross</strong> is a visual shortcut for mixture ratios!</p>

                    <!-- SVG Alligation Cross -->
                    <svg viewBox="0 0 380 180" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <g font-family="monospace" font-weight="bold" text-anchor="middle">
                            <!-- Cheaper item (left) -->
                            <circle cx="80" cy="60" r="25" fill="var(--accent-primary, #6366f1)" opacity="0.2"/>
                            <text x="80" y="50" font-size="12" fill="var(--text-secondary, #888)">Cheaper</text>
                            <text x="80" y="70" font-size="18" fill="var(--accent-primary, #6366f1)">₹20/kg</text>
                            
                            <!-- Costlier item (right) -->
                            <circle cx="300" cy="60" r="25" fill="var(--success, #22c55e)" opacity="0.2"/>
                            <text x="300" y="50" font-size="12" fill="var(--text-secondary, #888)">Costlier</text>
                            <text x="300" y="70" font-size="18" fill="var(--success, #22c55e)">₹35/kg</text>
                            
                            <!-- Mean (center) -->
                            <circle cx="190" cy="110" r="30" fill="var(--warning, #f59e0b)" opacity="0.2"/>
                            <text x="190" y="100" font-size="12" fill="var(--text-secondary, #888)">Mean Price</text>
                            <text x="190" y="120" font-size="20" fill="var(--warning, #f59e0b)">₹26/kg</text>
                            
                            <!-- Cross lines -->
                            <line x1="105" y1="70" x2="165" y2="100" stroke="var(--danger, #ef4444)" stroke-width="2"/>
                            <line x1="275" y1="70" x2="215" y2="100" stroke="var(--danger, #ef4444)" stroke-width="2"/>
                            
                            <!-- Differences (bottom) -->
                            <g transform="translate(0, 15)">
                                <text x="80" y="135" font-size="14" fill="var(--danger, #ef4444)">35 - 26</text>
                                <text x="80" y="155" font-size="16" fill="var(--danger, #ef4444)" font-weight="bold">= 9</text>
                                
                                <text x="300" y="135" font-size="14" fill="var(--danger, #ef4444)">26 - 20</text>
                                <text x="300" y="155" font-size="16" fill="var(--danger, #ef4444)" font-weight="bold">= 6</text>
                            </g>
                            
                            <!-- Ratio -->
                            <text x="190" y="175" font-size="16" fill="var(--text-primary, #ddd)">Ratio = 9 : 6 = 3 : 2</text>
                        </g>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Mix ₹20/kg rice with ₹35/kg rice to get ₹26/kg. Find ratio.</div>
                        <div class="step">Step 1: Draw the cross with cheaper, costlier, and mean</div>
                        <div class="step">Step 2: Cheaper gets (35 - 26) = <strong>9 parts</strong></div>
                        <div class="step">Step 3: Costlier gets (26 - 20) = <strong>6 parts</strong></div>
                        <div class="step">Step 4: Ratio = 9:6 = <strong>3:2</strong></div>
                        <div class="result">Mix in ratio 3:2</div>
                    </div>
                    
                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Remember:</strong> Cheaper ingredient gets (Higher - Mean), costlier gets (Mean - Lower)
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const lower = (Math.floor(Math.random() * 4) + 4) * 5; // 20,25,30,35
                const higher = lower + (Math.floor(Math.random() * 3) + 2) * 5; // +10,+15,+20
                const mean = lower + Math.floor((higher - lower) / 2);
                const diff1 = higher - mean;
                const diff2 = mean - lower;
                // Simplified ratio
                const gcd = (a, b) => b === 0 ? a : gcd(b, a % b);
                const g = gcd(diff1, diff2);
                return {
                    text: `Mix ₹${lower}/kg with ₹${higher}/kg to get ₹${mean}/kg. Ratio?`,
                    answer: `${diff1 / g}:${diff2 / g}`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        },
        'alligation-percentage': {
            id: 'alligation-percentage',
            category: 'Commercial Math',
            tags: ['alligation', 'mixtures', 'percentage'],
            title: 'Alligation with Percentages',
            ctrHeadline: 'Mix solutions? Same cross method works!',
            description: 'Use alligation to mix solutions of different concentrations.',
            difficulty: 'Intermediate',
            formula: 'Same cross method with %',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Mixing <strong>solutions</strong>? Alligation works with percentages too!</p>

                    <div class="example-box">
                        <div class="problem">Mix 20% solution with 50% solution to get 35% solution. Find ratio.</div>
                        <div class="step">Step 1: Draw cross → 20%, 50%, and mean 35%</div>
                        <div class="step">Step 2: 20% solution gets (50 - 35) = <strong>15 parts</strong></div>
                        <div class="step">Step 3: 50% solution gets (35 - 20) = <strong>15 parts</strong></div>
                        <div class="step">Step 4: Ratio = 15:15 = <strong>1:1</strong></div>
                        <div class="result">Mix equal amounts</div>
                    </div>

                    <!-- SVG Beakers -->
                    <svg viewBox="0 0 380 120" style="width: 100%; max-width: 440px; display: block; margin: 16px auto;">
                        <defs>
                            <linearGradient id="sol-low" x1="0%" y1="0%" x2="0%" y2="100%">
                                <stop offset="0%" style="stop-color:#6366f1;stop-opacity:0.3" />
                                <stop offset="100%" style="stop-color:#6366f1;stop-opacity:0.8" />
                            </linearGradient>
                            <linearGradient id="sol-high" x1="0%" y1="0%" x2="0%" y2="100%">
                                <stop offset="0%" style="stop-color:#22c55e;stop-opacity:0.3" />
                                <stop offset="100%" style="stop-color:#22c55e;stop-opacity:0.8" />
                            </linearGradient>
                            <linearGradient id="sol-mix" x1="0%" y1="0%" x2="0%" y2="100%">
                                <stop offset="0%" style="stop-color:#f59e0b;stop-opacity:0.3" />
                                <stop offset="100%" style="stop-color:#f59e0b;stop-opacity:0.8" />
                            </linearGradient>
                        </defs>
                        
                        <!-- Beaker 1 -->
                        <path d="M60,30 L60,90 L100,90 L100,30 Z" fill="none" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                        <rect x="60" y="60" width="40" height="30" fill="url(#sol-low)"/>
                        <text x="80" y="50" font-size="12" fill="var(--accent-primary, #6366f1)" text-anchor="middle" font-weight="bold">20%</text>
                        
                        <!-- Plus -->
                        <text x="140" y="70" font-size="24" fill="var(--text-secondary, #666)" text-anchor="middle">+</text>
                        
                        <!-- Beaker 2 -->
                        <path d="M170,30 L170,90 L210,90 L210,30 Z" fill="none" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                        <rect x="170" y="45" width="40" height="45" fill="url(#sol-high)"/>
                        <text x="190" y="35" font-size="12" fill="var(--success, #22c55e)" text-anchor="middle" font-weight="bold">50%</text>
                        
                        <!-- Equals -->
                        <text x="250" y="70" font-size="24" fill="var(--text-secondary, #666)" text-anchor="middle">=</text>
                        
                        <!-- Beaker 3 -->
                        <path d="M280,30 L280,90 L320,90 L320,30 Z" fill="none" stroke="var(--text-secondary, #666)" stroke-width="2"/>
                        <rect x="280" y="52" width="40" height="38" fill="url(#sol-mix)"/>
                        <text x="300" y="42" font-size="12" fill="var(--warning, #f59e0b)" text-anchor="middle" font-weight="bold">35%</text>
                    </svg>
                </div>
            `,
            generateQuestion: () => {
                const lower = (Math.floor(Math.random() * 3) + 1) * 10; // 10,20,30
                const higher = lower + (Math.floor(Math.random() * 3) + 3) * 10; // +30,+40,+50
                const mean = lower + Math.floor((higher - lower) / 2);
                const diff1 = higher - mean;
                const diff2 = mean - lower;
                const gcd = (a, b) => b === 0 ? a : gcd(b, a % b);
                const g = gcd(diff1, diff2);
                return {
                    text: `Mix ${lower}% solution with ${higher}% to get ${mean}%. Ratio?`,
                    answer: `${diff1 / g}:${diff2 / g}`
                };
            },
            checkAnswer: (userAns, correctAns) => {
                const clean = (s) => s.replace(/\s/g, '');
                return clean(userAns) === clean(correctAns);
            }
        },
        'alligation-replacement': {
            id: 'alligation-replacement',
            category: 'Commercial Math',
            tags: ['alligation', 'mixtures', 'advanced'],
            title: 'Mixture Replacement',
            ctrHeadline: 'Remove and replace to change concentration!',
            description: 'Calculate the final concentration after removing and replacing part of a mixture.',
            difficulty: 'Advanced',
            formula: 'Final = Initial × (1 - Removed/Total)ⁿ',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Removing and replacing changes the <strong>concentration</strong> with each step!</p>

                    <div class="example-box">
                        <div class="problem">40L of 60% milk. Remove 10L, replace with water. Final %?</div>
                        <div class="step">Step 1: Fraction removed = 10/40 = <strong>1/4</strong></div>
                        <div class="step">Step 2: Milk left = 60% × (1 - 1/4) = 60% × 3/4</div>
                        <div class="step">Step 3: = 60 × 0.75 = <strong>45%</strong></div>
                        <div class="result">Final concentration: 45%</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Formula:</strong> New% = Old% × (1 - Removed/Total)
                    </p>
                    
                    <p class="step-intro" style="margin-top: var(--space-2); font-size: var(--text-sm);">
                        <strong>For n replacements:</strong> Final% = Initial% × (1 - R/T)ⁿ
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const total = 40;
                const initial = 60;
                const removed = [10, 20][Math.floor(Math.random() * 2)];
                const fraction = removed / total;
                const final = initial * (1 - fraction);
                return {
                    text: `${total}L of ${initial}% milk. Remove ${removed}L, add water. Final %?`,
                    answer: final
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'alligation-mean-price': {
            id: 'alligation-mean-price',
            category: 'Commercial Math',
            tags: ['alligation', 'average'],
            title: 'Finding Mean Price | Weighted Average',
            ctrHeadline: 'Given ratio, find the mean price!',
            description: 'Calculate the mean price when mixing in a known ratio.',
            difficulty: 'Intermediate',
            formula: 'Mean = (P₁×Q₁ + P₂×Q₂) / (Q₁ + Q₂)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Know the ratio? Use <strong>weighted average</strong> to find mean!</p>

                    <div class="example-box">
                        <div class="problem">Mix ₹30/kg rice with ₹50/kg rice in ratio 2:3. Find mean price.</div>
                        <div class="step">Step 1: Total parts = 2 + 3 = <strong>5 parts</strong></div>
                        <div class="step">Step 2: Mean = (30×2 + 50×3) / 5</div>
                        <div class="step">Step 3: = (60 + 150) / 5 = 210 / 5</div>
                        <div class="step">Step 4: = <strong>₹42/kg</strong></div>
                        <div class="result">Mean price: ₹42/kg</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const p1 = (Math.floor(Math.random() * 4) + 2) * 10; // 20-50
                const p2 = p1 + (Math.floor(Math.random() * 3) + 2) * 10; // +20,+30,+40
                const r1 = Math.floor(Math.random() * 3) + 1; // 1,2,3
                const r2 = Math.floor(Math.random() * 3) + 1;
                const mean = (p1 * r1 + p2 * r2) / (r1 + r2);
                return {
                    text: `₹${p1}/kg mixed with ₹${p2}/kg in ${r1}:${r2}. Mean price?`,
                    answer: mean
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseFloat(userAns) - correctAns) <= 0.5
        },
        'alligation-quantity': {
            id: 'alligation-quantity',
            category: 'Commercial Math',
            tags: ['alligation', 'mixtures'],
            title: 'Finding Quantity from Ratio',
            ctrHeadline: 'Know the ratio? Scale it up!',
            description: 'Given the ratio and total, find individual quantities.',
            difficulty: 'Beginner',
            formula: 'Quantity = (Part / Total Parts) × Total Mixture',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Got a ratio and total? <strong>Scale up</strong> the parts!</p>

                    <div class="example-box">
                        <div class="problem">Mix in 3:2 ratio to make 50kg. How much of each?</div>
                        <div class="step">Step 1: Total parts = 3 + 2 = <strong>5 parts</strong></div>
                        <div class="step">Step 2: 1 part = 50 / 5 = <strong>10 kg</strong></div>
                        <div class="step">Step 3: First item = 3 × 10 = <strong>30 kg</strong></div>
                        <div class="step">Step 4: Second item = 2 × 10 = <strong>20 kg</strong></div>
                        <div class="result">30 kg and 20 kg</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const r1 = Math.floor(Math.random() * 4) + 1; // 1-4
                const r2 = Math.floor(Math.random() * 4) + 1;
                const total = (r1 + r2) * (Math.floor(Math.random() * 5) + 5); // Multiple of sum
                const q1 = (total / (r1 + r2)) * r1;
                return {
                    text: `Mix in ${r1}:${r2} to make ${total}kg total. First item qty (kg)?`,
                    answer: q1
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        }
    });
})();
