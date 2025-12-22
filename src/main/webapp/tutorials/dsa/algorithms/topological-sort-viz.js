/**
 * Topological Sort SVG Visualization
 * Shows Kahn's algorithm and DFS-based approach
 */

(function () {
    'use strict';

    class TopologicalSortViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.currentView = 'kahn';
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
                    <h3>Topological Sort Visualizations</h3>
                    <p class="viz-subtitle">Ordering vertices in DAG</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'kahn' ? 'active' : ''}" data-view="kahn">📑 Kahn's Algorithm</button>
                    <button class="viz-tab-btn ${this.currentView === 'dfs' ? 'active' : ''}" data-view="dfs">🌲 DFS-based</button>
                    <button class="viz-tab-btn ${this.currentView === 'course' ? 'active' : ''}" data-view="course">🎓 Course Schedule</button>
                    <button class="viz-tab-btn ${this.currentView === 'build' ? 'active' : ''}" data-view="build">🔨 Build Order</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'kahn': return this.renderKahn();
                case 'dfs': return this.renderDFS();
                case 'course': return this.renderCourse();
                case 'build': return this.renderBuild();
                default: return '';
            }
        }

        renderKahn() {
            return `<div class="graph-viz-section">
                <h4>Kahn's Algorithm (BFS-based)</h4>
                <p class="viz-description">Start with vertices having in-degree 0</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        ${this.drawDAG()}
                        <g transform="translate(0, 350)">
                            <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Process: 0 → 1,2 → 3</text>
                            <text x="0" y="40" font-size="14">1. Find vertices with in-degree 0: [0]</text>
                            <text x="0" y="60" font-size="14">2. Process 0, reduce in-degrees of neighbors</text>
                            <text x="0" y="80" font-size="14">3. Now in-degree 0: [1,2], process them</text>
                            <text x="0" y="100" font-size="14">4. Finally process 3</text>
                            <text x="0" y="130" font-size="14" font-weight="bold" fill="#4CAF50">Result: [0, 1, 2, 3] or [0, 2, 1, 3]</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderDFS() {
            return `<div class="graph-viz-section">
                <h4>DFS-based Topological Sort</h4>
                <p class="viz-description">Add to result when finished (all descendants processed)</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 100)">
                        <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Finish Times (reverse order)</text>
                        ${['Finish 3', 'Finish 1', 'Finish 2', 'Finish 0'].map((f, i) => `
                            <g transform="translate(0, ${50 + i * 80})">
                                <rect x="200" y="0" width="200" height="50" fill="#e3f2fd" stroke="#1976d2" stroke-width="2" rx="4"/>
                                <text x="300" y="33" text-anchor="middle" font-size="16">${f}</text>
                            </g>
                        `).join('')}
                        <text x="300" y="400" text-anchor="middle" font-size="14" font-weight="bold" fill="#4CAF50">Result: [3, 1, 2, 0] reversed = [0, 2, 1, 3]</text>
                    </g>
                </svg>
            </div>`;
        }

        renderCourse() {
            return `<div class="graph-viz-section">
                <h4>Course Schedule Problem</h4>
                <p class="viz-description">Can you finish all courses given prerequisites?</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        ${this.drawCourseGraph()}
                        <text x="300" y="350" text-anchor="middle" font-size="14" font-weight="bold" fill="#4CAF50">Order: CS101 → CS201 → CS301 → CS401</text>
                    </g>
                </svg>
            </div>`;
        }

        renderBuild() {
            return `<div class="graph-viz-section">
                <h4>Build Order (Dependencies)</h4>
                <p class="viz-description">In what order should projects be built?</p>
                <svg viewBox="0 0 1000 600" class="graph-svg">
                    <g transform="translate(100, 100)">
                        <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold">Build Dependencies</text>
                        ${['lib → app', 'utils → lib', 'core → utils'].map((dep, i) => `
                            <g transform="translate(200, ${50 + i * 80})">
                                <text x="0" y="30" font-size="16">${dep}</text>
                            </g>
                        `).join('')}
                        <text x="300" y="350" text-anchor="middle" font-size="14" font-weight="bold" fill="#4CAF50">Build Order: core → utils → lib → app</text>
                    </g>
                </svg>
            </div>`;
        }

        drawDAG() {
            return `
                <circle cx="200" cy="150" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                <text x="200" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                <circle cx="400" cy="150" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="400" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                <circle cx="300" cy="250" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                <text x="300" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                <circle cx="500" cy="250" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                <text x="500" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                <path d="M 230 150 L 370 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <path d="M 230 150 L 270 230" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <path d="M 400 170 L 480 240" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <path d="M 330 250 L 470 250" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#666"/></marker></defs>
            `;
        }

        drawCourseGraph() {
            return `
                <circle cx="150" cy="150" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                <text x="150" y="158" text-anchor="middle" font-size="16" font-weight="bold" fill="white">101</text>
                <circle cx="300" cy="150" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                <text x="300" y="158" text-anchor="middle" font-size="16" font-weight="bold" fill="white">201</text>
                <circle cx="450" cy="150" r="25" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                <text x="450" y="158" text-anchor="middle" font-size="16" font-weight="bold" fill="white">301</text>
                <circle cx="600" cy="150" r="25" fill="#9C27B0" stroke="#7B1FA2" stroke-width="2"/>
                <text x="600" y="158" text-anchor="middle" font-size="16" font-weight="bold" fill="white">401</text>
                <path d="M 175 150 L 275 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <path d="M 325 150 L 425 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <path d="M 475 150 L 575 150" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
                <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto"><polygon points="0 0, 10 3, 0 6" fill="#666"/></marker></defs>
            `;
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new TopologicalSortViz('topologicalSortVisualization'));
    } else {
        new TopologicalSortViz('topologicalSortVisualization');
    }
})();
