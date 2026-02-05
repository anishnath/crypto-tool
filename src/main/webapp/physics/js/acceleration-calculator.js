// Acceleration Calculator - Kinematic Equations

let currentMode = 'velocity';

// Unit conversion constants
const velocityToMS = {
    'm/s': 1,
    'km/h': 1 / 3.6,
    'mph': 0.44704
};

const accelerationToMS2 = {
    'm/s²': 1,
    'km/h²': 1 / 12960 // (1000m/3600s)²
};

const timeToSeconds = {
    's': 1,
    'min': 60,
    'h': 3600
};

const distanceToMeters = {
    'm': 1,
    'km': 1000,
    'mi': 1609.34,
    'ft': 0.3048
};

// Smart number formatting
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

// Set calculation mode
function setMode(mode) {
    currentMode = mode;

    // Update button states
    document.querySelectorAll('.mode-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.classList.add('active');

    // Show/hide input panels
    document.getElementById('velocity-inputs').style.display = mode === 'velocity' ? 'block' : 'none';
    document.getElementById('velocity-no-time-inputs').style.display = mode === 'velocity-no-time' ? 'block' : 'none';
    document.getElementById('distance-inputs').style.display = mode === 'distance' ? 'block' : 'none';
    document.getElementById('distance-avg-inputs').style.display = mode === 'distance-avg' ? 'block' : 'none';
    document.getElementById('avg-velocity-inputs').style.display = mode === 'avg-velocity' ? 'block' : 'none';

    // Recalculate
    calculate();
}

// Main calculation function
function calculate() {
    if (currentMode === 'velocity') {
        calculateFinalVelocity();
    } else if (currentMode === 'velocity-no-time') {
        calculateFinalVelocityNoTime();
    } else if (currentMode === 'distance') {
        calculateDistance();
    } else if (currentMode === 'distance-avg') {
        calculateDistanceAvg();
    } else if (currentMode === 'avg-velocity') {
        calculateAvgVelocity();
    }
}

// Calculate Final Velocity (v = u + at)
function calculateFinalVelocity() {
    const u = parseFloat(document.getElementById('initial-velocity').value) || 0;
    const uUnit = document.getElementById('initial-velocity-unit').value;
    const a = parseFloat(document.getElementById('acceleration').value) || 0;
    const aUnit = document.getElementById('acceleration-unit').value;
    const t = parseFloat(document.getElementById('time').value) || 1;
    const tUnit = document.getElementById('time-unit').value;

    // Convert to base units
    const uMS = u * velocityToMS[uUnit];
    const aMS2 = a * accelerationToMS2[aUnit];
    const tS = t * timeToSeconds[tUnit];

    // Calculate: v = u + at
    const vMS = uMS + (aMS2 * tS);

    // Display results
    displayResult(vMS, 'velocity', {
        u, uUnit, a, aUnit, t, tUnit, uMS, aMS2, tS
    });

    // Update visualization
    updateVisualization(uMS, vMS, aMS2, tS);
}

// Calculate Distance (s = ut + ½at²)
function calculateDistance() {
    const u = parseFloat(document.getElementById('initial-velocity-d').value) || 0;
    const uUnit = document.getElementById('initial-velocity-d-unit').value;
    const a = parseFloat(document.getElementById('acceleration-d').value) || 0;
    const aUnit = document.getElementById('acceleration-d-unit').value;
    const t = parseFloat(document.getElementById('time-d').value) || 1;
    const tUnit = document.getElementById('time-d-unit').value;

    // Convert to base units
    const uMS = u * velocityToMS[uUnit];
    const aMS2 = a * accelerationToMS2[aUnit];
    const tS = t * timeToSeconds[tUnit];

    // Calculate: s = ut + ½at²
    const sM = (uMS * tS) + (0.5 * aMS2 * tS * tS);

    // Display results
    displayResult(sM, 'distance', {
        u, uUnit, a, aUnit, t, tUnit, uMS, aMS2, tS
    });

    // Calculate final velocity for visualization
    const vMS = uMS + (aMS2 * tS);
    updateVisualization(uMS, vMS, aMS2, tS);
}

// Calculate Final Velocity without time (v² = u² + 2as)
function calculateFinalVelocityNoTime() {
    const u = parseFloat(document.getElementById('initial-velocity-vnt').value) || 0;
    const uUnit = document.getElementById('initial-velocity-vnt-unit').value;
    const a = parseFloat(document.getElementById('acceleration-vnt').value) || 0;
    const aUnit = document.getElementById('acceleration-vnt-unit').value;
    const s = parseFloat(document.getElementById('distance-vnt').value) || 1;
    const sUnit = document.getElementById('distance-vnt-unit').value;

    // Convert to base units
    const uMS = u * velocityToMS[uUnit];
    const aMS2 = a * accelerationToMS2[aUnit];
    const sM = s * distanceToMeters[sUnit];

    // Calculate: v² = u² + 2as, so v = √(u² + 2as)
    const vSquared = (uMS * uMS) + (2 * aMS2 * sM);
    const vMS = vSquared >= 0 ? Math.sqrt(vSquared) : 0;

    // Display results
    displayResult(vMS, 'velocity-no-time', {
        u, uUnit, a, aUnit, s, sUnit, uMS, aMS2, sM
    });

    // Calculate time for visualization: t = (v - u) / a
    const tS = aMS2 !== 0 ? (vMS - uMS) / aMS2 : 1;
    updateVisualization(uMS, vMS, aMS2, Math.abs(tS));
}

// Calculate Distance using average velocity (s = ½(u+v)t)
function calculateDistanceAvg() {
    const u = parseFloat(document.getElementById('initial-velocity-da').value) || 0;
    const uUnit = document.getElementById('initial-velocity-da-unit').value;
    const v = parseFloat(document.getElementById('final-velocity-da').value) || 0;
    const vUnit = document.getElementById('final-velocity-da-unit').value;
    const t = parseFloat(document.getElementById('time-da').value) || 1;
    const tUnit = document.getElementById('time-da-unit').value;

    // Convert to base units
    const uMS = u * velocityToMS[uUnit];
    const vMS = v * velocityToMS[vUnit];
    const tS = t * timeToSeconds[tUnit];

    // Calculate: s = ½(u + v)t
    const sM = 0.5 * (uMS + vMS) * tS;

    // Display results
    displayResult(sM, 'distance-avg', {
        u, uUnit, v, vUnit, t, tUnit, uMS, vMS, tS
    });

    // Calculate acceleration for visualization: a = (v - u) / t
    const aMS2 = tS !== 0 ? (vMS - uMS) / tS : 0;
    updateVisualization(uMS, vMS, aMS2, tS);
}

// Calculate Average Velocity (v_avg = (u+v)/2)
function calculateAvgVelocity() {
    const u = parseFloat(document.getElementById('initial-velocity-av').value) || 0;
    const uUnit = document.getElementById('initial-velocity-av-unit').value;
    const v = parseFloat(document.getElementById('final-velocity-av').value) || 0;
    const vUnit = document.getElementById('final-velocity-av-unit').value;

    // Convert to base units
    const uMS = u * velocityToMS[uUnit];
    const vMS = v * velocityToMS[vUnit];

    // Calculate: v_avg = (u + v) / 2
    const vAvgMS = (uMS + vMS) / 2;

    // Display results
    displayResult(vAvgMS, 'avg-velocity', {
        u, uUnit, v, vUnit, uMS, vMS
    });

    // For visualization, assume constant acceleration over 10 seconds
    const tS = 10;
    const aMS2 = (vMS - uMS) / tS;
    updateVisualization(uMS, vMS, aMS2, tS);
}

// Display result with educational formatting
function displayResult(value, type, inputs) {
    const resultValue = document.getElementById('result-value');
    const conversions = document.getElementById('conversions');
    const formulaSteps = document.getElementById('formula-steps');

    let mainResult, conversionHTML, stepsHTML;

    if (type === 'velocity') {
        const vKmh = value * 3.6;
        const vMph = value / 0.44704;

        mainResult = `${formatNumber(vKmh)} km/h`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">m/s</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(vMph)}</div>
                <div class="conversion-unit">mph</div>
            </div>
        `;

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find final velocity: <span class="formula">v = u + at</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Initial velocity: ${inputs.u} ${inputs.uUnit} = ${formatNumber(inputs.uMS)} m/s<br>
                    Acceleration: ${inputs.a} ${inputs.aUnit} = ${formatNumber(inputs.aMS2)} m/s²<br>
                    Time: ${inputs.t} ${inputs.tUnit} = ${formatNumber(inputs.tS)} s
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">v = ${formatNumber(inputs.uMS)} + (${formatNumber(inputs.aMS2)} × ${formatNumber(inputs.tS)})</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">v = ${formatNumber(value)} m/s = ${formatNumber(vKmh)} km/h</span>
                </div>
            </div>
        `;
    } else if (type === 'velocity-no-time') {
        const vKmh = value * 3.6;
        const vMph = value / 0.44704;

        mainResult = `${formatNumber(vKmh)} km/h`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">m/s</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(vMph)}</div>
                <div class="conversion-unit">mph</div>
            </div>
        `;

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find final velocity (no time): <span class="formula">v² = u² + 2as</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Initial velocity: ${inputs.u} ${inputs.uUnit} = ${formatNumber(inputs.uMS)} m/s<br>
                    Acceleration: ${inputs.a} ${inputs.aUnit} = ${formatNumber(inputs.aMS2)} m/s²<br>
                    Distance: ${inputs.s} ${inputs.sUnit} = ${formatNumber(inputs.sM)} m
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">v² = ${formatNumber(inputs.uMS)}² + (2 × ${formatNumber(inputs.aMS2)} × ${formatNumber(inputs.sM)})</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">v = √(${formatNumber(inputs.uMS * inputs.uMS + 2 * inputs.aMS2 * inputs.sM)}) = ${formatNumber(value)} m/s = ${formatNumber(vKmh)} km/h</span>
                </div>
            </div>
        `;
    } else if (type === 'distance-avg') {
        const sKm = value / 1000;
        const sMi = value / 1609.34;

        mainResult = `${formatNumber(sKm)} km`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">meters</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(sMi)}</div>
                <div class="conversion-unit">miles</div>
            </div>
        `;

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find distance (average velocity): <span class="formula">s = ½(u + v)t</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Initial velocity: ${inputs.u} ${inputs.uUnit} = ${formatNumber(inputs.uMS)} m/s<br>
                    Final velocity: ${inputs.v} ${inputs.vUnit} = ${formatNumber(inputs.vMS)} m/s<br>
                    Time: ${inputs.t} ${inputs.tUnit} = ${formatNumber(inputs.tS)} s
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">s = ½(${formatNumber(inputs.uMS)} + ${formatNumber(inputs.vMS)}) × ${formatNumber(inputs.tS)}</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">s = ${formatNumber(value)} m = ${formatNumber(sKm)} km</span>
                </div>
            </div>
        `;
    } else if (type === 'avg-velocity') {
        const vKmh = value * 3.6;
        const vMph = value / 0.44704;

        mainResult = `${formatNumber(vKmh)} km/h`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">m/s</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(vMph)}</div>
                <div class="conversion-unit">mph</div>
            </div>
        `;

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find average velocity: <span class="formula">v_avg = (u + v) / 2</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Initial velocity: ${inputs.u} ${inputs.uUnit} = ${formatNumber(inputs.uMS)} m/s<br>
                    Final velocity: ${inputs.v} ${inputs.vUnit} = ${formatNumber(inputs.vMS)} m/s
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">v_avg = (${formatNumber(inputs.uMS)} + ${formatNumber(inputs.vMS)}) / 2</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">v_avg = ${formatNumber(value)} m/s = ${formatNumber(vKmh)} km/h</span>
                </div>
            </div>
        `;
    } else { // distance (original)
        const sKm = value / 1000;
        const sMi = value / 1609.34;

        mainResult = `${formatNumber(sKm)} km`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">meters</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(sMi)}</div>
                <div class="conversion-unit">miles</div>
            </div>
        `;

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find distance: <span class="formula">s = ut + ½at²</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Initial velocity: ${inputs.u} ${inputs.uUnit} = ${formatNumber(inputs.uMS)} m/s<br>
                    Acceleration: ${inputs.a} ${inputs.aUnit} = ${formatNumber(inputs.aMS2)} m/s²<br>
                    Time: ${inputs.t} ${inputs.tUnit} = ${formatNumber(inputs.tS)} s
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">s = (${formatNumber(inputs.uMS)} × ${formatNumber(inputs.tS)}) + (½ × ${formatNumber(inputs.aMS2)} × ${formatNumber(inputs.tS)}²)</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">s = ${formatNumber(value)} m = ${formatNumber(sKm)} km</span>
                </div>
            </div>
        `;
    }

    resultValue.textContent = mainResult;
    conversions.innerHTML = conversionHTML;
    formulaSteps.innerHTML = stepsHTML;
}

// Update visualization with acceleration animation
function updateVisualization(uMS, vMS, aMS2, tS) {
    const vehicleContainer = document.getElementById('vehicle-container');
    const vehicle = document.getElementById('vehicle');
    const timeViz = document.getElementById('time-viz');
    const accelViz = document.getElementById('accel-viz');

    // Update text displays
    timeViz.textContent = `${formatNumber(tS)} s`;
    accelViz.textContent = `${formatNumber(aMS2)} m/s²`;

    // Reset position
    vehicleContainer.style.transition = 'none';
    vehicleContainer.style.left = '40px';

    // Force reflow
    vehicleContainer.offsetHeight;

    // Calculate animation duration (scale to 2 seconds max)
    const animDuration = Math.min(tS * 0.2, 2);

    // Use ease-in for acceleration (starts slow, speeds up)
    const timingFunction = aMS2 > 0 ? 'cubic-bezier(0.42, 0, 1, 1)' : 'cubic-bezier(0, 0, 0.58, 1)';

    // Animate to end
    setTimeout(() => {
        vehicleContainer.style.transition = `left ${animDuration}s ${timingFunction}`;
        vehicleContainer.style.left = 'calc(100% - 100px)';
    }, 50);

    // Update vehicle icon based on final speed
    const vKmh = vMS * 3.6;
    if (vKmh < 10) {
        vehicle.textContent = '🚶';
    } else if (vKmh < 30) {
        vehicle.textContent = '🚴';
    } else if (vKmh < 100) {
        vehicle.textContent = '🚗';
    } else if (vKmh < 300) {
        vehicle.textContent = '🚄';
    } else {
        vehicle.textContent = '✈️';
    }

    // Update graphs
    updateGraphs(uMS, vMS, aMS2, tS);
}

// Update interactive graphs
function updateGraphs(uMS, vMS, aMS2, tS) {
    const graphWidth = 240; // 280 - 40 (margins)
    const graphHeight = 140; // 160 - 20 (margins)
    const xOffset = 40;
    const yOffset = 20;

    // Velocity-Time Graph
    const vtLine = document.getElementById('v-t-line');
    const vtPoint = document.getElementById('v-t-point');

    if (vtLine && vtPoint) {
        // Calculate points
        const x1 = xOffset;
        const y1 = yOffset + graphHeight - (uMS / Math.max(vMS, 1)) * graphHeight;
        const x2 = xOffset + graphWidth;
        const y2 = yOffset + graphHeight - (vMS / Math.max(vMS, 1)) * graphHeight;

        // Draw line: v = u + at (linear)
        vtLine.setAttribute('d', `M ${x1} ${y1} L ${x2} ${y2}`);
        vtPoint.setAttribute('cx', x1);
        vtPoint.setAttribute('cy', y1);
    }

    // Position-Time Graph
    const stLine = document.getElementById('s-t-line');
    const stPoint = document.getElementById('s-t-point');

    if (stLine && stPoint) {
        // Calculate final position: s = ut + ½at²
        const sM = (uMS * tS) + (0.5 * aMS2 * tS * tS);
        const maxS = Math.max(sM, 1);

        // Generate parabolic path for s = ut + ½at²
        let pathData = `M ${xOffset} ${yOffset + graphHeight}`;

        const steps = 20;
        for (let i = 1; i <= steps; i++) {
            const t = (tS * i) / steps;
            const s = (uMS * t) + (0.5 * aMS2 * t * t);
            const x = xOffset + (t / tS) * graphWidth;
            const y = yOffset + graphHeight - (s / maxS) * graphHeight;
            pathData += ` L ${x} ${y}`;
        }

        stLine.setAttribute('d', pathData);
        stPoint.setAttribute('cx', xOffset);
        stPoint.setAttribute('cy', yOffset + graphHeight);
    }
}

// Load example
function loadExample(num) {
    const examples = {
        1: { mode: 'velocity', u: 0, uUnit: 'km/h', a: 2.78, aUnit: 'm/s²', t: 10, tUnit: 's' }, // 0 to 100 km/h
        2: { mode: 'distance', u: 0, uUnit: 'm/s', a: 9.8, aUnit: 'm/s²', t: 3, tUnit: 's' } // Free fall
    };

    const ex = examples[num];

    // Set mode if different
    if (currentMode !== ex.mode) {
        document.querySelectorAll('.mode-btn').forEach((btn, idx) => {
            if ((idx === 0 && ex.mode === 'velocity') ||
                (idx === 1 && ex.mode === 'distance')) {
                btn.click();
            }
        });
    }

    // Set values based on mode
    if (ex.mode === 'velocity') {
        document.getElementById('initial-velocity').value = ex.u;
        document.getElementById('initial-velocity-unit').value = ex.uUnit;
        document.getElementById('acceleration').value = ex.a;
        document.getElementById('acceleration-unit').value = ex.aUnit;
        document.getElementById('time').value = ex.t;
        document.getElementById('time-unit').value = ex.tUnit;
    } else {
        document.getElementById('initial-velocity-d').value = ex.u;
        document.getElementById('initial-velocity-d-unit').value = ex.uUnit;
        document.getElementById('acceleration-d').value = ex.a;
        document.getElementById('acceleration-d-unit').value = ex.aUnit;
        document.getElementById('time-d').value = ex.t;
        document.getElementById('time-d-unit').value = ex.tUnit;
    }

    // Calculate
    calculate();
}

// Initialize on load
window.addEventListener('DOMContentLoaded', () => {
    calculate();
});
