/**
 * Insertion Sort Visualization - Compact & Consistent
 * Shows building sorted portion by inserting elements one by one
 */

(function () {
    'use strict';

    class InsertionSortVisualization {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [];
            this.boxes = [];
            this.isRunning = false;
            this.isPaused = false;
            this.speed = 800;
            this.size = 8;
            this.stats = {
                comparisons: 0,
                shifts: 0,
                pass: 0
            };

            this.init();
        }

        init() {
            this.render();
            this.generateArray();
            this.renderArray();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-stats" id="vizStats"></div>
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
                        <input type="range" class="viz-slider" id="vizSpeed" min="200" max="2000" value="800" step="100">
                    </div>
                </div>
            `;

            this.renderStats();
            this.bindEvents();
        }

        renderStats() {
            const statsContainer = document.getElementById('vizStats');
            statsContainer.innerHTML = `
                <div class="viz-stat-card">
                    <div class="viz-stat-label">Comparisons</div>
                    <div class="viz-stat-value" id="statComparisons">0</div>
                </div>
                <div class="viz-stat-card">
                    <div class="viz-stat-label">Shifts</div>
                    <div class="viz-stat-value" id="statShifts">0</div>
                </div>
                <div class="viz-stat-card">
                    <div class="viz-stat-label">Current Pass</div>
                    <div class="viz-stat-value" id="statPass">0</div>
                </div>
            `;
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

        generateArray() {
            this.array = Array.from({ length: this.size }, () =>
                Math.floor(Math.random() * 99) + 1
            );
            this.resetStats();
        }

        resetStats() {
            this.stats = { comparisons: 0, shifts: 0, pass: 0 };
            this.updateStats();
        }

        updateStats() {
            document.getElementById('statComparisons').textContent = this.stats.comparisons;
            document.getElementById('statShifts').textContent = this.stats.shifts;
            document.getElementById('statPass').textContent = this.stats.pass;
        }

        updateOperation(text) {
            document.getElementById('vizOperation').textContent = text;
        }

        renderArray() {
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';
            this.boxes = [];

            this.array.forEach((value, index) => {
                const box = document.createElement('div');
                box.className = 'viz-box';
                if (index === 0) {
                    box.classList.add('sorted'); // First element is already "sorted"
                }
                box.textContent = value;
                box.setAttribute('data-index', `[${index}]`);

                arrayContainer.appendChild(box);
                this.boxes.push(box);
            });
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }

        clearHighlights() {
            this.boxes.forEach(box => {
                box.classList.remove('comparing', 'current-key', 'shifting');
            });
        }

        async highlightKey(index) {
            this.boxes[index].classList.add('current-key');
            await this.sleep(this.speed * 0.4);
        }

        async compare(keyIndex, compareIndex) {
            this.boxes[compareIndex].classList.add('comparing');

            this.updateOperation(`Comparing ${this.array[keyIndex]} with ${this.array[compareIndex]}`);

            this.stats.comparisons++;
            this.updateStats();

            await this.sleep(this.speed * 0.5);

            this.boxes[compareIndex].classList.remove('comparing');

            return this.array[keyIndex] < this.array[compareIndex];
        }

        async shift(fromIndex, toIndex) {
            const box = this.boxes[fromIndex];
            box.classList.add('shifting');

            this.updateOperation(`Shifting ${this.array[fromIndex]} to the right`);

            await this.sleep(this.speed * 0.4);

            // Swap in array
            [this.array[fromIndex], this.array[toIndex]] = [this.array[toIndex], this.array[fromIndex]];
            [this.boxes[fromIndex], this.boxes[toIndex]] = [this.boxes[toIndex], this.boxes[fromIndex]];

            // Update indices
            this.boxes.forEach((box, idx) => {
                box.setAttribute('data-index', `[${idx}]`);
            });

            // Re-render to show shift
            const arrayContainer = document.getElementById('vizArray');
            arrayContainer.innerHTML = '';
            this.boxes.forEach(box => arrayContainer.appendChild(box));

            this.stats.shifts++;
            this.updateStats();

            box.classList.remove('shifting');
        }

        async markSorted(index) {
            this.boxes[index].classList.remove('current-key');
            this.boxes[index].classList.add('sorted');
            await this.sleep(this.speed * 0.2);
        }

        async insertionSort() {
            const n = this.array.length;

            // First element is already sorted
            for (let i = 1; i < n; i++) {
                if (!this.isRunning) break;

                this.stats.pass = i;
                this.updateStats();

                const key = this.array[i];
                await this.highlightKey(i);
                this.updateOperation(`Pass ${i}: Inserting ${key} into sorted portion`);
                await this.sleep(this.speed * 0.5);

                let j = i - 1;

                // Shift elements greater than key
                while (j >= 0) {
                    if (!this.isRunning) break;

                    while (this.isPaused) {
                        await this.sleep(100);
                    }

                    if (await this.compare(i, j)) {
                        // Need to shift
                        await this.shift(j, j + 1);
                        j--;
                    } else {
                        // Found correct position
                        break;
                    }
                }

                this.clearHighlights();
                await this.markSorted(j + 1);

                this.updateOperation(`${key} inserted at position ${j + 1}`);
                await this.sleep(this.speed * 0.3);
            }

            if (this.isRunning) {
                this.updateOperation('✅ Sorting complete!');
                this.complete();
            }
        }

        async start() {
            if (this.isRunning) return;

            this.isRunning = true;
            this.isPaused = false;
            document.getElementById('vizStart').disabled = true;
            document.getElementById('vizPause').disabled = false;
            document.getElementById('vizShuffle').disabled = true;

            await this.insertionSort();
        }

        pause() {
            this.isPaused = !this.isPaused;
            const pauseBtn = document.getElementById('vizPause');
            pauseBtn.innerHTML = this.isPaused ?
                '<span>▶️</span> Resume' :
                '<span>⏸</span> Pause';
            this.updateOperation(this.isPaused ? '⏸ Paused' : 'Resuming...');
        }

        reset() {
            this.isRunning = false;
            this.isPaused = false;
            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.generateArray();
            this.renderArray();
            this.updateOperation('Ready to sort...');
        }

        shuffle() {
            this.generateArray();
            this.renderArray();
        }

        complete() {
            this.isRunning = false;
            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizShuffle').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new InsertionSortVisualization('insertionSortVisualization');
        });
    } else {
        new InsertionSortVisualization('insertionSortVisualization');
    }
})();
