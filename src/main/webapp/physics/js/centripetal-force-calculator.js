// Centripetal Force Calculator - F = mv²/r

let solveFor = 'force';
let stepsExpanded = false;
let animationId = null;
let angle = 0;
let canvas, ctx;

const massConv = { 'kg': 1, 'g': 0.001, 'lb': 0.453592 };
const velConv = { 'm/s': 1, 'km/h': 1/3.6, 'mph': 0.44704 };
const radConv = { 'm': 1, 'km': 1000, 'ft': 0.3048 };
const forceConv = { 'N': 1, 'kN': 1000, 'lbf': 4.44822 };

document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('circle-canvas');
    ctx = canvas.getContext('2d');
    setupCanvas();
    calculate();

    document.querySelectorAll('.number-input').forEach(input => {
        input.addEventListener('input', calculate);
    });

    window.addEventListener('resize', () => { setupCanvas(); calculate(); });
});

function setupCanvas() {
    const container = document.getElementById('circle-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
}

function setSolveFor(variable) {
    solveFor = variable;
    document.querySelectorAll('.solve-btn[data-var]').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.var === variable);
    });

    document.getElementById('mass-section').style.display = variable === 'mass' ? 'none' : 'block';
    document.getElementById('velocity-section').style.display = variable === 'velocity' ? 'none' : 'block';
    document.getElementById('radius-section').style.display = variable === 'radius' ? 'none' : 'block';
    document.getElementById('force-section').style.display = variable === 'force' ? 'none' : 'block';

    calculate();
}

function calculate() {
    let m = parseFloat(document.getElementById('mass').value) * massConv[document.getElementById('mass-unit').value];
    let v = parseFloat(document.getElementById('velocity').value) * velConv[document.getElementById('velocity-unit').value];
    let r = parseFloat(document.getElementById('radius').value) * radConv[document.getElementById('radius-unit').value];
    let F = parseFloat(document.getElementById('force').value) * forceConv[document.getElementById('force-unit').value];

    if (solveFor === 'force') F = m * v * v / r;
    else if (solveFor === 'mass') m = F * r / (v * v);
    else if (solveFor === 'velocity') v = Math.sqrt(F * r / m);
    else if (solveFor === 'radius') r = m * v * v / F;

    const a = v * v / r;
    const omega = v / r;
    const period = 2 * Math.PI * r / v;

    document.getElementById('result-force').textContent = formatNum(F) + ' N';
    document.getElementById('result-accel').textContent = formatNum(a) + ' m/s²';
    document.getElementById('result-omega').textContent = formatNum(omega) + ' rad/s';
    document.getElementById('result-period').textContent = formatNum(period) + ' s';

    document.getElementById('info-v').textContent = 'v = ' + formatNum(v) + ' m/s';
    document.getElementById('info-r').textContent = 'r = ' + formatNum(r) + ' m';
    document.getElementById('info-f').textContent = 'F = ' + formatNum(F) + ' N';

    drawCircle(m, v, r, F, a);
    generateSteps(m, v, r, F, a, omega, period);
}

function formatNum(n) {
    if (Math.abs(n) >= 10000) return n.toExponential(2);
    if (Math.abs(n) >= 100) return n.toFixed(1);
    if (Math.abs(n) >= 1) return n.toFixed(2);
    return n.toFixed(3);
}

function drawCircle(m, v, r, F, a) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const cx = canvas.width / 2;
    const cy = canvas.height / 2 - 20;
    const visualR = Math.min(canvas.width, canvas.height) * 0.35;

    // Draw circle path
    ctx.beginPath();
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);
    ctx.arc(cx, cy, visualR, 0, Math.PI * 2);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw center
    ctx.beginPath();
    ctx.fillStyle = '#14b8a6';
    ctx.arc(cx, cy, 6, 0, Math.PI * 2);
    ctx.fill();

    // Object position
    const objX = cx + visualR * Math.cos(angle);
    const objY = cy + visualR * Math.sin(angle);

    // Draw radius line
    ctx.beginPath();
    ctx.strokeStyle = '#64748b';
    ctx.lineWidth = 1;
    ctx.moveTo(cx, cy);
    ctx.lineTo(objX, objY);
    ctx.stroke();

    // Draw object
    ctx.beginPath();
    ctx.fillStyle = '#2563eb';
    ctx.arc(objX, objY, 15, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = 'white';
    ctx.font = 'bold 12px Inter';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('m', objX, objY);

    // Velocity arrow (tangent)
    const vAngle = angle + Math.PI / 2;
    const vLen = 50;
    drawArrow(objX, objY, objX + vLen * Math.cos(vAngle), objY + vLen * Math.sin(vAngle), '#059669', 'v');

    // Force arrow (toward center)
    const fAngle = angle + Math.PI;
    const fLen = 40;
    drawArrow(objX, objY, objX + fLen * Math.cos(fAngle), objY + fLen * Math.sin(fAngle), '#dc2626', 'F');

    // Labels
    ctx.fillStyle = '#64748b';
    ctx.font = '12px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('r', (cx + objX) / 2 + 10, (cy + objY) / 2);
}

function drawArrow(x1, y1, x2, y2, color, label) {
    const angle = Math.atan2(y2 - y1, x2 - x1);

    ctx.beginPath();
    ctx.strokeStyle = color;
    ctx.lineWidth = 3;
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    ctx.beginPath();
    ctx.fillStyle = color;
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2 - 10 * Math.cos(angle - 0.4), y2 - 10 * Math.sin(angle - 0.4));
    ctx.lineTo(x2 - 10 * Math.cos(angle + 0.4), y2 - 10 * Math.sin(angle + 0.4));
    ctx.closePath();
    ctx.fill();

    ctx.fillStyle = color;
    ctx.font = 'bold 12px Inter';
    ctx.textAlign = 'center';
    ctx.fillText(label, x2 + 15 * Math.cos(angle), y2 + 15 * Math.sin(angle));
}

function toggleAnimation() {
    const btn = document.getElementById('anim-btn');
    if (animationId) {
        cancelAnimationFrame(animationId);
        animationId = null;
        btn.textContent = '▶ Play';
    } else {
        btn.textContent = '⏸ Pause';
        animate();
    }
}

function animate() {
    const v = parseFloat(document.getElementById('velocity').value) * velConv[document.getElementById('velocity-unit').value];
    const r = parseFloat(document.getElementById('radius').value) * radConv[document.getElementById('radius-unit').value];
    const omega = v / r;

    angle += omega * 0.016; // ~60fps
    if (angle > Math.PI * 2) angle -= Math.PI * 2;

    calculate();
    animationId = requestAnimationFrame(animate);
}

function toggleSteps() {
    stepsExpanded = !stepsExpanded;
    document.getElementById('steps-body').classList.toggle('collapsed', !stepsExpanded);
    document.getElementById('steps-toggle').textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
}

function generateSteps(m, v, r, F, a, omega, period) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Mass: <span class="highlight">m = ${formatNum(m)} kg</span><br>
                Velocity: <span class="highlight">v = ${formatNum(v)} m/s</span><br>
                Radius: <span class="highlight">r = ${formatNum(r)} m</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Calculate Centripetal Force</div>
            <div class="step-formula">F = mv²/r</div>
            <div class="step-calc">
                F = ${formatNum(m)} × (${formatNum(v)})² / ${formatNum(r)}<br>
                F = ${formatNum(m)} × ${formatNum(v*v)} / ${formatNum(r)}<br>
                F = <span class="highlight">${formatNum(F)} N</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Centripetal Force</div>
                <div class="step-result-value">${formatNum(F)} N</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Centripetal Acceleration</div>
            <div class="step-formula">a = v²/r</div>
            <div class="step-calc">
                a = (${formatNum(v)})² / ${formatNum(r)} = <span class="highlight">${formatNum(a)} m/s²</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Calculate Angular Velocity & Period</div>
            <div class="step-formula">ω = v/r  |  T = 2πr/v</div>
            <div class="step-calc">
                ω = ${formatNum(v)} / ${formatNum(r)} = <span class="highlight">${formatNum(omega)} rad/s</span><br>
                T = 2π × ${formatNum(r)} / ${formatNum(v)} = <span class="highlight">${formatNum(period)} s</span>
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function loadExample(num) {
    const examples = {
        1: { m: 1500, mU: 'kg', v: 60, vU: 'km/h', r: 30, rU: 'm' },
        2: { m: 500, mU: 'kg', v: 25, vU: 'm/s', r: 15, rU: 'm' },
        3: { m: 1000, mU: 'kg', v: 7.8, vU: 'km/h', r: 6371, rU: 'km' },
        4: { m: 0.5, mU: 'kg', v: 5, vU: 'm/s', r: 1, rU: 'm' }
    };
    const ex = examples[num];
    document.getElementById('mass').value = ex.m;
    document.getElementById('mass-unit').value = ex.mU;
    document.getElementById('velocity').value = ex.v;
    document.getElementById('velocity-unit').value = ex.vU;
    document.getElementById('radius').value = ex.r;
    document.getElementById('radius-unit').value = ex.rU;
    setSolveFor('force');
}
