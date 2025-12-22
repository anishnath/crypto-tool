/**
 * Big O Complexity Growth Visualization
 * Shows how different time complexities grow with input size
 * Uses logarithmic Y-axis for better visualization of all curves
 */

(function () {
    'use strict';

    class BigOVisualization {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.n = 1;
            this.maxN = 100;
            this.isPlaying = false;
            this.animationSpeed = 50;
            this.useLogScale = true; // Use logarithmic Y-axis for better visualization

            // Complexity functions
            this.complexities = {
                'O(1)': { fn: (n) => 1, color: '#10b981', label: 'Constant' },
                'O(log n)': { fn: (n) => Math.log2(Math.max(n, 1)), color: '#3b82f6', label: 'Logarithmic' },
                'O(n)': { fn: (n) => n, color: '#8b5cf6', label: 'Linear' },
                'O(n log n)': { fn: (n) => n * Math.log2(Math.max(n, 1)), color: '#f59e0b', label: 'Linearithmic' },
                'O(n²)': { fn: (n) => n * n, color: '#ef4444', label: 'Quadratic' },
                'O(2ⁿ)': { fn: (n) => Math.pow(2, Math.min(n, 20)), color: '#dc2626', label: 'Exponential' }
            };

            this.init();
        }

        init() {
            this.render();
            this.drawChart();
            this.bindEvents();
            // Auto-play animation on load after a short delay
            setTimeout(() => {
                this.togglePlay();
            }, 800);
        }

        render() {
            this.container.innerHTML = `
                <div class="bigo-viz">
                    <div class="bigo-header">
                        <h3>Big O Complexity Growth Comparison</h3>
                        <p>Logarithmic scale - all curves visible and comparable</p>
                    </div>

                    <div class="bigo-canvas-container">
                        <canvas id="bigoCanvas" width="800" height="400"></canvas>
                        <div class="bigo-watermark">8gwifi.org/tutorials</div>
                    </div>

                    <div class="bigo-controls">
                        <button class="viz-btn viz-btn-primary" id="bigoPlay">
                            <span>⏸</span> Pause
                        </button>
                        <button class="viz-btn" id="bigoReset">
                            <span>🔄</span> Reset
                        </button>
                        <div class="viz-slider-group">
                            <div class="viz-slider-label">
                                <span>Input Size (n)</span>
                                <span id="bigoNValue">1</span>
                            </div>
                            <input type="range" class="viz-slider" id="bigoSlider" 
                                   min="1" max="100" value="1" step="1">
                        </div>
                    </div>

                    <div class="bigo-legend" id="bigoLegend"></div>

                    <div class="bigo-values" id="bigoValues"></div>
                </div>
            `;

            this.canvas = document.getElementById('bigoCanvas');
            this.ctx = this.canvas.getContext('2d');
            this.renderLegend();
        }

        renderLegend() {
            const legend = document.getElementById('bigoLegend');
            let html = '<div class="bigo-legend-items">';

            for (const [name, data] of Object.entries(this.complexities)) {
                html += `
                    <div class="bigo-legend-item">
                        <div class="bigo-legend-color" style="background: ${data.color}"></div>
                        <span class="bigo-legend-name">${name}</span>
                        <span class="bigo-legend-label">${data.label}</span>
                    </div>
                `;
            }

            html += '</div>';
            legend.innerHTML = html;
        }

        bindEvents() {
            document.getElementById('bigoPlay').addEventListener('click', () => this.togglePlay());
            document.getElementById('bigoReset').addEventListener('click', () => this.reset());
            document.getElementById('bigoSlider').addEventListener('input', (e) => {
                this.n = parseInt(e.target.value);
                this.updateDisplay();
                this.drawChart();
            });
        }

        togglePlay() {
            this.isPlaying = !this.isPlaying;
            const btn = document.getElementById('bigoPlay');

            if (this.isPlaying) {
                btn.innerHTML = '<span>⏸</span> Pause';
                this.animate();
            } else {
                btn.innerHTML = '<span>▶️</span> Play Animation';
            }
        }

        async animate() {
            while (this.isPlaying && this.n < this.maxN) {
                this.n++;
                document.getElementById('bigoSlider').value = this.n;
                this.updateDisplay();
                this.drawChart();
                await this.sleep(this.animationSpeed);
            }

            if (this.n >= this.maxN) {
                this.isPlaying = false;
                document.getElementById('bigoPlay').innerHTML = '<span>▶️</span> Play Animation';
            }
        }

        reset() {
            this.isPlaying = false;
            this.n = 1;
            document.getElementById('bigoSlider').value = 1;
            document.getElementById('bigoPlay').innerHTML = '<span>▶️</span> Play Animation';
            this.updateDisplay();
            this.drawChart();
        }

        updateDisplay() {
            document.getElementById('bigoNValue').textContent = this.n;
            this.updateValues();
        }

        updateValues() {
            const values = document.getElementById('bigoValues');
            let html = '<div class="bigo-values-grid">';

            for (const [name, data] of Object.entries(this.complexities)) {
                const value = data.fn(this.n);
                const displayValue = value < 1000 ? value.toFixed(0) :
                    value < 1000000 ? (value / 1000).toFixed(1) + 'K' :
                        (value / 1000000).toFixed(1) + 'M';

                html += `
                    <div class="bigo-value-card" style="border-left-color: ${data.color}">
                        <div class="bigo-value-name">${name}</div>
                        <div class="bigo-value-number">${displayValue}</div>
                        <div class="bigo-value-ops">operations</div>
                    </div>
                `;
            }

            html += '</div>';
            values.innerHTML = html;
        }

        drawChart() {
            const ctx = this.ctx;
            const width = this.canvas.width;
            const height = this.canvas.height;
            const padding = 60;
            const chartWidth = width - padding * 2;
            const chartHeight = height - padding * 2;

            // Clear canvas
            ctx.clearRect(0, 0, width, height);

            // Background
            ctx.fillStyle = getComputedStyle(document.documentElement)
                .getPropertyValue('--bg-primary') || '#ffffff';
            ctx.fillRect(0, 0, width, height);

            // Calculate max value for scaling (using log scale)
            let maxValue = 0;
            for (let i = 1; i <= this.maxN; i++) {
                for (const data of Object.values(this.complexities)) {
                    const value = data.fn(i);
                    if (value < Infinity && value > 0) {
                        maxValue = Math.max(maxValue, value);
                    }
                }
            }

            // Draw grid
            this.drawGrid(ctx, padding, chartWidth, chartHeight);

            // Draw axes
            this.drawAxes(ctx, padding, width, height, chartWidth, chartHeight, maxValue);

            // Draw curves
            for (const [name, data] of Object.entries(this.complexities)) {
                this.drawCurve(ctx, data, padding, chartWidth, chartHeight, maxValue);
            }

            // Draw current position marker
            this.drawCurrentMarker(ctx, padding, chartWidth, chartHeight, maxValue);

            // Draw curve labels at current position
            this.drawCurveLabels(ctx, padding, chartWidth, chartHeight, maxValue);
        }

        drawGrid(ctx, padding, chartWidth, chartHeight) {
            ctx.strokeStyle = 'rgba(128, 128, 128, 0.1)';
            ctx.lineWidth = 1;

            // Horizontal grid lines
            for (let i = 0; i <= 5; i++) {
                const y = padding + (chartHeight / 5) * i;
                ctx.beginPath();
                ctx.moveTo(padding, y);
                ctx.lineTo(padding + chartWidth, y);
                ctx.stroke();
            }

            // Vertical grid lines
            for (let i = 0; i <= 10; i++) {
                const x = padding + (chartWidth / 10) * i;
                ctx.beginPath();
                ctx.moveTo(x, padding);
                ctx.lineTo(x, padding + chartHeight);
                ctx.stroke();
            }
        }

        drawAxes(ctx, padding, width, height, chartWidth, chartHeight, maxValue) {
            ctx.strokeStyle = '#666';
            ctx.lineWidth = 2;
            ctx.font = '12px Inter, sans-serif';
            ctx.fillStyle = '#666';

            // Y-axis
            ctx.beginPath();
            ctx.moveTo(padding, padding);
            ctx.lineTo(padding, padding + chartHeight);
            ctx.stroke();

            // X-axis
            ctx.beginPath();
            ctx.moveTo(padding, padding + chartHeight);
            ctx.lineTo(padding + chartWidth, padding + chartHeight);
            ctx.stroke();

            // Y-axis label
            ctx.save();
            ctx.translate(20, padding + chartHeight / 2);
            ctx.rotate(-Math.PI / 2);
            ctx.textAlign = 'center';
            ctx.fillText('Operations (log scale)', 0, 0);
            ctx.restore();

            // X-axis label
            ctx.textAlign = 'center';
            ctx.fillText('Input Size (n)', padding + chartWidth / 2, height - 20);

            // X-axis ticks
            for (let i = 0; i <= 10; i++) {
                const x = padding + (chartWidth / 10) * i;
                const value = Math.round((this.maxN / 10) * i);
                ctx.fillText(value, x, padding + chartHeight + 20);
            }

            // Y-axis ticks (logarithmic)
            if (this.useLogScale) {
                const logMax = Math.log10(maxValue);
                for (let i = 0; i <= 5; i++) {
                    const y = padding + chartHeight - (chartHeight / 5) * i;
                    const value = Math.pow(10, (logMax / 5) * i);
                    const label = value < 1000 ? value.toFixed(0) :
                        value < 1000000 ? (value / 1000).toFixed(0) + 'K' :
                            (value / 1000000).toFixed(0) + 'M';
                    ctx.textAlign = 'right';
                    ctx.fillText(label, padding - 10, y + 4);
                }
            }
        }

        drawCurve(ctx, data, padding, chartWidth, chartHeight, maxValue) {
            ctx.strokeStyle = data.color;
            ctx.lineWidth = 3;
            ctx.beginPath();

            let started = false;
            for (let i = 1; i <= this.n; i++) {
                const value = data.fn(i);
                if (value === Infinity || value <= 0) continue;

                const x = padding + (i / this.maxN) * chartWidth;
                let y;

                if (this.useLogScale) {
                    // Logarithmic Y-axis
                    const logValue = Math.log10(value);
                    const logMax = Math.log10(maxValue);
                    y = padding + chartHeight - (logValue / logMax) * chartHeight;
                } else {
                    // Linear Y-axis
                    y = padding + chartHeight - (value / maxValue) * chartHeight;
                }

                if (!started) {
                    ctx.moveTo(x, y);
                    started = true;
                } else {
                    ctx.lineTo(x, y);
                }
            }

            ctx.stroke();
        }

        drawCurrentMarker(ctx, padding, chartWidth, chartHeight, maxValue) {
            const x = padding + (this.n / this.maxN) * chartWidth;

            // Vertical line
            ctx.strokeStyle = 'rgba(128, 128, 128, 0.5)';
            ctx.lineWidth = 2;
            ctx.setLineDash([5, 5]);
            ctx.beginPath();
            ctx.moveTo(x, padding);
            ctx.lineTo(x, padding + chartHeight);
            ctx.stroke();
            ctx.setLineDash([]);

            // Draw points on each curve
            for (const data of Object.values(this.complexities)) {
                const value = data.fn(this.n);
                if (value === Infinity || value <= 0) continue;

                let y;
                if (this.useLogScale) {
                    const logValue = Math.log10(value);
                    const logMax = Math.log10(maxValue);
                    y = padding + chartHeight - (logValue / logMax) * chartHeight;
                } else {
                    y = padding + chartHeight - (value / maxValue) * chartHeight;
                }

                ctx.fillStyle = data.color;
                ctx.beginPath();
                ctx.arc(x, y, 5, 0, Math.PI * 2);
                ctx.fill();

                ctx.strokeStyle = '#fff';
                ctx.lineWidth = 2;
                ctx.stroke();
            }
        }

        drawCurveLabels(ctx, padding, chartWidth, chartHeight, maxValue) {
            ctx.font = 'bold 11px Inter, sans-serif';
            ctx.textAlign = 'left';

            for (const [name, data] of Object.entries(this.complexities)) {
                const value = data.fn(this.n);
                if (value === Infinity || value <= 0) continue;

                const x = padding + (this.n / this.maxN) * chartWidth;
                let y;

                if (this.useLogScale) {
                    const logValue = Math.log10(value);
                    const logMax = Math.log10(maxValue);
                    y = padding + chartHeight - (logValue / logMax) * chartHeight;
                } else {
                    y = padding + chartHeight - (value / maxValue) * chartHeight;
                }

                // Draw label background
                const labelText = name;
                const metrics = ctx.measureText(labelText);
                const labelWidth = metrics.width + 8;
                const labelHeight = 18;

                ctx.fillStyle = 'rgba(0, 0, 0, 0.7)';
                ctx.fillRect(x + 10, y - labelHeight / 2, labelWidth, labelHeight);

                // Draw label text
                ctx.fillStyle = data.color;
                ctx.fillText(labelText, x + 14, y + 4);
            }
        }

        async sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new BigOVisualization('bigoVisualization');
        });
    } else {
        new BigOVisualization('bigoVisualization');
    }
})();
