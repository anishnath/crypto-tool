/**
 * Queue Basics Visualization
 * Shows FIFO operations with circular array wrapping
 */

(function () {
    'use strict';

    class QueueViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.queue = [];
            this.capacity = 6;
            this.front = 0;
            this.rear = -1;
            this.isRunning = false;
            this.speed = 1000;

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Queue - FIFO (First In, First Out)</h3>
                    <p class="viz-subtitle">Elements enter at rear, exit from front</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Size</div>
                        <div class="viz-stat-value" id="queueSize">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Front Element</div>
                        <div class="viz-stat-value" id="frontElement">-</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Principle</div>
                        <div class="viz-stat-value">FIFO</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Try enqueue and dequeue operations to see FIFO in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="queue-viz-container">
                        <div class="queue-label">FRONT</div>
                        <div class="queue-visual" id="queueVisual"></div>
                        <div class="queue-label">REAR</div>
                    </div>
                </div>
                
                <div class="viz-operations">
                    <h4>Operations:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" id="enqueueBtn">
                            <span class="viz-op-icon">➡️</span>
                            <span class="viz-op-label">Enqueue</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="dequeueBtn">
                            <span class="viz-op-icon">⬅️</span>
                            <span class="viz-op-label">Dequeue</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="peekBtn">
                            <span class="viz-op-icon">👁️</span>
                            <span class="viz-op-label">Peek</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="fifoDemo">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">FIFO Demo</span>
                            <span class="viz-op-complexity">Animation</span>
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
            document.getElementById('enqueueBtn').addEventListener('click', () => this.enqueue());
            document.getElementById('dequeueBtn').addEventListener('click', () => this.dequeue());
            document.getElementById('peekBtn').addEventListener('click', () => this.peek());
            document.getElementById('fifoDemo').addEventListener('click', () => this.fifoDemo());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });
        }

        renderVisualization() {
            const container = document.getElementById('queueVisual');
            if (!container) return;

            container.innerHTML = '';

            // Create slots for circular array
            for (let i = 0; i < this.capacity; i++) {
                const slot = document.createElement('div');
                slot.className = 'queue-slot';
                slot.dataset.idx = i;

                const value = this.queue[i];
                if (value !== undefined) {
                    slot.innerHTML = `
                        <div class="queue-slot-value">${value}</div>
                        ${i === this.front ? '<div class="queue-front-marker">FRONT</div>' : ''}
                        ${i === this.rear ? '<div class="queue-rear-marker">REAR</div>' : ''}
                    `;
                    slot.classList.add('queue-slot-filled');
                } else {
                    slot.innerHTML = '<div class="queue-slot-empty">-</div>';
                }

                container.appendChild(slot);
            }

            this.updateStats();
        }

        updateStats() {
            const size = this.queue.filter(x => x !== undefined).length;
            document.getElementById('queueSize').textContent = size;
            document.getElementById('frontElement').textContent =
                this.queue[this.front] !== undefined ? this.queue[this.front] : '-';
        }

        async enqueue() {
            if (this.isRunning) return;

            const size = this.queue.filter(x => x !== undefined).length;
            if (size >= this.capacity) {
                document.getElementById('explanation').textContent =
                    `⚠️ Queue is full (max ${this.capacity} elements)`;
                return;
            }

            this.isRunning = true;

            const value = size > 0 && this.queue[this.rear] !== undefined
                ? this.queue[this.rear] + 10
                : 10;

            document.getElementById('explanation').textContent =
                `Enqueuing ${value} at rear...`;

            await this.sleep(this.speed * 0.3);

            // Circular increment
            this.rear = (this.rear + 1) % this.capacity;
            this.queue[this.rear] = value;

            this.renderVisualization();

            // Animate new element
            const newSlot = document.querySelector(`[data-idx="${this.rear}"]`);
            if (newSlot) {
                newSlot.classList.add('queue-slot-new');
                await this.sleep(this.speed);
                newSlot.classList.remove('queue-slot-new');
            }

            document.getElementById('explanation').textContent =
                `✅ Enqueued ${value} at index ${this.rear}. Size: ${this.queue.filter(x => x !== undefined).length}`;

            this.isRunning = false;
        }

        async dequeue() {
            if (this.isRunning) return;

            if (this.queue[this.front] === undefined) {
                document.getElementById('explanation').textContent =
                    '✗ Cannot dequeue - queue is empty!';
                return;
            }

            this.isRunning = true;

            const value = this.queue[this.front];

            document.getElementById('explanation').textContent =
                `Dequeuing ${value} from front...`;

            // Animate element being removed
            const slot = document.querySelector(`[data-idx="${this.front}"]`);
            if (slot) {
                slot.classList.add('queue-slot-dequeue');
                await this.sleep(this.speed);
            }

            this.queue[this.front] = undefined;
            this.front = (this.front + 1) % this.capacity;

            this.renderVisualization();

            document.getElementById('explanation').textContent =
                `✅ Dequeued ${value}. Size: ${this.queue.filter(x => x !== undefined).length}`;

            this.isRunning = false;
        }

        async peek() {
            if (this.isRunning) return;

            if (this.queue[this.front] === undefined) {
                document.getElementById('explanation').textContent =
                    '✗ Cannot peek - queue is empty!';
                return;
            }

            this.isRunning = true;

            const value = this.queue[this.front];

            document.getElementById('explanation').textContent =
                `Peeking at front element...`;

            // Highlight front element
            const slot = document.querySelector(`[data-idx="${this.front}"]`);
            if (slot) {
                slot.classList.add('queue-slot-peek');
                await this.sleep(this.speed);
                slot.classList.remove('queue-slot-peek');
            }

            document.getElementById('explanation').textContent =
                `👁️ Front element is ${value} (not removed)`;

            this.isRunning = false;
        }

        async fifoDemo() {
            if (this.isRunning) return;

            this.isRunning = true;
            this.queue = new Array(this.capacity);
            this.front = 0;
            this.rear = -1;
            this.renderVisualization();

            document.getElementById('explanation').textContent =
                'FIFO Demo: Watch First In, First Out...';

            await this.sleep(this.speed);

            // Enqueue A, B, C
            const items = ['A', 'B', 'C'];
            for (const item of items) {
                document.getElementById('explanation').textContent =
                    `Enqueuing ${item}...`;

                this.rear = (this.rear + 1) % this.capacity;
                this.queue[this.rear] = item;
                this.renderVisualization();

                const newSlot = document.querySelector(`[data-idx="${this.rear}"]`);
                if (newSlot) {
                    newSlot.classList.add('queue-slot-new');
                    await this.sleep(this.speed);
                    newSlot.classList.remove('queue-slot-new');
                }
            }

            await this.sleep(this.speed);

            document.getElementById('explanation').textContent =
                'Now dequeuing: A was first in, so A comes out first!';
            await this.sleep(this.speed * 1.5);

            // Dequeue A, B, C
            while (this.queue[this.front] !== undefined) {
                const value = this.queue[this.front];
                document.getElementById('explanation').textContent =
                    `Dequeuing ${value} (first in, first out)...`;

                const slot = document.querySelector(`[data-idx="${this.front}"]`);
                if (slot) {
                    slot.classList.add('queue-slot-dequeue');
                    await this.sleep(this.speed);
                }

                this.queue[this.front] = undefined;
                this.front = (this.front + 1) % this.capacity;
                this.renderVisualization();
                await this.sleep(this.speed * 0.5);
            }

            document.getElementById('explanation').textContent =
                '✅ FIFO Demo complete! Order: A, B, C (same as enqueue order)';

            this.isRunning = false;
        }

        reset() {
            this.queue = [10, 20, 30];
            this.front = 0;
            this.rear = 2;
            this.isRunning = false;
            document.getElementById('explanation').textContent =
                'Try enqueue and dequeue operations to see FIFO in action!';
            this.renderVisualization();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new QueueViz('queueBasicsVisualization');
        });
    } else {
        new QueueViz('queueBasicsVisualization');
    }
})();
