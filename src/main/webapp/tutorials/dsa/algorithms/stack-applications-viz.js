/**
 * Stack Applications Visualization
 * Shows balanced parentheses and expression evaluation
 */

(function () {
    'use strict';

    class StackApplicationsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.stack = [];
            this.isRunning = false;
            this.speed = 1200;
            this.currentApp = 'balanced';

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Stack Applications</h3>
                    <p class="viz-subtitle">Real-world uses of stacks</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Application</div>
                        <div class="viz-stat-value" id="appName">Balanced</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Stack Size</div>
                        <div class="viz-stat-value" id="stackSize">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Status</div>
                        <div class="viz-stat-value" id="statusInfo">Ready</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose an application to see stacks in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="stack-app-container">
                        <div class="stack-app-input" id="inputArea"></div>
                        <div class="stack-app-visual" id="stackAppVisual"></div>
                    </div>
                </div>
                
                <div class="viz-operations">
                    <h4>Choose Application:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" data-app="balanced">
                            <span class="viz-op-icon">( )</span>
                            <span class="viz-op-label">Balanced Parentheses</span>
                            <span class="viz-op-complexity">Most Common!</span>
                        </button>
                        <button class="viz-op-btn" data-app="postfix">
                            <span class="viz-op-icon">🧮</span>
                            <span class="viz-op-label">Evaluate Postfix</span>
                            <span class="viz-op-complexity">Calculator</span>
                        </button>
                        <button class="viz-op-btn" data-app="infix">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Infix to Postfix</span>
                            <span class="viz-op-complexity">Conversion</span>
                        </button>
                        <button class="viz-op-btn" data-app="undo">
                            <span class="viz-op-icon">↩️</span>
                            <span class="viz-op-label">Undo/Redo</span>
                            <span class="viz-op-complexity">Two Stacks</span>
                        </button>
                    </div>
                </div>
                
                <div class="viz-controls">
                    <button class="viz-btn viz-btn-primary" id="vizStart">
                        <span>▶️</span> Start
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
            document.querySelectorAll('[data-app]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    this.currentApp = e.currentTarget.dataset.app;
                    this.reset();

                    document.querySelectorAll('[data-app]').forEach(b =>
                        b.classList.remove('viz-op-btn-selected'));
                    e.currentTarget.classList.add('viz-op-btn-selected');
                });
            });

            document.getElementById('vizStart').addEventListener('click', () => this.start());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });

            // Select balanced by default
            document.querySelector('[data-app="balanced"]').classList.add('viz-op-btn-selected');
        }

        renderVisualization() {
            const inputArea = document.getElementById('inputArea');
            const stackArea = document.getElementById('stackAppVisual');

            if (!inputArea || !stackArea) return;

            if (this.currentApp === 'balanced') {
                inputArea.innerHTML = '<div class="app-input-label">Expression: {[()]}</div>';
                this.renderStack(stackArea);
            } else if (this.currentApp === 'postfix') {
                inputArea.innerHTML = '<div class="app-input-label">Postfix: 23*5+</div>';
                this.renderStack(stackArea);
            } else if (this.currentApp === 'infix') {
                inputArea.innerHTML = '<div class="app-input-label">Infix: A+B*C</div>';
                this.renderStack(stackArea);
            } else if (this.currentApp === 'undo') {
                inputArea.innerHTML = '<div class="app-input-label">Text: Hello</div>';
                this.renderUndoRedo(stackArea);
            }

            document.getElementById('stackSize').textContent = this.stack.length;
        }

        renderStack(container) {
            container.innerHTML = `
                <div class="stack-app-label">Stack:</div>
                <div class="stack-app-elements" id="stackElements">
                    ${this.stack.length === 0 ? '<div class="stack-app-empty">Empty</div>' :
                    this.stack.map((item, idx) => `
                        <div class="stack-app-element" data-idx="${idx}">
                            ${item}
                        </div>
                      `).reverse().join('')}
                </div>
            `;
        }

        renderUndoRedo(container) {
            container.innerHTML = `
                <div class="undo-redo-container">
                    <div class="undo-stack">
                        <div class="stack-app-label">Undo Stack</div>
                        <div class="stack-app-elements">
                            ${this.stack.length === 0 ? '<div class="stack-app-empty">Empty</div>' :
                    this.stack.map(item => `<div class="stack-app-element">${item}</div>`).reverse().join('')}
                        </div>
                    </div>
                    <div class="undo-stack">
                        <div class="stack-app-label">Redo Stack</div>
                        <div class="stack-app-elements">
                            <div class="stack-app-empty">Empty</div>
                        </div>
                    </div>
                </div>
            `;
        }

        async start() {
            if (this.isRunning) return;

            this.isRunning = true;
            document.getElementById('vizStart').disabled = true;

            if (this.currentApp === 'balanced') {
                await this.runBalanced();
            } else if (this.currentApp === 'postfix') {
                await this.runPostfix();
            } else if (this.currentApp === 'infix') {
                await this.runInfixToPostfix();
            } else if (this.currentApp === 'undo') {
                await this.runUndoRedo();
            }

            document.getElementById('vizStart').disabled = false;
            this.isRunning = false;
        }

        async runBalanced() {
            document.getElementById('appName').textContent = 'Balanced';
            document.getElementById('explanation').textContent =
                'Checking if {[()]} is balanced...';

            const expression = '{[()]}';
            this.stack = [];

            const inputArea = document.getElementById('inputArea');
            inputArea.innerHTML = `<div class="app-input-display">${expression.split('').map((c, i) =>
                `<span class="input-char" data-idx="${i}">${c}</span>`).join('')}</div>`;

            await this.sleep(this.speed * 0.5);

            for (let i = 0; i < expression.length; i++) {
                const char = expression[i];
                const charElem = document.querySelector(`[data-idx="${i}"]`);

                if (charElem) charElem.classList.add('input-char-active');

                if (char === '{' || char === '[' || char === '(') {
                    document.getElementById('explanation').textContent =
                        `Found opening '${char}' - push to stack`;
                    this.stack.push(char);
                    this.renderStack(document.getElementById('stackAppVisual'));
                    await this.sleep(this.speed);
                } else {
                    const top = this.stack.pop();
                    document.getElementById('explanation').textContent =
                        `Found closing '${char}' - matches '${top}' ✓`;
                    this.renderStack(document.getElementById('stackAppVisual'));
                    await this.sleep(this.speed);
                }

                if (charElem) charElem.classList.remove('input-char-active');
            }

            document.getElementById('statusInfo').textContent = 'Balanced ✓';
            document.getElementById('explanation').textContent =
                '✅ All brackets matched! Stack is empty = BALANCED';
        }

        async runPostfix() {
            document.getElementById('appName').textContent = 'Postfix';
            document.getElementById('explanation').textContent =
                'Evaluating 23*5+...';

            const expression = '23*5+';
            this.stack = [];

            const inputArea = document.getElementById('inputArea');
            inputArea.innerHTML = `<div class="app-input-display">${expression.split('').map((c, i) =>
                `<span class="input-char" data-idx="${i}">${c}</span>`).join('')}</div>`;

            await this.sleep(this.speed * 0.5);

            for (let i = 0; i < expression.length; i++) {
                const char = expression[i];
                const charElem = document.querySelector(`[data-idx="${i}"]`);

                if (charElem) charElem.classList.add('input-char-active');

                if (char >= '0' && char <= '9') {
                    document.getElementById('explanation').textContent =
                        `Operand ${char} - push to stack`;
                    this.stack.push(char);
                    this.renderStack(document.getElementById('stackAppVisual'));
                    await this.sleep(this.speed);
                } else {
                    const b = this.stack.pop();
                    const a = this.stack.pop();
                    let result;
                    if (char === '*') result = parseInt(a) * parseInt(b);
                    if (char === '+') result = parseInt(a) + parseInt(b);

                    document.getElementById('explanation').textContent =
                        `Operator ${char} - compute ${a} ${char} ${b} = ${result}`;
                    this.stack.push(result.toString());
                    this.renderStack(document.getElementById('stackAppVisual'));
                    await this.sleep(this.speed);
                }

                if (charElem) charElem.classList.remove('input-char-active');
            }

            document.getElementById('statusInfo').textContent = this.stack[0];
            document.getElementById('explanation').textContent =
                `✅ Result: ${this.stack[0]} (2*3+5 = 11)`;
        }

        async runInfixToPostfix() {
            document.getElementById('appName').textContent = 'Infix→Postfix';
            document.getElementById('explanation').textContent =
                'Converting A+B*C to postfix...';

            await this.sleep(this.speed);

            document.getElementById('statusInfo').textContent = 'ABC*+';
            document.getElementById('explanation').textContent =
                '✅ Postfix: ABC*+ (B*C first, then +A)';
        }

        async runUndoRedo() {
            document.getElementById('appName').textContent = 'Undo/Redo';
            document.getElementById('explanation').textContent =
                'Demonstrating undo/redo with two stacks...';

            await this.sleep(this.speed);

            document.getElementById('statusInfo').textContent = 'Demo';
            document.getElementById('explanation').textContent =
                '✅ Two stacks: Undo stack stores history, Redo stack stores undone actions';
        }

        reset() {
            this.stack = [];
            this.isRunning = false;
            document.getElementById('explanation').textContent =
                'Choose an application to see stacks in action!';
            document.getElementById('statusInfo').textContent = 'Ready';
            this.renderVisualization();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new StackApplicationsViz('stackApplicationsVisualization');
        });
    } else {
        new StackApplicationsViz('stackApplicationsVisualization');
    }
})();
