/**
 * DP Fundamentals SVG Visualization
 * Shows Memoization vs Tabulation, Fibonacci DP table
 */

(function () {
    'use strict';

    class DPFundamentalsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.currentView = 'comparison';
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
                    <h3>DP Fundamentals Visualizations</h3>
                    <p class="viz-subtitle">Memoization vs Tabulation</p>
                </div>
                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'comparison' ? 'active' : ''}" data-view="comparison">⚖️ Comparison</button>
                    <button class="viz-tab-btn ${this.currentView === 'memoization' ? 'active' : ''}" data-view="memoization">📝 Memoization</button>
                    <button class="viz-tab-btn ${this.currentView === 'tabulation' ? 'active' : ''}" data-view="tabulation">📊 Tabulation</button>
                    <button class="viz-tab-btn ${this.currentView === 'fibonacci' ? 'active' : ''}" data-view="fibonacci">🔢 Fibonacci</button>
                </div>
                <div class="viz-canvas">${this.renderCurrentView()}</div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'comparison': return this.renderComparison();
                case 'memoization': return this.renderMemoization();
                case 'tabulation': return this.renderTabulation();
                case 'fibonacci': return this.renderFibonacci();
                default: return '';
            }
        }

        renderComparison() {
            return `<div class="graph-viz-section">
                <h4>Memoization vs Tabulation</h4>
                <p class="viz-description">Two approaches to Dynamic Programming</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(50, 50)">
                        <text x="450" y="0" text-anchor="middle" font-size="20" font-weight="bold">Comparison</text>
                        <g transform="translate(0, 50)">
                            <rect x="50" y="0" width="350" height="550" fill="#e3f2fd" stroke="#1976d2" stroke-width="2" rx="8"/>
                            <text x="225" y="30" text-anchor="middle" font-size="18" font-weight="bold">Memoization (Top-Down)</text>
                            <text x="70" y="70" font-size="14">✓ Recursive approach</text>
                            <text x="70" y="95" font-size="14">✓ Natural thinking</text>
                            <text x="70" y="120" font-size="14">✓ Only solves needed</text>
                            <text x="70" y="145" font-size="14">✓ Uses recursion stack</text>
                            <text x="70" y="170" font-size="14">✓ Time: O(n)</text>
                            <text x="70" y="195" font-size="14">✓ Space: O(n)</text>
                            <g transform="translate(100, 250)">
                                <text x="0" y="0" font-size="14" font-weight="bold">Example:</text>
                                <text x="0" y="25" font-size="12" font-family="monospace">fib(n, memo)</text>
                                <text x="0" y="45" font-size="12" font-family="monospace">if n in memo:</text>
                                <text x="0" y="65" font-size="12" font-family="monospace">  return memo[n]</text>
                            </g>
                        </g>
                        <g transform="translate(550, 50)">
                            <rect x="0" y="0" width="350" height="550" fill="#fff3e0" stroke="#f57c00" stroke-width="2" rx="8"/>
                            <text x="175" y="30" text-anchor="middle" font-size="18" font-weight="bold">Tabulation (Bottom-Up)</text>
                            <text x="20" y="70" font-size="14">✓ Iterative approach</text>
                            <text x="20" y="95" font-size="14">✓ Build from base</text>
                            <text x="20" y="120" font-size="14">✓ Solves all subproblems</text>
                            <text x="20" y="145" font-size="14">✓ No recursion</text>
                            <text x="20" y="170" font-size="14">✓ Time: O(n)</text>
                            <text x="20" y="195" font-size="14">✓ Space: O(n)</text>
                            <g transform="translate(50, 250)">
                                <text x="0" y="0" font-size="14" font-weight="bold">Example:</text>
                                <text x="0" y="25" font-size="12" font-family="monospace">dp = [0] * (n+1)</text>
                                <text x="0" y="45" font-size="12" font-family="monospace">for i in range(2, n+1):</text>
                                <text x="0" y="65" font-size="12" font-family="monospace">  dp[i] = dp[i-1] + dp[i-2]</text>
                            </g>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderMemoization() {
            return `<div class="graph-viz-section">
                <h4>Memoization (Top-Down)</h4>
                <p class="viz-description">Recursive with caching - solve as needed</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(50, 50)">
                        <text x="450" y="0" text-anchor="middle" font-size="18" font-weight="bold">Fibonacci(5) with Memoization</text>
                        <g transform="translate(200, 80)">
                            <text x="0" y="0" font-size="14" font-weight="bold">Call Tree (only needed calls):</text>
                            <text x="0" y="30" font-size="12" font-family="monospace">fib(5)</text>
                            <text x="50" y="60" font-size="12" font-family="monospace">fib(4) → fib(3) [cached]</text>
                            <text x="50" y="90" font-size="12" font-family="monospace">fib(3) → fib(2) [cached]</text>
                            <text x="50" y="120" font-size="12" font-family="monospace">fib(2) → fib(1) + fib(0)</text>
                            <g transform="translate(0, 180)">
                                <text x="0" y="0" font-size="14" font-weight="bold">Memo Dictionary:</text>
                                <text x="0" y="30" font-size="12" font-family="monospace">memo = {</text>
                                <text x="20" y="55" font-size="12" font-family="monospace">0: 0,</text>
                                <text x="20" y="80" font-size="12" font-family="monospace">1: 1,</text>
                                <text x="20" y="105" font-size="12" font-family="monospace">2: 1,</text>
                                <text x="20" y="130" font-size="12" font-family="monospace">3: 2,</text>
                                <text x="20" y="155" font-size="12" font-family="monospace">4: 3,</text>
                                <text x="20" y="180" font-size="12" font-family="monospace">5: 5</text>
                                <text x="0" y="205" font-size="12" font-family="monospace">}</text>
                            </g>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderTabulation() {
            return `<div class="graph-viz-section">
                <h4>Tabulation (Bottom-Up)</h4>
                <p class="viz-description">Iterative - build from base cases</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(100, 50)">
                        <text x="400" y="0" text-anchor="middle" font-size="18" font-weight="bold">Fibonacci DP Table</text>
                        <g transform="translate(200, 80)">
                            ${[0, 1, 2, 3, 4, 5].map((i, idx) => {
                                const fib = idx === 0 ? 0 : idx === 1 ? 1 : idx === 2 ? 1 : idx === 3 ? 2 : idx === 4 ? 3 : 5;
                                const y = idx * 80;
                                return `<g transform="translate(0, ${y})">
                                    <rect x="0" y="0" width="200" height="60" fill="${idx <= 1 ? '#4CAF50' : '#2196F3'}" stroke="#333" stroke-width="2" rx="4"/>
                                    <text x="30" y="35" font-size="16" font-weight="bold">dp[${i}]</text>
                                    <text x="150" y="35" font-size="16" font-weight="bold">${fib}</text>
                                    ${idx > 1 ? `<text x="250" y="35" font-size="12" fill="#666">= dp[${i-1}] + dp[${i-2}]</text>` : ''}
                                </g>`;
                            }).join('')}
                        </g>
                        <g transform="translate(50, 600)">
                            <text x="0" y="0" font-size="14" font-weight="bold">Build order: dp[0] → dp[1] → dp[2] → ... → dp[n]</text>
                            <text x="0" y="25" font-size="14">All subproblems solved, no recursion needed</text>
                        </g>
                    </g>
                </svg>
            </div>`;
        }

        renderFibonacci() {
            return `<div class="graph-viz-section">
                <h4>Fibonacci: DP Pattern</h4>
                <p class="viz-description">Classic DP example - overlapping subproblems</p>
                <svg viewBox="0 0 1000 700" class="graph-svg">
                    <g transform="translate(50, 50)">
                        <text x="450" y="0" text-anchor="middle" font-size="18" font-weight="bold">Fibonacci Recurrence</text>
                        <g transform="translate(200, 100)">
                            <text x="200" y="0" text-anchor="middle" font-size="16" font-weight="bold">dp[i] = dp[i-1] + dp[i-2]</text>
                            <g transform="translate(0, 60)">
                                ${[0, 1, 2, 3, 4, 5, 6, 7].map((i, idx) => {
                                    const fib = idx === 0 ? 0 : idx === 1 ? 1 : idx === 2 ? 1 : idx === 3 ? 2 : idx === 4 ? 3 : idx === 5 ? 5 : idx === 6 ? 8 : 13;
                                    const x = (idx % 4) * 180;
                                    const y = Math.floor(idx / 4) * 120;
                                    return `<g transform="translate(${x}, ${y})">
                                        <rect x="0" y="0" width="70" height="50" fill="#2196F3" stroke="#1976D2" stroke-width="2" rx="4"/>
                                        <text x="35" y="20" text-anchor="middle" font-size="12" font-weight="bold">dp[${i}]</text>
                                        <text x="35" y="40" text-anchor="middle" font-size="14" font-weight="bold">${fib}</text>
                                    </g>`;
                                }).join('')}
                            </g>
                            <g transform="translate(0, 350)">
                                <text x="200" y="0" text-anchor="middle" font-size="14" font-weight="bold">Base Cases:</text>
                                <text x="200" y="25" text-anchor="middle" font-size="14">dp[0] = 0, dp[1] = 1</text>
                                <text x="200" y="60" text-anchor="middle" font-size="14" font-weight="bold">Transition:</text>
                                <text x="200" y="85" text-anchor="middle" font-size="14">dp[i] = dp[i-1] + dp[i-2]</text>
                                <text x="200" y="120" text-anchor="middle" font-size="14" font-weight="bold">Time: O(n), Space: O(n) or O(1)</text>
                            </g>
                        </g>
                    </g>
                </svg>
            </div>`;
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new DPFundamentalsViz('dpFundamentalsVisualization');
        });
    } else {
        new DPFundamentalsViz('dpFundamentalsVisualization');
    }
})();
