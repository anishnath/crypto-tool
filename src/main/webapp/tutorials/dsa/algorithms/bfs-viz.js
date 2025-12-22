/**
 * BFS SVG Visualization
 * Shows BFS traversal level by level
 */

(function () {
    'use strict';

    class BFSViz {
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
                    <h3>BFS Visualizations</h3>
                    <p class="viz-subtitle">Level-wise graph traversal</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'traversal' ? 'active' : ''}" data-view="traversal">🔍 BFS Traversal</button>
                    <button class="viz-tab-btn ${this.currentView === 'levels' ? 'active' : ''}" data-view="levels">📊 Level-wise</button>
                    <button class="viz-tab-btn ${this.currentView === 'shortest' ? 'active' : ''}" data-view="shortest">🗺️ Shortest Path</button>
                    <button class="viz-tab-btn ${this.currentView === 'queue' ? 'active' : ''}" data-view="queue">📋 Queue Process</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'traversal': return this.renderTraversal();
                case 'levels': return this.renderLevels();
                case 'shortest': return this.renderShortestPath();
                case 'queue': return this.renderQueue();
                default: return '';
            }
        }

        renderTraversal() {
            return `<div class="graph-viz-section">
                <h4>BFS Traversal: Level by Level</h4>
                <p class="viz-description">Visits nodes level by level using queue</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="300" y="0" text-anchor="middle" font-size="18" font-weight="bold">BFS Order: 0 → 1 → 2 → 3 → 4 → 5 → 6</text>
                        ${this.drawGraph()}
                        <g transform="translate(0, 400)">
                            <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">BFS Properties</text>
                            <text x="0" y="30" font-size="14">✓ Uses queue (FIFO)</text>
                            <text x="0" y="50" font-size="14">✓ Visits level by level</text>
                            <text x="0" y="70" font-size="14">✓ Time: O(V + E)</text>
                            <text x="0" y="90" font-size="14">✓ Finds shortest path in unweighted graphs</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderLevels() {
            return `<div class="graph-viz-section">
                <h4>BFS Level-wise</h4>
                <p class="viz-description">Grouping vertices by distance from start</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        ${[0, 1, 2].map((level, idx) => {
                            const nodes = level === 0 ? [0] : level === 1 ? [1, 2] : [3, 4, 5, 6];
                            const y = 100 + level * 120;
                            return `<g transform="translate(0, ${y})">
                                <text x="0" y="0" font-size="16" font-weight="bold">Level ${level}:</text>
                                ${nodes.map((node, i) => `
                                    <circle cx="${150 + i * 80}" cy="0" r="25" fill="${idx === 0 ? '#4CAF50' : idx === 1 ? '#2196F3' : '#FF9800'}" stroke-width="3"/>
                                    <text x="${150 + i * 80}" y="8" text-anchor="middle" font-size="18" font-weight="bold" fill="white">${node}</text>
                                `).join('')}
                            </g>`;
                        }).join('')}
                    </g>
                </svg>
            </div>`;
        }

        renderShortestPath() {
            return `<div class="graph-viz-section">
                <h4>Shortest Path (Unweighted)</h4>
                <p class="viz-description">BFS guarantees shortest path in unweighted graphs</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        ${this.drawGraph()}
                        <path d="M 200 150 L 300 200 L 400 250" stroke="#FF5722" stroke-width="4" fill="none" marker-end="url(#arrow-red)"/>
                        <text x="300" y="160" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF5722">Shortest: 0→1→3</text>
                        <defs><marker id="arrow-red" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#FF5722"/></marker></defs>
                    </g>
                </svg>
            </div>`;
        }

        renderQueue() {
            return `<div class="graph-viz-section">
                <h4>Queue Process</h4>
                <p class="viz-description">Queue maintains order of nodes to visit</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Queue Operations</text>
                        ${['0', '1,2', '2,3,4', '3,4,5,6'].map((q, i) => `
                            <g transform="translate(0, ${50 + i * 80})">
                                <text x="0" y="20" font-size="14">Step ${i + 1}:</text>
                                <rect x="100" y="0" width="400" height="40" fill="#e3f2fd" stroke="#1976d2" stroke-width="2" rx="4"/>
                                <text x="300" y="28" text-anchor="middle" font-size="16">[${q}]</text>
                                <text x="550" y="28" font-size="14">→ Process ${i === 0 ? 0 : i === 1 ? 1 : i === 2 ? 2 : 3}</text>
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
        document.addEventListener('DOMContentLoaded', () => new BFSViz('bfsVisualization'));
    } else {
        new BFSViz('bfsVisualization');
    }
})();
