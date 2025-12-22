/**
 * Dijkstra's Algorithm SVG Visualization
 * Shows shortest path algorithm with priority queue
 */

(function () {
    'use strict';

    class DijkstraViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.currentView = 'algorithm';
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
                    <h3>Dijkstra's Algorithm Visualizations</h3>
                    <p class="viz-subtitle">Shortest path in weighted graphs</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'algorithm' ? 'active' : ''}" data-view="algorithm">🛣️ Algorithm</button>
                    <button class="viz-tab-btn ${this.currentView === 'priority' ? 'active' : ''}" data-view="priority">📋 Priority Queue</button>
                    <button class="viz-tab-btn ${this.currentView === 'shortest' ? 'active' : ''}" data-view="shortest">🗺️ Shortest Path</button>
                    <button class="viz-tab-btn ${this.currentView === 'comparison' ? 'active' : ''}" data-view="comparison">⚖️ Comparison</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'algorithm': return this.renderAlgorithm();
                case 'priority': return this.renderPriorityQueue();
                case 'shortest': return this.renderShortestPath();
                case 'comparison': return this.renderComparison();
                default: return '';
            }
        }

        renderAlgorithm() {
            return `<div class="graph-viz-section">
                <h4>Dijkstra's Algorithm Process</h4>
                <p class="viz-description">Greedy algorithm: always pick closest unvisited vertex</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="400" y="0" text-anchor="middle" font-size="18" font-weight="bold">Weighted Graph</text>
                        ${this.drawWeightedGraph()}
                        <g transform="translate(0, 400)">
                            <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Algorithm Steps</text>
                            <text x="0" y="30" font-size="14">1. Start at source (distance = 0)</text>
                            <text x="0" y="55" font-size="14">2. Add all neighbors to priority queue</text>
                            <text x="0" y="80" font-size="14">3. Extract minimum (closest vertex)</text>
                            <text x="0" y="105" font-size="14">4. Relax edges to unvisited neighbors</text>
                            <text x="0" y="130" font-size="14">5. Repeat until all vertices processed</text>
                            <text x="0" y="160" font-size="14" font-weight="bold" fill="#4CAF50">Time: O((V+E) log V) with heap</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderPriorityQueue() {
            return `<div class="graph-viz-section">
                <h4>Priority Queue Operations</h4>
                <p class="viz-description">Min heap maintains closest vertices</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(200, 100)">
                        <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Priority Queue (Min Heap)</text>
                        ${['(0,0)', '(1,4)', '(2,1)', '(3,6)'].map((item, i) => `
                            <g transform="translate(0, ${50 + i * 80})">
                                <rect x="0" y="0" width="600" height="60" fill="#e3f2fd" stroke="#1976d2" stroke-width="2" rx="4"/>
                                <text x="50" y="38" font-size="16">${item}</text>
                                <text x="200" y="38" font-size="14" fill="var(--text-secondary)">(distance, vertex)</text>
                            </g>
                        `).join('')}
                        <text x="300" y="420" text-anchor="middle" font-size="14" font-weight="bold" fill="#4CAF50">Extract min → Process closest vertex first</text>
                    </g>
                </svg>
            </div>`;
        }

        renderShortestPath() {
            return `<div class="graph-viz-section">
                <h4>Shortest Path Finding</h4>
                <p class="viz-description">Guaranteed shortest path in weighted graphs</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        ${this.drawWeightedGraph()}
                        <path d="M 200 150 L 300 250 L 500 250" stroke="#FF5722" stroke-width="4" fill="none" marker-end="url(#arrow-red)"/>
                        <text x="300" y="200" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">Shortest: 0→2→3 (distance: 5)</text>
                        <defs><marker id="arrow-red" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#FF5722"/></marker></defs>
                    </g>
                </svg>
            </div>`;
        }

        renderComparison() {
            return `<div class="graph-viz-section">
                <h4>Dijkstra vs BFS</h4>
                <p class="viz-description">Dijkstra handles weighted graphs</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Comparison</text>
                        <text x="0" y="50" font-size="14" font-weight="bold">Dijkstra:</text>
                        <text x="0" y="75" font-size="14">• Works with weighted graphs</text>
                        <text x="0" y="100" font-size="14">• Uses priority queue</text>
                        <text x="0" y="125" font-size="14">• Time: O((V+E) log V)</text>
                        <text x="0" y="150" font-size="14">• Finds shortest path in weighted graphs</text>
                        <text x="500" y="50" font-size="14" font-weight="bold">BFS:</text>
                        <text x="500" y="75" font-size="14">• Only unweighted graphs</text>
                        <text x="500" y="100" font-size="14">• Uses queue</text>
                        <text x="500" y="125" font-size="14">• Time: O(V + E)</text>
                        <text x="500" y="150" font-size="14">• Finds shortest path in unweighted graphs</text>
                    </g>
                </svg>
            </div>`;
        }

        drawWeightedGraph() {
            return `
                <circle cx="200" cy="150" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="200" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                <circle cx="400" cy="150" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="400" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                <circle cx="300" cy="250" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="300" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                <circle cx="500" cy="250" r="30" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                <text x="500" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                <path d="M 230 150 L 370 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <text x="300" y="140" text-anchor="middle" font-size="14" font-weight="bold">4</text>
                <path d="M 230 150 L 270 230" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <text x="220" y="200" text-anchor="middle" font-size="14" font-weight="bold">1</text>
                <path d="M 400 170 L 480 240" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <text x="450" y="210" text-anchor="middle" font-size="14" font-weight="bold">6</text>
                <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#666"/></marker></defs>
            `;
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new DijkstraViz('dijkstraVisualization'));
    } else {
        new DijkstraViz('dijkstraVisualization');
    }
})();
