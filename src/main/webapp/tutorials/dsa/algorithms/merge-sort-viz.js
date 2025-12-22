/**
 * Merge Sort Visualization - Tree Structure with Depth Animation
 * Adapted from deepseek_html with responsive design for tutorial framework
 */

(function () {
    'use strict';

    class MergeSortViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [38, 27, 43, 3, 9, 82, 10];
            this.originalArray = [...this.array];
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 800;

            // Statistics
            this.stats = {
                comparisons: 0,
                merges: 0,
                operations: 0,
                currentDepth: 0,
                maxDepth: 0
            };

            // Tree nodes
            this.treeNodes = [];
            this.treeConnections = [];

            this.init();
        }

        init() {
            this.render();
            this.generateTreeStructure();
            this.renderArray();
            this.renderTree();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-stats" id="vizStats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Depth</div>
                        <div class="viz-stat-value" id="statDepth">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Comparisons</div>
                        <div class="viz-stat-value" id="statComparisons">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Merges</div>
                        <div class="viz-stat-value" id="statMerges">0</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to sort...</div>
                
                <div class="viz-array-section">
                    <h4>Array View</h4>
                    <div class="viz-canvas">
                        <div class="viz-array" id="vizArray"></div>
                    </div>
                </div>
                
                <div class="viz-tree-section">
                    <h4>Recursive Tree Structure</h4>
                    <div class="viz-tree-container" id="vizTreeContainer">
                        <div class="viz-tree" id="vizTree"></div>
                    </div>
                </div>
                
                <div class="viz-controls">
                    <button class="viz-btn viz-btn-primary" id="vizStart">
                        <span>▶️</span> Start
                    </button>
                    <button class="viz-btn" id="vizPause" disabled>
                        <span>⏸</span> Pause
                    </button>
                    <button class="viz-btn" id="vizReset">
                        <span>🔄</span> Reset
                    </button>
                    <button class="viz-btn" id="vizShuffle">
                        <span>🎲</span> Shuffle
                    </button>
                    <div class="viz-slider-group">
                        <div class="viz-slider-label">
                            <span>Speed</span>
                            <span id="vizSpeedValue">800ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="vizSpeed" min="400" max="1600" value="800" step="100">
                    </div>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.getElementById('vizStart').addEventListener('click', () => this.start());
            document.getElementById('vizPause').addEventListener('click', () => this.pause());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());
            document.getElementById('vizShuffle').addEventListener('click', () => this.shuffle());

            document.getElementById('vizSpeed').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('vizSpeedValue').textContent = `${this.speed}ms`;
            });
        }

        // Tree Node class
        createTreeNode(value, level, x, y, parentId = null, depth = 0) {
            return {
                id: `node-${Math.random().toString(36).substr(2, 9)}`,
                value: value,
                level: level,
                x: x,
                y: y,
                parentId: parentId,
                depth: depth,
                state: 'default', // 'dividing', 'merging', 'sorted'
                subarray: Array.isArray(value) ? value : [value]
            };
        }

        // Generate tree structure
        generateTreeStructure() {
            this.treeNodes = [];
            this.treeConnections = [];

            const treeWidth = 800; // Fixed width for calculations
            const rootNode = this.createTreeNode(
                this.array,
                0,
                treeWidth / 2,
                40,
                null,
                0
            );

            this.treeNodes.push(rootNode);
            this.buildSubtree(rootNode, this.array, 0, 0, treeWidth, 0);
        }

        buildSubtree(parentNode, arr, level, leftBound, rightBound, depth) {
            if (arr.length <= 1) {
                return;
            }

            const mid = Math.floor(arr.length / 2);
            const leftArr = arr.slice(0, mid);
            const rightArr = arr.slice(mid);

            const leftX = (leftBound + (leftBound + rightBound) / 2) / 2;
            const rightX = ((leftBound + rightBound) / 2 + rightBound) / 2;
            const childY = 40 + (level + 1) * 80;

            // Create left child
            const leftNode = this.createTreeNode(
                leftArr,
                level + 1,
                leftX,
                childY,
                parentNode.id,
                depth + 1
            );
            this.treeNodes.push(leftNode);
            this.treeConnections.push({
                from: parentNode.id,
                to: leftNode.id,
                fromX: parentNode.x,
                fromY: parentNode.y,
                toX: leftNode.x,
                toY: leftNode.y
            });

            // Create right child
            const rightNode = this.createTreeNode(
                rightArr,
                level + 1,
                rightX,
                childY,
                parentNode.id,
                depth + 1
            );
            this.treeNodes.push(rightNode);
            this.treeConnections.push({
                from: parentNode.id,
                to: rightNode.id,
                fromX: parentNode.x,
                fromY: parentNode.y,
                toX: rightNode.x,
                toY: rightNode.y
            });

            // Recursively build subtrees
            this.buildSubtree(leftNode, leftArr, level + 1, leftBound, (leftBound + rightBound) / 2, depth + 1);
            this.buildSubtree(rightNode, rightArr, level + 1, (leftBound + rightBound) / 2, rightBound, depth + 1);

            this.stats.maxDepth = Math.max(this.stats.maxDepth, depth + 1);
        }

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            const highlights = {
                dividing: [],
                comparing: [],
                merging: [],
                sorted: []
            };

            // Determine which indices to highlight based on current step
            if (currentStepData) {
                if (currentStepData.type === 'divide' && currentStepData.start !== undefined) {
                    // Highlight the subarray being divided
                    for (let i = currentStepData.start; i <= currentStepData.end; i++) {
                        highlights.dividing.push(i);
                    }
                } else if (currentStepData.type === 'compare' && currentStepData.indices) {
                    // Highlight elements being compared
                    highlights.comparing = currentStepData.indices;
                } else if (currentStepData.type === 'merge-start' && currentStepData.start !== undefined) {
                    // Highlight elements being merged
                    for (let i = currentStepData.start; i <= currentStepData.end; i++) {
                        highlights.merging.push(i);
                    }
                } else if (currentStepData.type === 'merge-complete' && currentStepData.start !== undefined) {
                    // Highlight sorted subarray
                    for (let i = currentStepData.start; i <= currentStepData.end; i++) {
                        highlights.sorted.push(i);
                    }
                } else if (currentStepData.type === 'complete') {
                    // All elements are sorted
                    for (let i = 0; i < this.array.length; i++) {
                        highlights.sorted.push(i);
                    }
                }
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                // Apply color coding
                if (highlights.dividing.includes(idx)) {
                    box.classList.add('dividing');
                } else if (highlights.comparing.includes(idx)) {
                    box.classList.add('comparing');
                } else if (highlights.merging.includes(idx)) {
                    box.classList.add('merging');
                } else if (highlights.sorted.includes(idx)) {
                    box.classList.add('sorted');
                }

                arrayContainer.appendChild(box);
            });
        }

        renderTree() {
            const treeContainer = document.getElementById('vizTree');
            treeContainer.innerHTML = '';

            // Draw connections first
            this.treeConnections.forEach(conn => {
                const line = document.createElement('div');
                line.className = 'viz-tree-line';

                const dx = conn.toX - conn.fromX;
                const dy = conn.toY - conn.fromY;
                const length = Math.sqrt(dx * dx + dy * dy);
                const angle = Math.atan2(dy, dx) * (180 / Math.PI);

                line.style.width = `${length}px`;
                line.style.left = `${conn.fromX}px`;
                line.style.top = `${conn.fromY}px`;
                line.style.transform = `rotate(${angle}deg)`;
                line.style.transformOrigin = '0 0';

                treeContainer.appendChild(line);
            });

            // Draw nodes
            this.treeNodes.forEach(node => {
                const nodeEl = document.createElement('div');
                nodeEl.className = 'viz-tree-node';
                nodeEl.id = node.id;
                nodeEl.textContent = `[${node.subarray.join(',')}]`;
                nodeEl.style.left = `${node.x - 40}px`;
                nodeEl.style.top = `${node.y - 15}px`;

                if (node.state === 'dividing') {
                    nodeEl.classList.add('dividing');
                } else if (node.state === 'merging') {
                    nodeEl.classList.add('merging');
                } else if (node.state === 'sorted') {
                    nodeEl.classList.add('sorted');
                }

                if (node.depth === this.stats.currentDepth) {
                    nodeEl.classList.add('depth-highlight');
                }

                treeContainer.appendChild(nodeEl);
            });
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            const arr = [...this.originalArray];

            this.stats = {
                comparisons: 0,
                merges: 0,
                operations: 0,
                currentDepth: 0,
                maxDepth: 0
            };

            const recordStep = (type, data) => {
                this.animationSteps.push({
                    type,
                    array: [...arr],
                    ...data,
                    stats: { ...this.stats }
                });
            };

            const mergeSort = (start, end, depth) => {
                this.stats.maxDepth = Math.max(this.stats.maxDepth, depth);

                if (start >= end) return;

                const mid = Math.floor((start + end) / 2);
                const subarray = arr.slice(start, end + 1);

                recordStep('divide', {
                    start, mid, end,
                    subarray: subarray,
                    depth: depth,
                    description: `Dividing [${subarray.join(', ')}] at depth ${depth}`
                });

                mergeSort(start, mid, depth + 1);
                mergeSort(mid + 1, end, depth + 1);
                merge(start, mid, end, depth);
            };

            const merge = (start, mid, end, depth) => {
                const left = arr.slice(start, mid + 1);
                const right = arr.slice(mid + 1, end + 1);

                recordStep('merge-start', {
                    start, mid, end,
                    left: [...left],
                    right: [...right],
                    depth: depth,
                    description: `Merging [${left.join(', ')}] and [${right.join(', ')}]`
                });

                let i = 0, j = 0, k = start;

                while (i < left.length && j < right.length) {
                    this.stats.comparisons++;
                    this.stats.operations++;

                    if (left[i] <= right[j]) {
                        arr[k] = left[i];
                        i++;
                    } else {
                        arr[k] = right[j];
                        j++;
                    }
                    k++;
                }

                while (i < left.length) {
                    arr[k] = left[i];
                    i++;
                    k++;
                }

                while (j < right.length) {
                    arr[k] = right[j];
                    j++;
                    k++;
                }

                this.stats.merges++;

                recordStep('merge-complete', {
                    start, end,
                    subarray: arr.slice(start, end + 1),
                    depth: depth,
                    description: `Merged to [${arr.slice(start, end + 1).join(', ')}]`
                });
            };

            recordStep('start', {
                description: 'Starting Merge Sort - Divide and Conquer!'
            });

            mergeSort(0, arr.length - 1, 0);

            recordStep('complete', {
                description: 'Sorting complete!'
            });

            return this.animationSteps;
        }

        async start() {
            if (this.isRunning) return;

            if (this.currentStep === 0) {
                this.generateAnimationSteps();
            }

            this.isRunning = true;
            this.isPaused = false;
            document.getElementById('vizStart').disabled = true;
            document.getElementById('vizPause').disabled = false;
            document.getElementById('vizShuffle').disabled = true;

            while (this.isRunning && this.currentStep < this.animationSteps.length) {
                while (this.isPaused) {
                    await this.sleep(100);
                }

                await this.executeStep(this.animationSteps[this.currentStep]);
                this.currentStep++;
                await this.sleep(this.speed);
            }

            if (this.currentStep >= this.animationSteps.length) {
                this.complete();
            }
        }

        async executeStep(step) {
            this.array = [...step.array];
            this.stats = { ...step.stats };

            // Update stats display
            document.getElementById('statDepth').textContent = step.depth || 0;
            document.getElementById('statComparisons').textContent = this.stats.comparisons;
            document.getElementById('statMerges').textContent = this.stats.merges;

            // Update operation text
            document.getElementById('vizOperation').textContent = step.description || '';

            // Update tree node states
            this.updateTreeStates(step);

            // Render
            this.renderArray();
            this.renderTree();
        }

        updateTreeStates(step) {
            // Reset all states
            this.treeNodes.forEach(node => {
                node.state = 'default';
            });

            // Update based on step type
            if (step.type === 'divide') {
                this.stats.currentDepth = step.depth;
                // Mark nodes at current depth as dividing
                this.treeNodes.forEach(node => {
                    if (node.depth === step.depth) {
                        node.state = 'dividing';
                    }
                });
            } else if (step.type === 'merge-start' || step.type === 'merge-complete') {
                this.stats.currentDepth = step.depth;
                // Mark nodes at current depth as merging
                this.treeNodes.forEach(node => {
                    if (node.depth === step.depth) {
                        node.state = step.type === 'merge-complete' ? 'sorted' : 'merging';
                    }
                });
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
            this.array = [...this.originalArray];
            this.stats = {
                comparisons: 0,
                merges: 0,
                operations: 0,
                currentDepth: 0,
                maxDepth: 0
            };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.generateTreeStructure();
            this.renderArray();
            this.renderTree();

            document.getElementById('statDepth').textContent = '0';
            document.getElementById('statComparisons').textContent = '0';
            document.getElementById('statMerges').textContent = '0';
            document.getElementById('vizOperation').textContent = 'Ready to sort...';
        }

        shuffle() {
            this.array = Array.from({ length: 7 }, () => Math.floor(Math.random() * 99) + 1);
            this.originalArray = [...this.array];
            this.reset();
        }

        complete() {
            this.isRunning = false;
            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new MergeSortViz('mergeSortVisualization');
        });
    } else {
        new MergeSortViz('mergeSortVisualization');
    }
})();
