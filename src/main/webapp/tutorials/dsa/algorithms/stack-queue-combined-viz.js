/**
 * Combined Stack & Queue Problems Visualization
 * Enhanced with actual algorithm animations
 */

(function () {
    'use strict';

    class CombinedViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.stack1 = [];
            this.stack2 = [];
            this.isRunning = false;
            this.speed = 1000;
            this.currentDemo = 'queue-stacks';

            this.init();
        }

        init() {
            this.render();
            this.updateDisplay();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Combined Stack & Queue Problems</h3>
                    <p class="viz-subtitle">Advanced interview problems with animations</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Problem</div>
                        <div class="viz-stat-value" id="problemName">Queue using Stacks</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value" id="complexity">O(1) amortized</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Status</div>
                        <div class="viz-stat-value" id="statusInfo">Ready</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose a problem to see the solution in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="combined-viz-display" id="vizDisplay"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Choose Problem:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" data-demo="queue-stacks">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Queue using Stacks</span>
                            <span class="viz-op-complexity">O(1) amortized</span>
                        </button>
                        <button class="viz-op-btn" data-demo="next-greater">
                            <span class="viz-op-icon">📊</span>
                            <span class="viz-op-label">Next Greater Element</span>
                            <span class="viz-op-complexity">O(n)</span>
                        </button>
                        <button class="viz-op-btn" data-demo="min-stack">
                            <span class="viz-op-icon">⬇️</span>
                            <span class="viz-op-label">Min Stack</span>
                            <span class="viz-op-complexity">O(1) getMin</span>
                        </button>
                        <button class="viz-op-btn viz-op-btn-primary" id="runDemo">
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
            document.querySelectorAll('[data-demo]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    this.currentDemo = e.currentTarget.dataset.demo;
                    document.querySelectorAll('[data-demo]').forEach(b =>
                        b.classList.remove('viz-op-btn-selected'));
                    e.currentTarget.classList.add('viz-op-btn-selected');
                    this.reset();
                });
            });

            document.getElementById('runDemo').addEventListener('click', () => this.runDemo());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });

            document.querySelector('[data-demo="queue-stacks"]').classList.add('viz-op-btn-selected');
        }

        updateDisplay() {
            const display = document.getElementById('vizDisplay');

            if (this.currentDemo === 'queue-stacks') {
                document.getElementById('problemName').textContent = 'Queue using Stacks';
                document.getElementById('complexity').textContent = 'O(1) amortized';
                display.innerHTML = `
                    <div class="combined-demo-title">Queue using Two Stacks</div>
                    <div class="combined-stacks-container">
                        <div class="combined-stack-box">
                            <div class="stack-box-label">Stack 1 (Enqueue)</div>
                            <div class="stack-box-elements" id="stack1">
                                ${this.stack1.length === 0 ? '<div class="stack-empty">Empty</div>' :
                        this.stack1.map(item => `<div class="stack-item">${item}</div>`).reverse().join('')}
                            </div>
                        </div>
                        <div class="combined-arrow">→</div>
                        <div class="combined-stack-box">
                            <div class="stack-box-label">Stack 2 (Dequeue)</div>
                            <div class="stack-box-elements" id="stack2">
                                ${this.stack2.length === 0 ? '<div class="stack-empty">Empty</div>' :
                        this.stack2.map(item => `<div class="stack-item">${item}</div>`).reverse().join('')}
                            </div>
                        </div>
                    </div>
                `;
            } else if (this.currentDemo === 'next-greater') {
                document.getElementById('problemName').textContent = 'Next Greater';
                document.getElementById('complexity').textContent = 'O(n)';
                display.innerHTML = `
                    <div class="combined-demo-title">Next Greater Element</div>
                    <div class="combined-array-display">
                        <div class="array-label">Input Array:</div>
                        <div class="array-elements">
                            <div class="array-elem">4</div>
                            <div class="array-elem">5</div>
                            <div class="array-elem">2</div>
                            <div class="array-elem">25</div>
                        </div>
                    </div>
                    <div class="combined-result-display">
                        <div class="array-label">Next Greater:</div>
                        <div class="array-elements" id="nextGreaterResult">
                            <div class="array-elem result-empty">?</div>
                            <div class="array-elem result-empty">?</div>
                            <div class="array-elem result-empty">?</div>
                            <div class="array-elem result-empty">?</div>
                        </div>
                    </div>
                    <div class="combined-stack-display">
                        <div class="stack-label-small">Monotonic Stack:</div>
                        <div class="stack-small" id="monotonicStack"></div>
                    </div>
                `;
            } else if (this.currentDemo === 'min-stack') {
                document.getElementById('problemName').textContent = 'Min Stack';
                document.getElementById('complexity').textContent = 'O(1) all ops';
                display.innerHTML = `
                    <div class="combined-demo-title">Min Stack (O(1) getMin)</div>
                    <div class="combined-stacks-container">
                        <div class="combined-stack-box">
                            <div class="stack-box-label">Main Stack</div>
                            <div class="stack-box-elements" id="mainStack">
                                <div class="stack-empty">Empty</div>
                            </div>
                        </div>
                        <div class="combined-stack-box">
                            <div class="stack-box-label">Min Stack</div>
                            <div class="stack-box-elements" id="minStack">
                                <div class="stack-empty">Empty</div>
                            </div>
                        </div>
                    </div>
                    <div class="min-display">Current Min: <span id="currentMin">-</span></div>
                `;
            }
        }

        async runDemo() {
            if (this.isRunning) return;
            this.isRunning = true;

            if (this.currentDemo === 'queue-stacks') {
                await this.demoQueueStacks();
            } else if (this.currentDemo === 'next-greater') {
                await this.demoNextGreater();
            } else if (this.currentDemo === 'min-stack') {
                await this.demoMinStack();
            }

            this.isRunning = false;
        }

        async demoQueueStacks() {
            this.stack1 = [];
            this.stack2 = [];
            this.updateDisplay();

            document.getElementById('explanation').textContent = 'Enqueuing 1, 2, 3 to Stack1...';
            document.getElementById('statusInfo').textContent = 'Enqueue';
            await this.sleep(this.speed * 0.5);

            for (let val of [1, 2, 3]) {
                this.stack1.push(val);
                this.updateDisplay();
                this.highlightStack('stack1');
                document.getElementById('explanation').textContent = `Enqueued ${val} to Stack1`;
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent = 'Dequeuing: Transfer Stack1 → Stack2...';
            document.getElementById('statusInfo').textContent = 'Transfer';
            await this.sleep(this.speed);

            while (this.stack1.length > 0) {
                const val = this.stack1.pop();
                this.stack2.push(val);
                this.updateDisplay();
                this.highlightStack('stack2');
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent = 'Dequeuing from Stack2 (FIFO order!)...';
            document.getElementById('statusInfo').textContent = 'Dequeue';
            await this.sleep(this.speed);

            const dequeued = this.stack2.pop();
            this.updateDisplay();
            document.getElementById('explanation').textContent =
                `✅ Dequeued ${dequeued} - First In, First Out!`;
            document.getElementById('statusInfo').textContent = 'Complete';
        }

        async demoNextGreater() {
            const arr = [4, 5, 2, 25];
            const result = [-1, -1, -1, -1];
            const stack = [];

            document.getElementById('explanation').textContent =
                'Finding next greater element using monotonic stack...';
            document.getElementById('statusInfo').textContent = 'Processing';

            for (let i = 0; i < arr.length; i++) {
                document.getElementById('explanation').textContent =
                    `Processing element ${arr[i]} at index ${i}...`;

                this.highlightArrayElem(i);
                await this.sleep(this.speed);

                while (stack.length > 0 && arr[stack[stack.length - 1]] < arr[i]) {
                    const idx = stack.pop();
                    result[idx] = arr[i];
                    this.updateNextGreaterResult(result);
                    document.getElementById('explanation').textContent =
                        `Found! Next greater for ${arr[idx]} is ${arr[i]}`;
                    await this.sleep(this.speed);
                }

                stack.push(i);
                this.updateMonotonicStack(stack, arr);
                await this.sleep(this.speed);
            }

            this.updateNextGreaterResult(result);
            document.getElementById('explanation').textContent =
                '✅ Complete! Result: [5, 25, 25, -1]';
            document.getElementById('statusInfo').textContent = 'Complete';
        }

        async demoMinStack() {
            const mainStack = [];
            const minStack = [];
            const values = [5, 3, 7, 1, 9];

            document.getElementById('explanation').textContent = 'Pushing values with min tracking...';
            document.getElementById('statusInfo').textContent = 'Pushing';

            for (const val of values) {
                mainStack.push(val);
                if (minStack.length === 0 || val <= minStack[minStack.length - 1]) {
                    minStack.push(val);
                }

                this.updateMinStackDisplay(mainStack, minStack);
                document.getElementById('explanation').textContent =
                    `Pushed ${val}, Current min: ${minStack[minStack.length - 1]}`;
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent = 'Popping values...';
            document.getElementById('statusInfo').textContent = 'Popping';
            await this.sleep(this.speed);

            for (let i = 0; i < 2; i++) {
                const val = mainStack.pop();
                if (val === minStack[minStack.length - 1]) {
                    minStack.pop();
                }
                this.updateMinStackDisplay(mainStack, minStack);
                document.getElementById('explanation').textContent =
                    `Popped ${val}, Current min: ${minStack.length > 0 ? minStack[minStack.length - 1] : '-'}`;
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent =
                '✅ All operations O(1)!';
            document.getElementById('statusInfo').textContent = 'Complete';
        }

        updateNextGreaterResult(result) {
            const container = document.getElementById('nextGreaterResult');
            if (container) {
                container.innerHTML = result.map(val =>
                    `<div class="array-elem ${val === -1 ? 'result-empty' : 'result-found'}">${val === -1 ? '-1' : val}</div>`
                ).join('');
            }
        }

        updateMonotonicStack(stack, arr) {
            const container = document.getElementById('monotonicStack');
            if (container) {
                container.innerHTML = stack.length === 0 ? '<div class="stack-empty-small">Empty</div>' :
                    stack.map(idx => `<div class="stack-item-small">${arr[idx]}</div>`).reverse().join('');
            }
        }

        updateMinStackDisplay(mainStack, minStack) {
            const mainContainer = document.getElementById('mainStack');
            const minContainer = document.getElementById('minStack');
            const currentMin = document.getElementById('currentMin');

            if (mainContainer) {
                mainContainer.innerHTML = mainStack.length === 0 ? '<div class="stack-empty">Empty</div>' :
                    mainStack.map(val => `<div class="stack-item">${val}</div>`).reverse().join('');
            }

            if (minContainer) {
                minContainer.innerHTML = minStack.length === 0 ? '<div class="stack-empty">Empty</div>' :
                    minStack.map(val => `<div class="stack-item stack-item-min">${val}</div>`).reverse().join('');
            }

            if (currentMin) {
                currentMin.textContent = minStack.length > 0 ? minStack[minStack.length - 1] : '-';
            }
        }

        highlightStack(stackId) {
            const elem = document.getElementById(stackId);
            if (elem) {
                elem.classList.add('stack-highlight');
                setTimeout(() => elem.classList.remove('stack-highlight'), this.speed);
            }
        }

        highlightArrayElem(idx) {
            const elems = document.querySelectorAll('.array-elem');
            if (elems[idx]) {
                elems[idx].classList.add('array-elem-active');
                setTimeout(() => elems[idx].classList.remove('array-elem-active'), this.speed);
            }
        }

        reset() {
            this.stack1 = [];
            this.stack2 = [];
            this.isRunning = false;
            document.getElementById('explanation').textContent = 'Choose a problem to see the solution in action!';
            document.getElementById('statusInfo').textContent = 'Ready';
            this.updateDisplay();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new CombinedViz('combinedVisualization');
        });
    } else {
        new CombinedViz('combinedVisualization');
    }
})();
