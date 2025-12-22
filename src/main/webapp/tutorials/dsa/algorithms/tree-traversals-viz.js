/**
 * Tree Traversals SVG Visualization
 * Shows different traversal orders with numbered steps
 */

(function () {
    'use strict';

    class TreeTraversalsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'inorder';
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
                    <h3>Tree Traversal Orders</h3>
                    <p class="viz-subtitle">See the order nodes are visited in each traversal</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'inorder' ? 'active' : ''}" data-view="inorder">
                        📖 Inorder
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'preorder' ? 'active' : ''}" data-view="preorder">
                        📝 Preorder
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'postorder' ? 'active' : ''}" data-view="postorder">
                        📋 Postorder
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'levelorder' ? 'active' : ''}" data-view="levelorder">
                        🔄 Level-order
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'inorder':
                    return this.renderInorder();
                case 'preorder':
                    return this.renderPreorder();
                case 'postorder':
                    return this.renderPostorder();
                case 'levelorder':
                    return this.renderLevelOrder();
                default:
                    return '';
            }
        }

        renderInorder() {
            return `
                <div class="tree-viz-section">
                    <h4>Inorder Traversal: Left → Root → Right</h4>
                    <p class="viz-description">Visit left subtree, then root, then right subtree. For BST, gives sorted order!</p>
                    
                    <svg viewBox="0 0 800 500" class="tree-svg">
                        ${this.renderTree([4, 2, 5, 1, 6, 3, 7])}
                        
                        <!-- Order arrows -->
                        <path d="M 150 280 Q 200 320 250 280" fill="none" stroke="#4CAF50" stroke-width="3" marker-end="url(#arrow-green)"/>
                        <path d="M 250 180 Q 300 220 350 280" fill="none" stroke="#4CAF50" stroke-width="3" marker-end="url(#arrow-green)"/>
                        <path d="M 350 280 Q 375 200 400 100" fill="none" stroke="#4CAF50" stroke-width="3" marker-end="url(#arrow-green)"/>
                        <path d="M 400 100 Q 475 200 550 180" fill="none" stroke="#4CAF50" stroke-width="3" marker-end="url(#arrow-green)"/>
                        <path d="M 550 180 Q 575 230 600 280" fill="none" stroke="#4CAF50" stroke-width="3" marker-end="url(#arrow-green)"/>
                        <path d="M 600 280 Q 625 230 650 280" fill="none" stroke="#4CAF50" stroke-width="3" marker-end="url(#arrow-green)"/>
                        
                        <defs>
                            <marker id="arrow-green" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#4CAF50"/>
                            </marker>
                        </defs>
                        
                        <!-- Result -->
                        <g transform="translate(50, 400)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Visit Order: 4 → 2 → 5 → 1 → 6 → 3 → 7</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">Use case: Get sorted values from BST</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderPreorder() {
            return `
                <div class="tree-viz-section">
                    <h4>Preorder Traversal: Root → Left → Right</h4>
                    <p class="viz-description">Visit root first, then left subtree, then right subtree. Used to copy trees!</p>
                    
                    <svg viewBox="0 0 800 500" class="tree-svg">
                        ${this.renderTree([1, 2, 4, 5, 3, 6, 7])}
                        
                        <!-- Order arrows -->
                        <path d="M 400 100 Q 325 140 250 180" fill="none" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-blue)"/>
                        <path d="M 250 180 Q 200 230 150 280" fill="none" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-blue)"/>
                        <path d="M 150 280 Q 250 280 350 280" fill="none" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-blue)"/>
                        <path d="M 350 280 Q 425 230 550 180" fill="none" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-blue)"/>
                        <path d="M 550 180 Q 575 230 600 280" fill="none" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-blue)"/>
                        <path d="M 600 280 Q 625 280 650 280" fill="none" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-blue)"/>
                        
                        <defs>
                            <marker id="arrow-blue" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#2196F3"/>
                            </marker>
                        </defs>
                        
                        <!-- Result -->
                        <g transform="translate(50, 400)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Visit Order: 1 → 2 → 4 → 5 → 3 → 6 → 7</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">Use case: Copy tree, create prefix expression</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderPostorder() {
            return `
                <div class="tree-viz-section">
                    <h4>Postorder Traversal: Left → Right → Root</h4>
                    <p class="viz-description">Visit left subtree, then right subtree, then root. Used to delete trees!</p>
                    
                    <svg viewBox="0 0 800 500" class="tree-svg">
                        ${this.renderTree([4, 5, 2, 6, 7, 3, 1])}
                        
                        <!-- Order arrows -->
                        <path d="M 150 280 Q 200 280 250 180" fill="none" stroke="#FF9800" stroke-width="3" marker-end="url(#arrow-orange)"/>
                        <path d="M 250 180 Q 300 230 350 280" fill="none" stroke="#FF9800" stroke-width="3" marker-end="url(#arrow-orange)"/>
                        <path d="M 350 280 Q 450 230 550 180" fill="none" stroke="#FF9800" stroke-width="3" marker-end="url(#arrow-orange)"/>
                        <path d="M 550 180 Q 575 230 600 280" fill="none" stroke="#FF9800" stroke-width="3" marker-end="url(#arrow-orange)"/>
                        <path d="M 600 280 Q 625 280 650 280" fill="none" stroke="#FF9800" stroke-width="3" marker-end="url(#arrow-orange)"/>
                        <path d="M 650 280 Q 525 200 400 100" fill="none" stroke="#FF9800" stroke-width="3" marker-end="url(#arrow-orange)"/>
                        
                        <defs>
                            <marker id="arrow-orange" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#FF9800"/>
                            </marker>
                        </defs>
                        
                        <!-- Result -->
                        <g transform="translate(50, 400)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Visit Order: 4 → 5 → 2 → 6 → 7 → 3 → 1</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">Use case: Delete tree, evaluate postfix expression</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderLevelOrder() {
            return `
                <div class="tree-viz-section">
                    <h4>Level-order Traversal (BFS)</h4>
                    <p class="viz-description">Visit nodes level by level, left to right. Uses a queue!</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        ${this.renderTree([1, 2, 3, 4, 5, 6, 7])}
                        
                        <!-- Level indicators -->
                        <rect x="380" y="70" width="40" height="60" fill="none" stroke="#9C27B0" stroke-width="3" stroke-dasharray="5,5" rx="5"/>
                        <text x="320" y="105" font-size="14" font-weight="bold" fill="#9C27B0">Level 0</text>
                        
                        <rect x="230" y="150" width="340" height="60" fill="none" stroke="#9C27B0" stroke-width="3" stroke-dasharray="5,5" rx="5"/>
                        <text x="150" y="185" font-size="14" font-weight="bold" fill="#9C27B0">Level 1</text>
                        
                        <rect x="130" y="250" width="540" height="60" fill="none" stroke="#9C27B0" stroke-width="3" stroke-dasharray="5,5" rx="5"/>
                        <text x="50" y="285" font-size="14" font-weight="bold" fill="#9C27B0">Level 2</text>
                        
                        <!-- Arrows showing order -->
                        <path d="M 420 100 L 240 180" fill="none" stroke="#E91E63" stroke-width="2" marker-end="url(#arrow-pink)"/>
                        <path d="M 260 180 L 540 180" fill="none" stroke="#E91E63" stroke-width="2" marker-end="url(#arrow-pink)"/>
                        <path d="M 560 180 L 140 280" fill="none" stroke="#E91E63" stroke-width="2" marker-end="url(#arrow-pink)"/>
                        <path d="M 160 280 L 340 280" fill="none" stroke="#E91E63" stroke-width="2" marker-end="url(#arrow-pink)"/>
                        <path d="M 360 280 L 590 280" fill="none" stroke="#E91E63" stroke-width="2" marker-end="url(#arrow-pink)"/>
                        <path d="M 610 280 L 640 280" fill="none" stroke="#E91E63" stroke-width="2" marker-end="url(#arrow-pink)"/>
                        
                        <defs>
                            <marker id="arrow-pink" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#E91E63"/>
                            </marker>
                        </defs>
                        
                        <!-- Result -->
                        <g transform="translate(50, 450)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Visit Order: 1 → 2 → 3 → 4 → 5 → 6 → 7</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">Use case: Find shortest path, serialize tree</text>
                            <text x="0" y="45" font-size="14" fill="#9C27B0" font-weight="bold">Uses Queue (FIFO) instead of recursion!</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderTree(visitOrder) {
            // Render the same tree structure with numbered visit order
            return `
                <!-- Tree structure -->
                <circle cx="400" cy="100" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="400" y="108" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                <text x="400" y="60" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">${visitOrder[0]}</text>
                
                <line x1="400" y1="130" x2="250" y2="170" stroke="#666" stroke-width="2"/>
                <line x1="400" y1="130" x2="550" y2="170" stroke="#666" stroke-width="2"/>
                
                <circle cx="250" cy="190" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="250" y="198" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                <text x="250" y="150" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">${visitOrder[1]}</text>
                
                <circle cx="550" cy="190" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="550" y="198" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                <text x="550" y="150" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">${visitOrder[4]}</text>
                
                <line x1="250" y1="220" x2="150" y2="270" stroke="#666" stroke-width="2"/>
                <line x1="250" y1="220" x2="350" y2="270" stroke="#666" stroke-width="2"/>
                <line x1="550" y1="220" x2="600" y2="270" stroke="#666" stroke-width="2"/>
                <line x1="550" y1="220" x2="650" y2="270" stroke="#666" stroke-width="2"/>
                
                <circle cx="150" cy="290" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="150" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                <text x="150" y="340" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">${visitOrder[2]}</text>
                
                <circle cx="350" cy="290" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="350" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                <text x="350" y="340" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">${visitOrder[3]}</text>
                
                <circle cx="600" cy="290" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="600" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">6</text>
                <text x="600" y="340" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">${visitOrder[5]}</text>
                
                <circle cx="650" cy="290" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="650" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">7</text>
                <text x="650" y="340" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">${visitOrder[6]}</text>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new TreeTraversalsViz('treeTraversalsVisualization');
        });
    } else {
        new TreeTraversalsViz('treeTraversalsVisualization');
    }
})();
