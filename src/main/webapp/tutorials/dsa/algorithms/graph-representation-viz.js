/**
 * Graph Representation SVG Visualization
 * Shows adjacency matrix, adjacency list, and edge list
 */

(function () {
    'use strict';

    class GraphRepresentationViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'all';
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
                    <h3>Graph Representations</h3>
                    <p class="viz-subtitle">Three ways to represent graphs in code</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'all' ? 'active' : ''}" data-view="all">
                        📊 All Representations
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'matrix' ? 'active' : ''}" data-view="matrix">
                        🔲 Adjacency Matrix
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'list' ? 'active' : ''}" data-view="list">
                        📋 Adjacency List
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'edges' ? 'active' : ''}" data-view="edges">
                        📝 Edge List
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'all':
                    return this.renderAll();
                case 'matrix':
                    return this.renderMatrix();
                case 'list':
                    return this.renderList();
                case 'edges':
                    return this.renderEdges();
                default:
                    return '';
            }
        }

        renderAll() {
            // Graph: 0-1, 0-2, 1-2, 1-3, 2-3 (undirected)
            return `
                <div class="graph-viz-section">
                    <h4>Graph: Social Network (Undirected)</h4>
                    <p class="viz-description">Friends connections: 0↔1, 0↔2, 1↔2, 1↔3, 2↔3</p>
                    
                    <svg viewBox="0 0 1400 850" class="graph-svg">
                        <!-- Graph visualization -->
                        <g transform="translate(50, 50)">
                            <text x="300" y="0" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Graph Structure</text>
                            
                            <!-- Nodes -->
                            <circle cx="200" cy="150" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                            <text x="200" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">0</text>
                            
                            <circle cx="400" cy="150" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                            <text x="400" y="158" text-anchor="middle" font-size="20" font-weight="bold" fill="white">1</text>
                            
                            <circle cx="300" cy="250" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                            <text x="300" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                            
                            <circle cx="500" cy="250" r="30" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                            <text x="500" y="258" text-anchor="middle" font-size="20" font-weight="bold" fill="white">3</text>
                            
                            <!-- Edges -->
                            <line x1="230" y1="150" x2="370" y2="150" stroke="#666" stroke-width="2"/>
                            <line x1="230" y1="150" x2="270" y2="230" stroke="#666" stroke-width="2"/>
                            <line x1="400" y1="170" x2="310" y2="240" stroke="#666" stroke-width="2"/>
                            <line x1="400" y1="170" x2="480" y2="240" stroke="#666" stroke-width="2"/>
                            <line x1="330" y1="250" x2="470" y2="250" stroke="#666" stroke-width="2"/>
                        </g>
                        
                        <!-- Adjacency Matrix -->
                        <g transform="translate(600, 50)">
                            <text x="200" y="0" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Adjacency Matrix</text>
                            
                            <!-- Header row -->
                            <text x="50" y="40" font-size="14" font-weight="bold" fill="var(--text-secondary)"> </text>
                            <text x="90" y="40" text-anchor="middle" font-size="14" font-weight="bold" fill="var(--text-primary)">0</text>
                            <text x="130" y="40" text-anchor="middle" font-size="14" font-weight="bold" fill="var(--text-primary)">1</text>
                            <text x="170" y="40" text-anchor="middle" font-size="14" font-weight="bold" fill="var(--text-primary)">2</text>
                            <text x="210" y="40" text-anchor="middle" font-size="14" font-weight="bold" fill="var(--text-primary)">3</text>
                            
                            <!-- Matrix cells -->
                            ${[0, 1, 2, 3].map(row => {
                                const cells = [0, 1, 2, 3].map(col => {
                                    const hasEdge = (
                                        (row === 0 && (col === 1 || col === 2)) ||
                                        (row === 1 && (col === 0 || col === 2 || col === 3)) ||
                                        (row === 2 && (col === 0 || col === 1 || col === 3)) ||
                                        (row === 3 && (col === 1 || col === 2))
                                    );
                                    const fill = hasEdge ? '#4CAF50' : '#f0f0f0';
                                    const stroke = hasEdge ? '#388E3C' : '#ccc';
                                    const text = hasEdge ? '1' : '0';
                                    return `
                                        <rect x="${80 + col * 40}" y="${60 + row * 35}" width="30" height="30" 
                                              fill="${fill}" stroke="${stroke}" stroke-width="2"/>
                                        <text x="${95 + col * 40}" y="${80 + row * 35}" text-anchor="middle" 
                                              font-size="16" font-weight="bold" fill="${hasEdge ? 'white' : '#666'}">${text}</text>
                                    `;
                                }).join('');
                                return `
                                    <text x="50" y="${80 + row * 35}" text-anchor="middle" font-size="14" font-weight="bold" fill="var(--text-primary)">${row}</text>
                                    ${cells}
                                `;
                            }).join('')}
                            
                            <text x="200" y="230" text-anchor="middle" font-size="12" fill="var(--text-secondary)">
                                Space: O(V²), Check edge: O(1)
                            </text>
                        </g>
                        
                        <!-- Adjacency List -->
                        <g transform="translate(50, 350)">
                            <text x="250" y="0" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Adjacency List</text>
                            
                            ${[0, 1, 2, 3].map(i => {
                                const neighbors = 
                                    i === 0 ? [1, 2] :
                                    i === 1 ? [0, 2, 3] :
                                    i === 2 ? [0, 1, 3] :
                                    [1, 2];
                                const neighborText = neighbors.length > 0 ? neighbors.join(' → ') : '(none)';
                                return `
                                    <rect x="0" y="${30 + i * 50}" width="500" height="40" 
                                          fill="${i % 2 === 0 ? '#f9f9f9' : '#ffffff'}" 
                                          stroke="#ddd" stroke-width="1" rx="4"/>
                                    <text x="30" y="${55 + i * 50}" font-size="16" font-weight="bold" fill="var(--text-primary)">${i}:</text>
                                    <text x="80" y="${55 + i * 50}" font-size="16" fill="var(--text-secondary)">[${neighborText}]</text>
                                `;
                            }).join('')}
                            
                            <text x="250" y="250" text-anchor="middle" font-size="12" fill="var(--text-secondary)">
                                Space: O(V + E), Check edge: O(degree)
                            </text>
                        </g>
                        
                        <!-- Edge List -->
                        <g transform="translate(600, 350)">
                            <text x="250" y="0" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Edge List</text>
                            
                            ${[
                                [0, 1], [0, 2], [1, 2], [1, 3], [2, 3]
                            ].map((edge, idx) => `
                                <rect x="0" y="${30 + idx * 40}" width="500" height="35" 
                                      fill="${idx % 2 === 0 ? '#f9f9f9' : '#ffffff'}" 
                                      stroke="#ddd" stroke-width="1" rx="4"/>
                                <text x="30" y="${53 + idx * 40}" font-size="16" fill="var(--text-secondary)">
                                    (${edge[0]}, ${edge[1]})
                                </text>
                            `).join('')}
                            
                            <text x="250" y="250" text-anchor="middle" font-size="12" fill="var(--text-secondary)">
                                Space: O(E), Check edge: O(E)
                            </text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderMatrix() {
            return `
                <div class="graph-viz-section">
                    <h4>Adjacency Matrix</h4>
                    <p class="viz-description">V×V matrix where matrix[i][j] = 1 if edge exists, 0 otherwise</p>
                    
                    <svg viewBox="0 0 1000 700" class="graph-svg">
                        <g transform="translate(200, 100)">
                            <text x="200" y="0" text-anchor="middle" font-size="20" font-weight="bold" fill="var(--text-primary)">Adjacency Matrix</text>
                            
                            <!-- Header -->
                            <text x="50" y="50" font-size="16" font-weight="bold" fill="var(--text-secondary)"> </text>
                            ${[0, 1, 2, 3].map(i => `
                                <text x="${120 + i * 60}" y="50" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">${i}</text>
                            `).join('')}
                            
                            <!-- Matrix -->
                            ${[0, 1, 2, 3].map(row => {
                                const cells = [0, 1, 2, 3].map(col => {
                                    const hasEdge = (
                                        (row === 0 && (col === 1 || col === 2)) ||
                                        (row === 1 && (col === 0 || col === 2 || col === 3)) ||
                                        (row === 2 && (col === 0 || col === 1 || col === 3)) ||
                                        (row === 3 && (col === 1 || col === 2))
                                    );
                                    return `
                                        <rect x="${100 + col * 60}" y="${80 + row * 50}" width="50" height="45" 
                                              fill="${hasEdge ? '#4CAF50' : '#f0f0f0'}" 
                                              stroke="${hasEdge ? '#388E3C' : '#ccc'}" stroke-width="2"/>
                                        <text x="${125 + col * 60}" y="${107 + row * 50}" text-anchor="middle" 
                                              font-size="20" font-weight="bold" fill="${hasEdge ? 'white' : '#666'}">${hasEdge ? '1' : '0'}</text>
                                    `;
                                }).join('');
                                return `
                                    <text x="50" y="${107 + row * 50}" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">${row}</text>
                                    ${cells}
                                `;
                            }).join('')}
                            
                            <!-- Properties -->
                            <g transform="translate(0, 320)">
                                <text x="200" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Properties</text>
                                <text x="0" y="35" font-size="14" fill="var(--text-secondary)">✓ Space: O(V²)</text>
                                <text x="0" y="55" font-size="14" fill="var(--text-secondary)">✓ Check edge: O(1) - Very fast!</text>
                                <text x="0" y="75" font-size="14" fill="var(--text-secondary)">✓ Good for: Dense graphs (E ≈ V²)</text>
                                <text x="0" y="95" font-size="14" fill="var(--text-secondary)">✓ Good for: Quick edge existence checks</text>
                                <text x="0" y="115" font-size="14" fill="var(--text-secondary)">✗ Bad for: Sparse graphs (wasteful space)</text>
                            </g>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderList() {
            return `
                <div class="graph-viz-section">
                    <h4>Adjacency List</h4>
                    <p class="viz-description">Each vertex stores list of its neighbors</p>
                    
                    <svg viewBox="0 0 1000 750" class="graph-svg">
                        <g transform="translate(100, 50)">
                            <text x="300" y="0" text-anchor="middle" font-size="20" font-weight="bold" fill="var(--text-primary)">Adjacency List</text>
                            
                            ${[0, 1, 2, 3].map(i => {
                                const neighbors = 
                                    i === 0 ? [1, 2] :
                                    i === 1 ? [0, 2, 3] :
                                    i === 2 ? [0, 1, 3] :
                                    [1, 2];
                                
                                return `
                                    <g transform="translate(0, ${60 + i * 120})">
                                        <!-- Vertex -->
                                        <circle cx="50" cy="50" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                                        <text x="50" y="58" text-anchor="middle" font-size="18" font-weight="bold" fill="white">${i}</text>
                                        
                                        <!-- Arrow -->
                                        <path d="M 80 50 L 120 50" stroke="#666" stroke-width="2" marker-end="url(#arrowhead)"/>
                                        
                                        <!-- Neighbors -->
                                        ${neighbors.map((neighbor, idx) => `
                                            <g transform="translate(${140 + idx * 80}, 0)">
                                                <circle cx="0" cy="50" r="20" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                                                <text x="0" y="58" text-anchor="middle" font-size="16" font-weight="bold" fill="white">${neighbor}</text>
                                                ${idx < neighbors.length - 1 ? `
                                                    <path d="M 25 50 L 55 50" stroke="#999" stroke-width="2"/>
                                                ` : ''}
                                            </g>
                                        `).join('')}
                                        
                                        ${neighbors.length === 0 ? `
                                            <text x="140" y="55" font-size="14" fill="var(--text-secondary)">(no neighbors)</text>
                                        ` : ''}
                                    </g>
                                `;
                            }).join('')}
                            
                            <!-- Arrow marker definition -->
                            <defs>
                                <marker id="arrowhead" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                    <polygon points="0 0, 10 3, 0 6" fill="#666"/>
                                </marker>
                            </defs>
                            
                            <!-- Properties -->
                            <g transform="translate(0, 530)">
                                <text x="300" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Properties</text>
                                <text x="0" y="35" font-size="14" fill="var(--text-secondary)">✓ Space: O(V + E) - Efficient!</text>
                                <text x="0" y="55" font-size="14" fill="var(--text-secondary)">✓ Check edge: O(degree) - Usually fast</text>
                                <text x="0" y="75" font-size="14" fill="var(--text-secondary)">✓ Good for: Sparse graphs (E << V²)</text>
                                <text x="0" y="95" font-size="14" fill="var(--text-secondary)">✓ Most common choice - best balance</text>
                                <text x="0" y="115" font-size="14" fill="var(--text-secondary)">✓ Used by most graph algorithms</text>
                            </g>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderEdges() {
            return `
                <div class="graph-viz-section">
                    <h4>Edge List</h4>
                    <p class="viz-description">Simple list of all edges (from, to, weight)</p>
                    
                    <svg viewBox="0 0 1000 700" class="graph-svg">
                        <g transform="translate(200, 100)">
                            <text x="200" y="0" text-anchor="middle" font-size="20" font-weight="bold" fill="var(--text-primary)">Edge List</text>
                            
                            ${[
                                [0, 1], [0, 2], [1, 2], [1, 3], [2, 3]
                            ].map((edge, idx) => `
                                <g transform="translate(0, ${50 + idx * 70})">
                                    <rect x="0" y="0" width="400" height="60" 
                                          fill="${idx % 2 === 0 ? '#f9f9f9' : '#ffffff'}" 
                                          stroke="#ddd" stroke-width="2" rx="8"/>
                                    <text x="50" y="40" font-size="18" fill="var(--text-primary)">
                                        Edge ${idx + 1}: (${edge[0]} → ${edge[1]})
                                    </text>
                                </g>
                            `).join('')}
                            
                            <!-- Properties -->
                            <g transform="translate(0, 420)">
                                <text x="200" y="0" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Properties</text>
                                <text x="0" y="35" font-size="14" fill="var(--text-secondary)">✓ Space: O(E) - Minimal space</text>
                                <text x="0" y="55" font-size="14" fill="var(--text-secondary)">✓ Check edge: O(E) - Must iterate</text>
                                <text x="0" y="75" font-size="14" fill="var(--text-secondary)">✓ Good for: Iterating all edges</text>
                                <text x="0" y="95" font-size="14" fill="var(--text-secondary)">✓ Good for: Kruskal's algorithm (MST)</text>
                                <text x="0" y="115" font-size="14" fill="var(--text-secondary)">✗ Bad for: Edge existence queries</text>
                            </g>
                        </g>
                    </svg>
                </div>
            `;
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new GraphRepresentationViz('graphRepresentationVisualization');
        });
    } else {
        new GraphRepresentationViz('graphRepresentationVisualization');
    }
})();
