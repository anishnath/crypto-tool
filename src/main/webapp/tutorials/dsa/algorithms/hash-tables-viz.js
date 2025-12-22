/**
 * Hash Tables Visualization
 * Shows hash function and collision resolution
 */

(function () {
    'use strict';

    class HashTableViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.tableSize = 7;
            this.table = new Array(this.tableSize).fill(null).map(() => []);
            this.isRunning = false;
            this.speed = 1200;

            this.init();
        }

        init() {
            this.render();
            this.renderTable();
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Hash Table with Chaining</h3>
                    <p class="viz-subtitle">See hash function and collision resolution in action</p>
                </div>

                <div class="viz-stats">
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Table Size</div>
                        <div class="viz-stat-value">${this.tableSize}</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Items</div>
                        <div class="viz-stat-value" id="itemCount">0</div>
                    </div>
                    <div class="viz-stat-card">
                        <div class="viz-stat-label">Load Factor</div>
                        <div class="viz-stat-value" id="loadFactor">0.00</div>
                    </div>
                </div>
                
                <div class="viz-explanation" id="explanation">
                    Click operations to see how hash tables work!
                </div>
                
                <div class="viz-canvas">
                    <div class="hash-table-display" id="hashTableDisplay"></div>
                </div>
                
                <div class="viz-operations">
                    <h4>Operations:</h4>
                    <div class="viz-op-grid">
                        <button class="viz-op-btn" id="insertBtn">
                            <span class="viz-op-icon">➕</span>
                            <span class="viz-op-label">Insert</span>
                            <span class="viz-op-complexity">O(1) avg</span>
                        </button>
                        <button class="viz-op-btn" id="searchBtn">
                            <span class="viz-op-icon">🔍</span>
                            <span class="viz-op-label">Search</span>
                            <span class="viz-op-complexity">O(1) avg</span>
                        </button>
                        <button class="viz-op-btn" id="deleteBtn">
                            <span class="viz-op-icon">➖</span>
                            <span class="viz-op-label">Delete</span>
                            <span class="viz-op-complexity">O(1) avg</span>
                        </button>
                        <button class="viz-op-btn viz-op-btn-primary" id="demoBtn">
                            <span class="viz-op-icon">▶️</span>
                            <span class="viz-op-label">Run Demo</span>
                        </button>
                    </div>
                </div>
                
                <div class="viz-controls">
                    <button class="viz-btn" id="vizReset">
                        <span>🔄</span> Reset
                    </button>
                </div>
            `;

            this.bindEvents();
        }

        bindEvents() {
            document.getElementById('insertBtn').addEventListener('click', () => this.insert());
            document.getElementById('searchBtn').addEventListener('click', () => this.search());
            document.getElementById('deleteBtn').addEventListener('click', () => this.delete());
            document.getElementById('demoBtn').addEventListener('click', () => this.runDemo());
            document.getElementById('vizReset').addEventListener('click', () => this.reset());
        }

        hash(key) {
            let hash = 0;
            for (let i = 0; i < key.length; i++) {
                hash = (hash * 31 + key.charCodeAt(i)) % this.tableSize;
            }
            return hash;
        }

        renderTable() {
            const display = document.getElementById('hashTableDisplay');
            if (!display) return;

            let html = '';
            for (let i = 0; i < this.tableSize; i++) {
                const chain = this.table[i];
                html += `
                    <div class="hash-slot" data-idx="${i}">
                        <div class="hash-slot-index">[${i}]</div>
                        <div class="hash-slot-chain">
                            ${chain.length === 0 ? '<div class="hash-empty">Empty</div>' :
                        chain.map(item => `<div class="hash-item">${item}</div>`).join(' → ')}
                        </div>
                    </div>
                `;
            }
            display.innerHTML = html;

            this.updateStats();
        }

        updateStats() {
            const count = this.table.reduce((sum, chain) => sum + chain.length, 0);
            const loadFactor = (count / this.tableSize).toFixed(2);

            document.getElementById('itemCount').textContent = count;
            document.getElementById('loadFactor').textContent = loadFactor;
        }

        async insert() {
            if (this.isRunning) return;
            this.isRunning = true;

            const keys = ['apple', 'banana', 'cherry', 'date', 'elderberry'];
            const key = keys[Math.floor(Math.random() * keys.length)];
            const index = this.hash(key);

            document.getElementById('explanation').textContent =
                `Inserting "${key}" → hash(${key}) = ${index}`;

            await this.sleep(this.speed * 0.5);

            this.table[index].push(key);
            this.renderTable();
            this.highlightSlot(index);

            document.getElementById('explanation').textContent =
                `✅ Inserted "${key}" at index ${index}${this.table[index].length > 1 ? ' (collision resolved by chaining!)' : ''}`;

            this.isRunning = false;
        }

        async search() {
            if (this.isRunning) return;
            const count = this.table.reduce((sum, chain) => sum + chain.length, 0);
            if (count === 0) {
                document.getElementById('explanation').textContent = 'Table is empty!';
                return;
            }

            this.isRunning = true;

            // Find a random existing key
            let key;
            for (const chain of this.table) {
                if (chain.length > 0) {
                    key = chain[Math.floor(Math.random() * chain.length)];
                    break;
                }
            }

            const index = this.hash(key);

            document.getElementById('explanation').textContent =
                `Searching for "${key}" → hash(${key}) = ${index}`;

            this.highlightSlot(index);
            await this.sleep(this.speed);

            document.getElementById('explanation').textContent =
                `✅ Found "${key}" at index ${index}!`;

            this.isRunning = false;
        }

        async delete() {
            if (this.isRunning) return;
            const count = this.table.reduce((sum, chain) => sum + chain.length, 0);
            if (count === 0) {
                document.getElementById('explanation').textContent = 'Table is empty!';
                return;
            }

            this.isRunning = true;

            // Find and delete a random key
            let key, index;
            for (let i = 0; i < this.tableSize; i++) {
                if (this.table[i].length > 0) {
                    index = i;
                    key = this.table[i][0];
                    break;
                }
            }

            document.getElementById('explanation').textContent =
                `Deleting "${key}" from index ${index}`;

            this.highlightSlot(index);
            await this.sleep(this.speed);

            this.table[index].shift();
            this.renderTable();

            document.getElementById('explanation').textContent =
                `✅ Deleted "${key}"!`;

            this.isRunning = false;
        }

        async runDemo() {
            if (this.isRunning) return;
            this.isRunning = true;

            this.reset();
            await this.sleep(this.speed * 0.5);

            const keys = ['apple', 'banana', 'cherry', 'date'];

            for (const key of keys) {
                const index = this.hash(key);
                document.getElementById('explanation').textContent =
                    `Inserting "${key}" → hash = ${index}`;

                await this.sleep(this.speed);

                this.table[index].push(key);
                this.renderTable();
                this.highlightSlot(index);
                await this.sleep(this.speed);
            }

            document.getElementById('explanation').textContent =
                '✅ Demo complete! Notice how collisions are handled by chaining.';

            this.isRunning = false;
        }

        highlightSlot(index) {
            const slot = document.querySelector(`[data-idx="${index}"]`);
            if (slot) {
                slot.classList.add('hash-slot-highlight');
                setTimeout(() => slot.classList.remove('hash-slot-highlight'), this.speed);
            }
        }

        reset() {
            this.table = new Array(this.tableSize).fill(null).map(() => []);
            this.isRunning = false;
            document.getElementById('explanation').textContent =
                'Click operations to see how hash tables work!';
            this.renderTable();
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new HashTableViz('hashTableVisualization');
        });
    } else {
        new HashTableViz('hashTableVisualization');
    }
})();
