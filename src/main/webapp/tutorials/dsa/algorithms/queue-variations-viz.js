/**
 * Queue Variations Visualization
 * Shows Circular Queue, Deque, and Priority Queue with animations
 */

(function () {
    'use strict';

    class QueueVariationsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.queue = [];
            this.capacity = 5;
            this.isRunning = false;
            this.speed = 1000;
            this.currentType = 'circular';

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Queue Variations</h3>
                    <p class="viz-subtitle">Circular, Deque, Priority Queue</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Type</div>
                        <div class="viz-stat-value" id="queueType">Circular</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Size</div>
                        <div class="viz-stat-value" id="queueSize">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Feature</div>
                        <div class="viz-stat-value" id="featureInfo">Wraps</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose a queue variation to see it in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="queue-var-visual-container" id="queueVarVisual"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Choose Type:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" data-type="circular">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Circular Queue</span>
                            <span class="viz-op-complexity">Wraps Around</span>
                        </button>
                        <button class="viz-op-btn" data-type="deque">
                            <span class="viz-op-icon">↔️</span>
                            <span class="viz-op-label">Deque</span>
                            <span class="viz-op-complexity">Both Ends</span>
                        </button>
                        <button class="viz-op-btn" data-type="priority">
                            <span class="viz-op-icon">⭐</span>
                            <span class="viz-op-label">Priority Queue</span>
                            <span class="viz-op-complexity">By Priority</span>
                        </button>
                        <button class="viz-op-btn viz-op-btn-primary" id="demoBtn">
                            <span class="viz-op-icon">▶️</span>
                            <span class="viz-op-label">Run Demo</span>
                        </button>
                    </div>
                </div>
                
                <div class="viz-controls">
                    <button class="viz-btn" id="vizReset">
                        <span>🔄</span> Reset
                    </button>
                    <div class="viz-slider-group">
                        <div class="viz-slider-label">
                            <span>Speed</span>
                            <span id="speedValue">1000ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="speedSlider" 
                               min="500" max="2000" value="1000" step="100">
                    </div>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.querySelectorAll('[data-type]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    this.currentType = e.currentTarget.dataset.type;
                    this.reset();

                    document.querySelectorAll('[data-type]').forEach(b =>
                        b.classList.remove('viz-op-btn-selected'));
                    e.currentTarget.classList.add('viz-op-btn-selected');
                });
            });

            document.getElementById('demoBtn').addEventListener('click', () => this.runDemo());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });

            document.querySelector('[data-type="circular"]').classList.add('viz-op-btn-selected');
        }

        renderVisualization() {
            const container = document.getElementById('queueVarVisual');
            if (!container) return;

            if (this.currentType === 'circular') {
                this.renderCircular(container);
            } else if (this.currentType === 'deque') {
                this.renderDeque(container);
            } else if (this.currentType === 'priority') {
                this.renderPriority(container);
            }

            document.getElementById('queueSize').textContent = this.queue.length;
        }

        renderCircular(container) {
            container.innerHTML = `
                <div class="queue-var-title">Circular Queue (Capacity: ${this.capacity})</div>
                <div class="queue-var-slots">
                    ${Array(this.capacity).fill(0).map((_, i) => `
                        <div class="queue-var-slot" data-idx="${i}">
                            <div class="queue-var-slot-value">${this.queue[i] !== undefined ? this.queue[i] : '-'}</div>
                            <div class="queue-var-slot-label">Index ${i}</div>
                        </div>
                    `).join('')}
                </div>
            `;
        }

        renderDeque(container) {
            container.innerHTML = `
                <div class="queue-var-title">Deque (Double-Ended Queue)</div>
                <div class="deque-labels">
                    <div class="deque-label-left">← FRONT</div>
                    <div class="deque-label-right">REAR →</div>
                </div>
                <div class="queue-var-elements">
                    ${this.queue.length === 0 ? '<div class="queue-var-empty">Empty</div>' :
                    this.queue.map((item, idx) => `
                        <div class="queue-var-element" data-idx="${idx}">${item}</div>
                      `).join('')}
                </div>
            `;
        }

        renderPriority(container) {
            container.innerHTML = `
                <div class="queue-var-title">Priority Queue (Highest First)</div>
                <div class="queue-var-priority-list">
                    ${this.queue.length === 0 ? '<div class="queue-var-empty">Empty</div>' :
                    this.queue.map((item, idx) => `
                        <div class="queue-var-priority-item" data-idx="${idx}">
                            <div class="priority-badge">P${item.priority}</div>
                            <div class="priority-value">${item.value}</div>
                        </div>
                      `).join('')}
                </div>
            `;
        }

        async runDemo() {
            if (this.isRunning) return;
            this.isRunning = true;

            if (this.currentType === 'circular') {
                await this.demoCircular();
            } else if (this.currentType === 'deque') {
                await this.demoDeque();
            } else if (this.currentType === 'priority') {
                await this.demoPriority();
            }

            this.isRunning = false;
        }

        async demoCircular() {
            document.getElementById('queueType').textContent = 'Circular';
            document.getElementById('featureInfo').textContent = 'Wraps';

            this.queue = [];
            this.renderVisualization();

            document.getElementById('explanation').textContent = 'Enqueuing 5 elements...';
            await this.sleep(this.speed * 0.5);

            for (let i = 0; i < 5; i++) {
                this.queue[i] = 10 * (i + 1);
                this.renderVisualization();
                this.highlightSlot(i, 'new');
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent = 'Queue is full! Dequeuing 2 elements...';
            await this.sleep(this.speed);

            for (let i = 0; i < 2; i++) {
                this.highlightSlot(i, 'remove');
                await this.sleep(this.speed);
                this.queue[i] = undefined;
                this.renderVisualization();
            }

            document.getElementById('explanation').textContent = 'Enqueuing 2 more - wraps to beginning!';
            await this.sleep(this.speed);

            this.queue[0] = 60;
            this.renderVisualization();
            this.highlightSlot(0, 'new');
            await this.sleep(this.speed);

            this.queue[1] = 70;
            this.renderVisualization();
            this.highlightSlot(1, 'new');
            await this.sleep(this.speed);

            document.getElementById('explanation').textContent = '✅ Circular wrapping demonstrated!';
        }

        async demoDeque() {
            document.getElementById('queueType').textContent = 'Deque';
            document.getElementById('featureInfo').textContent = 'Both Ends';

            this.queue = [];
            this.renderVisualization();

            document.getElementById('explanation').textContent = 'Adding to rear...';
            await this.sleep(this.speed * 0.5);

            this.queue.push('B');
            this.renderVisualization();
            await this.sleep(this.speed);

            document.getElementById('explanation').textContent = 'Adding to front...';
            this.queue.unshift('A');
            this.renderVisualization();
            await this.sleep(this.speed);

            document.getElementById('explanation').textContent = 'Adding to rear again...';
            this.queue.push('C');
            this.renderVisualization();
            await this.sleep(this.speed);

            document.getElementById('explanation').textContent = 'Removing from front...';
            await this.sleep(this.speed);
            this.queue.shift();
            this.renderVisualization();
            await this.sleep(this.speed);

            document.getElementById('explanation').textContent = 'Removing from rear...';
            await this.sleep(this.speed);
            this.queue.pop();
            this.renderVisualization();
            await this.sleep(this.speed);

            document.getElementById('explanation').textContent = '✅ Deque allows operations at both ends!';
        }

        async demoPriority() {
            document.getElementById('queueType').textContent = 'Priority';
            document.getElementById('featureInfo').textContent = 'By Priority';

            this.queue = [];
            this.renderVisualization();

            document.getElementById('explanation').textContent = 'Adding tasks with priorities...';
            await this.sleep(this.speed * 0.5);

            const tasks = [
                { value: 'Email', priority: 2 },
                { value: 'Bug Fix', priority: 5 },
                { value: 'Meeting', priority: 3 },
                { value: 'Critical', priority: 10 }
            ];

            for (const task of tasks) {
                this.queue.push(task);
                this.queue.sort((a, b) => b.priority - a.priority);
                this.renderVisualization();
                document.getElementById('explanation').textContent =
                    `Added ${task.value} (Priority ${task.priority})`;
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent = 'Processing highest priority first...';
            await this.sleep(this.speed);

            while (this.queue.length > 0) {
                const task = this.queue.shift();
                document.getElementById('explanation').textContent =
                    `Processing: ${task.value} (Priority ${task.priority})`;
                this.renderVisualization();
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent = '✅ Highest priority served first!';
        }

        highlightSlot(idx, type) {
            const slot = document.querySelector(`[data-idx="${idx}"]`);
            if (slot) {
                slot.classList.add(`queue-var-slot-${type}`);
                setTimeout(() => {
                    slot.classList.remove(`queue-var-slot-${type}`);
                }, this.speed);
            }
        }

        reset() {
            this.queue = [];
            this.isRunning = false;
            document.getElementById('explanation').textContent = 'Choose a queue variation to see it in action!';
            this.renderVisualization();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new QueueVariationsViz('queueVariationsVisualization');
        });
    } else {
        new QueueVariationsViz('queueVariationsVisualization');
    }
})();
