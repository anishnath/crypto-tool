/**
 * Quick Math Topics - Mensuration (Area, Volume, Perimeter)
 */

(function registerMensurationTopics() {
    const QM = window.QuickMath || (window.QuickMath = { topics: {} });
    QM.topics = QM.topics || {};

    Object.assign(QM.topics, {
        'mensuration-rectangle': {
            id: 'mensuration-rectangle',
            category: 'Mensuration',
            tags: ['mensuration', 'area', 'geometry'],
            title: 'Rectangle Area & Perimeter Formula',
            ctrHeadline: 'Length × Width = Area. Don\'t Forget! 📐',
            description: 'Master area and perimeter calculations for rectangles and squares. Essential geometry formulas for competitive exams (SSC, Banking, Railway).',
            difficulty: 'Beginner',
            formula: 'Area = l×w, Perimeter = 2(l+w)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Rectangle: multiply length and width. <strong>That's it!</strong></p>

                    <!-- SVG Rectangle -->
                    <svg viewBox="0 0 400 180" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <defs>
                            <pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse">
                                <rect width="20" height="20" fill="none" stroke="var(--text-secondary, #444)" stroke-width="0.5"/>
                            </pattern>
                        </defs>
                        
                        <!-- Rectangle with grid -->
                        <rect x="80" y="40" width="240" height="120" fill="url(#grid)" stroke="var(--accent-primary, #6366f1)" stroke-width="3"/>
                        
                        <!-- Dimensions -->
                        <line x1="80" y1="25" x2="320" y2="25" stroke="var(--warning, #f59e0b)" stroke-width="2" marker-start="url(#arrow-l)" marker-end="url(#arrow-r)"/>
                        <text x="200" y="20" text-anchor="middle" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">Length = 12</text>
                        
                        <line x1="335" y1="40" x2="335" y2="160" stroke="var(--success, #22c55e)" stroke-width="2" marker-start="url(#arrow-u)" marker-end="url(#arrow-d)"/>
                        <text x="355" y="105" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">Width = 6</text>
                        
                        <defs>
                            <marker id="arrow-l" markerWidth="10" markerHeight="7" refX="1" refY="3.5" orient="auto">
                                <polygon points="10 0, 0 3.5, 10 7" fill="var(--warning, #f59e0b)"/>
                            </marker>
                            <marker id="arrow-r" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--warning, #f59e0b)"/>
                            </marker>
                            <marker id="arrow-u" markerWidth="7" markerHeight="10" refX="3.5" refY="1" orient="auto">
                                <polygon points="0 10, 3.5 0, 7 10" fill="var(--success, #22c55e)"/>
                            </marker>
                            <marker id="arrow-d" markerWidth="7" markerHeight="10" refX="3.5" refY="9" orient="auto">
                                <polygon points="0 0, 3.5 10, 7 0" fill="var(--success, #22c55e)"/>
                            </marker>
                        </defs>
                        
                        <text x="200" y="175" text-anchor="middle" font-size="13" fill="var(--text-primary, #ddd)">
                            Area = 12 × 6 = 72 sq units
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Rectangle: length 15, width 8. Find area and perimeter.</div>
                        <div class="step">Area = l × w = 15 × 8 = <strong>120 sq units</strong></div>
                        <div class="step">Perimeter = 2(l + w) = 2(15 + 8) = 2 × 23 = <strong>46 units</strong></div>
                        <div class="result">Area: 120, Perimeter: 46</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Square (all sides equal)</div>
                        <div class="step">Area = side² = s²</div>
                        <div class="step">Perimeter = 4s</div>
                        <div class="step">Diagonal = s√2</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const l = Math.floor(Math.random() * 15) + 5;
                const w = Math.floor(Math.random() * 10) + 3;
                const area = l * w;
                return {
                    text: `Rectangle ${l}×${w}. Area?`,
                    answer: area
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'mensuration-triangle': {
            id: 'mensuration-triangle',
            category: 'Mensuration',
            tags: ['mensuration', 'area', 'geometry'],
            title: 'Triangle Area Formula | Base & Height',
            ctrHeadline: 'Area = ½ × Base × Height. Memorize It! 🔺',
            description: 'Master triangle area calculations for competitive exams. Understand the 1/2*base*height formula - key geometry concept for SSC CGL, Banking.',
            difficulty: 'Beginner',
            formula: 'Area = ½bh',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Triangle = <strong>Half a rectangle</strong>. Draw the height!</p>

                    <!-- SVG Triangle -->
                    <svg viewBox="0 0 400 180" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <!-- Triangle -->
                        <path d="M200,40 L320,150 L80,150 Z" fill="var(--accent-primary, #6366f1)" opacity="0.2" stroke="var(--accent-primary, #6366f1)" stroke-width="3"/>
                        
                        <!-- Height (dashed line) -->
                        <line x1="200" y1="40" x2="200" y2="150" stroke="var(--danger, #ef4444)" stroke-width="2" stroke-dasharray="5"/>
                        <text x="215" y="95" font-size="14" fill="var(--danger, #ef4444)" font-weight="bold">h = 11</text>
                        
                        <!-- Base -->
                        <line x1="80" y1="165" x2="320" y2="165" stroke="var(--success, #22c55e)" stroke-width="2" marker-start="url(#arrow-bl)" marker-end="url(#arrow-br)"/>
                        <text x="200" y="180" text-anchor="middle" font-size="14" fill="var(--success, #22c55e)" font-weight="bold">base = 24</text>
                        
                        <defs>
                            <marker id="arrow-bl" markerWidth="10" markerHeight="7" refX="1" refY="3.5" orient="auto">
                                <polygon points="10 0, 0 3.5, 10 7" fill="var(--success, #22c55e)"/>
                            </marker>
                            <marker id="arrow-br" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                                <polygon points="0 0, 10 3.5, 0 7" fill="var(--success, #22c55e)"/>
                            </marker>
                        </defs>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Triangle: base 10, height 8. Find area.</div>
                        <div class="step">Area = ½ × base × height</div>
                        <div class="step">= ½ × 10 × 8 = 5 × 8</div>
                        <div class="step">= <strong>40 sq units</strong></div>
                        <div class="result">Area: 40</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Special triangles</div>
                        <div class="step"><strong>Equilateral:</strong> Area = (√3/4)a² where a = side</div>
                        <div class="step"><strong>Right-angled:</strong> Area = ½ × leg₁ × leg₂</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const base = (Math.floor(Math.random() * 10) + 5) * 2;
                const height = Math.floor(Math.random() * 10) + 4;
                const area = (base * height) / 2;
                return {
                    text: `Triangle base ${base}, height ${height}. Area?`,
                    answer: area
                };
            },
            checkAnswer: (userAns, correctAns) => parseFloat(userAns) === correctAns
        },
        'mensuration-circle': {
            id: 'mensuration-circle',
            category: 'Mensuration',
            tags: ['mensuration', 'area', 'geometry', 'circle'],
            title: 'Circle Area & Circumference Formulas',
            ctrHeadline: 'πr² vs 2πr: Never Confuse Them Again! ⚪',
            description: 'Master circle formulas (Area = πr², Circumference = 2πr) for competitive exams. Solve geometry problems instantly - essential for SSC, Banking.',
            difficulty: 'Intermediate',
            formula: 'Area = πr², Circumference = 2πr',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Circle: Everything depends on <strong>radius (r)</strong>!</p>

                    <!-- SVG Circle -->
                    <svg viewBox="0 0 400 200" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <!-- Circle -->
                        <circle cx="200" cy="100" r="70" fill="var(--success, #22c55e)" opacity="0.1" stroke="var(--success, #22c55e)" stroke-width="3"/>
                        
                        <!-- Center dot -->
                        <circle cx="200" cy="100" r="4" fill="var(--danger, #ef4444)"/>
                        
                        <!-- Radius -->
                        <line x1="200" y1="100" x2="270" y2="100" stroke="var(--warning, #f59e0b)" stroke-width="3"/>
                        <text x="235" y="90" font-size="14" fill="var(--warning, #f59e0b)" font-weight="bold">r = 7</text>
                        
                        <!-- Diameter -->
                        <line x1="130" y1="100" x2="270" y2="100" stroke="var(--accent-primary, #6366f1)" stroke-width="2" stroke-dasharray="5"/>
                        <text x="200" y="120" text-anchor="middle" font-size="12" fill="var(--accent-primary, #6366f1)">d = 2r = 14</text>
                        
                        <!-- Formulas -->
                        <text x="200" y="185" text-anchor="middle" font-size="13" fill="var(--text-primary, #ddd)">
                            Area = πr² = π × 49 ≈ 154
                        </text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Circle with radius 7. Find area and circumference. (Use π = 22/7)</div>
                        <div class="step">Area = πr² = (22/7) × 7² = 22 × 7 = <strong>154 sq units</strong></div>
                        <div class="step">Circumference = 2πr = 2 × (22/7) × 7 = <strong>44 units</strong></div>
                        <div class="result">Area: 154, Circumference: 44</div>
                    </div>

                    <p class="step-intro" style="margin-top: var(--space-3); font-size: var(--text-sm);">
                        <strong>Quick tip:</strong> Use π = 22/7 for multiples of 7, π = 3.14 otherwise
                    </p>
                </div>
            `,
            generateQuestion: () => {
                const r = [7, 14, 21][Math.floor(Math.random() * 3)]; // Multiples of 7 for easy calculation
                const area = Math.floor((22 / 7) * r * r);
                return {
                    text: `Circle radius ${r}. Area? (π=22/7)`,
                    answer: area
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseInt(userAns) - correctAns) <= 2
        },
        'mensuration-cuboid': {
            id: 'mensuration-cuboid',
            category: 'Mensuration',
            tags: ['mensuration', 'volume', 'geometry', '3d'],
            title: 'Cuboid Volume & Surface Area Formulas',
            ctrHeadline: 'Volume = L×W×H. 3D Math Made Easy! 📦',
            description: 'Master cuboid volume and surface area calculations for competitive exams. Learn the 3D geometry formulas essential for SSC CGL, Banking, Railway.',
            difficulty: 'Intermediate',
            formula: 'Volume = l×w×h, SA = 2(lw+wh+lh)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Cuboid = 3D rectangle. <strong>Multiply all three dimensions!</strong></p>

                    <!-- SVG 3D Cuboid -->
                    <svg viewBox="0 0 400 200" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <!-- Front face -->
                        <path d="M100,120 L240,120 L240,180 L100,180 Z" fill="var(--accent-primary, #6366f1)" opacity="0.3" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                        
                        <!-- Top face -->
                        <path d="M100,120 L150,90 L290,90 L240,120 Z" fill="var(--success, #22c55e)" opacity="0.3" stroke="var(--success, #22c55e)" stroke-width="2"/>
                        
                        <!-- Right face -->
                        <path d="M240,120 L290,90 L290,150 L240,180 Z" fill="var(--warning, #f59e0b)" opacity="0.3" stroke="var(--warning, #f59e0b)" stroke-width="2"/>
                        
                        <!-- Hidden edges (dashed) -->
                        <line x1="100" y1="180" x2="150" y2="150" stroke="var(--text-secondary, #666)" stroke-width="1" stroke-dasharray="3"/>
                        <line x1="150" y1="150" x2="290" y2="150" stroke="var(--text-secondary, #666)" stroke-width="1" stroke-dasharray="3"/>
                        <line x1="150" y1="150" x2="150" y2="90" stroke="var(--text-secondary, #666)" stroke-width="1" stroke-dasharray="3"/>
                        
                        <!-- Dimension labels -->
                        <text x="170" y="195" font-size="12" fill="var(--text-primary, #ddd)">Length = l</text>
                        <text x="310" y="120" font-size="12" fill="var(--text-primary, #ddd)">Height = h</text>
                        <text x="220" y="80" font-size="12" fill="var(--text-primary, #ddd)">Width = w</text>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Cuboid: 10 × 6 × 4. Find volume and surface area.</div>
                        <div class="step">Volume = l × w × h = 10 × 6 × 4 = <strong>240 cubic units</strong></div>
                        <div class="step">Surface Area = 2(lw + wh + lh)</div>
                        <div class="step">= 2(60 + 24 + 40) = 2 × 124 = <strong>248 sq units</strong></div>
                        <div class="result">Volume: 240, SA: 248</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Cube (all sides equal: a)</div>
                        <div class="step">Volume = a³</div>
                        <div class="step">Surface Area = 6a²</div>
                        <div class="step">Diagonal = a√3</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const l = Math.floor(Math.random() * 8) + 5;
                const w = Math.floor(Math.random() * 6) + 3;
                const h = Math.floor(Math.random() * 5) + 2;
                const volume = l * w * h;
                return {
                    text: `Cuboid ${l}×${w}×${h}. Volume?`,
                    answer: volume
                };
            },
            checkAnswer: (userAns, correctAns) => parseInt(userAns) === correctAns
        },
        'mensuration-cylinder': {
            id: 'mensuration-cylinder',
            category: 'Mensuration',
            tags: ['mensuration', 'volume', 'geometry', '3d'],
            title: 'Cylinder Volume & Surface Area Formulas',
            ctrHeadline: 'Calculate Cylinder Volume in Seconds! 🛢️',
            description: 'Master cylinder volume (πr²h) and surface area calculations for competitive exams. Solve 3D mensuration problems quickly - SSC, Banking trick.',
            difficulty: 'Intermediate',
            formula: 'Volume = πr²h, SA = 2πr(r+h)',
            explanation: `
                <div class="math-visualizer">
                    <p class="step-intro">Cylinder = <strong>Circle × height</strong>. Stack circles vertically!</p>

                    <!-- SVG Cylinder -->
                    <svg viewBox="0 0 400 220" style="width: 100%; max-width: 460px; display: block; margin: 16px auto;">
                        <!-- Bottom ellipse -->
                        <ellipse cx="200" cy="170" rx="80" ry="20" fill="var(--accent-primary, #6366f1)" opacity="0.2" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                        
                        <!-- Top ellipse -->
                        <ellipse cx="200" cy="60" rx="80" ry="20" fill="var(--success, #22c55e)" opacity="0.3" stroke="var(--success, #22c55e)" stroke-width="2"/>
                        
                        <!-- Side lines -->
                        <line x1="120" y1="60" x2="120" y2="170" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                        <line x1="280" y1="60" x2="280" y2="170" stroke="var(--accent-primary, #6366f1)" stroke-width="2"/>
                        
                        <!-- Radius -->
                        <line x1="200" y1="60" x2="280" y2="60" stroke="var(--warning, #f59e0b)" stroke-width="2"/>
                        <text x="240" y="50" font-size="13" fill="var(--warning, #f59e0b)" font-weight="bold">r</text>
                        
                        <!-- Height -->
                        <line x1="295" y1="60" x2="295" y2="170" stroke="var(--danger, #ef4444)" stroke-width="2" marker-start="url(#arrow-ht)" marker-end="url(#arrow-hb)"/>
                        <text x="310" y="120" font-size="13" fill="var(--danger, #ef4444)" font-weight="bold">h</text>
                        
                        <defs>
                            <marker id="arrow-ht" markerWidth="7" markerHeight="10" refX="3.5" refY="1" orient="auto">
                                <polygon points="0 10, 3.5 0, 7 10" fill="var(--danger, #ef4444)"/>
                            </marker>
                            <marker id="arrow-hb" markerWidth="7" markerHeight="10" refX="3.5" refY="9" orient="auto">
                                <polygon points="0 0, 3.5 10, 7 0" fill="var(--danger, #ef4444)"/>
                            </marker>
                        </defs>
                    </svg>

                    <div class="example-box">
                        <div class="problem">Cylinder: radius 7, height 10. Volume? (π=22/7)</div>
                        <div class="step">Volume = πr²h = (22/7) × 7² × 10</div>
                        <div class="step">= 22 × 7 × 10 = <strong>1540 cubic units</strong></div>
                        <div class="result">Volume: 1540</div>
                    </div>

                    <div class="example-box" style="margin-top: var(--space-3);">
                        <div class="problem">Surface Area breakdown</div>
                        <div class="step">Curved surface = 2πrh (rectangle wrapped around)</div>
                        <div class="step">Two circular ends = 2πr²</div>
                        <div class="step">Total SA = 2πr(r + h)</div>
                    </div>
                </div>
            `,
            generateQuestion: () => {
                const r = 7;
                const h = (Math.floor(Math.random() * 8) + 5) * 2;
                const volume = Math.floor((22 / 7) * r * r * h);
                return {
                    text: `Cylinder r=${r}, h=${h}. Volume? (π=22/7)`,
                    answer: volume
                };
            },
            checkAnswer: (userAns, correctAns) => Math.abs(parseInt(userAns) - correctAns) <= 5
        }
    });
})();
