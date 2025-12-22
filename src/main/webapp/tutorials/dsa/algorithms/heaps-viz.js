/**
 * Heaps SVG Visualization
 * Shows heap structure and operations
 */

(function () {
    'use strict';

    class HeapsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'structure';
            this.init();
        }

        init() {
            this.render();
            this.bindEvents();
        }

        bindEvents() {
            const buttons = this.container.querySelectorAll('.viz-tab-btn');
            buttons.forEach(btn => {
                btn.addEventListener('click', () => {
                    this.currentView = btn.dataset.view;
                    this.render();
                    this.bindEvents();
                });
            });
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Heap Visualizations</h3>
                    <p class="viz-subtitle">Understand heap structure and operations</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'structure' ? 'active' : ''}" data-view="structure">
                        🌳 Heap Structure
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'insert' ? 'active' : ''}" data-view="insert">
                        ➕ Insert
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'extract' ? 'active' : ''}" data-view="extract">
                        🔽 Extract Min
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'array' ? 'active' : ''}" data-view="array">
                        📊 Array Representation
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'structure':
                    return this.renderStructure();
                case 'insert':
                    return this.renderInsert();
                case 'extract':
                    return this.renderExtract();
                case 'array':
                    return this.renderArray();
                default:
                    return '';
            }
        }

        renderStructure() {
            return `
                <div class="tree-viz-section">
                    <h4>Min Heap Structure</h4>
                    <p class="viz-description">Complete binary tree where parent ≤ children. Root is always minimum!</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- Min Heap -->
                        <circle cx="400" cy="80" r="35" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="24" font-weight="bold" fill="white">1</text>
                        <text x="400" y="40" text-anchor="middle" font-size="14" font-weight="bold" fill="#4CAF50">MIN (Root)</text>
                        
                        <line x1="400" y1="115" x2="250" y2="165" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="115" x2="550" y2="165" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="190" r="35" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="250" y="198" text-anchor="middle" font-size="24" font-weight="bold" fill="white">3</text>
                        <text x="180" y="198" font-size="12" fill="var(--text-secondary)">3 ≥ 1 ✓</text>
                        
                        <circle cx="550" cy="190" r="35" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="550" y="198" text-anchor="middle" font-size="24" font-weight="bold" fill="white">2</text>
                        <text x="620" y="198" font-size="12" fill="var(--text-secondary)">2 ≥ 1 ✓</text>
                        
                        <line x1="250" y1="225" x2="150" y2="275" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="225" x2="350" y2="275" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="225" x2="450" y2="275" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="225" x2="650" y2="275" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="150" y="308" text-anchor="middle" font-size="24" font-weight="bold" fill="white">7</text>
                        
                        <circle cx="350" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="308" text-anchor="middle" font-size="24" font-weight="bold" fill="white">5</text>
                        
                        <circle cx="450" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="450" y="308" text-anchor="middle" font-size="24" font-weight="bold" fill="white">6</text>
                        
                        <circle cx="650" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="650" y="308" text-anchor="middle" font-size="24" font-weight="bold" fill="white">4</text>
                        
                        <!-- Properties -->
                        <g transform="translate(50, 380)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Min Heap Property:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">• Parent ≤ Both children</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">• Root is always minimum</text>
                            <text x="0" y="65" font-size="14" fill="var(--text-secondary)">• Complete binary tree (filled left to right)</text>
                            <text x="0" y="85" font-size="14" fill="var(--text-secondary)">• Height = O(log n)</text>
                            <text x="0" y="110" font-size="14" font-weight="bold" fill="#4CAF50">Use: Priority queues, Dijkstra's algorithm</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderInsert() {
            return `
                <div class="tree-viz-section">
                    <h4>Insert Operation: Adding 0</h4>
                    <p class="viz-description">Add to end, then bubble up to maintain heap property</p>
                    
                    <svg viewBox="0 0 800 650" class="tree-svg">
                        <!-- Original heap -->
                        <g opacity="0.3">
                            <circle cx="400" cy="80" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="400" y="88" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                            
                            <line x1="400" y1="110" x2="250" y2="160" stroke="#666" stroke-width="2"/>
                            <line x1="400" y1="110" x2="550" y2="160" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="250" cy="180" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                            
                            <circle cx="550" cy="180" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="550" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                            
                            <line x1="250" y1="210" x2="150" y2="260" stroke="#666" stroke-width="2"/>
                            <circle cx="150" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="150" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">7</text>
                        </g>
                        
                        <!-- Step 1: Add to end -->
                        <text x="50" y="350" font-size="16" font-weight="bold" fill="var(--text-primary)">Step 1: Add 0 to end</text>
                        <line x1="250" y1="210" x2="350" y2="260" stroke="#666" stroke-width="2" stroke-dasharray="5,5"/>
                        <circle cx="350" cy="280" r="30" fill="#FF5722" stroke="#D32F2F" stroke-width="3"/>
                        <text x="350" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                        <text x="350" y="330" text-anchor="middle" font-size="12" font-weight="bold" fill="#FF5722">NEW</text>
                        
                        <!-- Step 2: Compare with parent -->
                        <text x="50" y="400" font-size="16" font-weight="bold" fill="var(--text-primary)">Step 2: Compare with parent (3)</text>
                        <path d="M 350 250 Q 300 220 250 210" fill="none" stroke="#FF5722" stroke-width="3" marker-end="url(#arrow-up)"/>
                        <text x="300" y="240" font-size="12" font-weight="bold" fill="#FF5722">0 < 3, swap!</text>
                        
                        <!-- Step 3: After first swap -->
                        <text x="50" y="450" font-size="16" font-weight="bold" fill="var(--text-primary)">Step 3: After swap, compare with 1</text>
                        <circle cx="250" cy="180" r="30" fill="#FF5722" stroke="#D32F2F" stroke-width="3"/>
                        <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                        <path d="M 250 150 Q 325 115 400 110" fill="none" stroke="#FF5722" stroke-width="3" marker-end="url(#arrow-up)"/>
                        <text x="325" y="130" font-size="12" font-weight="bold" fill="#FF5722">0 < 1, swap!</text>
                        
                        <!-- Final result -->
                        <text x="50" y="500" font-size="16" font-weight="bold" fill="var(--text-primary)">Final: 0 is now root (minimum)</text>
                        <circle cx="400" cy="80" r="35" fill="#4CAF50" stroke="#388E3C" stroke-width="4"/>
                        <text x="400" y="88" text-anchor="middle" font-size="24" font-weight="bold" fill="white">0</text>
                        <text x="400" y="40" text-anchor="middle" font-size="14" font-weight="bold" fill="#4CAF50">NEW MIN!</text>
                        
                        <defs>
                            <marker id="arrow-up" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#FF5722"/>
                            </marker>
                        </defs>
                        
                        <!-- Summary -->
                        <g transform="translate(50, 550)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="#4CAF50">Insert: O(log n) - bubble up at most h levels</text>
                            <text x="0" y="20" font-size="12" fill="var(--text-secondary)">Always add to end, then restore heap property</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderExtract() {
            return `
                <div class="tree-viz-section">
                    <h4>Extract Min Operation</h4>
                    <p class="viz-description">Remove root, move last to root, then bubble down</p>
                    
                    <svg viewBox="0 0 800 650" class="tree-svg">
                        <!-- Step 1: Remove root -->
                        <text x="50" y="30" font-size="16" font-weight="bold" fill="var(--text-primary)">Step 1: Remove root (1)</text>
                        <circle cx="400" cy="80" r="35" fill="#F44336" stroke="#C62828" stroke-width="3" stroke-dasharray="5,5"/>
                        <text x="400" y="88" text-anchor="middle" font-size="24" font-weight="bold" fill="white" opacity="0.5">1</text>
                        <text x="480" y="88" font-size="14" font-weight="bold" fill="#F44336">REMOVED</text>
                        
                        <line x1="400" y1="115" x2="250" y2="165" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="115" x2="550" y2="165" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="190" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="250" y="198" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                        
                        <circle cx="550" cy="190" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="550" y="198" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        
                        <line x1="250" y1="220" x2="150" y2="270" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="220" x2="350" y2="270" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="290" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                        <text x="150" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">7</text>
                        
                        <circle cx="350" cy="290" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                        <text x="350" y="340" text-anchor="middle" font-size="12" font-weight="bold" fill="#FF9800">LAST</text>
                        
                        <!-- Step 2: Move last to root -->
                        <text x="50" y="380" font-size="16" font-weight="bold" fill="var(--text-primary)">Step 2: Move last (5) to root</text>
                        <path d="M 350 260 Q 375 170 400 115" fill="none" stroke="#FF9800" stroke-width="3" marker-end="url(#arrow-move)"/>
                        
                        <circle cx="400" cy="80" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="24" font-weight="bold" fill="white">5</text>
                        
                        <!-- Step 3: Bubble down -->
                        <text x="50" y="430" font-size="16" font-weight="bold" fill="var(--text-primary)">Step 3: Bubble down (5 > 2, swap)</text>
                        <path d="M 430 100 Q 490 145 550 160" fill="none" stroke="#FF9800" stroke-width="3" stroke-dasharray="5,5" marker-end="url(#arrow-down)"/>
                        <text x="490" y="130" font-size="12" font-weight="bold" fill="#FF9800">Swap with smaller child</text>
                        
                        <!-- Final result -->
                        <text x="50" y="480" font-size="16" font-weight="bold" fill="var(--text-primary)">Final: 2 is new root (minimum)</text>
                        <circle cx="400" cy="80" r="35" fill="#4CAF50" stroke="#388E3C" stroke-width="4"/>
                        <text x="400" y="88" text-anchor="middle" font-size="24" font-weight="bold" fill="white">2</text>
                        
                        <defs>
                            <marker id="arrow-move" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#FF9800"/>
                            </marker>
                            <marker id="arrow-down" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#FF9800"/>
                            </marker>
                        </defs>
                        
                        <!-- Summary -->
                        <g transform="translate(50, 550)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="#4CAF50">Extract Min: O(log n) - bubble down at most h levels</text>
                            <text x="0" y="20" font-size="12" fill="var(--text-secondary)">Remove root, replace with last, restore heap property</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderArray() {
            return `
                <div class="tree-viz-section">
                    <h4>Array Representation</h4>
                    <p class="viz-description">Heap stored efficiently in array - no pointers needed!</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- Tree view -->
                        <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Tree View</text>
                        
                        <circle cx="400" cy="80" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                        <text x="400" y="130" text-anchor="middle" font-size="12" fill="#4CAF50" font-weight="bold">i=0</text>
                        
                        <line x1="400" y1="110" x2="250" y2="160" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="110" x2="550" y2="160" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="180" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                        <text x="250" y="230" text-anchor="middle" font-size="12" fill="#2196F3" font-weight="bold">i=1</text>
                        
                        <circle cx="550" cy="180" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="550" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        <text x="550" y="230" text-anchor="middle" font-size="12" fill="#2196F3" font-weight="bold">i=2</text>
                        
                        <line x1="250" y1="210" x2="150" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="210" x2="350" y2="260" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                        <text x="150" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">7</text>
                        <text x="150" y="330" text-anchor="middle" font-size="12" fill="#FF9800" font-weight="bold">i=3</text>
                        
                        <circle cx="350" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                        <text x="350" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                        <text x="350" y="330" text-anchor="middle" font-size="12" fill="#FF9800" font-weight="bold">i=4</text>
                        
                        <!-- Array view -->
                        <text x="400" y="390" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Array View</text>
                        
                        <g transform="translate(150, 410)">
                            <rect x="0" y="0" width="80" height="50" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="40" y="30" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                            <text x="40" y="-10" text-anchor="middle" font-size="12" fill="var(--text-secondary)">0</text>
                            
                            <rect x="90" y="0" width="80" height="50" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="130" y="30" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                            <text x="130" y="-10" text-anchor="middle" font-size="12" fill="var(--text-secondary)">1</text>
                            
                            <rect x="180" y="0" width="80" height="50" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="220" y="30" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                            <text x="220" y="-10" text-anchor="middle" font-size="12" fill="var(--text-secondary)">2</text>
                            
                            <rect x="270" y="0" width="80" height="50" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="310" y="30" text-anchor="middle" font-size="20" font-weight="bold" fill="white">7</text>
                            <text x="310" y="-10" text-anchor="middle" font-size="12" fill="var(--text-secondary)">3</text>
                            
                            <rect x="360" y="0" width="80" height="50" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="400" y="30" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                            <text x="400" y="-10" text-anchor="middle" font-size="12" fill="var(--text-secondary)">4</text>
                        </g>
                        
                        <!-- Formulas -->
                        <g transform="translate(50, 510)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Index Formulas:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">• Parent of i: (i - 1) / 2</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">• Left child of i: 2i + 1</text>
                            <text x="0" y="65" font-size="14" fill="var(--text-secondary)">• Right child of i: 2i + 2</text>
                            <text x="400" y="25" font-size="14" fill="#4CAF50" font-weight="bold">Example: Parent of 4 = (4-1)/2 = 1 ✓</text>
                            <text x="400" y="45" font-size="14" fill="#4CAF50" font-weight="bold">Left child of 1 = 2(1)+1 = 3 ✓</text>
                        </g>
                    </svg>
                </div>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new HeapsViz('heapsVisualization');
        });
    } else {
        new HeapsViz('heapsVisualization');
    }
})();
