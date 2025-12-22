/**
 * Advanced Linked List Problems Visualization
 * Shows merge, reorder, partition, and rotate operations
 */

(function () {
    'use strict';

    class AdvancedLinkedListViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.list1 = [1, 3, 5];
            this.list2 = [2, 4, 6];
            this.isRunning = false;
            this.speed = 1500;
            this.currentProblem = 'merge';

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Advanced Linked List Problems</h3>
                    <p class="viz-subtitle">Combining all techniques</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Current Problem</div>
                        <div class="viz-stat-value" id="problemName">Merge</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Technique</div>
                        <div class="viz-stat-value" id="techniqueInfo">Two Pointers</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(n), O(1) space</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose a problem to see advanced techniques in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="adv-ll-viz" id="advLLViz"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Choose Problem:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" data-problem="merge">
                            <span class="viz-op-icon">🔗</span>
                            <span class="viz-op-label">Merge Sorted</span>
                            <span class="viz-op-complexity">Two Pointers</span>
                        </button>
                        <button class="viz-op-btn" data-problem="reorder">
                            <span class="viz-op-icon">🔀</span>
                            <span class="viz-op-label">Reorder List</span>
                            <span class="viz-op-complexity">Find Mid + Reverse</span>
                        </button>
                        <button class="viz-op-btn" data-problem="partition">
                            <span class="viz-op-icon">📊</span>
                            <span class="viz-op-label">Partition</span>
                            <span class="viz-op-complexity">Dummy Nodes</span>
                        </button>
                        <button class="viz-op-btn" data-problem="rotate">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Rotate Right</span>
                            <span class="viz-op-complexity">Find New Head</span>
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
            document.querySelectorAll('[data-problem]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    this.currentProblem = e.currentTarget.dataset.problem;
                    this.reset();

                    document.querySelectorAll('[data-problem]').forEach(b =>
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

            // Select merge by default
            document.querySelector('[data-problem="merge"]').classList.add('viz-op-btn-selected');
        }

        renderVisualization() {
            const container = document.getElementById('advLLViz');
            if (!container) return;

            container.innerHTML = '';

            if (this.currentProblem === 'merge') {
                this.renderMergeViz(container);
            } else if (this.currentProblem === 'reorder') {
                this.renderReorderViz(container);
            } else if (this.currentProblem === 'partition') {
                this.renderPartitionViz(container);
            } else if (this.currentProblem === 'rotate') {
                this.renderRotateViz(container);
            }
        }

        renderMergeViz(container) {
            const div = document.createElement('div');
            div.className = 'adv-problem-viz';
            div.innerHTML = `
                <div class="adv-list-row">
                    <div class="adv-list-label">List 1:</div>
                    <div class="adv-list" id="list1">
                        ${this.list1.map((v, i) => `
                            <div class="adv-node" data-list="1" data-idx="${i}">
                                <div class="adv-node-value">${v}</div>
                            </div>
                            ${i < this.list1.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                        `).join('')}
                    </div>
                </div>
                <div class="adv-list-row">
                    <div class="adv-list-label">List 2:</div>
                    <div class="adv-list" id="list2">
                        ${this.list2.map((v, i) => `
                            <div class="adv-node" data-list="2" data-idx="${i}">
                                <div class="adv-node-value">${v}</div>
                            </div>
                            ${i < this.list2.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                        `).join('')}
                    </div>
                </div>
                <div class="adv-list-row">
                    <div class="adv-list-label">Merged:</div>
                    <div class="adv-list" id="merged"></div>
                </div>
            `;
            container.appendChild(div);
        }

        renderReorderViz(container) {
            const list = [1, 2, 3, 4, 5];
            const div = document.createElement('div');
            div.className = 'adv-problem-viz';
            div.innerHTML = `
                <div class="adv-list-row">
                    <div class="adv-list-label">Original:</div>
                    <div class="adv-list" id="original">
                        ${list.map((v, i) => `
                            <div class="adv-node" data-idx="${i}">
                                <div class="adv-node-value">${v}</div>
                            </div>
                            ${i < list.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                        `).join('')}
                    </div>
                </div>
                <div class="adv-list-row">
                    <div class="adv-list-label">Reordered:</div>
                    <div class="adv-list" id="reordered"></div>
                </div>
            `;
            container.appendChild(div);
        }

        renderPartitionViz(container) {
            const list = [3, 5, 8, 5, 10, 2, 1];
            const div = document.createElement('div');
            div.className = 'adv-problem-viz';
            div.innerHTML = `
                <div class="adv-list-row">
                    <div class="adv-list-label">Original:</div>
                    <div class="adv-list" id="original">
                        ${list.map((v, i) => `
                            <div class="adv-node" data-idx="${i}" data-val="${v}">
                                <div class="adv-node-value">${v}</div>
                            </div>
                            ${i < list.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                        `).join('')}
                    </div>
                </div>
                <div class="adv-partition-label">Partition around 5</div>
                <div class="adv-list-row">
                    <div class="adv-list-label">Result:</div>
                    <div class="adv-list" id="partitioned"></div>
                </div>
            `;
            container.appendChild(div);
        }

        renderRotateViz(container) {
            const list = [1, 2, 3, 4, 5];
            const div = document.createElement('div');
            div.className = 'adv-problem-viz';
            div.innerHTML = `
                <div class="adv-list-row">
                    <div class="adv-list-label">Original:</div>
                    <div class="adv-list" id="original">
                        ${list.map((v, i) => `
                            <div class="adv-node" data-idx="${i}">
                                <div class="adv-node-value">${v}</div>
                            </div>
                            ${i < list.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                        `).join('')}
                    </div>
                </div>
                <div class="adv-partition-label">Rotate right by 2</div>
                <div class="adv-list-row">
                    <div class="adv-list-label">Rotated:</div>
                    <div class="adv-list" id="rotated"></div>
                </div>
            `;
            container.appendChild(div);
        }

        async start() {
            if (this.isRunning) return;

            this.isRunning = true;
            document.getElementById('vizStart').disabled = true;

            if (this.currentProblem === 'merge') {
                await this.runMerge();
            } else if (this.currentProblem === 'reorder') {
                await this.runReorder();
            } else if (this.currentProblem === 'partition') {
                await this.runPartition();
            } else if (this.currentProblem === 'rotate') {
                await this.runRotate();
            }

            document.getElementById('vizStart').disabled = false;
            this.isRunning = false;
        }

        async runMerge() {
            document.getElementById('problemName').textContent = 'Merge';
            document.getElementById('techniqueInfo').textContent = 'Two Pointers';
            document.getElementById('explanation').textContent =
                'Merging two sorted lists using two pointers...';

            const merged = [];
            let i = 0, j = 0;

            while (i < this.list1.length && j < this.list2.length) {
                const node1 = document.querySelector(`[data-list="1"][data-idx="${i}"]`);
                const node2 = document.querySelector(`[data-list="2"][data-idx="${j}"]`);

                if (node1) node1.classList.add('adv-node-compare');
                if (node2) node2.classList.add('adv-node-compare');

                await this.sleep(this.speed);

                if (this.list1[i] <= this.list2[j]) {
                    merged.push(this.list1[i]);
                    if (node1) node1.classList.remove('adv-node-compare');
                    i++;
                } else {
                    merged.push(this.list2[j]);
                    if (node2) node2.classList.remove('adv-node-compare');
                    j++;
                }

                this.updateMerged(merged);
                await this.sleep(this.speed * 0.5);
            }

            while (i < this.list1.length) {
                merged.push(this.list1[i++]);
                this.updateMerged(merged);
                await this.sleep(this.speed * 0.5);
            }

            while (j < this.list2.length) {
                merged.push(this.list2[j++]);
                this.updateMerged(merged);
                await this.sleep(this.speed * 0.5);
            }

            document.getElementById('explanation').textContent =
                '✅ Merged! Used two pointers to compare and merge.';
        }

        updateMerged(merged) {
            const container = document.getElementById('merged');
            if (!container) return;

            container.innerHTML = merged.map((v, i) => `
                <div class="adv-node adv-node-merged">
                    <div class="adv-node-value">${v}</div>
                </div>
                ${i < merged.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
            `).join('');
        }

        async runReorder() {
            document.getElementById('problemName').textContent = 'Reorder';
            document.getElementById('techniqueInfo').textContent = 'Mid + Reverse';
            document.getElementById('explanation').textContent =
                'Reordering: L0→Ln→L1→Ln-1→L2...';

            await this.sleep(this.speed);

            const reordered = [1, 5, 2, 4, 3];
            const container = document.getElementById('reordered');
            if (container) {
                container.innerHTML = reordered.map((v, i) => `
                    <div class="adv-node adv-node-merged">
                        <div class="adv-node-value">${v}</div>
                    </div>
                    ${i < reordered.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                `).join('');
            }

            document.getElementById('explanation').textContent =
                '✅ Reordered! Found middle, reversed second half, merged alternating.';
        }

        async runPartition() {
            document.getElementById('problemName').textContent = 'Partition';
            document.getElementById('techniqueInfo').textContent = 'Dummy Nodes';
            document.getElementById('explanation').textContent =
                'Partitioning around 5...';

            await this.sleep(this.speed);

            const partitioned = [3, 2, 1, 5, 8, 5, 10];
            const container = document.getElementById('partitioned');
            if (container) {
                container.innerHTML = partitioned.map((v, i) => `
                    <div class="adv-node ${v < 5 ? 'adv-node-less' : 'adv-node-greater'}">
                        <div class="adv-node-value">${v}</div>
                    </div>
                    ${i < partitioned.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                `).join('');
            }

            document.getElementById('explanation').textContent =
                '✅ Partitioned! All < 5 before all ≥ 5.';
        }

        async runRotate() {
            document.getElementById('problemName').textContent = 'Rotate';
            document.getElementById('techniqueInfo').textContent = 'Find New Head';
            document.getElementById('explanation').textContent =
                'Rotating right by 2...';

            await this.sleep(this.speed);

            const rotated = [4, 5, 1, 2, 3];
            const container = document.getElementById('rotated');
            if (container) {
                container.innerHTML = rotated.map((v, i) => `
                    <div class="adv-node adv-node-merged">
                        <div class="adv-node-value">${v}</div>
                    </div>
                    ${i < rotated.length - 1 ? '<div class="adv-arrow">→</div>' : ''}
                `).join('');
            }

            document.getElementById('explanation').textContent =
                '✅ Rotated! Last 2 nodes moved to front.';
        }

        reset() {
            this.isRunning = false;
            document.getElementById('explanation').textContent =
                'Choose a problem to see advanced techniques in action!';
            this.renderVisualization();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new AdvancedLinkedListViz('advancedLinkedListVisualization');
        });
    } else {
        new AdvancedLinkedListViz('advancedLinkedListVisualization');
    }
})();
