// Lens Calculator - Thin Lens, Lens Maker, Combined Lenses
// 1/f = 1/v - 1/u, m = v/u, P = 1/f

let currentMode = 'thinlens';
let lensType = 'converging';
let solveFor = 'v';
let stepsExpanded = false;
let canvas, ctx;

// Unit conversions to cm
const lengthConv = { 'cm': 1, 'm': 100, 'mm': 0.1 };

document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('ray-canvas');
    ctx = canvas.getContext('2d');
    setupCanvas();
    calculate();

    document.querySelectorAll('.number-input').forEach(input => {
        input.addEventListener('input', calculate);
    });

    window.addEventListener('resize', () => { setupCanvas(); calculate(); });
});

function setupCanvas() {
    const container = document.getElementById('ray-container');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
}

function setMode(mode) {
    currentMode = mode;

    document.querySelectorAll('.mode-tab').forEach(tab => {
        tab.classList.toggle('active', tab.dataset.mode === mode);
    });

    document.getElementById('thinlens-inputs').style.display = mode === 'thinlens' ? 'block' : 'none';
    document.getElementById('lensmaker-inputs').style.display = mode === 'lensmaker' ? 'block' : 'none';
    document.getElementById('combined-inputs').style.display = mode === 'combined' ? 'block' : 'none';

    calculate();
}

function setLensType(type) {
    lensType = type;

    document.querySelectorAll('.lens-type-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.type === type);
    });

    // Update focal length sign for diverging lens
    if (currentMode === 'thinlens') {
        const focalInput = document.getElementById('focal-length');
        const currentValue = Math.abs(parseFloat(focalInput.value) || 10);
        focalInput.value = type === 'diverging' ? -currentValue : currentValue;
    }

    calculate();
}

function setSolveFor(variable) {
    solveFor = variable;

    document.querySelectorAll('.solve-btn[data-var]').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.var === variable);
    });

    // Show/hide appropriate input sections
    document.getElementById('focal-section').style.display = variable === 'f' ? 'none' : 'block';
    document.getElementById('object-section').style.display = variable === 'u' ? 'none' : 'block';
    document.getElementById('image-section').style.display = variable === 'v' ? 'none' : 'block';

    calculate();
}

function setRefractiveIndex(n) {
    document.getElementById('refractive-index').value = n;
    calculate();
}

function calculate() {
    if (currentMode === 'thinlens') {
        calculateThinLens();
    } else if (currentMode === 'lensmaker') {
        calculateLensMaker();
    } else {
        calculateCombined();
    }
}

function calculateThinLens() {
    let f = parseFloat(document.getElementById('focal-length').value) * lengthConv[document.getElementById('focal-unit').value];
    let u = parseFloat(document.getElementById('object-dist').value) * lengthConv[document.getElementById('object-unit').value];
    let v = parseFloat(document.getElementById('image-dist').value) * lengthConv[document.getElementById('image-unit').value];
    const h_o = parseFloat(document.getElementById('object-height').value) || 5;

    // Apply sign convention for diverging lens
    if (lensType === 'diverging' && f > 0) {
        f = -Math.abs(f);
    } else if (lensType === 'converging' && f < 0) {
        f = Math.abs(f);
    }

    // Solve for the unknown variable using 1/f = 1/v - 1/u (or 1/v = 1/f + 1/u)
    if (solveFor === 'v') {
        // 1/v = 1/f + 1/u
        if (f !== 0 && u !== 0) {
            v = 1 / (1/f + 1/u);
        }
    } else if (solveFor === 'u') {
        // 1/u = 1/v - 1/f
        if (f !== 0 && v !== 0) {
            u = 1 / (1/v - 1/f);
        }
    } else if (solveFor === 'f') {
        // 1/f = 1/v - 1/u
        if (u !== 0 && v !== 0) {
            f = 1 / (1/v - 1/u);
        }
    }

    // Calculate magnification and image height
    const m = -v / u;  // Lateral magnification (negative sign for real image inversion)
    const h_i = m * h_o;
    const power = 100 / f; // Power in diopters (f in cm, so 100/f = 1/(f/100) = 1/f_meters)

    // Determine image characteristics
    const isReal = v > 0;
    const isInverted = m < 0;
    const isMagnified = Math.abs(m) > 1;

    // Update results
    document.getElementById('result-image').textContent = formatLength(v);
    document.getElementById('result-image-note').textContent = isReal ? 'Real image' : 'Virtual image';
    document.getElementById('result-mag').textContent = formatMag(m);
    document.getElementById('result-height').textContent = formatLength(h_i);
    document.getElementById('result-power').textContent = (power >= 0 ? '+' : '') + power.toFixed(1) + ' D';

    // Update info pills
    document.getElementById('info-u').textContent = 'u = ' + formatLength(u);
    document.getElementById('info-v').textContent = 'v = ' + formatLength(v);
    document.getElementById('info-f').textContent = 'f = ' + formatLength(f);

    // Update image property badges
    updatePropertyBadges(isReal, isInverted, isMagnified, Math.abs(m));

    // Draw ray diagram
    drawRayDiagram(f, u, v, h_o, h_i, m);

    // Generate steps
    generateThinLensSteps(f, u, v, m, h_o, h_i, power, isReal, isInverted, isMagnified);
}

function calculateLensMaker() {
    const mu = parseFloat(document.getElementById('refractive-index').value) || 1.5;
    const R1 = parseFloat(document.getElementById('radius1').value) || 20;
    const R2 = parseFloat(document.getElementById('radius2').value) || -20;

    // Lens maker formula: 1/f = (μ - 1)(1/R₁ - 1/R₂)
    const oneOverF = (mu - 1) * (1/R1 - 1/R2);
    const f = 1 / oneOverF;
    const power = 100 / f;

    // Update focal length input for thin lens calculations
    document.getElementById('focal-length').value = f.toFixed(2);

    // Update results
    document.getElementById('result-image').textContent = formatLength(f);
    document.getElementById('result-image-note').textContent = f > 0 ? 'Converging lens' : 'Diverging lens';

    document.querySelector('#results-grid .result-card.highlight .result-label').textContent = 'Focal Length';

    document.getElementById('result-mag').textContent = 'μ = ' + mu.toFixed(2);
    document.getElementById('result-height').textContent = 'R₁ = ' + R1 + ' cm';
    document.getElementById('result-power').textContent = (power >= 0 ? '+' : '') + power.toFixed(2) + ' D';

    // Update labels
    document.querySelector('#results-grid .result-card:nth-child(2) .result-label').textContent = 'Refractive Index';
    document.querySelector('#results-grid .result-card:nth-child(3) .result-label').textContent = 'Radius R₁';

    document.getElementById('info-u').textContent = 'μ = ' + mu.toFixed(2);
    document.getElementById('info-v').textContent = 'R₁ = ' + R1 + ' cm';
    document.getElementById('info-f').textContent = 'f = ' + formatLength(f);

    // Update property badges for lens type
    const propReal = document.getElementById('prop-real');
    const propOrientation = document.getElementById('prop-orientation');
    const propSize = document.getElementById('prop-size');

    propReal.textContent = f > 0 ? 'Converging' : 'Diverging';
    propReal.className = 'property-badge ' + (f > 0 ? 'real' : 'virtual');
    propOrientation.textContent = 'R₂ = ' + R2 + ' cm';
    propOrientation.className = 'property-badge erect';
    propSize.textContent = 'P = ' + power.toFixed(2) + ' D';
    propSize.className = 'property-badge magnified';

    drawLensMakerDiagram(f, R1, R2, mu);
    generateLensMakerSteps(mu, R1, R2, f, power);
}

function calculateCombined() {
    const f1 = parseFloat(document.getElementById('f1').value) || 10;
    const f2 = parseFloat(document.getElementById('f2').value) || 15;
    const d = parseFloat(document.getElementById('separation').value) || 0;

    let F, formula;

    if (d === 0) {
        // Lenses in contact: 1/F = 1/f₁ + 1/f₂
        F = 1 / (1/f1 + 1/f2);
        formula = 'contact';
    } else {
        // Separated lenses: 1/F = 1/f₁ + 1/f₂ - d/(f₁f₂)
        F = 1 / (1/f1 + 1/f2 - d/(f1*f2));
        formula = 'separated';
    }

    const P = 100 / F;
    const P1 = 100 / f1;
    const P2 = 100 / f2;

    // Update results
    document.getElementById('result-image').textContent = formatLength(F);
    document.getElementById('result-image-note').textContent = F > 0 ? 'Equivalent converging' : 'Equivalent diverging';

    document.querySelector('#results-grid .result-card.highlight .result-label').textContent = 'Equivalent Focal Length';

    document.getElementById('result-mag').textContent = 'P₁ = ' + P1.toFixed(1) + ' D';
    document.getElementById('result-height').textContent = 'P₂ = ' + P2.toFixed(1) + ' D';
    document.getElementById('result-power').textContent = (P >= 0 ? '+' : '') + P.toFixed(2) + ' D';

    document.querySelector('#results-grid .result-card:nth-child(2) .result-label').textContent = 'Power of Lens 1';
    document.querySelector('#results-grid .result-card:nth-child(3) .result-label').textContent = 'Power of Lens 2';

    document.getElementById('info-u').textContent = 'f₁ = ' + f1 + ' cm';
    document.getElementById('info-v').textContent = 'f₂ = ' + f2 + ' cm';
    document.getElementById('info-f').textContent = 'F = ' + formatLength(F);

    // Update badges
    const propReal = document.getElementById('prop-real');
    const propOrientation = document.getElementById('prop-orientation');
    const propSize = document.getElementById('prop-size');

    propReal.textContent = d === 0 ? 'In Contact' : 'd = ' + d + ' cm';
    propReal.className = 'property-badge erect';
    propOrientation.textContent = 'P_total = ' + P.toFixed(2) + ' D';
    propOrientation.className = 'property-badge magnified';
    propSize.textContent = F > 0 ? 'Converging' : 'Diverging';
    propSize.className = 'property-badge ' + (F > 0 ? 'real' : 'virtual');

    drawCombinedDiagram(f1, f2, d, F);
    generateCombinedSteps(f1, f2, d, F, P, P1, P2, formula);
}

function updatePropertyBadges(isReal, isInverted, isMagnified, absMag) {
    const propReal = document.getElementById('prop-real');
    const propOrientation = document.getElementById('prop-orientation');
    const propSize = document.getElementById('prop-size');

    propReal.textContent = isReal ? 'Real Image' : 'Virtual Image';
    propReal.className = 'property-badge ' + (isReal ? 'real' : 'virtual');

    propOrientation.textContent = isInverted ? 'Inverted' : 'Erect';
    propOrientation.className = 'property-badge ' + (isInverted ? 'inverted' : 'erect');

    if (Math.abs(absMag - 1) < 0.01) {
        propSize.textContent = 'Same Size';
        propSize.className = 'property-badge erect';
    } else {
        propSize.textContent = isMagnified ? 'Magnified' : 'Diminished';
        propSize.className = 'property-badge ' + (isMagnified ? 'magnified' : 'diminished');
    }
}

function drawRayDiagram(f, u, v, h_o, h_i, m) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const width = canvas.width;
    const height = canvas.height;
    const padding = 50; // Padding from edges
    const cy = height / 2; // Optical axis

    // Calculate the extents we need to show
    const leftExtent = Math.abs(u); // Object is to the left
    const rightExtent = Math.max(Math.abs(v), Math.abs(f) * 1.5); // Image or focal point
    const totalExtent = leftExtent + rightExtent;

    // Calculate scale to fit everything within the canvas
    const availableWidth = width - padding * 2;
    const scale = Math.min(availableWidth / totalExtent, 4); // Cap scale at 4 for very small values

    // Position lens so everything fits
    // Lens X position based on proportional space for object and image
    const lensX = padding + (leftExtent / totalExtent) * availableWidth;

    // Ensure lens is roughly centered if scale allows
    const cx = Math.max(padding + 60, Math.min(width - padding - 60, lensX));

    // Draw optical axis
    ctx.strokeStyle = 'rgba(0,0,0,0.2)';
    ctx.lineWidth = 1;
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(10, cy);
    ctx.lineTo(width - 10, cy);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw lens (scale height based on canvas)
    const lensHeight = Math.min(height - 60, 120);
    ctx.strokeStyle = '#4f46e5';
    ctx.lineWidth = 3;
    ctx.beginPath();

    if (lensType === 'converging' || f > 0) {
        // Converging lens (convex)
        ctx.moveTo(cx - 5, cy - lensHeight/2);
        ctx.quadraticCurveTo(cx + 15, cy, cx - 5, cy + lensHeight/2);
        ctx.moveTo(cx + 5, cy - lensHeight/2);
        ctx.quadraticCurveTo(cx - 15, cy, cx + 5, cy + lensHeight/2);
    } else {
        // Diverging lens (concave)
        ctx.moveTo(cx - 5, cy - lensHeight/2);
        ctx.quadraticCurveTo(cx - 20, cy, cx - 5, cy + lensHeight/2);
        ctx.moveTo(cx + 5, cy - lensHeight/2);
        ctx.quadraticCurveTo(cx + 20, cy, cx + 5, cy + lensHeight/2);
    }
    ctx.stroke();

    // Draw arrows at lens tips
    ctx.beginPath();
    ctx.moveTo(cx, cy - lensHeight/2 - 8);
    ctx.lineTo(cx - 5, cy - lensHeight/2);
    ctx.lineTo(cx + 5, cy - lensHeight/2);
    ctx.closePath();
    ctx.fillStyle = '#4f46e5';
    ctx.fill();

    ctx.beginPath();
    ctx.moveTo(cx, cy + lensHeight/2 + 8);
    ctx.lineTo(cx - 5, cy + lensHeight/2);
    ctx.lineTo(cx + 5, cy + lensHeight/2);
    ctx.closePath();
    ctx.fill();

    // Draw focal points (constrained to visible area)
    const focalDist = Math.abs(f) * scale;
    const focalX1 = Math.max(padding - 20, cx - focalDist);
    const focalX2 = Math.min(width - padding + 20, cx + focalDist);

    ctx.fillStyle = '#dc2626';
    ctx.beginPath();
    ctx.arc(focalX1, cy, 4, 0, Math.PI * 2);
    ctx.fill();
    ctx.beginPath();
    ctx.arc(focalX2, cy, 4, 0, Math.PI * 2);
    ctx.fill();

    ctx.font = 'bold 10px Inter';
    ctx.fillStyle = '#dc2626';
    ctx.textAlign = 'center';
    ctx.fillText('F', focalX1, cy + 15);
    ctx.fillText("F'", focalX2, cy + 15);

    // Draw object (constrained to visible area)
    const objXRaw = cx - u * scale;
    const objX = Math.max(padding - 10, Math.min(width - padding + 10, objXRaw));
    const maxObjHeight = (height / 2) - 40; // Leave room for labels
    const objHeight = Math.min(h_o * scale * 2, maxObjHeight, 50);

    ctx.strokeStyle = '#2563eb';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(objX, cy);
    ctx.lineTo(objX, cy - objHeight);
    ctx.stroke();

    // Object arrow
    ctx.beginPath();
    ctx.moveTo(objX, cy - objHeight - 6);
    ctx.lineTo(objX - 4, cy - objHeight);
    ctx.lineTo(objX + 4, cy - objHeight);
    ctx.closePath();
    ctx.fillStyle = '#2563eb';
    ctx.fill();

    ctx.font = '10px Inter';
    ctx.fillText('Object', objX, cy + 20);

    // Draw image (if valid)
    if (isFinite(v) && Math.abs(v) < 10000) {
        const imgXRaw = cx + v * scale;
        const imgX = Math.max(padding - 10, Math.min(width - padding + 10, imgXRaw));

        // Scale image height proportionally but cap it
        const imgHeightRaw = Math.abs(m) * objHeight;
        const imgHeight = Math.min(imgHeightRaw, maxObjHeight, 60);
        const imgDirection = m < 0 ? 1 : -1;  // Inverted if m < 0

        // Use dashed line for virtual image
        if (v < 0) {
            ctx.setLineDash([4, 3]);
        }

        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(imgX, cy);
        ctx.lineTo(imgX, cy - imgHeight * imgDirection);
        ctx.stroke();
        ctx.setLineDash([]);

        // Image arrow
        ctx.beginPath();
        const arrowY = cy - imgHeight * imgDirection;
        ctx.moveTo(imgX, arrowY + (imgDirection > 0 ? -6 : 6));
        ctx.lineTo(imgX - 4, arrowY);
        ctx.lineTo(imgX + 4, arrowY);
        ctx.closePath();
        ctx.fillStyle = '#059669';
        ctx.fill();

        ctx.fillText(v > 0 ? 'Image' : 'Virtual', imgX, cy + 20);

        // Draw rays (only if both object and image are visible)
        if (objX > padding - 20 && imgX < width - padding + 20) {
            drawRays(cx, cy, objX, cy - objHeight, imgX, cy - imgHeight * imgDirection, focalX1, focalX2, v < 0, width);
        }
    }

    // Draw scale indicator
    drawScaleIndicator(scale, width, height);
}

function drawScaleIndicator(scale, width, height) {
    const indicatorY = height - 15;

    ctx.font = '9px Inter';
    ctx.fillStyle = '#94a3b8';
    ctx.textAlign = 'right';

    // Show scale info
    const cmPerPixel = 1 / scale;
    if (cmPerPixel >= 10) {
        ctx.fillText(`Scale: 1px = ${cmPerPixel.toFixed(0)}cm`, width - 10, indicatorY);
    } else if (cmPerPixel >= 1) {
        ctx.fillText(`Scale: 1px = ${cmPerPixel.toFixed(1)}cm`, width - 10, indicatorY);
    } else {
        ctx.fillText(`Scale: ${scale.toFixed(1)}px = 1cm`, width - 10, indicatorY);
    }
}

function drawRays(lensX, axisY, objX, objTopY, imgX, imgTopY, f1X, f2X, isVirtual, canvasWidth) {
    ctx.lineWidth = 1.5;
    const rayExtend = Math.min(80, canvasWidth - lensX - 20); // Don't extend beyond canvas

    // Ray 1: Parallel to axis, then through focus
    ctx.strokeStyle = 'rgba(220, 38, 38, 0.7)';
    ctx.beginPath();
    ctx.moveTo(objX, objTopY);
    ctx.lineTo(lensX, objTopY);
    if (isVirtual) {
        ctx.setLineDash([4, 3]);
        ctx.lineTo(imgX, imgTopY);
        ctx.stroke();
        ctx.setLineDash([]);
        ctx.beginPath();
        ctx.moveTo(lensX, objTopY);
        const slope = (axisY - objTopY) / (f2X - lensX);
        ctx.lineTo(lensX + rayExtend, objTopY + slope * rayExtend);
    } else {
        ctx.lineTo(imgX, imgTopY);
    }
    ctx.stroke();

    // Ray 2: Through optical center (undeviated)
    ctx.strokeStyle = 'rgba(5, 150, 105, 0.7)';
    ctx.beginPath();
    ctx.moveTo(objX, objTopY);
    if (isVirtual) {
        ctx.setLineDash([4, 3]);
        ctx.lineTo(imgX, imgTopY);
        ctx.stroke();
        ctx.setLineDash([]);
        ctx.beginPath();
        ctx.moveTo(objX, objTopY);
        const slope = (objTopY - axisY) / (lensX - objX);
        ctx.lineTo(lensX + rayExtend, axisY + slope * (lensX + rayExtend - objX));
    } else {
        ctx.lineTo(imgX, imgTopY);
    }
    ctx.stroke();

    // Ray 3: Through focus, then parallel (only if f1X is valid)
    if (Math.abs(objX - f1X) > 5) { // Avoid division by zero
        ctx.strokeStyle = 'rgba(124, 58, 237, 0.7)';
        const ray3LensY = axisY + (objTopY - axisY) * (lensX - f1X) / (objX - f1X);

        // Only draw if ray3LensY is within reasonable bounds
        if (Math.abs(ray3LensY - axisY) < canvas.height / 2) {
            ctx.beginPath();
            ctx.moveTo(objX, objTopY);
            ctx.lineTo(lensX, ray3LensY);
            if (isVirtual) {
                ctx.setLineDash([4, 3]);
                ctx.lineTo(imgX, imgTopY);
                ctx.stroke();
                ctx.setLineDash([]);
                ctx.beginPath();
                ctx.moveTo(lensX, ray3LensY);
                ctx.lineTo(lensX + rayExtend, ray3LensY);
            } else {
                ctx.lineTo(imgX, imgTopY);
            }
            ctx.stroke();
        }
    }
}

function drawLensMakerDiagram(f, R1, R2, mu) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const width = canvas.width;
    const height = canvas.height;
    const cx = width / 2;
    const cy = height / 2;

    // Scale lens height to fit container
    const lensH = Math.min(height - 80, 120);
    const lensW = Math.min(width / 6, 25);

    // Draw lens shape based on radii
    ctx.fillStyle = 'rgba(79, 70, 229, 0.15)';
    ctx.strokeStyle = '#4f46e5';
    ctx.lineWidth = 3;

    ctx.beginPath();
    if (R1 > 0 && R2 < 0) {
        // Biconvex
        ctx.ellipse(cx, cy, lensW, lensH/2, 0, 0, Math.PI * 2);
    } else if (R1 < 0 && R2 > 0) {
        // Biconcave
        ctx.moveTo(cx - lensW * 0.7, cy - lensH/2);
        ctx.quadraticCurveTo(cx + lensW * 0.5, cy, cx - lensW * 0.7, cy + lensH/2);
        ctx.lineTo(cx + lensW * 0.7, cy + lensH/2);
        ctx.quadraticCurveTo(cx - lensW * 0.5, cy, cx + lensW * 0.7, cy - lensH/2);
        ctx.closePath();
    } else if (R1 > 0 && R2 > 0) {
        // Convex-concave (meniscus converging)
        ctx.moveTo(cx - lensW * 0.5, cy - lensH/2);
        ctx.quadraticCurveTo(cx + lensW, cy, cx - lensW * 0.5, cy + lensH/2);
        ctx.lineTo(cx + lensW * 0.5, cy + lensH/2);
        ctx.quadraticCurveTo(cx + lensW * 0.3, cy, cx + lensW * 0.5, cy - lensH/2);
        ctx.closePath();
    } else {
        // Other shapes - default ellipse
        ctx.ellipse(cx, cy, lensW * 0.8, lensH/2, 0, 0, Math.PI * 2);
    }
    ctx.fill();
    ctx.stroke();

    // Draw optical axis
    ctx.strokeStyle = 'rgba(0,0,0,0.15)';
    ctx.lineWidth = 1;
    ctx.setLineDash([4, 4]);
    ctx.beginPath();
    ctx.moveTo(30, cy);
    ctx.lineTo(width - 30, cy);
    ctx.stroke();
    ctx.setLineDash([]);

    // Labels - positioned relative to container size
    const labelOffset = Math.min(width / 4, 80);

    ctx.font = 'bold 13px Inter';
    ctx.fillStyle = '#4f46e5';
    ctx.textAlign = 'center';
    ctx.fillText('μ = ' + mu.toFixed(2), cx, cy + 5);

    ctx.font = '11px Inter';
    ctx.fillStyle = '#64748b';
    ctx.fillText('R₁ = ' + R1 + ' cm', cx - labelOffset, cy - lensH/3);
    ctx.fillText('R₂ = ' + R2 + ' cm', cx + labelOffset, cy + lensH/3);

    // Draw curvature indicators
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 1;

    // R1 indicator (left side)
    ctx.beginPath();
    ctx.moveTo(cx - lensW - 5, cy - lensH/4);
    ctx.lineTo(cx - labelOffset + 20, cy - lensH/3);
    ctx.stroke();

    // R2 indicator (right side)
    ctx.beginPath();
    ctx.moveTo(cx + lensW + 5, cy + lensH/4);
    ctx.lineTo(cx + labelOffset - 20, cy + lensH/3);
    ctx.stroke();

    // Focal length result
    ctx.font = 'bold 14px Inter';
    ctx.fillStyle = f > 0 ? '#059669' : '#ea580c';
    ctx.fillText('f = ' + f.toFixed(2) + ' cm', cx, height - 20);

    // Lens type indicator
    ctx.font = '11px Inter';
    ctx.fillStyle = '#64748b';
    ctx.fillText(f > 0 ? '(Converging)' : '(Diverging)', cx, height - 5);
}

function drawCombinedDiagram(f1, f2, d, F) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const width = canvas.width;
    const height = canvas.height;
    const cy = height / 2;
    const padding = 60;

    // Calculate lens positions to fit in container
    const availableWidth = width - padding * 2;
    const separation = d === 0 ? 30 : Math.min(d * 2, availableWidth * 0.4);

    const lens1X = padding + (availableWidth - separation) / 2;
    const lens2X = lens1X + separation;

    // Draw optical axis
    ctx.strokeStyle = 'rgba(0,0,0,0.15)';
    ctx.lineWidth = 1;
    ctx.setLineDash([4, 4]);
    ctx.beginPath();
    ctx.moveTo(20, cy);
    ctx.lineTo(width - 20, cy);
    ctx.stroke();
    ctx.setLineDash([]);

    // Scale lens height to container
    const lensHeight = Math.min(height - 100, 80);

    // Draw lens 1
    drawSimpleLens(lens1X, cy, f1 > 0, '#3b82f6', lensHeight);
    ctx.font = 'bold 11px Inter';
    ctx.fillStyle = '#3b82f6';
    ctx.textAlign = 'center';
    ctx.fillText('f₁ = ' + f1 + ' cm', lens1X, cy + lensHeight/2 + 20);

    // Draw lens 2
    drawSimpleLens(lens2X, cy, f2 > 0, '#f59e0b', lensHeight);
    ctx.fillStyle = '#f59e0b';
    ctx.fillText('f₂ = ' + f2 + ' cm', lens2X, cy + lensHeight/2 + 20);

    // Draw separation indicator
    if (d > 0) {
        const sepY = cy + lensHeight/2 + 35;
        ctx.strokeStyle = '#64748b';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(lens1X, sepY);
        ctx.lineTo(lens2X, sepY);
        ctx.stroke();

        // Arrow heads
        ctx.beginPath();
        ctx.moveTo(lens1X + 5, sepY - 3);
        ctx.lineTo(lens1X, sepY);
        ctx.lineTo(lens1X + 5, sepY + 3);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(lens2X - 5, sepY - 3);
        ctx.lineTo(lens2X, sepY);
        ctx.lineTo(lens2X - 5, sepY + 3);
        ctx.stroke();

        ctx.fillStyle = '#64748b';
        ctx.font = '10px Inter';
        ctx.fillText('d = ' + d + ' cm', (lens1X + lens2X) / 2, sepY + 12);
    } else {
        ctx.fillStyle = '#64748b';
        ctx.font = '10px Inter';
        ctx.fillText('(in contact)', (lens1X + lens2X) / 2, cy + lensHeight/2 + 40);
    }

    // Result at top
    ctx.font = 'bold 14px Inter';
    ctx.fillStyle = F > 0 ? '#059669' : '#ea580c';
    ctx.fillText('Equivalent: F = ' + F.toFixed(2) + ' cm', width / 2, 25);

    ctx.font = '11px Inter';
    ctx.fillStyle = '#64748b';
    ctx.fillText(F > 0 ? '(Converging system)' : '(Diverging system)', width / 2, 42);
}

function drawSimpleLens(x, y, isConverging, color, h = 80) {
    ctx.strokeStyle = color;
    ctx.lineWidth = 2.5;
    ctx.beginPath();

    const curve = Math.min(h / 6, 12);
    if (isConverging) {
        ctx.moveTo(x - 4, y - h/2);
        ctx.quadraticCurveTo(x + curve, y, x - 4, y + h/2);
        ctx.moveTo(x + 4, y - h/2);
        ctx.quadraticCurveTo(x - curve, y, x + 4, y + h/2);
    } else {
        ctx.moveTo(x - 4, y - h/2);
        ctx.quadraticCurveTo(x - curve, y, x - 4, y + h/2);
        ctx.moveTo(x + 4, y - h/2);
        ctx.quadraticCurveTo(x + curve, y, x + 4, y + h/2);
    }
    ctx.stroke();

    // Draw small arrows at tips to indicate lens type
    ctx.fillStyle = color;
    if (isConverging) {
        // Arrows pointing inward
        ctx.beginPath();
        ctx.moveTo(x, y - h/2 - 6);
        ctx.lineTo(x - 4, y - h/2);
        ctx.lineTo(x + 4, y - h/2);
        ctx.closePath();
        ctx.fill();
        ctx.beginPath();
        ctx.moveTo(x, y + h/2 + 6);
        ctx.lineTo(x - 4, y + h/2);
        ctx.lineTo(x + 4, y + h/2);
        ctx.closePath();
        ctx.fill();
    }
}

function formatLength(val) {
    if (!isFinite(val)) return '∞';
    if (Math.abs(val) >= 100) return (val / 100).toFixed(2) + ' m';
    return val.toFixed(2) + ' cm';
}

function formatMag(m) {
    if (!isFinite(m)) return '∞';
    return (m >= 0 ? '+' : '') + m.toFixed(2) + '×';
}

function toggleSteps() {
    stepsExpanded = !stepsExpanded;
    document.getElementById('steps-body').classList.toggle('collapsed', !stepsExpanded);
    document.getElementById('steps-toggle').textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
}

function generateThinLensSteps(f, u, v, m, h_o, h_i, power, isReal, isInverted, isMagnified) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Focal length: <span class="highlight">f = ${formatLength(f)}</span> (${f > 0 ? 'Converging' : 'Diverging'})<br>
                Object distance: <span class="highlight">u = ${formatLength(u)}</span><br>
                Object height: <span class="highlight">hₒ = ${h_o} cm</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Apply Thin Lens Formula</div>
            <div class="step-formula">1/f = 1/v - 1/u → 1/v = 1/f + 1/u</div>
            <div class="step-calc">
                1/v = 1/${f.toFixed(2)} + 1/${u.toFixed(2)}<br>
                1/v = ${(1/f).toFixed(4)} + ${(1/u).toFixed(4)}<br>
                1/v = ${(1/f + 1/u).toFixed(4)}<br>
                v = <span class="highlight">${formatLength(v)}</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Image Distance</div>
                <div class="step-result-value">${formatLength(v)} (${isReal ? 'Real' : 'Virtual'})</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Magnification</div>
            <div class="step-formula">m = -v/u = hᵢ/hₒ</div>
            <div class="step-calc">
                m = -${v.toFixed(2)} / ${u.toFixed(2)}<br>
                m = <span class="highlight">${formatMag(m)}</span><br><br>
                Image height: hᵢ = m × hₒ = ${m.toFixed(2)} × ${h_o}<br>
                hᵢ = <span class="highlight">${h_i.toFixed(2)} cm</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Calculate Power</div>
            <div class="step-formula">P = 1/f (in meters) = 100/f (f in cm)</div>
            <div class="step-calc">
                P = 100 / ${f.toFixed(2)}<br>
                P = <span class="highlight">${power >= 0 ? '+' : ''}${power.toFixed(2)} Diopters</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">5</span>Image Characteristics</div>
            <div class="step-calc">
                <strong>Nature:</strong> ${isReal ? 'Real (can be projected)' : 'Virtual (cannot be projected)'}<br>
                <strong>Orientation:</strong> ${isInverted ? 'Inverted (m < 0)' : 'Erect (m > 0)'}<br>
                <strong>Size:</strong> ${Math.abs(Math.abs(m) - 1) < 0.01 ? 'Same size' : (isMagnified ? 'Magnified (|m| > 1)' : 'Diminished (|m| < 1)')}
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function generateLensMakerSteps(mu, R1, R2, f, power) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Refractive index: <span class="highlight">μ = ${mu}</span><br>
                Radius of curvature R₁: <span class="highlight">${R1} cm</span><br>
                Radius of curvature R₂: <span class="highlight">${R2} cm</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Apply Lens Maker's Formula</div>
            <div class="step-formula">1/f = (μ - 1)(1/R₁ - 1/R₂)</div>
            <div class="step-calc">
                1/f = (${mu} - 1)(1/${R1} - 1/${R2})<br>
                1/f = ${(mu - 1).toFixed(2)} × (${(1/R1).toFixed(4)} - ${(1/R2).toFixed(4)})<br>
                1/f = ${(mu - 1).toFixed(2)} × ${(1/R1 - 1/R2).toFixed(4)}<br>
                1/f = ${((mu - 1) * (1/R1 - 1/R2)).toFixed(4)}<br>
                f = <span class="highlight">${f.toFixed(2)} cm</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Focal Length</div>
                <div class="step-result-value">${f.toFixed(2)} cm</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Power</div>
            <div class="step-formula">P = 100/f (Diopters)</div>
            <div class="step-calc">
                P = 100 / ${f.toFixed(2)}<br>
                P = <span class="highlight">${power >= 0 ? '+' : ''}${power.toFixed(2)} D</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Lens Type</div>
            <div class="step-calc">
                ${f > 0 ? '<strong style="color: #059669;">Converging Lens (f > 0)</strong><br>This lens brings parallel rays to a focus.' : '<strong style="color: #ea580c;">Diverging Lens (f < 0)</strong><br>This lens spreads parallel rays apart.'}
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function generateCombinedSteps(f1, f2, d, F, P, P1, P2, formula) {
    const html = `
        <div class="step-item">
            <div class="step-title"><span class="step-number">1</span>Given Values</div>
            <div class="step-calc">
                Focal length f₁: <span class="highlight">${f1} cm</span> (P₁ = ${P1.toFixed(2)} D)<br>
                Focal length f₂: <span class="highlight">${f2} cm</span> (P₂ = ${P2.toFixed(2)} D)<br>
                Separation: <span class="highlight">d = ${d} cm</span> ${d === 0 ? '(in contact)' : ''}
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">2</span>Apply ${d === 0 ? 'Contact' : 'Separated'} Lens Formula</div>
            <div class="step-formula">${d === 0 ? '1/F = 1/f₁ + 1/f₂' : '1/F = 1/f₁ + 1/f₂ - d/(f₁f₂)'}</div>
            <div class="step-calc">
                ${d === 0 ? `
                    1/F = 1/${f1} + 1/${f2}<br>
                    1/F = ${(1/f1).toFixed(4)} + ${(1/f2).toFixed(4)}<br>
                    1/F = ${(1/f1 + 1/f2).toFixed(4)}
                ` : `
                    1/F = 1/${f1} + 1/${f2} - ${d}/(${f1} × ${f2})<br>
                    1/F = ${(1/f1).toFixed(4)} + ${(1/f2).toFixed(4)} - ${(d/(f1*f2)).toFixed(4)}<br>
                    1/F = ${(1/f1 + 1/f2 - d/(f1*f2)).toFixed(4)}
                `}<br>
                F = <span class="highlight">${F.toFixed(2)} cm</span>
            </div>
            <div class="step-result">
                <div class="step-result-label">Equivalent Focal Length</div>
                <div class="step-result-value">${F.toFixed(2)} cm</div>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">3</span>Calculate Equivalent Power</div>
            <div class="step-formula">${d === 0 ? 'P = P₁ + P₂' : 'P = P₁ + P₂ - d×P₁×P₂/100'}</div>
            <div class="step-calc">
                ${d === 0 ? `
                    P = ${P1.toFixed(2)} + ${P2.toFixed(2)}
                ` : `
                    P = ${P1.toFixed(2)} + ${P2.toFixed(2)} - ${d}×${P1.toFixed(2)}×${P2.toFixed(2)}/100<br>
                    P = ${P1.toFixed(2)} + ${P2.toFixed(2)} - ${(d*P1*P2/100).toFixed(2)}
                `}<br>
                P = <span class="highlight">${P >= 0 ? '+' : ''}${P.toFixed(2)} D</span>
            </div>
        </div>
        <div class="step-item">
            <div class="step-title"><span class="step-number">4</span>Result</div>
            <div class="step-calc">
                The combination acts as a <strong>${F > 0 ? 'converging' : 'diverging'}</strong> lens system<br>
                with equivalent focal length <span class="highlight">${F.toFixed(2)} cm</span><br>
                and power <span class="highlight">${P >= 0 ? '+' : ''}${P.toFixed(2)} D</span>
            </div>
        </div>
    `;
    document.getElementById('steps-body').innerHTML = html;
}

function loadExample(num) {
    const examples = {
        1: { mode: 'thinlens', type: 'converging', f: 2, u: 2.5, h: 0.5 }, // Microscope
        2: { mode: 'thinlens', type: 'converging', f: 5, u: 200, h: 100 }, // Camera (50mm = 5cm, 2m = 200cm)
        3: { mode: 'thinlens', type: 'converging', f: 40, u: 25, h: 1 },   // Reading glasses (+2.5D = 40cm)
        4: { mode: 'combined', f1: 100, f2: 5, d: 0 }                       // Telescope
    };

    const ex = examples[num];

    if (ex.mode === 'thinlens') {
        setMode('thinlens');
        setLensType(ex.type);
        setSolveFor('v');
        document.getElementById('focal-length').value = ex.f;
        document.getElementById('object-dist').value = ex.u;
        document.getElementById('object-height').value = ex.h;
    } else if (ex.mode === 'combined') {
        setMode('combined');
        document.getElementById('f1').value = ex.f1;
        document.getElementById('f2').value = ex.f2;
        document.getElementById('separation').value = ex.d;
    }

    calculate();
}

// Expose functions globally
window.setMode = setMode;
window.setLensType = setLensType;
window.setSolveFor = setSolveFor;
window.setRefractiveIndex = setRefractiveIndex;
window.calculate = calculate;
window.toggleSteps = toggleSteps;
window.loadExample = loadExample;
