/**
 * Linked List Reversal Visualization
 * Shows the 3-pointer technique step-by-step
 */

(function () {
    'use strict';

    class ReversalViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.list = [1, 2, 3, 4];
            this.isRunning = false;
            this.speed = 1500;
            this.currentStep = 0;
            this.steps = [];

            this.init();
        }

        init() {
            this.render();
            this.generateSteps();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Linked List Reversal - The 3-Pointer Technique</h3>
                    <p class="viz-subtitle">Watch how prev, current, and next pointers work together</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Current Step</div>
                        <div class="viz-stat-value" id="currentStep">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Pointers</div>
                        <div class="viz-stat-value" id="pointerInfo">Ready</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(n) time, O(1) space</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Click Start to see the 3-pointer reversal technique!
                </div>
                
                <div class="viz-canvas">
                    <div class="reversal-viz" id="reversalViz"></div>
                </div>
                
                <div class="viz-controls">
                    <button class="viz-btn viz-btn-primary" id="vizStart">
                        <span>▶️</span> Start Reversal
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
                            <span id="speedValue">1500ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="speedSlider" 
                               min="800" max="2500" value="1500" step="200">
                    </div>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.getElementById('vizStart').addEventListener('click', () => this.start());
            document.getElementById('vizPause').addEventListener('click', () => this.pause());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });
        }

        generateSteps() {
            this.steps = [
                {
                    list: [1, 2, 3, 4],
                    prev: null,
                    current: 0,
                    next: 1,
                    reversed: [],
                    description: 'Initial state: prev=null, current=1, next=2'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: null,
                    current: 0,
                    next: 1,
                    reversed: [],
                    description: 'Step 1: Save next (2) before reversing pointer',
                    highlight: 'save'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: null,
                    current: 0,
                    next: 1,
                    reversed: [0],
                    description: 'Step 2: Reverse pointer - 1 now points to null',
                    highlight: 'reverse'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 0,
                    current: 1,
                    next: 2,
                    reversed: [0],
                    description: 'Step 3: Move forward - prev=1, current=2, next=3'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 0,
                    current: 1,
                    next: 2,
                    reversed: [0],
                    description: 'Save next (3) before reversing',
                    highlight: 'save'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 0,
                    current: 1,
                    next: 2,
                    reversed: [0, 1],
                    description: 'Reverse pointer - 2 now points to 1',
                    highlight: 'reverse'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 1,
                    current: 2,
                    next: 3,
                    reversed: [0, 1],
                    description: 'Move forward - prev=2, current=3, next=4'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 1,
                    current: 2,
                    next: 3,
                    reversed: [0, 1],
                    description: 'Save next (4) before reversing',
                    highlight: 'save'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 1,
                    current: 2,
                    next: 3,
                    reversed: [0, 1, 2],
                    description: 'Reverse pointer - 3 now points to 2',
                    highlight: 'reverse'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 2,
                    current: 3,
                    next: null,
                    reversed: [0, 1, 2],
                    description: 'Move forward - prev=3, current=4, next=null'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 2,
                    current: 3,
                    next: null,
                    reversed: [0, 1, 2],
                    description: 'Save next (null) - last iteration!',
                    highlight: 'save'
                },
                {
                    list: [1, 2, 3, 4],
                    prev: 2,
                    current: 3,
                    next: null,
                    reversed: [0, 1, 2, 3],
                    description: 'Reverse pointer - 4 now points to 3',
                    highlight: 'reverse'
                },
                {
                    list: [4, 3, 2, 1],
                    prev: 3,
                    current: null,
                    next: null,
                    reversed: [0, 1, 2, 3],
                    description: '✅ Done! Update head to prev (4). List is reversed!',
                    highlight: 'complete'
                }
            ];
        }

        renderVisualization() {
            const container = document.getElementById('reversalViz');
            if (!container) return;

            const step = this.steps[this.currentStep];
            if (!step) return;

            container.innerHTML = '';

            // Pointers section
            const pointersDiv = document.createElement('div');
            pointersDiv.className = 'rev-pointers';
            pointersDiv.innerHTML = `
                <div class="rev-pointer ${step.prev === null ? 'rev-pointer-active' : ''}">
                    <div class="rev-pointer-label">prev</div>
                    <div class="rev-pointer-value">${step.prev === null ? 'null' : step.list[step.prev]}</div>
                </div>
                <div class="rev-pointer ${step.current !== null ? 'rev-pointer-active' : ''}">
                    <div class="rev-pointer-label">current</div>
                    <div class="rev-pointer-value">${step.current === null ? 'null' : step.list[step.current]}</div>
                </div>
                <div class="rev-pointer ${step.next !== null && step.highlight === 'save' ? 'rev-pointer-active' : ''}">
                    <div class="rev-pointer-label">next</div>
                    <div class="rev-pointer-value">${step.next === null ? 'null' : step.list[step.next]}</div>
                </div>
            `;
            container.appendChild(pointersDiv);

            // List visualization
            const listDiv = document.createElement('div');
            listDiv.className = 'rev-list';

            // Reversed part
            if (step.reversed.length > 0) {
                const reversedDiv = document.createElement('div');
                reversedDiv.className = 'rev-section';
                reversedDiv.innerHTML = '<div class="rev-section-label">Reversed ✓</div>';

                const reversedNodes = document.createElement('div');
                reversedNodes.className = 'rev-nodes';

                for (let i = step.reversed.length - 1; i >= 0; i--) {
                    const idx = step.reversed[i];
                    const nodeDiv = document.createElement('div');
                    nodeDiv.className = 'rev-node-container';

                    let nodeClass = 'rev-node rev-node-reversed';
                    if (idx === step.prev) nodeClass += ' rev-node-prev';

                    nodeDiv.innerHTML = `
                        <div class="${nodeClass}">
                            <div class="rev-node-data">${step.list[idx]}</div>
                            <div class="rev-node-arrow">←</div>
                        </div>
                        ${i > 0 ? '<div class="rev-connector">←</div>' : ''}
                    `;
                    reversedNodes.appendChild(nodeDiv);
                }

                reversedDiv.appendChild(reversedNodes);
                listDiv.appendChild(reversedDiv);
            }

            // Current node
            if (step.current !== null) {
                const currentDiv = document.createElement('div');
                currentDiv.className = 'rev-section';
                currentDiv.innerHTML = '<div class="rev-section-label">Processing...</div>';

                const currentNode = document.createElement('div');
                currentNode.className = 'rev-nodes';
                currentNode.innerHTML = `
                    <div class="rev-node-container">
                        <div class="rev-node rev-node-current">
                            <div class="rev-node-data">${step.list[step.current]}</div>
                            <div class="rev-node-arrow">${step.highlight === 'reverse' ? '←' : '→'}</div>
                        </div>
                    </div>
                `;
                currentDiv.appendChild(currentNode);
                listDiv.appendChild(currentDiv);
            }

            // Remaining nodes
            const remaining = [];
            for (let i = 0; i < step.list.length; i++) {
                if (!step.reversed.includes(i) && i !== step.current) {
                    remaining.push(i);
                }
            }

            if (remaining.length > 0) {
                const remainingDiv = document.createElement('div');
                remainingDiv.className = 'rev-section';
                remainingDiv.innerHTML = '<div class="rev-section-label">Not Yet Reversed</div>';

                const remainingNodes = document.createElement('div');
                remainingNodes.className = 'rev-nodes';

                remaining.forEach((idx, i) => {
                    const nodeDiv = document.createElement('div');
                    nodeDiv.className = 'rev-node-container';

                    let nodeClass = 'rev-node';
                    if (idx === step.next) nodeClass += ' rev-node-next';

                    nodeDiv.innerHTML = `
                        <div class="${nodeClass}">
                            <div class="rev-node-data">${step.list[idx]}</div>
                            <div class="rev-node-arrow">→</div>
                        </div>
                        ${i < remaining.length - 1 ? '<div class="rev-connector">→</div>' : ''}
                    `;
                    remainingNodes.appendChild(nodeDiv);
                });

                remainingDiv.appendChild(remainingNodes);
                listDiv.appendChild(remainingDiv);
            }

            container.appendChild(listDiv);

            // Update info
            document.getElementById('currentStep').textContent = `${this.currentStep + 1}/${this.steps.length}`;
            document.getElementById('explanation').textContent = step.description;

            const pointerText = `prev=${step.prev === null ? 'null' : step.list[step.prev]}, current=${step.current === null ? 'null' : step.list[step.current]}, next=${step.next === null ? 'null' : step.list[step.next]}`;
            document.getElementById('pointerInfo').textContent = pointerText;
        }

        async start() {
            if (this.isRunning) return;

            this.isRunning = true;
            this.isPaused = false;
            document.getElementById('vizStart').disabled = true;
            document.getElementById('vizPause').disabled = false;

            while (this.isRunning && this.currentStep < this.steps.length) {
                while (this.isPaused) {
                    await this.sleep(100);
                }

                this.renderVisualization();
                await this.sleep(this.speed);
                this.currentStep++;
            }

            if (this.currentStep >= this.steps.length) {
                this.complete();
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
            new ReversalViz('reversalVisualization');
        });
    } else {
        new ReversalViz('reversalVisualization');
    }
})();
