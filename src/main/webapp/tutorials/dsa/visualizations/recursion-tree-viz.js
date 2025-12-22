/**
 * Recursion Tree Visualization
 * Shows how recursive algorithms break down problems
 * Clean, centered layout with color-coded levels
 */

(function () {
    'use strict';

    class RecursionTreeViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentStep = 0;
            this.maxSteps = 0;
            this.isPlaying = false;
            this.speed = 800;
            this.nodes = [];

            // Level colors for visual distinction
            this.levelColors = [
                '#3b82f6', // Level 0 - Blue
                '#8b5cf6', // Level 1 - Purple
                '#ec4899', // Level 2 - Pink
                '#f59e0b'  // Level 3 - Amber
            ];

            this.init();
        }

        init() {
            this.render();
            this.buildNodesList();
            this.bindEvents();
            setTimeout(() => this.togglePlay(), 1000);
        }

        render() {
            this.container.innerHTML = `
                <div class="recursion-viz">
                    <div class="recursion-header">
                        <h3>Recursion Tree: Merge Sort</h3>
                        <p class="recursion-formula">T(n) = 2T(n/2) + n</p>
                    </div>

                    <div class="recursion-canvas-container">
                        <canvas id="recursionCanvas" width="800" height="500"></canvas>
<!--                        <div class="bigo-watermark">8gwifi.org/tutorials</div>-->
                    </div>

                    <div class="recursion-controls">
                        <button class="viz-btn viz-btn-primary" id="recPlay">
                            <span>⏸</span> Pause
                        </button>
                        <button class="viz-btn" id="recReset">
                            <span>🔄</span> Reset
                        </button>
                        <div class="viz-slider-group">
                            <div class="viz-slider-label">
                                <span>Step</span>
                                <span id="recStepValue">0 / 0</span>
                            </div>
                            <input type="range" class="viz-slider" id="recSlider" 
                                   min="0" max="10" value="0" step="1">
                        </div>
                    </div>

                    <div class="recursion-explanation" id="recExplanation"></div>
                </div>
            `;

            this.canvas = document.getElementById('recursionCanvas');
            this.ctx = this.canvas.getContext('2d');
        }

        buildNodesList() {
            this.nodes = [];

            // Build tree structure with proper positioning
            // Level 0: 1 node at center
            this.addNode(0, 400, 60, 'n', 'n');

            // Level 1: 2 nodes
            this.addNode(1, 250, 160, 'n/2', 'n/2', 0);
            this.addNode(1, 550, 160, 'n/2', 'n/2', 0);

            // Level 2: 4 nodes
            this.addNode(2, 175, 260, 'n/4', 'n/4', 1);
            this.addNode(2, 325, 260, 'n/4', 'n/4', 1);
            this.addNode(2, 475, 260, 'n/4', 'n/4', 2);
            this.addNode(2, 625, 260, 'n/4', 'n/4', 2);

            // Level 3: 8 nodes
            this.addNode(3, 125, 360, 'n/8', 'n/8', 3);
            this.addNode(3, 225, 360, 'n/8', 'n/8', 3);
            this.addNode(3, 275, 360, 'n/8', 'n/8', 4);
            this.addNode(3, 375, 360, 'n/8', 'n/8', 4);
            this.addNode(3, 425, 360, 'n/8', 'n/8', 5);
            this.addNode(3, 525, 360, 'n/8', 'n/8', 5);
            this.addNode(3, 575, 360, 'n/8', 'n/8', 6);
            this.addNode(3, 675, 360, 'n/8', 'n/8', 6);

            this.maxSteps = this.nodes.length;
            document.getElementById('recSlider').max = this.maxSteps;
            this.updateDisplay();
        }

        addNode(level, x, y, size, work, parentIndex = null) {
            const node = {
                level,
                x,
                y,
                size,
                work,
                parentIndex,
                index: this.nodes.length
            };
            this.nodes.push(node);
        }

        bindEvents() {
            document.getElementById('recPlay').addEventListener('click', () => this.togglePlay());
            document.getElementById('recReset').addEventListener('click', () => this.reset());
            document.getElementById('recSlider').addEventListener('input', (e) => {
                this.currentStep = parseInt(e.target.value);
                this.updateDisplay();
            });
        }

        togglePlay() {
            this.isPlaying = !this.isPlaying;
            const btn = document.getElementById('recPlay');

            if (this.isPlaying) {
                btn.innerHTML = '<span>⏸</span> Pause';
                this.animate();
            } else {
                btn.innerHTML = '<span>▶️</span> Play';
            }
        }

        async animate() {
            while (this.isPlaying && this.currentStep < this.maxSteps) {
                this.currentStep++;
                document.getElementById('recSlider').value = this.currentStep;
                this.updateDisplay();
                await this.sleep(this.speed);
            }

            if (this.currentStep >= this.maxSteps) {
                this.isPlaying = false;
                document.getElementById('recPlay').innerHTML = '<span>▶️</span> Play';
            }
        }

        reset() {
            this.isPlaying = false;
            this.currentStep = 0;
            document.getElementById('recSlider').value = 0;
            document.getElementById('recPlay').innerHTML = '<span>▶️</span> Play';
            this.updateDisplay();
        }

        updateDisplay() {
            document.getElementById('recStepValue').textContent = `${this.currentStep} / ${this.maxSteps}`;
            this.drawTree();
            this.updateExplanation();
        }

        drawTree() {
            const ctx = this.ctx;
            const width = this.canvas.width;
            const height = this.canvas.height;

            // Clear with dark background
            ctx.clearRect(0, 0, width, height);
            ctx.fillStyle = '#1a1a1a';
            ctx.fillRect(0, 0, width, height);

            // Draw lines first (behind nodes)
            for (let i = 0; i < Math.min(this.currentStep, this.nodes.length); i++) {
                const node = this.nodes[i];
                if (node.parentIndex !== null && node.parentIndex < this.currentStep) {
                    this.drawLine(this.nodes[node.parentIndex], node);
                }
            }

            // Draw nodes on top
            for (let i = 0; i < Math.min(this.currentStep, this.nodes.length); i++) {
                this.drawNode(this.nodes[i]);
            }
        }

        drawLine(parent, child) {
            const ctx = this.ctx;
            ctx.strokeStyle = '#444';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(parent.x, parent.y + 25);
            ctx.lineTo(child.x, child.y - 25);
            ctx.stroke();
        }

        drawNode(node) {
            const ctx = this.ctx;
            const color = this.levelColors[node.level];

            // Node circle
            ctx.fillStyle = color;
            ctx.beginPath();
            ctx.arc(node.x, node.y, 25, 0, Math.PI * 2);
            ctx.fill();

            // Node border
            ctx.strokeStyle = this.lightenColor(color);
            ctx.lineWidth = 2;
            ctx.stroke();

            // Node label (size)
            ctx.fillStyle = '#fff';
            ctx.font = 'bold 12px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            ctx.fillText(node.size, node.x, node.y);

            // Work label below
            ctx.fillStyle = '#888';
            ctx.font = '11px Inter, sans-serif';
            ctx.fillText(`work: ${node.work}`, node.x, node.y + 45);
        }

        lightenColor(color) {
            // Simple color lightening
            const colors = {
                '#3b82f6': '#60a5fa',
                '#8b5cf6': '#a78bfa',
                '#ec4899': '#f472b6',
                '#f59e0b': '#fbbf24'
            };
            return colors[color] || color;
        }

        updateExplanation() {
            if (this.currentStep === 0) {
                document.getElementById('recExplanation').innerHTML = `
                    <div class="explanation-content">
                        <h4>Ready to Start</h4>
                        <p>Watch how merge sort breaks down an array of size <strong>n</strong> into smaller pieces.</p>
                        <p>Each level is color-coded for clarity.</p>
                    </div>
                `;
                return;
            }

            const currentNode = this.nodes[Math.min(this.currentStep - 1, this.nodes.length - 1)];
            const level = currentNode.level;
            const nodesAtLevel = Math.pow(2, level);

            const explanation = document.getElementById('recExplanation');
            explanation.innerHTML = `
                <div class="explanation-content">
                    <h4>Level ${level} - Breaking Down the Problem</h4>
                    <ul>
                        <li><strong>Nodes at this level:</strong> ${nodesAtLevel}</li>
                        <li><strong>Size of each subproblem:</strong> ${currentNode.size}</li>
                        <li><strong>Work per node:</strong> ${currentNode.work}</li>
                        <li><strong>Total work at this level:</strong> n</li>
                    </ul>
                    <p class="explanation-insight">
                        💡 Each level does <strong>O(n)</strong> total work. 
                        With <strong>log n</strong> levels (${level + 1} so far), the total is <strong>O(n log n)</strong>
                    </p>
                </div>
            `;
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new RecursionTreeViz('recursionTreeViz');
        });
    } else {
        new RecursionTreeViz('recursionTreeViz');
    }
})();
