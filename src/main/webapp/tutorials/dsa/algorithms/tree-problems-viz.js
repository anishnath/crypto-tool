/**
 * Tree Problems SVG Visualization
 * Shows common tree problem patterns
 */

(function () {
    'use strict';

    class TreeProblemsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'depth';
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
                    <h3>Common Tree Patterns</h3>
                    <p class="viz-subtitle">Master these patterns to solve most tree problems</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'depth' ? 'active' : ''}" data-view="depth">
                        📊 Depth & Height
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'path' ? 'active' : ''}" data-view="path">
                        🛤️ Path Sum
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'lca' ? 'active' : ''}" data-view="lca">
                        👥 LCA
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'symmetric' ? 'active' : ''}" data-view="symmetric">
                        🪞 Symmetric
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'depth':
                    return this.renderDepth();
                case 'path':
                    return this.renderPathSum();
                case 'lca':
                    return this.renderLCA();
                case 'symmetric':
                    return this.renderSymmetric();
                default:
                    return '';
            }
        }

        renderDepth() {
            return `
                <div class="tree-viz-section">
                    <h4>Maximum Depth (Height) of Tree</h4>
                    <p class="viz-description">Find the longest path from root to any leaf. Real-world: Organization hierarchy levels, file system depth</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- Tree -->
                        <circle cx="400" cy="80" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                        <text x="450" y="88" font-size="14" fill="#2196F3" font-weight="bold">Depth 0</text>
                        
                        <line x1="400" y1="110" x2="250" y2="160" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="110" x2="550" y2="160" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        <text x="300" y="188" font-size="14" fill="#4CAF50" font-weight="bold">Depth 1</text>
                        
                        <circle cx="550" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                        
                        <line x1="250" y1="210" x2="150" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="210" x2="350" y2="260" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="150" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        <text x="200" y="288" font-size="14" fill="#FF9800" font-weight="bold">Depth 2</text>
                        
                        <circle cx="350" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                        
                        <line x1="150" y1="310" x2="100" y2="360" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="100" cy="380" r="30" fill="#E91E63" stroke="#C2185B" stroke-width="3"/>
                        <text x="100" y="388" text-anchor="middle" font-size="20" font-weight="bold" fill="white">6</text>
                        <text x="150" y="388" font-size="14" fill="#E91E63" font-weight="bold">Depth 3</text>
                        
                        <!-- Height arrows -->
                        <line x1="700" y1="80" x2="700" y2="380" stroke="#FF5722" stroke-width="4" marker-end="url(#arrow-height)"/>
                        <text x="720" y="230" font-size="18" font-weight="bold" fill="#FF5722">Height = 3</text>
                        
                        <defs>
                            <marker id="arrow-height" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#FF5722"/>
                            </marker>
                        </defs>
                        
                        <!-- Formula -->
                        <g transform="translate(50, 450)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Formula:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">height(node) = 1 + max(height(left), height(right))</text>
                            <text x="0" y="50" font-size="14" fill="var(--text-secondary)">Base case: height(null) = -1 or 0</text>
                            <text x="0" y="75" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(n) | Space: O(h)</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderPathSum() {
            return `
                <div class="tree-viz-section">
                    <h4>Path Sum Problem</h4>
                    <p class="viz-description">Find if there's a root-to-leaf path with target sum. Real-world: Budget allocation, cost analysis</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- Tree -->
                        <circle cx="400" cy="80" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                        
                        <line x1="400" y1="110" x2="250" y2="160" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="110" x2="550" y2="160" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        
                        <circle cx="550" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">8</text>
                        
                        <line x1="250" y1="210" x2="150" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="210" x2="350" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="210" x2="650" y2="260" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="150" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">11</text>
                        
                        <circle cx="350" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">13</text>
                        
                        <circle cx="650" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="650" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        
                        <!-- Highlight path with sum 22 -->
                        <circle cx="400" cy="80" r="35" fill="none" stroke="#4CAF50" stroke-width="4"/>
                        <circle cx="250" cy="180" r="35" fill="none" stroke="#4CAF50" stroke-width="4"/>
                        <circle cx="350" cy="280" r="35" fill="none" stroke="#4CAF50" stroke-width="4"/>
                        
                        <path d="M 400 115 L 250 145" stroke="#4CAF50" stroke-width="4"/>
                        <path d="M 250 215 L 350 245" stroke="#4CAF50" stroke-width="4"/>
                        
                        <!-- Sum labels -->
                        <text x="320" y="130" font-size="14" font-weight="bold" fill="#4CAF50">5</text>
                        <text x="280" y="230" font-size="14" font-weight="bold" fill="#4CAF50">5+4=9</text>
                        <text x="280" y="330" font-size="14" font-weight="bold" fill="#4CAF50">9+13=22 ✓</text>
                        
                        <!-- Target -->
                        <rect x="50" y="380" width="700" height="120" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2" rx="8"/>
                        <text x="400" y="410" text-anchor="middle" font-size="18" font-weight="bold" fill="#2E7D32">Target Sum: 22</text>
                        <text x="400" y="435" text-anchor="middle" font-size="14" fill="#388E3C">Path found: 5 → 4 → 13 = 22 ✓</text>
                        <text x="400" y="460" text-anchor="middle" font-size="14" fill="var(--text-secondary)">Algorithm: DFS with running sum</text>
                        <text x="400" y="485" text-anchor="middle" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(n) | Space: O(h)</text>
                    </svg>
                </div>
            `;
        }

        renderLCA() {
            return `
                <div class="tree-viz-section">
                    <h4>Lowest Common Ancestor (LCA)</h4>
                    <p class="viz-description">Find the lowest common ancestor of two nodes. Real-world: Find common manager, shared resource</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- BST -->
                        <circle cx="400" cy="80" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="4"/>
                        <text x="400" y="88" text-anchor="middle" font-size="20" font-weight="bold" fill="white">6</text>
                        <text x="400" y="50" text-anchor="middle" font-size="16" font-weight="bold" fill="#FF9800">LCA(2,8)</text>
                        
                        <line x1="400" y1="110" x2="250" y2="160" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="110" x2="550" y2="160" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="180" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        
                        <circle cx="550" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">8</text>
                        
                        <line x1="250" y1="210" x2="150" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="210" x2="350" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="210" x2="450" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="210" x2="650" y2="260" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="280" r="25" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                        <text x="150" y="287" text-anchor="middle" font-size="16" font-weight="bold" fill="#1976D2">0</text>
                        
                        <circle cx="350" cy="280" r="25" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                        <text x="350" y="287" text-anchor="middle" font-size="16" font-weight="bold" fill="#1976D2">4</text>
                        
                        <circle cx="450" cy="280" r="25" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2"/>
                        <text x="450" y="287" text-anchor="middle" font-size="16" font-weight="bold" fill="#2E7D32">7</text>
                        
                        <circle cx="650" cy="280" r="25" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2"/>
                        <text x="650" y="287" text-anchor="middle" font-size="16" font-weight="bold" fill="#2E7D32">9</text>
                        
                        <!-- Highlight nodes -->
                        <circle cx="250" cy="180" r="35" fill="none" stroke="#2196F3" stroke-width="4" stroke-dasharray="5,5"/>
                        <circle cx="550" cy="180" r="35" fill="none" stroke="#4CAF50" stroke-width="4" stroke-dasharray="5,5"/>
                        
                        <!-- Explanation -->
                        <g transform="translate(50, 350)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Finding LCA(2, 8):</text>
                            <text x="0" y="30" font-size="14" fill="var(--text-secondary)">1. Start at root (6)</text>
                            <text x="0" y="50" font-size="14" fill="var(--text-secondary)">2. Is 2 < 6 < 8? YES!</text>
                            <text x="0" y="70" font-size="14" fill="var(--text-secondary)">3. Node 6 is the split point → LCA = 6</text>
                            <text x="0" y="100" font-size="14" font-weight="bold" fill="#FF9800">Answer: 6 is the lowest common ancestor</text>
                            <text x="0" y="130" font-size="14" fill="var(--text-secondary)">BST property: If p < root < q, root is LCA</text>
                            <text x="0" y="155" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(h) | Space: O(1)</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderSymmetric() {
            return `
                <div class="tree-viz-section">
                    <h4>Symmetric Tree</h4>
                    <p class="viz-description">Check if tree is a mirror of itself. Real-world: Design validation, pattern matching</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- Symmetric tree -->
                        <circle cx="400" cy="80" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                        
                        <line x1="400" y1="110" x2="250" y2="160" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="110" x2="550" y2="160" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        
                        <circle cx="550" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        
                        <line x1="250" y1="210" x2="150" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="210" x2="350" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="210" x2="450" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="210" x2="650" y2="260" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="150" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                        
                        <circle cx="350" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        
                        <circle cx="450" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="450" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        
                        <circle cx="650" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="650" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                        
                        <!-- Mirror line -->
                        <line x1="400" y1="50" x2="400" y2="320" stroke="#9C27B0" stroke-width="3" stroke-dasharray="10,5"/>
                        <text x="410" y="200" font-size="14" font-weight="bold" fill="#9C27B0">Mirror</text>
                        
                        <!-- Matching pairs -->
                        <path d="M 150 250 Q 400 200 650 250" fill="none" stroke="#4CAF50" stroke-width="2" stroke-dasharray="5,5"/>
                        <text x="400" y="220" text-anchor="middle" font-size="12" fill="#4CAF50">3 ↔ 3</text>
                        
                        <path d="M 350 250 Q 400 220 450 250" fill="none" stroke="#4CAF50" stroke-width="2" stroke-dasharray="5,5"/>
                        <text x="400" y="240" text-anchor="middle" font-size="12" fill="#4CAF50">4 ↔ 4</text>
                        
                        <!-- Explanation -->
                        <g transform="translate(50, 360)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Checking Symmetry:</text>
                            <text x="0" y="30" font-size="14" fill="var(--text-secondary)">1. Compare left subtree with right subtree</text>
                            <text x="0" y="50" font-size="14" fill="var(--text-secondary)">2. Left.left must equal Right.right</text>
                            <text x="0" y="70" font-size="14" fill="var(--text-secondary)">3. Left.right must equal Right.left</text>
                            <text x="0" y="100" font-size="14" font-weight="bold" fill="#4CAF50">This tree is symmetric! ✓</text>
                            <text x="0" y="130" font-size="14" fill="var(--text-secondary)">Algorithm: Recursive mirror check</text>
                            <text x="0" y="155" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(n) | Space: O(h)</text>
                        </g>
                    </svg>
                </div>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new TreeProblemsViz('treeProblemsVisualization');
        });
    } else {
        new TreeProblemsViz('treeProblemsVisualization');
    }
})();
