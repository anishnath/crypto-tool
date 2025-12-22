/**
 * Radix Sort Visualization - The Card Sorter
 * Shows digit-by-digit sorting with multiple passes
 */

(function () {
    'use strict';

    class RadixSortViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [170, 45, 75, 90, 802, 24, 2, 66];
            this.originalArray = [...this.array];
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 1200;

            this.stats = {
                passes: 0,
                currentPass: 0,
                totalPasses: 0
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
                        <div class="viz-stat-label">Current Pass</div>
                        <div class="viz-stat-value" id="statCurrentPass">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Total Passes</div>
                        <div class="viz-stat-value" id="statTotalPasses">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(d×n)</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to sort...</div>
                
                <div class="viz-array-section">
                    <h4 id="vizPassTitle">Original Array</h4>
                    <div class="viz-canvas">
                        <div class="viz-array" id="vizArray"></div>
                    </div>
                    <div class="viz-digit-display" id="vizDigitDisplay"></div>
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
                            <span id="vizSpeedValue">1200ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="vizSpeed" min="600" max="2400" value="1200" step="200">
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
            this.renderDigits();
        }

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            let highlightIndices = [];

            if (currentStepData && currentStepData.type === 'sorting') {
                // Highlight all during sorting
                highlightIndices = Array.from({ length: this.array.length }, (_, i) => i);
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                if (highlightIndices.includes(idx)) {
                    box.classList.add('current');
                }

                if (currentStepData && currentStepData.type === 'complete') {
                    box.classList.add('sorted');
                }

                arrayContainer.appendChild(box);
            });
        }

        renderDigits() {
            const digitDisplay = document.getElementById('vizDigitDisplay');
            const currentStepData = this.animationSteps[this.currentStep];

            if (!currentStepData || !currentStepData.exp) {
                digitDisplay.innerHTML = '';
                return;
            }

            const exp = currentStepData.exp;
            const digitName = this.getDigitName(exp);

            digitDisplay.innerHTML = `
                <div class="viz-digit-info">
                    <strong>Extracting ${digitName} digit:</strong>
                </div>
            `;

            const digitsContainer = document.createElement('div');
            digitsContainer.className = 'viz-digits-row';

            this.array.forEach(num => {
                const digit = Math.floor(num / exp) % 10;
                const digitBox = document.createElement('div');
                digitBox.className = 'viz-digit-box';
                digitBox.innerHTML = `
                    <div class="viz-digit-number">${num}</div>
                    <div class="viz-digit-arrow">↓</div>
                    <div class="viz-digit-value">${digit}</div>
                `;
                digitsContainer.appendChild(digitBox);
            });

            digitDisplay.appendChild(digitsContainer);
        }

        getDigitName(exp) {
            if (exp === 1) return 'ones';
            if (exp === 10) return 'tens';
            if (exp === 100) return 'hundreds';
            if (exp === 1000) return 'thousands';
            return `10^${Math.log10(exp)}`;
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            const arr = [...this.originalArray];

            const maxNum = Math.max(...arr);
            const numDigits = maxNum.toString().length;

            this.stats = {
                passes: 0,
                currentPass: 0,
                totalPasses: numDigits
            };

            const recordStep = (type, data) => {
                this.animationSteps.push({
                    type,
                    array: [...arr],
                    ...data,
                    stats: { ...this.stats }
                });
            };

            recordStep('start', {
                description: `Starting Radix Sort - ${numDigits} passes needed`
            });

            let exp = 1;
            for (let pass = 0; pass < numDigits; pass++) {
                this.stats.currentPass = pass + 1;
                this.stats.passes++;

                const digitName = this.getDigitName(exp);

                recordStep('pass-start', {
                    exp,
                    description: `PASS ${pass + 1}: Sorting by ${digitName} digit`
                });

                recordStep('extract', {
                    exp,
                    description: `Extracting ${digitName} digit from each number`
                });

                // Perform counting sort on this digit
                const sorted = this.countingSortByDigit(arr, exp);
                arr.splice(0, arr.length, ...sorted);

                recordStep('sorting', {
                    exp,
                    description: `Sorting by ${digitName} digit using Counting Sort`
                });

                recordStep('pass-complete', {
                    exp,
                    description: `Pass ${pass + 1} complete! Array sorted by ${digitName} digit`
                });

                exp *= 10;
            }

            recordStep('complete', {
                description: 'Radix Sort complete! Array is fully sorted.'
            });

            return this.animationSteps;
        }

        countingSortByDigit(arr, exp) {
            const n = arr.length;
            const output = new Array(n);
            const count = new Array(10).fill(0);

            // Count occurrences
            for (let i = 0; i < n; i++) {
                const digit = Math.floor(arr[i] / exp) % 10;
                count[digit]++;
            }

            // Cumulative count
            for (let i = 1; i < 10; i++) {
                count[i] += count[i - 1];
            }

            // Build output (right to left for stability)
            for (let i = n - 1; i >= 0; i--) {
                const digit = Math.floor(arr[i] / exp) % 10;
                output[count[digit] - 1] = arr[i];
                count[digit]--;
            }

            return output;
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

            document.getElementById('statCurrentPass').textContent = this.stats.currentPass;
            document.getElementById('statTotalPasses').textContent = this.stats.totalPasses;
            document.getElementById('vizOperation').textContent = step.description || '';

            // Update pass title
            if (step.exp) {
                const digitName = this.getDigitName(step.exp);
                document.getElementById('vizPassTitle').textContent =
                    `Pass ${this.stats.currentPass}: Sorting by ${digitName} digit`;
            } else if (step.type === 'complete') {
                document.getElementById('vizPassTitle').textContent = 'Sorted Array';
            } else {
                document.getElementById('vizPassTitle').textContent = 'Original Array';
            }

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
            this.stats = { passes: 0, currentPass: 0, totalPasses: 0 };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderVisualization();

            document.getElementById('statCurrentPass').textContent = '0';
            document.getElementById('statTotalPasses').textContent = '0';
            document.getElementById('vizOperation').textContent = 'Ready to sort...';
            document.getElementById('vizPassTitle').textContent = 'Original Array';
        }

        shuffle() {
            this.array = Array.from({ length: 8 }, () => Math.floor(Math.random() * 900) + 1);
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
            new RadixSortViz('radixSortVisualization');
        });
    } else {
        new RadixSortViz('radixSortVisualization');
    }
})();
