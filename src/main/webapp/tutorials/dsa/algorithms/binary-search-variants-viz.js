/**
 * Binary Search Variants Visualization
 * Focus on Rotated Sorted Array - most common interview problem
 */

(function () {
    'use strict';

    class BinarySearchVariantsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            // Rotated sorted array example
            this.array = [4, 5, 6, 7, 0, 1, 2];
            this.target = 0;
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 1500;

            this.stats = {
                comparisons: 0
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
                        <div class="viz-stat-label">Target</div>
                        <div class="viz-stat-value" id="statTarget">${this.target}</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Comparisons</div>
                        <div class="viz-stat-value" id="statComparisons">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Array Type</div>
                        <div class="viz-stat-value">Rotated</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(log n)</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Rotated sorted array - one half is always sorted!</div>
                
                <div class="viz-array-section">
                    <h4>Rotated Sorted Array: [4,5,6,7,0,1,2]</h4>
                    <div class="viz-canvas">
                        <div class="viz-array" id="vizArray"></div>
                    </div>
                </div>
                
                <div class="viz-pointers-info" id="vizPointersInfo">
                    <div class="viz-pointer-label">
                        <span style="color: #4cc9f0;">●</span> Left pointer
                    </div>
                    <div class="viz-pointer-label">
                        <span style="color: #f72585;">●</span> Right pointer
                    </div>
                    <div class="viz-pointer-label">
                        <span style="color: #fbbf24;">●</span> Mid pointer
                    </div>
                    <div class="viz-pointer-label">
                        <span style="color: #7209b7;">●</span> Sorted half
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
                    <div class="viz-slider-group">
                        <div class="viz-slider-label">
                            <span>Speed</span>
                            <span id="vizSpeedValue">1500ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="vizSpeed" min="800" max="2500" value="1500" step="200">
                    </div>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.getElementById('vizStart').addEventListener('click', () => this.start());
            document.getElementById('vizPause').addEventListener('click', () => this.pause());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('vizSpeed').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('vizSpeedValue').textContent = `${this.speed}ms`;
            });
        }

        renderVisualization() {
            this.renderArray();
        }

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            let left = -1, right = -1, mid = -1;
            let found = false;
            let sortedHalf = null;

            if (currentStepData) {
                left = currentStepData.left;
                right = currentStepData.right;
                mid = currentStepData.mid;
                found = currentStepData.found;
                sortedHalf = currentStepData.sortedHalf;
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                if (found && idx === mid) {
                    box.classList.add('sorted'); // Found!
                } else if (idx === mid) {
                    box.classList.add('comparing'); // Current mid
                } else if (sortedHalf === 'left' && idx >= left && idx < mid) {
                    box.classList.add('pivot'); // Sorted left half
                } else if (sortedHalf === 'right' && idx > mid && idx <= right) {
                    box.classList.add('pivot'); // Sorted right half
                } else if (idx >= left && idx <= right && left !== -1) {
                    box.classList.add('active'); // In search range
                } else if (left !== -1) {
                    box.classList.add('eliminated'); // Outside range
                }

                // Add pointer labels
                const labels = [];
                if (idx === left) labels.push('L');
                if (idx === right) labels.push('R');
                if (idx === mid) labels.push('M');

                if (labels.length > 0) {
                    const labelDiv = document.createElement('div');
                    labelDiv.className = 'viz-box-label';
                    labelDiv.textContent = labels.join(',');
                    box.appendChild(labelDiv);
                }

                arrayContainer.appendChild(box);
            });
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            let left = 0;
            let right = this.array.length - 1;

            this.stats = { comparisons: 0 };

            const recordStep = (type, data) => {
                this.animationSteps.push({
                    type,
                    left,
                    right,
                    ...data,
                    stats: { ...this.stats }
                });
            };

            recordStep('start', {
                mid: -1,
                found: false,
                sortedHalf: null,
                description: `Searching for ${this.target} in rotated sorted array...`
            });

            let found = false;

            while (left <= right && !found) {
                const mid = Math.floor((left + right) / 2);
                this.stats.comparisons++;

                // Check if found
                if (this.array[mid] === this.target) {
                    recordStep('found', {
                        mid,
                        found: true,
                        sortedHalf: null,
                        description: `✓ FOUND! ${this.target} at index ${mid}`
                    });
                    found = true;
                    break;
                }

                // Determine which half is sorted
                let sortedHalf = null;
                if (this.array[left] <= this.array[mid]) {
                    sortedHalf = 'left';
                    recordStep('check-sorted', {
                        mid,
                        found: false,
                        sortedHalf,
                        description: `Left half [${left}:${mid}] is sorted (${this.array[left]} ≤ ${this.array[mid]})`
                    });

                    // Check if target is in sorted left half
                    if (this.array[left] <= this.target && this.target < this.array[mid]) {
                        recordStep('go-left', {
                            mid,
                            found: false,
                            sortedHalf,
                            description: `Target ${this.target} is in sorted left half, search left`
                        });
                        right = mid - 1;
                    } else {
                        recordStep('go-right', {
                            mid,
                            found: false,
                            sortedHalf,
                            description: `Target ${this.target} not in sorted left, search right`
                        });
                        left = mid + 1;
                    }
                } else {
                    sortedHalf = 'right';
                    recordStep('check-sorted', {
                        mid,
                        found: false,
                        sortedHalf,
                        description: `Right half [${mid}:${right}] is sorted (${this.array[mid]} < ${this.array[right]})`
                    });

                    // Check if target is in sorted right half
                    if (this.array[mid] < this.target && this.target <= this.array[right]) {
                        recordStep('go-right', {
                            mid,
                            found: false,
                            sortedHalf,
                            description: `Target ${this.target} is in sorted right half, search right`
                        });
                        left = mid + 1;
                    } else {
                        recordStep('go-left', {
                            mid,
                            found: false,
                            sortedHalf,
                            description: `Target ${this.target} not in sorted right, search left`
                        });
                        right = mid - 1;
                    }
                }
            }

            if (!found) {
                recordStep('not-found', {
                    mid: -1,
                    found: false,
                    sortedHalf: null,
                    description: `✗ NOT FOUND`
                });
            }

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
            this.stats = { ...step.stats };

            document.getElementById('statComparisons').textContent = this.stats.comparisons;
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
            this.stats = { comparisons: 0 };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderVisualization();

            document.getElementById('statComparisons').textContent = '0';
            document.getElementById('vizOperation').textContent = 'Rotated sorted array - one half is always sorted!';
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
            new BinarySearchVariantsViz('binarySearchVariantsVisualization');
        });
    } else {
        new BinarySearchVariantsViz('binarySearchVariantsVisualization');
    }
})();
