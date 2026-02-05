// Gravitational Force Calculator - F = Gm₁m₂/r²

const G = 6.674e-11; // Gravitational constant
let stepsExpanded = false;
let canvas, ctx;

const massConv = { 'kg': 1, 'earth': 5.972e24, 'sun': 1.989e30 };
const distConv = { 'm': 1, 'km': 1000, 'earth-r': 6.371e6 };

document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('gravity-canvas');
    ctx = canvas.getContext('2d');
    setupCanvas();
    calculate();

    document.querySelectorAll('.number-input').forEach(input => {
        input.addEventListener('input', calculate);
    });

    window.addEventListener('resize', () => { setupCanvas(); calculate(); });
});

function setupCanvas() {
    const container = document.getElementById('gravity-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
}

function setMass1(value, unit) {
    document.getElementById('mass1').value = value;
    document.getElementById('mass1-unit').value = unit;
    calculate();
}

function setMass2(value) {
    document.getElementById('mass2').value = value;
    calculate();
}

function setDistance(value) {
    document.getElementById('distance').value = value;
    document.getElementById('distance-unit').value = 'm';
    calculate();
}

function calculate() {
    const m1Input = parseFloat(document.getElementById('mass1').value) || 5.972e24;
    const m1Unit = document.getElementById('mass1-unit').value;
    const m2Input = parseFloat(document.getElementById('mass2').value) || 1000;
    const rInput = parseFloat(document.getElementById('distance').value) || 6.371e6;
    const rUnit = document.getElementById('distance-unit').value;

    const m1 = m1Input * massConv[m1Unit];
    const m2 = m2Input;
    const r = rInput * distConv[rUnit];

    // F = Gm₁m₂/r²
    const force = G * m1 * m2 / (r * r);

    // Surface gravity g = GM/r²
    const gravity = G * m1 / (r * r);

    // Orbital velocity v = √(GM/r)
    const orbitalV = Math.sqrt(G * m1 / r);

    // Escape velocity vₑ = √(2GM/r)
    const escapeV = Math.sqrt(2 * G * m1 / r);

    // Display results
    document.getElementById('result-force').textContent = formatForce(force);
    document.getElementById('result-gravity').textContent = formatNum(gravity) + ' m/s²';
    document.getElementById('result-orbital').textContent = formatVel(orbitalV);
    document.getElementById('result-escape').textContent = formatVel(escapeV);

    drawVisualization(m1, m2, r, force);
    generateSteps(m1, m2, r, force, gravity, orbitalV, escapeV);
}

function formatNum(n) {
    if (Math.abs(n) >= 1e9) return n.toExponential(2);
    if (Math.abs(n) >= 1e6) return (n / 1e6).toFixed(2) + 'M';
    if (Math.abs(n) >= 1000) return (n / 1000).toFixed(2) + 'k';
    if (Math.abs(n) >= 1) return n.toFixed(2);
    return n.toExponential(2);
}

function formatForce(f) {
    if (f >= 1e9) return (f / 1e9).toFixed(2) + ' GN';
    if (f >= 1e6) return (f / 1e6).toFixed(2) + ' MN';
    if (f >= 1e3) return (f / 1e3).toFixed(2) + ' kN';
    if (f >= 0.01) return f.toFixed(2) + ' N';
    if (f >= 1e-6) return (f * 1e6).toFixed(2) + ' μN';
    if (f >= 1e-9) return (f * 1e9).toFixed(2) + ' nN';
    if (f >= 1e-12) return (f * 1e12).toFixed(2) + ' pN';
    // For extremely small forces, use scientific notation
    return f.toExponential(2) + ' N';
}

function formatVel(v) {
    if (v >= 1000) return (v / 1000).toFixed(2) + ' km/s';
    return v.toFixed(2) + ' m/s';
}

function formatSci(n) {
    return n.toExponential(3);
}

function drawVisualization(m1, m2, r, force) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Draw stars background
    for (let i = 0; i < 50; i++) {
        ctx.fillStyle = `rgba(255, 255, 255, ${Math.random() * 0.5 + 0.2})`;
        ctx.beginPath();
        ctx.arc(Math.random() * canvas.width, Math.random() * canvas.height, Math.random() * 1.5, 0, Math.PI * 2);
        ctx.fill();
    }

    const cx = canvas.width / 2;
    const cy = canvas.height / 2;

    // Scale masses for visualization
    const logM1 = Math.log10(m1);
    const r1 = Math.min(Math.max(logM1 * 3, 20), 80);
    const r2 = 15;

    const dist = 120;

    // Draw mass 1 (large body)
    const grad1 = ctx.createRadialGradient(cx - dist, cy, 0, cx - dist, cy, r1);
    grad1.addColorStop(0, '#60a5fa');
    grad1.addColorStop(1, '#1d4ed8');
    ctx.beginPath();
    ctx.fillStyle = grad1;
    ctx.arc(cx - dist, cy, r1, 0, Math.PI * 2);
    ctx.fill();

    // Draw mass 2 (small body)
    ctx.beginPath();
    ctx.fillStyle = '#f59e0b';
    ctx.arc(cx + dist, cy, r2, 0, Math.PI * 2);
    ctx.fill();

    // Draw force arrows
    const arrowLen = 50;

    // Force on m2 (toward m1)
    drawArrow(cx + dist - r2 - 10, cy, cx + dist - r2 - 10 - arrowLen, cy, '#dc2626');
    ctx.fillStyle = '#dc2626';
    ctx.font = 'bold 11px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('F', cx + dist - r2 - 10 - arrowLen/2, cy - 15);

    // Force on m1 (toward m2) - equal and opposite
    drawArrow(cx - dist + r1 + 10, cy, cx - dist + r1 + 10 + arrowLen, cy, '#dc2626');
    ctx.fillText('F', cx - dist + r1 + 10 + arrowLen/2, cy - 15);

    // Labels
    ctx.fillStyle = 'white';
    ctx.font = 'bold 14px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('m₁', cx - dist, cy + r1 + 25);
    ctx.fillText('m₂', cx + dist, cy + r2 + 25);

    // Distance line
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.5)';
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(cx - dist, cy + r1 + 40);
    ctx.lineTo(cx + dist, cy + r1 + 40);
    ctx.stroke();
    ctx.setLineDash([]);

    ctx.fillStyle = 'rgba(255, 255, 255, 0.7)';
    ctx.font = '12px Inter';
    ctx.fillText('r = ' + formatNum(r) + ' m', cx, cy + r1 + 55);
}

function drawArrow(x1, y1, x2, y2, color) {
    const angle = Math.atan2(y2 - y1, x2 - x1);
    ctx.strokeStyle = color;
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2 - 10 * Math.cos(angle - 0.4), y2 - 10 * Math.sin(angle - 0.4));
    ctx.lineTo(x2 - 10 * Math.cos(angle + 0.4), y2 - 10 * Math.sin(angle + 0.4));
    ctx.closePath();
    ctx.fill();
}

function toggleSteps() {
    stepsExpanded = !stepsExpanded;
    document.getElementById('steps-body').classList.toggle('collapsed', !stepsExpanded);
    document.getElementById('steps-toggle').textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
}

function generateSteps(m1, m2, r, force, gravity, orbitalV, escapeV) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Gravitational constant: <span class="highlight">G = 6.674 × 10⁻¹¹ N⋅m²/kg²</span><br>
                Mass 1: <span class="highlight">m₁ = ${formatSci(m1)} kg</span><br>
                Mass 2: <span class="highlight">m₂ = ${formatSci(m2)} kg</span><br>
                Distance: <span class="highlight">r = ${formatSci(r)} m</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Calculate Gravitational Force</div>
            <div class="step-formula">F = Gm₁m₂/r²</div>
            <div class="step-calc">
                F = (6.674×10⁻¹¹) × (${formatSci(m1)}) × (${formatSci(m2)}) / (${formatSci(r)})²<br>
                F = <span class="highlight">${formatForce(force)}</span>
                ${force < 0.01 && force > 0 ? `<br><em style="font-size: 0.8em; color: var(--text-secondary);">(Scientific: ${force.toExponential(3)} N)</em>` : ''}
            </div>
            <div class="step-result">
                <div class="step-result-label">Gravitational Force</div>
                <div class="step-result-value">${formatForce(force)}</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Surface Gravity</div>
            <div class="step-formula">g = GM/r²</div>
            <div class="step-calc">
                g = (6.674×10⁻¹¹) × (${formatSci(m1)}) / (${formatSci(r)})²<br>
                g = <span class="highlight">${formatNum(gravity)} m/s²</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Calculate Orbital & Escape Velocity</div>
            <div class="step-formula">v_orbital = √(GM/r)  |  v_escape = √(2GM/r)</div>
            <div class="step-calc">
                Orbital velocity: v = √(G × ${formatSci(m1)} / ${formatSci(r)}) = <span class="highlight">${formatVel(orbitalV)}</span><br>
                Escape velocity: vₑ = √(2 × G × ${formatSci(m1)} / ${formatSci(r)}) = <span class="highlight">${formatVel(escapeV)}</span>
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}
