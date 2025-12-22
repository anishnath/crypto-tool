/**
 * Binary Search Tree SVG Visualization
 * Shows BST property and operations
 */

(function () {
    'use strict';

    class BSTViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'property';
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
                    <h3>Binary Search Tree Operations</h3>
                    <p class="viz-subtitle">Explore BST property and operations</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'property' ? 'active' : ''}" data-view="property">
                        📐 BST Property
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'search' ? 'active' : ''}" data-view="search">
                        🔍 Search
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'insert' ? 'active' : ''}" data-view="insert">
                        ➕ Insert
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'delete' ? 'active' : ''}" data-view="delete">
                        🗑️ Delete
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'property':
                    return this.renderBSTProperty();
                case 'search':
                    return this.renderSearch();
                case 'insert':
                    return this.renderInsert();
                case 'delete':
                    return this.renderDelete();
                default:
                    return '';
            }
        }

        renderBSTProperty() {
            return `
                <div class="tree-viz-section">
                    <h4>BST Property: Left < Root < Right</h4>
                    <p class="viz-description">Every node follows this rule: all left descendants are smaller, all right descendants are larger</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- Root -->
                        <circle cx="400" cy="100" r="35" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="400" y="110" text-anchor="middle" font-size="24" font-weight="bold" fill="white">50</text>
                        
                        <!-- Level 1 -->
                        <line x1="400" y1="135" x2="250" y2="175" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="135" x2="550" y2="175" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="200" r="35" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="210" text-anchor="middle" font-size="24" font-weight="bold" fill="white">30</text>
                        <text x="250" y="160" text-anchor="middle" font-size="14" fill="#4CAF50" font-weight="bold">30 < 50 ✓</text>
                        
                        <circle cx="550" cy="200" r="35" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="210" text-anchor="middle" font-size="24" font-weight="bold" fill="white">70</text>
                        <text x="550" y="160" text-anchor="middle" font-size="14" fill="#4CAF50" font-weight="bold">70 > 50 ✓</text>
                        
                        <!-- Level 2 -->
                        <line x1="250" y1="235" x2="150" y2="275" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="235" x2="350" y2="275" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="235" x2="450" y2="275" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="235" x2="650" y2="275" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="150" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">20</text>
                        <text x="150" y="355" text-anchor="middle" font-size="12" fill="var(--text-secondary)">20 < 30 < 50</text>
                        
                        <circle cx="350" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">40</text>
                        <text x="350" y="355" text-anchor="middle" font-size="12" fill="var(--text-secondary)">30 < 40 < 50</text>
                        
                        <circle cx="450" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="450" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">60</text>
                        <text x="450" y="355" text-anchor="middle" font-size="12" fill="var(--text-secondary)">50 < 60 < 70</text>
                        
                        <circle cx="650" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="650" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">80</text>
                        <text x="650" y="355" text-anchor="middle" font-size="12" fill="var(--text-secondary)">50 < 70 < 80</text>
                        
                        <!-- Property boxes -->
                        <rect x="50" y="420" width="300" height="100" fill="#E3F2FD" stroke="#2196F3" stroke-width="2" rx="8"/>
                        <text x="200" y="445" text-anchor="middle" font-size="16" font-weight="bold" fill="#1976D2">Left Subtree</text>
                        <text x="200" y="470" text-anchor="middle" font-size="14" fill="#1565C0">All values < 50</text>
                        <text x="200" y="495" text-anchor="middle" font-size="14" fill="#1565C0">{20, 30, 40}</text>
                        
                        <rect x="450" y="420" width="300" height="100" fill="#FFF3E0" stroke="#FF9800" stroke-width="2" rx="8"/>
                        <text x="600" y="445" text-anchor="middle" font-size="16" font-weight="bold" fill="#E65100">Right Subtree</text>
                        <text x="600" y="470" text-anchor="middle" font-size="14" fill="#EF6C00">All values > 50</text>
                        <text x="600" y="495" text-anchor="middle" font-size="14" fill="#EF6C00">{60, 70, 80}</text>
                    </svg>
                </div>
            `;
        }

        renderSearch() {
            return `
                <div class="tree-viz-section">
                    <h4>Searching for 60 in BST</h4>
                    <p class="viz-description">Compare and go left or right - O(log n) in balanced tree!</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        ${this.renderBSTStructure()}
                        
                        <!-- Search path -->
                        <circle cx="400" cy="100" r="40" fill="none" stroke="#4CAF50" stroke-width="4"/>
                        <text x="320" y="105" font-size="14" font-weight="bold" fill="#4CAF50">① 60 > 50</text>
                        
                        <circle cx="550" cy="200" r="40" fill="none" stroke="#4CAF50" stroke-width="4"/>
                        <text x="580" y="205" font-size="14" font-weight="bold" fill="#4CAF50">② 60 < 70</text>
                        
                        <circle cx="450" cy="300" r="40" fill="none" stroke="#4CAF50" stroke-width="4"/>
                        <text x="480" y="340" font-size="14" font-weight="bold" fill="#4CAF50">③ Found!</text>
                        
                        <!-- Path arrows -->
                        <path d="M 400 140 L 550 160" stroke="#4CAF50" stroke-width="4" marker-end="url(#arrow-search)"/>
                        <path d="M 550 240 L 450 260" stroke="#4CAF50" stroke-width="4" marker-end="url(#arrow-search)"/>
                        
                        <defs>
                            <marker id="arrow-search" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#4CAF50"/>
                            </marker>
                        </defs>
                        
                        <!-- Steps -->
                        <g transform="translate(50, 420)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Search Steps:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">1. Start at root (50): 60 > 50 → go right</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">2. At node (70): 60 < 70 → go left</text>
                            <text x="0" y="65" font-size="14" fill="var(--text-secondary)">3. At node (60): Found! ✓</text>
                            <text x="0" y="90" font-size="14" font-weight="bold" fill="#4CAF50">Comparisons: 3 (O(log n))</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderInsert() {
            return `
                <div class="tree-viz-section">
                    <h4>Inserting 65 into BST</h4>
                    <p class="viz-description">Find correct position maintaining BST property</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        ${this.renderBSTStructure()}
                        
                        <!-- Insert path -->
                        <circle cx="400" cy="100" r="40" fill="none" stroke="#2196F3" stroke-width="4"/>
                        <text x="320" y="105" font-size="14" font-weight="bold" fill="#2196F3">① 65 > 50</text>
                        
                        <circle cx="550" cy="200" r="40" fill="none" stroke="#2196F3" stroke-width="4"/>
                        <text x="580" y="205" font-size="14" font-weight="bold" fill="#2196F3">② 65 < 70</text>
                        
                        <circle cx="450" cy="300" r="40" fill="none" stroke="#2196F3" stroke-width="4"/>
                        <text x="480" y="340" font-size="14" font-weight="bold" fill="#2196F3">③ 65 > 60</text>
                        
                        <!-- New node -->
                        <line x1="450" y1="335" x2="500" y2="385" stroke="#666" stroke-width="2" stroke-dasharray="5,5"/>
                        <circle cx="500" cy="400" r="35" fill="#FF5722" stroke="#D32F2F" stroke-width="4"/>
                        <text x="500" y="410" text-anchor="middle" font-size="24" font-weight="bold" fill="white">65</text>
                        <text x="500" y="450" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">④ Insert here!</text>
                        
                        <!-- Path arrows -->
                        <path d="M 400 140 L 550 160" stroke="#2196F3" stroke-width="4" marker-end="url(#arrow-insert)"/>
                        <path d="M 550 240 L 450 260" stroke="#2196F3" stroke-width="4" marker-end="url(#arrow-insert)"/>
                        <path d="M 450 340 L 500 360" stroke="#2196F3" stroke-width="4" marker-end="url(#arrow-insert)"/>
                        
                        <defs>
                            <marker id="arrow-insert" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#2196F3"/>
                            </marker>
                        </defs>
                        
                        <!-- Steps -->
                        <g transform="translate(50, 500)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Insert Steps:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">1. 65 > 50 → go right</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">2. 65 < 70 → go left</text>
                            <text x="0" y="65" font-size="14" fill="var(--text-secondary)">3. 65 > 60 → go right (null)</text>
                            <text x="0" y="85" font-size="14" font-weight="bold" fill="#FF5722">4. Insert 65 as right child of 60</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderDelete() {
            return `
                <div class="tree-viz-section">
                    <h4>Delete Cases in BST</h4>
                    <p class="viz-description">Three cases: leaf, one child, two children</p>
                    
                    <svg viewBox="0 0 800 700" class="tree-svg">
                        <!-- Case 1: Delete Leaf -->
                        <g transform="translate(50, 30)">
                            <text x="100" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Case 1: Delete Leaf (20)</text>
                            <circle cx="100" cy="40" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="100" y="47" text-anchor="middle" font-size="16" font-weight="bold" fill="white">30</text>
                            <line x1="100" y1="65" x2="70" y2="95" stroke="#666" stroke-width="2"/>
                            <circle cx="70" cy="110" r="25" fill="#F44336" stroke="#C62828" stroke-width="3"/>
                            <text x="70" y="117" text-anchor="middle" font-size="16" font-weight="bold" fill="white">20</text>
                            <text x="70" y="150" text-anchor="middle" font-size="12" fill="#F44336" font-weight="bold">Simply remove</text>
                        </g>
                        
                        <!-- Case 2: Delete One Child -->
                        <g transform="translate(300, 30)">
                            <text x="100" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Case 2: One Child (30)</text>
                            <circle cx="100" cy="40" r="25" fill="#F44336" stroke="#C62828" stroke-width="3"/>
                            <text x="100" y="47" text-anchor="middle" font-size="16" font-weight="bold" fill="white">30</text>
                            <line x1="100" y1="65" x2="100" y2="95" stroke="#666" stroke-width="2"/>
                            <circle cx="100" cy="110" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="100" y="117" text-anchor="middle" font-size="16" font-weight="bold" fill="white">40</text>
                            <text x="100" y="150" text-anchor="middle" font-size="12" fill="#4CAF50" font-weight="bold">Replace with child</text>
                        </g>
                        
                        <!-- Case 3: Delete Two Children -->
                        <g transform="translate(200, 250)">
                            <text x="200" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Case 3: Two Children (50)</text>
                            
                            <circle cx="200" cy="50" r="30" fill="#F44336" stroke="#C62828" stroke-width="3"/>
                            <text x="200" y="58" text-anchor="middle" font-size="20" font-weight="bold" fill="white">50</text>
                            
                            <line x1="200" y1="80" x2="120" y2="120" stroke="#666" stroke-width="2"/>
                            <line x1="200" y1="80" x2="280" y2="120" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="120" cy="140" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="120" y="147" text-anchor="middle" font-size="16" font-weight="bold" fill="white">30</text>
                            
                            <circle cx="280" cy="140" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="280" y="147" text-anchor="middle" font-size="16" font-weight="bold" fill="white">70</text>
                            
                            <line x1="280" y1="165" x2="250" y2="195" stroke="#666" stroke-width="2"/>
                            <circle cx="250" cy="210" r="25" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                            <text x="250" y="217" text-anchor="middle" font-size="16" font-weight="bold" fill="white">60</text>
                            <text x="250" y="250" text-anchor="middle" font-size="12" fill="#FF9800" font-weight="bold">Successor</text>
                            
                            <!-- Arrow showing replacement -->
                            <path d="M 250 185 Q 225 115 200 80" fill="none" stroke="#FF9800" stroke-width="3" stroke-dasharray="5,5" marker-end="url(#arrow-replace)"/>
                            
                            <defs>
                                <marker id="arrow-replace" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                    <polygon points="0 0, 10 3, 0 6" fill="#FF9800"/>
                                </marker>
                            </defs>
                            
                            <text x="200" y="300" text-anchor="middle" font-size="14" fill="var(--text-secondary)">1. Find successor (min in right subtree)</text>
                            <text x="200" y="320" text-anchor="middle" font-size="14" fill="var(--text-secondary)">2. Replace 50 with 60</text>
                            <text x="200" y="340" text-anchor="middle" font-size="14" fill="var(--text-secondary)">3. Delete successor from original position</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderBSTStructure() {
            return `
                <!-- BST Structure: 50, 30, 70, 20, 40, 60, 80 -->
                <circle cx="400" cy="100" r="35" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="400" y="110" text-anchor="middle" font-size="24" font-weight="bold" fill="white">50</text>
                
                <line x1="400" y1="135" x2="250" y2="175" stroke="#666" stroke-width="2"/>
                <line x1="400" y1="135" x2="550" y2="175" stroke="#666" stroke-width="2"/>
                
                <circle cx="250" cy="200" r="35" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="250" y="210" text-anchor="middle" font-size="24" font-weight="bold" fill="white">30</text>
                
                <circle cx="550" cy="200" r="35" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="550" y="210" text-anchor="middle" font-size="24" font-weight="bold" fill="white">70</text>
                
                <line x1="250" y1="235" x2="150" y2="275" stroke="#666" stroke-width="2"/>
                <line x1="250" y1="235" x2="350" y2="275" stroke="#666" stroke-width="2"/>
                <line x1="550" y1="235" x2="450" y2="275" stroke="#666" stroke-width="2"/>
                <line x1="550" y1="235" x2="650" y2="275" stroke="#666" stroke-width="2"/>
                
                <circle cx="150" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="150" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">20</text>
                
                <circle cx="350" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="350" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">40</text>
                
                <circle cx="450" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="450" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">60</text>
                
                <circle cx="650" cy="300" r="35" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="650" y="310" text-anchor="middle" font-size="24" font-weight="bold" fill="white">80</text>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new BSTViz('bstVisualization');
        });
    } else {
        new BSTViz('bstVisualization');
    }
})();
