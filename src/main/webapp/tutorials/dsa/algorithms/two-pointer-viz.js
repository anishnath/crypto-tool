/**
 * Two Pointer Techniques Visualization
 * Shows slow-fast and gap patterns
 */

(function () {
    'use strict';

    class TwoPointerViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.isRunning = false;
            this.speed = 1200;
            this.currentPattern = 'slow-fast';
            this.list = [1, 2, 3, 4, 5];

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Two Pointer Techniques</h3>
                    <p class="viz-subtitle">Master the slow-fast and gap patterns</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Current Step</div>
                        <div class="viz-stat-value" id="currentStep">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Pattern</div>
                        <div class="viz-stat-value" id="patternInfo">Slow-Fast</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Complexity</div>
                        <div class="viz-stat-value">O(n) time, O(1) space</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose a pattern to see how two pointers work!
                </div>
                
                <div class="viz-canvas">
                    <div class="two-pointer-viz" id="twoPointerViz"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Choose Pattern:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn viz-op-slow-fast" data-pattern="slow-fast">
                            <span class="viz-op-icon">🐢🐇</span>
                            <span class="viz-op-label">Slow-Fast Pattern</span>
                            <span class="viz-op-complexity">Find Middle</span>
                        </button>
                        <button class="viz-op-btn viz-op-gap" data-pattern="gap">
                            <span class="viz-op-icon">📏</span>
                            <span class="viz-op-label">Gap Pattern</span>
                            <span class="viz-op-complexity">Nth from End</span>
                        </button>
                        <button class="viz-op-btn viz-op-palindrome" data-pattern="palindrome">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Palindrome Check</span>
                            <span class="viz-op-complexity">Slow-Fast + Reverse</span>
                        </button>
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
                            <span id="speedValue">1200ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="speedSlider" 
                               min="600" max="2000" value="1200" step="200">
                    </div>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.querySelectorAll('[data-pattern]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    this.currentPattern = e.currentTarget.dataset.pattern;
                    this.reset();

                    document.querySelectorAll('[data-pattern]').forEach(b =>
                        b.classList.remove('viz-op-btn-selected'));
                    e.currentTarget.classList.add('viz-op-btn-selected');
                });
            });

            document.getElementById('vizStart').addEventListener('click', () => this.start());
            document.getElementById('vizPause').addEventListener('click', () => this.pause());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });

            // Select slow-fast by default
            document.querySelector('[data-pattern="slow-fast"]').classList.add('viz-op-btn-selected');
        }

        renderVisualization() {
            const container = document.getElementById('twoPointerViz');
            if (!container) return;

            container.innerHTML = '';

            const listDiv = document.createElement('div');
            listDiv.className = 'tp-list';

            // Render nodes
            this.list.forEach((val, idx) => {
                const nodeDiv = document.createElement('div');
                nodeDiv.className = 'tp-node-container';
                nodeDiv.innerHTML = `
                    <div class="tp-node" data-idx="${idx}">
                        <div class="tp-node-value">${val}</div>
                        <div class="tp-node-label" id="label${idx}"></div>
                    </div>
                    ${idx < this.list.length - 1 ? '<div class="tp-arrow">→</div>' : ''}
                `;
                listDiv.appendChild(nodeDiv);
            });

            container.appendChild(listDiv);

            // Pattern description
            const descDiv = document.createElement('div');
            descDiv.className = 'tp-pattern-desc';

            if (this.currentPattern === 'slow-fast') {
                descDiv.innerHTML = `
                    <div class="tp-desc-card">
                        <h4>Slow-Fast Pattern</h4>
                        <p>🐢 Slow pointer moves 1 step</p>
                        <p>🐇 Fast pointer moves 2 steps</p>
                        <p>When fast reaches end, slow is at middle!</p>
                    </div>
                `;
            } else if (this.currentPattern === 'gap') {
                descDiv.innerHTML = `
                    <div class="tp-desc-card">
                        <h4>Gap Pattern (2nd from end)</h4>
                        <p>📍 First pointer moves 2 steps ahead</p>
                        <p>📍 Second pointer starts at head</p>
                        <p>Both move together - gap maintained!</p>
                    </div>
                `;
            } else {
                descDiv.innerHTML = `
                    <div class="tp-desc-card">
                        <h4>Palindrome Check</h4>
                        <p>1. Find middle with slow-fast</p>
                        <p>2. Reverse second half</p>
                        <p>3. Compare both halves</p>
                    </div>
                `;
            }

            container.appendChild(descDiv);
        }

        async start() {
            if (this.isRunning) return;

            this.isRunning = true;
            this.isPaused = false;
            document.getElementById('vizStart').disabled = true;
            document.getElementById('vizPause').disabled = false;

            if (this.currentPattern === 'slow-fast') {
                await this.runSlowFast();
            } else if (this.currentPattern === 'gap') {
                await this.runGap();
            } else {
                await this.runPalindrome();
            }
        }

        async runSlowFast() {
            document.getElementById('patternInfo').textContent = 'Slow-Fast';

            let slow = 0;
            let fast = 0;
            let step = 0;

            this.highlightNodes(slow, fast, 'slow', 'fast');
            document.getElementById('explanation').textContent =
                'Starting: Both at index 0';
            await this.sleep(this.speed);

            while (fast < this.list.length - 1 && this.isRunning) {
                while (this.isPaused) await this.sleep(100);

                step++;

                // Move slow 1 step
                if (slow < this.list.length - 1) {
                    slow++;
                }

                // Move fast 2 steps
                if (fast < this.list.length - 1) {
                    fast++;
                    if (fast < this.list.length - 1) {
                        fast++;
                    }
                }

                this.highlightNodes(slow, fast, 'slow', 'fast');
                document.getElementById('currentStep').textContent = step;
                document.getElementById('explanation').textContent =
                    `Step ${step}: Slow at ${this.list[slow]}, Fast at ${this.list[fast]}`;

                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent =
                `✅ Middle found! Slow is at index ${slow} (value = ${this.list[slow]})`;
            this.complete();
        }

        async runGap() {
            document.getElementById('patternInfo').textContent = 'Gap Pattern';

            const n = 2; // 2nd from end
            let first = 0;
            let second = 0;
            let step = 0;

            // Phase 1: Move first n steps ahead
            document.getElementById('explanation').textContent =
                `Phase 1: Moving first pointer ${n} steps ahead...`;

            for (let i = 0; i < n && this.isRunning; i++) {
                while (this.isPaused) await this.sleep(100);

                first++;
                step++;
                this.highlightNodes(second, first, 'second', 'first');
                document.getElementById('currentStep').textContent = step;
                document.getElementById('explanation').textContent =
                    `Step ${step}: First moved to index ${first}`;
                await this.sleep(this.speed);
            }

            // Phase 2: Move both together
            document.getElementById('explanation').textContent =
                `Phase 2: Moving both together (gap = ${n})...`;
            await this.sleep(this.speed * 0.5);

            while (first < this.list.length - 1 && this.isRunning) {
                while (this.isPaused) await this.sleep(100);

                first++;
                second++;
                step++;

                this.highlightNodes(second, first, 'second', 'first');
                document.getElementById('currentStep').textContent = step;
                document.getElementById('explanation').textContent =
                    `Step ${step}: Second at ${this.list[second]}, First at ${this.list[first]}`;
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent =
                `✅ Found! Second is at ${n}nd from end (value = ${this.list[second]})`;
            this.complete();
        }

        async runPalindrome() {
            document.getElementById('patternInfo').textContent = 'Palindrome';

            // Use palindrome list
            this.list = [1, 2, 3, 2, 1];
            this.renderVisualization();
            await this.sleep(500);

            let slow = 0;
            let fast = 0;
            let step = 0;

            // Phase 1: Find middle
            document.getElementById('explanation').textContent =
                'Phase 1: Finding middle with slow-fast...';
            await this.sleep(this.speed * 0.5);

            while (fast < this.list.length - 1 && this.isRunning) {
                while (this.isPaused) await this.sleep(100);

                step++;
                if (slow < this.list.length - 1) slow++;
                if (fast < this.list.length - 1) {
                    fast++;
                    if (fast < this.list.length - 1) fast++;
                }

                this.highlightNodes(slow, fast, 'slow', 'fast');
                document.getElementById('currentStep').textContent = step;
                await this.sleep(this.speed * 0.8);
            }

            document.getElementById('explanation').textContent =
                `Middle found at index ${slow}. Now comparing halves...`;
            await this.sleep(this.speed);

            // Phase 2: Compare (simplified visualization)
            let left = 0;
            let right = this.list.length - 1;

            while (left < right && this.isRunning) {
                while (this.isPaused) await this.sleep(100);

                step++;
                this.highlightNodes(left, right, 'compare', 'compare');
                document.getElementById('currentStep').textContent = step;
                document.getElementById('explanation').textContent =
                    `Comparing: ${this.list[left]} vs ${this.list[right]}`;
                await this.sleep(this.speed);

                left++;
                right--;
            }

            document.getElementById('explanation').textContent =
                '✅ It\'s a palindrome! All values match.';
            this.complete();
        }

        highlightNodes(idx1, idx2, type1, type2) {
            // Clear all
            document.querySelectorAll('.tp-node').forEach(node => {
                node.classList.remove('tp-node-slow', 'tp-node-fast',
                    'tp-node-first', 'tp-node-second', 'tp-node-compare');
            });

            for (let i = 0; i < this.list.length; i++) {
                const label = document.getElementById(`label${i}`);
                if (label) label.textContent = '';
            }

            // Highlight
            const node1 = document.querySelector(`[data-idx="${idx1}"]`);
            const node2 = document.querySelector(`[data-idx="${idx2}"]`);

            if (node1) {
                node1.classList.add(`tp-node-${type1}`);
                const label1 = document.getElementById(`label${idx1}`);
                if (label1) {
                    label1.textContent = type1 === 'slow' ? '🐢' :
                        type1 === 'second' ? '2nd' :
                            type1 === 'compare' ? '✓' : type1;
                }
            }

            if (node2 && idx1 !== idx2) {
                node2.classList.add(`tp-node-${type2}`);
                const label2 = document.getElementById(`label${idx2}`);
                if (label2) {
                    label2.textContent = type2 === 'fast' ? '🐇' :
                        type2 === 'first' ? '1st' :
                            type2 === 'compare' ? '✓' : type2;
                }
            }
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

            document.getElementById('vizStart').disabled = false;
            document.getElementById('vizPause').disabled = true;
            document.getElementById('vizPause').innerHTML = '<span>⏸</span> Pause';
            document.getElementById('currentStep').textContent = '0';
            document.getElementById('explanation').textContent =
                'Choose a pattern and click Start!';

            this.list = [1, 2, 3, 4, 5];
            this.renderVisualization();
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
            new TwoPointerViz('twoPointerVisualization');
        });
    } else {
        new TwoPointerViz('twoPointerVisualization');
    }
})();
