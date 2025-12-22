/**
 * Singly Linked List Visualization - CLEAR Layout
 * HEAD points to first node, TAIL points to last node
 */

(function () {
    'use strict';

    class LinkedListViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.list = [];
            this.isRunning = false;
            this.speed = 1200;

            this.init();
        }

        init() {
            this.render();
            this.list = [10, 20, 30];
            this.renderList();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Interactive Linked List Demo</h3>
                    <p class="viz-subtitle">HEAD points to first node, TAIL points to last node</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Current Operation</div>
                        <div class="viz-stat-value" id="currentOp">Ready</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">List Size</div>
                        <div class="viz-stat-value" id="listSize">3</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Time Complexity</div>
                        <div class="viz-stat-value" id="complexity">-</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Click an operation below to see how it works!
                </div>
                
                <div class="viz-canvas">
                    <div class="viz-linked-list" id="linkedList"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Try These Operations:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn viz-op-insert-head" data-op="insert-head">
                            <span class="viz-op-icon">⬅️</span>
                            <span class="viz-op-label">Insert at HEAD</span>
                            <span class="viz-op-complexity">O(1) - Fast!</span>
                        </button>
                        <button class="viz-op-btn viz-op-insert-tail" data-op="insert-tail">
                            <span class="viz-op-icon">➡️</span>
                            <span class="viz-op-label">Insert at TAIL</span>
                            <span class="viz-op-complexity">O(n) - Must traverse</span>
                        </button>
                        <button class="viz-op-btn viz-op-delete" data-op="delete-head">
                            <span class="viz-op-icon">❌</span>
                            <span class="viz-op-label">Delete HEAD</span>
                            <span class="viz-op-complexity">O(1) - Fast!</span>
                        </button>
                        <button class="viz-op-btn viz-op-search" data-op="search">
                            <span class="viz-op-icon">🔍</span>
                            <span class="viz-op-label">Search Value</span>
                            <span class="viz-op-complexity">O(n) - Check all</span>
                        </button>
                        <button class="viz-op-btn viz-op-btn-reset" data-op="reset">
                            <span class="viz-op-icon">🔄</span>
                            <span class="viz-op-label">Reset List</span>
                        </button>
                    </div>
                </div>
                
                <div class="viz-controls">
                    <div class="viz-slider-group">
                        <div class="viz-slider-label">
                            <span>Animation Speed</span>
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
            document.querySelectorAll('.viz-op-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const op = e.currentTarget.dataset.op;
                    if (!this.isRunning) {
                        this.executeOperation(op);
                    }
                });
            });

            document.getElementById('speedSlider').addEventListener('input', (e) => {
                this.speed = parseInt(e.target.value);
                document.getElementById('speedValue').textContent = `${this.speed}ms`;
            });
        }

        async executeOperation(op) {
            if (this.isRunning) return;

            this.isRunning = true;
            this.disableButtons();

            switch (op) {
                case 'insert-head':
                    await this.animateInsertHead();
                    break;
                case 'insert-tail':
                    await this.animateInsertTail();
                    break;
                case 'delete-head':
                    await this.animateDeleteHead();
                    break;
                case 'search':
                    await this.animateSearch();
                    break;
                case 'reset':
                    this.reset();
                    break;
            }

            this.isRunning = false;
            this.enableButtons();
        }

        async animateInsertHead() {
            const newValue = Math.floor(Math.random() * 90) + 10;

            this.updateStatus('Insert at HEAD', `Inserting ${newValue} at HEAD`, 'O(1)');

            await this.showStep(`Step 1: Create new node with value ${newValue}`);
            this.renderList({ newNode: newValue, newNodePos: 'above' });
            await this.sleep(this.speed);

            await this.showStep(`Step 2: Point new node to current HEAD`);
            this.renderList({ newNode: newValue, newNodePos: 'pointing' });
            await this.sleep(this.speed);

            await this.showStep(`Step 3: Update HEAD to point to new node`);
            this.list.unshift(newValue);
            this.renderList({ highlight: 0, state: 'inserted' });
            await this.sleep(this.speed);

            await this.showStep(`✅ Done! ${newValue} is now the HEAD`);
            this.renderList();
            this.updateSize();
        }

        async animateInsertTail() {
            const newValue = Math.floor(Math.random() * 90) + 10;

            this.updateStatus('Insert at TAIL', `Inserting ${newValue} at TAIL`, 'O(n)');

            await this.showStep(`Step 1: Create new node with value ${newValue}`);
            this.renderList({ newNode: newValue, newNodePos: 'above' });
            await this.sleep(this.speed);

            await this.showStep(`Step 2: Traverse from HEAD to find TAIL`);
            for (let i = 0; i < this.list.length; i++) {
                this.renderList({ highlight: i, state: 'traversing', newNode: newValue, newNodePos: 'above' });
                await this.sleep(this.speed * 0.6);
            }

            await this.showStep(`Step 3: Link current TAIL to new node`);
            this.list.push(newValue);
            this.renderList({ highlight: this.list.length - 1, state: 'inserted' });
            await this.sleep(this.speed);

            await this.showStep(`✅ Done! ${newValue} is now the TAIL`);
            this.renderList();
            this.updateSize();
        }

        async animateDeleteHead() {
            if (this.list.length === 0) {
                await this.showStep('❌ Cannot delete from empty list!');
                return;
            }

            const deletedValue = this.list[0];
            this.updateStatus('Delete HEAD', `Deleting HEAD (${deletedValue})`, 'O(1)');

            await this.showStep(`Step 1: Current HEAD is ${deletedValue}`);
            this.renderList({ highlight: 0, state: 'deleting' });
            await this.sleep(this.speed);

            await this.showStep(`Step 2: Move HEAD to next node`);
            this.list.shift();
            this.renderList({ highlight: 0, state: 'new-head' });
            await this.sleep(this.speed);

            await this.showStep(`✅ Done! Deleted ${deletedValue}`);
            this.renderList();
            this.updateSize();
        }

        async animateSearch() {
            if (this.list.length === 0) {
                await this.showStep('❌ List is empty!');
                return;
            }

            const searchValue = this.list[Math.floor(Math.random() * this.list.length)];
            this.updateStatus('Search', `Searching for ${searchValue}`, 'O(n)');

            await this.showStep(`Searching for ${searchValue} starting from HEAD...`);

            for (let i = 0; i < this.list.length; i++) {
                await this.showStep(`Checking node ${i}: value = ${this.list[i]}`);
                this.renderList({ highlight: i, state: 'searching' });
                await this.sleep(this.speed * 0.8);

                if (this.list[i] === searchValue) {
                    await this.showStep(`✅ Found ${searchValue} at position ${i}!`);
                    this.renderList({ highlight: i, state: 'found' });
                    await this.sleep(this.speed);
                    break;
                }
            }

            this.renderList();
        }

        renderList(options = {}) {
            const { highlight = null, state = 'normal', newNode = null, newNodePos = null } = options;
            const container = document.getElementById('linkedList');
            if (!container) return;

            container.innerHTML = '';

            // New node floating above
            if (newNode !== null && newNodePos === 'above') {
                const newNodeDiv = document.createElement('div');
                newNodeDiv.className = 'll-new-node-floating';
                newNodeDiv.innerHTML = `
                    <div class="ll-new-label">NEW NODE</div>
                    <div class="ll-node ll-node-new">
                        <div class="ll-data">${newNode}</div>
                        <div class="ll-next">→</div>
                    </div>
                `;
                container.appendChild(newNodeDiv);
            }

            // Main list row
            const mainRow = document.createElement('div');
            mainRow.className = 'll-main-row';

            // HEAD pointer column
            const headCol = document.createElement('div');
            headCol.className = 'll-pointer-col';
            headCol.innerHTML = `
                <div class="ll-pointer-box ll-head-box">
                    <div class="ll-pointer-label">HEAD</div>
                    <div class="ll-pointer-arrow">↓</div>
                </div>
            `;
            mainRow.appendChild(headCol);

            // Nodes
            this.list.forEach((value, idx) => {
                const nodeCol = document.createElement('div');
                nodeCol.className = 'll-node-col';

                let nodeClass = 'll-node';
                if (idx === 0) nodeClass += ' ll-is-head';
                if (idx === this.list.length - 1) nodeClass += ' ll-is-tail';

                if (idx === highlight) {
                    if (state === 'deleting') nodeClass += ' ll-node-deleting';
                    else if (state === 'searching') nodeClass += ' ll-node-searching';
                    else if (state === 'found') nodeClass += ' ll-node-found';
                    else if (state === 'inserted') nodeClass += ' ll-node-inserted';
                    else if (state === 'traversing') nodeClass += ' ll-node-traversing';
                    else if (state === 'new-head') nodeClass += ' ll-node-new-head';
                }

                nodeCol.innerHTML = `
                    <div class="${nodeClass}">
                        <div class="ll-data">${value}</div>
                        <div class="ll-next">→</div>
                    </div>
                    ${idx < this.list.length - 1 ? '<div class="ll-connector">next</div>' : ''}
                `;

                mainRow.appendChild(nodeCol);
            });

            // NULL
            const nullCol = document.createElement('div');
            nullCol.className = 'll-node-col';
            nullCol.innerHTML = `
                <div class="ll-null">null</div>
            `;
            mainRow.appendChild(nullCol);

            // TAIL pointer column
            if (this.list.length > 0) {
                const tailCol = document.createElement('div');
                tailCol.className = 'll-pointer-col';
                tailCol.innerHTML = `
                    <div class="ll-pointer-box ll-tail-box">
                        <div class="ll-pointer-arrow">↑</div>
                        <div class="ll-pointer-label">TAIL</div>
                    </div>
                `;
                mainRow.appendChild(tailCol);
            }

            container.appendChild(mainRow);
        }

        updateStatus(op, desc, complexity) {
            document.getElementById('currentOp').textContent = op;
            document.getElementById('complexity').textContent = complexity;
        }

        async showStep(message) {
            document.getElementById('explanation').textContent = message;
        }

        updateSize() {
            document.getElementById('listSize').textContent = this.list.length;
        }

        reset() {
            this.list = [10, 20, 30];
            this.renderList();
            this.updateSize();
            this.updateStatus('Ready', '', '-');
            this.showStep('List reset! HEAD points to first node (10), TAIL points to last node (30)');
        }

        disableButtons() {
            document.querySelectorAll('.viz-op-btn').forEach(btn => {
                if (btn.dataset.op !== 'reset') btn.disabled = true;
            });
        }

        enableButtons() {
            document.querySelectorAll('.viz-op-btn').forEach(btn => {
                btn.disabled = false;
            });
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new LinkedListViz('linkedListVisualization');
        });
    } else {
        new LinkedListViz('linkedListVisualization');
    }
})();
