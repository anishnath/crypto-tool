// Educational Velocity Calculator - Interactive Learning

let currentMode = 'velocity';

// Unit conversion constants
const distanceToMeters = {
    'm': 1,
    'km': 1000,
    'mi': 1609.34,
    'ft': 0.3048
};

const timeToSeconds = {
    's': 1,
    'min': 60,
    'h': 3600
};

const velocityToMS = {
    'm/s': 1,
    'km/h': 1 / 3.6,
    'mph': 0.44704,
    'ft/s': 0.3048
};

// Smart number formatting - shows appropriate decimal places
function formatNumber(num) {
    if (num === 0) return '0';
    const absNum = Math.abs(num);

    if (absNum >= 1000) return num.toFixed(0);      // 1234
    if (absNum >= 100) return num.toFixed(1);       // 123.4
    if (absNum >= 10) return num.toFixed(2);        // 12.34
    if (absNum >= 1) return num.toFixed(2);         // 1.23
    if (absNum >= 0.01) return num.toFixed(4);      // 0.1234
    return num.toExponential(2);                     // 1.23e-5
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
    document.getElementById('distance-inputs').style.display = mode === 'distance' ? 'block' : 'none';
    document.getElementById('time-inputs').style.display = mode === 'time' ? 'block' : 'none';

    // Recalculate
    calculate();
}

// Main calculation function
function calculate() {
    if (currentMode === 'velocity') {
        calculateVelocity();
    } else if (currentMode === 'distance') {
        calculateDistance();
    } else {
        calculateTime();
    }
}

// Calculate Velocity
function calculateVelocity() {
    const distance = parseFloat(document.getElementById('distance').value) || 0;
    const distanceUnit = document.getElementById('distance-unit').value;
    const time = parseFloat(document.getElementById('time').value) || 1;
    const timeUnit = document.getElementById('time-unit').value;

    // Convert to base units
    const distanceM = distance * distanceToMeters[distanceUnit];
    const timeS = time * timeToSeconds[timeUnit];

    // Calculate velocity in m/s
    const velocityMS = distanceM / timeS;

    // Display results
    displayResult(velocityMS, 'velocity', {
        distance, distanceUnit, time, timeUnit
    });

    // Update visualization
    updateVisualization(distance, distanceUnit, time, timeUnit, velocityMS);
}

// Calculate Distance
function calculateDistance() {
    const velocity = parseFloat(document.getElementById('velocity-d').value) || 0;
    const velocityUnit = document.getElementById('velocity-d-unit').value;
    const time = parseFloat(document.getElementById('time-d').value) || 1;
    const timeUnit = document.getElementById('time-d-unit').value;

    // Convert to base units
    const velocityMS = velocity * velocityToMS[velocityUnit];
    const timeS = time * timeToSeconds[timeUnit];

    // Calculate distance in meters
    const distanceM = velocityMS * timeS;

    // Display results
    displayResult(distanceM, 'distance', {
        velocity, velocityUnit, time, timeUnit
    });

    // Update visualization
    updateVisualization(distanceM / 1000, 'km', time, timeUnit, velocityMS);
}

// Calculate Time
function calculateTime() {
    const distance = parseFloat(document.getElementById('distance-t').value) || 0;
    const distanceUnit = document.getElementById('distance-t-unit').value;
    const velocity = parseFloat(document.getElementById('velocity-t').value) || 1;
    const velocityUnit = document.getElementById('velocity-t-unit').value;

    // Convert to base units
    const distanceM = distance * distanceToMeters[distanceUnit];
    const velocityMS = velocity * velocityToMS[velocityUnit];

    // Calculate time in seconds
    const timeS = distanceM / velocityMS;

    // Display results
    displayResult(timeS, 'time', {
        distance, distanceUnit, velocity, velocityUnit
    });

    // Update visualization
    updateVisualization(distance, distanceUnit, timeS / 3600, 'h', velocityMS);
}

// Display result with educational formatting
function displayResult(value, type, inputs) {
    const resultValue = document.getElementById('result-value');
    const conversions = document.getElementById('conversions');
    const formulaSteps = document.getElementById('formula-steps');

    let mainResult, conversionHTML, stepsHTML;

    if (type === 'velocity') {
        const velocityKmh = value * 3.6;
        const velocityMph = value / 0.44704;

        mainResult = `${formatNumber(velocityKmh)} km/h`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">m/s</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(velocityMph)}</div>
                <div class="conversion-unit">mph</div>
            </div>
        `;

        const distM = inputs.distance * distanceToMeters[inputs.distanceUnit];
        const timeS = inputs.time * timeToSeconds[inputs.timeUnit];

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find velocity, we use: <span class="formula">v = d / t</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Distance: ${inputs.distance} ${inputs.distanceUnit} = ${formatNumber(distM)} m<br>
                    Time: ${inputs.time} ${inputs.timeUnit} = ${formatNumber(timeS)} s
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">v = ${formatNumber(distM)} m / ${formatNumber(timeS)} s</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">v = ${formatNumber(value)} m/s = ${formatNumber(velocityKmh)} km/h</span>
                </div>
            </div>
        `;
    } else if (type === 'distance') {
        const distanceKm = value / 1000;
        const distanceMi = value / 1609.34;

        mainResult = `${formatNumber(distanceKm)} km`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">meters</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(distanceMi)}</div>
                <div class="conversion-unit">miles</div>
            </div>
        `;

        const velMS = inputs.velocity * velocityToMS[inputs.velocityUnit];
        const timeS = inputs.time * timeToSeconds[inputs.timeUnit];

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find distance, we use: <span class="formula">d = v × t</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Velocity: ${inputs.velocity} ${inputs.velocityUnit} = ${formatNumber(velMS)} m/s<br>
                    Time: ${inputs.time} ${inputs.timeUnit} = ${formatNumber(timeS)} s
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">d = ${formatNumber(velMS)} m/s × ${formatNumber(timeS)} s</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">d = ${formatNumber(value)} m = ${formatNumber(distanceKm)} km</span>
                </div>
            </div>
        `;
    } else { // time
        const timeMin = value / 60;
        const timeH = value / 3600;

        mainResult = `${formatNumber(timeH)} hours`;
        conversionHTML = `
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(value)}</div>
                <div class="conversion-unit">seconds</div>
            </div>
            <div class="conversion-item">
                <div class="conversion-value">${formatNumber(timeMin)}</div>
                <div class="conversion-unit">minutes</div>
            </div>
        `;

        const distM = inputs.distance * distanceToMeters[inputs.distanceUnit];
        const velMS = inputs.velocity * velocityToMS[inputs.velocityUnit];

        stepsHTML = `
            <div class="step">
                <div class="step-label">Step 1: Identify the formula</div>
                <div class="step-content">
                    To find time, we use: <span class="formula">t = d / v</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 2: Convert to standard units</div>
                <div class="step-content">
                    Distance: ${inputs.distance} ${inputs.distanceUnit} = ${formatNumber(distM)} m<br>
                    Velocity: ${inputs.velocity} ${inputs.velocityUnit} = ${formatNumber(velMS)} m/s
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 3: Substitute values</div>
                <div class="step-content">
                    <span class="formula">t = ${formatNumber(distM)} m / ${formatNumber(velMS)} m/s</span>
                </div>
            </div>
            <div class="step">
                <div class="step-label">Step 4: Calculate</div>
                <div class="step-content">
                    <span class="formula">t = ${formatNumber(value)} s = ${formatNumber(timeH)} hours</span>
                </div>
            </div>
        `;
    }

    resultValue.textContent = mainResult;
    conversions.innerHTML = conversionHTML;
    formulaSteps.innerHTML = stepsHTML;
}

// Update visualization with smooth animations
function updateVisualization(distance, distanceUnit, time, timeUnit, velocityMS) {
    const vehicleContainer = document.getElementById('vehicle-container');
    const vehicle = document.getElementById('vehicle');
    const timeViz = document.getElementById('time-viz');
    const distanceViz = document.getElementById('distance-viz');

    // Update text displays
    timeViz.textContent = `${time.toFixed(1)} ${timeUnit}`;
    distanceViz.textContent = `${distance.toFixed(1)} ${distanceUnit}`;

    // Animate vehicle
    // Reset position
    vehicleContainer.style.transition = 'none';
    vehicleContainer.style.left = '40px';

    // Force reflow
    vehicleContainer.offsetHeight;

    // Calculate animation duration (scale to 2 seconds max)
    const animDuration = Math.min(time * 0.5, 2);

    // Animate to end
    setTimeout(() => {
        vehicleContainer.style.transition = `left ${animDuration}s cubic-bezier(0.4, 0, 0.2, 1)`;
        vehicleContainer.style.left = 'calc(100% - 100px)';
    }, 50);

    // Update vehicle icon based on speed
    const velocityKmh = velocityMS * 3.6;
    if (velocityKmh < 10) {
        vehicle.textContent = '🚶';
    } else if (velocityKmh < 30) {
        vehicle.textContent = '🚴';
    } else if (velocityKmh < 100) {
        vehicle.textContent = '🚗';
    } else if (velocityKmh < 300) {
        vehicle.textContent = '🚄';
    } else {
        vehicle.textContent = '✈️';
    }

    // Update graphs
    updateGraphs(velocityMS, distance, time);
}

// Update interactive graphs for constant velocity
function updateGraphs(velocityMS, distance, time) {
    const graphWidth = 240; // 280 - 40 (margins)
    const graphHeight = 140; // 160 - 20 (margins)
    const xOffset = 40;
    const yOffset = 20;

    // Velocity-Time Graph (horizontal line for constant velocity)
    const vtLine = document.getElementById('v-t-line');
    const vtPoint = document.getElementById('v-t-point');

    if (vtLine && vtPoint) {
        // Constant velocity = horizontal line
        const y = yOffset + graphHeight / 2; // Middle of graph
        vtLine.setAttribute('d', `M ${xOffset} ${y} L ${xOffset + graphWidth} ${y}`);
        vtPoint.setAttribute('cx', xOffset);
        vtPoint.setAttribute('cy', y);
    }

    // Position-Time Graph (diagonal line for constant velocity)
    const stLine = document.getElementById('s-t-line');
    const stPoint = document.getElementById('s-t-point');

    if (stLine && stPoint) {
        // Linear relationship: s = vt
        const x1 = xOffset;
        const y1 = yOffset + graphHeight;
        const x2 = xOffset + graphWidth;
        const y2 = yOffset;

        stLine.setAttribute('d', `M ${x1} ${y1} L ${x2} ${y2}`);
        stPoint.setAttribute('cx', x1);
        stPoint.setAttribute('cy', y1);
    }
}

// Load example
function loadExample(num) {
    const examples = {
        1: { mode: 'velocity', distance: 100, distanceUnit: 'km', time: 2, timeUnit: 'h' },
        2: { mode: 'velocity', distance: 5, distanceUnit: 'km', time: 30, timeUnit: 'min' },
        3: { mode: 'velocity', distance: 900, distanceUnit: 'km', time: 1, timeUnit: 'h' },
        4: { mode: 'velocity', distance: 20, distanceUnit: 'km', time: 1, timeUnit: 'h' }
    };

    const ex = examples[num];

    // Set mode if different
    if (currentMode !== ex.mode) {
        document.querySelectorAll('.mode-btn').forEach((btn, idx) => {
            if ((idx === 0 && ex.mode === 'velocity') ||
                (idx === 1 && ex.mode === 'distance') ||
                (idx === 2 && ex.mode === 'time')) {
                btn.click();
            }
        });
    }

    // Set values
    document.getElementById('distance').value = ex.distance;
    document.getElementById('distance-unit').value = ex.distanceUnit;
    document.getElementById('time').value = ex.time;
    document.getElementById('time-unit').value = ex.timeUnit;

    // Calculate
    calculate();
}

// Initialize on load
window.addEventListener('DOMContentLoaded', () => {
    calculate();
});
