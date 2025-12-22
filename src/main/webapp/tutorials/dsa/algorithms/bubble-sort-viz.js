/**
 * Bubble Sort Visualization
 * Embedded visualization for the Bubble Sort tutorial lesson
 */

(function () {
    'use strict';

    class BubbleSortVisualization {
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
                swaps: 0,
                accesses: 0,
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
                    <div class="viz-slider-group">
                        <div class="viz-slider-label">
                            <span>Array Size</span>
                            <span id="vizSizeValue">8</span>
                        </div>
                        <input type="range" class="viz-slider" id="vizSize" min="4" max="15" value="8" step="1">
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
                    <div class="viz-stat-label">Swaps</div>
                    <div class="viz-stat-value" id="statSwaps">0</div>
                </div>
                <div class="viz-stat-card">
                    <div class="viz-stat-label">Array Accesses</div>
                    <div class="viz-stat-value" id="statAccesses">0</div>
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

            document.getElementById('vizSize').addEventListener('input', (e) => {
                this.size = parseInt(e.target.value);
                document.getElementById('vizSizeValue').textContent = this.size;
                if (!this.isRunning) {
                    this.generateArray();
                    this.renderArray();
                }
            });
        }

        generateArray() {
            this.array = Array.from({ length: this.size }, () =>
                Math.floor(Math.random() * 99) + 1
            );
            this.resetStats();
        }

        resetStats() {
            this.stats = { comparisons: 0, swaps: 0, accesses: 0, pass: 0 };
            this.updateStats();
        }

        updateStats() {
            document.getElementById('statComparisons').textContent = this.stats.comparisons;
            document.getElementById('statSwaps').textContent = this.stats.swaps;
            document.getElementById('statAccesses').textContent = this.stats.accesses;
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
                box.textContent = value;
                box.setAttribute('data-index', `[${index}]`);

                arrayContainer.appendChild(box);
                this.boxes.push(box);
            });
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }

        async swap(i, j) {
            const box1 = this.boxes[i];
            const box2 = this.boxes[j];

            this.updateOperation(`Swapping ${this.array[i]} and ${this.array[j]}`);

            box1.classList.add('swapping');
            box2.classList.add('swapping');

            const rect1 = box1.getBoundingClientRect();
            const rect2 = box2.getBoundingClientRect();
            const distance = rect2.left - rect1.left;

            box1.style.transition = `transform ${this.speed * 0.6}ms cubic-bezier(0.68, -0.55, 0.265, 1.55)`;
            box2.style.transition = `transform ${this.speed * 0.6}ms cubic-bezier(0.68, -0.55, 0.265, 1.55)`;

            box1.style.transform = `translateX(${distance}px) translateY(-30px)`;
            box2.style.transform = `translateX(${-distance}px) translateY(-30px)`;

            await this.sleep(this.speed * 0.6);

            box1.style.transform = `translateX(${distance}px)`;
            box2.style.transform = `translateX(${-distance}px)`;

            await this.sleep(this.speed * 0.4);

            if (i < j) {
                box2.parentNode.insertBefore(box2, box1);
            } else {
                box1.parentNode.insertBefore(box1, box2);
            }

            box1.style.transition = 'none';
            box2.style.transition = 'none';
            box1.style.transform = '';
            box2.style.transform = '';

            [this.array[i], this.array[j]] = [this.array[j], this.array[i]];
            [this.boxes[i], this.boxes[j]] = [this.boxes[j], this.boxes[i]];

            this.boxes.forEach((box, idx) => {
                box.setAttribute('data-index', `[${idx}]`);
            });

            this.stats.swaps++;
            this.stats.accesses += 4;
            this.updateStats();

            box1.classList.remove('swapping');
            box2.classList.remove('swapping');
        }

        async compare(i, j) {
            this.boxes[i].classList.add('comparing');
            this.boxes[j].classList.add('comparing');

            this.updateOperation(`Comparing ${this.array[i]} and ${this.array[j]}`);

            this.stats.comparisons++;
            this.stats.accesses += 2;
            this.updateStats();

            await this.sleep(this.speed * 0.5);

            const shouldSwap = this.array[i] > this.array[j];

            this.boxes[i].classList.remove('comparing');
            this.boxes[j].classList.remove('comparing');

            return shouldSwap;
        }

        async markSorted(index) {
            this.boxes[index].classList.add('sorted');
            this.updateOperation(`Element ${this.array[index]} is now in its final position`);
            await this.sleep(this.speed * 0.3);
        }

        async bubbleSort() {
            const n = this.array.length;

            for (let i = 0; i < n - 1; i++) {
                if (!this.isRunning) break;

                this.stats.pass = i + 1;
                this.updateStats();
                this.updateOperation(`Pass ${i + 1}: Finding the ${i + 1}${this.getOrdinalSuffix(i + 1)} largest element`);
                await this.sleep(this.speed * 0.5);

                let swapped = false;

                for (let j = 0; j < n - i - 1; j++) {
                    if (!this.isRunning) break;

                    while (this.isPaused) {
                        await this.sleep(100);
                    }

                    if (await this.compare(j, j + 1)) {
                        await this.swap(j, j + 1);
                        swapped = true;
                    }
                }

                await this.markSorted(n - i - 1);

                if (!swapped) {
                    this.updateOperation('Array is already sorted! Early termination.');
                    await this.sleep(this.speed);
                    for (let k = 0; k < n - i - 1; k++) {
                        await this.markSorted(k);
                    }
                    break;
                }
            }

            if (this.isRunning) {
                await this.markSorted(0);
                this.updateOperation('✅ Sorting complete! Array is now sorted.');
                this.complete();
            }
        }

        getOrdinalSuffix(num) {
            const j = num % 10;
            const k = num % 100;
            if (j === 1 && k !== 11) return 'st';
            if (j === 2 && k !== 12) return 'nd';
            if (j === 3 && k !== 13) return 'rd';
            return 'th';
        }

        async start() {
            if (this.isRunning) return;

            this.isRunning = true;
            this.isPaused = false;
            document.getElementById('vizStart').disabled = true;
            document.getElementById('vizPause').disabled = false;
            document.getElementById('vizShuffle').disabled = true;
            document.getElementById('vizSize').disabled = true;

            await this.bubbleSort();
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
            document.getElementById('vizSize').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';

            this.generateArray();
            this.renderArray();
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
            document.getElementById('vizSize').disabled = false;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new BubbleSortVisualization('bubbleSortVisualization');
        });
    } else {
        new BubbleSortVisualization('bubbleSortVisualization');
    }
})();
