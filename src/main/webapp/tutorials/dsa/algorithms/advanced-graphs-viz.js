/**
 * Advanced Graph Algorithms SVG Visualization
 * Floyd-Warshall, SCC, Articulation Points, Bridges
 */

(function () {
    'use strict';

    class AdvancedGraphsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.currentView = 'floyd';
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
                    <h3>Advanced Graph Algorithms</h3>
                    <p class="viz-subtitle">Floyd-Warshall, SCC, Articulation Points, Bridges</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'floyd' ? 'active' : ''}" data-view="floyd">🎯 Floyd-Warshall</button>
                    <button class="viz-tab-btn ${this.currentView === 'scc' ? 'active' : ''}" data-view="scc">🔗 Strongly Connected</button>
                    <button class="viz-tab-btn ${this.currentView === 'articulation' ? 'active' : ''}" data-view="articulation">⚡ Articulation Points</button>
                    <button class="viz-tab-btn ${this.currentView === 'bridges' ? 'active' : ''}" data-view="bridges">🌉 Bridges</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'floyd': return this.renderFloyd();
                case 'scc': return this.renderSCC();
                case 'articulation': return this.renderArticulation();
                case 'bridges': return this.renderBridges();
                default: return '';
            }
        }

        renderFloyd() {
            return `<div class="graph-viz-section">
                <h4>Floyd-Warshall Algorithm</h4>
                <p class="viz-description">All-pairs shortest path in O(V³)</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="400" y="0" text-anchor="middle" font-size="18" font-weight="bold">All-Pairs Shortest Path</text>
                        ${this.drawGraph()}
                        <g transform="translate(0, 400)">
                            <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Algorithm</text>
                            <text x="0" y="30" font-size="14">For each intermediate vertex k:</text>
                            <text x="0" y="55" font-size="14">  For each pair (i, j):</text>
                            <text x="0" y="80" font-size="14">    dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])</text>
                            <text x="0" y="110" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(V³) - Finds all pairs at once</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderSCC() {
            return `<div class="graph-viz-section">
                <h4>Strongly Connected Components (Kosaraju's)</h4>
                <p class="viz-description">Two DFS passes to find SCCs</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="400" y="0" text-anchor="middle" font-size="18" font-weight="bold">Directed Graph</text>
                        ${this.drawDirectedGraph()}
                        <g transform="translate(0, 400)">
                            <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Kosaraju's Algorithm</text>
                            <text x="0" y="30" font-size="14">1. First DFS: Get finish times</text>
                            <text x="0" y="55" font-size="14">2. Build transpose graph</text>
                            <text x="0" y="80" font-size="14">3. Second DFS on transpose in reverse order</text>
                            <text x="0" y="110" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(V + E) - Two DFS passes</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderArticulation() {
            return `<div class="graph-viz-section">
                <h4>Articulation Points (Cut Vertices)</h4>
                <p class="viz-description">Vertices whose removal increases components</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 100)">
                        ${this.drawUndirectedGraph()}
                        <circle cx="300" cy="200" r="35" fill="#FF5722" stroke="#D32F2F" stroke-width="4"/>
                        <text x="300" y="208" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                        <text x="300" y="270" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">ARTICULATION POINT!</text>
                    </g>
                </svg>
            </div>`;
        }

        renderBridges() {
            return `<div class="graph-viz-section">
                <h4>Bridges (Cut Edges)</h4>
                <p class="viz-description">Edges whose removal increases components</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 100)">
                        ${this.drawUndirectedGraph()}
                        <line x1="300" y1="200" x2="500" y2="200" stroke="#FF5722" stroke-width="4"/>
                        <text x="400" y="190" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">BRIDGE!</text>
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
                <path d="M 230 150 L 270 230" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#666"/></marker></defs>
            `;
        }

        drawDirectedGraph() {
            return `
                <circle cx="200" cy="150" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="200" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                <circle cx="400" cy="150" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="400" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                <circle cx="300" cy="250" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="300" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                <path d="M 230 150 L 370 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <path d="M 400 170 L 310 240" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <path d="M 330 250 Q 250 220 230 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#666"/></marker></defs>
            `;
        }

        drawUndirectedGraph() {
            return `
                <circle cx="200" cy="200" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="200" y="208" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                <circle cx="300" cy="200" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="300" y="208" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                <circle cx="500" cy="200" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="500" y="208" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                <circle cx="400" cy="300" r="30" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                <text x="400" y="308" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                <line x1="230" y1="200" x2="270" y2="200" stroke="#666" stroke-width="2"/>
                <line x1="300" y1="200" x2="470" y2="200" stroke="#666" stroke-width="2"/>
                <line x1="300" y1="230" x2="380" y2="280" stroke="#666" stroke-width="2"/>
                <line x1="430" y1="280" x2="470" y2="230" stroke="#666" stroke-width="2"/>
            `;
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new AdvancedGraphsViz('advancedGraphsVisualization'));
    } else {
        new AdvancedGraphsViz('advancedGraphsVisualization');
    }
})();
