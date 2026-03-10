/**
 * Lens & Mirror Calculator - Render Module
 * Polished Canvas ray diagram + KaTeX step-by-step rendering
 */
(function() {
'use strict';

// ==================== Helpers ====================

function fmt(n) {
    if (n === 0) return '0';
    if (!isFinite(n)) return String(n);
    if (Math.abs(n - Math.round(n)) < 1e-9) return String(Math.round(n));
    return n.toFixed(4).replace(/\.?0+$/, '');
}

function renderKaTeX(el, latex, displayMode) {
    if (!el || !window.katex) return;
    try {
        katex.render(latex, el, { displayMode: displayMode !== false, throwOnError: false });
    } catch (e) {
        el.textContent = latex;
    }
}

function buildStepDOM(number, description, latex) {
    var step = document.createElement('div');
    step.className = 'lm-step';
    var numEl = document.createElement('div');
    numEl.className = 'lm-step-number';
    numEl.textContent = number;
    var content = document.createElement('div');
    content.className = 'lm-step-content';
    var desc = document.createElement('div');
    desc.className = 'lm-step-desc';
    desc.innerHTML = description;
    content.appendChild(desc);
    if (latex) {
        var math = document.createElement('div');
        math.className = 'lm-step-math';
        renderKaTeX(math, latex, true);
        content.appendChild(math);
    }
    step.appendChild(numEl);
    step.appendChild(content);
    return step;
}

// ==================== Results Display ====================

function renderResults(container, result) {
    if (!container) return;
    container.innerHTML = '';
    if (result.error) {
        var err = document.createElement('div');
        err.className = 'lm-error';
        err.textContent = result.error;
        container.appendChild(err);
        return;
    }
    var grid = document.createElement('div');
    grid.className = 'lm-results-grid';
    var items = [];
    if (result.isPlane) {
        items.push({ label: 'Focal Length (f)', value: '\u221E' });
    } else {
        items.push({ label: 'Focal Length (f)', value: fmt(result.f) + ' cm' });
    }
    items.push({ label: 'Object Distance (u)', value: fmt(result.u) + ' cm' });
    items.push({ label: 'Image Distance (v)', value: fmt(result.v) + ' cm' });
    items.push({ label: 'Magnification (m)', value: fmt(result.m) });
    items.push({ label: 'Image Height (h\')', value: fmt(result.h_prime) + ' cm' });
    if (result.R !== undefined) {
        items.push({ label: 'Radius of Curvature (R)', value: fmt(result.R) + ' cm' });
    }
    if (!result.isPlane) {
        items.push({ label: 'Power (P)', value: fmt(result.power) + ' D' });
    }
    for (var i = 0; i < items.length; i++) {
        var card = document.createElement('div');
        card.className = 'lm-result-card';
        var lbl = document.createElement('div');
        lbl.className = 'lm-result-label';
        lbl.textContent = items[i].label;
        var val = document.createElement('div');
        val.className = 'lm-result-value';
        val.textContent = items[i].value;
        card.appendChild(lbl);
        card.appendChild(val);
        grid.appendChild(card);
    }
    container.appendChild(grid);

    var badges = document.createElement('div');
    badges.className = 'lm-badges';
    var typeBadge = document.createElement('span');
    typeBadge.className = 'lm-badge ' + (result.v > 0 ? 'lm-badge-real' : 'lm-badge-virtual');
    typeBadge.textContent = result.imageType;
    badges.appendChild(typeBadge);
    var orBadge = document.createElement('span');
    orBadge.className = 'lm-badge ' + (result.m < 0 ? 'lm-badge-inverted' : 'lm-badge-upright');
    orBadge.textContent = result.orientation;
    badges.appendChild(orBadge);
    var szBadge = document.createElement('span');
    szBadge.className = 'lm-badge';
    szBadge.textContent = result.size;
    badges.appendChild(szBadge);
    container.appendChild(badges);
}

// ==================== Steps Display ====================

function renderSteps(container, result, mode) {
    if (!container || result.error) return;
    container.innerHTML = '';

    // Plane mirror: simplified steps
    if (result.isPlane) {
        container.appendChild(buildStepDOM('1', '<strong>Given values</strong>',
            'u = ' + fmt(result.u) + '\\text{ cm},\\quad h = ' + fmt(result.h) + '\\text{ cm}'));
        container.appendChild(buildStepDOM('2', '<strong>Plane mirror law:</strong> image at equal distance behind mirror',
            'v = -u = -(' + fmt(result.u) + ') = \\boxed{' + fmt(result.v) + '\\text{ cm}}'));
        container.appendChild(buildStepDOM('3', '<strong>Magnification</strong>',
            'm = 1 \\quad \\text{(always for plane mirror)}'));
        container.appendChild(buildStepDOM('4', '<strong>Image height</strong>',
            "h' = h = \\boxed{" + fmt(result.h) + '\\text{ cm}} \\quad \\text{(same size, upright)}'));
        container.appendChild(buildStepDOM('5', '<strong>Image characteristics:</strong> Virtual, Upright, Same Size. Focal length f = \\infty, Power P = 0 D.', null));
        return;
    }

    var givenLatex = '';
    if (mode !== 'find-f') givenLatex += 'f = ' + fmt(result.f) + '\\text{ cm}';
    if (mode !== 'find-u') givenLatex += (givenLatex ? ',\\quad ' : '') + 'u = ' + fmt(result.u) + '\\text{ cm}';
    if (mode !== 'find-v') givenLatex += (givenLatex ? ',\\quad ' : '') + 'v = ' + fmt(result.v) + '\\text{ cm}';
    givenLatex += ',\\quad h = ' + fmt(result.h) + '\\text{ cm}';
    container.appendChild(buildStepDOM('1', '<strong>Given values</strong>', givenLatex));

    if (mode === 'find-v') {
        container.appendChild(buildStepDOM('2', '<strong>Thin Lens Equation:</strong> solve for v',
            '\\frac{1}{v} = \\frac{1}{f} - \\frac{1}{u} = \\frac{1}{' + fmt(result.f) + '} - \\frac{1}{' + fmt(result.u) + '} = ' + fmt(1/result.f - 1/result.u)));
        container.appendChild(buildStepDOM('3', '<strong>Image distance</strong>',
            'v = \\frac{1}{' + fmt(1/result.f - 1/result.u) + '} = \\boxed{' + fmt(result.v) + '\\text{ cm}}'));
    } else if (mode === 'find-u') {
        container.appendChild(buildStepDOM('2', '<strong>Thin Lens Equation:</strong> solve for u',
            '\\frac{1}{u} = \\frac{1}{f} - \\frac{1}{v} = \\frac{1}{' + fmt(result.f) + '} - \\frac{1}{' + fmt(result.v) + '} = ' + fmt(1/result.f - 1/result.v)));
        container.appendChild(buildStepDOM('3', '<strong>Object distance</strong>',
            'u = \\frac{1}{' + fmt(1/result.f - 1/result.v) + '} = \\boxed{' + fmt(result.u) + '\\text{ cm}}'));
    } else {
        container.appendChild(buildStepDOM('2', '<strong>Thin Lens Equation:</strong> solve for f',
            '\\frac{1}{f} = \\frac{1}{u} + \\frac{1}{v} = \\frac{1}{' + fmt(result.u) + '} + \\frac{1}{' + fmt(result.v) + '} = ' + fmt(1/result.u + 1/result.v)));
        container.appendChild(buildStepDOM('3', '<strong>Focal length</strong>',
            'f = \\frac{1}{' + fmt(1/result.u + 1/result.v) + '} = \\boxed{' + fmt(result.f) + '\\text{ cm}}'));
    }

    container.appendChild(buildStepDOM('4', '<strong>Magnification</strong>',
        'm = \\frac{v}{u} = \\frac{' + fmt(result.v) + '}{' + fmt(result.u) + '} = \\boxed{' + fmt(result.m) + '}'));
    container.appendChild(buildStepDOM('5', '<strong>Image height</strong>',
        "h' = m \\times h = " + fmt(result.m) + ' \\times ' + fmt(result.h) + ' = \\boxed{' + fmt(result.h_prime) + '\\text{ cm}}'));

    var stepNum = 6;
    if (result.R !== undefined) {
        container.appendChild(buildStepDOM(String(stepNum), '<strong>Radius of curvature</strong>',
            'R = 2f = 2 \\times ' + fmt(result.f) + ' = \\boxed{' + fmt(result.R) + '\\text{ cm}}'));
        stepNum++;
    }

    container.appendChild(buildStepDOM(String(stepNum), '<strong>Power</strong>',
        'P = \\frac{1}{f_{\\text{m}}} = \\frac{1}{' + fmt(result.f / 100) + '} = \\boxed{' + fmt(result.power) + '\\text{ D}}'));
    stepNum++;

    var charDesc = '<strong>Image characteristics:</strong> ';
    charDesc += result.imageType + ' (v ' + (result.v > 0 ? '> 0' : '< 0') + '), ';
    charDesc += result.orientation + ' (m ' + (result.m < 0 ? '< 0' : '> 0') + '), ';
    charDesc += result.size + ' (|m| = ' + fmt(Math.abs(result.m)) + ')';
    container.appendChild(buildStepDOM(String(stepNum), charDesc, null));
}

// ==================== Color Themes ====================

function getTheme() {
    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    if (isDark) {
        return {
            bg: '#0c1220',
            grid: '#0e1825',
            axis: '#1a2f48',
            axisCenter: '#162030',
            lens: '#4ec9f5',
            lensFill: 'rgba(78,201,245,0.05)',
            mirror: '#4ec9f5',
            mirrorHatch: '#1a2f48',
            focal: '#f7c948',
            focalDim: 'rgba(247,201,72,0.4)',
            obj: '#ffffff',
            objLabel: '#6b8fae',
            imgReal: '#3b82f6',
            imgVirtual: '#f7c948',
            ray1: '#ff6b35',
            ray2: '#4ec9f5',
            ray3: '#3de8b0',
            virtualExt: '#666666',
            bracket: '#a0c4ff',
            bracketImg: '#f7c948',
            bracketF: 'rgba(247,201,72,0.5)',
            dimText: '#2e4460',
            font: "'JetBrains Mono', 'Inter', monospace"
        };
    }
    return {
        bg: '#f8fafc',
        grid: '#f0f2f5',
        axis: '#c8d4e0',
        axisCenter: '#dde4ec',
        lens: '#2563eb',
        lensFill: 'rgba(37,99,235,0.06)',
        mirror: '#2563eb',
        mirrorHatch: '#c8d4e0',
        focal: '#dc2626',
        focalDim: 'rgba(220,38,38,0.35)',
        obj: '#1e293b',
        objLabel: '#475569',
        imgReal: '#2563eb',
        imgVirtual: '#d97706',
        ray1: '#ef4444',
        ray2: '#2563eb',
        ray3: '#059669',
        virtualExt: '#9ca3af',
        bracket: '#6366f1',
        bracketImg: '#d97706',
        bracketF: 'rgba(220,38,38,0.5)',
        dimText: '#94a3b8',
        font: "'Inter', 'JetBrains Mono', sans-serif"
    };
}

// ==================== Drawing Primitives ====================

function ln(ctx, x1, y1, x2, y2) {
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
}

function drawArrow(ctx, x1, y1, x2, y2, color, alpha, size) {
    alpha = alpha || 1;
    size = size || 7;
    ctx.save();
    ctx.globalAlpha = alpha;
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = 1.8;
    ctx.setLineDash([]);
    ctx.lineCap = 'round';
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
    var a = Math.atan2(y2 - y1, x2 - x1);
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2 - size * Math.cos(a - 0.38), y2 - size * Math.sin(a - 0.38));
    ctx.lineTo(x2 - size * Math.cos(a + 0.38), y2 - size * Math.sin(a + 0.38));
    ctx.closePath();
    ctx.fill();
    ctx.restore();
}

function drawRay(ctx, x1, y1, x2, y2, color, dashed, alpha) {
    ctx.save();
    ctx.globalAlpha = alpha || 1;
    ctx.strokeStyle = color;
    ctx.lineWidth = dashed ? 1.2 : 1.8;
    ctx.setLineDash(dashed ? [5, 4] : []);
    ctx.lineCap = 'round';
    ln(ctx, x1, y1, x2, y2);
    ctx.restore();
}

function drawDot(ctx, x, y, r, color, alpha) {
    ctx.save();
    ctx.globalAlpha = alpha || 1;
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
}

function drawText(ctx, text, x, y, color, size, align, alpha, font) {
    ctx.save();
    ctx.globalAlpha = alpha || 1;
    ctx.fillStyle = color;
    ctx.font = (size || 10) + 'px ' + (font || "'Inter', sans-serif");
    ctx.textAlign = align || 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(text, x, y);
    ctx.restore();
}

function extendRay(ctx, x0, y0, dx, dy) {
    var W = ctx.canvas.width, H = ctx.canvas.height;
    var t = Infinity;
    if (dx > 0) t = Math.min(t, (W - 15 - x0) / dx);
    if (dx < 0) t = Math.min(t, (15 - x0) / dx);
    if (dy < 0) t = Math.min(t, (15 - y0) / dy);
    if (dy > 0) t = Math.min(t, (H - 15 - y0) / dy);
    t = Math.max(0, t);
    return [x0 + t * dx, y0 + t * dy];
}

// Mid-ray arrowhead
function midArrow(ctx, x1, y1, x2, y2, frac, color, alpha) {
    var mx = x1 + (x2 - x1) * frac;
    var my = y1 + (y2 - y1) * frac;
    var mx2 = x1 + (x2 - x1) * (frac + 0.015);
    var my2 = y1 + (y2 - y1) * (frac + 0.015);
    drawArrow(ctx, mx, my, mx2, my2, color, alpha, 6);
}

// ==================== Object / Image Arrows ====================

function drawObjectArrow(ctx, x, axisY, tipY, color, dashed, alpha) {
    ctx.save();
    ctx.globalAlpha = alpha || 1;
    ctx.strokeStyle = color;
    ctx.lineWidth = 2;
    ctx.setLineDash(dashed ? [4, 3] : []);
    ctx.lineCap = 'round';
    ln(ctx, x, axisY, x, tipY);
    ctx.restore();
    drawArrow(ctx, x, axisY + (tipY < axisY ? -4 : 4), x, tipY, color, alpha, 7);
}

// ==================== Distance Brackets ====================

function drawBracket(ctx, x1, x2, y, color, label, labelY, T) {
    ctx.save();
    ctx.globalAlpha = 0.5;
    ctx.strokeStyle = color;
    ctx.lineWidth = 1;
    ctx.setLineDash([2, 3]);
    ctx.lineCap = 'round';
    ln(ctx, x1, y, x2, y);
    ctx.setLineDash([]);
    ln(ctx, x1, y - 4, x1, y + 4);
    ln(ctx, x2, y - 4, x2, y + 4);
    ctx.restore();
    drawText(ctx, label, (x1 + x2) / 2, labelY, color, 9, 'center', 0.7, T.font);
}

// ==================== Lens Shapes ====================

function drawConvergingLens(ctx, cx, cy, lh, lw, T) {
    var bow = lw * 0.82;
    ctx.save();
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 12;
    ctx.strokeStyle = T.lens;
    ctx.lineWidth = 1.6;
    ctx.setLineDash([]);

    // Left surface (curves LEFT = outward for convex)
    ctx.beginPath();
    ctx.moveTo(cx - lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx - lw / 2 - bow, cy, cx - lw / 2, cy + lh / 2);
    ctx.stroke();

    // Right surface (curves RIGHT = outward)
    ctx.beginPath();
    ctx.moveTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 + bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.stroke();

    // Top and bottom edges
    ln(ctx, cx - lw / 2, cy - lh / 2, cx + lw / 2, cy - lh / 2);
    ln(ctx, cx - lw / 2, cy + lh / 2, cx + lw / 2, cy + lh / 2);

    // Fill
    ctx.shadowBlur = 0;
    ctx.beginPath();
    ctx.moveTo(cx - lw / 2, cy - lh / 2);
    ctx.lineTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 + bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.lineTo(cx - lw / 2, cy + lh / 2);
    ctx.quadraticCurveTo(cx - lw / 2 - bow, cy, cx - lw / 2, cy - lh / 2);
    ctx.closePath();
    ctx.fillStyle = T.lensFill;
    ctx.fill();

    // Converging arrows (inward at tips)
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 8;
    drawArrow(ctx, cx, cy - lh / 2 + 14, cx, cy - lh / 2 - 4, T.lens, 0.8, 6);
    drawArrow(ctx, cx, cy + lh / 2 - 14, cx, cy + lh / 2 + 4, T.lens, 0.8, 6);

    ctx.restore();
}

function drawDivergingLens(ctx, cx, cy, lh, lw, T) {
    var bow = lw * 0.82;
    ctx.save();
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 12;
    ctx.strokeStyle = T.lens;
    ctx.lineWidth = 1.6;
    ctx.setLineDash([]);

    // Left surface (curves RIGHT = inward for concave)
    ctx.beginPath();
    ctx.moveTo(cx - lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx - lw / 2 + bow, cy, cx - lw / 2, cy + lh / 2);
    ctx.stroke();

    // Right surface (curves LEFT = inward)
    ctx.beginPath();
    ctx.moveTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 - bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.stroke();

    // Top and bottom
    ln(ctx, cx - lw / 2, cy - lh / 2, cx + lw / 2, cy - lh / 2);
    ln(ctx, cx - lw / 2, cy + lh / 2, cx + lw / 2, cy + lh / 2);

    // Fill
    ctx.shadowBlur = 0;
    ctx.beginPath();
    ctx.moveTo(cx - lw / 2, cy - lh / 2);
    ctx.lineTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 - bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.lineTo(cx - lw / 2, cy + lh / 2);
    ctx.quadraticCurveTo(cx - lw / 2 + bow, cy, cx - lw / 2, cy - lh / 2);
    ctx.closePath();
    ctx.fillStyle = T.lensFill;
    ctx.fill();

    // Diverging arrows (outward at tips)
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 8;
    drawArrow(ctx, cx, cy - lh / 2 + 14, cx, cy - lh / 2 - 4, T.lens, 0.8, 6);
    drawArrow(ctx, cx, cy + lh / 2 - 14, cx, cy + lh / 2 + 4, T.lens, 0.8, 6);

    ctx.restore();
}

function drawConcaveMirror(ctx, cx, cy, lh, T) {
    var curve = lh * 0.15;
    ctx.save();
    ctx.shadowColor = T.mirror;
    ctx.shadowBlur = 10;
    ctx.strokeStyle = T.mirror;
    ctx.lineWidth = 2;
    ctx.setLineDash([]);

    ctx.beginPath();
    ctx.moveTo(cx, cy - lh / 2);
    ctx.quadraticCurveTo(cx - curve, cy, cx, cy + lh / 2);
    ctx.stroke();

    // Hatching on back side
    ctx.shadowBlur = 0;
    ctx.strokeStyle = T.mirrorHatch;
    ctx.lineWidth = 1;
    for (var i = 0; i <= 8; i++) {
        var t = i / 8;
        var py = -lh / 2 + t * lh;
        var px = -curve * (1 - Math.pow(2 * t - 1, 2));
        ln(ctx, cx + px, cy + py, cx + px + lh * 0.05, cy + py - lh * 0.05);
    }
    ctx.restore();
}

function drawConvexMirror(ctx, cx, cy, lh, T) {
    var curve = lh * 0.15;
    ctx.save();
    ctx.shadowColor = T.mirror;
    ctx.shadowBlur = 10;
    ctx.strokeStyle = T.mirror;
    ctx.lineWidth = 2;
    ctx.setLineDash([]);

    ctx.beginPath();
    ctx.moveTo(cx, cy - lh / 2);
    ctx.quadraticCurveTo(cx + curve, cy, cx, cy + lh / 2);
    ctx.stroke();

    // Hatching
    ctx.shadowBlur = 0;
    ctx.strokeStyle = T.mirrorHatch;
    ctx.lineWidth = 1;
    for (var i = 0; i <= 8; i++) {
        var t = i / 8;
        var py = -lh / 2 + t * lh;
        var px = curve * (1 - Math.pow(2 * t - 1, 2));
        ln(ctx, cx + px, cy + py, cx + px + lh * 0.05, cy + py - lh * 0.05);
    }
    ctx.restore();
}

function drawPlanoConvexLens(ctx, cx, cy, lh, lw, T) {
    var bow = lw * 0.82;
    ctx.save();
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 12;
    ctx.strokeStyle = T.lens;
    ctx.lineWidth = 1.6;
    ctx.setLineDash([]);

    // Left surface: flat (straight line)
    ln(ctx, cx - lw / 2, cy - lh / 2, cx - lw / 2, cy + lh / 2);

    // Right surface: convex (curves outward)
    ctx.beginPath();
    ctx.moveTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 + bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.stroke();

    // Top and bottom edges
    ln(ctx, cx - lw / 2, cy - lh / 2, cx + lw / 2, cy - lh / 2);
    ln(ctx, cx - lw / 2, cy + lh / 2, cx + lw / 2, cy + lh / 2);

    // Fill
    ctx.shadowBlur = 0;
    ctx.beginPath();
    ctx.moveTo(cx - lw / 2, cy - lh / 2);
    ctx.lineTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 + bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.lineTo(cx - lw / 2, cy + lh / 2);
    ctx.closePath();
    ctx.fillStyle = T.lensFill;
    ctx.fill();

    // Converging arrows
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 8;
    drawArrow(ctx, cx, cy - lh / 2 + 14, cx, cy - lh / 2 - 4, T.lens, 0.8, 6);
    drawArrow(ctx, cx, cy + lh / 2 - 14, cx, cy + lh / 2 + 4, T.lens, 0.8, 6);

    ctx.restore();
}

function drawPlanoConcaveLens(ctx, cx, cy, lh, lw, T) {
    var bow = lw * 0.82;
    ctx.save();
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 12;
    ctx.strokeStyle = T.lens;
    ctx.lineWidth = 1.6;
    ctx.setLineDash([]);

    // Left surface: flat (straight line)
    ln(ctx, cx - lw / 2, cy - lh / 2, cx - lw / 2, cy + lh / 2);

    // Right surface: concave (curves inward)
    ctx.beginPath();
    ctx.moveTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 - bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.stroke();

    // Top and bottom edges
    ln(ctx, cx - lw / 2, cy - lh / 2, cx + lw / 2, cy - lh / 2);
    ln(ctx, cx - lw / 2, cy + lh / 2, cx + lw / 2, cy + lh / 2);

    // Fill
    ctx.shadowBlur = 0;
    ctx.beginPath();
    ctx.moveTo(cx - lw / 2, cy - lh / 2);
    ctx.lineTo(cx + lw / 2, cy - lh / 2);
    ctx.quadraticCurveTo(cx + lw / 2 - bow, cy, cx + lw / 2, cy + lh / 2);
    ctx.lineTo(cx - lw / 2, cy + lh / 2);
    ctx.closePath();
    ctx.fillStyle = T.lensFill;
    ctx.fill();

    // Diverging arrows
    ctx.shadowColor = T.lens;
    ctx.shadowBlur = 8;
    drawArrow(ctx, cx, cy - lh / 2 + 14, cx, cy - lh / 2 - 4, T.lens, 0.8, 6);
    drawArrow(ctx, cx, cy + lh / 2 - 14, cx, cy + lh / 2 + 4, T.lens, 0.8, 6);

    ctx.restore();
}

function drawPlaneMirror(ctx, cx, cy, lh, T) {
    ctx.save();
    ctx.shadowColor = T.mirror;
    ctx.shadowBlur = 10;
    ctx.strokeStyle = T.mirror;
    ctx.lineWidth = 2.5;
    ctx.setLineDash([]);

    // Straight vertical line
    ln(ctx, cx, cy - lh / 2, cx, cy + lh / 2);

    // Hatching on back side
    ctx.shadowBlur = 0;
    ctx.strokeStyle = T.mirrorHatch;
    ctx.lineWidth = 1;
    for (var i = 0; i <= 10; i++) {
        var t = i / 10;
        var py = cy - lh / 2 + t * lh;
        ln(ctx, cx, py, cx + lh * 0.05, py - lh * 0.05);
    }
    ctx.restore();
}

// ==================== Main Draw ====================

function drawRayDiagram(canvas, result, opticalType) {
    if (!canvas || result.error) return;

    var ctx = canvas.getContext('2d');
    var container = canvas.parentElement;
    var W = container.clientWidth;
    var H = Math.max(360, Math.min(480, W * 0.5));
    canvas.width = W;
    canvas.height = H;
    canvas.style.height = H + 'px';

    var T = getTheme();

    // Plane mirror: dedicated simple diagram
    if (opticalType === 'plane-mirror') {
        drawPlaneMirrorDiagram(ctx, W, H, result, T);
        return;
    }

    // Physics values (using absolute values for layout, signs for direction)
    var f = result.f;
    var u = result.u;   // negative (object on left)
    var v = result.v;   // positive=real, negative=virtual
    var h = result.h;
    var hi = result.h_prime;

    var absU = Math.abs(u);
    var absV = Math.abs(v);
    var absF = Math.abs(f);

    // ── Layout ──────────────────────────────────────────
    var lx = W * 0.5;    // lens x
    var ly = H * 0.48;   // optical axis y
    var lh = Math.min(140, Math.max(80, h * 14 + 50));
    var lw = 22;

    // Adaptive scale
    var leftPx = lx - 70;
    var rightPx = W - lx - 50;
    var maxLeft = absU + 4;
    var maxRight = Math.max(absF * 2.2, absV) + 8;
    var scale = Math.min(leftPx / maxLeft, rightPx / maxRight);
    if (scale < 0.5) scale = 0.5;

    // Also clamp vertical: ensure object/image arrows fit
    var maxArrowH = Math.max(Math.abs(h), Math.abs(hi));
    var availH = ly - 50;
    var vScale = availH / (maxArrowH * scale);
    if (vScale < 1) scale = scale * vScale;

    // Key pixel coordinates
    var obj_x = lx - absU * scale;       // object (left of lens)
    var obj_ty = ly - h * scale;          // object tip (above axis)
    var img_x = lx + v * scale;           // image (right if real, left if virtual)
    var img_ty = ly - hi * scale;         // image tip
    var F1x = lx + f * scale;             // F (right for converging, left for diverging)
    var F2x = lx - f * scale;             // F'

    // ── Clear + Background ──────────────────────────────
    ctx.clearRect(0, 0, W, H);
    ctx.fillStyle = T.bg;
    ctx.fillRect(0, 0, W, H);

    // Background grid
    ctx.save();
    ctx.strokeStyle = T.grid;
    ctx.lineWidth = 1;
    var gs = 44;
    for (var gx = 0; gx < W; gx += gs) { ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, H); ctx.stroke(); }
    for (var gy = 0; gy < H; gy += gs) { ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(W, gy); ctx.stroke(); }
    ctx.restore();

    // ── Optical axis ────────────────────────────────────
    ctx.save();
    ctx.strokeStyle = T.axis;
    ctx.lineWidth = 1;
    ctx.setLineDash([10, 6]);
    ln(ctx, 0, ly, W, ly);
    ctx.restore();

    // Lens center line
    ctx.save();
    ctx.strokeStyle = T.axisCenter;
    ctx.lineWidth = 1;
    ctx.setLineDash([4, 4]);
    ln(ctx, lx, 10, lx, H - 10);
    ctx.restore();

    // ── Principal Rays ──────────────────────────────────
    drawPrincipalRays(ctx, result, T, lx, ly, scale, obj_x, obj_ty, img_x, img_ty, F1x, F2x);

    // ── Optical Element ─────────────────────────────────
    if (opticalType === 'converging') {
        drawConvergingLens(ctx, lx, ly, lh, lw, T);
        drawText(ctx, 'Biconvex Lens', lx, ly - lh / 2 - 22, T.lens, 10, 'center', 0.6, T.font);
    } else if (opticalType === 'diverging') {
        drawDivergingLens(ctx, lx, ly, lh, lw, T);
        drawText(ctx, 'Biconcave Lens', lx, ly - lh / 2 - 22, T.lens, 10, 'center', 0.6, T.font);
    } else if (opticalType === 'plano-convex') {
        drawPlanoConvexLens(ctx, lx, ly, lh, lw, T);
        drawText(ctx, 'Plano-Convex Lens', lx, ly - lh / 2 - 22, T.lens, 10, 'center', 0.6, T.font);
    } else if (opticalType === 'plano-concave') {
        drawPlanoConcaveLens(ctx, lx, ly, lh, lw, T);
        drawText(ctx, 'Plano-Concave Lens', lx, ly - lh / 2 - 22, T.lens, 10, 'center', 0.6, T.font);
    } else if (opticalType === 'concave-mirror') {
        drawConcaveMirror(ctx, lx, ly, lh, T);
        drawText(ctx, 'Concave Mirror', lx, ly - lh / 2 - 22, T.mirror, 10, 'center', 0.6, T.font);
    } else if (opticalType === 'convex-mirror') {
        drawConvexMirror(ctx, lx, ly, lh, T);
        drawText(ctx, 'Convex Mirror', lx, ly - lh / 2 - 22, T.mirror, 10, 'center', 0.6, T.font);
    } else if (opticalType === 'plane-mirror') {
        drawPlaneMirror(ctx, lx, ly, lh, T);
        drawText(ctx, 'Plane Mirror', lx, ly - lh / 2 - 22, T.mirror, 10, 'center', 0.6, T.font);
    }

    // ── Focal Points ────────────────────────────────────
    if (absF < 1000) {
        // F
        ctx.save();
        ctx.shadowColor = T.focal;
        ctx.shadowBlur = 8;
        drawDot(ctx, F1x, ly, 5, T.focal, 1);
        ctx.restore();
        ctx.save();
        ctx.strokeStyle = T.focal;
        ctx.lineWidth = 1.5;
        ctx.setLineDash([]);
        ln(ctx, F1x, ly - 6, F1x, ly + 6);
        ctx.restore();
        drawText(ctx, 'F', F1x, ly + 18, T.focal, 11, 'center', 1, T.font);

        // F'
        drawDot(ctx, F2x, ly, 4, T.focalDim, 1);
        ctx.save();
        ctx.strokeStyle = T.focalDim;
        ctx.lineWidth = 1;
        ctx.setLineDash([]);
        ln(ctx, F2x, ly - 6, F2x, ly + 6);
        ctx.restore();
        drawText(ctx, "F'", F2x, ly + 18, T.focalDim, 11, 'center', 1, T.font);
    }

    // ── Object Arrow ────────────────────────────────────
    ctx.save();
    ctx.shadowColor = T.obj;
    ctx.shadowBlur = 6;
    drawObjectArrow(ctx, obj_x, ly, obj_ty, T.obj, false, 1);
    ctx.restore();
    drawDot(ctx, obj_x, ly, 3, T.obj, 1);
    drawText(ctx, 'Object', obj_x, obj_ty - 16, T.objLabel, 10, 'center', 1, T.font);

    // ── Image Arrow ─────────────────────────────────────
    var imgColor = v > 0 ? T.imgReal : T.imgVirtual;
    var imgDashed = v < 0;
    ctx.save();
    ctx.shadowColor = imgColor;
    ctx.shadowBlur = 8;
    drawObjectArrow(ctx, img_x, ly, img_ty, imgColor, imgDashed, 0.85);
    ctx.restore();
    drawDot(ctx, img_x, ly, 3, imgColor, imgDashed ? 0.5 : 1);

    // Image convergence dot at tip
    ctx.save();
    ctx.shadowColor = imgColor;
    ctx.shadowBlur = 14;
    drawDot(ctx, img_x, img_ty, 4.5, imgColor, 0.9);
    ctx.restore();

    var imgLabelText = v > 0 ? 'Real' : 'Virtual';
    drawText(ctx, imgLabelText, img_x, img_ty - 20, imgColor, 10, 'center', 0.7, T.font);
    drawText(ctx, 'Image', img_x, img_ty - 8, imgColor, 10, 'center', 0.7, T.font);

    // ── Distance Brackets ───────────────────────────────
    var bracketY = ly + lh / 2 + 28;
    var labelY = bracketY + 14;

    // u bracket
    if (Math.abs(obj_x - lx) > 30) {
        drawBracket(ctx, obj_x, lx, bracketY, T.bracket,
            'u = ' + absU.toFixed(1) + ' cm', labelY, T);
    }

    // v bracket
    if (Math.abs(img_x - lx) > 25) {
        drawBracket(ctx, img_x, lx, bracketY + 24, T.bracketImg,
            '|v| = ' + absV.toFixed(1) + ' cm', labelY + 24, T);
    }

    // f bracket
    if (Math.abs(F1x - lx) > 20 && Math.abs(F1x - obj_x) > 25) {
        drawBracket(ctx, F1x, lx, bracketY + 48, T.bracketF,
            'f = ' + absF.toFixed(1) + ' cm', labelY + 48, T);
    }

    // ── Axis arrow (right edge) ─────────────────────────
    ctx.save();
    ctx.globalAlpha = 0.25;
    ctx.strokeStyle = T.dimText;
    ctx.fillStyle = T.dimText;
    ctx.lineWidth = 1;
    ctx.setLineDash([]);
    ctx.beginPath();
    ctx.moveTo(W - 50, ly);
    ctx.lineTo(W - 14, ly);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(W - 14, ly);
    ctx.lineTo(W - 22, ly - 4);
    ctx.lineTo(W - 22, ly + 4);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
    drawText(ctx, 'Optical Axis', W - 50, ly - 12, T.dimText, 9, 'right', 0.7, T.font);
}

// ==================== Plane Mirror Diagram ====================

function drawPlaneMirrorDiagram(ctx, W, H, result, T) {
    var u = result.u;
    var h = result.h;
    var absU = Math.abs(u);

    var mx = W * 0.5;    // mirror x
    var ly = H * 0.48;   // axis y
    var lh = Math.min(160, Math.max(100, h * 14 + 60));

    // Scale: fit object and image (same distance)
    var sidePx = mx - 80;
    var scale = sidePx / (absU + 4);
    if (scale < 0.5) scale = 0.5;

    // Clamp vertical
    var availH = ly - 50;
    var vScale = availH / (h * scale);
    if (vScale < 1) scale = scale * vScale;

    var obj_x = mx - absU * scale;
    var obj_ty = ly - h * scale;
    var img_x = mx + absU * scale;   // virtual image behind mirror
    var img_ty = ly - h * scale;     // same height, upright

    // Background
    ctx.clearRect(0, 0, W, H);
    ctx.fillStyle = T.bg;
    ctx.fillRect(0, 0, W, H);

    // Grid
    ctx.save();
    ctx.strokeStyle = T.grid;
    ctx.lineWidth = 1;
    var gs = 44;
    for (var gx = 0; gx < W; gx += gs) { ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, H); ctx.stroke(); }
    for (var gy = 0; gy < H; gy += gs) { ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(W, gy); ctx.stroke(); }
    ctx.restore();

    // Optical axis
    ctx.save();
    ctx.strokeStyle = T.axis;
    ctx.lineWidth = 1;
    ctx.setLineDash([10, 6]);
    ln(ctx, 0, ly, W, ly);
    ctx.restore();

    // ── Rays: two rays from object reflecting off mirror ──
    // Ray 1: from object tip, hits mirror perpendicular (horizontal), reflects back
    drawRay(ctx, obj_x, obj_ty, mx, obj_ty, T.ray1, false, 0.9);
    midArrow(ctx, obj_x, obj_ty, mx, obj_ty, 0.55, T.ray1, 0.9);
    // Reflected back (same horizontal line)
    drawRay(ctx, mx, obj_ty, obj_x - 30, obj_ty, T.ray1, false, 0.7);
    midArrow(ctx, mx, obj_ty, obj_x - 30, obj_ty, 0.4, T.ray1, 0.7);
    // Virtual extension behind mirror
    drawRay(ctx, mx, obj_ty, img_x, img_ty, T.virtualExt, true, 0.4);

    // Ray 2: from object tip to mirror at angle
    var hitY = ly - h * scale * 0.3;   // hits mirror lower
    drawRay(ctx, obj_x, obj_ty, mx, hitY, T.ray2, false, 0.9);
    midArrow(ctx, obj_x, obj_ty, mx, hitY, 0.55, T.ray2, 0.9);
    // Reflects at equal angle (angle of incidence = angle of reflection)
    var dy = hitY - obj_ty;   // how much lower the hit point is
    var reflEndX = obj_x - 30;
    var reflEndY = hitY + dy * ((mx - reflEndX) / (mx - obj_x));
    drawRay(ctx, mx, hitY, reflEndX, reflEndY, T.ray2, false, 0.7);
    midArrow(ctx, mx, hitY, reflEndX, reflEndY, 0.4, T.ray2, 0.7);
    // Virtual extension behind mirror
    drawRay(ctx, mx, hitY, img_x, img_ty, T.virtualExt, true, 0.4);

    // Ray 3: from object base (on axis) at angle
    var hitY3 = ly - h * scale * 0.15;
    drawRay(ctx, obj_x, ly, mx, hitY3, T.ray3, false, 0.8);
    midArrow(ctx, obj_x, ly, mx, hitY3, 0.55, T.ray3, 0.8);
    var dy3 = hitY3 - ly;
    var refl3EndX = obj_x - 20;
    var refl3EndY = hitY3 + dy3 * ((mx - refl3EndX) / (mx - obj_x));
    drawRay(ctx, mx, hitY3, refl3EndX, refl3EndY, T.ray3, false, 0.6);
    // Virtual extension
    drawRay(ctx, mx, hitY3, img_x, ly, T.virtualExt, true, 0.4);

    // ── Mirror ──
    drawPlaneMirror(ctx, mx, ly, lh, T);
    drawText(ctx, 'Plane Mirror', mx, ly - lh / 2 - 22, T.mirror, 10, 'center', 0.6, T.font);

    // ── Object Arrow ──
    ctx.save();
    ctx.shadowColor = T.obj;
    ctx.shadowBlur = 6;
    drawObjectArrow(ctx, obj_x, ly, obj_ty, T.obj, false, 1);
    ctx.restore();
    drawDot(ctx, obj_x, ly, 3, T.obj, 1);
    drawText(ctx, 'Object', obj_x, obj_ty - 16, T.objLabel, 10, 'center', 1, T.font);

    // ── Virtual Image Arrow (dashed, behind mirror) ──
    ctx.save();
    ctx.shadowColor = T.imgVirtual;
    ctx.shadowBlur = 8;
    drawObjectArrow(ctx, img_x, ly, img_ty, T.imgVirtual, true, 0.7);
    ctx.restore();
    drawDot(ctx, img_x, ly, 3, T.imgVirtual, 0.5);
    ctx.save();
    ctx.shadowColor = T.imgVirtual;
    ctx.shadowBlur = 14;
    drawDot(ctx, img_x, img_ty, 4.5, T.imgVirtual, 0.8);
    ctx.restore();
    drawText(ctx, 'Virtual', img_x, img_ty - 20, T.imgVirtual, 10, 'center', 0.7, T.font);
    drawText(ctx, 'Image', img_x, img_ty - 8, T.imgVirtual, 10, 'center', 0.7, T.font);

    // ── Distance Brackets ──
    var bracketY = ly + lh / 2 + 28;
    drawBracket(ctx, obj_x, mx, bracketY, T.bracket,
        'u = ' + absU.toFixed(1) + ' cm', bracketY + 14, T);
    drawBracket(ctx, img_x, mx, bracketY + 24, T.bracketImg,
        'v = ' + absU.toFixed(1) + ' cm', bracketY + 38, T);

    // Axis arrow
    ctx.save();
    ctx.globalAlpha = 0.25;
    ctx.strokeStyle = T.dimText;
    ctx.fillStyle = T.dimText;
    ctx.lineWidth = 1;
    ctx.setLineDash([]);
    ctx.beginPath();
    ctx.moveTo(W - 50, ly);
    ctx.lineTo(W - 14, ly);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(W - 14, ly);
    ctx.lineTo(W - 22, ly - 4);
    ctx.lineTo(W - 22, ly + 4);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
}

// ==================== Principal Rays ====================

function drawPrincipalRays(ctx, result, T, lx, ly, scale, obj_x, obj_ty, img_x, img_ty, F1x, F2x) {
    var v = result.v;
    var isReal = v > 0;

    // ── Ray 1: Parallel to axis → through/from F ──────
    // Incoming: horizontal from object tip to lens
    drawRay(ctx, obj_x, obj_ty, lx, obj_ty, T.ray1, false, 0.9);
    midArrow(ctx, obj_x, obj_ty, lx, obj_ty, 0.55, T.ray1, 0.9);

    if (isReal) {
        // Outgoing: from lens to image through F
        drawRay(ctx, lx, obj_ty, img_x, img_ty, T.ray1, false, 0.9);
        midArrow(ctx, lx, obj_ty, img_x, img_ty, 0.5, T.ray1, 0.9);
    } else {
        // Outgoing: diverges away from F
        var r1dx = lx - F1x;
        var r1dy = obj_ty - ly;
        var r1end = extendRay(ctx, lx, obj_ty, r1dx, r1dy);
        drawRay(ctx, lx, obj_ty, r1end[0], r1end[1], T.ray1, false, 0.9);
        midArrow(ctx, lx, obj_ty, r1end[0], r1end[1], 0.5, T.ray1, 0.9);
        // Virtual extension back to image
        drawRay(ctx, lx, obj_ty, img_x, img_ty, T.virtualExt, true, 0.4);
    }

    // ── Ray 2: Through center (undeviated) ────────────
    if (isReal) {
        drawRay(ctx, obj_x, obj_ty, img_x, img_ty, T.ray3, false, 0.9);
        midArrow(ctx, obj_x, obj_ty, lx, ly, 0.5, T.ray3, 0.9);
        midArrow(ctx, lx, ly, img_x, img_ty, 0.45, T.ray3, 0.9);
    } else {
        // Through center and extend beyond
        var r3dx = lx - obj_x;
        var r3dy = ly - obj_ty;
        drawRay(ctx, obj_x, obj_ty, lx, ly, T.ray3, false, 0.9);
        midArrow(ctx, obj_x, obj_ty, lx, ly, 0.5, T.ray3, 0.9);
        var r3end = extendRay(ctx, lx, ly, r3dx, r3dy);
        drawRay(ctx, lx, ly, r3end[0], r3end[1], T.ray3, false, 0.9);
        midArrow(ctx, lx, ly, r3end[0], r3end[1], 0.45, T.ray3, 0.9);
        drawRay(ctx, lx, ly, img_x, img_ty, T.virtualExt, true, 0.4);
    }

    // ── Ray 3: Through/toward F' → parallel after lens ─
    if (Math.abs(result.f) < 1000) {
        if (isReal) {
            // Incoming: from obj tip toward F' on object side
            var slope = (ly - obj_ty) / (F2x - obj_x);
            var lensY = obj_ty + slope * (lx - obj_x);
            drawRay(ctx, obj_x, obj_ty, lx, lensY, T.ray2, false, 0.9);
            midArrow(ctx, obj_x, obj_ty, lx, lensY, 0.5, T.ray2, 0.9);
            // Outgoing: to image
            drawRay(ctx, lx, lensY, img_x, img_ty, T.ray2, false, 0.9);
            midArrow(ctx, lx, lensY, img_x, img_ty, 0.5, T.ray2, 0.9);
        } else {
            // Aimed toward F' (on opposite side) → exits parallel
            var r2t = (lx - obj_x) / (F1x - obj_x);
            var r2LensY = obj_ty + r2t * (ly - obj_ty);
            drawRay(ctx, obj_x, obj_ty, lx, r2LensY, T.ray2, false, 0.9);
            midArrow(ctx, obj_x, obj_ty, lx, r2LensY, 0.5, T.ray2, 0.9);
            // Exits parallel (horizontal)
            var r2ex = extendRay(ctx, lx, r2LensY, 1, 0);
            drawRay(ctx, lx, r2LensY, r2ex[0], r2LensY, T.ray2, false, 0.9);
            midArrow(ctx, lx, r2LensY, r2ex[0], r2LensY, 0.5, T.ray2, 0.9);
            drawRay(ctx, lx, r2LensY, img_x, r2LensY, T.virtualExt, true, 0.4);
        }
    }
}

// ==================== Export ====================

window.LensMirrorRender = {
    fmt: fmt,
    renderKaTeX: renderKaTeX,
    renderResults: renderResults,
    renderSteps: renderSteps,
    drawRayDiagram: drawRayDiagram
};

})();
