/**
 * Bellman-Ford Algorithm SVG Visualization
 * Shows algorithm with negative weights and cycle detection
 */

(function () {
    'use strict';

    class BellmanFordViz {
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
                    <h3>Bellman-Ford Algorithm Visualizations</h3>
                    <p class="viz-subtitle">Shortest path with negative weights</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'algorithm' ? 'active' : ''}" data-view="algorithm">⚖️ Algorithm</button>
                    <button class="viz-tab-btn ${this.currentView === 'relaxation' ? 'active' : ''}" data-view="relaxation">🔄 Relaxation</button>
                    <button class="viz-tab-btn ${this.currentView === 'cycle' ? 'active' : ''}" data-view="cycle">⚠️ Cycle Detection</button>
                    <button class="viz-tab-btn ${this.currentView === 'comparison' ? 'active' : ''}" data-view="comparison">📊 Comparison</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'algorithm': return this.renderAlgorithm();
                case 'relaxation': return this.renderRelaxation();
                case 'cycle': return this.renderCycle();
                case 'comparison': return this.renderComparison();
                default: return '';
            }
        }

        renderAlgorithm() {
            return `<div class="graph-viz-section">
                <h4>Bellman-Ford Algorithm</h4>
                <p class="viz-description">Relax edges V-1 times, then check for negative cycles</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="400" y="0" text-anchor="middle" font-size="18" font-weight="bold">Graph with Negative Weights</text>
                        ${this.drawGraph()}
                        <g transform="translate(0, 400)">
                            <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Algorithm Steps</text>
                            <text x="0" y="30" font-size="14">1. Initialize distances (start = 0, others = ∞)</text>
                            <text x="0" y="55" font-size="14">2. Relax all edges V-1 times</text>
                            <text x="0" y="80" font-size="14">3. Check if edges can still be relaxed</text>
                            <text x="0" y="105" font-size="14">4. If yes → negative cycle exists!</text>
                            <text x="0" y="135" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(VE) - Slower than Dijkstra</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderRelaxation() {
            return `<div class="graph-viz-section">
                <h4>Edge Relaxation</h4>
                <p class="viz-description">Relax edges to update shortest distances</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(200, 100)">
                        <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Relaxation Process</text>
                        ${['Iteration 1', 'Iteration 2', 'Iteration 3'].map((iter, i) => `
                            <g transform="translate(0, ${50 + i * 100})">
                                <text x="0" y="30" font-size="16" font-weight="bold">${iter}:</text>
                                <text x="150" y="30" font-size="14">Relax all edges</text>
                                <text x="150" y="55" font-size="14" fill="var(--text-secondary)">Update distances if dist[u] + weight < dist[v]</text>
                            </g>
                        `).join('')}
                    </g>
                </svg>
            </div>`;
        }

        renderCycle() {
            return `<div class="graph-viz-section">
                <h4>Negative Cycle Detection</h4>
                <p class="viz-description">If edges can still be relaxed after V-1 iterations, negative cycle exists</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(200, 100)">
                        ${this.drawCycleGraph()}
                        <path d="M 300 200 Q 400 150 500 200 Q 400 250 300 200" stroke="#FF5722" stroke-width="4" fill="none" marker-end="url(#arrow-red)"/>
                        <text x="400" y="130" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">NEGATIVE CYCLE!</text>
                        <defs><marker id="arrow-red" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#FF5722"/></marker></defs>
                    </g>
                </svg>
            </div>`;
        }

        renderComparison() {
            return `<div class="graph-viz-section">
                <h4>Dijkstra vs Bellman-Ford</h4>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Comparison</text>
                        <text x="0" y="50" font-size="14" font-weight="bold">Dijkstra:</text>
                        <text x="0" y="75" font-size="14">✓ Faster: O((V+E) log V)</text>
                        <text x="0" y="100" font-size="14">✗ No negative weights</text>
                        <text x="0" y="125" font-size="14">✗ Cannot detect cycles</text>
                        <text x="500" y="50" font-size="14" font-weight="bold">Bellman-Ford:</text>
                        <text x="500" y="75" font-size="14">✗ Slower: O(VE)</text>
                        <text x="500" y="100" font-size="14">✓ Handles negative weights</text>
                        <text x="500" y="125" font-size="14">✓ Detects negative cycles</text>
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
                <circle cx="300" cy="250" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="300" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                <path d="M 230 150 L 370 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <text x="300" y="140" text-anchor="middle" font-size="14" font-weight="bold">4</text>
                <path d="M 230 150 L 270 230" stroke="#FF5722" stroke-width="2" marker-end="url(#arrow)"/>
                <text x="220" y="200" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">-3</text>
                <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#666"/></marker></defs>
            `;
        }

        drawCycleGraph() {
            return `
                <circle cx="300" cy="200" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="300" y="208" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                <circle cx="500" cy="200" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="500" y="208" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                <circle cx="400" cy="300" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="400" y="308" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
            `;
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new BellmanFordViz('bellmanFordVisualization'));
    } else {
        new BellmanFordViz('bellmanFordVisualization');
    }
})();
