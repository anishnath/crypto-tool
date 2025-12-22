/**
 * Compact Array Visualization
 * Simple, focused demonstration of array operations
 */

(function () {
    'use strict';

    class ArrayViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [10, 20, 30, 40, 50, 60];
            this.highlightIndex = -1;

            this.init();
        }

        init() {
            this.render();
            this.bindEvents();
        }

        render() {
            this.container.innerHTML = `
                <div class="array-viz-compact">
                    <div class="array-viz-header">
                        <h4>Array Operations</h4>
                        <p class="array-viz-desc">Click any box for O(1) access</p>
                    </div>
                    
                    <div class="array-container" id="arrayContainer"></div>
                    
                    <div class="array-controls">
                        <button class="viz-btn" id="btnInsert">Insert at Index 2</button>
                        <button class="viz-btn" id="btnReset">Reset</button>
                    </div>
                    
                    <div class="array-complexity" id="complexity">
                        Click an element to see O(1) access
                    </div>
                </div>
            `;

            this.renderArray();
        }

        renderArray() {
            const container = document.getElementById('arrayContainer');
            container.innerHTML = '';

            this.array.forEach((value, index) => {
                const box = document.createElement('div');
                box.className = 'array-box';
                if (index === this.highlightIndex) {
                    box.classList.add('highlight');
                }

                box.innerHTML = `
                    <div class="array-index">i=${index}</div>
                    <div class="array-value">${value}</div>
                `;

                box.addEventListener('click', () => this.accessElement(index));
                container.appendChild(box);
            });
        }

        bindEvents() {
            document.getElementById('btnInsert').addEventListener('click', () => this.insertElement());
            document.getElementById('btnReset').addEventListener('click', () => this.reset());
        }

        accessElement(index) {
            this.highlightIndex = index;
            this.renderArray();

            const complexity = document.getElementById('complexity');
            complexity.innerHTML = `
                ✅ <strong>O(1) Access:</strong> array[${index}] = ${this.array[index]} (instant!)
            `;
            complexity.style.color = '#10b981';
        }

        async insertElement() {
            if (this.array.length >= 10) {
                alert('Array is full for this demo');
                return;
            }

            const complexity = document.getElementById('complexity');
            complexity.innerHTML = `
                ⏳ <strong>O(n) Insert:</strong> Inserting 99 at index 2, shifting elements...
            `;
            complexity.style.color = '#f59e0b';

            // Highlight elements that will shift
            await this.sleep(500);

            // Insert
            this.array.splice(2, 0, 99);
            this.highlightIndex = 2;
            this.renderArray();

            await this.sleep(500);
            complexity.innerHTML = `
                ❌ <strong>O(n) Insert:</strong> Had to shift ${this.array.length - 3} elements
            `;
            complexity.style.color = '#ef4444';
        }

        reset() {
            this.array = [10, 20, 30, 40, 50, 60];
            this.highlightIndex = -1;
            this.renderArray();

            const complexity = document.getElementById('complexity');
            complexity.innerHTML = 'Click an element to see O(1) access';
            complexity.style.color = '#888';
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new ArrayViz('arrayVizCompact');
        });
    } else {
        new ArrayViz('arrayVizCompact');
    }
})();
