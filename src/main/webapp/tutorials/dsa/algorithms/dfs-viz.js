/**
 * DFS SVG Visualization
 * Shows DFS traversal depth-first
 */

(function () {
    'use strict';

    class DFSViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.currentView = 'traversal';
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
                    <h3>DFS Visualizations</h3>
                    <p class="viz-subtitle">Depth-first graph traversal</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'traversal' ? 'active' : ''}" data-view="traversal">🌲 DFS Traversal</button>
                    <button class="viz-tab-btn ${this.currentView === 'recursive' ? 'active' : ''}" data-view="recursive">🔁 Recursive</button>
                    <button class="viz-tab-btn ${this.currentView === 'cycle' ? 'active' : ''}" data-view="cycle">🔍 Cycle Detection</button>
                    <button class="viz-tab-btn ${this.currentView === 'stack' ? 'active' : ''}" data-view="stack">📚 Stack Process</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'traversal': return this.renderTraversal();
                case 'recursive': return this.renderRecursive();
                case 'cycle': return this.renderCycle();
                case 'stack': return this.renderStack();
                default: return '';
            }
        }

        renderTraversal() {
            return `<div class="graph-viz-section">
                <h4>DFS Traversal: Deep First</h4>
                <p class="viz-description">Goes as deep as possible before backtracking</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="300" y="0" text-anchor="middle" font-size="18" font-weight="bold">DFS Order: 0 → 1 → 3 → 4 → 2 → 5 → 6</text>
                        ${this.drawGraph()}
                        <path d="M 200 150 L 400 150 L 500 250 L 600 250 M 400 170 L 300 250 L 300 350 L 200 350" 
                              stroke="#FF5722" stroke-width="3" fill="none" stroke-dasharray="5,5"/>
                        <g transform="translate(0, 400)">
                            <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">DFS Properties</text>
                            <text x="0" y="30" font-size="14">✓ Uses stack/recursion</text>
                            <text x="0" y="50" font-size="14">✓ Explores depth before breadth</text>
                            <text x="0" y="70" font-size="14">✓ Time: O(V + E)</text>
                            <text x="0" y="90" font-size="14">✓ Perfect for maze solving, topological sort</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderRecursive() {
            return `<div class="graph-viz-section">
                <h4>Recursive DFS</h4>
                <p class="viz-description">Natural recursion explores depth first</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(50, 50)">
                        <text x="350" y="0" text-anchor="middle" font-size="16" font-weight="bold">Recursive Call Stack</text>
                        ${['dfs(0)', 'dfs(1)', 'dfs(3)', 'dfs(2)'].map((call, i) => `
                            <g transform="translate(0, ${50 + i * 100})">
                                <rect x="200" y="0" width="300" height="60" fill="${i === 0 ? '#4CAF50' : '#e3f2fd'}" 
                                      stroke="#1976d2" stroke-width="2" rx="4"/>
                                <text x="350" y="38" text-anchor="middle" font-size="16">${call}</text>
                                ${i < 3 ? '<line x1="350" y1="60" x2="350" y2="80" stroke="#666" stroke-width="2"/>' : ''}
                            </g>
                        `).join('')}
                        <text x="350" y="500" text-anchor="middle" font-size="14">Stack naturally maintains depth-first order</text>
                    </g>
                </svg>
            </div>`;
        }

        renderCycle() {
            return `<div class="graph-viz-section">
                <h4>Cycle Detection</h4>
                <p class="viz-description">Back edge detection reveals cycles</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(200, 100)">
                        <circle cx="200" cy="150" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="200" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                        <circle cx="400" cy="150" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="400" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                        <circle cx="300" cy="250" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="300" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        <line x1="230" y1="150" x2="370" y2="150" stroke="#666" stroke-width="2"/>
                        <line x1="230" y1="150" x2="270" y2="230" stroke="#666" stroke-width="2"/>
                        <line x1="370" y1="170" x2="330" y2="240" stroke="#666" stroke-width="2"/>
                        <path d="M 300 220 Q 150 200 200 120" stroke="#FF5722" stroke-width="4" fill="none" marker-end="url(#arrow-red)"/>
                        <text x="200" y="100" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">BACK EDGE = CYCLE!</text>
                        <defs><marker id="arrow-red" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#FF5722"/></marker></defs>
                    </g>
                </svg>
            </div>`;
        }

        renderStack() {
            return `<div class="graph-viz-section">
                <h4>Stack Process</h4>
                <p class="viz-description">Stack maintains depth-first order</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Stack Operations</text>
                        ${['[0]', '[2,1]', '[2,4,3]', '[2,4]'].map((s, i) => `
                            <g transform="translate(200, ${50 + i * 80})">
                                <rect x="0" y="0" width="200" height="50" fill="#e3f2fd" stroke="#1976d2" stroke-width="2" rx="4"/>
                                <text x="100" y="33" text-anchor="middle" font-size="16">${s}</text>
                                <text x="250" y="33" font-size="14">→ Pop ${i === 0 ? 0 : i === 1 ? 1 : i === 2 ? 3 : 4}</text>
                            </g>
                        `).join('')}
                    </g>
                </svg>
            </div>`;
        }

        drawGraph() {
            return `
                <circle cx="200" cy="150" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="200" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                <circle cx="400" cy="150" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="400" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                <circle cx="300" cy="250" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="300" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                <circle cx="500" cy="250" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="500" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                <line x1="230" y1="150" x2="370" y2="150" stroke="#666" stroke-width="2"/>
                <line x1="230" y1="150" x2="270" y2="230" stroke="#666" stroke-width="2"/>
                <line x1="400" y1="170" x2="310" y2="240" stroke="#666" stroke-width="2"/>
                <line x1="400" y1="170" x2="480" y2="240" stroke="#666" stroke-width="2"/>
            `;
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new DFSViz('dfsVisualization'));
    } else {
        new DFSViz('dfsVisualization');
    }
})();
