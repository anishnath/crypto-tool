// Force Calculator - Newton's Laws Physics Simulation with Matter.js
// F = ma, W = mg, f = μN

let currentMode = 'basic';
let solveFor = 'force';
let includeFriction = false;
let outputUnit = 'N';
let stepsExpanded = false;

// Animation state
let isAnimating = false;
let animationId = null;
let slidePosition = 0;
let slideVelocity = 0;
let willSlide = false;
let lastCalculatedValues = {};

// Matter.js modules
let Engine, Runner, Bodies, Body, Composite, Events, Constraint;
let engine, runner;
let blockBody, inclineSurface, floorBody;
let matterInitialized = false;

// Unit conversions
const massConversions = {
    'kg': 1,
    'g': 0.001,
    'lb': 0.453592,
    'oz': 0.0283495
};

const accelConversions = {
    'm/s²': 1,
    'ft/s²': 0.3048,
    'g': 9.80665
};

const forceConversions = {
    'N': 1,
    'kN': 1000,
    'lbf': 4.44822,
    'dyn': 0.00001
};

const forceOutputConversions = {
    'N': { factor: 1, symbol: 'N' },
    'kN': { factor: 0.001, symbol: 'kN' },
    'lbf': { factor: 0.224809, symbol: 'lbf' },
    'dyn': { factor: 100000, symbol: 'dyn' }
};

// DOM elements
let canvas, ctx, fbdObject;

document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('fbd-canvas');
    ctx = canvas.getContext('2d');
    fbdObject = document.getElementById('fbd-object');

    setupCanvas();

    // Initialize Matter.js if available
    if (typeof Matter !== 'undefined') {
        initMatterJS();
    }

    calculate();

    // Add input listeners
    document.querySelectorAll('.number-input').forEach(input => {
        input.addEventListener('input', calculate);
    });

    window.addEventListener('resize', () => {
        setupCanvas();
        if (matterInitialized) {
            createMatterBodies();
        }
        calculate();
    });
});

function initMatterJS() {
    Engine = Matter.Engine;
    Runner = Matter.Runner;
    Bodies = Matter.Bodies;
    Body = Matter.Body;
    Composite = Matter.Composite;
    Events = Matter.Events;
    Constraint = Matter.Constraint;

    // Create engine with gravity
    engine = Engine.create({
        gravity: { x: 0, y: 1 }
    });

    runner = Runner.create();
    matterInitialized = true;

    createMatterBodies();
}

function createMatterBodies() {
    if (!engine) return;

    Composite.clear(engine.world);

    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;

    // Create block
    blockBody = Bodies.rectangle(centerX, centerY - 100, 60, 60, {
        mass: 10,
        friction: 0.3,
        frictionStatic: 0.4,
        restitution: 0.2,
        render: { visible: false },
        label: 'block'
    });

    // Create floor (default for non-incline mode)
    floorBody = Bodies.rectangle(centerX, centerY + 60, canvas.width, 40, {
        isStatic: true,
        friction: 0.5,
        render: { visible: false },
        label: 'floor'
    });

    Composite.add(engine.world, [blockBody, floorBody]);
}

function setupCanvas() {
    const container = document.getElementById('fbd-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
}

function setMode(mode) {
    currentMode = mode;

    if (isAnimating) {
        stopAnimation();
    }

    document.querySelectorAll('.mode-tab').forEach(tab => {
        tab.classList.remove('active');
        if (tab.dataset.mode === mode) {
            tab.classList.add('active');
        }
    });

    const inclineInputs = document.getElementById('incline-inputs');
    const solveForSection = document.getElementById('solve-for-section');
    const accelSection = document.getElementById('accel-input-section');
    const animationControls = document.getElementById('animation-controls');

    if (mode === 'basic') {
        inclineInputs.style.display = 'none';
        solveForSection.style.display = 'block';
        accelSection.style.display = 'block';
        if (animationControls) animationControls.style.display = 'none';
        fbdObject.textContent = '📦';
    } else if (mode === 'weight') {
        inclineInputs.style.display = 'none';
        solveForSection.style.display = 'none';
        accelSection.style.display = 'none';
        if (animationControls) animationControls.style.display = 'none';
        setSolveFor('force');
        document.getElementById('acceleration').value = 9.81;
        document.getElementById('accel-unit').value = 'm/s²';
        fbdObject.textContent = '🏋️';
    } else if (mode === 'incline') {
        inclineInputs.style.display = 'block';
        solveForSection.style.display = 'none';
        accelSection.style.display = 'none';
        if (animationControls) animationControls.style.display = 'block';
        setSolveFor('force');
        fbdObject.textContent = '📦';
    }

    calculate();
}

function setSolveFor(variable) {
    solveFor = variable;

    document.querySelectorAll('.solve-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.var === variable) {
            btn.classList.add('active');
        }
    });

    const massSection = document.getElementById('mass-input-section');
    const accelSection = document.getElementById('accel-input-section');
    const forceSection = document.getElementById('force-input-section');

    if (variable === 'force') {
        massSection.style.display = 'block';
        accelSection.style.display = 'block';
        forceSection.style.display = 'none';
    } else if (variable === 'mass') {
        massSection.style.display = 'none';
        accelSection.style.display = 'block';
        forceSection.style.display = 'block';
    } else if (variable === 'acceleration') {
        massSection.style.display = 'block';
        accelSection.style.display = 'none';
        forceSection.style.display = 'block';
    }

    calculate();
}

function toggleFriction() {
    includeFriction = !includeFriction;

    const toggle = document.getElementById('friction-toggle');
    const inputs = document.getElementById('friction-inputs');
    const frictionResult = document.getElementById('friction-result');

    toggle.classList.toggle('active', includeFriction);
    inputs.classList.toggle('show', includeFriction);
    frictionResult.style.display = includeFriction ? 'block' : 'none';

    calculate();
}

function setFriction(value) {
    document.getElementById('friction-coeff').value = value;
    calculate();
}

function setAccelPreset(value) {
    document.getElementById('acceleration').value = value;
    document.getElementById('accel-unit').value = 'm/s²';
    calculate();
}

function setOutputUnit(unit) {
    outputUnit = unit;

    document.querySelectorAll('.unit-btn[data-unit]').forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.unit === unit) {
            btn.classList.add('active');
        }
    });

    calculate();
}

function calculate() {
    const massInput = parseFloat(document.getElementById('mass').value) || 10;
    const massUnit = document.getElementById('mass-unit').value;
    const accelInput = parseFloat(document.getElementById('acceleration').value) || 9.8;
    const accelUnit = document.getElementById('accel-unit').value;
    const forceInput = parseFloat(document.getElementById('force').value) || 98;
    const forceUnit = document.getElementById('force-unit').value;
    const frictionCoeff = parseFloat(document.getElementById('friction-coeff').value) || 0.3;
    const inclineAngle = parseFloat(document.getElementById('incline-angle').value) || 30;

    let mass = massInput * massConversions[massUnit];
    let accel = accelInput * accelConversions[accelUnit];
    let force = forceInput * forceConversions[forceUnit];

    let netForce, weight, normalForce, frictionForce;
    const g = 9.80665;

    if (currentMode === 'weight') {
        weight = mass * g;
        normalForce = weight;
        netForce = weight;
        accel = g;
        frictionForce = includeFriction ? frictionCoeff * normalForce : 0;
    } else if (currentMode === 'incline') {
        const theta = inclineAngle * Math.PI / 180;
        weight = mass * g;
        normalForce = weight * Math.cos(theta);
        const parallelComponent = weight * Math.sin(theta);
        frictionForce = includeFriction ? frictionCoeff * normalForce : 0;
        netForce = parallelComponent - frictionForce;
        accel = netForce / mass;

        willSlide = netForce > 0.01;

        lastCalculatedValues = {
            mass, accel, weight, normalForce, frictionForce, netForce, inclineAngle, willSlide, frictionCoeff
        };

        // Update Matter.js body friction
        if (blockBody && matterInitialized) {
            blockBody.friction = frictionCoeff;
            blockBody.frictionStatic = frictionCoeff * 1.2;
        }
    } else {
        if (solveFor === 'force') {
            weight = mass * g;
            normalForce = weight;
            frictionForce = includeFriction ? frictionCoeff * normalForce : 0;
            const appliedForce = mass * accel;
            netForce = appliedForce - frictionForce;
        } else if (solveFor === 'mass') {
            mass = force / accel;
            weight = mass * g;
            normalForce = weight;
            netForce = force;
            frictionForce = includeFriction ? frictionCoeff * normalForce : 0;
        } else if (solveFor === 'acceleration') {
            weight = mass * g;
            normalForce = weight;
            frictionForce = includeFriction ? frictionCoeff * normalForce : 0;
            netForce = force - frictionForce;
            accel = netForce / mass;
        }
    }

    const outConv = forceOutputConversions[outputUnit];
    const netForceDisplay = netForce * outConv.factor;
    const weightDisplay = weight * outConv.factor;
    const normalDisplay = normalForce * outConv.factor;
    const frictionDisplay = frictionForce * outConv.factor;

    document.getElementById('result-force').textContent = formatNumber(netForceDisplay) + ' ' + outConv.symbol;
    document.getElementById('result-weight').textContent = formatNumber(weightDisplay) + ' ' + outConv.symbol;
    document.getElementById('result-normal').textContent = formatNumber(normalDisplay) + ' ' + outConv.symbol;
    document.getElementById('result-friction').textContent = formatNumber(frictionDisplay) + ' ' + outConv.symbol;

    document.getElementById('info-mass').textContent = 'm = ' + formatNumber(mass) + ' kg';
    document.getElementById('info-accel').textContent = 'a = ' + formatNumber(accel) + ' m/s²';

    drawFBD(mass, accel, weight, normalForce, frictionForce, netForce, inclineAngle);

    generateStepByStep(massInput, massUnit, accelInput, accelUnit, mass, accel, weight, normalForce, frictionForce, netForce, frictionCoeff, inclineAngle);
}

function formatNumber(num) {
    if (Math.abs(num) >= 10000) return num.toExponential(2);
    if (Math.abs(num) >= 100) return num.toFixed(1);
    if (Math.abs(num) >= 10) return num.toFixed(2);
    if (Math.abs(num) >= 1) return num.toFixed(3);
    return num.toFixed(4);
}

function drawFBD(mass, accel, weight, normalForce, frictionForce, netForce, inclineAngle, animOffset = 0) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const objectSize = 80;

    let objX = centerX;
    let objY = centerY;

    if (currentMode === 'incline' && animOffset !== 0) {
        const theta = inclineAngle * Math.PI / 180;
        objX = centerX + animOffset * Math.cos(theta);
        objY = centerY + animOffset * Math.sin(theta);
    }

    fbdObject.style.left = (objX - objectSize / 2) + 'px';
    fbdObject.style.top = (objY - objectSize / 2) + 'px';

    const maxForce = Math.max(weight, normalForce, Math.abs(netForce), frictionForce || 1);
    const maxArrowLength = 100;
    const scale = maxArrowLength / maxForce;

    if (currentMode === 'incline') {
        const theta = inclineAngle * Math.PI / 180;

        // Draw incline surface with gradient
        ctx.save();
        ctx.translate(centerX, centerY);
        ctx.rotate(-theta);

        const surfaceGrad = ctx.createLinearGradient(0, objectSize / 2, 0, objectSize / 2 + 30);
        surfaceGrad.addColorStop(0, '#64748b');
        surfaceGrad.addColorStop(1, '#475569');

        ctx.fillStyle = surfaceGrad;
        ctx.fillRect(-150, objectSize / 2, 400, 30);

        // Surface texture lines
        ctx.strokeStyle = '#334155';
        ctx.lineWidth = 1;
        for (let i = -140; i < 250; i += 20) {
            ctx.beginPath();
            ctx.moveTo(i, objectSize / 2 + 5);
            ctx.lineTo(i + 10, objectSize / 2 + 25);
            ctx.stroke();
        }

        ctx.restore();

        fbdObject.style.transform = `rotate(-${inclineAngle}deg)`;

        drawSlideStatus(willSlide, netForce);
    } else {
        fbdObject.style.transform = 'none';

        // Draw ground with gradient
        const groundGrad = ctx.createLinearGradient(0, centerY + objectSize / 2, 0, centerY + objectSize / 2 + 20);
        groundGrad.addColorStop(0, '#64748b');
        groundGrad.addColorStop(1, '#475569');
        ctx.fillStyle = groundGrad;
        ctx.fillRect(centerX - 150, centerY + objectSize / 2, 300, 20);
    }

    // Draw weight (down) - Purple
    if (weight > 0) {
        const arrowLen = weight * scale;
        const startX = currentMode === 'incline' ? objX : centerX;
        const startY = currentMode === 'incline' ? objY : centerY;
        drawArrow(startX, startY, startX, startY + arrowLen, '#7c3aed', currentMode === 'incline' ? 'W' : 'W = ' + formatNumber(weight) + ' N');
    }

    // Draw normal force (up or perpendicular) - Green
    if (normalForce > 0) {
        const arrowLen = normalForce * scale;
        if (currentMode === 'incline') {
            const theta = inclineAngle * Math.PI / 180;
            const nx = objX + arrowLen * Math.sin(theta);
            const ny = objY - arrowLen * Math.cos(theta);
            drawArrow(objX, objY, nx, ny, '#059669', 'N');
        } else {
            drawArrow(centerX, centerY, centerX, centerY - arrowLen, '#059669', 'N = ' + formatNumber(normalForce) + ' N');
        }
    }

    // Draw friction force (opposing motion) - Orange
    if (includeFriction && frictionForce > 0) {
        const arrowLen = frictionForce * scale;
        if (currentMode === 'incline') {
            const theta = inclineAngle * Math.PI / 180;
            const fx = objX - arrowLen * Math.cos(theta);
            const fy = objY - arrowLen * Math.sin(theta);
            drawArrow(objX, objY, fx, fy, '#ea580c', 'f');
        } else {
            drawArrow(centerX, centerY, centerX - arrowLen, centerY, '#ea580c', 'f = ' + formatNumber(frictionForce) + ' N');
        }
    }

    // Draw applied/net force - Red (or Blue for net)
    if (currentMode === 'basic' && solveFor === 'force') {
        const appliedForce = mass * accel;
        const arrowLen = appliedForce * scale;
        if (appliedForce > 0) {
            drawArrow(centerX, centerY, centerX + arrowLen, centerY, '#dc2626', 'F = ' + formatNumber(appliedForce) + ' N');
        }
    } else if (currentMode === 'incline' && netForce !== 0) {
        const arrowLen = Math.abs(netForce) * scale;
        const theta = inclineAngle * Math.PI / 180;
        const direction = netForce > 0 ? 1 : -1;
        const fx = objX + direction * arrowLen * Math.cos(theta);
        const fy = objY + direction * arrowLen * Math.sin(theta);
        drawArrow(objX, objY, fx, fy, '#2563eb', 'F_net');
    }
}

function drawSlideStatus(willSlide, netForce) {
    const statusX = 15;
    const statusY = 30;

    // Background pill
    ctx.beginPath();
    ctx.roundRect(statusX, statusY - 18, willSlide ? 140 : 120, 28, 14);
    ctx.fillStyle = willSlide ? 'rgba(220, 38, 38, 0.9)' : 'rgba(5, 150, 105, 0.9)';
    ctx.fill();

    ctx.font = 'bold 12px Inter, sans-serif';
    ctx.fillStyle = 'white';
    ctx.textAlign = 'left';

    if (willSlide) {
        ctx.fillText('⚠️ WILL SLIDE', statusX + 10, statusY);
    } else {
        ctx.fillText('✓ STATIONARY', statusX + 10, statusY);
    }

    ctx.font = '11px Inter, sans-serif';
    ctx.fillStyle = '#475569';
    ctx.fillText(`F_net = ${formatNumber(netForce)} N`, statusX, statusY + 22);

    if (willSlide) {
        ctx.fillStyle = '#dc2626';
        ctx.fillText('(Click "Simulate Slide" to animate)', statusX, statusY + 38);
    } else {
        ctx.fillStyle = '#059669';
        ctx.fillText('(Friction prevents motion)', statusX, statusY + 38);
    }
}

function drawArrow(fromX, fromY, toX, toY, color, label) {
    const headLength = 12;
    const angle = Math.atan2(toY - fromY, toX - fromX);

    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = 3;
    ctx.lineCap = 'round';

    // Shadow
    ctx.save();
    ctx.strokeStyle = 'rgba(0, 0, 0, 0.2)';
    ctx.beginPath();
    ctx.moveTo(fromX + 2, fromY + 2);
    ctx.lineTo(toX + 2, toY + 2);
    ctx.stroke();
    ctx.restore();

    // Draw line
    ctx.beginPath();
    ctx.strokeStyle = color;
    ctx.moveTo(fromX, fromY);
    ctx.lineTo(toX, toY);
    ctx.stroke();

    // Draw arrowhead
    ctx.beginPath();
    ctx.moveTo(toX, toY);
    ctx.lineTo(toX - headLength * Math.cos(angle - Math.PI / 6), toY - headLength * Math.sin(angle - Math.PI / 6));
    ctx.lineTo(toX - headLength * Math.cos(angle + Math.PI / 6), toY - headLength * Math.sin(angle + Math.PI / 6));
    ctx.closePath();
    ctx.fill();

    // Draw label
    if (label) {
        ctx.font = 'bold 12px Inter, sans-serif';
        ctx.fillStyle = color;

        const midX = (fromX + toX) / 2;
        const midY = (fromY + toY) / 2;

        const perpAngle = angle + Math.PI / 2;
        const offset = 15;
        const labelX = midX + offset * Math.cos(perpAngle);
        const labelY = midY + offset * Math.sin(perpAngle);

        ctx.fillText(label, labelX, labelY);
    }
}

function toggleSteps() {
    stepsExpanded = !stepsExpanded;

    const stepsBody = document.getElementById('steps-body');
    const stepsToggle = document.getElementById('steps-toggle');

    if (stepsExpanded) {
        stepsBody.classList.remove('collapsed');
        stepsToggle.textContent = '▲ Hide';
    } else {
        stepsBody.classList.add('collapsed');
        stepsToggle.textContent = '▼ Show';
    }
}

function generateStepByStep(massInput, massUnit, accelInput, accelUnit, massSI, accelSI, weight, normalForce, frictionForce, netForce, frictionCoeff, inclineAngle) {
    const stepsBody = document.getElementById('steps-body');
    if (!stepsBody) return;

    const g = 9.80665;
    const outConv = forceOutputConversions[outputUnit];

    let html = '';

    html += `
        <div class="step-item">
            <div class="step-title">
                <span class="step-number">1</span>
                Identify Given Values
            </div>
            <div class="step-calc">
                Mass: <span class="highlight">m = ${massInput} ${massUnit}</span>
                ${massUnit !== 'kg' ? `<br>→ Convert to SI: m = ${massInput} × ${massConversions[massUnit]} = <span class="highlight">${formatNumber(massSI)} kg</span>` : ''}
    `;

    if (currentMode !== 'weight') {
        html += `
                <br>Acceleration: <span class="highlight">a = ${accelInput} ${accelUnit}</span>
                ${accelUnit !== 'm/s²' ? `<br>→ Convert to SI: a = ${formatNumber(accelSI)} m/s²` : ''}
        `;
    }

    if (currentMode === 'incline') {
        html += `<br>Incline angle: <span class="highlight">θ = ${inclineAngle}°</span>`;
    }

    if (includeFriction) {
        html += `<br>Friction coefficient: <span class="highlight">μ = ${frictionCoeff}</span>`;
    }

    html += `
            </div>
        </div>
    `;

    html += `
        <div class="step-item">
            <div class="step-title">
                <span class="step-number">2</span>
                Calculate Weight
            </div>
            <div class="step-formula">W = mg</div>
            <div class="step-calc">
                W = ${formatNumber(massSI)} kg × ${formatNumber(g)} m/s²
                <br>W = <span class="highlight">${formatNumber(weight)} N</span>
            </div>
        </div>
    `;

    if (currentMode === 'incline') {
        const theta = inclineAngle * Math.PI / 180;
        html += `
            <div class="step-item">
                <div class="step-title">
                    <span class="step-number">3</span>
                    Calculate Normal Force (Inclined Plane)
                </div>
                <div class="step-formula">N = mg × cos(θ)</div>
                <div class="step-calc">
                    N = ${formatNumber(weight)} × cos(${inclineAngle}°)
                    <br>N = ${formatNumber(weight)} × ${formatNumber(Math.cos(theta))}
                    <br>N = <span class="highlight">${formatNumber(normalForce)} N</span>
                </div>
            </div>
        `;
    } else {
        html += `
            <div class="step-item">
                <div class="step-title">
                    <span class="step-number">3</span>
                    Calculate Normal Force
                </div>
                <div class="step-formula">N = W (on flat surface)</div>
                <div class="step-calc">
                    On a flat horizontal surface, normal force equals weight:
                    <br>N = <span class="highlight">${formatNumber(normalForce)} N</span>
                </div>
            </div>
        `;
    }

    let stepNum = 4;
    if (includeFriction) {
        html += `
            <div class="step-item">
                <div class="step-title">
                    <span class="step-number">${stepNum}</span>
                    Calculate Friction Force
                </div>
                <div class="step-formula">f = μN</div>
                <div class="step-calc">
                    f = ${frictionCoeff} × ${formatNumber(normalForce)} N
                    <br>f = <span class="highlight">${formatNumber(frictionForce)} N</span>
                </div>
            </div>
        `;
        stepNum++;
    }

    if (currentMode === 'incline') {
        const theta = inclineAngle * Math.PI / 180;
        const parallel = weight * Math.sin(theta);
        const willObjectSlide = netForce > 0.01;
        const criticalAngle = includeFriction ? Math.atan(frictionCoeff) * 180 / Math.PI : 0;

        html += `
            <div class="step-item">
                <div class="step-title">
                    <span class="step-number">${stepNum}</span>
                    Calculate Net Force on Incline
                </div>
                <div class="step-formula">F_net = mg×sin(θ) - f</div>
                <div class="step-calc">
                    Parallel component: F_∥ = ${formatNumber(weight)} × sin(${inclineAngle}°) = ${formatNumber(parallel)} N
                    ${includeFriction ? `<br>Friction opposing motion: f = ${formatNumber(frictionForce)} N` : ''}
                    <br>Net force: F_net = ${formatNumber(parallel)} ${includeFriction ? '- ' + formatNumber(frictionForce) : ''} = <span class="highlight">${formatNumber(netForce)} N</span>
                </div>
                <div class="step-result">
                    <div class="step-result-label">Net Force</div>
                    <div class="step-result-value">${formatNumber(netForce * outConv.factor)} ${outConv.symbol}</div>
                </div>
            </div>
        `;
        stepNum++;

        html += `
            <div class="step-item" style="border-left-color: ${willObjectSlide ? '#dc2626' : '#059669'};">
                <div class="step-title">
                    <span class="step-number" style="background: ${willObjectSlide ? '#dc2626' : '#059669'};">${stepNum}</span>
                    Motion Analysis
                </div>
                <div class="step-calc">
                    <strong>Will the object slide?</strong>
                    ${includeFriction ? `
                        <br>Condition: Object slides when tan(θ) > μ
                        <br>tan(${inclineAngle}°) = ${formatNumber(Math.tan(theta))}
                        <br>μ = ${frictionCoeff}
                        <br>Critical angle: θ_c = arctan(μ) = <span class="highlight">${formatNumber(criticalAngle)}°</span>
                        <br><br>Since ${inclineAngle}° ${inclineAngle > criticalAngle ? '>' : '≤'} ${formatNumber(criticalAngle)}°:
                    ` : `
                        <br>No friction: Object will slide at any angle > 0°
                    `}
                </div>
                <div class="step-result" style="background: ${willObjectSlide ? 'linear-gradient(135deg, rgba(220, 38, 38, 0.1), rgba(185, 28, 28, 0.1))' : 'linear-gradient(135deg, rgba(5, 150, 105, 0.1), rgba(4, 120, 87, 0.1))'}; border-color: ${willObjectSlide ? 'rgba(220, 38, 38, 0.3)' : 'rgba(5, 150, 105, 0.3)'};">
                    <div class="step-result-label" style="color: ${willObjectSlide ? '#dc2626' : '#059669'};">Result</div>
                    <div class="step-result-value" style="color: ${willObjectSlide ? '#dc2626' : '#059669'};">
                        ${willObjectSlide ? '⚠️ Object WILL SLIDE down (a = ' + formatNumber(netForce/massSI) + ' m/s²)' : '✓ Object stays STATIONARY (friction holds)'}
                    </div>
                </div>
            </div>
        `;
    } else if (currentMode === 'basic') {
        html += `
            <div class="step-item">
                <div class="step-title">
                    <span class="step-number">${stepNum}</span>
                    Apply Newton's Second Law
                </div>
                <div class="step-formula">F = ma</div>
                <div class="step-calc">
                    F = ${formatNumber(massSI)} kg × ${formatNumber(accelSI)} m/s²
                    <br>Applied Force = <span class="highlight">${formatNumber(massSI * accelSI)} N</span>
                    ${includeFriction ? `<br>Net Force = Applied - Friction = ${formatNumber(massSI * accelSI)} - ${formatNumber(frictionForce)} = <span class="highlight">${formatNumber(netForce)} N</span>` : ''}
                </div>
                <div class="step-result">
                    <div class="step-result-label">${includeFriction ? 'Net Force' : 'Force'}</div>
                    <div class="step-result-value">${formatNumber(netForce * outConv.factor)} ${outConv.symbol}</div>
                </div>
            </div>
        `;
    } else {
        html += `
            <div class="step-item">
                <div class="step-title">
                    <span class="step-number">${stepNum}</span>
                    Result: Weight Force
                </div>
                <div class="step-calc">
                    The weight of an object is the gravitational force acting on it.
                </div>
                <div class="step-result">
                    <div class="step-result-label">Weight</div>
                    <div class="step-result-value">${formatNumber(weight * outConv.factor)} ${outConv.symbol}</div>
                </div>
            </div>
        `;
    }

    html += `
        <div class="step-item">
            <div class="step-title">
                <span class="step-number">${stepNum + 1}</span>
                Unit Conversions
            </div>
            <div class="step-calc">
                <strong>Force in different units:</strong>
                <br>• Newtons: ${formatNumber(netForce)} N
                <br>• Kilonewtons: ${formatNumber(netForce * 0.001)} kN
                <br>• Pound-force: ${formatNumber(netForce * 0.224809)} lbf
                <br>• Dynes: ${formatNumber(netForce * 100000)} dyn
            </div>
        </div>
    `;

    stepsBody.innerHTML = html;
}

function loadExample(num) {
    const examples = {
        1: {
            mode: 'basic',
            mass: 1500,
            massUnit: 'kg',
            accel: 3,
            accelUnit: 'm/s²',
            friction: false,
            solveFor: 'force'
        },
        2: {
            mode: 'weight',
            mass: 100,
            massUnit: 'kg',
            friction: false
        },
        3: {
            mode: 'incline',
            mass: 20,
            massUnit: 'kg',
            angle: 30,
            friction: true,
            frictionCoeff: 0.3
        },
        4: {
            mode: 'basic',
            mass: 50000,
            massUnit: 'kg',
            accel: 20,
            accelUnit: 'm/s²',
            friction: false,
            solveFor: 'force'
        }
    };

    const ex = examples[num];

    setMode(ex.mode);

    document.getElementById('mass').value = ex.mass;
    document.getElementById('mass-unit').value = ex.massUnit;

    if (ex.accel !== undefined) {
        document.getElementById('acceleration').value = ex.accel;
        document.getElementById('accel-unit').value = ex.accelUnit;
    }

    if (ex.angle !== undefined) {
        document.getElementById('incline-angle').value = ex.angle;
    }

    if (ex.friction !== includeFriction) {
        toggleFriction();
    }

    if (ex.frictionCoeff !== undefined) {
        document.getElementById('friction-coeff').value = ex.frictionCoeff;
    }

    if (ex.solveFor) {
        setSolveFor(ex.solveFor);
    }

    calculate();
}

// ============ MATTER.JS INCLINE ANIMATION ============

function startSlideAnimation() {
    if (currentMode !== 'incline') return;

    if (isAnimating) {
        stopAnimation();
        return;
    }

    // Check if object will slide based on physics calculations
    if (!willSlide) {
        // Show stationary animation - object stays in place with force arrows
        showStationaryAnimation();
        return;
    }

    // Object will slide - use simple physics-based animation
    // (More accurate than Matter.js for educational purposes)
    startSimpleSlideAnimation();
}

function showStationaryAnimation() {
    isAnimating = true;

    const { mass, weight, normalForce, frictionForce, netForce, inclineAngle, frictionCoeff } = lastCalculatedValues;

    // Update button
    const btn = document.getElementById('simulate-btn');
    if (btn) {
        btn.innerHTML = '<span>⏹️</span><span>Stop</span>';
        btn.style.background = 'linear-gradient(135deg, #059669, #047857)';
    }

    let wobblePhase = 0;
    const startTime = Date.now();

    function animateStationary() {
        if (!isAnimating) return;

        ctx.clearRect(0, 0, canvas.width, canvas.height);

        const centerX = canvas.width / 2;
        const centerY = canvas.height / 2;
        const theta = inclineAngle * Math.PI / 180;
        const objectSize = 80;

        // Small wobble to show it's trying to move but can't
        const elapsed = (Date.now() - startTime) / 1000;
        wobblePhase = Math.sin(elapsed * 8) * Math.exp(-elapsed * 2) * 3;

        const objX = centerX + wobblePhase * Math.cos(theta);
        const objY = centerY + wobblePhase * Math.sin(theta);

        // Draw incline surface
        ctx.save();
        ctx.translate(centerX, centerY);
        ctx.rotate(-theta);

        const surfaceGrad = ctx.createLinearGradient(0, objectSize / 2, 0, objectSize / 2 + 30);
        surfaceGrad.addColorStop(0, '#64748b');
        surfaceGrad.addColorStop(1, '#475569');

        ctx.fillStyle = surfaceGrad;
        ctx.fillRect(-150, objectSize / 2, 400, 30);

        // Surface texture lines
        ctx.strokeStyle = '#334155';
        ctx.lineWidth = 1;
        for (let i = -140; i < 250; i += 20) {
            ctx.beginPath();
            ctx.moveTo(i, objectSize / 2 + 5);
            ctx.lineTo(i + 10, objectSize / 2 + 25);
            ctx.stroke();
        }

        ctx.restore();

        // Position the emoji object
        fbdObject.style.left = (objX - objectSize / 2) + 'px';
        fbdObject.style.top = (objY - objectSize / 2) + 'px';
        fbdObject.style.transform = `rotate(-${inclineAngle}deg)`;

        // Draw force arrows
        const maxForce = Math.max(weight, normalForce, Math.abs(netForce), frictionForce || 1);
        const maxArrowLength = 100;
        const scale = maxArrowLength / maxForce;

        // Weight arrow
        const wLen = weight * scale;
        drawArrow(objX, objY, objX, objY + wLen, '#7c3aed', 'W');

        // Normal force arrow
        const nLen = normalForce * scale;
        const nx = objX + nLen * Math.sin(theta);
        const ny = objY - nLen * Math.cos(theta);
        drawArrow(objX, objY, nx, ny, '#059669', 'N');

        // Friction force arrow (up the slope - holding it in place)
        if (frictionForce > 0) {
            const fLen = frictionForce * scale;
            const fx = objX - fLen * Math.cos(theta);
            const fy = objY - fLen * Math.sin(theta);
            drawArrow(objX, objY, fx, fy, '#ea580c', 'f');
        }

        // Draw status message
        drawStationaryStatus(frictionCoeff, inclineAngle);

        // Continue animation for a few seconds then stop
        if (elapsed < 3) {
            animationId = requestAnimationFrame(animateStationary);
        } else {
            stopAnimation();
        }
    }

    animateStationary();
}

function drawStationaryStatus(frictionCoeff, angle) {
    const criticalAngle = Math.atan(frictionCoeff) * 180 / Math.PI;

    // Status box
    ctx.beginPath();
    ctx.roundRect(10, 10, 200, 70, 10);
    ctx.fillStyle = 'rgba(5, 150, 105, 0.95)';
    ctx.fill();

    ctx.font = 'bold 14px Inter, sans-serif';
    ctx.fillStyle = 'white';
    ctx.textAlign = 'left';
    ctx.fillText('✓ STATIONARY', 20, 32);

    ctx.font = '11px Inter, sans-serif';
    ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
    ctx.fillText(`Angle: ${angle}° < Critical: ${criticalAngle.toFixed(1)}°`, 20, 50);
    ctx.fillText('Friction prevents motion', 20, 68);
}


function startSimpleSlideAnimation() {
    isAnimating = true;
    slidePosition = 0;
    slideVelocity = 0;

    const btn = document.getElementById('simulate-btn');
    if (btn) {
        btn.innerHTML = '<span>⏹️</span><span>Stop Animation</span>';
        btn.style.background = 'linear-gradient(135deg, #dc2626, #b91c1c)';
    }

    const startTime = Date.now();
    animateSlidePhysics(startTime);
}

function animateSlidePhysics(startTime) {
    if (!isAnimating) return;

    const { mass, weight, normalForce, frictionForce, netForce, inclineAngle, frictionCoeff } = lastCalculatedValues;

    // Calculate real physics values
    // a = F_net / m = (mg*sin(θ) - μ*mg*cos(θ)) / m = g*(sin(θ) - μ*cos(θ))
    const acceleration = netForce / mass; // m/s²

    // Time elapsed (in seconds, scaled for visual effect)
    const elapsed = (Date.now() - startTime) / 1000;
    const timeScale = 0.5; // Slow down for better visualization
    const t = elapsed * timeScale;

    // Kinematics: x = 0.5 * a * t²,  v = a * t
    const realVelocity = acceleration * t; // m/s
    const realPosition = 0.5 * acceleration * t * t; // m

    // Scale for canvas visualization
    const positionScale = 50; // pixels per meter
    slidePosition = realPosition * positionScale;
    slideVelocity = realVelocity;

    const maxSlide = 180;

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const theta = inclineAngle * Math.PI / 180;
    const objectSize = 80;

    // Calculate object position along the incline
    const objX = centerX + slidePosition * Math.cos(theta);
    const objY = centerY + slidePosition * Math.sin(theta);

    // Draw incline surface
    ctx.save();
    ctx.translate(centerX, centerY);
    ctx.rotate(-theta);

    const surfaceGrad = ctx.createLinearGradient(0, objectSize / 2, 0, objectSize / 2 + 30);
    surfaceGrad.addColorStop(0, '#64748b');
    surfaceGrad.addColorStop(1, '#475569');

    ctx.fillStyle = surfaceGrad;
    ctx.fillRect(-150, objectSize / 2, 400, 30);

    // Surface texture lines
    ctx.strokeStyle = '#334155';
    ctx.lineWidth = 1;
    for (let i = -140; i < 250; i += 20) {
        ctx.beginPath();
        ctx.moveTo(i, objectSize / 2 + 5);
        ctx.lineTo(i + 10, objectSize / 2 + 25);
        ctx.stroke();
    }

    ctx.restore();

    // Position the emoji object
    fbdObject.style.left = (objX - objectSize / 2) + 'px';
    fbdObject.style.top = (objY - objectSize / 2) + 'px';
    fbdObject.style.transform = `rotate(-${inclineAngle}deg)`;

    // Draw force arrows (following the object)
    const maxForce = Math.max(weight, normalForce, Math.abs(netForce), frictionForce || 1);
    const maxArrowLength = 80;
    const scale = maxArrowLength / maxForce;

    // Weight arrow (always down)
    const wLen = weight * scale;
    drawArrow(objX, objY, objX, objY + wLen, '#7c3aed', '');

    // Normal force arrow (perpendicular to surface)
    const nLen = normalForce * scale;
    const nx = objX + nLen * Math.sin(theta);
    const ny = objY - nLen * Math.cos(theta);
    drawArrow(objX, objY, nx, ny, '#059669', '');

    // Friction force arrow (up the slope)
    if (frictionForce > 0) {
        const fLen = frictionForce * scale;
        const fx = objX - fLen * Math.cos(theta);
        const fy = objY - fLen * Math.sin(theta);
        drawArrow(objX, objY, fx, fy, '#ea580c', '');
    }

    // Net force arrow (down the slope)
    if (netForce > 0) {
        const netLen = netForce * scale;
        const netX = objX + netLen * Math.cos(theta);
        const netY = objY + netLen * Math.sin(theta);
        drawArrow(objX, objY, netX, netY, '#2563eb', '');
    }

    // Draw physics info panel
    drawSlidePhysicsInfo(realPosition, realVelocity, acceleration, t / timeScale);

    // Draw slide status
    drawSlideStatusAnimated();

    // Check if we should reset or continue
    if (slidePosition > maxSlide) {
        setTimeout(() => {
            if (isAnimating) {
                // Reset and continue
                const newStartTime = Date.now();
                animateSlidePhysics(newStartTime);
            }
        }, 800);
        return;
    }

    animationId = requestAnimationFrame(() => animateSlidePhysics(startTime));
}

function drawSlidePhysicsInfo(position, velocity, acceleration, time) {
    const infoX = canvas.width - 10;
    const infoY = 15;

    // Background
    ctx.beginPath();
    ctx.roundRect(infoX - 140, infoY - 10, 145, 90, 8);
    ctx.fillStyle = 'rgba(30, 41, 59, 0.95)';
    ctx.fill();

    ctx.font = 'bold 11px Inter, sans-serif';
    ctx.fillStyle = '#94a3b8';
    ctx.textAlign = 'right';
    ctx.fillText('PHYSICS DATA', infoX - 5, infoY + 5);

    ctx.font = '11px JetBrains Mono, monospace';
    ctx.fillStyle = '#22d3ee';
    ctx.fillText(`t: ${time.toFixed(2)} s`, infoX - 5, infoY + 22);
    ctx.fillText(`x: ${position.toFixed(2)} m`, infoX - 5, infoY + 37);
    ctx.fillText(`v: ${velocity.toFixed(2)} m/s`, infoX - 5, infoY + 52);
    ctx.fillText(`a: ${acceleration.toFixed(2)} m/s²`, infoX - 5, infoY + 67);
}

function drawSlideStatusAnimated() {
    const { netForce, inclineAngle, frictionCoeff } = lastCalculatedValues;
    const criticalAngle = Math.atan(frictionCoeff) * 180 / Math.PI;

    // Status box
    ctx.beginPath();
    ctx.roundRect(10, 10, 180, 55, 10);
    ctx.fillStyle = 'rgba(220, 38, 38, 0.95)';
    ctx.fill();

    ctx.font = 'bold 14px Inter, sans-serif';
    ctx.fillStyle = 'white';
    ctx.textAlign = 'left';
    ctx.fillText('⚠️ SLIDING', 20, 32);

    ctx.font = '11px Inter, sans-serif';
    ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
    ctx.fillText(`Angle: ${inclineAngle}° > Critical: ${criticalAngle.toFixed(1)}°`, 20, 50);
}


function stopAnimation() {
    isAnimating = false;
    if (animationId) {
        cancelAnimationFrame(animationId);
        animationId = null;
    }
    if (runner && engine) {
        Runner.stop(runner);
    }

    slidePosition = 0;
    slideVelocity = 0;

    const btn = document.getElementById('simulate-btn');
    if (btn) {
        btn.innerHTML = '<span>▶️</span><span>Simulate Slide</span>';
        btn.style.background = 'linear-gradient(135deg, #059669, #047857)';
    }

    // Recreate bodies for static mode
    if (matterInitialized) {
        createMatterBodies();
    }

    calculate();
}

function resetAnimation() {
    stopAnimation();
    calculate();
}

function showAnimationMessage(message) {
    ctx.save();

    ctx.beginPath();
    ctx.roundRect(canvas.width / 2 - 150, canvas.height - 50, 300, 35, 8);
    ctx.fillStyle = 'rgba(5, 150, 105, 0.95)';
    ctx.fill();

    ctx.font = 'bold 13px Inter, sans-serif';
    ctx.fillStyle = 'white';
    ctx.textAlign = 'center';
    ctx.fillText(message, canvas.width / 2, canvas.height - 28);

    ctx.restore();

    setTimeout(() => {
        calculate();
    }, 2000);
}

// Make functions globally accessible
window.startSlideAnimation = startSlideAnimation;
window.stopAnimation = stopAnimation;
window.resetAnimation = resetAnimation;
