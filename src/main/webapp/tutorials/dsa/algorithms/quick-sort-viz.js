/**
 * Quick Sort Visualization - Partition Animation
 * Shows pivot selection and partition process
 */

(function () {
    'use strict';

    class QuickSortViz {
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

            this.stats = {
                comparisons: 0,
                swaps: 0,
                partitions: 0
            };

            this.init();
        }

        init() {
            this.render();
            this.renderArray();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-stats" id="vizStats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Comparisons</div>
                        <div class="viz-stat-value" id="statComparisons">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Swaps</div>
                        <div class="viz-stat-value" id="statSwaps">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Partitions</div>
                        <div class="viz-stat-value" id="statPartitions">0</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to sort...</div>
                
                <div class="viz-canvas">
                    <div class="viz-array" id="vizArray"></div>
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

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            const highlights = {
                pivot: -1,
                comparing: [],
                swapping: [],
                sorted: []
            };

            if (currentStepData) {
                if (currentStepData.type === 'select-pivot') {
                    highlights.pivot = currentStepData.pivotIndex;
                } else if (currentStepData.type === 'compare') {
                    highlights.pivot = currentStepData.pivotIndex;
                    highlights.comparing = currentStepData.comparing || [];
                } else if (currentStepData.type === 'swap') {
                    highlights.pivot = currentStepData.pivotIndex;
                    highlights.swapping = currentStepData.swapping || [];
                } else if (currentStepData.type === 'place-pivot') {
                    highlights.sorted = [currentStepData.pivotIndex];
                } else if (currentStepData.type === 'complete') {
                    for (let i = 0; i < this.array.length; i++) {
                        highlights.sorted.push(i);
                    }
                }
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                if (highlights.pivot === idx) {
                    box.classList.add('pivot');
                } else if (highlights.comparing.includes(idx)) {
                    box.classList.add('comparing');
                } else if (highlights.swapping.includes(idx)) {
                    box.classList.add('swapping');
                } else if (highlights.sorted.includes(idx)) {
                    box.classList.add('sorted');
                }

                arrayContainer.appendChild(box);
            });
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            const arr = [...this.originalArray];

            this.stats = {
                comparisons: 0,
                swaps: 0,
                partitions: 0
            };

            const recordStep = (type, data) => {
                this.animationSteps.push({
                    type,
                    array: [...arr],
                    ...data,
                    stats: { ...this.stats }
                });
            };

            const quickSort = (low, high) => {
                if (low < high) {
                    const pivotIndex = partition(low, high);
                    quickSort(low, pivotIndex - 1);
                    quickSort(pivotIndex + 1, high);
                }
            };

            const partition = (low, high) => {
                this.stats.partitions++;
                const pivot = arr[high];

                recordStep('select-pivot', {
                    pivotIndex: high,
                    low, high,
                    description: `Select pivot: ${pivot} at index ${high}`
                });

                let i = low - 1;

                for (let j = low; j < high; j++) {
                    this.stats.comparisons++;

                    recordStep('compare', {
                        pivotIndex: high,
                        comparing: [j],
                        low, high,
                        description: `Compare ${arr[j]} with pivot ${pivot}`
                    });

                    if (arr[j] <= pivot) {
                        i++;
                        if (i !== j) {
                            this.stats.swaps++;
                            recordStep('swap', {
                                pivotIndex: high,
                                swapping: [i, j],
                                low, high,
                                description: `Swap ${arr[i]} ↔ ${arr[j]}`
                            });
                            [arr[i], arr[j]] = [arr[j], arr[i]];
                        }
                    }
                }

                // Place pivot in correct position
                this.stats.swaps++;
                [arr[i + 1], arr[high]] = [arr[high], arr[i + 1]];

                recordStep('place-pivot', {
                    pivotIndex: i + 1,
                    low, high,
                    description: `Pivot ${pivot} placed in final position ${i + 1}`
                });

                return i + 1;
            };

            recordStep('start', {
                description: 'Starting Quick Sort - Pick pivot, partition, recurse!'
            });

            quickSort(0, arr.length - 1);

            recordStep('complete', {
                description: 'Sorting complete! All pivots found their homes.'
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

            document.getElementById('statComparisons').textContent = this.stats.comparisons;
            document.getElementById('statSwaps').textContent = this.stats.swaps;
            document.getElementById('statPartitions').textContent = this.stats.partitions;
            document.getElementById('vizOperation').textContent = step.description || '';

            this.renderArray();
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
            this.stats = { comparisons: 0, swaps: 0, partitions: 0 };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderArray();

            document.getElementById('statComparisons').textContent = '0';
            document.getElementById('statSwaps').textContent = '0';
            document.getElementById('statPartitions').textContent = '0';
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
            new QuickSortViz('quickSortVisualization');
        });
    } else {
        new QuickSortViz('quickSortVisualization');
    }
})();
