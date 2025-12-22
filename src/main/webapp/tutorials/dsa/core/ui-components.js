/**
 * UI Controls Component
 * Reusable control panel for all visualizations
 */
class VisualizationControls {
    constructor(config = {}) {
        this.config = {
            showPlayback: config.showPlayback !== false,
            showSpeed: config.showSpeed !== false,
            showSize: config.showSize !== false,
            showShuffle: config.showShuffle !== false,
            speedMin: config.speedMin || 200,
            speedMax: config.speedMax || 2000,
            speedDefault: config.speedDefault || 800,
            speedStep: config.speedStep || 100,
            sizeMin: config.sizeMin || 4,
            sizeMax: config.sizeMax || 15,
            sizeDefault: config.sizeDefault || 8,
            sizeStep: config.sizeStep || 1,
            ...config
        };

        this.callbacks = {
            onStart: config.onStart || (() => { }),
            onPause: config.onPause || (() => { }),
            onStep: config.onStep || (() => { }),
            onReset: config.onReset || (() => { }),
            onShuffle: config.onShuffle || (() => { }),
            onSpeedChange: config.onSpeedChange || (() => { }),
            onSizeChange: config.onSizeChange || (() => { })
        };

        this.elements = {};
    }

    render(containerId) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const controlsHTML = `
            <div class="controls">
                ${this.config.showPlayback ? this.renderPlaybackControls() : ''}
                ${this.config.showSpeed ? this.renderSpeedControl() : ''}
                ${this.config.showSize ? this.renderSizeControl() : ''}
            </div>
        `;

        container.innerHTML = controlsHTML;
        this.bindEvents();
    }

    renderPlaybackControls() {
        return `
            <button class="btn btn-primary" id="startBtn">
                <span>▶️</span> Start
            </button>
            <button class="btn" id="pauseBtn" disabled>
                <span>⏸</span> Pause
            </button>
            <button class="btn" id="stepBtn">
                <span>⏭</span> Step
            </button>
            <button class="btn" id="resetBtn">
                <span>🔄</span> Reset
            </button>
            ${this.config.showShuffle ? `
                <button class="btn" id="shuffleBtn">
                    <span>🎲</span> Shuffle
                </button>
            ` : ''}
        `;
    }

    renderSpeedControl() {
        return `
            <div class="slider-group">
                <div class="slider-label">
                    <span>Speed</span>
                    <span id="speedValue">${this.config.speedDefault}ms</span>
                </div>
                <input type="range" id="speedSlider" 
                    min="${this.config.speedMin}" 
                    max="${this.config.speedMax}" 
                    value="${this.config.speedDefault}" 
                    step="${this.config.speedStep}">
            </div>
        `;
    }

    renderSizeControl() {
        return `
            <div class="slider-group">
                <div class="slider-label">
                    <span>Array Size</span>
                    <span id="sizeValue">${this.config.sizeDefault}</span>
                </div>
                <input type="range" id="sizeSlider" 
                    min="${this.config.sizeMin}" 
                    max="${this.config.sizeMax}" 
                    value="${this.config.sizeDefault}" 
                    step="${this.config.sizeStep}">
            </div>
        `;
    }

    bindEvents() {
        this.elements.startBtn = document.getElementById('startBtn');
        this.elements.pauseBtn = document.getElementById('pauseBtn');
        this.elements.stepBtn = document.getElementById('stepBtn');
        this.elements.resetBtn = document.getElementById('resetBtn');
        this.elements.shuffleBtn = document.getElementById('shuffleBtn');
        this.elements.speedSlider = document.getElementById('speedSlider');
        this.elements.sizeSlider = document.getElementById('sizeSlider');
        this.elements.speedValue = document.getElementById('speedValue');
        this.elements.sizeValue = document.getElementById('sizeValue');

        if (this.elements.startBtn) {
            this.elements.startBtn.addEventListener('click', () => {
                this.callbacks.onStart();
                this.setRunningState(true);
            });
        }

        if (this.elements.pauseBtn) {
            this.elements.pauseBtn.addEventListener('click', () => {
                this.callbacks.onPause();
                this.togglePauseButton();
            });
        }

        if (this.elements.stepBtn) {
            this.elements.stepBtn.addEventListener('click', () => {
                this.callbacks.onStep();
            });
        }

        if (this.elements.resetBtn) {
            this.elements.resetBtn.addEventListener('click', () => {
                this.callbacks.onReset();
                this.setRunningState(false);
            });
        }

        if (this.elements.shuffleBtn) {
            this.elements.shuffleBtn.addEventListener('click', () => {
                this.callbacks.onShuffle();
            });
        }

        if (this.elements.speedSlider) {
            this.elements.speedSlider.addEventListener('input', (e) => {
                const value = parseInt(e.target.value);
                this.elements.speedValue.textContent = `${value}ms`;
                this.callbacks.onSpeedChange(value);
            });
        }

        if (this.elements.sizeSlider) {
            this.elements.sizeSlider.addEventListener('input', (e) => {
                const value = parseInt(e.target.value);
                this.elements.sizeValue.textContent = value;
                this.callbacks.onSizeChange(value);
            });
        }
    }

    setRunningState(isRunning) {
        if (this.elements.startBtn) this.elements.startBtn.disabled = isRunning;
        if (this.elements.pauseBtn) this.elements.pauseBtn.disabled = !isRunning;
        if (this.elements.stepBtn) this.elements.stepBtn.disabled = isRunning;
        if (this.elements.shuffleBtn) this.elements.shuffleBtn.disabled = isRunning;
        if (this.elements.sizeSlider) this.elements.sizeSlider.disabled = isRunning;
    }

    togglePauseButton() {
        if (!this.elements.pauseBtn) return;

        const isPaused = this.elements.pauseBtn.innerHTML.includes('Resume');
        this.elements.pauseBtn.innerHTML = isPaused ?
            '<span>⏸</span> Pause' :
            '<span>▶️</span> Resume';
    }

    reset() {
        this.setRunningState(false);
        if (this.elements.pauseBtn) {
            this.elements.pauseBtn.innerHTML = '<span>⏸</span> Pause';
        }
    }
}

/**
 * Stats Display Component
 */
class StatsDisplay {
    constructor(stats = []) {
        this.stats = stats;
    }

    render(containerId) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const statsHTML = `
            <div class="stats-bar">
                ${this.stats.map(stat => `
                    <div class="stat-card">
                        <div class="stat-label">${stat.label}</div>
                        <div class="stat-value" id="${stat.id}">0</div>
                    </div>
                `).join('')}
            </div>
        `;

        container.innerHTML = statsHTML;
    }

    update(statId, value) {
        const element = document.getElementById(statId);
        if (element) {
            element.textContent = value;
        }
    }
}

/**
 * Operation Display Component
 */
class OperationDisplay {
    constructor(config = {}) {
        this.config = {
            defaultText: config.defaultText || 'Ready to start...',
            ...config
        };
    }

    render(containerId) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const html = `
            <div class="current-operation" id="currentOp">
                ${this.config.defaultText}
            </div>
        `;

        container.innerHTML = html;
    }

    update(text) {
        const element = document.getElementById('currentOp');
        if (element) {
            element.textContent = text;
        }
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { VisualizationControls, StatsDisplay, OperationDisplay };
}
