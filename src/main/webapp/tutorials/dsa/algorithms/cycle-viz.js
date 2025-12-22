/**
 * Cycle Detection Visualization - Floyd's Tortoise and Hare
 * Shows slow and fast pointers moving through the list
 */

(function () {
    'use strict';

    class CycleViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.isRunning = false;
            this.speed = 1200;
            this.currentStep = 0;
            this.hasCycle = true;

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Floyd's Cycle Detection - Tortoise 🐢 and Hare 🐇</h3>
                    <p class="viz-subtitle">Slow pointer moves 1 step, Fast pointer moves 2 steps</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Current Step</div>
                        <div class="viz-stat-value" id="currentStep">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Status</div>
                        <div class="viz-stat-value" id="statusInfo">Ready</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(n) time, O(1) space</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose a scenario and click Start to see Floyd's algorithm in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="cycle-viz" id="cycleViz"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Choose Scenario:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn viz-op-cycle" data-scenario="cycle">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">List WITH Cycle</span>
                            <span class="viz-op-complexity">They will meet!</span>
                        </button>
                        <button class="viz-op-btn viz-op-no-cycle" data-scenario="no-cycle">
                            <span class="viz-op-icon">➡️</span>
                            <span class="viz-op-label">List WITHOUT Cycle</span>
                            <span class="viz-op-complexity">Hare reaches end</span>
                        </button>
                    </div>
                </div>
                
                <div class="viz-controls">
                    <button class="viz-btn viz-btn-primary" id="vizStart">
                        <span>▶️</span> Start Detection
                    </button>
                    <button class="viz-btn" id="vizPause" disabled>
                        <span>⏸</span> Pause
                    </button>
                    <button class="viz-btn" id="vizReset">
                        <span>🔄</span> Reset
                    </button>
                    <div class="viz-slider-group">
                        <div class="viz-slider-label">
                            <span>Speed</span>
                            <span id="speedValue">1200ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="speedSlider" 
                               min="600" max="2000" value="1200" step="200">
                    </div>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.querySelectorAll('[data-scenario]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const scenario = e.currentTarget.dataset.scenario;
                    this.hasCycle = scenario === 'cycle';
                    this.reset();

                    document.querySelectorAll('[data-scenario]').forEach(b =>
                        b.classList.remove('viz-op-btn-selected'));
                    e.currentTarget.classList.add('viz-op-btn-selected');
                });
            });

            document.getElementById('vizStart').addEventListener('click', () => this.start());
            document.getElementById('vizPause').addEventListener('click', () => this.pause());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });

            // Select cycle scenario by default
            document.querySelector('[data-scenario="cycle"]').classList.add('viz-op-btn-selected');
        }

        renderVisualization() {
            const container = document.getElementById('cycleViz');
            if (!container) return;

            container.innerHTML = '';

            // Create list structure
            const listDiv = document.createElement('div');
            listDiv.className = 'cycle-list';

            if (this.hasCycle) {
                listDiv.innerHTML = `
                    <div class="cycle-diagram">
                        <div class="cycle-label">List with Cycle:</div>
                        <div class="cycle-nodes-row">
                            <div class="cycle-node" data-node="0">
                                <div class="cycle-node-value">1</div>
                                <div class="cycle-node-label" id="node0Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="1">
                                <div class="cycle-node-value">2</div>
                                <div class="cycle-node-label" id="node1Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="2">
                                <div class="cycle-node-value">3</div>
                                <div class="cycle-node-label" id="node2Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="3">
                                <div class="cycle-node-value">4</div>
                                <div class="cycle-node-label" id="node3Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="4">
                                <div class="cycle-node-value">5</div>
                                <div class="cycle-node-label" id="node4Label"></div>
                            </div>
                        </div>
                        <div class="cycle-back-arrow">
                            <div class="cycle-back-label">↑ Cycle back to node 2 ↓</div>
                        </div>
                    </div>
                `;
            } else {
                listDiv.innerHTML = `
                    <div class="cycle-diagram">
                        <div class="cycle-label">List without Cycle:</div>
                        <div class="cycle-nodes-row">
                            <div class="cycle-node" data-node="0">
                                <div class="cycle-node-value">1</div>
                                <div class="cycle-node-label" id="node0Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="1">
                                <div class="cycle-node-value">2</div>
                                <div class="cycle-node-label" id="node1Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="2">
                                <div class="cycle-node-value">3</div>
                                <div class="cycle-node-label" id="node2Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="3">
                                <div class="cycle-node-value">4</div>
                                <div class="cycle-node-label" id="node3Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-node" data-node="4">
                                <div class="cycle-node-value">5</div>
                                <div class="cycle-node-label" id="node4Label"></div>
                            </div>
                            <div class="cycle-arrow">→</div>
                            <div class="cycle-null">null</div>
                        </div>
                    </div>
                `;
            }

            container.appendChild(listDiv);

            // Pointers info
            const pointersDiv = document.createElement('div');
            pointersDiv.className = 'cycle-pointers-info';
            pointersDiv.innerHTML = `
                <div class="cycle-pointer-card cycle-slow-card">
                    <div class="cycle-pointer-icon">🐢</div>
                    <div class="cycle-pointer-name">Tortoise (slow)</div>
                    <div class="cycle-pointer-desc">Moves 1 step</div>
                </div>
                <div class="cycle-pointer-card cycle-fast-card">
                    <div class="cycle-pointer-icon">🐇</div>
                    <div class="cycle-pointer-name">Hare (fast)</div>
                    <div class="cycle-pointer-desc">Moves 2 steps</div>
                </div>
            `;
            container.appendChild(pointersDiv);
        }

        async start() {
            if (this.isRunning) return;

            this.isRunning = true;
            this.isPaused = false;
            document.getElementById('vizStart').disabled = true;
            document.getElementById('vizPause').disabled = false;

            // Clear labels
            for (let i = 0; i < 5; i++) {
                const label = document.getElementById(`node${i}Label`);
                if (label) label.textContent = '';
            }

            let slow = 0;
            let fast = 0;
            let step = 0;

            document.getElementById('explanation').textContent =
                `Starting: Both pointers at node ${slow + 1}`;
            document.getElementById('statusInfo').textContent = 'Running...';

            // Initial position
            this.highlightNodes(slow, fast);
            await this.sleep(this.speed);

            while (this.isRunning) {
                while (this.isPaused) {
                    await this.sleep(100);
                }

                step++;

                // Move slow 1 step
                if (this.hasCycle) {
                    slow = (slow + 1) % 5;
                    if (slow >= 2) {
                        // In cycle part
                        slow = 2 + ((slow - 2) % 3);
                    }
                } else {
                    slow++;
                }

                // Move fast 2 steps
                if (this.hasCycle) {
                    for (let i = 0; i < 2; i++) {
                        fast = (fast + 1) % 5;
                        if (fast >= 2) {
                            fast = 2 + ((fast - 2) % 3);
                        }
                    }
                } else {
                    fast += 2;
                }

                // Check if fast reached end (no cycle)
                if (!this.hasCycle && fast >= 5) {
                    document.getElementById('explanation').textContent =
                        `✅ NO CYCLE! Hare reached the end (null)`;
                    document.getElementById('statusInfo').textContent = 'No Cycle';
                    this.complete();
                    break;
                }

                // Update visualization
                this.highlightNodes(slow, fast);
                document.getElementById('currentStep').textContent = step;
                document.getElementById('explanation').textContent =
                    `Step ${step}: 🐢 at node ${slow + 1}, 🐇 at node ${fast + 1}`;

                await this.sleep(this.speed);

                // Check if they met (cycle detected)
                if (this.hasCycle && slow === fast) {
                    document.getElementById('explanation').textContent =
                        `✅ CYCLE DETECTED! They met at node ${slow + 1}`;
                    document.getElementById('statusInfo').textContent = 'Cycle Found!';
                    this.highlightNodes(slow, fast, true);
                    this.complete();
                    break;
                }
            }
        }

        highlightNodes(slow, fast, meeting = false) {
            // Clear all highlights
            document.querySelectorAll('.cycle-node').forEach(node => {
                node.classList.remove('cycle-node-slow', 'cycle-node-fast', 'cycle-node-meeting');
            });

            // Clear labels
            for (let i = 0; i < 5; i++) {
                const label = document.getElementById(`node${i}Label`);
                if (label) label.textContent = '';
            }

            // Highlight current positions
            const slowNode = document.querySelector(`[data-node="${slow}"]`);
            const fastNode = document.querySelector(`[data-node="${fast}"]`);

            if (meeting) {
                if (slowNode) slowNode.classList.add('cycle-node-meeting');
                const label = document.getElementById(`node${slow}Label`);
                if (label) label.textContent = '🐢🐇 MET!';
            } else {
                if (slowNode) {
                    slowNode.classList.add('cycle-node-slow');
                    const label = document.getElementById(`node${slow}Label`);
                    if (label) label.textContent = '🐢';
                }
                if (fastNode && fast !== slow) {
                    fastNode.classList.add('cycle-node-fast');
                    const label = document.getElementById(`node${fast}Label`);
                    if (label) label.textContent = '🐇';
                } else if (fast === slow) {
                    const label = document.getElementById(`node${slow}Label`);
                    if (label) label.textContent = '🐢🐇';
                }
            }
        }

        pause() {
            this.isPaused = !this.isPaused;
            const pauseBtn = document.getElementById('vizPause');
            pauseBtn.innerHTML = this.isPaused ?
                '<span>▶️</span> Resume' :
                '<span>⏸</span> Pause';
        }

        reset() {
            this.isRunning = false;
            this.isPaused = false;
            this.currentStep = 0;

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';
            document.getElementById('currentStep').textContent = '0';
            document.getElementById('statusInfo').textContent = 'Ready';
            document.getElementById('explanation').textContent =
                'Choose a scenario and click Start to see Floyd\'s algorithm in action!';

            this.renderVisualization();
        }

        complete() {
            this.isRunning = false;
            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new CycleViz('cycleVisualization');
        });
    } else {
        new CycleViz('cycleVisualization');
    }
})();
