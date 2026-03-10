/**
 * Lens Calculator - Lens Maker + Combined Lenses + Double Lens System
 * ES5-compatible IIFE, Canvas diagrams with dark-mode support
 */
(function() {
'use strict';

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function val(id, fallback) {
    var el = $(id);
    if (!el) return fallback || 0;
    return parseFloat(el.value) || fallback || 0;
}

function setInput(id, v) {
    var el = $(id);
    if (el) el.value = v;
}

function isDark() {
    return document.documentElement.getAttribute('data-theme') === 'dark';
}

function themeColor(light, dark) {
    return isDark() ? dark : light;
}

// ==================== State ====================

var state = {
    mode: 'lensmaker',   // lensmaker | combined | doublelens
    lastResult: null
};

// ==================== Calculation: Lens Maker ====================

function calcLensMaker() {
    var mu = val('lc-mu', 1.5);
    var muMedium = val('lc-medium-mu', 1);
    var R1 = val('lc-r1', 20);
    var R2 = val('lc-r2', -20);
    var thickToggle = $('lc-thick-toggle');
    var isThick = thickToggle && thickToggle.checked;
    var t = isThick ? val('lc-thickness', 1) : 0;

    var result = {};

    if (Math.abs(muMedium) < 0.01) {
        result.error = 'Medium refractive index cannot be zero';
        return result;
    }

    var muRel = mu / muMedium;

    // Handle plano surfaces (R = infinity → 1/R = 0)
    var invR1 = (Math.abs(R1) > 90000) ? 0 : 1 / R1;
    var invR2 = (Math.abs(R2) > 90000) ? 0 : 1 / R2;

    var oneOverF;
    if (isThick && t > 0 && Math.abs(R1) < 90000 && Math.abs(R2) < 90000) {
        // Thick lens: 1/f = (μ-1)[1/R1 - 1/R2 + (μ-1)t/(μ·R1·R2)]
        oneOverF = (muRel - 1) * (invR1 - invR2 + (muRel - 1) * t / (muRel * R1 * R2));
    } else {
        oneOverF = (muRel - 1) * (invR1 - invR2);
    }

    if (Math.abs(oneOverF) < 0.00001) {
        result.error = 'Focal length approaches infinity (flat glass or invalid radii)';
        return result;
    }

    var f = 1 / oneOverF;
    var P = 100 / f;  // f in cm → P in diopters

    result.mode = 'lensmaker';
    result.mu = mu;
    result.muMedium = muMedium;
    result.muRel = muRel;
    result.R1 = R1;
    result.R2 = R2;
    result.invR1 = invR1;
    result.invR2 = invR2;
    result.f = f;
    result.P = P;
    result.isConverging = f > 0;
    result.oneOverF = oneOverF;
    result.isThick = isThick;
    result.t = t;

    return result;
}

// ==================== Calculation: Combined Lenses ====================

function calcCombined() {
    var f1 = val('lc-f1', 10);
    var f2 = val('lc-f2', 15);
    var d = val('lc-separation', 0);

    var result = {};

    if (Math.abs(f1) < 0.001 || Math.abs(f2) < 0.001) {
        result.error = 'Focal lengths cannot be zero';
        return result;
    }

    var oneOverF;
    if (d === 0) {
        oneOverF = 1/f1 + 1/f2;
    } else {
        oneOverF = 1/f1 + 1/f2 - d/(f1 * f2);
    }

    if (Math.abs(oneOverF) < 0.00001) {
        result.error = 'Equivalent focal length approaches infinity';
        return result;
    }

    var F = 1 / oneOverF;
    var P1 = 100 / f1;
    var P2 = 100 / f2;
    var P = 100 / F;

    // Back Focal Distance (BFD) and Front Focal Distance (FFD) for separated lenses
    var BFD = 0, FFD = 0;
    if (d > 0) {
        // BFD = F * (1 - d/f1)  measured from lens 2
        BFD = F * (1 - d / f1);
        // FFD = F * (1 - d/f2)  measured from lens 1
        FFD = F * (1 - d / f2);
    } else {
        BFD = F;
        FFD = F;
    }

    result.mode = 'combined';
    result.f1 = f1;
    result.f2 = f2;
    result.d = d;
    result.F = F;
    result.P1 = P1;
    result.P2 = P2;
    result.P = P;
    result.oneOverF = oneOverF;
    result.isConverging = F > 0;
    result.inContact = d === 0;
    result.BFD = BFD;
    result.FFD = FFD;

    return result;
}

// ==================== Calculation: Double Lens System ====================

function calcDoubleLens() {
    var f1 = val('lc-dl-f1', 10);
    var f2 = val('lc-dl-f2', 15);
    var d = val('lc-dl-d', 25);
    var u1 = val('lc-dl-u', 25);
    var h = val('lc-dl-h', 5);

    var result = {};

    if (Math.abs(f1) < 0.001 || Math.abs(f2) < 0.001) {
        result.error = 'Focal lengths cannot be zero';
        return result;
    }
    if (Math.abs(u1) < 0.001) {
        result.error = 'Object distance cannot be zero';
        return result;
    }

    // Lens 1: 1/v1 = 1/f1 - 1/u1 (sign: u1 negative in New Cartesian)
    // Using Real-is-Positive: 1/v1 = 1/f1 + 1/u1 ... actually no.
    // Let's use New Cartesian consistently: u is negative, 1/f = 1/v + 1/u
    // So 1/v = 1/f - 1/u ... wait. 1/f = 1/v + 1/u → 1/v = 1/f - 1/u
    // With u negative: 1/v = 1/f - 1/(-|u|) = 1/f + 1/|u|
    // That gives positive v for real image beyond lens.

    // Using convention: u1 is entered as positive, internally we treat as -u1
    var u1_signed = -Math.abs(u1); // object on left, negative
    var inv_v1 = (1/f1) - (1/u1_signed); // 1/v1 = 1/f1 - 1/u1
    // = 1/f1 + 1/|u1|

    if (Math.abs(inv_v1) < 0.00001) {
        result.error = 'Image from Lens 1 at infinity (object at focal point)';
        return result;
    }

    var v1 = 1 / inv_v1;
    var m1 = v1 / u1_signed;

    // Object for Lens 2
    // v1 is measured from Lens 1. Lens 2 is at distance d from Lens 1.
    // u2 = -(d - v1) if v1 < d → real object for L2
    // u2 = -(d - v1) if v1 > d → this gives positive u2 = virtual object
    var u2 = -(d - v1);

    if (Math.abs(u2) < 0.001) {
        result.error = 'Intermediate image forms exactly at Lens 2';
        return result;
    }

    var inv_v2 = (1/f2) - (1/u2);

    if (Math.abs(inv_v2) < 0.00001) {
        result.error = 'Final image at infinity';
        return result;
    }

    var v2 = 1 / inv_v2;
    var m2 = v2 / u2;
    var mTotal = m1 * m2;
    var hPrime = mTotal * h;

    // Intermediate image height
    var h1 = m1 * h;

    result.mode = 'doublelens';
    result.f1 = f1;
    result.f2 = f2;
    result.d = d;
    result.u1 = u1;
    result.u1_signed = u1_signed;
    result.v1 = v1;
    result.m1 = m1;
    result.u2 = u2;
    result.v2 = v2;
    result.m2 = m2;
    result.mTotal = mTotal;
    result.h = h;
    result.h1 = h1;
    result.hPrime = hPrime;
    result.img1Real = v1 > 0;
    result.img2Real = v2 > 0;
    result.img1Inverted = m1 < 0;
    result.img2Inverted = mTotal < 0;
    result.isMagnified = Math.abs(mTotal) > 1;

    return result;
}

// ==================== Main Calculate ====================

function calculate() {
    var result;
    if (state.mode === 'lensmaker') {
        result = calcLensMaker();
    } else if (state.mode === 'combined') {
        result = calcCombined();
    } else {
        result = calcDoubleLens();
    }

    state.lastResult = result;
    showOutput(result);
}

// ==================== Show Output ====================

function showOutput(result) {
    var empty = $('lc-empty-state');
    if (empty) empty.style.display = 'none';

    var canvas = $('lc-diagram');
    if (canvas) drawDiagram(canvas, result);

    renderResults($('lc-results-container'), result);
    renderSteps($('lc-steps-container'), result);
}

// ==================== Render Results ====================

function renderResults(container, result) {
    if (!container) return;
    if (result.error) {
        container.innerHTML = '<div class="lc-error">' + result.error + '</div>';
        return;
    }

    var html = '';

    if (result.mode === 'lensmaker') {
        html += '<div class="lc-badges">';
        html += '<span class="lc-badge ' + (result.isConverging ? 'lc-badge-converging' : 'lc-badge-diverging') + '">' + (result.isConverging ? 'Converging' : 'Diverging') + '</span>';
        html += '<span class="lc-badge">&mu; = ' + result.mu.toFixed(2) + '</span>';
        if (result.muMedium !== 1) html += '<span class="lc-badge">Medium &mu; = ' + result.muMedium.toFixed(2) + '</span>';
        if (result.isThick) html += '<span class="lc-badge">Thick Lens (t=' + result.t + ' cm)</span>';
        html += '</div>';

        html += '<div class="lc-results-grid">';
        html += resultCard('Focal Length', fmtLen(result.f));
        html += resultCard('Power', fmtPower(result.P));
        html += resultCard('R\u2081', fmtRadius(result.R1));
        html += resultCard('R\u2082', fmtRadius(result.R2));
        if (result.isThick) html += resultCard('Thickness', result.t + ' cm');
        html += resultCard('\u03BC (relative)', result.muRel.toFixed(4));
        html += '</div>';
    }

    else if (result.mode === 'combined') {
        html += '<div class="lc-badges">';
        html += '<span class="lc-badge ' + (result.isConverging ? 'lc-badge-converging' : 'lc-badge-diverging') + '">' + (result.isConverging ? 'Converging' : 'Diverging') + ' System</span>';
        html += '<span class="lc-badge ' + (result.inContact ? 'lc-badge-contact' : 'lc-badge-separated') + '">' + (result.inContact ? 'In Contact' : 'Separated d=' + result.d + ' cm') + '</span>';
        html += '</div>';

        html += '<div class="lc-results-grid">';
        html += resultCard('Equivalent f', fmtLen(result.F));
        html += resultCard('Total Power', fmtPower(result.P));
        html += resultCard('f\u2081', fmtLen(result.f1));
        html += resultCard('f\u2082', fmtLen(result.f2));
        if (!result.inContact) {
            html += resultCard('Back Focal Dist', fmtLen(result.BFD));
            html += resultCard('Front Focal Dist', fmtLen(result.FFD));
        }
        html += resultCard('P\u2081', fmtPower(result.P1));
        html += resultCard('P\u2082', fmtPower(result.P2));
        html += '</div>';
    }

    else if (result.mode === 'doublelens') {
        html += '<div class="lc-badges">';
        html += '<span class="lc-badge ' + (result.img2Real ? 'lc-badge-converging' : 'lc-badge-diverging') + '">Final: ' + (result.img2Real ? 'Real' : 'Virtual') + '</span>';
        html += '<span class="lc-badge">' + (result.img2Inverted ? 'Inverted' : 'Upright') + '</span>';
        html += '<span class="lc-badge">' + (result.isMagnified ? 'Magnified' : 'Diminished') + '</span>';
        html += '<span class="lc-badge ' + (result.img1Real ? 'lc-badge-converging' : 'lc-badge-diverging') + '">Intermediate: ' + (result.img1Real ? 'Real' : 'Virtual') + '</span>';
        html += '</div>';

        html += '<div class="lc-results-grid">';
        html += resultCard('v\u2081 (Lens 1)', fmtLen(result.v1));
        html += resultCard('v\u2082 (Lens 2)', fmtLen(result.v2));
        html += resultCard('m\u2081', fmtMag(result.m1));
        html += resultCard('m\u2082', fmtMag(result.m2));
        html += resultCard('Total m', fmtMag(result.mTotal));
        html += resultCard('Final Height', fmtLen(result.hPrime));
        html += resultCard('u\u2082 (for L2)', fmtLen(result.u2));
        html += resultCard('Intermediate h\u2032', fmtLen(result.h1));
        html += '</div>';
    }

    container.innerHTML = html;
}

function resultCard(label, value) {
    return '<div class="lc-result-card"><div class="lc-result-label">' + label + '</div><div class="lc-result-value">' + value + '</div></div>';
}

// ==================== Format Helpers ====================

function fmtLen(v) {
    if (!isFinite(v)) return '\u221E';
    return v.toFixed(2) + ' cm';
}

function fmtRadius(v) {
    if (Math.abs(v) > 90000) return '\u221E (flat)';
    return v.toFixed(2) + ' cm';
}

function fmtPower(P) {
    if (!isFinite(P)) return '\u221E D';
    return (P >= 0 ? '+' : '') + P.toFixed(2) + ' D';
}

function fmtMag(m) {
    if (!isFinite(m)) return '\u221E';
    return (m >= 0 ? '+' : '') + m.toFixed(3) + '\u00D7';
}

// ==================== Render Steps ====================

function renderSteps(container, result) {
    if (!container) return;
    if (result.error) { container.innerHTML = ''; return; }

    var html = '';
    var n = 1;

    if (result.mode === 'lensmaker') {
        html += step(n++, 'Given Values',
            'Refractive index of lens: <strong>\u03BC\u2081 = ' + result.mu + '</strong><br>' +
            'Refractive index of medium: <strong>\u03BC\u2082 = ' + result.muMedium + '</strong><br>' +
            'Radius R\u2081 = <strong>' + fmtRadius(result.R1) + '</strong><br>' +
            'Radius R\u2082 = <strong>' + fmtRadius(result.R2) + '</strong>');

        if (result.muMedium !== 1) {
            html += step(n++, 'Relative Refractive Index',
                '\u03BC_rel = \u03BC\u2081 / \u03BC\u2082 = ' + result.mu + ' / ' + result.muMedium + '<br>' +
                '<strong>\u03BC_rel = ' + result.muRel.toFixed(4) + '</strong>');
        }

        if (result.isThick) {
            html += step(n++, 'Apply Thick Lens Maker\u2019s Formula',
                '<div class="lc-step-math" id="lc-katex-lm"></div>' +
                '1/f = (\u03BC\u22121)[1/R\u2081 \u2212 1/R\u2082 + (\u03BC\u22121)t/(\u03BC\u00B7R\u2081\u00B7R\u2082)]<br>' +
                'Thickness correction: (\u03BC\u22121)t/(\u03BC\u00B7R\u2081\u00B7R\u2082) = ' +
                ((result.muRel - 1) * result.t / (result.muRel * result.R1 * result.R2)).toFixed(6) + '<br>' +
                '1/f = ' + (result.muRel - 1).toFixed(4) + ' \u00D7 [' + result.invR1.toFixed(6) + ' \u2212 ' + result.invR2.toFixed(6) + ' + ' +
                ((result.muRel - 1) * result.t / (result.muRel * result.R1 * result.R2)).toFixed(6) + ']<br>' +
                '1/f = <strong>' + result.oneOverF.toFixed(6) + '</strong>');
        } else {
            html += step(n++, 'Apply Lens Maker\u2019s Formula',
                '<div class="lc-step-math" id="lc-katex-lm"></div>' +
                '1/f = (\u03BC - 1)(1/R\u2081 \u2212 1/R\u2082)<br>' +
                '1/f = (' + result.muRel.toFixed(4) + ' \u2212 1)(' + result.invR1.toFixed(6) + ' \u2212 ' + result.invR2.toFixed(6) + ')<br>' +
                '1/f = ' + (result.muRel - 1).toFixed(4) + ' \u00D7 ' + (result.invR1 - result.invR2).toFixed(6) + '<br>' +
                '1/f = <strong>' + result.oneOverF.toFixed(6) + '</strong>');
        }

        html += step(n++, 'Focal Length',
            'f = 1 / ' + result.oneOverF.toFixed(6) + '<br>' +
            '<strong>f = ' + fmtLen(result.f) + '</strong>');

        html += step(n++, 'Power in Diopters',
            'P = 100 / f (cm) = 100 / ' + result.f.toFixed(2) + '<br>' +
            '<strong>P = ' + fmtPower(result.P) + '</strong>');

        html += step(n++, 'Lens Classification',
            result.isConverging
                ? '<strong style="color:#1e40af;">Converging Lens (f &gt; 0)</strong><br>Brings parallel rays to a real focus.'
                : '<strong style="color:#92400e;">Diverging Lens (f &lt; 0)</strong><br>Spreads parallel rays; virtual focus.');
    }

    else if (result.mode === 'combined') {
        html += step(n++, 'Given Values',
            'f\u2081 = <strong>' + fmtLen(result.f1) + '</strong> (P\u2081 = ' + fmtPower(result.P1) + ')<br>' +
            'f\u2082 = <strong>' + fmtLen(result.f2) + '</strong> (P\u2082 = ' + fmtPower(result.P2) + ')<br>' +
            'Separation d = <strong>' + result.d + ' cm</strong>' + (result.inContact ? ' (in contact)' : ''));

        if (result.inContact) {
            html += step(n++, 'Lenses in Contact Formula',
                '1/F = 1/f\u2081 + 1/f\u2082<br>' +
                '1/F = 1/' + result.f1 + ' + 1/' + result.f2 + '<br>' +
                '1/F = ' + (1/result.f1).toFixed(6) + ' + ' + (1/result.f2).toFixed(6) + '<br>' +
                '1/F = <strong>' + result.oneOverF.toFixed(6) + '</strong>');

            html += step(n++, 'Equivalent Power',
                'P = P\u2081 + P\u2082<br>' +
                'P = ' + fmtPower(result.P1) + ' + ' + fmtPower(result.P2) + '<br>' +
                '<strong>P = ' + fmtPower(result.P) + '</strong>');
        } else {
            html += step(n++, 'Separated Lenses Formula',
                '1/F = 1/f\u2081 + 1/f\u2082 \u2212 d/(f\u2081\u00B7f\u2082)<br>' +
                '1/F = 1/' + result.f1 + ' + 1/' + result.f2 + ' \u2212 ' + result.d + '/(' + result.f1 + '\u00D7' + result.f2 + ')<br>' +
                '1/F = ' + (1/result.f1).toFixed(6) + ' + ' + (1/result.f2).toFixed(6) + ' \u2212 ' + (result.d/(result.f1*result.f2)).toFixed(6) + '<br>' +
                '1/F = <strong>' + result.oneOverF.toFixed(6) + '</strong>');

            html += step(n++, 'Equivalent Power',
                'P = P\u2081 + P\u2082 \u2212 d\u00B7P\u2081\u00B7P\u2082/100<br>' +
                'P = ' + result.P1.toFixed(2) + ' + ' + result.P2.toFixed(2) + ' \u2212 ' + (result.d * result.P1 * result.P2 / 100).toFixed(4) + '<br>' +
                '<strong>P = ' + fmtPower(result.P) + '</strong>');
        }

        html += step(n++, 'Equivalent Focal Length',
            'F = 1 / ' + result.oneOverF.toFixed(6) + '<br>' +
            '<strong>F = ' + fmtLen(result.F) + '</strong>');

        if (!result.inContact) {
            html += step(n++, 'Back & Front Focal Distance',
                'BFD = F(1 \u2212 d/f\u2081) = ' + result.F.toFixed(2) + '(1 \u2212 ' + result.d + '/' + result.f1 + ')<br>' +
                '<strong>BFD = ' + fmtLen(result.BFD) + '</strong> (from Lens 2)<br><br>' +
                'FFD = F(1 \u2212 d/f\u2082) = ' + result.F.toFixed(2) + '(1 \u2212 ' + result.d + '/' + result.f2 + ')<br>' +
                '<strong>FFD = ' + fmtLen(result.FFD) + '</strong> (from Lens 1)');
        }

        html += step(n++, 'System Classification',
            'The combination acts as a <strong>' + (result.isConverging ? 'converging' : 'diverging') + '</strong> lens system.');
    }

    else if (result.mode === 'doublelens') {
        html += step(n++, 'Given Values',
            'Lens 1: f\u2081 = <strong>' + fmtLen(result.f1) + '</strong><br>' +
            'Lens 2: f\u2082 = <strong>' + fmtLen(result.f2) + '</strong><br>' +
            'Separation: d = <strong>' + result.d + ' cm</strong><br>' +
            'Object distance: u\u2081 = <strong>' + result.u1 + ' cm</strong> (from Lens 1)<br>' +
            'Object height: h = <strong>' + result.h + ' cm</strong>');

        html += step(n++, 'Image from Lens 1',
            'Using 1/f = 1/v + 1/u (New Cartesian, u = ' + result.u1_signed + ' cm):<br>' +
            '1/v\u2081 = 1/f\u2081 \u2212 1/u\u2081<br>' +
            '1/v\u2081 = 1/' + result.f1 + ' \u2212 1/(' + result.u1_signed.toFixed(2) + ')<br>' +
            '1/v\u2081 = ' + (1/result.f1).toFixed(6) + ' + ' + (1/result.u1).toFixed(6) + '<br>' +
            'v\u2081 = <strong>' + fmtLen(result.v1) + '</strong> (' + (result.img1Real ? 'Real' : 'Virtual') + ')<br>' +
            'm\u2081 = v\u2081/u\u2081 = ' + result.v1.toFixed(2) + '/' + result.u1_signed.toFixed(2) + ' = <strong>' + fmtMag(result.m1) + '</strong>');

        html += step(n++, 'Object for Lens 2',
            'u\u2082 = \u2212(d \u2212 v\u2081) = \u2212(' + result.d + ' \u2212 ' + result.v1.toFixed(2) + ')<br>' +
            'u\u2082 = <strong>' + fmtLen(result.u2) + '</strong><br>' +
            (result.u2 < 0 ? 'Negative \u2192 real object for Lens 2' : 'Positive \u2192 virtual object for Lens 2'));

        html += step(n++, 'Image from Lens 2',
            '1/v\u2082 = 1/f\u2082 \u2212 1/u\u2082<br>' +
            '1/v\u2082 = 1/' + result.f2 + ' \u2212 1/(' + result.u2.toFixed(2) + ')<br>' +
            'v\u2082 = <strong>' + fmtLen(result.v2) + '</strong> (' + (result.img2Real ? 'Real' : 'Virtual') + ')<br>' +
            'm\u2082 = v\u2082/u\u2082 = ' + result.v2.toFixed(2) + '/' + result.u2.toFixed(2) + ' = <strong>' + fmtMag(result.m2) + '</strong>');

        html += step(n++, 'Total Magnification',
            'm_total = m\u2081 \u00D7 m\u2082 = ' + result.m1.toFixed(4) + ' \u00D7 ' + result.m2.toFixed(4) + '<br>' +
            '<strong>m_total = ' + fmtMag(result.mTotal) + '</strong><br><br>' +
            'Final image height: h\u2032 = m \u00D7 h = ' + result.mTotal.toFixed(4) + ' \u00D7 ' + result.h + '<br>' +
            '<strong>h\u2032 = ' + fmtLen(result.hPrime) + '</strong>');

        html += step(n++, 'Image Properties',
            '<strong>Nature:</strong> ' + (result.img2Real ? 'Real (can be projected)' : 'Virtual (cannot be projected)') + '<br>' +
            '<strong>Orientation:</strong> ' + (result.img2Inverted ? 'Inverted' : 'Upright') + '<br>' +
            '<strong>Size:</strong> ' + (Math.abs(Math.abs(result.mTotal) - 1) < 0.01 ? 'Same size' : (result.isMagnified ? 'Magnified (|m| > 1)' : 'Diminished (|m| < 1)')));
    }

    container.innerHTML = html;

    // Render KaTeX if available
    if (result.mode === 'lensmaker' && window.katex) {
        var katexEl = $('lc-katex-lm');
        if (katexEl) {
            try {
                var formula = result.isThick
                    ? '\\frac{1}{f} = (\\mu-1)\\left[\\frac{1}{R_1} - \\frac{1}{R_2} + \\frac{(\\mu-1)\\,t}{\\mu\\,R_1\\,R_2}\\right]'
                    : '\\frac{1}{f} = \\left(\\frac{\\mu_1}{\\mu_2} - 1\\right)\\left(\\frac{1}{R_1} - \\frac{1}{R_2}\\right)';
                window.katex.render(formula, katexEl, { displayMode: true });
            } catch(e) { /* ignore */ }
        }
    }
}

function step(num, title, body) {
    return '<div class="lc-step">' +
        '<div class="lc-step-number">' + num + '</div>' +
        '<div class="lc-step-content">' +
            '<div class="lc-step-desc"><strong>' + title + '</strong></div>' +
            '<div style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.7;">' + body + '</div>' +
        '</div></div>';
}

// ==================== Drawing ====================

function drawDiagram(canvas, result) {
    var ctx = canvas.getContext('2d');
    var W = canvas.width;
    var H = canvas.height;

    // Background
    var bg = themeColor('#fafbff', '#0c1220');
    ctx.fillStyle = bg;
    ctx.fillRect(0, 0, W, H);

    // Grid
    drawGrid(ctx, W, H);

    if (result.error) {
        ctx.font = '14px Inter, sans-serif';
        ctx.fillStyle = themeColor('#991b1b', '#fca5a5');
        ctx.textAlign = 'center';
        ctx.fillText(result.error, W/2, H/2);
        return;
    }

    if (result.mode === 'lensmaker') {
        drawLensMakerDiagram(ctx, W, H, result);
    } else if (result.mode === 'combined') {
        drawCombinedDiagram(ctx, W, H, result);
    } else {
        drawDoubleLensDiagram(ctx, W, H, result);
    }
}

function drawGrid(ctx, W, H) {
    ctx.strokeStyle = themeColor('rgba(0,0,0,0.04)', 'rgba(255,255,255,0.04)');
    ctx.lineWidth = 1;
    var step = 30;
    for (var x = step; x < W; x += step) {
        ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, H); ctx.stroke();
    }
    for (var y = step; y < H; y += step) {
        ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(W, y); ctx.stroke();
    }
}

function drawAxis(ctx, W, H) {
    var cy = H / 2;
    ctx.strokeStyle = themeColor('rgba(0,0,0,0.15)', 'rgba(255,255,255,0.15)');
    ctx.lineWidth = 1;
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(10, cy);
    ctx.lineTo(W - 10, cy);
    ctx.stroke();
    ctx.setLineDash([]);
}

function drawLensShape(ctx, cx, cy, lh, f, isConverging) {
    var lw = 12;
    ctx.strokeStyle = themeColor('#6366f1', '#818cf8');
    ctx.lineWidth = 3;
    ctx.fillStyle = themeColor('rgba(99,102,241,0.1)', 'rgba(99,102,241,0.15)');

    ctx.beginPath();
    if (isConverging) {
        // Biconvex
        ctx.moveTo(cx - 3, cy - lh/2);
        ctx.quadraticCurveTo(cx + lw, cy, cx - 3, cy + lh/2);
        ctx.quadraticCurveTo(cx - lw, cy, cx - 3, cy - lh/2);
    } else {
        // Biconcave
        ctx.moveTo(cx - lw * 0.7, cy - lh/2);
        ctx.quadraticCurveTo(cx + lw * 0.3, cy, cx - lw * 0.7, cy + lh/2);
        ctx.lineTo(cx + lw * 0.7, cy + lh/2);
        ctx.quadraticCurveTo(cx - lw * 0.3, cy, cx + lw * 0.7, cy - lh/2);
        ctx.closePath();
    }
    ctx.fill();
    ctx.stroke();

    // Arrows at tips
    ctx.fillStyle = themeColor('#6366f1', '#818cf8');
    ctx.beginPath();
    ctx.moveTo(cx, cy - lh/2 - 6);
    ctx.lineTo(cx - 4, cy - lh/2);
    ctx.lineTo(cx + 4, cy - lh/2);
    ctx.closePath();
    ctx.fill();
    ctx.beginPath();
    ctx.moveTo(cx, cy + lh/2 + 6);
    ctx.lineTo(cx - 4, cy + lh/2);
    ctx.lineTo(cx + 4, cy + lh/2);
    ctx.closePath();
    ctx.fill();
}

// ===== Lens Maker Diagram =====
function drawLensMakerDiagram(ctx, W, H, result) {
    drawAxis(ctx, W, H);
    var cx = W / 2;
    var cy = H / 2;
    var lh = Math.min(H - 80, 160);

    // Draw lens based on R1, R2
    var R1 = result.R1;
    var R2 = result.R2;
    var isPlano1 = Math.abs(R1) > 90000;
    var isPlano2 = Math.abs(R2) > 90000;
    var lw = 18;

    ctx.fillStyle = themeColor('rgba(99,102,241,0.12)', 'rgba(99,102,241,0.2)');
    ctx.strokeStyle = themeColor('#6366f1', '#818cf8');
    ctx.lineWidth = 3;

    ctx.beginPath();
    // Left surface
    if (isPlano1) {
        ctx.moveTo(cx - lw/2, cy - lh/2);
        ctx.lineTo(cx - lw/2, cy + lh/2);
    } else if (R1 > 0) {
        ctx.moveTo(cx - lw/2, cy - lh/2);
        ctx.quadraticCurveTo(cx + lw * 0.8, cy, cx - lw/2, cy + lh/2);
    } else {
        ctx.moveTo(cx - lw/2, cy - lh/2);
        ctx.quadraticCurveTo(cx - lw * 1.5, cy, cx - lw/2, cy + lh/2);
    }
    // Right surface
    if (isPlano2) {
        ctx.lineTo(cx + lw/2, cy + lh/2);
        ctx.lineTo(cx + lw/2, cy - lh/2);
    } else if (R2 < 0) {
        ctx.lineTo(cx + lw/2, cy + lh/2);
        ctx.quadraticCurveTo(cx + lw * 1.5, cy, cx + lw/2, cy - lh/2);
    } else {
        ctx.lineTo(cx + lw/2, cy + lh/2);
        ctx.quadraticCurveTo(cx - lw * 0.8, cy, cx + lw/2, cy - lh/2);
    }
    ctx.closePath();
    ctx.fill();
    ctx.stroke();

    // Mu label inside lens
    ctx.font = 'bold 14px Inter, sans-serif';
    ctx.fillStyle = themeColor('#6366f1', '#a5b4fc');
    ctx.textAlign = 'center';
    ctx.fillText('\u03BC = ' + result.mu.toFixed(2), cx, cy + 5);

    // R1, R2 labels
    ctx.font = '11px Inter, sans-serif';
    ctx.fillStyle = themeColor('#64748b', '#94a3b8');
    var lbl1 = 'R\u2081 = ' + fmtRadius(result.R1);
    var lbl2 = 'R\u2082 = ' + fmtRadius(result.R2);
    ctx.textAlign = 'right';
    ctx.fillText(lbl1, cx - lw - 15, cy - lh/3);
    ctx.textAlign = 'left';
    ctx.fillText(lbl2, cx + lw + 15, cy + lh/3);

    // Leader lines
    ctx.strokeStyle = themeColor('#94a3b8', '#64748b');
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(cx - lw/2, cy - lh/4);
    ctx.lineTo(cx - lw - 12, cy - lh/3);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(cx + lw/2, cy + lh/4);
    ctx.lineTo(cx + lw + 12, cy + lh/3);
    ctx.stroke();

    // Focal length result
    ctx.font = 'bold 14px Inter, sans-serif';
    ctx.fillStyle = result.isConverging ? themeColor('#059669', '#34d399') : themeColor('#ea580c', '#fb923c');
    ctx.textAlign = 'center';
    ctx.fillText('f = ' + result.f.toFixed(2) + ' cm', cx, H - 30);
    ctx.font = '11px Inter, sans-serif';
    ctx.fillStyle = themeColor('#64748b', '#94a3b8');
    ctx.fillText(result.isConverging ? '(Converging)' : '(Diverging)', cx, H - 14);

    // Draw focal point markers if finite
    if (isFinite(result.f) && Math.abs(result.f) < 500) {
        var scale = Math.min((W - 100) / (Math.abs(result.f) * 2.5), 3);
        var fx = Math.abs(result.f) * scale;
        var f1x = Math.max(30, cx - fx);
        var f2x = Math.min(W - 30, cx + fx);

        ctx.fillStyle = themeColor('#dc2626', '#f87171');
        ctx.beginPath(); ctx.arc(f1x, cy, 4, 0, Math.PI * 2); ctx.fill();
        ctx.beginPath(); ctx.arc(f2x, cy, 4, 0, Math.PI * 2); ctx.fill();
        ctx.font = 'bold 10px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('F', f1x, cy + 16);
        ctx.fillText("F'", f2x, cy + 16);
    }
}

// ===== Combined Lenses Diagram =====
function drawCombinedDiagram(ctx, W, H, result) {
    drawAxis(ctx, W, H);
    var cy = H / 2;
    var lh = Math.min(H - 100, 120);

    var separation = result.d === 0 ? 30 : Math.min(result.d * 2, (W - 160) * 0.4);
    var cx1 = W / 2 - separation / 2;
    var cx2 = W / 2 + separation / 2;

    // Draw lens 1
    drawLensShape(ctx, cx1, cy, lh, result.f1, result.f1 > 0);
    // Draw lens 2
    ctx.save();
    var oldStroke = ctx.strokeStyle;
    drawLensShape(ctx, cx2, cy, lh, result.f2, result.f2 > 0);
    ctx.restore();

    // Color-code lens 2 differently
    ctx.strokeStyle = themeColor('#f59e0b', '#fbbf24');
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(cx2, cy - lh/2 - 6, 0.1, 0, 0); // tiny invisible arc to reset path
    ctx.stroke();

    // Labels
    ctx.font = 'bold 11px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillStyle = themeColor('#6366f1', '#818cf8');
    ctx.fillText('f\u2081 = ' + result.f1 + ' cm', cx1, cy + lh/2 + 22);
    ctx.fillStyle = themeColor('#f59e0b', '#fbbf24');
    ctx.fillText('f\u2082 = ' + result.f2 + ' cm', cx2, cy + lh/2 + 22);

    // Separation indicator
    if (result.d > 0) {
        var sepY = cy + lh/2 + 38;
        ctx.strokeStyle = themeColor('#64748b', '#94a3b8');
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(cx1, sepY); ctx.lineTo(cx2, sepY); ctx.stroke();
        // Arrowheads
        ctx.beginPath(); ctx.moveTo(cx1+5, sepY-3); ctx.lineTo(cx1, sepY); ctx.lineTo(cx1+5, sepY+3); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(cx2-5, sepY-3); ctx.lineTo(cx2, sepY); ctx.lineTo(cx2-5, sepY+3); ctx.stroke();
        ctx.font = '10px Inter, sans-serif';
        ctx.fillStyle = themeColor('#64748b', '#94a3b8');
        ctx.fillText('d = ' + result.d + ' cm', (cx1+cx2)/2, sepY + 14);
    } else {
        ctx.font = '10px Inter, sans-serif';
        ctx.fillStyle = themeColor('#64748b', '#94a3b8');
        ctx.fillText('(in contact)', (cx1+cx2)/2, cy + lh/2 + 38);
    }

    // Result at top
    ctx.font = 'bold 14px Inter, sans-serif';
    ctx.fillStyle = result.isConverging ? themeColor('#059669', '#34d399') : themeColor('#ea580c', '#fb923c');
    ctx.fillText('F = ' + result.F.toFixed(2) + ' cm  |  P = ' + fmtPower(result.P), W/2, 28);
    ctx.font = '11px Inter, sans-serif';
    ctx.fillStyle = themeColor('#64748b', '#94a3b8');
    ctx.fillText(result.isConverging ? '(Converging system)' : '(Diverging system)', W/2, 44);
}

// ===== Double Lens System Diagram =====
function drawDoubleLensDiagram(ctx, W, H, result) {
    drawAxis(ctx, W, H);
    var cy = H / 2;
    var padding = 60;
    var lh = Math.min(H - 100, 100);

    // Layout: [obj] ---- [L1] ---- d ---- [L2] ---- [img]
    var absU1 = Math.abs(result.u1);
    var absV1 = Math.abs(result.v1);
    var absV2 = Math.abs(result.v2);
    var d = result.d;

    // Total horizontal span: u1 + d + |v2| (or more if v2 is behind L2)
    var leftSpan = absU1;
    var rightSpan = d + Math.max(absV2, 0);
    var totalSpan = leftSpan + rightSpan;

    if (totalSpan < 1) totalSpan = 100;

    var availW = W - padding * 2;
    var scale = Math.min(availW / totalSpan, 4);
    scale = Math.max(scale, 0.5);

    var L1x = padding + leftSpan * scale;
    L1x = Math.max(padding + 40, Math.min(W - padding - 80, L1x));
    var L2x = L1x + d * scale;
    L2x = Math.max(L1x + 30, Math.min(W - padding - 40, L2x));

    // Object
    var objX = Math.max(padding, L1x - absU1 * scale);
    var maxArrowH = (H / 2) - 30;
    var objH = Math.min(Math.abs(result.h) * scale * 1.5, maxArrowH, 50);

    // Draw lenses
    drawLensShape(ctx, L1x, cy, lh, result.f1, result.f1 > 0);

    // Save and draw L2 with different color
    var saveStroke = themeColor('#6366f1', '#818cf8');
    drawLensShape(ctx, L2x, cy, lh, result.f2, result.f2 > 0);

    // Labels for lenses
    ctx.font = '9px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillStyle = themeColor('#6366f1', '#a5b4fc');
    ctx.fillText('L\u2081 (f=' + result.f1 + ')', L1x, cy + lh/2 + 16);
    ctx.fillText('L\u2082 (f=' + result.f2 + ')', L2x, cy + lh/2 + 16);

    // Draw object arrow
    ctx.strokeStyle = themeColor('#2563eb', '#60a5fa');
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    ctx.moveTo(objX, cy);
    ctx.lineTo(objX, cy - objH);
    ctx.stroke();
    ctx.fillStyle = themeColor('#2563eb', '#60a5fa');
    ctx.beginPath();
    ctx.moveTo(objX, cy - objH - 5);
    ctx.lineTo(objX - 4, cy - objH);
    ctx.lineTo(objX + 4, cy - objH);
    ctx.closePath();
    ctx.fill();
    ctx.font = '9px Inter, sans-serif';
    ctx.fillText('Object', objX, cy + 12);

    // Intermediate image
    var img1H = Math.min(Math.abs(result.m1) * objH, maxArrowH, 50);
    var img1Dir = result.m1 < 0 ? 1 : -1; // inverted goes below axis
    var img1X;
    if (result.v1 > 0) {
        img1X = L1x + result.v1 * scale;
    } else {
        img1X = L1x + result.v1 * scale; // virtual: left of L1
    }
    img1X = Math.max(padding, Math.min(W - padding, img1X));

    // Draw intermediate image (dashed if virtual)
    if (!result.img1Real) ctx.setLineDash([4, 3]);
    ctx.strokeStyle = themeColor('#f59e0b', '#fbbf24');
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(img1X, cy);
    ctx.lineTo(img1X, cy - img1H * img1Dir);
    ctx.stroke();
    ctx.setLineDash([]);
    ctx.fillStyle = themeColor('#f59e0b', '#fbbf24');
    ctx.font = '8px Inter, sans-serif';
    ctx.fillText('I\u2081', img1X, cy + 12);

    // Final image
    var img2H = Math.min(Math.abs(result.mTotal) * objH, maxArrowH, 60);
    var img2Dir = result.mTotal < 0 ? 1 : -1;
    var img2X;
    if (result.v2 > 0) {
        img2X = L2x + result.v2 * scale;
    } else {
        img2X = L2x + result.v2 * scale;
    }
    img2X = Math.max(padding, Math.min(W - padding, img2X));

    if (!result.img2Real) ctx.setLineDash([4, 3]);
    ctx.strokeStyle = themeColor('#059669', '#34d399');
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    ctx.moveTo(img2X, cy);
    ctx.lineTo(img2X, cy - img2H * img2Dir);
    ctx.stroke();
    ctx.setLineDash([]);
    ctx.fillStyle = themeColor('#059669', '#34d399');
    ctx.beginPath();
    var tip2Y = cy - img2H * img2Dir;
    ctx.moveTo(img2X, tip2Y + (img2Dir > 0 ? -5 : 5));
    ctx.lineTo(img2X - 4, tip2Y);
    ctx.lineTo(img2X + 4, tip2Y);
    ctx.closePath();
    ctx.fill();
    ctx.font = '9px Inter, sans-serif';
    ctx.fillText(result.img2Real ? 'Final Image' : 'Final (Virtual)', img2X, cy + 12);

    // Draw rays through system (simplified: 2 rays)
    ctx.lineWidth = 1.2;

    // Ray 1: parallel from object → through F1 of L1 → continues to L2 → refracted
    ctx.strokeStyle = themeColor('rgba(220,38,38,0.6)', 'rgba(248,113,113,0.6)');
    ctx.beginPath();
    ctx.moveTo(objX, cy - objH);
    ctx.lineTo(L1x, cy - objH);
    ctx.lineTo(img1X, cy - img1H * img1Dir);
    ctx.stroke();

    // Ray 2: through center of L1 → undeviated → to L2
    ctx.strokeStyle = themeColor('rgba(5,150,105,0.6)', 'rgba(52,211,153,0.6)');
    ctx.beginPath();
    ctx.moveTo(objX, cy - objH);
    ctx.lineTo(L1x, cy - objH + (objH) * (L1x - objX) / (img1X - objX + 0.001));
    ctx.lineTo(img1X, cy - img1H * img1Dir);
    ctx.stroke();

    // Separation label
    if (d > 0) {
        ctx.font = '9px Inter, sans-serif';
        ctx.fillStyle = themeColor('#64748b', '#94a3b8');
        ctx.fillText('d=' + d + 'cm', (L1x + L2x) / 2, cy - lh/2 - 8);
    }

    // Title
    ctx.font = 'bold 12px Inter, sans-serif';
    ctx.fillStyle = themeColor('#1e293b', '#f1f5f9');
    ctx.textAlign = 'center';
    ctx.fillText('Double Lens System — m_total = ' + result.mTotal.toFixed(3) + '\u00D7', W/2, 18);
}

// ==================== Mode Switching ====================

function switchMode(mode) {
    state.mode = mode;

    var btns = document.querySelectorAll('.lc-mode-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-mode') === mode);
    }

    var lm = $('lc-lensmaker-inputs');
    var cb = $('lc-combined-inputs');
    var dl = $('lc-doublelens-inputs');

    if (lm) lm.style.display = mode === 'lensmaker' ? '' : 'none';
    if (cb) cb.style.display = mode === 'combined' ? '' : 'none';
    if (dl) dl.style.display = mode === 'doublelens' ? '' : 'none';

    // Toggle example groups
    var exLm = $('lc-ex-lensmaker');
    var exCb = $('lc-ex-combined');
    var exDl = $('lc-ex-doublelens');
    if (exLm) exLm.style.display = mode === 'lensmaker' ? '' : 'none';
    if (exCb) exCb.style.display = mode === 'combined' ? '' : 'none';
    if (exDl) exDl.style.display = mode === 'doublelens' ? '' : 'none';

    calculate();
}

// ==================== Presets ====================

function applyMaterial(mu) {
    setInput('lc-mu', mu);
    calculate();
}

function applyShape(R1, R2) {
    setInput('lc-r1', R1);
    setInput('lc-r2', R2);
    setInput('lc-r1-slider', R1);
    setInput('lc-r2-slider', R2);
    calculate();
}

function applyExample(preset) {
    var presets = {
        'crown-biconvex':    { mode: 'lensmaker', mu: 1.52, muM: 1, R1: 20, R2: -20 },
        'flint-biconcave':   { mode: 'lensmaker', mu: 1.62, muM: 1, R1: -15, R2: 15 },
        'bk7-planoconvex':   { mode: 'lensmaker', mu: 1.5168, muM: 1, R1: 99999, R2: -25 },
        'diamond':           { mode: 'lensmaker', mu: 2.42, muM: 1, R1: 10, R2: -10 },
        'water-lens':        { mode: 'lensmaker', mu: 1.5, muM: 1.33, R1: 20, R2: -20 },
        'meniscus':          { mode: 'lensmaker', mu: 1.52, muM: 1, R1: 20, R2: 40 },
        'contact-conv':      { mode: 'combined', f1: 10, f2: 20, d: 0 },
        'contact-achro':     { mode: 'combined', f1: 15, f2: -30, d: 0 },
        'separated':         { mode: 'combined', f1: 10, f2: 15, d: 5 },
        'telescope':         { mode: 'combined', f1: 100, f2: 5, d: 105 },
        'microscope':        { mode: 'doublelens', f1: 1, f2: 5, d: 20, u: 1.2, h: 0.1 },
        'projector':         { mode: 'doublelens', f1: 10, f2: 20, d: 40, u: 12, h: 2 },
        'relay':             { mode: 'doublelens', f1: 15, f2: 15, d: 30, u: 30, h: 5 },
        'telephoto':         { mode: 'doublelens', f1: 50, f2: -20, d: 35, u: 500, h: 50 }
    };

    var p = presets[preset];
    if (!p) return;

    switchMode(p.mode);

    if (p.mode === 'lensmaker') {
        setInput('lc-mu', p.mu);
        setInput('lc-medium-mu', p.muM);
        setInput('lc-r1', p.R1);
        setInput('lc-r2', p.R2);
        setInput('lc-r1-slider', p.R1);
        setInput('lc-r2-slider', p.R2);
    } else if (p.mode === 'combined') {
        setInput('lc-f1', p.f1);
        setInput('lc-f2', p.f2);
        setInput('lc-separation', p.d);
    } else {
        setInput('lc-dl-f1', p.f1);
        setInput('lc-dl-f2', p.f2);
        setInput('lc-dl-d', p.d);
        setInput('lc-dl-u', p.u);
        setInput('lc-dl-h', p.h);
    }

    calculate();
}

// ==================== Slider Sync ====================

function syncSlider(inputId, sliderId) {
    var input = $(inputId);
    var slider = $(sliderId);
    if (!input || !slider) return;

    input.addEventListener('input', function() {
        slider.value = input.value;
    });
    slider.addEventListener('input', function() {
        input.value = slider.value;
        calculate();
    });
}

// ==================== Events ====================

function bindEvents() {
    // Mode buttons
    var modeBtns = document.querySelectorAll('.lc-mode-btn');
    for (var i = 0; i < modeBtns.length; i++) {
        (function(btn) {
            btn.addEventListener('click', function() {
                switchMode(btn.getAttribute('data-mode'));
            });
        })(modeBtns[i]);
    }

    // Calculate button
    var solveBtn = $('lc-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculate);

    // Auto-calculate on any input change
    var allInputs = document.querySelectorAll('.lc-input, .lc-select');
    for (var ai = 0; ai < allInputs.length; ai++) {
        allInputs[ai].addEventListener('input', calculate);
        allInputs[ai].addEventListener('change', calculate);
    }

    // Slider sync
    syncSlider('lc-r1', 'lc-r1-slider');
    syncSlider('lc-r2', 'lc-r2-slider');

    // Medium dropdown → hidden input sync
    var mediumSelect = $('lc-medium-select');
    var mediumInput = $('lc-medium-mu');
    if (mediumSelect && mediumInput) {
        mediumSelect.addEventListener('change', function() {
            if (mediumSelect.value === 'custom') {
                mediumInput.style.display = '';
                mediumInput.focus();
            } else {
                mediumInput.style.display = 'none';
                mediumInput.value = mediumSelect.value;
                calculate();
            }
        });
    }

    // Thick lens toggle
    var thickToggle = $('lc-thick-toggle');
    var thickSection = $('lc-thick-section');
    if (thickToggle && thickSection) {
        thickToggle.addEventListener('change', function() {
            thickSection.style.display = thickToggle.checked ? '' : 'none';
            calculate();
        });
    }

    // Material chips
    var matChips = document.querySelectorAll('.lc-mat-chip');
    for (var j = 0; j < matChips.length; j++) {
        (function(chip) {
            chip.addEventListener('click', function(e) {
                e.preventDefault();
                applyMaterial(parseFloat(chip.getAttribute('data-mu')));
            });
        })(matChips[j]);
    }

    // Shape chips
    var shapeChips = document.querySelectorAll('.lc-shape-chip');
    for (var k = 0; k < shapeChips.length; k++) {
        (function(chip) {
            chip.addEventListener('click', function(e) {
                e.preventDefault();
                // Highlight active shape
                var all = document.querySelectorAll('.lc-shape-chip');
                for (var s = 0; s < all.length; s++) all[s].classList.remove('active');
                chip.classList.add('active');
                var r1 = parseFloat(chip.getAttribute('data-r1'));
                var r2 = parseFloat(chip.getAttribute('data-r2'));
                applyShape(r1, r2);
            });
        })(shapeChips[k]);
    }

    // Example chips
    var exChips = document.querySelectorAll('.lc-example-chip');
    for (var m = 0; m < exChips.length; m++) {
        (function(chip) {
            chip.addEventListener('click', function(e) {
                e.preventDefault();
                applyExample(chip.getAttribute('data-example'));
            });
        })(exChips[m]);
    }
}

// ==================== Init ====================

function init() {
    bindEvents();
    calculate();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
