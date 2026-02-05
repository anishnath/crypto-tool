// Torque Calculator - τ = rF sin θ

let solveFor = 'torque';
let stepsExpanded = false;
let canvas, ctx;

const rConv = { 'm': 1, 'cm': 0.01, 'in': 0.0254, 'ft': 0.3048 };
const fConv = { 'N': 1, 'kN': 1000, 'lbf': 4.44822 };
const tConv = { 'N·m': 1, 'lb·ft': 1.35582, 'lb·in': 0.112985 };

document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('torque-canvas');
    ctx = canvas.getContext('2d');
    setupCanvas();
    calculate();

    document.querySelectorAll('.number-input').forEach(input => {
        input.addEventListener('input', calculate);
    });

    window.addEventListener('resize', () => { setupCanvas(); calculate(); });
});

function setupCanvas() {
    const container = document.getElementById('torque-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
}

function setSolveFor(variable) {
    solveFor = variable;
    document.querySelectorAll('.solve-btn[data-var]').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.var === variable);
    });

    document.getElementById('radius-section').style.display = variable === 'radius' ? 'none' : 'block';
    document.getElementById('force-section').style.display = variable === 'force' ? 'none' : 'block';
    document.getElementById('torque-section').style.display = variable === 'torque' ? 'none' : 'block';

    calculate();
}

function setAngle(angle) {
    document.getElementById('angle').value = angle;
    updateAngle();
}

function updateAngle() {
    const angle = document.getElementById('angle').value;
    document.getElementById('angle-display').textContent = angle + '°';
    calculate();
}

function calculate() {
    let r = parseFloat(document.getElementById('radius').value) * rConv[document.getElementById('radius-unit').value];
    let F = parseFloat(document.getElementById('force').value) * fConv[document.getElementById('force-unit').value];
    let tau = parseFloat(document.getElementById('torque').value) * tConv[document.getElementById('torque-unit').value];
    const angleDeg = parseFloat(document.getElementById('angle').value);
    const angleRad = angleDeg * Math.PI / 180;
    const sinTheta = Math.sin(angleRad);

    if (solveFor === 'torque') {
        tau = r * F * sinTheta;
    } else if (solveFor === 'force') {
        F = tau / (r * sinTheta);
    } else if (solveFor === 'radius') {
        r = tau / (F * sinTheta);
    }

    const effectiveForce = F * sinTheta;

    document.getElementById('result-torque').textContent = formatNum(tau) + ' N·m';
    document.getElementById('result-lever').textContent = formatNum(r) + ' m';
    document.getElementById('result-eff-force').textContent = formatNum(effectiveForce) + ' N';
    document.getElementById('result-sin').textContent = sinTheta.toFixed(3);

    document.getElementById('info-r').textContent = 'r = ' + formatNum(r) + ' m';
    document.getElementById('info-f').textContent = 'F = ' + formatNum(F) + ' N';
    document.getElementById('info-tau').textContent = 'τ = ' + formatNum(tau) + ' N·m';

    drawVisualization(r, F, angleDeg, tau);
    generateSteps(r, F, angleDeg, sinTheta, tau, effectiveForce);
}

function formatNum(n) {
    if (Math.abs(n) >= 10000) return n.toExponential(2);
    if (Math.abs(n) >= 100) return n.toFixed(1);
    if (Math.abs(n) >= 1) return n.toFixed(2);
    return n.toFixed(3);
}

function drawVisualization(r, F, angleDeg, tau) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const cx = canvas.width / 2;
    const cy = canvas.height / 2 + 20;
    const leverLen = Math.min(canvas.width * 0.35, 150);

    // Draw pivot point
    ctx.beginPath();
    ctx.fillStyle = '#64748b';
    ctx.arc(cx, cy, 12, 0, Math.PI * 2);
    ctx.fill();

    ctx.beginPath();
    ctx.fillStyle = '#d97706';
    ctx.arc(cx, cy, 6, 0, Math.PI * 2);
    ctx.fill();

    // Draw lever arm (horizontal)
    ctx.strokeStyle = '#374151';
    ctx.lineWidth = 8;
    ctx.lineCap = 'round';
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(cx + leverLen, cy);
    ctx.stroke();

    // End of lever
    const endX = cx + leverLen;
    const endY = cy;

    // Draw force vector at angle
    const forceLen = 60;
    const forceAngle = -angleDeg * Math.PI / 180; // Negative for visual (up is negative y)
    const forceEndX = endX + forceLen * Math.cos(forceAngle);
    const forceEndY = endY + forceLen * Math.sin(forceAngle);

    // Force arrow
    drawArrow(endX, endY, forceEndX, forceEndY, '#dc2626', 3);

    // Label force
    ctx.fillStyle = '#dc2626';
    ctx.font = 'bold 14px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('F', forceEndX + 15 * Math.cos(forceAngle), forceEndY + 15 * Math.sin(forceAngle));

    // Draw angle arc
    if (angleDeg !== 90 && angleDeg !== 0) {
        ctx.beginPath();
        ctx.strokeStyle = '#d97706';
        ctx.lineWidth = 2;
        const arcRadius = 30;
        const startAngle = 0;
        const endAngle = -angleDeg * Math.PI / 180;
        ctx.arc(endX, endY, arcRadius, Math.min(startAngle, endAngle), Math.max(startAngle, endAngle));
        ctx.stroke();

        // Angle label
        const labelAngle = -angleDeg * Math.PI / 360;
        ctx.fillStyle = '#d97706';
        ctx.font = 'bold 12px Inter';
        ctx.fillText('θ=' + angleDeg + '°', endX + 45 * Math.cos(labelAngle), endY + 45 * Math.sin(labelAngle));
    }

    // Draw rotation arrow (indicates torque direction)
    const rotRadius = 40;
    ctx.beginPath();
    ctx.strokeStyle = '#059669';
    ctx.lineWidth = 3;
    ctx.arc(cx, cy, rotRadius, -0.3, Math.PI + 0.3);
    ctx.stroke();

    // Rotation arrow head
    const rotArrowAngle = Math.PI + 0.3;
    ctx.beginPath();
    ctx.fillStyle = '#059669';
    ctx.moveTo(cx + rotRadius * Math.cos(rotArrowAngle), cy + rotRadius * Math.sin(rotArrowAngle));
    ctx.lineTo(cx + (rotRadius - 8) * Math.cos(rotArrowAngle + 0.3), cy + (rotRadius - 8) * Math.sin(rotArrowAngle + 0.3));
    ctx.lineTo(cx + (rotRadius + 8) * Math.cos(rotArrowAngle + 0.3), cy + (rotRadius + 8) * Math.sin(rotArrowAngle + 0.3));
    ctx.closePath();
    ctx.fill();

    // Labels
    ctx.fillStyle = '#374151';
    ctx.font = 'bold 12px Inter';
    ctx.textAlign = 'center';
    ctx.fillText('Pivot', cx, cy + 30);

    // r label
    ctx.fillStyle = '#2563eb';
    ctx.fillText('r', cx + leverLen / 2, cy - 15);

    // Draw lever arm bracket
    ctx.strokeStyle = '#2563eb';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(cx, cy - 8);
    ctx.lineTo(cx, cy - 12);
    ctx.lineTo(cx + leverLen, cy - 12);
    ctx.lineTo(cx + leverLen, cy - 8);
    ctx.stroke();

    // Torque direction label
    ctx.fillStyle = '#059669';
    ctx.font = 'bold 14px Inter';
    ctx.fillText('τ (CCW)', cx, cy - 55);
}

function drawArrow(x1, y1, x2, y2, color, width) {
    const angle = Math.atan2(y2 - y1, x2 - x1);
    ctx.strokeStyle = color;
    ctx.lineWidth = width;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2 - 12 * Math.cos(angle - 0.4), y2 - 12 * Math.sin(angle - 0.4));
    ctx.lineTo(x2 - 12 * Math.cos(angle + 0.4), y2 - 12 * Math.sin(angle + 0.4));
    ctx.closePath();
    ctx.fill();
}

function toggleSteps() {
    stepsExpanded = !stepsExpanded;
    document.getElementById('steps-body').classList.toggle('collapsed', !stepsExpanded);
    document.getElementById('steps-toggle').textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
}

function generateSteps(r, F, angleDeg, sinTheta, tau, effectiveForce) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Lever arm distance: <span class="highlight">r = ${formatNum(r)} m</span><br>
                Applied force: <span class="highlight">F = ${formatNum(F)} N</span><br>
                Angle: <span class="highlight">θ = ${angleDeg}°</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Calculate sin(θ)</div>
            <div class="step-calc">
                sin(${angleDeg}°) = <span class="highlight">${sinTheta.toFixed(4)}</span>
                ${angleDeg === 90 ? '<br><em>(Maximum torque at 90°)</em>' : ''}
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Apply Torque Formula</div>
            <div class="step-formula">τ = r × F × sin(θ)</div>
            <div class="step-calc">
                τ = ${formatNum(r)} × ${formatNum(F)} × ${sinTheta.toFixed(4)}<br>
                τ = ${formatNum(r * F)} × ${sinTheta.toFixed(4)}<br>
                τ = <span class="highlight">${formatNum(tau)} N·m</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Torque</div>
                <div class="step-result-value">${formatNum(tau)} N·m</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Effective Force Component</div>
            <div class="step-calc">
                The effective perpendicular force component:<br>
                F_⊥ = F × sin(θ) = ${formatNum(F)} × ${sinTheta.toFixed(4)} = <span class="highlight">${formatNum(effectiveForce)} N</span><br>
                <em>This is the portion of force that creates rotation.</em>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">5</span>Unit Conversions</div>
            <div class="step-calc">
                • ${formatNum(tau)} N·m = <span class="highlight">${formatNum(tau / 1.35582)} lb·ft</span><br>
                • ${formatNum(tau)} N·m = <span class="highlight">${formatNum(tau / 0.112985)} lb·in</span>
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function loadExample(num) {
    const examples = {
        1: { r: 25, rU: 'cm', F: 150, fU: 'N', angle: 90 },    // Wrench
        2: { r: 80, rU: 'cm', F: 20, fU: 'N', angle: 90 },     // Door
        3: { r: 45, rU: 'cm', F: 220, fU: 'N', angle: 90 },    // Lug nut
        4: { r: 30, rU: 'cm', F: 50, fU: 'N', angle: 60 }      // Hammer
    };
    const ex = examples[num];
    document.getElementById('radius').value = ex.r;
    document.getElementById('radius-unit').value = ex.rU;
    document.getElementById('force').value = ex.F;
    document.getElementById('force-unit').value = ex.fU;
    document.getElementById('angle').value = ex.angle;
    updateAngle();
    setSolveFor('torque');
}
