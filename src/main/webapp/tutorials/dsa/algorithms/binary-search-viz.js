/**
 * Binary Search Visualization - The Dictionary Lookup
 * Shows left, right, mid pointers and range shrinking
 */

(function () {
    'use strict';

    class BinarySearchViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25];
            this.target = 13;
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 1500;

            this.stats = {
                comparisons: 0,
                rangeSize: 0
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
                        <div class="viz-stat-label">Range Size</div>
                        <div class="viz-stat-value" id="statRange">${this.array.length}</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(log n)</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to search...</div>
                
                <div class="viz-array-section">
                    <h4>Sorted Array</h4>
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
                    <button class="viz-btn" id="vizNewTarget">
                        <span>🎯</span> New Target
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
            document.getElementById('vizNewTarget').addEventListener('click', () => this.newTarget());

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

            if (currentStepData) {
                left = currentStepData.left;
                right = currentStepData.right;
                mid = currentStepData.mid;
                found = currentStepData.found;
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                // Highlight based on position
                if (found && idx === mid) {
                    box.classList.add('sorted'); // Found!
                } else if (idx === mid) {
                    box.classList.add('comparing'); // Current mid
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

            this.stats = {
                comparisons: 0,
                rangeSize: this.array.length
            };

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
                description: `Searching for ${this.target} in sorted array...`
            });

            let found = false;

            while (left <= right && !found) {
                const mid = Math.floor((left + right) / 2);
                this.stats.comparisons++;
                this.stats.rangeSize = right - left + 1;

                recordStep('compare', {
                    mid,
                    found: false,
                    description: `Compare: arr[${mid}] = ${this.array[mid]} with target ${this.target}`
                });

                if (this.array[mid] === this.target) {
                    recordStep('found', {
                        mid,
                        found: true,
                        description: `✓ FOUND! ${this.target} at index ${mid}`
                    });
                    found = true;
                } else if (this.array[mid] < this.target) {
                    recordStep('go-right', {
                        mid,
                        found: false,
                        description: `${this.array[mid]} < ${this.target}, search RIGHT half`
                    });
                    left = mid + 1;
                } else {
                    recordStep('go-left', {
                        mid,
                        found: false,
                        description: `${this.array[mid]} > ${this.target}, search LEFT half`
                    });
                    right = mid - 1;
                }
            }

            if (!found) {
                recordStep('not-found', {
                    mid: -1,
                    found: false,
                    description: `✗ NOT FOUND - ${this.target} is not in the array`
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
            document.getElementById('vizNewTarget').disabled = true;

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
            document.getElementById('statRange').textContent = this.stats.rangeSize;
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
            this.stats = { comparisons: 0, rangeSize: this.array.length };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizNewTarget').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderVisualization();

            document.getElementById('statComparisons').textContent = '0';
            document.getElementById('statRange').textContent = this.array.length;
            document.getElementById('vizOperation').textContent = 'Ready to search...';
        }

        newTarget() {
            // Pick a random target (might or might not be in array)
            const inArray = Math.random() > 0.3; // 70% chance in array
            if (inArray) {
                this.target = this.array[Math.floor(Math.random() * this.array.length)];
            } else {
                // Pick a number not in array
                const gaps = [];
                for (let i = 0; i < this.array.length - 1; i++) {
                    if (this.array[i + 1] - this.array[i] > 1) {
                        gaps.push(this.array[i] + 1);
                    }
                }
                this.target = gaps.length > 0 ? gaps[Math.floor(Math.random() * gaps.length)] : 0;
            }

            document.getElementById('statTarget').textContent = this.target;
            this.reset();
        }

        complete() {
            this.isRunning = false;
            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizNewTarget').disabled = false;
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new BinarySearchViz('binarySearchVisualization');
        });
    } else {
        new BinarySearchViz('binarySearchVisualization');
    }
})();
