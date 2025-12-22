/**
 * Tim Sort Visualization - The Hybrid Champion
 * Shows run detection, extension, and merging
 */

(function () {
    'use strict';

    class TimSortViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [5, 2, 8, 1, 9, 3, 7, 4, 6];
            this.originalArray = [...this.array];
            this.animationSteps = [];
            this.currentStep = 0;
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 1500;

            this.stats = {
                runsFound: 0,
                mergesPerformed: 0,
                minrun: 0
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
                        <div class="viz-stat-label">Runs Found</div>
                        <div class="viz-stat-value" id="statRuns">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Merges</div>
                        <div class="viz-stat-value" id="statMerges">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Minrun</div>
                        <div class="viz-stat-value" id="statMinrun">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(n log n)</div>
                    </div>
                </div>
                
                <div class="viz-operation" id="vizOperation">Ready to sort...</div>
                
                <div class="viz-array-section">
                    <h4 id="vizPhaseTitle">Original Array</h4>
                    <div class="viz-canvas">
                        <div class="viz-array" id="vizArray"></div>
                    </div>
                </div>
                
                <div class="viz-runs-section" id="vizRunsSection" style="display: none;">
                    <h4>Detected Runs</h4>
                    <div id="vizRunsList"></div>
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
            document.getElementById('vizShuffle').addEventListener('click', () => this.shuffle());

            document.getElementById('vizSpeed').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('vizSpeedValue').textContent = `${this.speed}ms`;
            });
        }

        renderVisualization() {
            this.renderArray();
            this.renderRuns();
        }

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';

            const currentStepData = this.animationSteps[this.currentStep];
            let runRanges = [];
            let highlightIndices = [];

            if (currentStepData) {
                runRanges = currentStepData.runs || [];
                highlightIndices = currentStepData.highlight || [];
            }

            this.array.forEach((value, idx) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                box.textContent = value;

                // Check if in a run
                let inRun = false;
                runRanges.forEach((run, runIdx) => {
                    if (idx >= run.start && idx < run.end) {
                        box.classList.add('in-run');
                        box.style.borderColor = this.getRunColor(runIdx);
                        inRun = true;
                    }
                });

                if (highlightIndices.includes(idx)) {
                    box.classList.add('current');
                }

                if (currentStepData && currentStepData.type === 'complete' && !inRun) {
                    box.classList.add('sorted');
                }

                arrayContainer.appendChild(box);
            });
        }

        renderRuns() {
            const currentStepData = this.animationSteps[this.currentStep];
            const runsSection = document.getElementById('vizRunsSection');
            const runsList = document.getElementById('vizRunsList');

            if (!currentStepData || !currentStepData.runs || currentStepData.runs.length === 0) {
                runsSection.style.display = 'none';
                return;
            }

            runsSection.style.display = 'block';
            runsList.innerHTML = '';

            currentStepData.runs.forEach((run, idx) => {
                const runDiv = document.createElement('div');
                runDiv.className = 'viz-run-item';
                runDiv.style.borderLeft = `4px solid ${this.getRunColor(idx)}`;

                const runData = this.array.slice(run.start, run.end);
                runDiv.innerHTML = `
                    <strong>Run ${idx + 1}:</strong> 
                    [${run.start}:${run.end}] = [${runData.join(', ')}]
                    <span class="viz-run-length">(length: ${run.end - run.start})</span>
                `;

                runsList.appendChild(runDiv);
            });
        }

        getRunColor(runIdx) {
            const colors = ['#4cc9f0', '#f72585', '#7209b7', '#3a0ca3', '#4361ee', '#4895ef'];
            return colors[runIdx % colors.length];
        }

        calculateMinrun(n) {
            let r = 0;
            while (n >= 64) {
                r |= n & 1;
                n >>= 1;
            }
            return n + r;
        }

        generateAnimationSteps() {
            this.animationSteps = [];
            const arr = [...this.originalArray];
            const n = arr.length;

            const minrun = this.calculateMinrun(n);
            this.stats = {
                runsFound: 0,
                mergesPerformed: 0,
                minrun: minrun
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
                description: `Starting Tim Sort - Python's default algorithm!`,
                runs: []
            });

            recordStep('minrun', {
                description: `Calculated minrun = ${minrun} (minimum run length)`,
                runs: []
            });

            // Phase 1: Detect and create runs
            const runs = [];
            let i = 0;

            recordStep('phase', {
                description: 'PHASE 1: Detecting natural runs (sorted sequences)',
                runs: []
            });

            while (i < n) {
                const runStart = i;
                let runEnd = i + 1;

                // Find natural run
                if (runEnd < n) {
                    if (arr[runEnd] >= arr[i]) {
                        // Ascending
                        while (runEnd < n && arr[runEnd] >= arr[runEnd - 1]) {
                            runEnd++;
                        }
                    } else {
                        // Descending - reverse it
                        while (runEnd < n && arr[runEnd] < arr[runEnd - 1]) {
                            runEnd++;
                        }
                        arr.splice(runStart, runEnd - runStart, ...arr.slice(runStart, runEnd).reverse());
                    }
                }

                // Extend to minrun if needed
                if (runEnd - runStart < minrun) {
                    runEnd = Math.min(runStart + minrun, n);
                    // Insertion sort to extend
                    for (let j = runStart + 1; j < runEnd; j++) {
                        const key = arr[j];
                        let k = j - 1;
                        while (k >= runStart && arr[k] > key) {
                            arr[k + 1] = arr[k];
                            k--;
                        }
                        arr[k + 1] = key;
                    }
                }

                runs.push({ start: runStart, end: runEnd });
                this.stats.runsFound++;

                recordStep('run-found', {
                    description: `Found run ${runs.length}: [${runStart}:${runEnd}] (length ${runEnd - runStart})`,
                    runs: [...runs],
                    highlight: Array.from({ length: runEnd - runStart }, (_, idx) => runStart + idx)
                });

                i = runEnd;
            }

            // Phase 2: Merge runs
            recordStep('phase', {
                description: `PHASE 2: Merging ${runs.length} runs`,
                runs: [...runs]
            });

            while (runs.length > 1) {
                const run1 = runs[0];
                const run2 = runs[1];

                recordStep('merge-start', {
                    description: `Merging runs [${run1.start}:${run1.end}] + [${run2.start}:${run2.end}]`,
                    runs: [...runs],
                    highlight: [
                        ...Array.from({ length: run1.end - run1.start }, (_, idx) => run1.start + idx),
                        ...Array.from({ length: run2.end - run2.start }, (_, idx) => run2.start + idx)
                    ]
                });

                // Merge
                const merged = [];
                let i1 = run1.start, i2 = run2.start;

                while (i1 < run1.end && i2 < run2.end) {
                    if (arr[i1] <= arr[i2]) {
                        merged.push(arr[i1++]);
                    } else {
                        merged.push(arr[i2++]);
                    }
                }

                while (i1 < run1.end) merged.push(arr[i1++]);
                while (i2 < run2.end) merged.push(arr[i2++]);

                arr.splice(run1.start, run2.end - run1.start, ...merged);

                runs[0] = { start: run1.start, end: run2.end };
                runs.splice(1, 1);
                this.stats.mergesPerformed++;

                recordStep('merge-complete', {
                    description: `Merge complete! ${runs.length} run(s) remaining`,
                    runs: [...runs]
                });
            }

            recordStep('complete', {
                description: 'Tim Sort complete! Array is fully sorted.',
                runs: []
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

            document.getElementById('statRuns').textContent = this.stats.runsFound;
            document.getElementById('statMerges').textContent = this.stats.mergesPerformed;
            document.getElementById('statMinrun').textContent = this.stats.minrun;
            document.getElementById('vizOperation').textContent = step.description || '';

            if (step.type === 'phase') {
                document.getElementById('vizPhaseTitle').textContent = step.description;
            } else if (step.type === 'complete') {
                document.getElementById('vizPhaseTitle').textContent = 'Sorted Array';
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
            this.stats = { runsFound: 0, mergesPerformed: 0, minrun: 0 };

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.renderVisualization();

            document.getElementById('statRuns').textContent = '0';
            document.getElementById('statMerges').textContent = '0';
            document.getElementById('statMinrun').textContent = '0';
            document.getElementById('vizOperation').textContent = 'Ready to sort...';
            document.getElementById('vizPhaseTitle').textContent = 'Original Array';
        }

        shuffle() {
            this.array = Array.from({ length: 9 }, () => Math.floor(Math.random() * 20) + 1);
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
            new TimSortViz('timSortVisualization');
        });
    } else {
        new TimSortViz('timSortVisualization');
    }
})();
