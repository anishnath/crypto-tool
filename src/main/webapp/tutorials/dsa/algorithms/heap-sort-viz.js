/**
 * Heap Sort Visualization - Tournament Organizer
 * Dual view: Heap tree + Array representation
 */

(function () {
    'use strict';

    class HeapSortViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [12, 11, 13, 5, 6, 7];
            this.originalArray = [...this.array];
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 1000;

            this.stats = {
                comparisons: 0,
                swaps: 0,
                heapSize: this.array.length
            };

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-stats" id="vizStats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Heap Size</div>
                        <div class="viz-stat-value" id="statHeapSize">${this.array.length}</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Comparisons</div>
                        <div class="viz-stat-value" id="statComparisons">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Swaps</div>
                        <div class="viz-stat-value" id="statSwaps">0</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to sort...</div>
                
                <div class="viz-heap-section">
                    <h4>Heap Tree View</h4>
                    <div class="viz-heap-tree" id="vizHeapTree"></div>
                </div>
                
                <div class="viz-array-section">
                    <h4>Array Representation</h4>
                    <div class="viz-canvas">
                        <div class="viz-array" id="vizArray"></div>
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
                            <span id="vizSpeedValue">1000ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="vizSpeed" min="500" max="2000" value="1000" step="100">
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

        renderVisualization() {
            this.renderArray();
            this.renderHeapTree();
        }

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            const highlights = {
                current: -1,
                comparing: [],
                swapping: [],
                sorted: []
            };

            if (currentStepData) {
                if (currentStepData.type === 'heapify') {
                    highlights.current = currentStepData.index;
                    if (currentStepData.comparing) {
                        highlights.comparing = currentStepData.comparing;
                    }
                } else if (currentStepData.type === 'swap') {
                    highlights.swapping = currentStepData.indices;
                } else if (currentStepData.type === 'extract') {
                    highlights.sorted = currentStepData.sorted || [];
                }
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                // Add index label
                const indexLabel = document.createElement('div');
                indexLabel.className = 'viz-box-index';
                indexLabel.textContent = idx;
                box.appendChild(indexLabel);

                if (idx >= this.stats.heapSize) {
                    box.classList.add('sorted');
                } else if (highlights.current === idx) {
                    box.classList.add('current');
                } else if (highlights.comparing.includes(idx)) {
                    box.classList.add('comparing');
                } else if (highlights.swapping.includes(idx)) {
                    box.classList.add('swapping');
                }

                arrayContainer.appendChild(box);
            });
        }

        renderHeapTree() {
            const treeContainer = document.getElementById('vizHeapTree');
            treeContainer.innerHTML = '';

            const heapSize = this.stats.heapSize;
            if (heapSize === 0) return;

            const currentStepData = this.animationSteps[this.currentStep];
            const highlights = {
                current: -1,
                comparing: [],
                swapping: []
            };

            if (currentStepData) {
                if (currentStepData.type === 'heapify') {
                    highlights.current = currentStepData.index;
                    if (currentStepData.comparing) {
                        highlights.comparing = currentStepData.comparing;
                    }
                } else if (currentStepData.type === 'swap') {
                    highlights.swapping = currentStepData.indices;
                }
            }

            // Calculate tree dimensions
            const levels = Math.floor(Math.log2(heapSize)) + 1;
            const treeWidth = 600;
            const levelHeight = 80;

            // Create SVG
            const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            svg.setAttribute('width', treeWidth);
            svg.setAttribute('height', levels * levelHeight + 40);
            svg.style.display = 'block';
            svg.style.margin = '0 auto';

            // Draw connections first
            for (let i = 0; i < heapSize; i++) {
                const left = 2 * i + 1;
                const right = 2 * i + 2;

                const level = Math.floor(Math.log2(i + 1));
                const posInLevel = i - (Math.pow(2, level) - 1);
                const nodesInLevel = Math.pow(2, level);
                const x = (treeWidth / (nodesInLevel + 1)) * (posInLevel + 1);
                const y = level * levelHeight + 40;

                // Draw line to left child
                if (left < heapSize) {
                    const childLevel = Math.floor(Math.log2(left + 1));
                    const childPosInLevel = left - (Math.pow(2, childLevel) - 1);
                    const childNodesInLevel = Math.pow(2, childLevel);
                    const childX = (treeWidth / (childNodesInLevel + 1)) * (childPosInLevel + 1);
                    const childY = childLevel * levelHeight + 40;

                    const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                    line.setAttribute('x1', x);
                    line.setAttribute('y1', y);
                    line.setAttribute('x2', childX);
                    line.setAttribute('y2', childY);
                    line.setAttribute('stroke', '#4cc9f0');
                    line.setAttribute('stroke-width', '2');
                    svg.appendChild(line);
                }

                // Draw line to right child
                if (right < heapSize) {
                    const childLevel = Math.floor(Math.log2(right + 1));
                    const childPosInLevel = right - (Math.pow(2, childLevel) - 1);
                    const childNodesInLevel = Math.pow(2, childLevel);
                    const childX = (treeWidth / (childNodesInLevel + 1)) * (childPosInLevel + 1);
                    const childY = childLevel * levelHeight + 40;

                    const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                    line.setAttribute('x1', x);
                    line.setAttribute('y1', y);
                    line.setAttribute('x2', childX);
                    line.setAttribute('y2', childY);
                    line.setAttribute('stroke', '#4cc9f0');
                    line.setAttribute('stroke-width', '2');
                    svg.appendChild(line);
                }
            }

            treeContainer.appendChild(svg);

            // Draw nodes
            for (let i = 0; i < heapSize; i++) {
                const level = Math.floor(Math.log2(i + 1));
                const posInLevel = i - (Math.pow(2, level) - 1);
                const nodesInLevel = Math.pow(2, level);
                const x = (treeWidth / (nodesInLevel + 1)) * (posInLevel + 1);
                const y = level * levelHeight + 40;

                const node = document.createElement('div');
                node.className = 'viz-heap-node';
                node.textContent = this.array[i];
                node.style.left = `${x - 20}px`;
                node.style.top = `${y - 20}px`;

                if (highlights.current === i) {
                    node.classList.add('current');
                } else if (highlights.comparing.includes(i)) {
                    node.classList.add('comparing');
                } else if (highlights.swapping.includes(i)) {
                    node.classList.add('swapping');
                }

                treeContainer.appendChild(node);
            }
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            const arr = [...this.originalArray];
            const n = arr.length;

            this.stats = {
                comparisons: 0,
                swaps: 0,
                heapSize: n
            };

            const recordStep = (type, data) => {
                this.animationSteps.push({
                    type,
                    array: [...arr],
                    ...data,
                    stats: { ...this.stats }
                });
            };

            const heapify = (n, i) => {
                let largest = i;
                const left = 2 * i + 1;
                const right = 2 * i + 2;

                recordStep('heapify', {
                    index: i,
                    description: `Heapifying node ${arr[i]} at index ${i}`
                });

                const comparing = [];
                if (left < n) comparing.push(left);
                if (right < n) comparing.push(right);

                if (comparing.length > 0) {
                    this.stats.comparisons++;
                    recordStep('heapify', {
                        index: i,
                        comparing: comparing,
                        description: `Comparing ${arr[i]} with children`
                    });
                }

                if (left < n && arr[left] > arr[largest]) {
                    largest = left;
                }

                if (right < n && arr[right] > arr[largest]) {
                    largest = right;
                }

                if (largest !== i) {
                    this.stats.swaps++;
                    recordStep('swap', {
                        indices: [i, largest],
                        description: `Swap ${arr[i]} ↔ ${arr[largest]}`
                    });

                    [arr[i], arr[largest]] = [arr[largest], arr[i]];
                    heapify(n, largest);
                }
            };

            recordStep('start', {
                description: 'Starting Heap Sort - Build max heap, then extract!'
            });

            // Build max heap
            recordStep('phase', {
                description: 'PHASE 1: Building Max Heap'
            });

            for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
                heapify(n, i);
            }

            recordStep('phase', {
                description: 'Max heap built! Root is maximum element.'
            });

            // Extract elements
            recordStep('phase', {
                description: 'PHASE 2: Extracting Max and Sorting'
            });

            for (let i = n - 1; i > 0; i--) {
                this.stats.swaps++;
                recordStep('swap', {
                    indices: [0, i],
                    description: `Extract max ${arr[0]}, place at index ${i}`
                });

                [arr[0], arr[i]] = [arr[i], arr[0]];
                this.stats.heapSize = i;

                recordStep('extract', {
                    sorted: Array.from({ length: n - i }, (_, idx) => i + idx),
                    description: `Heapify remaining elements (heap size: ${i})`
                });

                heapify(i, 0);
            }

            this.stats.heapSize = 0;
            recordStep('complete', {
                sorted: Array.from({ length: n }, (_, i) => i),
                description: 'Heap Sort complete! Array is sorted.'
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

            document.getElementById('statHeapSize').textContent = this.stats.heapSize;
            document.getElementById('statComparisons').textContent = this.stats.comparisons;
            document.getElementById('statSwaps').textContent = this.stats.swaps;
            document.getElementById('vizOperation').textContent = step.description || '';

            this.renderVisualization();
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
            this.stats = { comparisons: 0, swaps: 0, heapSize: this.array.length };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderVisualization();

            document.getElementById('statHeapSize').textContent = this.array.length;
            document.getElementById('statComparisons').textContent = '0';
            document.getElementById('statSwaps').textContent = '0';
            document.getElementById('vizOperation').textContent = 'Ready to sort...';
        }

        shuffle() {
            this.array = Array.from({ length: 6 }, () => Math.floor(Math.random() * 20) + 1);
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
            new HeapSortViz('heapSortVisualization');
        });
    } else {
        new HeapSortViz('heapSortVisualization');
    }
})();
