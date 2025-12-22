/**
 * Doubly Linked List Visualization
 * Shows bidirectional links with next and prev pointers
 */

(function () {
    'use strict';

    class DoublyLinkedListViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.list = [];
            this.isRunning = false;
            this.speed = 1500;

            this.init();
        }

        init() {
            this.render();
            this.renderVisualization();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Doubly Linked List - Bidirectional Links</h3>
                    <p class="viz-subtitle">Each node has BOTH next and prev pointers</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Nodes</div>
                        <div class="viz-stat-value" id="nodeCount">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Operation</div>
                        <div class="viz-stat-value" id="operationInfo">Ready</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Advantage</div>
                        <div class="viz-stat-value">O(1) at both ends!</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Choose an operation to see bidirectional links in action!
                </div>
                
                <div class="viz-canvas">
                    <div class="dll-viz" id="dllViz"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Operations:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" id="insertHead">
                            <span class="viz-op-icon">⬅️</span>
                            <span class="viz-op-label">Insert at Head</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="insertTail">
                            <span class="viz-op-icon">➡️</span>
                            <span class="viz-op-label">Insert at Tail</span>
                            <span class="viz-op-complexity">O(1) ✓</span>
                        </button>
                        <button class="viz-op-btn" id="deleteHead">
                            <span class="viz-op-icon">🗑️</span>
                            <span class="viz-op-label">Delete Head</span>
                            <span class="viz-op-complexity">O(1)</span>
                        </button>
                        <button class="viz-op-btn" id="deleteTail">
                            <span class="viz-op-icon">🗑️</span>
                            <span class="viz-op-label">Delete Tail</span>
                            <span class="viz-op-complexity">O(1) ✓</span>
                        </button>
                        <button class="viz-op-btn" id="traverseForward">
                            <span class="viz-op-icon">→</span>
                            <span class="viz-op-label">Traverse Forward</span>
                            <span class="viz-op-complexity">Head to Tail</span>
                        </button>
                        <button class="viz-op-btn" id="traverseBackward">
                            <span class="viz-op-icon">←</span>
                            <span class="viz-op-label">Traverse Backward</span>
                            <span class="viz-op-complexity">Tail to Head</span>
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
                            <span id="speedValue">1500ms</span>
                        </div>
                        <input type="range" class="viz-slider" id="speedSlider" 
                               min="800" max="2500" value="1500" step="200">
                    </div>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.getElementById('insertHead').addEventListener('click', () => this.insertHead());
            document.getElementById('insertTail').addEventListener('click', () => this.insertTail());
            document.getElementById('deleteHead').addEventListener('click', () => this.deleteHead());
            document.getElementById('deleteTail').addEventListener('click', () => this.deleteTail());
            document.getElementById('traverseForward').addEventListener('click', () => this.traverseForward());
            document.getElementById('traverseBackward').addEventListener('click', () => this.traverseBackward());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });
        }

        renderVisualization() {
            const container = document.getElementById('dllViz');
            if (!container) return;

            container.innerHTML = '';

            if (this.list.length === 0) {
                container.innerHTML = '<div class="dll-empty">List is empty</div>';
                document.getElementById('nodeCount').textContent = '0';
                return;
            }

            const listDiv = document.createElement('div');
            listDiv.className = 'dll-list';

            // HEAD label
            const headLabel = document.createElement('div');
            headLabel.className = 'dll-label dll-head-label';
            headLabel.textContent = 'HEAD';
            listDiv.appendChild(headLabel);

            // Nodes
            this.list.forEach((val, idx) => {
                // Node container
                const nodeContainer = document.createElement('div');
                nodeContainer.className = 'dll-node-container';

                // Node
                const node = document.createElement('div');
                node.className = 'dll-node';
                node.dataset.idx = idx;
                node.innerHTML = `
                    <div class="dll-node-prev">prev</div>
                    <div class="dll-node-data">${val}</div>
                    <div class="dll-node-next">next</div>
                `;
                nodeContainer.appendChild(node);

                // Arrows
                if (idx < this.list.length - 1) {
                    const arrows = document.createElement('div');
                    arrows.className = 'dll-arrows';
                    arrows.innerHTML = `
                        <div class="dll-arrow-forward">→</div>
                        <div class="dll-arrow-backward">←</div>
                    `;
                    nodeContainer.appendChild(arrows);
                }

                listDiv.appendChild(nodeContainer);
            });

            // TAIL label
            const tailLabel = document.createElement('div');
            tailLabel.className = 'dll-label dll-tail-label';
            tailLabel.textContent = 'TAIL';
            listDiv.appendChild(tailLabel);

            // NULL indicators
            const nullDiv = document.createElement('div');
            nullDiv.className = 'dll-null-indicators';
            nullDiv.innerHTML = `
                <div class="dll-null-left">← null</div>
                <div class="dll-null-right">null →</div>
            `;
            container.appendChild(nullDiv);

            container.appendChild(listDiv);

            document.getElementById('nodeCount').textContent = this.list.length;
        }

        async insertHead() {
            if (this.isRunning) return;
            this.isRunning = true;

            const value = this.list.length > 0 ? this.list[0] - 10 : 10;

            document.getElementById('operationInfo').textContent = 'Insert Head';
            document.getElementById('explanation').textContent =
                `Inserting ${value} at HEAD - O(1) operation`;

            await this.sleep(this.speed * 0.3);

            this.list.unshift(value);
            this.renderVisualization();

            // Highlight new node
            const newNode = document.querySelector('[data-idx="0"]');
            if (newNode) {
                newNode.classList.add('dll-node-highlight');
                await this.sleep(this.speed);
                newNode.classList.remove('dll-node-highlight');
            }

            document.getElementById('explanation').textContent =
                `✅ Inserted ${value} at HEAD. Updated prev pointer of old head!`;

            this.isRunning = false;
        }

        async insertTail() {
            if (this.isRunning) return;
            this.isRunning = true;

            const value = this.list.length > 0 ? this.list[this.list.length - 1] + 10 : 10;

            document.getElementById('operationInfo').textContent = 'Insert Tail';
            document.getElementById('explanation').textContent =
                `Inserting ${value} at TAIL - O(1) with tail pointer!`;

            await this.sleep(this.speed * 0.3);

            this.list.push(value);
            this.renderVisualization();

            // Highlight new node
            const newNode = document.querySelector(`[data-idx="${this.list.length - 1}"]`);
            if (newNode) {
                newNode.classList.add('dll-node-highlight');
                await this.sleep(this.speed);
                newNode.classList.remove('dll-node-highlight');
            }

            document.getElementById('explanation').textContent =
                `✅ Inserted ${value} at TAIL in O(1)! Much better than singly linked list's O(n)!`;

            this.isRunning = false;
        }

        async deleteHead() {
            if (this.isRunning) return;
            if (this.list.length === 0) {
                document.getElementById('explanation').textContent = '✗ Cannot delete - list is empty!';
                return;
            }

            this.isRunning = true;

            const value = this.list[0];

            document.getElementById('operationInfo').textContent = 'Delete Head';
            document.getElementById('explanation').textContent =
                `Deleting HEAD (${value}) - O(1) operation`;

            // Highlight node to delete
            const node = document.querySelector('[data-idx="0"]');
            if (node) {
                node.classList.add('dll-node-delete');
                await this.sleep(this.speed);
            }

            this.list.shift();
            this.renderVisualization();

            document.getElementById('explanation').textContent =
                `✅ Deleted ${value} from HEAD. Updated prev pointer of new head to null!`;

            this.isRunning = false;
        }

        async deleteTail() {
            if (this.isRunning) return;
            if (this.list.length === 0) {
                document.getElementById('explanation').textContent = '✗ Cannot delete - list is empty!';
                return;
            }

            this.isRunning = true;

            const value = this.list[this.list.length - 1];

            document.getElementById('operationInfo').textContent = 'Delete Tail';
            document.getElementById('explanation').textContent =
                `Deleting TAIL (${value}) - O(1) with prev pointer!`;

            // Highlight node to delete
            const node = document.querySelector(`[data-idx="${this.list.length - 1}"]`);
            if (node) {
                node.classList.add('dll-node-delete');
                await this.sleep(this.speed);
            }

            this.list.pop();
            this.renderVisualization();

            document.getElementById('explanation').textContent =
                `✅ Deleted ${value} from TAIL in O(1)! Used prev pointer - impossible in singly linked list!`;

            this.isRunning = false;
        }

        async traverseForward() {
            if (this.isRunning) return;
            if (this.list.length === 0) return;

            this.isRunning = true;

            document.getElementById('operationInfo').textContent = 'Traverse →';
            document.getElementById('explanation').textContent =
                'Traversing forward: HEAD to TAIL using next pointers';

            for (let i = 0; i < this.list.length; i++) {
                const node = document.querySelector(`[data-idx="${i}"]`);
                if (node) {
                    node.classList.add('dll-node-traverse');
                    document.getElementById('explanation').textContent =
                        `At node ${this.list[i]} (index ${i})`;
                    await this.sleep(this.speed * 0.7);
                    node.classList.remove('dll-node-traverse');
                }
            }

            document.getElementById('explanation').textContent =
                '✅ Forward traversal complete!';

            this.isRunning = false;
        }

        async traverseBackward() {
            if (this.isRunning) return;
            if (this.list.length === 0) return;

            this.isRunning = true;

            document.getElementById('operationInfo').textContent = 'Traverse ←';
            document.getElementById('explanation').textContent =
                'Traversing backward: TAIL to HEAD using prev pointers';

            for (let i = this.list.length - 1; i >= 0; i--) {
                const node = document.querySelector(`[data-idx="${i}"]`);
                if (node) {
                    node.classList.add('dll-node-traverse');
                    document.getElementById('explanation').textContent =
                        `At node ${this.list[i]} (index ${i})`;
                    await this.sleep(this.speed * 0.7);
                    node.classList.remove('dll-node-traverse');
                }
            }

            document.getElementById('explanation').textContent =
                '✅ Backward traversal complete! Only possible with doubly linked list!';

            this.isRunning = false;
        }

        reset() {
            this.list = [10, 20, 30, 40];
            this.isRunning = false;
            document.getElementById('operationInfo').textContent = 'Ready';
            document.getElementById('explanation').textContent =
                'Choose an operation to see bidirectional links in action!';
            this.renderVisualization();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new DoublyLinkedListViz('doublyLinkedListVisualization');
        });
    } else {
        new DoublyLinkedListViz('doublyLinkedListVisualization');
    }
})();
