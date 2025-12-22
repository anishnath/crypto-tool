/**
 * Linear Search Visualization - The Detective's Method
 * Shows sequential checking of each element
 */

(function () {
    'use strict';

    class LinearSearchViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [5, 2, 8, 1, 9, 3, 7, 4, 6];
            this.target = 3;
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 1000;

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
                        <div class="viz-stat-label">Array Size</div>
                        <div class="viz-stat-value">${this.array.length}</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(n)</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to search...</div>
                
                <div class="viz-array-section">
                    <h4>Array (Unsorted - Linear Search works!)</h4>
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
                    <button class="viz-btn" id="vizNewTarget">
                        <span>🎯</span> New Target
                    </button>
                    <div class="viz-slider-group">
                        <div class="viz-slider-label">
                            <span>Speed</span>
                            <span id="vizSpeedValue">1000ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="vizSpeed" min="500" max="2000" value="1000" step="200">
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
            let currentIndex = -1;
            let found = false;
            let checked = [];

            if (currentStepData) {
                currentIndex = currentStepData.index;
                found = currentStepData.found;
                checked = currentStepData.checked || [];
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                if (found && idx === currentIndex) {
                    box.classList.add('sorted'); // Found!
                } else if (idx === currentIndex) {
                    box.classList.add('comparing'); // Currently checking
                } else if (checked.includes(idx)) {
                    box.classList.add('eliminated'); // Already checked, not found
                }

                arrayContainer.appendChild(box);
            });
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            this.stats = { comparisons: 0 };

            const recordStep = (type, data) => {
                this.animationSteps.push({
                    type,
                    ...data,
                    stats: { ...this.stats }
                });
            };

            recordStep('start', {
                index: -1,
                found: false,
                checked: [],
                description: `Searching for ${this.target}... checking each element sequentially`
            });

            let found = false;
            const checked = [];

            for (let i = 0; i < this.array.length; i++) {
                this.stats.comparisons++;

                recordStep('compare', {
                    index: i,
                    found: false,
                    checked: [...checked],
                    description: `Step ${i + 1}: Checking arr[${i}] = ${this.array[i]} vs ${this.target}`
                });

                if (this.array[i] === this.target) {
                    recordStep('found', {
                        index: i,
                        found: true,
                        checked: [...checked],
                        description: `✓ FOUND! ${this.target} at index ${i} after ${this.stats.comparisons} comparison(s)`
                    });
                    found = true;
                    break;
                } else {
                    checked.push(i);
                    recordStep('not-match', {
                        index: i,
                        found: false,
                        checked: [...checked],
                        description: `${this.array[i]} ≠ ${this.target}, continue to next element...`
                    });
                }
            }

            if (!found) {
                recordStep('not-found', {
                    index: -1,
                    found: false,
                    checked: [...checked],
                    description: `✗ NOT FOUND - Checked all ${this.array.length} elements`
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
            document.getElementById('vizNewTarget').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderVisualization();

            document.getElementById('statComparisons').textContent = '0';
            document.getElementById('vizOperation').textContent = 'Ready to search...';
        }

        newTarget() {
            // Pick a random target (might or might not be in array)
            const inArray = Math.random() > 0.3; // 70% chance in array
            if (inArray) {
                this.target = this.array[Math.floor(Math.random() * this.array.length)];
            } else {
                // Pick a number not in array (0 or 10+)
                this.target = Math.random() > 0.5 ? 0 : 10 + Math.floor(Math.random() * 5);
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
            new LinearSearchViz('linearSearchVisualization');
        });
    } else {
        new LinearSearchViz('linearSearchVisualization');
    }
})();
