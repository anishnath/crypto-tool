// Projectile Motion Calculator - Physics Simulation with Matter.js
// Formulas:
// - x(t) = v₀·cos(θ)·t
// - y(t) = v₀·sin(θ)·t - ½gt²
// - Range: R = v₀²·sin(2θ)/g
// - Max Height: H = v₀²·sin²(θ)/(2g)
// - Time of Flight: T = 2·v₀·sin(θ)/g

let animationId = null;
let showTrail = true;
let trailPoints = [];
let outputUnit = 'm';
let stepsExpanded = false;

// Matter.js modules
let Engine, Runner, Bodies, Body, Composite, Events;
let engine, runner;
let projectileBody;
let groundBody;
let useMatterJS = false;
let matterInitialized = false;

// Unit conversion constants (to SI units)
const velocityConversions = {
    'm/s': 1,
    'km/h': 1 / 3.6,
    'ft/s': 0.3048,
    'mph': 0.44704
};

const gravityConversions = {
    'm/s²': 1,
    'ft/s²': 0.3048
};

// Output distance conversions (from meters)
const distanceConversions = {
    'm': { factor: 1, symbol: 'm', name: 'meters' },
    'ft': { factor: 3.28084, symbol: 'ft', name: 'feet' },
    'yd': { factor: 1.09361, symbol: 'yd', name: 'yards' },
    'km': { factor: 0.001, symbol: 'km', name: 'kilometers' },
    'mi': { factor: 0.000621371, symbol: 'mi', name: 'miles' }
};

// DOM Elements
let velocityInput, angleSlider, angleValue, gravityInput, canvas, ctx, projectile, launcher;
let velocityUnitSelect, gravityUnitSelect;

// Current calculated values
let currentV0 = 20;
let currentTheta = Math.PI / 4;
let currentG = 9.8;
let currentRange = 0;
let currentMaxHeight = 0;
let currentFlightTime = 0;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    velocityInput = document.getElementById('velocity');
    angleSlider = document.getElementById('angle');
    angleValue = document.getElementById('angle-value');
    gravityInput = document.getElementById('gravity');
    canvas = document.getElementById('trajectory-canvas');
    ctx = canvas.getContext('2d');
    projectile = document.getElementById('projectile');
    launcher = document.getElementById('launcher');
    velocityUnitSelect = document.getElementById('velocity-unit');
    gravityUnitSelect = document.getElementById('gravity-unit');

    setupCanvas();
    setupEventListeners();

    // Initialize Matter.js if available
    if (typeof Matter !== 'undefined') {
        initMatterJS();
    }

    calculate();
    drawInitialState();
});

function initMatterJS() {
    Engine = Matter.Engine;
    Runner = Matter.Runner;
    Bodies = Matter.Bodies;
    Body = Matter.Body;
    Composite = Matter.Composite;
    Events = Matter.Events;

    // Create engine with gravity
    engine = Engine.create({
        gravity: { x: 0, y: 1 } // Positive y is down in Matter.js
    });

    runner = Runner.create();
    matterInitialized = true;

    createMatterBodies();

    // Listen for collisions
    Events.on(engine, 'collisionStart', (event) => {
        const pairs = event.pairs;
        for (let pair of pairs) {
            if (pair.bodyA.label === 'projectile' || pair.bodyB.label === 'projectile') {
                showBounceEffect();
            }
        }
    });
}

function createMatterBodies() {
    if (!engine) return;

    Composite.clear(engine.world);

    const groundY = canvas.height * 0.60;

    // Create ground (static)
    groundBody = Bodies.rectangle(canvas.width / 2, groundY + 25, canvas.width * 2, 50, {
        isStatic: true,
        friction: 0.5,
        restitution: 0.6, // Bouncy ground
        render: { visible: false },
        label: 'ground'
    });

    // Create projectile
    projectileBody = Bodies.circle(50, groundY - 15, 15, {
        mass: 1,
        friction: 0.01,
        frictionAir: 0.001, // Small air resistance
        restitution: 0.7, // Bouncy ball
        render: { visible: false },
        label: 'projectile'
    });

    Composite.add(engine.world, [groundBody, projectileBody]);
}

function setupCanvas() {
    const container = document.getElementById('trajectory-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;

    window.addEventListener('resize', () => {
        canvas.width = container.offsetWidth;
        canvas.height = container.offsetHeight;
        if (matterInitialized) {
            createMatterBodies();
        }
        if (!animationId) {
            drawInitialState();
        }
    });
}

function setupEventListeners() {
    angleSlider.addEventListener('input', () => {
        angleValue.textContent = angleSlider.value + '°';
        updateLauncherAngle();
        calculate();
    });

    velocityInput.addEventListener('input', calculate);
    gravityInput.addEventListener('input', calculate);
}

function setAngle(angle) {
    angleSlider.value = angle;
    angleValue.textContent = angle + '°';
    updateLauncherAngle();
    calculate();

    document.querySelectorAll('.angle-preset').forEach(btn => {
        btn.classList.remove('optimal');
        if (btn.textContent.includes(angle + '°')) {
            btn.classList.add('optimal');
        }
    });
}

function updateLauncherAngle() {
    const angle = parseFloat(angleSlider.value);
    launcher.style.transform = `rotate(-${angle}deg)`;
}

function calculate() {
    const v0Input = parseFloat(velocityInput.value) || 20;
    const angleDeg = parseFloat(angleSlider.value) || 45;
    const theta = angleDeg * Math.PI / 180;
    const gInput = parseFloat(gravityInput.value) || 9.8;

    const vUnit = velocityUnitSelect ? velocityUnitSelect.value : 'm/s';
    const gUnit = gravityUnitSelect ? gravityUnitSelect.value : 'm/s²';

    // Convert to SI units
    const v0 = v0Input * velocityConversions[vUnit];
    const g = gInput * gravityConversions[gUnit];

    // Store current values
    currentV0 = v0;
    currentTheta = theta;
    currentG = g;

    // Calculate results
    const range = (v0 * v0 * Math.sin(2 * theta)) / g;
    const maxHeight = (v0 * v0 * Math.sin(theta) * Math.sin(theta)) / (2 * g);
    const flightTime = (2 * v0 * Math.sin(theta)) / g;

    currentRange = range;
    currentMaxHeight = maxHeight;
    currentFlightTime = flightTime;

    // Get output unit conversion
    const outConv = distanceConversions[outputUnit];

    // Update display
    const rangeDisplay = range * outConv.factor;
    const heightDisplay = maxHeight * outConv.factor;

    document.getElementById('result-range').textContent = formatNumber(rangeDisplay) + ' ' + outConv.symbol;
    document.getElementById('result-height').textContent = formatNumber(heightDisplay) + ' ' + outConv.symbol;
    document.getElementById('result-time').textContent = formatNumber(flightTime) + ' s';

    document.getElementById('range-marker').textContent = formatNumber(rangeDisplay) + ' ' + outConv.symbol;
    document.getElementById('height-marker').textContent = 'Max: ' + formatNumber(heightDisplay) + ' ' + outConv.symbol;

    const heightPercent = Math.min(maxHeight / (maxHeight + 10) * 40 + 40, 90);
    document.getElementById('height-marker').style.bottom = heightPercent + '%';

    // Update Matter.js gravity
    if (engine) {
        const scaledG = g / 9.8; // Normalize to Earth gravity
        engine.gravity.y = scaledG;
    }

    generateStepByStep(v0Input, vUnit, angleDeg, gInput, gUnit, v0, g, range, maxHeight, flightTime);
    drawPredictedTrajectory(v0, theta, g, range, maxHeight, flightTime);
    drawGraphs(v0, theta, g, flightTime, range, maxHeight);

    return { v0, theta, g, range, maxHeight, flightTime };
}

function formatNumber(num) {
    if (Math.abs(num) >= 100) return num.toFixed(1);
    if (Math.abs(num) >= 10) return num.toFixed(2);
    return num.toFixed(3);
}

function formatPrecise(num) {
    if (Math.abs(num) >= 1000) return num.toFixed(1);
    if (Math.abs(num) >= 100) return num.toFixed(2);
    if (Math.abs(num) >= 10) return num.toFixed(3);
    return num.toFixed(4);
}

function setOutputUnit(unit) {
    outputUnit = unit;

    document.querySelectorAll('.unit-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.unit === unit) {
            btn.classList.add('active');
        }
    });

    calculate();
}

function onUnitChange() {
    calculate();
}

function setGravity(value, unit) {
    gravityInput.value = value;
    if (gravityUnitSelect) {
        gravityUnitSelect.value = unit;
    }
    calculate();
}

function toggleSteps() {
    const stepsBody = document.getElementById('steps-body');
    const stepsToggle = document.getElementById('steps-toggle');

    stepsExpanded = !stepsExpanded;

    if (stepsExpanded) {
        stepsBody.classList.remove('collapsed');
        stepsToggle.textContent = '▲ Hide';
    } else {
        stepsBody.classList.add('collapsed');
        stepsToggle.textContent = '▼ Show';
    }
}

function generateStepByStep(v0Input, vUnit, angleDeg, gInput, gUnit, v0SI, gSI, range, maxHeight, flightTime) {
    const stepsBody = document.getElementById('steps-body');
    if (!stepsBody) return;

    const angleRad = angleDeg * Math.PI / 180;
    const sinTheta = Math.sin(angleRad);
    const cosTheta = Math.cos(angleRad);
    const sin2Theta = Math.sin(2 * angleRad);

    const allDistanceUnits = Object.keys(distanceConversions).map(unit => {
        const conv = distanceConversions[unit];
        return {
            range: range * conv.factor,
            height: maxHeight * conv.factor,
            symbol: conv.symbol,
            name: conv.name
        };
    });

    let html = `
        <div class="step-item">
            <div class="step-title">
                <span class="step-number">1</span>
                Identify Given Values
            </div>
            <div class="step-calc">
                Initial velocity: <span class="highlight">v₀ = ${v0Input} ${vUnit}</span>
                ${vUnit !== 'm/s' ? `<br>→ Converting to SI: v₀ = ${v0Input} × ${velocityConversions[vUnit]} = <span class="highlight">${formatPrecise(v0SI)} m/s</span>` : ''}
                <br>Launch angle: <span class="highlight">θ = ${angleDeg}°</span>
                <br>→ In radians: θ = ${angleDeg} × π/180 = <span class="highlight">${formatPrecise(angleRad)} rad</span>
                <br>Gravity: <span class="highlight">g = ${gInput} ${gUnit}</span>
                ${gUnit !== 'm/s²' ? `<br>→ Converting to SI: g = ${gInput} × ${gravityConversions[gUnit]} = <span class="highlight">${formatPrecise(gSI)} m/s²</span>` : ''}
            </div>
        </div>

        <div class="step-item">
            <div class="step-title">
                <span class="step-number">2</span>
                Calculate Trigonometric Values
            </div>
            <div class="step-calc">
                sin(θ) = sin(${angleDeg}°) = <span class="highlight">${formatPrecise(sinTheta)}</span>
                <br>cos(θ) = cos(${angleDeg}°) = <span class="highlight">${formatPrecise(cosTheta)}</span>
                <br>sin(2θ) = sin(${2 * angleDeg}°) = <span class="highlight">${formatPrecise(sin2Theta)}</span>
                <br>sin²(θ) = ${formatPrecise(sinTheta)}² = <span class="highlight">${formatPrecise(sinTheta * sinTheta)}</span>
            </div>
        </div>

        <div class="step-item">
            <div class="step-title">
                <span class="step-number">3</span>
                Calculate Horizontal Range (R)
            </div>
            <div class="step-formula">R = v₀² × sin(2θ) / g</div>
            <div class="step-calc">
                R = (${formatPrecise(v0SI)})² × ${formatPrecise(sin2Theta)} / ${formatPrecise(gSI)}
                <br>R = ${formatPrecise(v0SI * v0SI)} × ${formatPrecise(sin2Theta)} / ${formatPrecise(gSI)}
                <br>R = ${formatPrecise(v0SI * v0SI * sin2Theta)} / ${formatPrecise(gSI)}
            </div>
            <div class="step-result">
                <div class="step-result-label">Range</div>
                <div class="step-result-value">${formatPrecise(range)} m</div>
                <div class="unit-conversions">
                    ${allDistanceUnits.filter(u => u.symbol !== 'm').map(u =>
                        `<div class="unit-conversion-item">
                            <span class="label">${u.name}:</span>
                            <span class="value">${formatPrecise(u.range)} ${u.symbol}</span>
                        </div>`
                    ).join('')}
                </div>
            </div>
        </div>

        <div class="step-item">
            <div class="step-title">
                <span class="step-number">4</span>
                Calculate Maximum Height (H)
            </div>
            <div class="step-formula">H = v₀² × sin²(θ) / (2g)</div>
            <div class="step-calc">
                H = (${formatPrecise(v0SI)})² × ${formatPrecise(sinTheta * sinTheta)} / (2 × ${formatPrecise(gSI)})
                <br>H = ${formatPrecise(v0SI * v0SI)} × ${formatPrecise(sinTheta * sinTheta)} / ${formatPrecise(2 * gSI)}
                <br>H = ${formatPrecise(v0SI * v0SI * sinTheta * sinTheta)} / ${formatPrecise(2 * gSI)}
            </div>
            <div class="step-result">
                <div class="step-result-label">Maximum Height</div>
                <div class="step-result-value">${formatPrecise(maxHeight)} m</div>
                <div class="unit-conversions">
                    ${allDistanceUnits.filter(u => u.symbol !== 'm').map(u =>
                        `<div class="unit-conversion-item">
                            <span class="label">${u.name}:</span>
                            <span class="value">${formatPrecise(u.height)} ${u.symbol}</span>
                        </div>`
                    ).join('')}
                </div>
            </div>
        </div>

        <div class="step-item">
            <div class="step-title">
                <span class="step-number">5</span>
                Calculate Total Flight Time (T)
            </div>
            <div class="step-formula">T = 2 × v₀ × sin(θ) / g</div>
            <div class="step-calc">
                T = 2 × ${formatPrecise(v0SI)} × ${formatPrecise(sinTheta)} / ${formatPrecise(gSI)}
                <br>T = ${formatPrecise(2 * v0SI * sinTheta)} / ${formatPrecise(gSI)}
            </div>
            <div class="step-result">
                <div class="step-result-label">Flight Time</div>
                <div class="step-result-value">${formatPrecise(flightTime)} seconds</div>
                <div class="unit-conversions">
                    <div class="unit-conversion-item">
                        <span class="label">Time to max height:</span>
                        <span class="value">${formatPrecise(flightTime / 2)} s</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="step-item">
            <div class="step-title">
                <span class="step-number">6</span>
                Velocity Components
            </div>
            <div class="step-formula">vₓ = v₀ × cos(θ)   |   vᵧ = v₀ × sin(θ)</div>
            <div class="step-calc">
                Horizontal (constant): vₓ = ${formatPrecise(v0SI)} × ${formatPrecise(cosTheta)} = <span class="highlight">${formatPrecise(v0SI * cosTheta)} m/s</span>
                <br>Initial vertical: vᵧ₀ = ${formatPrecise(v0SI)} × ${formatPrecise(sinTheta)} = <span class="highlight">${formatPrecise(v0SI * sinTheta)} m/s</span>
                <br>At max height: vᵧ = <span class="highlight">0 m/s</span> (projectile momentarily stops rising)
                <br>At landing: vᵧ = <span class="highlight">-${formatPrecise(v0SI * sinTheta)} m/s</span> (opposite direction)
            </div>
        </div>
    `;

    stepsBody.innerHTML = html;
}

function drawInitialState() {
    updateLauncherAngle();
    calculate();
}

function drawPredictedTrajectory(v0, theta, g, range, maxHeight, flightTime) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const groundY = canvas.height * 0.60;
    const startX = 40;
    const availableWidth = canvas.width - startX - 30;
    const availableHeight = groundY - 20;
    const scaleX = availableWidth / Math.max(range, 1);
    const scaleY = availableHeight / Math.max(maxHeight, 1);
    const scale = Math.min(scaleX, scaleY);

    // Draw trajectory path (dashed)
    ctx.beginPath();
    ctx.strokeStyle = 'rgba(234, 88, 12, 0.4)';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);

    const steps = 50;
    for (let i = 0; i <= steps; i++) {
        const t = (flightTime * i) / steps;
        const x = v0 * Math.cos(theta) * t;
        const y = v0 * Math.sin(theta) * t - 0.5 * g * t * t;

        const canvasX = startX + x * scale;
        const canvasY = groundY - y * scale;

        if (i === 0) {
            ctx.moveTo(canvasX, canvasY);
        } else {
            ctx.lineTo(canvasX, canvasY);
        }
    }
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw max height indicator
    const maxHeightX = startX + (range / 2) * scale;
    const maxHeightY = groundY - maxHeight * scale;

    ctx.beginPath();
    ctx.strokeStyle = 'rgba(37, 99, 235, 0.5)';
    ctx.lineWidth = 1;
    ctx.setLineDash([3, 3]);
    ctx.moveTo(maxHeightX, groundY);
    ctx.lineTo(maxHeightX, maxHeightY);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw range indicator
    ctx.beginPath();
    ctx.strokeStyle = 'rgba(5, 150, 105, 0.5)';
    ctx.setLineDash([3, 3]);
    ctx.moveTo(startX, groundY + 10);
    ctx.lineTo(startX + range * scale, groundY + 10);
    ctx.stroke();
    ctx.setLineDash([]);
}

function launch() {
    if (animationId) {
        cancelAnimationFrame(animationId);
        animationId = null;
    }

    const { v0, theta, g, range, maxHeight, flightTime } = calculate();

    if (flightTime <= 0 || range <= 0 || maxHeight <= 0) {
        console.warn('Invalid projectile parameters', { range, maxHeight, flightTime });
        return;
    }

    trailPoints = [];
    projectile.style.display = 'block';
    projectile.textContent = '⚫';

    // Use Matter.js if available
    if (matterInitialized && useMatterJS) {
        launchWithMatterJS(v0, theta, g, range, maxHeight, flightTime);
    } else {
        launchWithAnimation(v0, theta, g, range, maxHeight, flightTime);
    }
}

function launchWithMatterJS(v0, theta, g, range, maxHeight, flightTime) {
    const groundY = canvas.height * 0.60;
    const startX = 40;
    const availableWidth = canvas.width - startX - 30;
    const availableHeight = groundY - 20;
    const scaleX = availableWidth / Math.max(range, 1);
    const scaleY = availableHeight / Math.max(maxHeight, 1);
    const scale = Math.min(scaleX, scaleY);

    // Reset projectile position
    Body.setPosition(projectileBody, { x: startX, y: groundY - 15 });

    // Set velocity scaled to canvas
    const vx = v0 * Math.cos(theta) * scale * 0.5;
    const vy = -v0 * Math.sin(theta) * scale * 0.5; // Negative because y is inverted

    Body.setVelocity(projectileBody, { x: vx, y: vy });

    // Set gravity based on g value
    engine.gravity.y = g / 9.8;

    // Start physics
    Runner.run(runner, engine);

    // Start render loop
    let bounceCount = 0;
    const maxBounces = 5;

    function renderMatterLoop() {
        const pos = projectileBody.position;
        const vel = projectileBody.velocity;

        // Update projectile position
        projectile.style.left = pos.x + 'px';
        projectile.style.top = pos.y + 'px';

        // Add trail point
        if (showTrail) {
            trailPoints.push({ x: pos.x, y: pos.y });
        }

        // Convert position back to physics units
        const physX = (pos.x - startX) / scale;
        const physY = (groundY - pos.y) / scale;

        // Update info display
        document.getElementById('info-position').textContent =
            `x: ${formatNumber(physX)} m, y: ${formatNumber(Math.max(physY, 0))} m`;
        document.getElementById('info-velocity').textContent =
            `vx: ${formatNumber(vel.x / scale * 2)}, vy: ${formatNumber(-vel.y / scale * 2)} m/s`;

        // Draw frame
        drawMatterFrame(v0, theta, g, range, maxHeight, flightTime, pos.x, pos.y, scale, startX, groundY);

        // Check if stopped
        const speed = Math.sqrt(vel.x * vel.x + vel.y * vel.y);
        if (speed < 0.5 && pos.y >= groundY - 20) {
            bounceCount++;
            if (bounceCount > maxBounces) {
                Runner.stop(runner);
                projectile.textContent = '💥';
                setTimeout(() => {
                    projectile.textContent = '⚫';
                    projectile.style.display = 'none';
                }, 500);
                return;
            }
        }

        animationId = requestAnimationFrame(renderMatterLoop);
    }

    renderMatterLoop();
}

function launchWithAnimation(v0, theta, g, range, maxHeight, flightTime) {
    const groundY = canvas.height * 0.60;
    const startX = 40;
    const availableWidth = canvas.width - startX - 30;
    const availableHeight = groundY - 20;

    const scaleX = availableWidth / Math.max(range, 1);
    const scaleY = availableHeight / Math.max(maxHeight, 1);
    const scale = Math.min(scaleX, scaleY);

    const startTime = performance.now();
    const animationDuration = Math.max(Math.min(flightTime * 400, 5000), 1000);

    function animate(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / animationDuration, 1);
        const t = progress * flightTime;

        const x = v0 * Math.cos(theta) * t;
        const y = v0 * Math.sin(theta) * t - 0.5 * g * t * t;

        const vx = v0 * Math.cos(theta);
        const vy = v0 * Math.sin(theta) - g * t;

        const canvasX = startX + x * scale;
        const canvasY = groundY - Math.max(y, 0) * scale;

        projectile.style.left = canvasX + 'px';
        projectile.style.top = canvasY + 'px';

        if (showTrail && y >= -0.1) {
            trailPoints.push({ x: canvasX, y: canvasY });
        }

        drawFrame(v0, theta, g, range, maxHeight, flightTime, canvasX, canvasY, scale, startX, groundY);

        document.getElementById('info-position').textContent =
            `x: ${formatNumber(x)} m, y: ${formatNumber(Math.max(y, 0))} m`;
        document.getElementById('info-velocity').textContent =
            `vx: ${formatNumber(vx)}, vy: ${formatNumber(vy)} m/s`;
        document.getElementById('info-time').textContent = `t = ${formatNumber(t)} s`;

        if (progress < 1) {
            animationId = requestAnimationFrame(animate);
        } else {
            animationId = null;
            projectile.textContent = '💥';
            showImpactEffect(canvasX, canvasY);
            setTimeout(() => {
                projectile.textContent = '⚫';
                projectile.style.display = 'none';
            }, 500);
        }
    }

    animationId = requestAnimationFrame(animate);
}

function drawMatterFrame(v0, theta, g, range, maxHeight, flightTime, currentX, currentY, scale, startX, groundY) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Draw predicted trajectory (faded)
    ctx.beginPath();
    ctx.strokeStyle = 'rgba(234, 88, 12, 0.2)';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);

    const steps = 50;
    for (let i = 0; i <= steps; i++) {
        const t = (flightTime * i) / steps;
        const x = v0 * Math.cos(theta) * t;
        const y = v0 * Math.sin(theta) * t - 0.5 * g * t * t;

        const canvasX = startX + x * scale;
        const canvasY = groundY - y * scale;

        if (i === 0) {
            ctx.moveTo(canvasX, canvasY);
        } else {
            ctx.lineTo(canvasX, canvasY);
        }
    }
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw trail with gradient
    if (showTrail && trailPoints.length > 1) {
        for (let i = 1; i < trailPoints.length; i++) {
            const alpha = i / trailPoints.length;
            ctx.beginPath();
            ctx.strokeStyle = `rgba(234, 88, 12, ${alpha})`;
            ctx.lineWidth = 3 * alpha + 1;
            ctx.lineCap = 'round';
            ctx.moveTo(trailPoints[i - 1].x, trailPoints[i - 1].y);
            ctx.lineTo(trailPoints[i].x, trailPoints[i].y);
            ctx.stroke();
        }
    }

    // Draw ball with gradient
    drawBall(currentX, currentY);
}

function drawFrame(v0, theta, g, range, maxHeight, flightTime, currentX, currentY, scale, startX, groundY) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (!scale || !startX || !groundY) {
        groundY = canvas.height * 0.60;
        startX = 50;
        const availableWidth = canvas.width - startX - 30;
        const availableHeight = groundY - 20;
        const scaleX = availableWidth / Math.max(range, 1);
        const scaleY = availableHeight / Math.max(maxHeight, 1);
        scale = Math.min(scaleX, scaleY);
    }

    // Draw predicted trajectory (faded)
    ctx.beginPath();
    ctx.strokeStyle = 'rgba(234, 88, 12, 0.2)';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);

    const steps = 50;
    for (let i = 0; i <= steps; i++) {
        const t = (flightTime * i) / steps;
        const x = v0 * Math.cos(theta) * t;
        const y = v0 * Math.sin(theta) * t - 0.5 * g * t * t;

        const canvasX = startX + x * scale;
        const canvasY = groundY - y * scale;

        if (i === 0) {
            ctx.moveTo(canvasX, canvasY);
        } else {
            ctx.lineTo(canvasX, canvasY);
        }
    }
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw trail with gradient effect
    if (showTrail && trailPoints.length > 1) {
        for (let i = 1; i < trailPoints.length; i++) {
            const alpha = i / trailPoints.length;
            ctx.beginPath();
            ctx.strokeStyle = `rgba(234, 88, 12, ${alpha})`;
            ctx.lineWidth = 3 * alpha + 1;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            ctx.moveTo(trailPoints[i - 1].x, trailPoints[i - 1].y);
            ctx.lineTo(trailPoints[i].x, trailPoints[i].y);
            ctx.stroke();
        }
    }

    // Draw ball with 3D effect
    drawBall(currentX, currentY);

    // Draw velocity vector
    if (currentX && currentY && trailPoints.length > 0) {
        const t = trailPoints.length / 50 * flightTime;
        const vx = v0 * Math.cos(theta);
        const vy = v0 * Math.sin(theta) - g * t;
        const vScale = 2;

        ctx.beginPath();
        ctx.strokeStyle = '#2563eb';
        ctx.lineWidth = 2;
        ctx.moveTo(currentX, currentY);
        ctx.lineTo(currentX + vx * vScale, currentY - vy * vScale);
        ctx.stroke();

        // Arrow head
        const angle = Math.atan2(-vy, vx);
        ctx.beginPath();
        ctx.fillStyle = '#2563eb';
        ctx.moveTo(currentX + vx * vScale, currentY - vy * vScale);
        ctx.lineTo(
            currentX + vx * vScale - 8 * Math.cos(angle - 0.4),
            currentY - vy * vScale + 8 * Math.sin(angle - 0.4)
        );
        ctx.lineTo(
            currentX + vx * vScale - 8 * Math.cos(angle + 0.4),
            currentY - vy * vScale + 8 * Math.sin(angle + 0.4)
        );
        ctx.closePath();
        ctx.fill();
    }
}

function drawBall(x, y) {
    const radius = 12;

    // Shadow
    ctx.beginPath();
    ctx.fillStyle = 'rgba(0, 0, 0, 0.3)';
    ctx.arc(x + 3, y + 3, radius, 0, Math.PI * 2);
    ctx.fill();

    // Ball gradient
    const ballGrad = ctx.createRadialGradient(x - 3, y - 3, 0, x, y, radius);
    ballGrad.addColorStop(0, '#374151');
    ballGrad.addColorStop(0.5, '#1f2937');
    ballGrad.addColorStop(1, '#111827');

    ctx.beginPath();
    ctx.fillStyle = ballGrad;
    ctx.arc(x, y, radius, 0, Math.PI * 2);
    ctx.fill();

    // Shine
    ctx.beginPath();
    ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';
    ctx.arc(x - 3, y - 3, radius * 0.4, 0, Math.PI * 2);
    ctx.fill();
}

function showImpactEffect(x, y) {
    // Draw impact particles
    ctx.save();
    for (let i = 0; i < 8; i++) {
        const angle = (Math.PI * 2 * i) / 8;
        const dist = 20;
        ctx.beginPath();
        ctx.fillStyle = 'rgba(234, 88, 12, 0.6)';
        ctx.arc(x + Math.cos(angle) * dist, y + Math.sin(angle) * dist, 4, 0, Math.PI * 2);
        ctx.fill();
    }
    ctx.restore();
}

function showBounceEffect() {
    // Flash effect on bounce
    const pos = projectileBody.position;
    ctx.beginPath();
    ctx.fillStyle = 'rgba(234, 88, 12, 0.5)';
    ctx.arc(pos.x, pos.y, 25, 0, Math.PI * 2);
    ctx.fill();
}

function drawGraphs(v0, theta, g, flightTime, range, maxHeight) {
    drawXTGraph(v0, theta, flightTime, range);
    drawYTGraph(v0, theta, g, flightTime, maxHeight);
    drawYXGraph(v0, theta, g, range, maxHeight);
}

function drawXTGraph(v0, theta, flightTime, range) {
    const svg = document.getElementById('x-t-graph');
    const width = 200, height = 150;
    const padding = { top: 15, right: 15, bottom: 25, left: 35 };
    const graphWidth = width - padding.left - padding.right;
    const graphHeight = height - padding.top - padding.bottom;

    let html = `
        <line x1="${padding.left}" y1="${height - padding.bottom}" x2="${width - padding.right}" y2="${height - padding.bottom}" stroke="var(--text-tertiary)" stroke-width="1"/>
        <line x1="${padding.left}" y1="${padding.top}" x2="${padding.left}" y2="${height - padding.bottom}" stroke="var(--text-tertiary)" stroke-width="1"/>
        <text x="${width/2}" y="${height - 5}" fill="var(--text-secondary)" font-size="10" text-anchor="middle">Time (s)</text>
        <text x="10" y="${height/2}" fill="var(--text-secondary)" font-size="10" text-anchor="middle" transform="rotate(-90 10 ${height/2})">x (m)</text>
    `;

    const vx = v0 * Math.cos(theta);
    let pathData = `M ${padding.left} ${height - padding.bottom}`;

    const steps = 30;
    for (let i = 1; i <= steps; i++) {
        const t = (flightTime * i) / steps;
        const x = vx * t;
        const canvasX = padding.left + (t / flightTime) * graphWidth;
        const canvasY = height - padding.bottom - (x / range) * graphHeight;
        pathData += ` L ${canvasX} ${canvasY}`;
    }

    html += `<path d="${pathData}" fill="none" stroke="var(--physics-blue)" stroke-width="2"/>`;
    svg.innerHTML = html;
}

function drawYTGraph(v0, theta, g, flightTime, maxHeight) {
    const svg = document.getElementById('y-t-graph');
    const width = 200, height = 150;
    const padding = { top: 15, right: 15, bottom: 25, left: 35 };
    const graphWidth = width - padding.left - padding.right;
    const graphHeight = height - padding.top - padding.bottom;

    let html = `
        <line x1="${padding.left}" y1="${height - padding.bottom}" x2="${width - padding.right}" y2="${height - padding.bottom}" stroke="var(--text-tertiary)" stroke-width="1"/>
        <line x1="${padding.left}" y1="${padding.top}" x2="${padding.left}" y2="${height - padding.bottom}" stroke="var(--text-tertiary)" stroke-width="1"/>
        <text x="${width/2}" y="${height - 5}" fill="var(--text-secondary)" font-size="10" text-anchor="middle">Time (s)</text>
        <text x="10" y="${height/2}" fill="var(--text-secondary)" font-size="10" text-anchor="middle" transform="rotate(-90 10 ${height/2})">y (m)</text>
    `;

    let pathData = `M ${padding.left} ${height - padding.bottom}`;

    const steps = 30;
    for (let i = 1; i <= steps; i++) {
        const t = (flightTime * i) / steps;
        const y = v0 * Math.sin(theta) * t - 0.5 * g * t * t;
        const canvasX = padding.left + (t / flightTime) * graphWidth;
        const canvasY = height - padding.bottom - (Math.max(y, 0) / maxHeight) * graphHeight;
        pathData += ` L ${canvasX} ${canvasY}`;
    }

    html += `<path d="${pathData}" fill="none" stroke="var(--physics-orange)" stroke-width="2"/>`;

    const maxX = padding.left + 0.5 * graphWidth;
    const maxY = height - padding.bottom - graphHeight;
    html += `<circle cx="${maxX}" cy="${maxY}" r="4" fill="var(--physics-orange)"/>`;

    svg.innerHTML = html;
}

function drawYXGraph(v0, theta, g, range, maxHeight) {
    const svg = document.getElementById('y-x-graph');
    const width = 200, height = 150;
    const padding = { top: 15, right: 15, bottom: 25, left: 35 };
    const graphWidth = width - padding.left - padding.right;
    const graphHeight = height - padding.top - padding.bottom;

    let html = `
        <line x1="${padding.left}" y1="${height - padding.bottom}" x2="${width - padding.right}" y2="${height - padding.bottom}" stroke="var(--text-tertiary)" stroke-width="1"/>
        <line x1="${padding.left}" y1="${padding.top}" x2="${padding.left}" y2="${height - padding.bottom}" stroke="var(--text-tertiary)" stroke-width="1"/>
        <text x="${width/2}" y="${height - 5}" fill="var(--text-secondary)" font-size="10" text-anchor="middle">x (m)</text>
        <text x="10" y="${height/2}" fill="var(--text-secondary)" font-size="10" text-anchor="middle" transform="rotate(-90 10 ${height/2})">y (m)</text>
    `;

    let pathData = `M ${padding.left} ${height - padding.bottom}`;

    const steps = 30;
    for (let i = 1; i <= steps; i++) {
        const x = (range * i) / steps;
        const y = x * Math.tan(theta) - (g * x * x) / (2 * v0 * v0 * Math.cos(theta) * Math.cos(theta));
        const canvasX = padding.left + (x / range) * graphWidth;
        const canvasY = height - padding.bottom - (Math.max(y, 0) / maxHeight) * graphHeight;
        pathData += ` L ${canvasX} ${canvasY}`;
    }

    html += `<path d="${pathData}" fill="none" stroke="var(--physics-green)" stroke-width="2"/>`;
    svg.innerHTML = html;
}

function toggleTrail() {
    showTrail = !showTrail;
    const btn = document.getElementById('trail-btn');
    btn.textContent = showTrail ? 'Trail: ON' : 'Trail: OFF';
    btn.classList.toggle('active', showTrail);
}

function toggleMatterJS() {
    useMatterJS = !useMatterJS;
    const btn = document.getElementById('matter-btn');
    if (btn) {
        btn.textContent = useMatterJS ? 'Physics: Bounce' : 'Physics: Normal';
        btn.classList.toggle('active', useMatterJS);
    }
}

function resetSimulation() {
    if (animationId) {
        cancelAnimationFrame(animationId);
        animationId = null;
    }
    if (runner && engine) {
        Runner.stop(runner);
    }
    trailPoints = [];
    projectile.style.display = 'none';
    projectile.textContent = '⚫';

    document.getElementById('info-position').textContent = 'x: 0 m, y: 0 m';
    document.getElementById('info-velocity').textContent = 'vx: 0, vy: 0 m/s';
    document.getElementById('info-time').textContent = 't = 0.00 s';

    calculate();
}

function loadExample(num) {
    const examples = {
        1: { v: 25, a: 35, g: 9.81, name: 'Soccer kick' },
        2: { v: 8, a: 55, g: 9.81, name: 'Basketball' },
        3: { v: 50, a: 10, g: 9.81, name: 'Tennis serve' },
        4: { v: 80, a: 45, g: 9.81, name: 'Cannonball' }
    };

    const example = examples[num];

    velocityInput.value = example.v;
    gravityInput.value = example.g;

    if (velocityUnitSelect) velocityUnitSelect.value = 'm/s';
    if (gravityUnitSelect) gravityUnitSelect.value = 'm/s²';

    setAngle(example.a);
    resetSimulation();

    setTimeout(launch, 300);
}

// Export functions
window.toggleMatterJS = toggleMatterJS;
