/**
 * Minimum Spanning Tree SVG Visualization
 * Shows Kruskal's and Prim's algorithms
 */

(function () {
    'use strict';

    class MSTViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.currentView = 'kruskal';
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
                    <h3>Minimum Spanning Tree Visualizations</h3>
                    <p class="viz-subtitle">Kruskal's and Prim's algorithms</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'kruskal' ? 'active' : ''}" data-view="kruskal">🌳 Kruskal's</button>
                    <button class="viz-tab-btn ${this.currentView === 'prim' ? 'active' : ''}" data-view="prim">🌲 Prim's</button>
                    <button class="viz-tab-btn ${this.currentView === 'unionfind' ? 'active' : ''}" data-view="unionfind">🔗 Union-Find</button>
                    <button class="viz-tab-btn ${this.currentView === 'comparison' ? 'active' : ''}" data-view="comparison">📊 Comparison</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'kruskal': return this.renderKruskal();
                case 'prim': return this.renderPrim();
                case 'unionfind': return this.renderUnionFind();
                case 'comparison': return this.renderComparison();
                default: return '';
            }
        }

        renderKruskal() {
            return `<div class="graph-viz-section">
                <h4>Kruskal's Algorithm</h4>
                <p class="viz-description">Sort edges, add smallest that doesn't create cycle</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="400" y="0" text-anchor="middle" font-size="18" font-weight="bold">Weighted Graph</text>
                        ${this.drawGraph()}
                        <g transform="translate(0, 400)">
                            <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Kruskal's Steps</text>
                            <text x="0" y="30" font-size="14">1. Sort all edges by weight</text>
                            <text x="0" y="55" font-size="14">2. Add smallest edge that doesn't create cycle</text>
                            <text x="0" y="80" font-size="14">3. Use Union-Find to detect cycles</text>
                            <text x="0" y="105" font-size="14">4. Repeat until V-1 edges added</text>
                            <text x="0" y="135" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(E log E) - Good for sparse graphs</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderPrim() {
            return `<div class="graph-viz-section">
                <h4>Prim's Algorithm</h4>
                <p class="viz-description">Start from vertex, always add minimum edge from MST</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="400" y="0" text-anchor="middle" font-size="18" font-weight="bold">Prim's Process</text>
                        ${this.drawGraph()}
                        <g transform="translate(0, 400)">
                            <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Prim's Steps</text>
                            <text x="0" y="30" font-size="14">1. Start from any vertex</text>
                            <text x="0" y="55" font-size="14">2. Add minimum edge from MST to non-MST</text>
                            <text x="0" y="80" font-size="14">3. Use priority queue to find minimum</text>
                            <text x="0" y="105" font-size="14">4. Repeat until all vertices in MST</text>
                            <text x="0" y="135" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(E log V) - Good for dense graphs</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderUnionFind() {
            return `<div class="graph-viz-section">
                <h4>Union-Find Data Structure</h4>
                <p class="viz-description">Efficiently detects cycles in Kruskal's</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(200, 100)">
                        <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Union-Find Operations</text>
                        <text x="0" y="50" font-size="14" font-weight="bold">Find(x):</text>
                        <text x="150" y="50" font-size="14">Find root with path compression</text>
                        <text x="0" y="100" font-size="14" font-weight="bold">Union(x, y):</text>
                        <text x="150" y="100" font-size="14">Merge two sets using union by rank</text>
                        <text x="0" y="150" font-size="14" font-weight="bold">Cycle Detection:</text>
                        <text x="150" y="150" font-size="14">If Find(u) == Find(v) → edge creates cycle!</text>
                        <text x="0" y="200" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(α(V)) amortized - Nearly constant!</text>
                    </g>
                </svg>
            </div>`;
        }

        renderComparison() {
            return `<div class="graph-viz-section">
                <h4>Kruskal vs Prim</h4>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        <text x="400" y="0" text-anchor="middle" font-size="16" font-weight="bold">Comparison</text>
                        <text x="0" y="50" font-size="14" font-weight="bold">Kruskal:</text>
                        <text x="0" y="75" font-size="14">• Edge-based (sort edges)</text>
                        <text x="0" y="100" font-size="14">• Time: O(E log E)</text>
                        <text x="0" y="125" font-size="14">• Best for: Sparse graphs</text>
                        <text x="500" y="50" font-size="14" font-weight="bold">Prim:</text>
                        <text x="500" y="75" font-size="14">• Vertex-based (priority queue)</text>
                        <text x="500" y="100" font-size="14">• Time: O(E log V)</text>
                        <text x="500" y="125" font-size="14">• Best for: Dense graphs</text>
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
                <circle cx="500" cy="250" r="30" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                <text x="500" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                <line x1="230" y1="150" x2="370" y2="150" stroke="#666" stroke-width="2"/>
                <text x="300" y="140" text-anchor="middle" font-size="14" font-weight="bold">10</text>
                <line x1="230" y1="150" x2="270" y2="230" stroke="#666" stroke-width="2"/>
                <text x="220" y="200" text-anchor="middle" font-size="14" font-weight="bold">6</text>
                <line x1="330" y1="250" x2="470" y2="250" stroke="#666" stroke-width="2"/>
                <text x="400" y="240" text-anchor="middle" font-size="14" font-weight="bold">4</text>
            `;
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new MSTViz('mstVisualization'));
    } else {
        new MSTViz('mstVisualization');
    }
})();
