// Momentum Calculator - p = mv, J = FΔt, Collisions
// Using Matter.js for realistic physics visualization

let currentMode = 'basic';
let collisionType = 'elastic';
let stepsExpanded = false;
let canvas, ctx;

// Matter.js modules
let Engine, Render, Runner, Bodies, Body, Composite, Events, World;

// Matter.js instances
let engine, render, runner;
let ball1, ball2;
let walls = [];
let matterInitialized = false;

// Animation state
let isAnimating = false;
let animationPhase = 'before';

// Collision data
let collisionData = {
    m1: 5, m2: 3,
    u1: 10, u2: -5,
    v1: 0, v2: 0,
    e: 1
};

// Unit conversions
const massConv = { 'kg': 1, 'g': 0.001, 'lb': 0.453592 };
const velConv = { 'm/s': 1, 'km/h': 1/3.6, 'mph': 0.44704 };
const forceConv = { 'N': 1, 'kN': 1000 };
const timeConv = { 's': 1, 'ms': 0.001 };

document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('collision-canvas');
    ctx = canvas.getContext('2d');

    // Initialize Matter.js if available
    if (typeof Matter !== 'undefined') {
        Engine = Matter.Engine;
        Render = Matter.Render;
        Runner = Matter.Runner;
        Bodies = Matter.Bodies;
        Body = Matter.Body;
        Composite = Matter.Composite;
        Events = Matter.Events;
        World = Matter.World;

        initMatterJS();
        matterInitialized = true;
    }

    setupCanvas();
    calculate();

    document.querySelectorAll('.number-input').forEach(input => {
        input.addEventListener('input', calculate);
    });

    window.addEventListener('resize', () => {
        setupCanvas();
        if (matterInitialized && currentMode === 'collision') {
            resetMatterBodies();
        }
        drawVisualization();
    });
});

function setupCanvas() {
    const container = document.getElementById('collision-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
}

function initMatterJS() {
    // Create engine with no gravity (horizontal collision)
    engine = Engine.create({
        gravity: { x: 0, y: 0 }
    });

    // Create runner
    runner = Runner.create();

    // Setup collision detection
    Events.on(engine, 'collisionStart', (event) => {
        if (isAnimating && animationPhase === 'before') {
            animationPhase = 'collision';
            showCollisionEffect();
            setTimeout(() => {
                animationPhase = 'after';
            }, 300);
        }
    });

    createMatterBodies();
}

function createMatterBodies() {
    const container = document.getElementById('collision-container');
    const width = container.offsetWidth;
    const height = container.offsetHeight;

    // Clear existing bodies
    if (engine) {
        Composite.clear(engine.world, false);
    }

    const { m1, m2, e } = collisionData;

    // Calculate radii based on mass (visual scaling)
    const r1 = Math.max(20, Math.min(45, 20 + Math.log10(m1 + 1) * 12));
    const r2 = Math.max(20, Math.min(45, 20 + Math.log10(m2 + 1) * 12));

    // Create balls with proper restitution
    ball1 = Bodies.circle(width * 0.25, height / 2, r1, {
        restitution: e,
        friction: 0,
        frictionAir: 0,
        label: 'ball1',
        render: { fillStyle: '#3b82f6' }
    });

    ball2 = Bodies.circle(width * 0.75, height / 2, r2, {
        restitution: e,
        friction: 0,
        frictionAir: 0,
        label: 'ball2',
        render: { fillStyle: '#f59e0b' }
    });

    // Set mass (Matter.js uses density, so we adjust)
    Body.setMass(ball1, m1);
    Body.setMass(ball2, m2);

    // Create walls (invisible boundaries)
    const wallOptions = { isStatic: true, restitution: 1, friction: 0 };
    walls = [
        Bodies.rectangle(width / 2, -25, width, 50, wallOptions), // top
        Bodies.rectangle(width / 2, height + 25, width, 50, wallOptions), // bottom
        Bodies.rectangle(-25, height / 2, 50, height, wallOptions), // left
        Bodies.rectangle(width + 25, height / 2, 50, height, wallOptions) // right
    ];

    // Add all bodies to world
    Composite.add(engine.world, [ball1, ball2, ...walls]);
}

function resetMatterBodies() {
    if (!matterInitialized) return;

    const container = document.getElementById('collision-container');
    const width = container.offsetWidth;
    const height = container.offsetHeight;

    createMatterBodies();

    // Reset positions
    Body.setPosition(ball1, { x: width * 0.25, y: height / 2 });
    Body.setPosition(ball2, { x: width * 0.75, y: height / 2 });
    Body.setVelocity(ball1, { x: 0, y: 0 });
    Body.setVelocity(ball2, { x: 0, y: 0 });
    Body.setAngularVelocity(ball1, 0);
    Body.setAngularVelocity(ball2, 0);
}

function setMode(mode) {
    currentMode = mode;
    stopAnimation();

    document.querySelectorAll('.mode-tab').forEach(tab => {
        tab.classList.toggle('active', tab.dataset.mode === mode);
    });

    document.getElementById('basic-inputs').style.display = mode === 'basic' ? 'block' : 'none';
    document.getElementById('impulse-inputs').style.display = mode === 'impulse' ? 'block' : 'none';
    document.getElementById('collision-inputs').style.display = mode === 'collision' ? 'block' : 'none';

    // Show/hide animate button and momentum bars (only for collision mode)
    document.getElementById('animate-btn').style.display = mode === 'collision' ? 'flex' : 'none';
    document.getElementById('momentum-bars').style.display = mode === 'collision' ? 'flex' : 'none';

    calculate();
}

function setCollisionType(type) {
    collisionType = type;

    document.querySelectorAll('.collision-type-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.type === type);
    });

    // Show restitution slider for inelastic
    const restitutionSection = document.getElementById('restitution-section');
    restitutionSection.classList.toggle('show', type === 'inelastic');

    if (type === 'elastic') {
        collisionData.e = 1;
    } else if (type === 'perfect') {
        collisionData.e = 0;
    } else {
        collisionData.e = parseFloat(document.getElementById('restitution').value);
    }

    // Update Matter.js bodies with new restitution
    if (matterInitialized && ball1 && ball2) {
        ball1.restitution = collisionData.e;
        ball2.restitution = collisionData.e;
    }

    calculate();
}

function updateRestitution() {
    const e = parseFloat(document.getElementById('restitution').value);
    document.getElementById('restitution-value').textContent = e.toFixed(2);
    collisionData.e = e;

    if (matterInitialized && ball1 && ball2) {
        ball1.restitution = e;
        ball2.restitution = e;
    }

    calculate();
}

function calculate() {
    if (currentMode === 'basic') {
        calculateBasicMomentum();
    } else if (currentMode === 'impulse') {
        calculateImpulse();
    } else {
        calculateCollision();
    }
}

function calculateBasicMomentum() {
    const mass = parseFloat(document.getElementById('mass-basic').value) * massConv[document.getElementById('mass-basic-unit').value];
    const vel = parseFloat(document.getElementById('vel-basic').value) * velConv[document.getElementById('vel-basic-unit').value];

    const momentum = mass * vel;
    const ke = 0.5 * mass * vel * vel;

    document.getElementById('result-momentum').textContent = formatMomentum(momentum);
    document.getElementById('result-before').textContent = formatNum(mass) + ' kg';
    document.getElementById('result-after').textContent = formatNum(vel) + ' m/s';
    document.getElementById('result-ke-lost').textContent = formatEnergy(ke);

    // Update labels for basic mode
    document.querySelector('#results-grid .result-card:nth-child(2) .result-label').textContent = 'Mass';
    document.querySelector('#results-grid .result-card:nth-child(3) .result-label').textContent = 'Velocity';
    document.querySelector('#results-grid .result-card:nth-child(4) .result-label').textContent = 'Kinetic Energy';

    // Update info pills
    document.getElementById('info-p1').textContent = 'p = ' + formatMomentum(momentum);
    document.getElementById('info-p2').textContent = 'm = ' + formatNum(mass) + ' kg';
    document.getElementById('info-total').textContent = 'v = ' + formatNum(vel) + ' m/s';

    drawBasicVisualization(mass, vel, momentum);
    generateBasicSteps(mass, vel, momentum, ke);
}

function calculateImpulse() {
    const force = parseFloat(document.getElementById('force-impulse').value) * forceConv[document.getElementById('force-impulse-unit').value];
    const time = parseFloat(document.getElementById('time-impulse').value) * timeConv[document.getElementById('time-impulse-unit').value];
    const mass = parseFloat(document.getElementById('mass-impulse').value);

    const impulse = force * time;
    const deltaV = mass > 0 ? impulse / mass : 0;

    document.getElementById('result-momentum').textContent = formatMomentum(impulse);
    document.getElementById('result-before').textContent = formatNum(force) + ' N';
    document.getElementById('result-after').textContent = formatNum(time * 1000) + ' ms';
    document.getElementById('result-ke-lost').textContent = formatNum(deltaV) + ' m/s';

    // Update labels
    document.querySelector('#results-grid .result-card:nth-child(1) .result-label').textContent = 'Impulse (J)';
    document.querySelector('#results-grid .result-card:nth-child(2) .result-label').textContent = 'Force';
    document.querySelector('#results-grid .result-card:nth-child(3) .result-label').textContent = 'Duration';
    document.querySelector('#results-grid .result-card:nth-child(4) .result-label').textContent = 'Δv (if m=' + mass + 'kg)';

    document.getElementById('info-p1').textContent = 'J = ' + formatMomentum(impulse);
    document.getElementById('info-p2').textContent = 'F = ' + formatNum(force) + ' N';
    document.getElementById('info-total').textContent = 'Δt = ' + formatNum(time * 1000) + ' ms';

    drawImpulseVisualization(force, time, impulse);
    generateImpulseSteps(force, time, impulse, mass, deltaV);
}

function calculateCollision() {
    const m1 = parseFloat(document.getElementById('m1').value) || 5;
    const m2 = parseFloat(document.getElementById('m2').value) || 3;
    const u1 = parseFloat(document.getElementById('u1').value) || 10;
    const u2 = parseFloat(document.getElementById('u2').value) || -5;
    const e = collisionData.e;

    collisionData.m1 = m1;
    collisionData.m2 = m2;
    collisionData.u1 = u1;
    collisionData.u2 = u2;

    // Calculate final velocities based on collision type
    let v1, v2;

    if (collisionType === 'perfect') {
        // Perfectly inelastic: objects stick together
        v1 = v2 = (m1 * u1 + m2 * u2) / (m1 + m2);
    } else {
        // General case using coefficient of restitution
        v1 = ((m1 - e * m2) * u1 + (1 + e) * m2 * u2) / (m1 + m2);
        v2 = ((m2 - e * m1) * u2 + (1 + e) * m1 * u1) / (m1 + m2);
    }

    collisionData.v1 = v1;
    collisionData.v2 = v2;

    // Calculate momenta
    const p1_before = m1 * u1;
    const p2_before = m2 * u2;
    const p_total_before = p1_before + p2_before;

    const p1_after = m1 * v1;
    const p2_after = m2 * v2;
    const p_total_after = p1_after + p2_after;

    // Calculate kinetic energies
    const ke_before = 0.5 * m1 * u1 * u1 + 0.5 * m2 * u2 * u2;
    const ke_after = 0.5 * m1 * v1 * v1 + 0.5 * m2 * v2 * v2;
    const ke_lost = ke_before - ke_after;

    // Update results
    document.getElementById('result-momentum').textContent = formatMomentum(p_total_before);
    document.getElementById('result-before').textContent = formatMomentum(p_total_before);
    document.getElementById('result-after').textContent = formatMomentum(p_total_after);
    document.getElementById('result-ke-lost').textContent = formatEnergy(ke_lost);

    // Reset labels for collision mode
    document.querySelector('#results-grid .result-card:nth-child(1) .result-label').textContent = 'Total Momentum';
    document.querySelector('#results-grid .result-card:nth-child(2) .result-label').textContent = 'Total Before';
    document.querySelector('#results-grid .result-card:nth-child(3) .result-label').textContent = 'Total After';
    document.querySelector('#results-grid .result-card:nth-child(4) .result-label').textContent = 'KE Lost';

    // Update info pills
    document.getElementById('info-p1').textContent = 'p₁ = ' + formatMomentum(p1_before);
    document.getElementById('info-p2').textContent = 'p₂ = ' + formatMomentum(p2_before);
    document.getElementById('info-total').textContent = 'Σp = ' + formatMomentum(p_total_before);

    // Update momentum bars
    updateMomentumBars(p1_before, p2_before, p1_after, p2_after);

    // Update Matter.js bodies
    if (matterInitialized) {
        resetMatterBodies();
    }

    drawVisualization();
    generateCollisionSteps(m1, m2, u1, u2, v1, v2, e, p_total_before, ke_before, ke_after, ke_lost);
}

function updateMomentumBars(p1_before, p2_before, p1_after, p2_after) {
    const totalBefore = Math.abs(p1_before) + Math.abs(p2_before);
    const totalAfter = Math.abs(p1_after) + Math.abs(p2_after);

    const scale = 100 / Math.max(totalBefore, totalAfter, 1);

    document.getElementById('bar-before-1').style.width = (Math.abs(p1_before) * scale) + '%';
    document.getElementById('bar-before-2').style.width = (Math.abs(p2_before) * scale) + '%';
    document.getElementById('bar-after-1').style.width = (Math.abs(p1_after) * scale) + '%';
    document.getElementById('bar-after-2').style.width = (Math.abs(p2_after) * scale) + '%';
}

function drawVisualization() {
    if (currentMode === 'collision') {
        if (matterInitialized && isAnimating) {
            drawMatterVisualization();
        } else {
            drawCollisionVisualization();
        }
    }
}

function drawBasicVisualization(mass, vel, momentum) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const cx = canvas.width / 2;
    const cy = canvas.height / 2;

    // Draw object with gradient
    const radius = Math.min(30 + Math.log10(mass + 1) * 15, 60);
    const gradient = ctx.createRadialGradient(cx - radius/3, cy - radius/3, 0, cx, cy, radius);
    gradient.addColorStop(0, '#60a5fa');
    gradient.addColorStop(1, '#2563eb');

    ctx.beginPath();
    ctx.fillStyle = gradient;
    ctx.arc(cx, cy, radius, 0, Math.PI * 2);
    ctx.fill();

    // Add shine
    ctx.beginPath();
    ctx.fillStyle = 'rgba(255,255,255,0.3)';
    ctx.arc(cx - radius/3, cy - radius/3, radius/3, 0, Math.PI * 2);
    ctx.fill();

    // Draw velocity arrow
    if (vel !== 0) {
        const arrowLen = Math.min(Math.abs(vel) * 8, 100) * Math.sign(vel);
        drawArrow(cx, cy, cx + arrowLen, cy, '#dc2626', 3);
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 12px Inter';
        ctx.textAlign = 'center';
        ctx.fillText('v = ' + formatNum(vel) + ' m/s', cx + arrowLen / 2, cy - 25);
    }

    // Label
    ctx.fillStyle = 'white';
    ctx.font = 'bold 14px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('m', cx, cy + 5);
}

function drawImpulseVisualization(force, time, impulse) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const cx = canvas.width / 2;
    const cy = canvas.height / 2;

    // Draw object with gradient
    const gradient = ctx.createRadialGradient(cx - 15, cy - 15, 0, cx, cy, 40);
    gradient.addColorStop(0, '#60a5fa');
    gradient.addColorStop(1, '#2563eb');

    ctx.beginPath();
    ctx.fillStyle = gradient;
    ctx.arc(cx, cy, 40, 0, Math.PI * 2);
    ctx.fill();

    // Draw force arrow with animation effect
    const arrowLen = Math.min(force / 10, 100);
    const pulseScale = 1 + 0.1 * Math.sin(Date.now() / 200);
    drawArrow(cx - 80, cy, cx - 80 + arrowLen * pulseScale, cy, '#dc2626', 4);

    ctx.fillStyle = '#dc2626';
    ctx.font = 'bold 12px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('F = ' + formatNum(force) + ' N', cx - 80 + arrowLen / 2, cy - 25);

    // Draw time indicator
    ctx.fillStyle = '#64748b';
    ctx.font = '11px Inter';
    ctx.fillText('Δt = ' + formatNum(time * 1000) + ' ms', cx, cy + 70);

    // Impulse result
    ctx.fillStyle = '#059669';
    ctx.font = 'bold 14px Inter';
    ctx.fillText('J = ' + formatMomentum(impulse), cx, cy + 90);
}

function drawCollisionVisualization() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const { m1, m2, u1, u2, v1, v2 } = collisionData;

    const cy = canvas.height / 2;

    // Calculate positions
    let x1 = canvas.width * 0.25;
    let x2 = canvas.width * 0.75;
    let vel1 = u1;
    let vel2 = u2;

    // Draw track
    ctx.strokeStyle = 'rgba(0,0,0,0.1)';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(50, cy);
    ctx.lineTo(canvas.width - 50, cy);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw object 1 (blue) with gradient
    const r1 = Math.max(20, Math.min(45, 20 + Math.log10(m1 + 1) * 12));
    const gradient1 = ctx.createRadialGradient(x1 - r1/3, cy - r1/3, 0, x1, cy, r1);
    gradient1.addColorStop(0, '#60a5fa');
    gradient1.addColorStop(1, '#2563eb');

    ctx.beginPath();
    ctx.fillStyle = gradient1;
    ctx.arc(x1, cy, r1, 0, Math.PI * 2);
    ctx.fill();

    // Shine on ball 1
    ctx.beginPath();
    ctx.fillStyle = 'rgba(255,255,255,0.3)';
    ctx.arc(x1 - r1/3, cy - r1/3, r1/4, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = 'white';
    ctx.font = 'bold 11px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('m₁', x1, cy + 4);

    // Draw object 2 (orange) with gradient
    const r2 = Math.max(20, Math.min(45, 20 + Math.log10(m2 + 1) * 12));
    const gradient2 = ctx.createRadialGradient(x2 - r2/3, cy - r2/3, 0, x2, cy, r2);
    gradient2.addColorStop(0, '#fbbf24');
    gradient2.addColorStop(1, '#f59e0b');

    ctx.beginPath();
    ctx.fillStyle = gradient2;
    ctx.arc(x2, cy, r2, 0, Math.PI * 2);
    ctx.fill();

    // Shine on ball 2
    ctx.beginPath();
    ctx.fillStyle = 'rgba(255,255,255,0.3)';
    ctx.arc(x2 - r2/3, cy - r2/3, r2/4, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = 'white';
    ctx.fillText('m₂', x2, cy + 4);

    // Draw velocity arrows
    if (vel1 !== 0) {
        const arrow1Len = Math.min(Math.abs(vel1) * 5, 60) * Math.sign(vel1);
        drawArrow(x1 + r1 * Math.sign(vel1), cy - r1 - 15, x1 + r1 * Math.sign(vel1) + arrow1Len, cy - r1 - 15, '#2563eb', 2);
        ctx.fillStyle = '#2563eb';
        ctx.font = '10px JetBrains Mono';
        ctx.fillText(`u₁=${formatNum(vel1)}`, x1, cy - r1 - 30);
    }
    if (vel2 !== 0) {
        const arrow2Len = Math.min(Math.abs(vel2) * 5, 60) * Math.sign(vel2);
        drawArrow(x2 + r2 * Math.sign(vel2), cy - r2 - 15, x2 + r2 * Math.sign(vel2) + arrow2Len, cy - r2 - 15, '#d97706', 2);
        ctx.fillStyle = '#d97706';
        ctx.font = '10px JetBrains Mono';
        ctx.fillText(`u₂=${formatNum(vel2)}`, x2, cy - r2 - 30);
    }

    // Phase label
    ctx.fillStyle = '#64748b';
    ctx.font = '12px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('Before Collision - Click "Animate" to see physics!', canvas.width / 2, 25);
}

function drawMatterVisualization() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (!ball1 || !ball2) return;

    const { m1, m2 } = collisionData;
    const cy = canvas.height / 2;

    // Draw track
    ctx.strokeStyle = 'rgba(0,0,0,0.1)';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(50, cy);
    ctx.lineTo(canvas.width - 50, cy);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw ball 1
    const r1 = ball1.circleRadius;
    const x1 = ball1.position.x;
    const y1 = ball1.position.y;

    const gradient1 = ctx.createRadialGradient(x1 - r1/3, y1 - r1/3, 0, x1, y1, r1);
    gradient1.addColorStop(0, '#60a5fa');
    gradient1.addColorStop(1, '#2563eb');

    ctx.beginPath();
    ctx.fillStyle = gradient1;
    ctx.arc(x1, y1, r1, 0, Math.PI * 2);
    ctx.fill();

    // Shine
    ctx.beginPath();
    ctx.fillStyle = 'rgba(255,255,255,0.3)';
    ctx.arc(x1 - r1/3, y1 - r1/3, r1/4, 0, Math.PI * 2);
    ctx.fill();

    // Label
    ctx.fillStyle = 'white';
    ctx.font = 'bold 11px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('m₁', x1, y1 + 4);

    // Draw ball 2
    const r2 = ball2.circleRadius;
    const x2 = ball2.position.x;
    const y2 = ball2.position.y;

    const gradient2 = ctx.createRadialGradient(x2 - r2/3, y2 - r2/3, 0, x2, y2, r2);
    gradient2.addColorStop(0, '#fbbf24');
    gradient2.addColorStop(1, '#f59e0b');

    ctx.beginPath();
    ctx.fillStyle = gradient2;
    ctx.arc(x2, y2, r2, 0, Math.PI * 2);
    ctx.fill();

    // Shine
    ctx.beginPath();
    ctx.fillStyle = 'rgba(255,255,255,0.3)';
    ctx.arc(x2 - r2/3, y2 - r2/3, r2/4, 0, Math.PI * 2);
    ctx.fill();

    // Label
    ctx.fillStyle = 'white';
    ctx.fillText('m₂', x2, y2 + 4);

    // Velocity arrows (from Matter.js velocities)
    const v1x = ball1.velocity.x;
    const v2x = ball2.velocity.x;

    if (Math.abs(v1x) > 0.5) {
        const arrow1Len = Math.min(Math.abs(v1x) * 3, 60) * Math.sign(v1x);
        drawArrow(x1, y1 - r1 - 15, x1 + arrow1Len, y1 - r1 - 15, '#2563eb', 2);
    }
    if (Math.abs(v2x) > 0.5) {
        const arrow2Len = Math.min(Math.abs(v2x) * 3, 60) * Math.sign(v2x);
        drawArrow(x2, y2 - r2 - 15, x2 + arrow2Len, y2 - r2 - 15, '#d97706', 2);
    }

    // Velocity labels
    ctx.font = '10px JetBrains Mono';
    ctx.fillStyle = '#3b82f6';
    ctx.fillText(`v₁=${formatNum(v1x / 2)} m/s`, x1, y1 + r1 + 18);
    ctx.fillStyle = '#f59e0b';
    ctx.fillText(`v₂=${formatNum(v2x / 2)} m/s`, x2, y2 + r2 + 18);

    // Phase label
    ctx.textAlign = 'center';
    if (animationPhase === 'before') {
        ctx.fillStyle = '#64748b';
        ctx.font = '12px Inter';
        ctx.fillText('Approaching...', canvas.width / 2, 25);
    } else if (animationPhase === 'collision') {
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 16px Inter';
        ctx.fillText('💥 COLLISION!', canvas.width / 2, 28);
    } else {
        ctx.fillStyle = '#059669';
        ctx.font = '12px Inter';
        ctx.fillText('After Collision - Momentum Conserved!', canvas.width / 2, 25);
    }
}

function showCollisionEffect() {
    // Flash effect on collision
    const container = document.getElementById('collision-container');
    container.style.boxShadow = '0 0 30px rgba(220, 38, 38, 0.6)';
    setTimeout(() => {
        container.style.boxShadow = '';
    }, 200);
}

function drawArrow(x1, y1, x2, y2, color, width) {
    const angle = Math.atan2(y2 - y1, x2 - x1);
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = width;
    ctx.lineCap = 'round';

    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2 - 10 * Math.cos(angle - 0.4), y2 - 10 * Math.sin(angle - 0.4));
    ctx.lineTo(x2 - 10 * Math.cos(angle + 0.4), y2 - 10 * Math.sin(angle + 0.4));
    ctx.closePath();
    ctx.fill();
}

function toggleAnimation() {
    if (isAnimating) {
        stopAnimation();
    } else {
        startAnimation();
    }
}

function startAnimation() {
    if (currentMode !== 'collision') return;
    if (!matterInitialized) {
        alert('Matter.js not loaded. Using fallback animation.');
        startFallbackAnimation();
        return;
    }

    isAnimating = true;
    animationPhase = 'before';

    const { u1, u2 } = collisionData;

    // Reset positions
    resetMatterBodies();

    // Set initial velocities (scale for visual effect)
    const velScale = 2;
    Body.setVelocity(ball1, { x: u1 * velScale, y: 0 });
    Body.setVelocity(ball2, { x: u2 * velScale, y: 0 });

    // Start physics engine
    Runner.run(runner, engine);

    const btn = document.getElementById('animate-btn');
    btn.innerHTML = '<span>⏹️</span><span>Stop Animation</span>';
    btn.classList.add('stop');

    // Start render loop
    renderLoop();
}

function renderLoop() {
    if (!isAnimating) return;

    drawMatterVisualization();
    requestAnimationFrame(renderLoop);
}

function stopAnimation() {
    isAnimating = false;
    animationPhase = 'before';

    if (matterInitialized && runner) {
        Runner.stop(runner);
        resetMatterBodies();
    }

    const btn = document.getElementById('animate-btn');
    btn.innerHTML = '<span>▶️</span><span>Animate Collision</span>';
    btn.classList.remove('stop');

    drawVisualization();
}

function startFallbackAnimation() {
    // Fallback for when Matter.js isn't available
    isAnimating = true;
    animationPhase = 'before';
    let animationTime = 0;

    const btn = document.getElementById('animate-btn');
    btn.innerHTML = '<span>⏹️</span><span>Stop Animation</span>';
    btn.classList.add('stop');

    function animate() {
        if (!isAnimating) return;

        animationTime += 0.05;

        if (animationPhase === 'before' && animationTime > 1.5) {
            animationPhase = 'collision';
            animationTime = 0;
            showCollisionEffect();
        } else if (animationPhase === 'collision' && animationTime > 0.3) {
            animationPhase = 'after';
            animationTime = 0;
        } else if (animationPhase === 'after' && animationTime > 2.5) {
            animationPhase = 'before';
            animationTime = 0;
        }

        drawFallbackAnimation(animationTime);
        requestAnimationFrame(animate);
    }

    animate();
}

function drawFallbackAnimation(time) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const { m1, m2, u1, u2, v1, v2 } = collisionData;
    const cy = canvas.height / 2;
    const scale = 15;

    let x1, x2, vel1, vel2;

    if (animationPhase === 'before') {
        x1 = canvas.width * 0.25 + u1 * time * scale;
        x2 = canvas.width * 0.75 + u2 * time * scale;
        vel1 = u1;
        vel2 = u2;
    } else if (animationPhase === 'collision') {
        x1 = canvas.width / 2 - 30;
        x2 = canvas.width / 2 + 30;
        vel1 = 0;
        vel2 = 0;
    } else {
        x1 = canvas.width / 2 - 30 + v1 * time * scale;
        x2 = canvas.width / 2 + 30 + v2 * time * scale;
        vel1 = v1;
        vel2 = v2;
    }

    // Draw track
    ctx.strokeStyle = 'rgba(0,0,0,0.1)';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(50, cy);
    ctx.lineTo(canvas.width - 50, cy);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw balls with gradients
    const r1 = Math.max(20, Math.min(45, 20 + Math.log10(m1 + 1) * 12));
    const r2 = Math.max(20, Math.min(45, 20 + Math.log10(m2 + 1) * 12));

    // Ball 1
    const gradient1 = ctx.createRadialGradient(x1 - r1/3, cy - r1/3, 0, x1, cy, r1);
    gradient1.addColorStop(0, '#60a5fa');
    gradient1.addColorStop(1, '#2563eb');
    ctx.beginPath();
    ctx.fillStyle = gradient1;
    ctx.arc(x1, cy, r1, 0, Math.PI * 2);
    ctx.fill();

    // Ball 2
    const gradient2 = ctx.createRadialGradient(x2 - r2/3, cy - r2/3, 0, x2, cy, r2);
    gradient2.addColorStop(0, '#fbbf24');
    gradient2.addColorStop(1, '#f59e0b');
    ctx.beginPath();
    ctx.fillStyle = gradient2;
    ctx.arc(x2, cy, r2, 0, Math.PI * 2);
    ctx.fill();

    // Labels
    ctx.fillStyle = 'white';
    ctx.font = 'bold 11px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('m₁', x1, cy + 4);
    ctx.fillText('m₂', x2, cy + 4);

    // Phase label
    if (animationPhase === 'before') {
        ctx.fillStyle = '#64748b';
        ctx.font = '12px Inter';
        ctx.fillText('Before Collision', canvas.width / 2, 25);
    } else if (animationPhase === 'collision') {
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 16px Inter';
        ctx.fillText('💥 COLLISION!', canvas.width / 2, 28);
    } else {
        ctx.fillStyle = '#059669';
        ctx.font = '12px Inter';
        ctx.fillText('After Collision', canvas.width / 2, 25);
    }
}

function formatNum(n) {
    if (!isFinite(n)) return '0';
    if (Math.abs(n) >= 10000) return n.toExponential(2);
    if (Math.abs(n) >= 100) return n.toFixed(1);
    if (Math.abs(n) >= 1) return n.toFixed(2);
    if (Math.abs(n) >= 0.01) return n.toFixed(3);
    return n.toExponential(2);
}

function formatMomentum(p) {
    if (Math.abs(p) >= 1000) return (p / 1000).toFixed(2) + ' kN·s';
    return formatNum(p) + ' kg·m/s';
}

function formatEnergy(e) {
    if (Math.abs(e) >= 1000) return (e / 1000).toFixed(2) + ' kJ';
    return formatNum(e) + ' J';
}

function toggleSteps() {
    stepsExpanded = !stepsExpanded;
    document.getElementById('steps-body').classList.toggle('collapsed', !stepsExpanded);
    document.getElementById('steps-toggle').textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
}

function generateBasicSteps(mass, vel, momentum, ke) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Mass: <span class="highlight">m = ${formatNum(mass)} kg</span><br>
                Velocity: <span class="highlight">v = ${formatNum(vel)} m/s</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Calculate Momentum</div>
            <div class="step-formula">p = mv</div>
            <div class="step-calc">
                p = ${formatNum(mass)} × ${formatNum(vel)}<br>
                p = <span class="highlight">${formatMomentum(momentum)}</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Momentum</div>
                <div class="step-result-value">${formatMomentum(momentum)}</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Kinetic Energy</div>
            <div class="step-formula">KE = ½mv²</div>
            <div class="step-calc">
                KE = ½ × ${formatNum(mass)} × (${formatNum(vel)})²<br>
                KE = <span class="highlight">${formatEnergy(ke)}</span>
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function generateImpulseSteps(force, time, impulse, mass, deltaV) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Force: <span class="highlight">F = ${formatNum(force)} N</span><br>
                Time: <span class="highlight">Δt = ${formatNum(time * 1000)} ms = ${formatNum(time)} s</span>
                ${mass > 0 ? `<br>Mass: <span class="highlight">m = ${formatNum(mass)} kg</span>` : ''}
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Calculate Impulse</div>
            <div class="step-formula">J = F × Δt</div>
            <div class="step-calc">
                J = ${formatNum(force)} × ${formatNum(time)}<br>
                J = <span class="highlight">${formatMomentum(impulse)}</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Impulse</div>
                <div class="step-result-value">${formatMomentum(impulse)}</div>
            </div>
        </div>
        ${mass > 0 ? `
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Velocity Change</div>
            <div class="step-formula">J = Δp = m × Δv → Δv = J/m</div>
            <div class="step-calc">
                Δv = ${formatMomentum(impulse)} / ${formatNum(mass)} kg<br>
                Δv = <span class="highlight">${formatNum(deltaV)} m/s</span>
            </div>
        </div>
        ` : ''}
        <div class="step-item">
            <div class="step-title"><span class="step-number">${mass > 0 ? 4 : 3}</span>Physical Interpretation</div>
            <div class="step-calc">
                The impulse of <span class="highlight">${formatMomentum(impulse)}</span> represents the change in momentum.<br>
                <em>Longer contact time with same impulse means less force (airbag principle).</em>
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function generateCollisionSteps(m1, m2, u1, u2, v1, v2, e, p_total, ke_before, ke_after, ke_lost) {
    const p1_before = m1 * u1;
    const p2_before = m2 * u2;
    const p1_after = m1 * v1;
    const p2_after = m2 * v2;

    const collisionName = e === 1 ? 'Elastic' : (e === 0 ? 'Perfectly Inelastic' : `Inelastic (e=${e.toFixed(2)})`);

    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                <strong>Object 1:</strong> m₁ = ${formatNum(m1)} kg, u₁ = ${formatNum(u1)} m/s<br>
                <strong>Object 2:</strong> m₂ = ${formatNum(m2)} kg, u₂ = ${formatNum(u2)} m/s<br>
                <strong>Collision Type:</strong> <span class="highlight">${collisionName}</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Calculate Initial Momenta</div>
            <div class="step-formula">p = mv</div>
            <div class="step-calc">
                p₁ = ${formatNum(m1)} × ${formatNum(u1)} = <span class="highlight">${formatMomentum(p1_before)}</span><br>
                p₂ = ${formatNum(m2)} × ${formatNum(u2)} = <span class="highlight">${formatMomentum(p2_before)}</span><br>
                Total: Σp = ${formatMomentum(p1_before)} + ${formatMomentum(p2_before)} = <span class="highlight">${formatMomentum(p_total)}</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Apply Conservation Laws</div>
            <div class="step-formula">m₁u₁ + m₂u₂ = m₁v₁ + m₂v₂${e < 1 ? '<br>e = -(v₁ - v₂)/(u₁ - u₂)' : ''}</div>
            <div class="step-calc">
                ${e === 0 ? `
                    Perfectly inelastic: objects stick together<br>
                    v = (m₁u₁ + m₂u₂)/(m₁ + m₂)<br>
                    v = (${formatNum(m1 * u1)} + ${formatNum(m2 * u2)})/(${formatNum(m1 + m2)})<br>
                    v = <span class="highlight">${formatNum(v1)} m/s</span>
                ` : e === 1 ? `
                    Elastic collision formulas:<br>
                    v₁ = ((m₁-m₂)u₁ + 2m₂u₂)/(m₁+m₂) = <span class="highlight">${formatNum(v1)} m/s</span><br>
                    v₂ = ((m₂-m₁)u₂ + 2m₁u₁)/(m₁+m₂) = <span class="highlight">${formatNum(v2)} m/s</span>
                ` : `
                    Using coefficient of restitution e = ${e.toFixed(2)}:<br>
                    v₁ = <span class="highlight">${formatNum(v1)} m/s</span><br>
                    v₂ = <span class="highlight">${formatNum(v2)} m/s</span>
                `}
            </div>
            <div class="step-result">
                <div class="step-result-label">Final Velocities</div>
                <div class="step-result-value">v₁ = ${formatNum(v1)} m/s, v₂ = ${formatNum(v2)} m/s</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Verify Conservation</div>
            <div class="step-calc">
                Final momenta:<br>
                p₁' = ${formatNum(m1)} × ${formatNum(v1)} = <span class="highlight">${formatMomentum(p1_after)}</span><br>
                p₂' = ${formatNum(m2)} × ${formatNum(v2)} = <span class="highlight">${formatMomentum(p2_after)}</span><br>
                Total: Σp' = <span class="highlight">${formatMomentum(p1_after + p2_after)}</span><br>
                <em style="color: var(--physics-green);">✓ Momentum conserved: ${formatMomentum(p_total)} ≈ ${formatMomentum(p1_after + p2_after)}</em>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">5</span>Energy Analysis</div>
            <div class="step-formula">KE = ½mv²</div>
            <div class="step-calc">
                KE before = ½(${formatNum(m1)})(${formatNum(u1)})² + ½(${formatNum(m2)})(${formatNum(u2)})² = <span class="highlight">${formatEnergy(ke_before)}</span><br>
                KE after = ½(${formatNum(m1)})(${formatNum(v1)})² + ½(${formatNum(m2)})(${formatNum(v2)})² = <span class="highlight">${formatEnergy(ke_after)}</span><br>
                <br>
                <strong>Energy lost:</strong> <span class="highlight" style="color: ${ke_lost > 0.01 ? '#dc2626' : '#059669'};">${formatEnergy(ke_lost)} (${((ke_lost/ke_before)*100).toFixed(1)}%)</span>
                ${e === 1 ? '<br><em style="color: var(--physics-green);">✓ Elastic collision: KE conserved</em>' :
                  e === 0 ? '<br><em style="color: #dc2626;">Maximum energy lost in perfectly inelastic collision</em>' : ''}
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function loadExample(num) {
    stopAnimation();
    setMode('collision');

    const examples = {
        1: { m1: 1000, m2: 800, u1: 20, u2: -15, type: 'perfect' },  // Car crash
        2: { m1: 0.17, m2: 0.17, u1: 5, u2: 0, type: 'elastic' },     // Billiard balls
        3: { m1: 0.6, m2: 1000000, u1: -10, u2: 0, type: 'inelastic', e: 0.8 }, // Bouncing ball
        4: { m1: 50000, m2: 30000, u1: 8, u2: 2, type: 'perfect' }    // Train coupling
    };

    const ex = examples[num];

    document.getElementById('m1').value = ex.m1;
    document.getElementById('m2').value = ex.m2;
    document.getElementById('u1').value = ex.u1;
    document.getElementById('u2').value = ex.u2;

    setCollisionType(ex.type);
    if (ex.e !== undefined) {
        document.getElementById('restitution').value = ex.e;
        updateRestitution();
    }

    calculate();
}

// Expose functions globally
window.setMode = setMode;
window.setCollisionType = setCollisionType;
window.updateRestitution = updateRestitution;
window.calculate = calculate;
window.toggleAnimation = toggleAnimation;
window.toggleSteps = toggleSteps;
window.loadExample = loadExample;
