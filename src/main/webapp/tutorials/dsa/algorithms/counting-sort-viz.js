/**
 * Counting Sort Visualization - The Tally Counter
 * Shows count array building and output reconstruction
 */

(function () {
    'use strict';

    class CountingSortViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [4, 2, 2, 8, 3, 3, 1];
            this.originalArray = [...this.array];
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 1000;

            this.stats = {
                range: 0,
                counts: 0
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
                        <div class="viz-stat-label">Range</div>
                        <div class="viz-stat-value" id="statRange">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Array Size</div>
                        <div class="viz-stat-value" id="statSize">${this.array.length}</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(n+k)</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to sort...</div>
                
                <div class="viz-array-section">
                    <h4>Original Array</h4>
                    <div class="viz-canvas">
                        <div class="viz-array" id="vizArray"></div>
                    </div>
                </div>
                
                <div class="viz-count-section">
                    <h4>Count Array (Tally Marks)</h4>
                    <div class="viz-count-container" id="vizCountContainer"></div>
                </div>
                
                <div class="viz-output-section">
                    <h4>Sorted Output</h4>
                    <div class="viz-canvas">
                        <div class="viz-array" id="vizOutput"></div>
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
            this.renderCountArray();
            this.renderOutput();
        }

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            let currentIndex = -1;

            if (currentStepData && currentStepData.type === 'count') {
                currentIndex = currentStepData.index;
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                if (idx === currentIndex) {
                    box.classList.add('current');
                }

                arrayContainer.appendChild(box);
            });
        }

        renderCountArray() {
            const countContainer = document.getElementById('vizCountContainer');
            countContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            const counts = currentStepData ? currentStepData.counts : [];
            const minVal = currentStepData ? currentStepData.minVal : Math.min(...this.array);
            const maxVal = currentStepData ? currentStepData.maxVal : Math.max(...this.array);

            for (let i = minVal; i <= maxVal; i++) {
                const countBox = document.createElement('div');
                countBox.className = 'viz-count-box';

                const label = document.createElement('div');
                label.className = 'viz-count-label';
                label.textContent = i;

                const tallyContainer = document.createElement('div');
                tallyContainer.className = 'viz-tally-container';

                const count = counts[i - minVal] || 0;
                for (let j = 0; j < count; j++) {
                    const tally = document.createElement('div');
                    tally.className = 'viz-tally-mark';
                    tally.textContent = '|';
                    tallyContainer.appendChild(tally);
                }

                const countNum = document.createElement('div');
                countNum.className = 'viz-count-number';
                countNum.textContent = count;

                countBox.appendChild(label);
                countBox.appendChild(tallyContainer);
                countBox.appendChild(countNum);

                countContainer.appendChild(countBox);
            }
        }

        renderOutput() {
            const outputContainer = document.getElementById('vizOutput');
            outputContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            const output = currentStepData ? currentStepData.output : [];

            if (output.length === 0) {
                const placeholder = document.createElement('div');
                placeholder.className = 'viz-placeholder';
                placeholder.textContent = 'Output will appear here...';
                outputContainer.appendChild(placeholder);
                return;
            }

            output.forEach((value, idx) => {
                if (value !== null) {
                    const box = document.createElement('div');
                    box.className = 'viz-box sorted';
                    box.textContent = value;
                    outputContainer.appendChild(box);
                } else {
                    const box = document.createElement('div');
                    box.className = 'viz-box-empty';
                    box.textContent = '?';
                    outputContainer.appendChild(box);
                }
            });
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            const arr = [...this.originalArray];
            const n = arr.length;

            const minVal = Math.min(...arr);
            const maxVal = Math.max(...arr);
            const range = maxVal - minVal + 1;

            this.stats = {
                range: range,
                counts: 0
            };

            const recordStep = (type, data) => {
                this.animationSteps.push({
                    type,
                    array: [...arr],
                    minVal,
                    maxVal,
                    ...data,
                    stats: { ...this.stats }
                });
            };

            recordStep('start', {
                counts: new Array(range).fill(0),
                output: [],
                description: 'Starting Counting Sort - O(n) linear time!'
            });

            // Phase 1: Count occurrences
            const counts = new Array(range).fill(0);

            recordStep('phase', {
                counts: [...counts],
                output: [],
                description: `PHASE 1: Counting occurrences (range: ${minVal} to ${maxVal})`
            });

            for (let i = 0; i < n; i++) {
                counts[arr[i] - minVal]++;
                this.stats.counts++;

                recordStep('count', {
                    index: i,
                    counts: [...counts],
                    output: [],
                    description: `Counting ${arr[i]} → count[${arr[i] - minVal}] = ${counts[arr[i] - minVal]}`
                });
            }

            recordStep('phase', {
                counts: [...counts],
                output: [],
                description: 'PHASE 2: Reconstructing sorted array from counts'
            });

            // Phase 2: Reconstruct sorted array
            const output = [];
            for (let i = 0; i < range; i++) {
                const value = i + minVal;
                const count = counts[i];

                if (count > 0) {
                    recordStep('reconstruct', {
                        counts: [...counts],
                        output: [...output],
                        description: `Placing ${count} occurrence(s) of ${value}`
                    });

                    for (let j = 0; j < count; j++) {
                        output.push(value);

                        recordStep('place', {
                            counts: [...counts],
                            output: [...output],
                            description: `Placed ${value} at position ${output.length - 1}`
                        });
                    }
                }
            }

            recordStep('complete', {
                counts: [...counts],
                output: [...output],
                description: 'Counting Sort complete! Sorted in O(n+k) time!'
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
            this.stats = { ...step.stats };

            document.getElementById('statRange').textContent = this.stats.range;
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
            this.stats = { range: 0, counts: 0 };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderVisualization();

            document.getElementById('statRange').textContent = '0';
            document.getElementById('vizOperation').textContent = 'Ready to sort...';
        }

        shuffle() {
            this.array = Array.from({ length: 7 }, () => Math.floor(Math.random() * 9) + 1);
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
            new CountingSortViz('countingSortVisualization');
        });
    } else {
        new CountingSortViz('countingSortVisualization');
    }
})();
