/**
 * Compact Two Pointers Visualization
 * Shows how two pointers work for Two Sum problem
 */

(function () {
    'use strict';

    class TwoPointersViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.array = [1, 2, 3, 4, 6, 8, 9];
            this.target = 10;
            this.left = 0;
            this.right = this.array.length - 1;
            this.step = 0;
            this.steps = [];
            this.isPlaying = false;

            this.init();
        }

        init() {
            this.generateSteps();
            this.render();
            this.bindEvents();
        }

        generateSteps() {
            let l = 0, r = this.array.length - 1;

            while (l < r) {
                const sum = this.array[l] + this.array[r];
                this.steps.push({
                    left: l,
                    right: r,
                    sum: sum,
                    message: sum === this.target ? `Found! ${this.array[l]} + ${this.array[r]} = ${this.target}` :
                        sum < this.target ? `${sum} < ${this.target}, move left →` :
                            `${sum} > ${this.target}, move right ←`
                });

                if (sum === this.target) break;
                if (sum < this.target) l++;
                else r--;
            }
        }

        render() {
            this.container.innerHTML = `
                <div class="two-pointers-viz">
                    <div class="viz-header">
                        <h4>Two Pointers: Find Two Sum = ${this.target}</h4>
                    </div>
                    
                    <div class="array-display" id="arrayDisplay"></div>
                    
                    <div class="viz-controls">
                        <button class="viz-btn viz-btn-primary" id="btnStep">Next Step</button>
                        <button class="viz-btn" id="btnReset">Reset</button>
                    </div>
                    
                    <div class="viz-message" id="message">
                        Click "Next Step" to see how two pointers work
                    </div>
                </div>
            `;

            this.renderArray();
        }

        renderArray() {
            const display = document.getElementById('arrayDisplay');
            const currentStep = this.steps[this.step];

            display.innerHTML = this.array.map((val, idx) => {
                let className = 'array-cell';
                let label = '';

                if (currentStep) {
                    if (idx === currentStep.left) {
                        className += ' left-pointer';
                        label = '<div class="pointer-label left">L</div>';
                    }
                    if (idx === currentStep.right) {
                        className += ' right-pointer';
                        label = '<div class="pointer-label right">R</div>';
                    }
                }

                return `
                    <div class="${className}">
                        ${label}
                        <div class="cell-value">${val}</div>
                        <div class="cell-index">${idx}</div>
                    </div>
                `;
            }).join('');

            this.updateMessage();
        }

        updateMessage() {
            const msg = document.getElementById('message');
            const currentStep = this.steps[this.step];

            if (!currentStep) {
                msg.textContent = 'Click "Next Step" to start';
                msg.style.color = '#888';
                return;
            }

            msg.innerHTML = `
                <strong>Step ${this.step + 1}:</strong> ${currentStep.message}
                ${currentStep.sum === this.target ? ' ✅' : ''}
            `;
            msg.style.color = currentStep.sum === this.target ? '#10b981' : '#3b82f6';
        }

        bindEvents() {
            document.getElementById('btnStep').addEventListener('click', () => this.nextStep());
            document.getElementById('btnReset').addEventListener('click', () => this.reset());
        }

        nextStep() {
            if (this.step < this.steps.length - 1) {
                this.step++;
                this.renderArray();
            } else {
                const msg = document.getElementById('message');
                msg.innerHTML = '✅ <strong>Done!</strong> Found the pair in O(n) time';
                msg.style.color = '#10b981';
            }
        }

        reset() {
            this.step = 0;
            this.renderArray();
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new TwoPointersViz('twoPointersViz');
        });
    } else {
        new TwoPointersViz('twoPointersViz');
    }
})();
