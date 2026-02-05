// Spring Force Calculator - Hooke's Law (F = -kx) with Matter.js Physics

let solveFor = 'force';
let stepsExpanded = false;
let canvas, ctx;

// Matter.js modules
let Engine, Render, Runner, Bodies, Body, Composite, Constraint, Events, Mouse, MouseConstraint;
let engine, runner;
let anchor, mass;
let springConstraint;
let isAnimating = false;
let animationId = null;

// Unit conversions
const kConversions = { 'N/m': 1, 'kN/m': 1000, 'lbf/in': 175.127 };
const xConversions = { 'm': 1, 'cm': 0.01, 'mm': 0.001, 'in': 0.0254 };
const forceConversions = { 'N': 1, 'kN': 1000, 'lbf': 4.44822 };

// Current calculated values
let currentK = 100;
let currentX = 0.1;
let currentForce = 10;

document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('spring-canvas');
    ctx = canvas.getContext('2d');
    setupCanvas();

    // Initialize Matter.js if available
    if (typeof Matter !== 'undefined') {
        initMatterJS();
    }

    calculate();

    document.querySelectorAll('.number-input').forEach(input => {
        input.addEventListener('input', calculate);
    });

    window.addEventListener('resize', () => {
        setupCanvas();
        if (typeof Matter !== 'undefined') {
            resetMatterBodies();
        }
        calculate();
    });
});

function setupCanvas() {
    const container = document.getElementById('spring-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
}

function initMatterJS() {
    // Get Matter.js modules
    Engine = Matter.Engine;
    Runner = Matter.Runner;
    Bodies = Matter.Bodies;
    Body = Matter.Body;
    Composite = Matter.Composite;
    Constraint = Matter.Constraint;
    Events = Matter.Events;
    Mouse = Matter.Mouse;
    MouseConstraint = Matter.MouseConstraint;

    // Create engine with no gravity (horizontal spring system)
    engine = Engine.create({
        gravity: { x: 0, y: 0 }
    });

    // Create runner
    runner = Runner.create();

    // Create bodies
    createMatterBodies();
}

function createMatterBodies() {
    if (!engine) return;

    const width = canvas.width;
    const height = canvas.height;
    const centerY = height / 2;
    const wallX = 50;
    const equilibriumX = width / 2;

    // Clear existing bodies
    Composite.clear(engine.world);

    // Create fixed anchor point (invisible)
    anchor = Bodies.rectangle(wallX, centerY, 20, 20, {
        isStatic: true,
        render: { visible: false }
    });

    // Create mass (the block)
    mass = Bodies.rectangle(equilibriumX, centerY, 60, 60, {
        mass: 1,
        friction: 0,
        frictionAir: 0.02, // Small damping for realistic oscillation decay
        restitution: 0.8,
        render: { visible: false },
        label: 'springMass'
    });

    // Create spring constraint
    springConstraint = Constraint.create({
        bodyA: anchor,
        bodyB: mass,
        stiffness: 0.05, // Will be adjusted based on k
        damping: 0.01,
        length: equilibriumX - wallX - 30,
        render: {
            visible: true,
            strokeStyle: '#db2777',
            lineWidth: 3
        }
    });

    // Add to world
    Composite.add(engine.world, [anchor, mass, springConstraint]);
}

function resetMatterBodies() {
    if (!engine) return;
    createMatterBodies();
}

function setSolveFor(variable) {
    solveFor = variable;

    document.querySelectorAll('.solve-btn[data-var]').forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.var === variable) btn.classList.add('active');
    });

    const kSection = document.getElementById('k-input-section');
    const xSection = document.getElementById('x-input-section');
    const forceSection = document.getElementById('force-input-section');

    if (variable === 'force') {
        kSection.style.display = 'block';
        xSection.style.display = 'block';
        forceSection.style.display = 'none';
    } else if (variable === 'k') {
        kSection.style.display = 'none';
        xSection.style.display = 'block';
        forceSection.style.display = 'block';
    } else if (variable === 'x') {
        kSection.style.display = 'block';
        xSection.style.display = 'none';
        forceSection.style.display = 'block';
    }

    calculate();
}

function setSpringPreset(value) {
    document.getElementById('spring-constant').value = value;
    document.getElementById('k-unit').value = 'N/m';
    calculate();
}

function calculate() {
    const kInput = parseFloat(document.getElementById('spring-constant').value) || 100;
    const kUnit = document.getElementById('k-unit').value;
    const xInput = parseFloat(document.getElementById('displacement').value) || 0.1;
    const xUnit = document.getElementById('x-unit').value;
    const fInput = parseFloat(document.getElementById('force').value) || 10;
    const fUnit = document.getElementById('force-unit').value;

    // Convert to SI
    let k = kInput * kConversions[kUnit];
    let x = xInput * xConversions[xUnit];
    let force = fInput * forceConversions[fUnit];

    // Calculate based on solve-for
    if (solveFor === 'force') {
        force = k * Math.abs(x);
    } else if (solveFor === 'k') {
        k = force / Math.abs(x);
    } else if (solveFor === 'x') {
        x = force / k;
    }

    // Store current values
    currentK = k;
    currentX = x;
    currentForce = force;

    // Elastic potential energy
    const pe = 0.5 * k * x * x;

    // Update display
    document.getElementById('result-force').textContent = formatNumber(force) + ' N';
    document.getElementById('result-pe').textContent = formatNumber(pe) + ' J';
    document.getElementById('result-k').textContent = formatNumber(k) + ' N/m';
    document.getElementById('result-x').textContent = formatNumber(x) + ' m';

    // Update info pills
    document.getElementById('info-k').textContent = 'k = ' + formatNumber(k) + ' N/m';
    document.getElementById('info-x').textContent = 'x = ' + formatNumber(x) + ' m';
    document.getElementById('info-f').textContent = 'F = ' + formatNumber(force) + ' N';

    // Draw spring (static visualization or update Matter.js)
    if (!isAnimating) {
        drawSpring(k, x, force);
    }

    // Generate steps
    generateSteps(kInput, kUnit, xInput, xUnit, fInput, fUnit, k, x, force, pe);
}

function formatNumber(num) {
    if (Math.abs(num) >= 10000) return num.toExponential(2);
    if (Math.abs(num) >= 100) return num.toFixed(1);
    if (Math.abs(num) >= 10) return num.toFixed(2);
    if (Math.abs(num) >= 1) return num.toFixed(3);
    return num.toFixed(4);
}

function drawSpring(k, x, force) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const centerY = canvas.height / 2;
    const wallX = 50;
    const equilibriumX = canvas.width / 2;

    // Scale displacement for visualization (max 150px)
    const maxVisualDisp = 150;
    const visualDisp = Math.min(Math.abs(x) * 500, maxVisualDisp) * Math.sign(x);
    const blockX = equilibriumX + visualDisp;
    const blockSize = 60;

    // Draw wall with gradient
    const wallGrad = ctx.createLinearGradient(wallX - 15, 0, wallX, 0);
    wallGrad.addColorStop(0, '#475569');
    wallGrad.addColorStop(1, '#64748b');
    ctx.fillStyle = wallGrad;
    ctx.fillRect(wallX - 15, centerY - 80, 15, 160);

    // Wall texture
    ctx.strokeStyle = '#334155';
    ctx.lineWidth = 1;
    for (let i = centerY - 75; i < centerY + 75; i += 15) {
        ctx.beginPath();
        ctx.moveTo(wallX - 12, i);
        ctx.lineTo(wallX - 3, i + 10);
        ctx.stroke();
    }

    // Draw equilibrium line (dashed)
    ctx.beginPath();
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);
    ctx.moveTo(equilibriumX, centerY - 100);
    ctx.lineTo(equilibriumX, centerY + 100);
    ctx.stroke();
    ctx.setLineDash([]);

    // Label equilibrium
    ctx.fillStyle = '#64748b';
    ctx.font = '12px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('Equilibrium', equilibriumX, centerY + 115);

    // Draw spring coils with 3D effect
    drawSpringCoils(wallX, blockX - blockSize / 2, centerY);

    // Draw block with 3D effect
    drawBlock(blockX, centerY, blockSize);

    // Draw force arrow if there's displacement
    if (Math.abs(visualDisp) > 5) {
        drawForceArrow(blockX, centerY, blockSize, visualDisp, force);
    }

    // Draw displacement arrow
    if (Math.abs(visualDisp) > 5) {
        drawDisplacementArrow(equilibriumX, blockX, centerY, x);
    }
}

function drawSpringCoils(startX, endX, centerY) {
    const coils = 12;
    const amplitude = 15;
    const springLength = endX - startX;
    const coilWidth = springLength / coils;

    // Spring shadow
    ctx.beginPath();
    ctx.strokeStyle = 'rgba(0, 0, 0, 0.1)';
    ctx.lineWidth = 5;
    ctx.lineCap = 'round';
    drawCoilPath(startX + 2, endX + 2, centerY + 2, coils, coilWidth, amplitude);
    ctx.stroke();

    // Main spring with gradient
    const springGrad = ctx.createLinearGradient(startX, centerY - amplitude, startX, centerY + amplitude);
    springGrad.addColorStop(0, '#ec4899');
    springGrad.addColorStop(0.5, '#db2777');
    springGrad.addColorStop(1, '#be185d');

    ctx.beginPath();
    ctx.strokeStyle = springGrad;
    ctx.lineWidth = 4;
    drawCoilPath(startX, endX, centerY, coils, coilWidth, amplitude);
    ctx.stroke();

    // Highlight
    ctx.beginPath();
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
    ctx.lineWidth = 2;
    drawCoilPath(startX, endX, centerY - 2, coils, coilWidth, amplitude * 0.9);
    ctx.stroke();
}

function drawCoilPath(startX, endX, centerY, coils, coilWidth, amplitude) {
    ctx.moveTo(startX, centerY);
    for (let i = 0; i < coils; i++) {
        const x1 = startX + coilWidth * (i + 0.25);
        const x2 = startX + coilWidth * (i + 0.5);
        const x3 = startX + coilWidth * (i + 0.75);
        const x4 = startX + coilWidth * (i + 1);

        ctx.lineTo(x1, centerY - amplitude);
        ctx.lineTo(x2, centerY);
        ctx.lineTo(x3, centerY + amplitude);
        ctx.lineTo(x4, centerY);
    }
}

function drawBlock(blockX, centerY, blockSize) {
    const x = blockX - blockSize / 2;
    const y = centerY - blockSize / 2;

    // Block shadow
    ctx.fillStyle = 'rgba(0, 0, 0, 0.2)';
    ctx.fillRect(x + 4, y + 4, blockSize, blockSize);

    // Block gradient
    const blockGrad = ctx.createLinearGradient(x, y, x + blockSize, y + blockSize);
    blockGrad.addColorStop(0, '#a855f7');
    blockGrad.addColorStop(0.5, '#7c3aed');
    blockGrad.addColorStop(1, '#6d28d9');

    ctx.fillStyle = blockGrad;
    ctx.beginPath();
    ctx.roundRect(x, y, blockSize, blockSize, 8);
    ctx.fill();

    // Block highlight
    ctx.fillStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.beginPath();
    ctx.roundRect(x + 3, y + 3, blockSize - 6, blockSize / 3, 4);
    ctx.fill();

    // Mass label
    ctx.fillStyle = 'white';
    ctx.font = 'bold 14px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('m', blockX, centerY);
}

function drawForceArrow(blockX, centerY, blockSize, visualDisp, force) {
    const arrowLength = Math.min(Math.abs(force) * 2, 80);
    const arrowDir = visualDisp > 0 ? -1 : 1; // Force opposes displacement
    const arrowStart = blockX + (visualDisp > 0 ? blockSize / 2 + 10 : -blockSize / 2 - 10);
    const arrowEnd = arrowStart + arrowDir * arrowLength;

    // Arrow shadow
    ctx.beginPath();
    ctx.strokeStyle = 'rgba(0, 0, 0, 0.2)';
    ctx.lineWidth = 6;
    ctx.moveTo(arrowStart + 2, centerY + 2);
    ctx.lineTo(arrowEnd + 2, centerY + 2);
    ctx.stroke();

    // Arrow body
    ctx.beginPath();
    ctx.strokeStyle = '#dc2626';
    ctx.lineWidth = 4;
    ctx.moveTo(arrowStart, centerY);
    ctx.lineTo(arrowEnd, centerY);
    ctx.stroke();

    // Arrowhead
    ctx.beginPath();
    ctx.fillStyle = '#dc2626';
    ctx.moveTo(arrowEnd, centerY);
    ctx.lineTo(arrowEnd - arrowDir * 12, centerY - 8);
    ctx.lineTo(arrowEnd - arrowDir * 12, centerY + 8);
    ctx.closePath();
    ctx.fill();

    // Label
    ctx.fillStyle = '#dc2626';
    ctx.font = 'bold 12px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('F = ' + formatNumber(force) + ' N', (arrowStart + arrowEnd) / 2, centerY - 18);
}

function drawDisplacementArrow(equilibriumX, blockX, centerY, x) {
    const dispY = centerY + 70;

    // Arrow body
    ctx.beginPath();
    ctx.strokeStyle = '#2563eb';
    ctx.lineWidth = 2;
    ctx.moveTo(equilibriumX, dispY);
    ctx.lineTo(blockX, dispY);
    ctx.stroke();

    // Arrowhead
    const dispDir = blockX > equilibriumX ? 1 : -1;
    ctx.beginPath();
    ctx.fillStyle = '#2563eb';
    ctx.moveTo(blockX, dispY);
    ctx.lineTo(blockX - dispDir * 8, dispY - 5);
    ctx.lineTo(blockX - dispDir * 8, dispY + 5);
    ctx.closePath();
    ctx.fill();

    // Label
    ctx.fillStyle = '#2563eb';
    ctx.font = 'bold 11px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('x = ' + formatNumber(x) + ' m', (equilibriumX + blockX) / 2, dispY + 18);
}

// ============ MATTER.JS ANIMATION ============

// Store calculated mass for physics
let currentMass = 1;

function startOscillation() {
    if (isAnimating) {
        stopOscillation();
        return;
    }

    // Always use the accurate simple harmonic motion animation
    // Matter.js spring constraints don't accurately model Hooke's Law
    startSimpleAnimation();
}

function drawEnergyBar(pe, ke) {
    const barX = 10;
    const barY = 10;
    const barWidth = 120;
    const barHeight = 20;
    const total = pe + ke + 0.001;

    // Background
    ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
    ctx.beginPath();
    ctx.roundRect(barX, barY, barWidth, barHeight + 25, 8);
    ctx.fill();

    // PE portion (purple)
    const peWidth = (pe / total) * (barWidth - 10);
    ctx.fillStyle = '#7c3aed';
    ctx.fillRect(barX + 5, barY + 5, peWidth, barHeight - 5);

    // KE portion (green)
    ctx.fillStyle = '#059669';
    ctx.fillRect(barX + 5 + peWidth, barY + 5, (barWidth - 10) - peWidth, barHeight - 5);

    // Labels
    ctx.font = '9px Inter, sans-serif';
    ctx.fillStyle = '#475569';
    ctx.textAlign = 'left';
    ctx.fillText('PE: ' + formatNumber(pe) + ' J', barX + 5, barY + 32);
    ctx.fillText('KE: ' + formatNumber(ke) + ' J', barX + 65, barY + 32);
}

function stopOscillation() {
    isAnimating = false;
    if (animationId) {
        cancelAnimationFrame(animationId);
        animationId = null;
    }
    if (runner && engine) {
        Runner.stop(runner);
    }

    // Reset button state
    const oscillateBtn = document.querySelector('button[onclick="startOscillation()"]');
    if (oscillateBtn) {
        oscillateBtn.innerHTML = '<span>🔄</span><span>Oscillate Spring</span>';
        oscillateBtn.style.background = 'linear-gradient(135deg, #059669, #047857)';
    }

    calculate(); // Redraw static state
}

// Accurate Simple Harmonic Motion animation based on calculated values
function startSimpleAnimation() {
    if (isAnimating) {
        stopOscillation();
        return;
    }

    isAnimating = true;
    let t = 0;

    // Use calculated values for accurate physics
    // For spring: ω = √(k/m), assuming m=1kg for visual demo, or derive from PE
    // Period T = 2π√(m/k)
    const assumedMass = 1; // kg - standard assumption for visualization
    const omega = Math.sqrt(currentK / assumedMass); // Angular frequency (rad/s)
    const amplitude = Math.abs(currentX); // Initial displacement
    const dampingRatio = 0.03; // Light damping for visual appeal

    // Calculate derived values for display
    const period = (2 * Math.PI) / omega;
    const frequency = 1 / period;

    console.log(`Spring oscillation: k=${currentK} N/m, A=${amplitude} m, ω=${omega.toFixed(2)} rad/s, T=${period.toFixed(3)} s`);

    // Update button to show stop state
    const oscillateBtn = document.querySelector('button[onclick="startOscillation()"]');
    if (oscillateBtn) {
        oscillateBtn.innerHTML = '<span>⏹️</span><span>Stop Oscillation</span>';
        oscillateBtn.style.background = 'linear-gradient(135deg, #dc2626, #b91c1c)';
    }

    function animate() {
        if (!isAnimating) return;

        // Real-time increment (60fps assumed)
        t += 0.016; // ~16ms per frame

        // Damped simple harmonic motion: x(t) = A * e^(-γt) * cos(ωt)
        const damping = Math.exp(-dampingRatio * omega * t);
        const x = amplitude * damping * Math.cos(omega * t);
        const velocity = -amplitude * omega * damping * Math.sin(omega * t); // v = dx/dt

        // Force from Hooke's Law (restoring force)
        const force = currentK * Math.abs(x);

        // Energy calculations
        const PE = 0.5 * currentK * x * x; // Potential energy
        const KE = 0.5 * assumedMass * velocity * velocity; // Kinetic energy
        const totalEnergy = PE + KE;

        // Draw the spring with current position
        drawAnimatedSpring(currentK, x, force, velocity, PE, KE);

        // Update info pills
        document.getElementById('info-x').textContent = 'x = ' + formatNumber(x) + ' m';
        document.getElementById('info-f').textContent = 'F = ' + formatNumber(force) + ' N';

        // Continue until amplitude decays significantly or max time reached
        if (Math.abs(x) > amplitude * 0.01 && t < 20) {
            animationId = requestAnimationFrame(animate);
        } else {
            stopOscillation();
        }
    }

    animate();
}

function drawAnimatedSpring(k, x, force, velocity, PE, KE) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const centerY = canvas.height / 2;
    const wallX = 50;
    const equilibriumX = canvas.width / 2;

    // Scale displacement for visualization (max 150px)
    const maxVisualDisp = 150;
    const visualDisp = Math.min(Math.abs(x) * 500, maxVisualDisp) * Math.sign(x);
    const blockX = equilibriumX + visualDisp;
    const blockSize = 60;

    // Draw wall with gradient
    const wallGrad = ctx.createLinearGradient(wallX - 15, 0, wallX, 0);
    wallGrad.addColorStop(0, '#475569');
    wallGrad.addColorStop(1, '#64748b');
    ctx.fillStyle = wallGrad;
    ctx.fillRect(wallX - 15, centerY - 80, 15, 160);

    // Wall texture
    ctx.strokeStyle = '#334155';
    ctx.lineWidth = 1;
    for (let i = centerY - 75; i < centerY + 75; i += 15) {
        ctx.beginPath();
        ctx.moveTo(wallX - 12, i);
        ctx.lineTo(wallX - 3, i + 10);
        ctx.stroke();
    }

    // Draw equilibrium line (dashed)
    ctx.beginPath();
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);
    ctx.moveTo(equilibriumX, centerY - 100);
    ctx.lineTo(equilibriumX, centerY + 100);
    ctx.stroke();
    ctx.setLineDash([]);

    // Label equilibrium
    ctx.fillStyle = '#64748b';
    ctx.font = '12px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('Equilibrium (x=0)', equilibriumX, centerY + 115);

    // Draw spring coils
    drawSpringCoils(wallX, blockX - blockSize / 2, centerY);

    // Draw block with motion blur effect based on velocity
    drawAnimatedBlock(blockX, centerY, blockSize, velocity);

    // Draw force arrow if there's displacement
    if (Math.abs(visualDisp) > 5) {
        drawForceArrow(blockX, centerY, blockSize, visualDisp, force);
    }

    // Draw velocity arrow
    if (Math.abs(velocity) > 0.001) {
        drawVelocityArrow(blockX, centerY - 50, velocity);
    }

    // Draw energy bar
    drawEnergyBar(PE, KE);

    // Draw physics info
    drawPhysicsInfo(x, velocity, force);
}

function drawAnimatedBlock(blockX, centerY, blockSize, velocity) {
    const x = blockX - blockSize / 2;
    const y = centerY - blockSize / 2;

    // Motion blur effect - draw faint trails based on velocity
    const blurIntensity = Math.min(Math.abs(velocity) * 20, 3);
    for (let i = blurIntensity; i > 0; i--) {
        const offset = (velocity > 0 ? -1 : 1) * i * 4;
        ctx.fillStyle = `rgba(168, 85, 247, ${0.1 / i})`;
        ctx.beginPath();
        ctx.roundRect(x + offset, y, blockSize, blockSize, 8);
        ctx.fill();
    }

    // Block shadow
    ctx.fillStyle = 'rgba(0, 0, 0, 0.2)';
    ctx.fillRect(x + 4, y + 4, blockSize, blockSize);

    // Block gradient
    const blockGrad = ctx.createLinearGradient(x, y, x + blockSize, y + blockSize);
    blockGrad.addColorStop(0, '#a855f7');
    blockGrad.addColorStop(0.5, '#7c3aed');
    blockGrad.addColorStop(1, '#6d28d9');

    ctx.fillStyle = blockGrad;
    ctx.beginPath();
    ctx.roundRect(x, y, blockSize, blockSize, 8);
    ctx.fill();

    // Block highlight
    ctx.fillStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.beginPath();
    ctx.roundRect(x + 3, y + 3, blockSize - 6, blockSize / 3, 4);
    ctx.fill();

    // Mass label
    ctx.fillStyle = 'white';
    ctx.font = 'bold 14px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('m', blockX, centerY);
}

function drawVelocityArrow(x, y, velocity) {
    const arrowLength = Math.min(Math.abs(velocity) * 300, 60);
    const dir = velocity > 0 ? 1 : -1;

    if (arrowLength < 5) return;

    ctx.beginPath();
    ctx.strokeStyle = '#059669';
    ctx.lineWidth = 3;
    ctx.moveTo(x, y);
    ctx.lineTo(x + dir * arrowLength, y);
    ctx.stroke();

    // Arrowhead
    ctx.beginPath();
    ctx.fillStyle = '#059669';
    ctx.moveTo(x + dir * arrowLength, y);
    ctx.lineTo(x + dir * (arrowLength - 8), y - 5);
    ctx.lineTo(x + dir * (arrowLength - 8), y + 5);
    ctx.closePath();
    ctx.fill();

    ctx.fillStyle = '#059669';
    ctx.font = 'bold 11px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('v = ' + formatNumber(Math.abs(velocity)) + ' m/s', x + dir * arrowLength / 2, y - 12);
}

function drawPhysicsInfo(x, velocity, force) {
    const infoX = canvas.width - 10;
    const infoY = 15;

    ctx.font = '11px JetBrains Mono, monospace';
    ctx.fillStyle = '#64748b';
    ctx.textAlign = 'right';

    ctx.fillText(`x: ${formatNumber(x)} m`, infoX, infoY);
    ctx.fillText(`v: ${formatNumber(velocity)} m/s`, infoX, infoY + 15);
    ctx.fillText(`F: ${formatNumber(force)} N`, infoX, infoY + 30);
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

function generateSteps(kInput, kUnit, xInput, xUnit, fInput, fUnit, k, x, force, pe) {
    const stepsBody = document.getElementById('steps-body');
    if (!stepsBody) return;

    let html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Identify Given Values</div>
            <div class="step-calc">
                ${solveFor !== 'k' ? `Spring constant: <span class="highlight">k = ${kInput} ${kUnit}</span>
                ${kUnit !== 'N/m' ? `<br>→ Convert: k = ${formatNumber(k)} N/m` : ''}<br>` : ''}
                ${solveFor !== 'x' ? `Displacement: <span class="highlight">x = ${xInput} ${xUnit}</span>
                ${xUnit !== 'm' ? `<br>→ Convert: x = ${formatNumber(x)} m` : ''}<br>` : ''}
                ${solveFor !== 'force' ? `Force: <span class="highlight">F = ${fInput} ${fUnit}</span>
                ${fUnit !== 'N' ? `<br>→ Convert: F = ${formatNumber(force)} N` : ''}` : ''}
            </div>
        </div>

        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Apply Hooke's Law</div>
            <div class="step-formula">F = kx</div>
            <div class="step-calc">
                ${solveFor === 'force' ? `
                    F = ${formatNumber(k)} × ${formatNumber(x)}
                    <br>F = <span class="highlight">${formatNumber(force)} N</span>
                ` : solveFor === 'k' ? `
                    k = F / x
                    <br>k = ${formatNumber(force)} / ${formatNumber(x)}
                    <br>k = <span class="highlight">${formatNumber(k)} N/m</span>
                ` : `
                    x = F / k
                    <br>x = ${formatNumber(force)} / ${formatNumber(k)}
                    <br>x = <span class="highlight">${formatNumber(x)} m</span>
                `}
            </div>
            <div class="step-result">
                <div class="step-result-label">${solveFor === 'force' ? 'Spring Force' : solveFor === 'k' ? 'Spring Constant' : 'Displacement'}</div>
                <div class="step-result-value">${solveFor === 'force' ? formatNumber(force) + ' N' : solveFor === 'k' ? formatNumber(k) + ' N/m' : formatNumber(x) + ' m'}</div>
            </div>
        </div>

        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Elastic Potential Energy</div>
            <div class="step-formula">PE = ½kx²</div>
            <div class="step-calc">
                PE = 0.5 × ${formatNumber(k)} × (${formatNumber(x)})²
                <br>PE = 0.5 × ${formatNumber(k)} × ${formatNumber(x * x)}
                <br>PE = <span class="highlight">${formatNumber(pe)} J</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Elastic Potential Energy</div>
                <div class="step-result-value">${formatNumber(pe)} J</div>
            </div>
        </div>

        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Understanding the Result</div>
            <div class="step-calc">
                • The spring exerts a <span class="highlight">restoring force of ${formatNumber(force)} N</span>
                <br>• This force acts in the <span class="highlight">opposite direction</span> to displacement
                <br>• The spring stores <span class="highlight">${formatNumber(pe)} J</span> of elastic potential energy
                <br>• If released, this energy converts to kinetic energy
            </div>
        </div>
    `;

    stepsBody.innerHTML = html;
}

function loadExample(num) {
    const examples = {
        1: { k: 50000, kUnit: 'N/m', x: 5, xUnit: 'cm' },      // Car suspension
        2: { k: 500, kUnit: 'N/m', x: 1, xUnit: 'cm' },        // Pen spring
        3: { k: 2000, kUnit: 'N/m', x: 3, xUnit: 'cm' },       // Mattress
        4: { k: 50, kUnit: 'N/m', x: 2, xUnit: 'mm' }          // Watch spring
    };

    const ex = examples[num];
    document.getElementById('spring-constant').value = ex.k;
    document.getElementById('k-unit').value = ex.kUnit;
    document.getElementById('displacement').value = ex.x;
    document.getElementById('x-unit').value = ex.xUnit;

    setSolveFor('force');
    calculate();
}

// Make oscillation functions globally accessible
window.startOscillation = startOscillation;
window.stopOscillation = stopOscillation;
