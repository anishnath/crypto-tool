/**
 * Selection Sort Visualization - Compact & Consistent
 * Shows minimum selection and single swap per pass
 */

(function () {
    'use strict';

    class SelectionSortVisualization {
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
                    <div class="viz-stat-label">Swaps</div>
                    <div class="viz-stat-value" id="statSwaps">0</div>
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
            this.stats = { comparisons: 0, swaps: 0, pass: 0 };
            this.updateStats();
        }

        updateStats() {
            document.getElementById('statComparisons').textContent = this.stats.comparisons;
            document.getElementById('statSwaps').textContent = this.stats.swaps;
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

        async highlightMin(index) {
            this.boxes[index].classList.add('finding-min');
            await this.sleep(this.speed * 0.3);
        }

        clearHighlights() {
            this.boxes.forEach(box => {
                box.classList.remove('comparing', 'finding-min', 'current-min');
            });
        }

        async compare(i, j, currentMin) {
            this.boxes[i].classList.add('comparing');
            this.boxes[j].classList.add('comparing');

            if (currentMin !== i && currentMin !== j) {
                this.boxes[currentMin].classList.add('current-min');
            }

            this.updateOperation(`Comparing ${this.array[j]} with current min ${this.array[currentMin]}`);

            this.stats.comparisons++;
            this.updateStats();

            await this.sleep(this.speed * 0.5);

            this.boxes[i].classList.remove('comparing');
            this.boxes[j].classList.remove('comparing');

            return this.array[j] < this.array[currentMin];
        }

        async swap(i, j) {
            if (i === j) return;

            const box1 = this.boxes[i];
            const box2 = this.boxes[j];

            this.updateOperation(`Swapping ${this.array[i]} and ${this.array[j]}`);

            box1.classList.add('swapping');
            box2.classList.add('swapping');

            const rect1 = box1.getBoundingClientRect();
            const rect2 = box2.getBoundingClientRect();
            const distance = rect2.left - rect1.left;

            box1.style.transition = `transform ${this.speed * 0.6}ms ease`;
            box2.style.transition = `transform ${this.speed * 0.6}ms ease`;

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
            this.updateStats();

            box1.classList.remove('swapping');
            box2.classList.remove('swapping');
        }

        async markSorted(index) {
            this.boxes[index].classList.add('sorted');
            await this.sleep(this.speed * 0.3);
        }

        async selectionSort() {
            const n = this.array.length;

            for (let i = 0; i < n - 1; i++) {
                if (!this.isRunning) break;

                this.stats.pass = i + 1;
                this.updateStats();

                await this.highlightMin(i);
                this.updateOperation(`Pass ${i + 1}: Finding minimum from index ${i}`);
                await this.sleep(this.speed * 0.5);

                let minIdx = i;
                this.boxes[minIdx].classList.add('current-min');

                for (let j = i + 1; j < n; j++) {
                    if (!this.isRunning) break;

                    while (this.isPaused) {
                        await this.sleep(100);
                    }

                    if (await this.compare(i, j, minIdx)) {
                        this.boxes[minIdx].classList.remove('current-min');
                        minIdx = j;
                        this.boxes[minIdx].classList.add('current-min');
                    }
                }

                this.clearHighlights();

                if (minIdx !== i) {
                    await this.swap(i, minIdx);
                } else {
                    this.updateOperation(`${this.array[i]} already in correct position`);
                    await this.sleep(this.speed * 0.5);
                }

                await this.markSorted(i);
            }

            if (this.isRunning) {
                await this.markSorted(n - 1);
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

            await this.selectionSort();
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
            new SelectionSortVisualization('selectionSortVisualization');
        });
    } else {
        new SelectionSortVisualization('selectionSortVisualization');
    }
})();
