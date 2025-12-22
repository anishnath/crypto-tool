/**
 * Circular Linked List Visualization
 * Shows circular structure with last node pointing back to first
 */

(function () {
    'use strict';

    class CircularLinkedListViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.list = [10, 20, 30, 40];
            this.isRunning = false;
            this.speed = 1200;

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Circular Linked List - Last Points to First!</h3>
                    <p class="viz-subtitle">No null termination - forms a complete circle</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Nodes</div>
                        <div class="viz-stat-value" id="nodeCount">${this.list.length}</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Structure</div>
                        <div class="viz-stat-value">Circular ⭕</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Last Points To</div>
                        <div class="viz-stat-value">HEAD ↻</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose an operation to see the circular structure in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="cll-viz" id="cllViz"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Operations:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" id="insertNode">
                            <span class="viz-op-icon">➕</span>
                            <span class="viz-op-label">Insert Node</span>
                            <span class="viz-op-complexity">Add to circle</span>
                        </button>
                        <button class="viz-op-btn" id="deleteNode">
                            <span class="viz-op-icon">🗑️</span>
                            <span class="viz-op-label">Delete Node</span>
                            <span class="viz-op-complexity">Remove from circle</span>
                        </button>
                        <button class="viz-op-btn" id="traverseOnce">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Traverse Once</span>
                            <span class="viz-op-complexity">Go around circle</span>
                        </button>
                        <button class="viz-op-btn" id="traverseMultiple">
                            <span class="viz-op-icon">🔁</span>
                            <span class="viz-op-label">Traverse 3 Times</span>
                            <span class="viz-op-complexity">Keep going!</span>
                        </button>
                    </div>
                </div>
                
                <div class="viz-controls">
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
            document.getElementById('insertNode').addEventListener('click', () => this.insertNode());
            document.getElementById('deleteNode').addEventListener('click', () => this.deleteNode());
            document.getElementById('traverseOnce').addEventListener('click', () => this.traverse(1));
            document.getElementById('traverseMultiple').addEventListener('click', () => this.traverse(3));
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });
        }

        renderVisualization() {
            const container = document.getElementById('cllViz');
            if (!container) return;

            container.innerHTML = '';

            if (this.list.length === 0) {
                container.innerHTML = '<div class="cll-empty">List is empty</div>';
                document.getElementById('nodeCount').textContent = '0';
                return;
            }

            // Create circular layout
            const circleDiv = document.createElement('div');
            circleDiv.className = 'cll-circle';

            const radius = 150;
            const centerX = 200;
            const centerY = 200;
            const angleStep = (2 * Math.PI) / this.list.length;

            this.list.forEach((val, idx) => {
                const angle = idx * angleStep - Math.PI / 2; // Start from top
                const x = centerX + radius * Math.cos(angle);
                const y = centerY + radius * Math.sin(angle);

                // Node
                const node = document.createElement('div');
                node.className = 'cll-node';
                node.dataset.idx = idx;
                node.style.left = `${x}px`;
                node.style.top = `${y}px`;
                node.innerHTML = `<div class="cll-node-value">${val}</div>`;
                circleDiv.appendChild(node);

                // Arrow to next (including last to first!)
                const nextIdx = (idx + 1) % this.list.length;
                const nextAngle = nextIdx * angleStep - Math.PI / 2;
                const nextX = centerX + radius * Math.cos(nextAngle);
                const nextY = centerY + radius * Math.sin(nextAngle);

                const arrow = document.createElement('div');
                arrow.className = 'cll-arrow';
                arrow.dataset.from = idx;
                arrow.dataset.to = nextIdx;

                // Calculate arrow position and rotation
                const midX = (x + nextX) / 2;
                const midY = (y + nextY) / 2;
                const dx = nextX - x;
                const dy = nextY - y;
                const rotation = Math.atan2(dy, dx) * 180 / Math.PI;

                arrow.style.left = `${midX}px`;
                arrow.style.top = `${midY}px`;
                arrow.style.transform = `translate(-50%, -50%) rotate(${rotation}deg)`;

                // Special styling for last-to-first arrow
                if (idx === this.list.length - 1) {
                    arrow.classList.add('cll-arrow-circular');
                }

                circleDiv.appendChild(arrow);
            });

            // HEAD label
            const headLabel = document.createElement('div');
            headLabel.className = 'cll-head-label';
            headLabel.textContent = 'HEAD';
            headLabel.style.left = `${centerX}px`;
            headLabel.style.top = `${centerY - radius - 40}px`;
            circleDiv.appendChild(headLabel);

            // Center text
            const centerText = document.createElement('div');
            centerText.className = 'cll-center-text';
            centerText.innerHTML = `
                <div class="cll-center-icon">⭕</div>
                <div class="cll-center-label">Circular</div>
            `;
            centerText.style.left = `${centerX}px`;
            centerText.style.top = `${centerY}px`;
            circleDiv.appendChild(centerText);

            container.appendChild(circleDiv);

            document.getElementById('nodeCount').textContent = this.list.length;
        }

        async insertNode() {
            if (this.isRunning) return;
            this.isRunning = true;

            const value = this.list.length > 0 ? this.list[this.list.length - 1] + 10 : 10;

            document.getElementById('explanation').textContent =
                `Inserting ${value} into circular list...`;

            await this.sleep(this.speed * 0.3);

            this.list.push(value);
            this.renderVisualization();

            // Highlight new node
            const newNode = document.querySelector(`[data-idx="${this.list.length - 1}"]`);
            if (newNode) {
                newNode.classList.add('cll-node-highlight');
                await this.sleep(this.speed);
                newNode.classList.remove('cll-node-highlight');
            }

            // Highlight circular arrow
            const circularArrow = document.querySelector('.cll-arrow-circular');
            if (circularArrow) {
                circularArrow.classList.add('cll-arrow-highlight');
                await this.sleep(this.speed);
                circularArrow.classList.remove('cll-arrow-highlight');
            }

            document.getElementById('explanation').textContent =
                `✅ Inserted ${value}. Last node now points back to HEAD!`;

            this.isRunning = false;
        }

        async deleteNode() {
            if (this.isRunning) return;
            if (this.list.length === 0) {
                document.getElementById('explanation').textContent = '✗ Cannot delete - list is empty!';
                return;
            }

            this.isRunning = true;

            const value = this.list[this.list.length - 1];

            document.getElementById('explanation').textContent =
                `Deleting ${value} from circular list...`;

            // Highlight node to delete
            const node = document.querySelector(`[data-idx="${this.list.length - 1}"]`);
            if (node) {
                node.classList.add('cll-node-delete');
                await this.sleep(this.speed);
            }

            this.list.pop();
            this.renderVisualization();

            document.getElementById('explanation').textContent =
                `✅ Deleted ${value}. Circle updated!`;

            this.isRunning = false;
        }

        async traverse(times) {
            if (this.isRunning) return;
            if (this.list.length === 0) return;

            this.isRunning = true;

            document.getElementById('explanation').textContent =
                `Traversing circle ${times} time(s)...`;

            const totalSteps = this.list.length * times;

            for (let i = 0; i < totalSteps; i++) {
                const idx = i % this.list.length;
                const node = document.querySelector(`[data-idx="${idx}"]`);

                if (node) {
                    node.classList.add('cll-node-traverse');

                    const circleNum = Math.floor(i / this.list.length) + 1;
                    const posInCircle = (i % this.list.length) + 1;

                    document.getElementById('explanation').textContent =
                        `Circle ${circleNum}, Node ${posInCircle}: ${this.list[idx]}`;

                    await this.sleep(this.speed * 0.7);
                    node.classList.remove('cll-node-traverse');
                }

                // Highlight arrow
                const arrow = document.querySelector(`[data-from="${idx}"]`);
                if (arrow) {
                    arrow.classList.add('cll-arrow-active');
                    await this.sleep(this.speed * 0.3);
                    arrow.classList.remove('cll-arrow-active');
                }
            }

            document.getElementById('explanation').textContent =
                `✅ Completed ${times} circle(s)! This is the power of circular lists!`;

            this.isRunning = false;
        }

        reset() {
            this.list = [10, 20, 30, 40];
            this.isRunning = false;
            document.getElementById('explanation').textContent =
                'Choose an operation to see the circular structure in action!';
            this.renderVisualization();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new CircularLinkedListViz('circularLinkedListVisualization');
        });
    } else {
        new CircularLinkedListViz('circularLinkedListVisualization');
    }
})();
