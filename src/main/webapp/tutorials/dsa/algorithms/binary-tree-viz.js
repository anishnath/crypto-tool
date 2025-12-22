/**
 * Binary Tree SVG Visualization
 * Static SVG diagrams showing tree concepts
 */

(function () {
    'use strict';

    class BinaryTreeViz {
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
                    <h3>Binary Tree Concepts</h3>
                    <p class="viz-subtitle">Click each tab to explore different aspects</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'structure' ? 'active' : ''}" data-view="structure">
                        🌳 Tree Structure
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'types' ? 'active' : ''}" data-view="types">
                        📊 Tree Types
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'terminology' ? 'active' : ''}" data-view="terminology">
                        📖 Terminology
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
                    return this.renderTreeStructure();
                case 'types':
                    return this.renderTreeTypes();
                case 'terminology':
                    return this.renderTerminology();
                default:
                    return '';
            }
        }

        renderTreeStructure() {
            return `
                <div class="tree-viz-section">
                    <h4>Binary Tree Structure</h4>
                    <p class="viz-description">Each node has at most 2 children: left and right</p>
                    
                    <svg viewBox="0 0 800 500" class="tree-svg">
                        <!-- Root Node -->
                        <circle cx="400" cy="60" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="400" y="68" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                        <text x="400" y="30" text-anchor="middle" font-size="14" fill="var(--text-primary)">Root</text>
                        
                        <!-- Level 1 -->
                        <line x1="400" y1="90" x2="250" y2="140" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="90" x2="550" y2="140" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="160" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="168" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        
                        <circle cx="550" cy="160" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="168" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                        
                        <!-- Level 2 -->
                        <line x1="250" y1="190" x2="150" y2="240" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="190" x2="350" y2="240" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="190" x2="450" y2="240" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="190" x2="650" y2="240" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="260" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="150" y="268" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        <text x="150" y="310" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Leaf</text>
                        
                        <circle cx="350" cy="260" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="268" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                        <text x="350" y="310" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Leaf</text>
                        
                        <circle cx="450" cy="260" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="450" y="268" text-anchor="middle" font-size="20" font-weight="bold" fill="white">6</text>
                        <text x="450" y="310" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Leaf</text>
                        
                        <circle cx="650" cy="260" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="650" y="268" text-anchor="middle" font-size="20" font-weight="bold" fill="white">7</text>
                        <text x="650" y="310" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Leaf</text>
                        
                        <!-- Labels -->
                        <text x="50" y="60" font-size="14" fill="var(--text-secondary)">Level 0 (Root)</text>
                        <text x="50" y="160" font-size="14" fill="var(--text-secondary)">Level 1</text>
                        <text x="50" y="260" font-size="14" fill="var(--text-secondary)">Level 2 (Leaves)</text>
                        
                        <!-- Legend -->
                        <g transform="translate(50, 380)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Properties:</text>
                            <text x="0" y="25" font-size="13" fill="var(--text-secondary)">• Height = 2 (longest path from root to leaf)</text>
                            <text x="0" y="45" font-size="13" fill="var(--text-secondary)">• Size = 7 nodes</text>
                            <text x="0" y="65" font-size="13" fill="var(--text-secondary)">• Each node has at most 2 children</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderTreeTypes() {
            return `
                <div class="tree-viz-section">
                    <h4>Types of Binary Trees</h4>
                    <p class="viz-description">Different classifications based on structure</p>
                    
                    <svg viewBox="0 0 800 700" class="tree-svg">
                        <!-- Full Binary Tree -->
                        <g transform="translate(100, 50)">
                            <text x="100" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Full Binary Tree</text>
                            <text x="100" y="20" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Every node has 0 or 2 children</text>
                            
                            <circle cx="100" cy="60" r="20" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="100" y="66" text-anchor="middle" font-size="14" font-weight="bold" fill="white">1</text>
                            
                            <line x1="100" y1="80" x2="60" y2="110" stroke="#666" stroke-width="2"/>
                            <line x1="100" y1="80" x2="140" y2="110" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="60" cy="120" r="20" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="60" y="126" text-anchor="middle" font-size="14" font-weight="bold" fill="white">2</text>
                            
                            <circle cx="140" cy="120" r="20" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="140" y="126" text-anchor="middle" font-size="14" font-weight="bold" fill="white">3</text>
                            
                            <line x1="60" y1="140" x2="40" y2="170" stroke="#666" stroke-width="2"/>
                            <line x1="60" y1="140" x2="80" y2="170" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="40" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="40" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">4</text>
                            
                            <circle cx="80" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="80" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">5</text>
                        </g>
                        
                        <!-- Complete Binary Tree -->
                        <g transform="translate(400, 50)">
                            <text x="100" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Complete Binary Tree</text>
                            <text x="100" y="20" text-anchor="middle" font-size="12" fill="var(--text-secondary)">All levels filled except last</text>
                            
                            <circle cx="100" cy="60" r="20" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="100" y="66" text-anchor="middle" font-size="14" font-weight="bold" fill="white">1</text>
                            
                            <line x1="100" y1="80" x2="60" y2="110" stroke="#666" stroke-width="2"/>
                            <line x1="100" y1="80" x2="140" y2="110" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="60" cy="120" r="20" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="60" y="126" text-anchor="middle" font-size="14" font-weight="bold" fill="white">2</text>
                            
                            <circle cx="140" cy="120" r="20" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="140" y="126" text-anchor="middle" font-size="14" font-weight="bold" fill="white">3</text>
                            
                            <line x1="60" y1="140" x2="40" y2="170" stroke="#666" stroke-width="2"/>
                            <line x1="60" y1="140" x2="80" y2="170" stroke="#666" stroke-width="2"/>
                            <line x1="140" y1="140" x2="120" y2="170" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="40" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="40" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">4</text>
                            
                            <circle cx="80" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="80" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">5</text>
                            
                            <circle cx="120" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="120" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">6</text>
                        </g>
                        
                        <!-- Perfect Binary Tree -->
                        <g transform="translate(250, 350)">
                            <text x="150" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Perfect Binary Tree</text>
                            <text x="150" y="20" text-anchor="middle" font-size="12" fill="var(--text-secondary)">All leaves at same level</text>
                            
                            <circle cx="150" cy="60" r="20" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="150" y="66" text-anchor="middle" font-size="14" font-weight="bold" fill="white">1</text>
                            
                            <line x1="150" y1="80" x2="100" y2="110" stroke="#666" stroke-width="2"/>
                            <line x1="150" y1="80" x2="200" y2="110" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="100" cy="120" r="20" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="100" y="126" text-anchor="middle" font-size="14" font-weight="bold" fill="white">2</text>
                            
                            <circle cx="200" cy="120" r="20" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="200" y="126" text-anchor="middle" font-size="14" font-weight="bold" fill="white">3</text>
                            
                            <line x1="100" y1="140" x2="75" y2="170" stroke="#666" stroke-width="2"/>
                            <line x1="100" y1="140" x2="125" y2="170" stroke="#666" stroke-width="2"/>
                            <line x1="200" y1="140" x2="175" y2="170" stroke="#666" stroke-width="2"/>
                            <line x1="200" y1="140" x2="225" y2="170" stroke="#666" stroke-width="2"/>
                            
                            <circle cx="75" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="75" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">4</text>
                            
                            <circle cx="125" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="125" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">5</text>
                            
                            <circle cx="175" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="175" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">6</text>
                            
                            <circle cx="225" cy="180" r="20" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="225" y="186" text-anchor="middle" font-size="14" font-weight="bold" fill="white">7</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderTerminology() {
            return `
                <div class="tree-viz-section">
                    <h4>Tree Terminology</h4>
                    <p class="viz-description">Important terms to understand</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- Tree with labels -->
                        <circle cx="400" cy="80" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="20" font-weight="bold" fill="white">A</text>
                        <text x="400" y="40" text-anchor="middle" font-size="14" font-weight="bold" fill="#2196F3">ROOT</text>
                        <text x="400" y="55" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Depth = 0</text>
                        
                        <line x1="400" y1="110" x2="250" y2="160" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="110" x2="550" y2="160" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="250" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">B</text>
                        <text x="180" y="188" text-anchor="end" font-size="12" fill="var(--text-secondary)">Depth = 1</text>
                        
                        <circle cx="550" cy="180" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="188" text-anchor="middle" font-size="20" font-weight="bold" fill="white">C</text>
                        <text x="620" y="188" text-anchor="start" font-size="12" fill="var(--text-secondary)">Depth = 1</text>
                        
                        <line x1="250" y1="210" x2="150" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="250" y1="210" x2="350" y2="260" stroke="#666" stroke-width="2"/>
                        <line x1="550" y1="210" x2="650" y2="260" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="150" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="150" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">D</text>
                        <text x="150" y="330" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF9800">LEAF</text>
                        <text x="150" y="345" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Depth = 2</text>
                        
                        <circle cx="350" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="350" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">E</text>
                        <text x="350" y="330" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF9800">LEAF</text>
                        
                        <circle cx="650" cy="280" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="650" y="288" text-anchor="middle" font-size="20" font-weight="bold" fill="white">F</text>
                        <text x="650" y="330" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF9800">LEAF</text>
                        
                        <!-- Parent-Child relationship -->
                        <path d="M 400 120 Q 325 150 250 170" fill="none" stroke="#9C27B0" stroke-width="2" stroke-dasharray="5,5"/>
                        <text x="325" y="135" text-anchor="middle" font-size="12" fill="#9C27B0" font-weight="bold">Parent-Child</text>
                        
                        <!-- Siblings -->
                        <path d="M 150 260 Q 250 240 350 260" fill="none" stroke="#E91E63" stroke-width="2" stroke-dasharray="5,5"/>
                        <text x="250" y="235" text-anchor="middle" font-size="12" fill="#E91E63" font-weight="bold">Siblings</text>
                        
                        <!-- Height indicator -->
                        <line x1="720" y1="80" x2="720" y2="280" stroke="#FF5722" stroke-width="3"/>
                        <text x="750" y="180" font-size="14" font-weight="bold" fill="#FF5722">Height = 2</text>
                        
                        <!-- Definitions -->
                        <g transform="translate(50, 400)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Definitions:</text>
                            <text x="0" y="25" font-size="13" fill="var(--text-secondary)"><tspan font-weight="bold">Root:</tspan> Top node (no parent)</text>
                            <text x="0" y="45" font-size="13" fill="var(--text-secondary)"><tspan font-weight="bold">Leaf:</tspan> Node with no children</text>
                            <text x="0" y="65" font-size="13" fill="var(--text-secondary)"><tspan font-weight="bold">Parent:</tspan> Node with children</text>
                            <text x="0" y="85" font-size="13" fill="var(--text-secondary)"><tspan font-weight="bold">Child:</tspan> Node connected below parent</text>
                            <text x="0" y="105" font-size="13" fill="var(--text-secondary)"><tspan font-weight="bold">Siblings:</tspan> Nodes with same parent</text>
                            <text x="0" y="125" font-size="13" fill="var(--text-secondary)"><tspan font-weight="bold">Depth:</tspan> Distance from root to node</text>
                            <text x="0" y="145" font-size="13" fill="var(--text-secondary)"><tspan font-weight="bold">Height:</tspan> Longest path from root to leaf</text>
                        </g>
                    </svg>
                </div>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new BinaryTreeViz('binaryTreeVisualization');
        });
    } else {
        new BinaryTreeViz('binaryTreeVisualization');
    }
})();
