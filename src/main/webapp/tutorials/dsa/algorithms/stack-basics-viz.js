/**
 * Stack Basics Visualization
 * Shows LIFO operations with animated push and pop
 */

(function () {
    'use strict';

    class StackViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.stack = [];
            this.maxSize = 8;
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
                    <h3>Stack - LIFO (Last In, First Out)</h3>
                    <p class="viz-subtitle">Watch elements enter and exit from the top</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Size</div>
                        <div class="viz-stat-value" id="stackSize">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Top Element</div>
                        <div class="viz-stat-value" id="topElement">-</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Principle</div>
                        <div class="viz-stat-value">LIFO</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Try push and pop operations to see LIFO in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="stack-viz-container">
                        <div class="stack-label">TOP</div>
                        <div class="stack-visual" id="stackVisual"></div>
                        <div class="stack-label">BOTTOM</div>
                    </div>
                </div>
                
                <div class="viz-operations">
                    <h4>Operations:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" id="pushBtn">
                            <span class="viz-op-icon">⬆️</span>
                            <span class="viz-op-label">Push</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="popBtn">
                            <span class="viz-op-icon">⬇️</span>
                            <span class="viz-op-label">Pop</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="peekBtn">
                            <span class="viz-op-icon">👁️</span>
                            <span class="viz-op-label">Peek</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="lifoDemo">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">LIFO Demo</span>
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
            document.getElementById('pushBtn').addEventListener('click', () => this.push());
            document.getElementById('popBtn').addEventListener('click', () => this.pop());
            document.getElementById('peekBtn').addEventListener('click', () => this.peek());
            document.getElementById('lifoDemo').addEventListener('click', () => this.lifoDemo());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });
        }

        renderVisualization() {
            const container = document.getElementById('stackVisual');
            if (!container) return;

            container.innerHTML = '';

            if (this.stack.length === 0) {
                container.innerHTML = '<div class="stack-empty">Stack is empty</div>';
            } else {
                // Render from top to bottom
                for (let i = this.stack.length - 1; i >= 0; i--) {
                    const element = document.createElement('div');
                    element.className = 'stack-element';
                    element.dataset.idx = i;
                    element.innerHTML = `
                        <div class="stack-element-value">${this.stack[i]}</div>
                        ${i === this.stack.length - 1 ? '<div class="stack-top-indicator">← TOP</div>' : ''}
                    `;
                    container.appendChild(element);
                }
            }

            this.updateStats();
        }

        updateStats() {
            document.getElementById('stackSize').textContent = this.stack.length;
            document.getElementById('topElement').textContent =
                this.stack.length > 0 ? this.stack[this.stack.length - 1] : '-';
        }

        async push() {
            if (this.isRunning) return;
            if (this.stack.length >= this.maxSize) {
                document.getElementById('explanation').textContent =
                    `⚠️ Stack is full (max ${this.maxSize} elements)`;
                return;
            }

            this.isRunning = true;

            const value = this.stack.length > 0
                ? this.stack[this.stack.length - 1] + 10
                : 10;

            document.getElementById('explanation').textContent =
                `Pushing ${value} onto stack...`;

            await this.sleep(this.speed * 0.3);

            this.stack.push(value);
            this.renderVisualization();

            // Animate new element
            const newElement = document.querySelector(`[data-idx="${this.stack.length - 1}"]`);
            if (newElement) {
                newElement.classList.add('stack-element-new');
                await this.sleep(this.speed);
                newElement.classList.remove('stack-element-new');
            }

            document.getElementById('explanation').textContent =
                `✅ Pushed ${value}. Stack size: ${this.stack.length}`;

            this.isRunning = false;
        }

        async pop() {
            if (this.isRunning) return;
            if (this.stack.length === 0) {
                document.getElementById('explanation').textContent =
                    '✗ Cannot pop - stack is empty!';
                return;
            }

            this.isRunning = true;

            const value = this.stack[this.stack.length - 1];

            document.getElementById('explanation').textContent =
                `Popping ${value} from stack...`;

            // Animate element being removed
            const element = document.querySelector(`[data-idx="${this.stack.length - 1}"]`);
            if (element) {
                element.classList.add('stack-element-pop');
                await this.sleep(this.speed);
            }

            this.stack.pop();
            this.renderVisualization();

            document.getElementById('explanation').textContent =
                `✅ Popped ${value}. Stack size: ${this.stack.length}`;

            this.isRunning = false;
        }

        async peek() {
            if (this.isRunning) return;
            if (this.stack.length === 0) {
                document.getElementById('explanation').textContent =
                    '✗ Cannot peek - stack is empty!';
                return;
            }

            this.isRunning = true;

            const value = this.stack[this.stack.length - 1];

            document.getElementById('explanation').textContent =
                `Peeking at top element...`;

            // Highlight top element
            const element = document.querySelector(`[data-idx="${this.stack.length - 1}"]`);
            if (element) {
                element.classList.add('stack-element-peek');
                await this.sleep(this.speed);
                element.classList.remove('stack-element-peek');
            }

            document.getElementById('explanation').textContent =
                `👁️ Top element is ${value} (not removed)`;

            this.isRunning = false;
        }

        async lifoDemo() {
            if (this.isRunning) return;

            this.isRunning = true;
            this.stack = [];
            this.renderVisualization();

            document.getElementById('explanation').textContent =
                'LIFO Demo: Watch Last In, First Out...';

            await this.sleep(this.speed);

            // Push A, B, C
            const items = ['A', 'B', 'C'];
            for (const item of items) {
                document.getElementById('explanation').textContent =
                    `Pushing ${item}...`;
                this.stack.push(item);
                this.renderVisualization();

                const newElement = document.querySelector(`[data-idx="${this.stack.length - 1}"]`);
                if (newElement) {
                    newElement.classList.add('stack-element-new');
                    await this.sleep(this.speed);
                    newElement.classList.remove('stack-element-new');
                }
            }

            await this.sleep(this.speed);

            document.getElementById('explanation').textContent =
                'Now popping: C was last in, so C comes out first!';
            await this.sleep(this.speed * 1.5);

            // Pop C, B, A
            while (this.stack.length > 0) {
                const value = this.stack[this.stack.length - 1];
                document.getElementById('explanation').textContent =
                    `Popping ${value} (last in, first out)...`;

                const element = document.querySelector(`[data-idx="${this.stack.length - 1}"]`);
                if (element) {
                    element.classList.add('stack-element-pop');
                    await this.sleep(this.speed);
                }

                this.stack.pop();
                this.renderVisualization();
                await this.sleep(this.speed * 0.5);
            }

            document.getElementById('explanation').textContent =
                '✅ LIFO Demo complete! Order: C, B, A (reverse of push order)';

            this.isRunning = false;
        }

        reset() {
            this.stack = [10, 20, 30];
            this.isRunning = false;
            document.getElementById('explanation').textContent =
                'Try push and pop operations to see LIFO in action!';
            this.renderVisualization();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new StackViz('stackBasicsVisualization');
        });
    } else {
        new StackViz('stackBasicsVisualization');
    }
})();
