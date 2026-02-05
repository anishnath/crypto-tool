// Kinematics Solver - Smart equation solver with visualization

const knownVars = new Set(['u', 'a', 't']); // Pre-select u, a, t

// Unit conversions
const velocityToMS = { 'm/s': 1, 'km/h': 1 / 3.6, 'mph': 0.44704 };
const accelerationToMS2 = { 'm/s²': 1, 'km/h²': 1 / 12960 };
const distanceToMeters = { 'm': 1, 'km': 1000, 'mi': 1609.34, 'ft': 0.3048 };
const timeToSeconds = { 's': 1, 'min': 60, 'h': 3600 };

function formatNumber(num) {
    if (num === 0) return '0';
    const absNum = Math.abs(num);
    if (absNum >= 1000) return num.toFixed(0);
    if (absNum >= 100) return num.toFixed(1);
    if (absNum >= 10) return num.toFixed(2);
    if (absNum >= 1) return num.toFixed(2);
    if (absNum >= 0.01) return num.toFixed(4);
    return num.toExponential(2);
}

// Toggle variable selection
function toggleVar(varName) {
    if (knownVars.has(varName)) {
        knownVars.delete(varName);
        document.getElementById(`btn-${varName}`).classList.remove('active');
        document.querySelector(`#btn-${varName} .var-status`).textContent = 'Unknown';
    } else {
        if (knownVars.size >= 3) {
            alert('Select exactly 3 known variables');
            return;
        }
        knownVars.add(varName);
        document.getElementById(`btn-${varName}`).classList.add('active');
        document.querySelector(`#btn-${varName} .var-status`).textContent = 'Known';
    }
    updateInputs();
}

// Update input fields based on selection
function updateInputs() {
    const inputsSection = document.getElementById('inputs-section');
    const vars = {
        u: { name: 'Initial Velocity', emoji: '🚀', units: ['m/s', 'km/h', 'mph'], default: 0 },
        v: { name: 'Final Velocity', emoji: '🏁', units: ['m/s', 'km/h', 'mph'], default: 0 },
        a: { name: 'Acceleration', emoji: '⚡', units: ['m/s²', 'km/h²'], default: 5 },
        s: { name: 'Distance', emoji: '📏', units: ['m', 'km', 'mi', 'ft'], default: 0 },
        t: { name: 'Time', emoji: '⏱️', units: ['s', 'min', 'h'], default: 10 }
    };

    let html = '';
    for (const varName of knownVars) {
        const v = vars[varName];
        html += `
            <div class="input-group">
                <div class="input-label">
                    <span>${v.emoji}</span>
                    <span>${v.name} (${varName})</span>
                </div>
                <div class="input-row">
                    <input type="number" id="input-${varName}" class="number-input" 
                           value="${v.default}" step="any">
                    <select id="unit-${varName}" class="unit-select">
                        ${v.units.map(u => `<option value="${u}">${u}</option>`).join('')}
                    </select>
                </div>
            </div>
        `;
    }
    inputsSection.innerHTML = html;
}

// Main solve function
function solve() {
    const values = {};

    // Get values in base units
    for (const varName of knownVars) {
        const input = document.getElementById(`input-${varName}`);
        const unit = document.getElementById(`unit-${varName}`);
        const value = parseFloat(input.value) || 0;

        let baseValue = value;
        if (varName === 'u' || varName === 'v') baseValue = value * velocityToMS[unit.value];
        else if (varName === 'a') baseValue = value * accelerationToMS2[unit.value];
        else if (varName === 's') baseValue = value * distanceToMeters[unit.value];
        else if (varName === 't') baseValue = value * timeToSeconds[unit.value];

        values[varName] = baseValue;
    }

    const allVars = ['u', 'v', 'a', 's', 't'];
    const unknowns = allVars.filter(v => !knownVars.has(v));

    const solutions = solveKinematics(values, unknowns);
    displaySolutions(solutions, values, unknowns);
}

// Smart solver
function solveKinematics(k, unknowns) {
    const solutions = {};

    // Case 1: u, a, t → v, s
    if (k.u !== undefined && k.a !== undefined && k.t !== undefined) {
        solutions.v = {
            value: k.u + k.a * k.t,
            formula: 'v = u + at',
            steps: [
                `Substitute values: v = ${formatNumber(k.u)} + (${formatNumber(k.a)} × ${formatNumber(k.t)})`,
                `Calculate: v = ${formatNumber(k.u + k.a * k.t)} m/s`
            ]
        };
        solutions.s = {
            value: k.u * k.t + 0.5 * k.a * k.t * k.t,
            formula: 's = ut + ½at²',
            steps: [
                `Substitute: s = (${formatNumber(k.u)} × ${formatNumber(k.t)}) + ½(${formatNumber(k.a)} × ${formatNumber(k.t)}²)`,
                `Calculate: s = ${formatNumber(k.u * k.t + 0.5 * k.a * k.t * k.t)} m`
            ]
        };
    }

    // Case 2: u, a, s → v, t
    else if (k.u !== undefined && k.a !== undefined && k.s !== undefined) {
        const vSquared = k.u * k.u + 2 * k.a * k.s;
        const v = vSquared >= 0 ? Math.sqrt(vSquared) : 0;
        solutions.v = {
            value: v,
            formula: 'v² = u² + 2as',
            steps: [
                `v² = ${formatNumber(k.u)}² + (2 × ${formatNumber(k.a)} × ${formatNumber(k.s)})`,
                `v² = ${formatNumber(vSquared)}`,
                `v = √${formatNumber(vSquared)} = ${formatNumber(v)} m/s`
            ]
        };
        if (k.a !== 0) {
            solutions.t = {
                value: (v - k.u) / k.a,
                formula: 't = (v - u) / a',
                steps: [
                    `t = (${formatNumber(v)} - ${formatNumber(k.u)}) / ${formatNumber(k.a)}`,
                    `t = ${formatNumber((v - k.u) / k.a)} s`
                ]
            };
        }
    }

    // Case 3: u, v, t → a, s
    else if (k.u !== undefined && k.v !== undefined && k.t !== undefined) {
        if (k.t !== 0) {
            solutions.a = {
                value: (k.v - k.u) / k.t,
                formula: 'a = (v - u) / t',
                steps: [
                    `a = (${formatNumber(k.v)} - ${formatNumber(k.u)}) / ${formatNumber(k.t)}`,
                    `a = ${formatNumber((k.v - k.u) / k.t)} m/s²`
                ]
            };
        }
        solutions.s = {
            value: 0.5 * (k.u + k.v) * k.t,
            formula: 's = ½(u + v)t',
            steps: [
                `s = ½(${formatNumber(k.u)} + ${formatNumber(k.v)}) × ${formatNumber(k.t)}`,
                `s = ${formatNumber(0.5 * (k.u + k.v) * k.t)} m`
            ]
        };
    }

    // Case 4: u, v, a → s, t
    else if (k.u !== undefined && k.v !== undefined && k.a !== undefined) {
        if (k.a !== 0) {
            solutions.s = {
                value: (k.v * k.v - k.u * k.u) / (2 * k.a),
                formula: 's = (v² - u²) / 2a',
                steps: [
                    `s = (${formatNumber(k.v)}² - ${formatNumber(k.u)}²) / (2 × ${formatNumber(k.a)})`,
                    `s = ${formatNumber((k.v * k.v - k.u * k.u) / (2 * k.a))} m`
                ]
            };
            solutions.t = {
                value: (k.v - k.u) / k.a,
                formula: 't = (v - u) / a',
                steps: [
                    `t = (${formatNumber(k.v)} - ${formatNumber(k.u)}) / ${formatNumber(k.a)}`,
                    `t = ${formatNumber((k.v - k.u) / k.a)} s`
                ]
            };
        }
    }

    // Case 5: u, v, s → a, t
    else if (k.u !== undefined && k.v !== undefined && k.s !== undefined) {
        if (k.s !== 0) {
            solutions.a = {
                value: (k.v * k.v - k.u * k.u) / (2 * k.s),
                formula: 'a = (v² - u²) / 2s',
                steps: [
                    `a = (${formatNumber(k.v)}² - ${formatNumber(k.u)}²) / (2 × ${formatNumber(k.s)})`,
                    `a = ${formatNumber((k.v * k.v - k.u * k.u) / (2 * k.s))} m/s²`
                ]
            };
        }
        if (k.u + k.v !== 0) {
            solutions.t = {
                value: (2 * k.s) / (k.u + k.v),
                formula: 't = 2s / (u + v)',
                steps: [
                    `t = (2 × ${formatNumber(k.s)}) / (${formatNumber(k.u)} + ${formatNumber(k.v)})`,
                    `t = ${formatNumber((2 * k.s) / (k.u + k.v))} s`
                ]
            };
        }
    }

    // Case 6: u, s, t → v, a
    else if (k.u !== undefined && k.s !== undefined && k.t !== undefined) {
        if (k.t !== 0) {
            const a = (2 * (k.s - k.u * k.t)) / (k.t * k.t);
            solutions.a = {
                value: a,
                formula: 'a = 2(s - ut) / t²',
                steps: [
                    `a = 2(${formatNumber(k.s)} - ${formatNumber(k.u)} × ${formatNumber(k.t)}) / ${formatNumber(k.t)}²`,
                    `a = ${formatNumber(a)} m/s²`
                ]
            };
            solutions.v = {
                value: k.u + a * k.t,
                formula: 'v = u + at',
                steps: [
                    `v = ${formatNumber(k.u)} + (${formatNumber(a)} × ${formatNumber(k.t)})`,
                    `v = ${formatNumber(k.u + a * k.t)} m/s`
                ]
            };
        }
    }

    // Case 7: v, a, t → u, s
    else if (k.v !== undefined && k.a !== undefined && k.t !== undefined) {
        solutions.u = {
            value: k.v - k.a * k.t,
            formula: 'u = v - at',
            steps: [
                `u = ${formatNumber(k.v)} - (${formatNumber(k.a)} × ${formatNumber(k.t)})`,
                `u = ${formatNumber(k.v - k.a * k.t)} m/s`
            ]
        };
        const u = k.v - k.a * k.t;
        solutions.s = {
            value: u * k.t + 0.5 * k.a * k.t * k.t,
            formula: 's = ut + ½at²',
            steps: [
                `s = (${formatNumber(u)} × ${formatNumber(k.t)}) + ½(${formatNumber(k.a)} × ${formatNumber(k.t)}²)`,
                `s = ${formatNumber(u * k.t + 0.5 * k.a * k.t * k.t)} m`
            ]
        };
    }

    // Case 8: v, a, s → u, t
    else if (k.v !== undefined && k.a !== undefined && k.s !== undefined) {
        const uSquared = k.v * k.v - 2 * k.a * k.s;
        const u = uSquared >= 0 ? Math.sqrt(uSquared) : 0;
        solutions.u = {
            value: u,
            formula: 'u² = v² - 2as',
            steps: [
                `u² = ${formatNumber(k.v)}² - (2 × ${formatNumber(k.a)} × ${formatNumber(k.s)})`,
                `u = ${formatNumber(u)} m/s`
            ]
        };
        if (k.a !== 0) {
            solutions.t = {
                value: (k.v - u) / k.a,
                formula: 't = (v - u) / a',
                steps: [
                    `t = (${formatNumber(k.v)} - ${formatNumber(u)}) / ${formatNumber(k.a)}`,
                    `t = ${formatNumber((k.v - u) / k.a)} s`
                ]
            };
        }
    }

    // Case 9: v, s, t → u, a
    else if (k.v !== undefined && k.s !== undefined && k.t !== undefined) {
        if (k.t !== 0) {
            const u = (2 * k.s / k.t) - k.v;
            solutions.u = {
                value: u,
                formula: 'u = (2s/t) - v',
                steps: [
                    `u = (2 × ${formatNumber(k.s)} / ${formatNumber(k.t)}) - ${formatNumber(k.v)}`,
                    `u = ${formatNumber(u)} m/s`
                ]
            };
            solutions.a = {
                value: (k.v - u) / k.t,
                formula: 'a = (v - u) / t',
                steps: [
                    `a = (${formatNumber(k.v)} - ${formatNumber(u)}) / ${formatNumber(k.t)}`,
                    `a = ${formatNumber((k.v - u) / k.t)} m/s²`
                ]
            };
        }
    }

    // Case 10: a, s, t → u, v
    else if (k.a !== undefined && k.s !== undefined && k.t !== undefined) {
        if (k.t !== 0) {
            const u = (k.s - 0.5 * k.a * k.t * k.t) / k.t;
            solutions.u = {
                value: u,
                formula: 'u = (s - ½at²) / t',
                steps: [
                    `u = (${formatNumber(k.s)} - ½ × ${formatNumber(k.a)} × ${formatNumber(k.t)}²) / ${formatNumber(k.t)}`,
                    `u = ${formatNumber(u)} m/s`
                ]
            };
            solutions.v = {
                value: u + k.a * k.t,
                formula: 'v = u + at',
                steps: [
                    `v = ${formatNumber(u)} + (${formatNumber(k.a)} × ${formatNumber(k.t)})`,
                    `v = ${formatNumber(u + k.a * k.t)} m/s`
                ]
            };
        }
    }

    return solutions;
}

// Display solutions with visualization
function displaySolutions(solutions, known, unknowns) {
    const panel = document.getElementById('result-panel');

    // Get all values
    const allValues = { ...known };
    for (const varName of unknowns) {
        if (solutions[varName]) {
            allValues[varName] = solutions[varName].value;
        }
    }

    const u = allValues.u || 0;
    const v = allValues.v || 0;
    const a = allValues.a || 0;
    const s = allValues.s || 0;
    const t = allValues.t || 0;

    let html = `
        <div class="solution-header">
            <div class="solution-title">
                <span>✅</span>
                <span>Solutions Found!</span>
            </div>
        </div>
    `;

    // Display each solution
    for (const varName of unknowns) {
        if (solutions[varName]) {
            const sol = solutions[varName];
            const labels = {
                u: 'Initial Velocity (u)',
                v: 'Final Velocity (v)',
                a: 'Acceleration (a)',
                s: 'Distance (s)',
                t: 'Time (t)'
            };
            const units = { u: 'm/s', v: 'm/s', a: 'm/s²', s: 'm', t: 's' };

            html += `
                <div class="solution-card">
                    <h4 style="color: var(--physics-green); margin: 0 0 0.75rem 0; font-size: 1.125rem;">
                        ${labels[varName]}
                    </h4>
                    <div class="result-main">${formatNumber(sol.value)} ${units[varName]}</div>
                    ${getConversions(varName, sol.value)}
                    <div class="formula-box">
                        <strong>Formula:</strong> <span class="formula-text">${sol.formula}</span>
                    </div>
                    <div class="steps-container">
                        ${sol.steps.map((step, i) => `
                            <div class="step">
                                <div class="step-label">Step ${i + 1}</div>
                                <div class="step-content">${step}</div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        }
    }

    // Add visualization
    html += createVisualization(u, v, a, s, t);

    panel.innerHTML = html;

    // Animate after render
    setTimeout(() => animateMotion(u, v, a, s, t), 100);
}

function getConversions(varName, value) {
    if (varName === 'u' || varName === 'v') {
        return `
            <div class="result-conversions">
                <div class="conversion-badge">${formatNumber(value * 3.6)} km/h</div>
                <div class="conversion-badge">${formatNumber(value / 0.44704)} mph</div>
            </div>
        `;
    } else if (varName === 's') {
        return `
            <div class="result-conversions">
                <div class="conversion-badge">${formatNumber(value / 1000)} km</div>
                <div class="conversion-badge">${formatNumber(value / 1609.34)} miles</div>
            </div>
        `;
    } else if (varName === 't') {
        return `
            <div class="result-conversions">
                <div class="conversion-badge">${formatNumber(value / 60)} min</div>
                <div class="conversion-badge">${formatNumber(value / 3600)} h</div>
            </div>
        `;
    }
    return '';
}

function createVisualization(u, v, a, s, t) {
    return `
        <div class="animation-stage">
            <div class="stage-info">
                <div class="info-badge">
                    <div class="label">Distance</div>
                    <div class="value">${formatNumber(s)} m</div>
                </div>
                <div class="info-badge">
                    <div class="label">Time</div>
                    <div class="value">${formatNumber(t)} s</div>
                </div>
                <div class="info-badge">
                    <div class="label">Acceleration</div>
                    <div class="value">${formatNumber(a)} m/s²</div>
                </div>
            </div>
            <div class="vehicle-container" id="vehicle-container">
                <div class="vehicle" id="vehicle">🚗</div>
            </div>
            <div class="road">
                <div class="road-line"></div>
            </div>
            <div class="distance-markers">
                <span>Start (${formatNumber(u)} m/s)</span>
                <span>End (${formatNumber(v)} m/s)</span>
            </div>
        </div>
        
        <div class="graphs-container">
            <div class="graph-card">
                <div class="graph-title">
                    <span>📈</span>
                    <span>Velocity vs Time</span>
                </div>
                <svg class="graph-svg" id="v-t-graph" viewBox="0 0 300 200">
                    <line class="graph-axis" x1="40" y1="160" x2="280" y2="160" />
                    <line class="graph-axis" x1="40" y1="20" x2="40" y2="160" />
                    <text class="graph-label" x="150" y="190">Time (s)</text>
                    <text class="graph-label" x="5" y="90" transform="rotate(-90 5 90)">Velocity (m/s)</text>
                    <path id="v-t-line" class="graph-line" />
                    <circle id="v-t-point" class="graph-point" r="5" />
                </svg>
            </div>
            <div class="graph-card">
                <div class="graph-title">
                    <span>📊</span>
                    <span>Position vs Time</span>
                </div>
                <svg class="graph-svg" id="s-t-graph" viewBox="0 0 300 200">
                    <line class="graph-axis" x1="40" y1="160" x2="280" y2="160" />
                    <line class="graph-axis" x1="40" y1="20" x2="40" y2="160" />
                    <text class="graph-label" x="150" y="190">Time (s)</text>
                    <text class="graph-label" x="5" y="90" transform="rotate(-90 5 90)">Position (m)</text>
                    <path id="s-t-line" class="graph-line" />
                    <circle id="s-t-point" class="graph-point" r="5" />
                </svg>
            </div>
        </div>
    `;
}

function animateMotion(u, v, a, s, t) {
    const container = document.getElementById('vehicle-container');
    const vehicle = document.getElementById('vehicle');

    if (!container || !vehicle) return;

    // Animate vehicle
    const duration = Math.min(t * 0.5, 2);
    setTimeout(() => {
        container.style.transition = `left ${duration}s ease-out`;
        container.style.left = 'calc(100% - 80px)';
    }, 50);

    // Update vehicle icon
    const vKmh = v * 3.6;
    if (vKmh < 10) vehicle.textContent = '🚶';
    else if (vKmh < 30) vehicle.textContent = '🚲';
    else if (vKmh < 60) vehicle.textContent = '🚗';
    else if (vKmh < 120) vehicle.textContent = '🏎️';
    else vehicle.textContent = '✈️';

    // Draw graphs
    drawGraphs(u, v, a, s, t);
}

function drawGraphs(u, v, a, s, t) {
    const graphWidth = 240;
    const graphHeight = 140;
    const xOffset = 40;
    const yOffset = 20;

    // Velocity-Time graph: v(t) = u + at (linear)
    const vtLine = document.getElementById('v-t-line');
    const vtPoint = document.getElementById('v-t-point');

    if (vtLine && vtPoint) {
        // Find min and max velocity for proper scaling
        const minV = Math.min(u, v, 0);
        const maxV = Math.max(u, v, 0);
        const rangeV = Math.max(maxV - minV, 0.1); // Avoid division by zero

        // Map velocity to Y coordinate (higher velocity = higher on graph)
        const velocityToY = (vel) => {
            return yOffset + graphHeight - ((vel - minV) / rangeV) * graphHeight;
        };

        const y1 = velocityToY(u);
        const y2 = velocityToY(v);

        vtLine.setAttribute('d', `M ${xOffset} ${y1} L ${xOffset + graphWidth} ${y2}`);
        vtPoint.setAttribute('cx', xOffset);
        vtPoint.setAttribute('cy', y1);

        // Add zero line if velocity crosses zero
        const vtGraph = document.getElementById('v-t-graph');
        const existingZeroLine = vtGraph?.querySelector('.zero-line');
        if (existingZeroLine) existingZeroLine.remove();

        if (minV < 0 && maxV > 0 && vtGraph) {
            const zeroY = velocityToY(0);
            const zeroLine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            zeroLine.setAttribute('class', 'zero-line');
            zeroLine.setAttribute('x1', xOffset);
            zeroLine.setAttribute('y1', zeroY);
            zeroLine.setAttribute('x2', xOffset + graphWidth);
            zeroLine.setAttribute('y2', zeroY);
            zeroLine.setAttribute('stroke', '#94a3b8');
            zeroLine.setAttribute('stroke-width', '1');
            zeroLine.setAttribute('stroke-dasharray', '4 4');
            vtGraph.appendChild(zeroLine);
        }
    }

    // Position-Time graph: s(t) = ut + ½at² (parabolic)
    const stLine = document.getElementById('s-t-line');
    const stPoint = document.getElementById('s-t-point');

    if (stLine && stPoint) {
        // Calculate all positions to find true min/max
        const steps = 30;
        const positions = [];
        for (let i = 0; i <= steps; i++) {
            const time = (t * i) / steps;
            const pos = (u * time) + (0.5 * a * time * time);
            positions.push({ time, pos });
        }

        // Find min and max position for proper scaling
        const allPos = positions.map(p => p.pos);
        const minS = Math.min(...allPos, 0);
        const maxS = Math.max(...allPos, 0);
        const rangeS = Math.max(maxS - minS, 0.1); // Avoid division by zero

        // Map position to Y coordinate
        const positionToY = (pos) => {
            return yOffset + graphHeight - ((pos - minS) / rangeS) * graphHeight;
        };

        // Build path
        let pathData = `M ${xOffset} ${positionToY(0)}`;
        for (let i = 1; i <= steps; i++) {
            const x = xOffset + (positions[i].time / t) * graphWidth;
            const y = positionToY(positions[i].pos);
            pathData += ` L ${x} ${y}`;
        }

        stLine.setAttribute('d', pathData);
        stPoint.setAttribute('cx', xOffset);
        stPoint.setAttribute('cy', positionToY(0));

        // Add zero line if position crosses zero
        const stGraph = document.getElementById('s-t-graph');
        const existingZeroLine = stGraph?.querySelector('.zero-line');
        if (existingZeroLine) existingZeroLine.remove();

        if (minS < 0 && maxS > 0 && stGraph) {
            const zeroY = positionToY(0);
            const zeroLine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            zeroLine.setAttribute('class', 'zero-line');
            zeroLine.setAttribute('x1', xOffset);
            zeroLine.setAttribute('y1', zeroY);
            zeroLine.setAttribute('x2', xOffset + graphWidth);
            zeroLine.setAttribute('y2', zeroY);
            zeroLine.setAttribute('stroke', '#94a3b8');
            zeroLine.setAttribute('stroke-width', '1');
            zeroLine.setAttribute('stroke-dasharray', '4 4');
            stGraph.appendChild(zeroLine);
        }
    }
}

// Initialize
window.addEventListener('DOMContentLoaded', () => {
    updateInputs();
});
