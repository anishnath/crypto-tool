/**
 * Hash Maps & Sets Visualization
 * Shows Two Sum algorithm in action
 */

(function () {
    'use strict';

    class HashMapViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.map = new Map();
            this.isRunning = false;
            this.speed = 1500;

            this.init();
        }

        init() {
            this.render();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Two Sum - HashMap Pattern</h3>
                    <p class="viz-subtitle">The most asked interview question!</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Target</div>
                        <div class="viz-stat-value" id="targetValue">9</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Current</div>
                        <div class="viz-stat-value" id="currentValue">-</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complement</div>
                        <div class="viz-stat-value" id="complementValue">-</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Click "Run Demo" to see Two Sum algorithm!
                </div>
                
                <div class="viz-canvas">
                    <div class="hashmap-display">
                        <div class="hashmap-section">
                            <div class="hashmap-label">Array:</div>
                            <div class="hashmap-array" id="arrayDisplay"></div>
                        </div>
                        <div class="hashmap-section">
                            <div class="hashmap-label">HashMap (seen):</div>
                            <div class="hashmap-entries" id="mapDisplay">
                                <div class="hashmap-empty">Empty</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="viz-operations">
                    <h4>Algorithm:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn viz-op-btn-primary" id="runDemo">
                            <span class="viz-op-icon">▶️</span>
                            <span class="viz-op-label">Run Two Sum</span>
                            <span class="viz-op-complexity">O(n)</span>
                        </button>
                        <button class="viz-op-btn" id="resetBtn">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Reset</span>
                        </button>
                    </div>
                </div>
            `;

            this.bindEvents();
            this.renderArray();
        }

        bindEvents() {
            document.getElementById('runDemo').addEventListener('click', () => this.runTwoSum());
            document.getElementById('resetBtn').addEventListener('click', () => this.reset());
        }

        renderArray() {
            const nums = [2, 7, 11, 15];
            const display = document.getElementById('arrayDisplay');

            display.innerHTML = nums.map((num, idx) =>
                `<div class="array-item" data-idx="${idx}">${num}</div>`
            ).join('');
        }

        renderMap() {
            const display = document.getElementById('mapDisplay');

            if (this.map.size === 0) {
                display.innerHTML = '<div class="hashmap-empty">Empty</div>';
                return;
            }

            let html = '';
            this.map.forEach((value, key) => {
                html += `<div class="hashmap-entry">${key} → ${value}</div>`;
            });
            display.innerHTML = html;
        }

        async runTwoSum() {
            if (this.isRunning) return;
            this.isRunning = true;

            const nums = [2, 7, 11, 15];
            const target = 9;
            this.map.clear();
            this.renderMap();

            document.getElementById('explanation').textContent =
                'Starting Two Sum algorithm...';
            await this.sleep(this.speed * 0.5);

            for (let i = 0; i < nums.length; i++) {
                const num = nums[i];
                const complement = target - num;

                document.getElementById('currentValue').textContent = num;
                document.getElementById('complementValue').textContent = complement;

                this.highlightArrayItem(i);

                document.getElementById('explanation').textContent =
                    `Checking ${num}, need complement ${complement}...`;
                await this.sleep(this.speed);

                if (this.map.has(complement)) {
                    document.getElementById('explanation').textContent =
                        `✅ Found! ${this.map.get(complement)} + ${num} = ${target}`;
                    this.isRunning = false;
                    return;
                }

                this.map.set(num, i);
                this.renderMap();

                document.getElementById('explanation').textContent =
                    `Added ${num} → ${i} to HashMap`;
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent =
                '✗ No solution found';
            this.isRunning = false;
        }

        highlightArrayItem(idx) {
            document.querySelectorAll('.array-item').forEach((item, i) => {
                if (i === idx) {
                    item.classList.add('array-item-active');
                } else {
                    item.classList.remove('array-item-active');
                }
            });
        }

        reset() {
            this.map.clear();
            this.isRunning = false;
            document.getElementById('currentValue').textContent = '-';
            document.getElementById('complementValue').textContent = '-';
            document.getElementById('explanation').textContent =
                'Click "Run Demo" to see Two Sum algorithm!';
            this.renderMap();
            document.querySelectorAll('.array-item').forEach(item =>
                item.classList.remove('array-item-active'));
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new HashMapViz('hashMapVisualization');
        });
    } else {
        new HashMapViz('hashMapVisualization');
    }
})();
