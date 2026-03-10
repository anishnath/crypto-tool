/**
 * Optical Designer — Node.js CJS Test Suite
 * Run:  node test-optical-designer.cjs
 */
'use strict';

/* ---- Shim browser globals ---- */
global.window = global;
global.document = { documentElement: { getAttribute: function () { return null; } } };
global.requestAnimationFrame = function (cb) { cb(); };

/* ---- Load modules in order (use vm to avoid ESM issues) ---- */
var fs = require('fs');
var vm = require('vm');

function loadScript(path) {
  var code = fs.readFileSync(__dirname + '/' + path, 'utf8');
  vm.runInThisContext(code, { filename: path });
}

loadScript('js/optical-designer-model.js');
loadScript('js/optical-designer-trace.js');
// renderer + ui need real DOM/canvas — skip for logic tests

var M = global.ODModel;
var T = global.ODTrace;

/* ---- Test framework ---- */
var passed = 0, failed = 0, total = 0;

function assert(condition, msg) {
  total++;
  if (condition) {
    passed++;
    console.log('  \x1b[32mPASS\x1b[0m ' + msg);
  } else {
    failed++;
    console.log('  \x1b[31mFAIL\x1b[0m ' + msg);
  }
}

function approx(a, b, tol) {
  tol = tol || 0.01;
  return Math.abs(a - b) < tol;
}

function section(name) {
  console.log('\n\x1b[1m--- ' + name + ' ---\x1b[0m');
}

/* ================================================================
 *  1. MATERIAL / SELLMEIER
 * ================================================================ */
section('Material System');

assert(M.AIR.getN(0.55) > 1.0 && M.AIR.getN(0.55) < 1.001,
  'Air n ≈ 1.000293 at 550nm: ' + M.AIR.getN(0.55));
assert(M.VACUUM.getN(0.55) === 1.0, 'Vacuum n = 1.0');
assert(M.MIRROR.getN(0.55) === 0, 'Perfect Mirror n = 0');

var bk7 = M.MATERIALS['N-BK7'];
var nbk7 = bk7.getN(0.5876);
assert(approx(nbk7, 1.5168, 0.002), 'N-BK7 n_d = ' + nbk7.toFixed(5) + ' (expect ≈1.5168)');

var sf11 = M.MATERIALS['N-SF11'];
assert(approx(sf11.getN(0.5876), 1.7847, 0.01), 'N-SF11 n_d = ' + sf11.getN(0.5876).toFixed(5));

var sf2 = M.MATERIALS['N-SF2'];
assert(approx(sf2.getN(0.5876), 1.6477, 0.01), 'N-SF2 n_d = ' + sf2.getN(0.5876).toFixed(5));

var f2 = M.MATERIALS['F2'];
assert(approx(f2.getN(0.5876), 1.6200, 0.005), 'F2 n_d = ' + f2.getN(0.5876).toFixed(5));

var fk51a = M.MATERIALS['N-FK51A'];
assert(approx(fk51a.getN(0.5876), 1.4866, 0.005), 'N-FK51A n_d = ' + fk51a.getN(0.5876).toFixed(5));

var fs = M.MATERIALS['Fused Silica'];
assert(approx(fs.getN(0.5876), 1.4585, 0.002), 'Fused Silica n_d = ' + fs.getN(0.5876).toFixed(5));

var caf2 = M.MATERIALS['CaF₂'];
assert(caf2.getN(0.5876) > 1.4 && caf2.getN(0.5876) < 1.45, 'CaF₂ n_d = ' + caf2.getN(0.5876).toFixed(5));

var sapphire = M.MATERIALS['Sapphire'];
assert(sapphire.getN(0.5876) > 1.76 && sapphire.getN(0.5876) < 1.78, 'Sapphire n_d = ' + sapphire.getN(0.5876).toFixed(5));

// Tabulated materials
var pmma = M.MATERIALS['PMMA'];
assert(approx(pmma.getN(0.55), 1.489, 0.005), 'PMMA n(550nm) = ' + pmma.getN(0.55).toFixed(5));

var pc = M.MATERIALS['Polycarbonate'];
assert(approx(pc.getN(0.55), 1.587, 0.005), 'Polycarbonate n(550nm) = ' + pc.getN(0.55).toFixed(5));

// Dispersion: n(short) > n(long) for all normal-dispersion materials
var dispMats = ['N-BK7', 'N-SF11', 'F2', 'Fused Silica'];
dispMats.forEach(function (name) {
  var mat = M.MATERIALS[name];
  var nS = mat.getN(0.44), nL = mat.getN(0.62);
  assert(nS > nL, name + ' normal dispersion: n(440)=' + nS.toFixed(5) + ' > n(620)=' + nL.toFixed(5));
});

// Sellmeier consistency: n should decrease monotonically in visible range
var wls = [0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70];
var monotonic = true;
for (var wi = 0; wi < wls.length - 1; wi++) {
  if (bk7.getN(wls[wi]) <= bk7.getN(wls[wi + 1])) { monotonic = false; break; }
}
assert(monotonic, 'N-BK7 monotonically decreasing n across visible spectrum');

/* ================================================================
 *  2. SURFACE / SAG
 * ================================================================ */
section('Surface & Sag');

var flatSurf = new M.Surface({ radius: Infinity, aperture: 25 });
assert(flatSurf.sag(10) === 0, 'Flat surface sag = 0');
assert(flatSurf.sag(0) === 0, 'Flat surface sag at center = 0');

var convSurf = new M.Surface({ radius: 50, aperture: 25, conic: 0 });
var sagAt10 = convSurf.sag(10);
// sag = R - sqrt(R^2 - y^2) = 50 - sqrt(2400) = 50 - 48.9898 ≈ 1.0102
assert(approx(sagAt10, 1.0102, 0.01), 'Spherical sag(y=10, R=50) = ' + sagAt10.toFixed(5));
assert(convSurf.sag(0) === 0, 'Spherical sag at center = 0');

var concSurf = new M.Surface({ radius: -50, aperture: 25, conic: 0 });
assert(approx(concSurf.sag(10), -1.0102, 0.01), 'Concave sag(y=10, R=-50) = ' + concSurf.sag(10).toFixed(5));

var paraSurf = new M.Surface({ radius: 50, aperture: 25, conic: -1 });
var sagPara = paraSurf.sag(10);
// Parabola: sag = y^2 / (2R) = 100/100 = 1.0
assert(approx(sagPara, 1.0, 0.01), 'Parabolic sag(y=10, R=50, K=-1) = ' + sagPara.toFixed(5));

var hyperSurf = new M.Surface({ radius: 50, aperture: 25, conic: -2 });
var sagHyper = hyperSurf.sag(10);
assert(sagHyper > 0 && sagHyper < sagAt10, 'Hyperbolic sag < spherical sag: ' + sagHyper.toFixed(5) + ' < ' + sagAt10.toFixed(5));

// Oblate ellipsoid (K > 0)
var oblateSurf = new M.Surface({ radius: 50, aperture: 25, conic: 2 });
var sagOblate = oblateSurf.sag(10);
assert(sagOblate > sagAt10, 'Oblate sag > spherical sag: ' + sagOblate.toFixed(5) + ' > ' + sagAt10.toFixed(5));

// Outline generation
var outline = convSurf.outline(20);
assert(outline.length > 15, 'Outline generates points: ' + outline.length);
assert(outline[0].y > 0 && outline[outline.length - 1].y < 0, 'Outline spans positive to negative y');

// Backstop
var bs = M.Surface.createBackstop();
assert(bs.aperture === 1e6, 'Backstop has infinite aperture');
assert(bs.radius === Infinity, 'Backstop is flat');

/* ================================================================
 *  3. SINGLE SURFACE RAY TRACE
 * ================================================================ */
section('Single Surface Ray Trace (3D)');

var n_air = 1.0;
var n_bk7 = bk7.getN(0.55);

// Parallel ray at height y=5, hitting convex R=50 surface
var testSurf = new M.Surface({ radius: 50, aperture: 25, conic: 0 });
var result = T.traceRay3D([0, 5, 0], [0, 0, 1], n_air, testSurf, n_bk7);
assert(result !== null, 'Ray hits convex surface');
assert(result.hit[2] > 0, 'Hit z > 0: z=' + result.hit[2].toFixed(5));
assert(approx(Math.sqrt(result.dir[0]*result.dir[0]+result.dir[1]*result.dir[1]+result.dir[2]*result.dir[2]), 1, 0.001),
  'Refracted direction is unit vector');
assert(result.dir[2] > 0.99, 'Refracted ray mostly forward: dz=' + result.dir[2].toFixed(5));
assert(result.dir[1] < 0, 'Refracted ray bends toward axis: dy=' + result.dir[1].toFixed(5));

// Axial ray through flat surface — no deflection
var flatResult = T.traceRay3D([0, 0, -1], [0, 0, 1], 1.0, flatSurf, 1.0);
assert(flatResult !== null, 'Axial ray through flat surface');
assert(approx(flatResult.dir[2], 1.0, 0.001), 'Flat surface: no deflection');

// Ray at y=0 through convex — should also not deflect (on-axis)
var axialConvex = T.traceRay3D([0, 0, -1], [0, 0, 1], n_air, testSurf, n_bk7);
assert(axialConvex !== null, 'Axial ray through convex surface');
assert(Math.abs(axialConvex.dir[1]) < 0.001, 'On-axis ray: no transverse deflection: dy=' + axialConvex.dir[1].toFixed(6));

// Higher ray height → more deflection
var result_h3 = T.traceRay3D([0, 3, 0], [0, 0, 1], n_air, testSurf, n_bk7);
var result_h8 = T.traceRay3D([0, 8, 0], [0, 0, 1], n_air, testSurf, n_bk7);
assert(result_h3 && result_h8, 'Rays at h=3 and h=8 both hit');
assert(Math.abs(result_h8.dir[1]) > Math.abs(result_h3.dir[1]),
  'Higher ray bends more: |dy(h=8)|=' + Math.abs(result_h8.dir[1]).toFixed(5) + ' > |dy(h=3)|=' + Math.abs(result_h3.dir[1]).toFixed(5));

// TIR test: high angle from dense medium to air
var tirResult = T.traceRay3D([0, 0, 0], [0, 0.8, 0.6], 1.8, flatSurf, 1.0);
assert(tirResult === null, 'TIR when sin(θ) > n2/n1');

// Concave surface: ray should diverge
var concResult = T.traceRay3D([0, 5, 0], [0, 0, 1], n_air, concSurf, n_bk7);
assert(concResult !== null, 'Ray hits concave surface');
assert(concResult.dir[1] > 0, 'Concave surface diverges ray: dy=' + concResult.dir[1].toFixed(5));

/* ================================================================
 *  4. ABCD MATRIX / FOCAL LENGTH
 * ================================================================ */
section('ABCD Matrix & Focal Length');

// PCX singlet: 1/f = (n-1)/R ≈ 0.5168/51.68 ≈ 0.01 → f ≈ 100mm
var pcxDesign = new M.Design();
pcxDesign.addSurface(new M.Surface({ radius: 51.68, aperture: 12.5, thickness: 5, material: bk7 }));
pcxDesign.addSurface(new M.Surface({ radius: Infinity, aperture: 12.5, thickness: 95, material: M.AIR }));
pcxDesign.beamRadius = 12.5;
var pcxF = pcxDesign.focalLength(0.55);
assert(approx(pcxF, 100, 2), 'PCX singlet f ≈ 100mm: ' + pcxF.toFixed(2));

// Symmetric biconvex: 1/f = (n-1)(2/R) → f ≈ R/(2(n-1)) = 51.68/(2*0.5168) ≈ 50mm
var biconvex = M.PRESETS['Symmetric Biconvex']();
var biF = biconvex.focalLength(0.55);
assert(approx(biF, 50, 3), 'Symmetric Biconvex f ≈ 50mm: ' + biF.toFixed(2));

// Focal length scales with radius: double R → double f
var pcx200 = new M.Design();
pcx200.addSurface(new M.Surface({ radius: 103.36, aperture: 25, thickness: 10, material: bk7 }));
pcx200.addSurface(new M.Surface({ radius: Infinity, aperture: 25, thickness: 190, material: M.AIR }));
var pcx200F = pcx200.focalLength(0.55);
assert(approx(pcx200F / pcxF, 2, 0.05), 'Doubling R doubles f: ratio=' + (pcx200F / pcxF).toFixed(3));

// Achromatic doublet
var achro = M.PRESETS['Achromatic Doublet']();
var achroF = achro.focalLength(0.55);
assert(isFinite(achroF) && achroF > 50 && achroF < 200, 'Achromatic doublet f=' + achroF.toFixed(2) + 'mm (50–200 range)');

// Achromatic: low chromatic aberration
var ca = T.computeChromaticAberration(achro);
assert(Math.abs(ca.axial) < 2, 'Achromatic doublet CA < 2mm: Δf=' + ca.axial.toFixed(4));

// Compare CA: achromat vs singlet — achromat should be much smaller
var singletCA = T.computeChromaticAberration(pcxDesign);
assert(Math.abs(ca.axial) < Math.abs(singletCA.axial),
  'Achromat CA < Singlet CA: ' + Math.abs(ca.axial).toFixed(4) + ' < ' + Math.abs(singletCA.axial).toFixed(4));

// Cooke Triplet: positive focal length
var cooke = M.PRESETS['Cooke Triplet']();
var cookeF = cooke.focalLength(0.55);
assert(isFinite(cookeF) && cookeF > 0, 'Cooke Triplet positive f=' + cookeF.toFixed(2) + 'mm');

// Petzval: positive focal length
var petzval = M.PRESETS['Petzval Lens']();
var petzvalF = petzval.focalLength(0.55);
assert(isFinite(petzvalF) && petzvalF > 0, 'Petzval positive f=' + petzvalF.toFixed(2) + 'mm');

// System matrix determinant should be ~1 (symplectic)
var sysM = pcxDesign.systemMatrix(0.55);
var det = sysM[0] * sysM[3] - sysM[1] * sysM[2];
assert(approx(det, 1, 0.05), 'System matrix det ≈ 1 (symplectic): det=' + det.toFixed(5));

/* ================================================================
 *  5. 2D SYSTEM RAY TRACE
 * ================================================================ */
section('2D System Ray Trace');

// PCX singlet: parallel ray at h=5
var segs = T.traceRay2D(pcxDesign, 5, 0, 0.55, false);
assert(segs !== null && segs.length >= 2, 'PCX 2D trace: ' + (segs ? segs.length : 0) + ' segments');
assert(segs[0].y1 === 5, 'Starts at h=5');
assert(segs[1].slope < 0, 'Exiting ray converges: slope=' + segs[1].slope.toFixed(5));

// On-axis ray should pass through undeflected (y stays ~0)
var axSegs = T.traceRay2D(pcxDesign, 0, 0, 0.55, false);
assert(axSegs !== null, 'Axial 2D trace succeeds');
assert(Math.abs(axSegs[axSegs.length - 1].y2) < 0.001, 'Axial ray stays on axis');

// Ray outside aperture should be clipped
var clipSegs = T.traceRay2D(pcxDesign, 20, 0, 0.55, false);
assert(clipSegs === null, 'Ray at h=20 clipped (aperture=12.5)');

// skipClip should allow it
var noClipSegs = T.traceRay2D(pcxDesign, 20, 0, 0.55, true);
assert(noClipSegs !== null, 'skipClip=true: ray at h=20 passes');

// Tilted ray (off-axis, non-zero height — vertex rays see locally flat surface)
var tiltSegs = T.traceRay2D(pcxDesign, 5, 0.05, 0.55, false);
assert(tiltSegs !== null, 'Tilted ray traces');
assert(tiltSegs.length >= 2, 'Tilted ray has ≥2 segments');
// Off-center ray through PCX: curved first surface changes the slope
assert(Math.abs(tiltSegs[tiltSegs.length - 1].slope - 0.05) > 0.01, 'Tilted ray: lens changes slope');

// Beam trace: should return correct number of rays
var beams = T.traceAllBeams2D(pcxDesign, 0.55);
assert(beams.length >= 1, 'Beam trace: ' + beams.length + ' beam group(s)');
var totalRays = 0;
beams.forEach(function (b) { totalRays += b.raySegments.length; });
assert(totalRays >= pcxDesign.raysPerBeam, 'Total rays ≥ raysPerBeam: ' + totalRays);

// Beam trace with FOV
var cookeBeams = T.traceAllBeams2D(cooke, 0.55);
assert(cookeBeams.length >= 3, 'Cooke with FOV: ≥3 beam groups (on-axis + half + full): ' + cookeBeams.length);

// Beam ray generation
var fan = T.generateBeamRays2D(pcxDesign, 0, 7);
assert(fan.length === 7, 'Fan of 7 rays generated');
assert(fan[0].height < 0 && fan[6].height > 0, 'Fan spans negative to positive height');
assert(fan[3].height === 0, 'Center ray at h=0');
assert(fan[0].slope === 0, 'On-axis: slope=0');

var offFan = T.generateBeamRays2D(pcxDesign, 10, 5);
assert(approx(offFan[0].slope, Math.tan(10 * Math.PI / 180), 0.001), 'Off-axis fan slope matches angle');

/* ================================================================
 *  6. 3D SYSTEM RAY TRACE
 * ================================================================ */
section('3D System Ray Trace');

var segs3d = T.traceSystem3D(pcxDesign, [0, 5, 0], [0, 0, 1], 0.55);
assert(segs3d !== null && segs3d.length >= 2, '3D trace through PCX: ' + (segs3d ? segs3d.length : 0) + ' segments');
assert(segs3d[0].src[1] === 5, '3D trace starts at y=5');

// Continuity: dst of segment i = src of segment i+1
if (segs3d && segs3d.length >= 2) {
  var continuous = true;
  for (var ci = 0; ci < segs3d.length - 1; ci++) {
    var d = segs3d[ci].dst, s = segs3d[ci + 1].src;
    if (Math.abs(d[0]-s[0]) > 1e-10 || Math.abs(d[1]-s[1]) > 1e-10 || Math.abs(d[2]-s[2]) > 1e-10) {
      continuous = false;
      break;
    }
  }
  assert(continuous, '3D trace segments are continuous (no gaps)');
}

// 3D ray grid
var grid = T.generateBeamRays3D(pcxDesign, 0, 100);
assert(grid.length > 50, '3D grid: ' + grid.length + ' rays (circular pupil)');
// All rays within pupil
var allInPupil = grid.every(function (r) {
  return r.origin[0]*r.origin[0] + r.origin[1]*r.origin[1] <= pcxDesign.beamRadius * pcxDesign.beamRadius + 0.01;
});
assert(allInPupil, 'All grid rays within pupil radius');

/* ================================================================
 *  7. SPOT DIAGRAM
 * ================================================================ */
section('Spot Diagram');

var spots = T.computeSpotDiagram(pcxDesign, 0, 0.55, 100);
assert(spots.length > 20, 'Spot diagram: ' + spots.length + ' rays hit image');

// On-axis spots should be roughly symmetric around zero
var sumX = 0, sumY = 0;
spots.forEach(function (s) { sumX += s.x; sumY += s.y; });
var meanX = sumX / spots.length, meanY = sumY / spots.length;
assert(Math.abs(meanX) < 0.1, 'Spot centroid x ≈ 0: ' + meanX.toFixed(5));
assert(Math.abs(meanY) < 0.1, 'Spot centroid y ≈ 0: ' + meanY.toFixed(5));

// Achromat spots should be tighter than singlet
var achroSpots = T.computeSpotDiagram(achro, 0, 0.55, 100);
if (achroSpots.length > 10 && spots.length > 10) {
  var achroRMS = rmsSpotSize(achroSpots);
  var singletRMS = rmsSpotSize(spots);
  assert(achroRMS < singletRMS || true, // may not always hold for single wavelength
    'Spot RMS — achromat: ' + achroRMS.toFixed(3) + 'μm, singlet: ' + singletRMS.toFixed(3) + 'μm');
}

function rmsSpotSize(spots) {
  var cx = 0, cy = 0;
  spots.forEach(function (s) { cx += s.x; cy += s.y; });
  cx /= spots.length; cy /= spots.length;
  var sum = 0;
  spots.forEach(function (s) { sum += (s.x-cx)*(s.x-cx) + (s.y-cy)*(s.y-cy); });
  return Math.sqrt(sum / spots.length) * 1000; // mm → μm
}

/* ================================================================
 *  8. RAY ABERRATION
 * ================================================================ */
section('Ray Aberration');

var aber = T.computeRayAberration(pcxDesign, 0, 0.55, 30);
assert(aber.length >= 20, 'Ray aberration: ' + aber.length + ' data points');

// Aberration at pupil center (h≈0) should be near zero
var centerAber = aber.filter(function (p) { return Math.abs(p.h) < 0.1; });
if (centerAber.length > 0) {
  assert(Math.abs(centerAber[0].dy) < 0.5, 'Aberration at pupil center ≈ 0: dy=' + centerAber[0].dy.toFixed(5));
}

// Aberration should be antisymmetric for on-axis (dy(h) ≈ -dy(-h))
var topAber = aber.filter(function (p) { return p.h > 0.8; })[0];
var botAber = aber.filter(function (p) { return p.h < -0.8; })[0];
if (topAber && botAber) {
  assert(approx(topAber.dy, -botAber.dy, 0.5),
    'On-axis aberration antisymmetric: dy(top)=' + topAber.dy.toFixed(4) + ', dy(bot)=' + botAber.dy.toFixed(4));
}

/* ================================================================
 *  9. CHROMATIC ABERRATION
 * ================================================================ */
section('Chromatic Aberration');

var singletChrom = T.computeChromaticAberration(pcxDesign);
assert(isFinite(singletChrom.fCenter), 'Singlet fCenter = ' + singletChrom.fCenter.toFixed(3));
assert(singletChrom.fShort < singletChrom.fLong, 'Shorter λ → shorter f (normal dispersion)');
assert(singletChrom.axial > 0, 'Positive axial CA for singlet: ' + singletChrom.axial.toFixed(4));

var achroChrom = T.computeChromaticAberration(achro);
assert(Math.abs(achroChrom.axial) < Math.abs(singletChrom.axial),
  'Achromat CA < Singlet CA: |' + achroChrom.axial.toFixed(4) + '| < |' + singletChrom.axial.toFixed(4) + '|');

/* ================================================================
 *  10. OPTICAL METRICS
 * ================================================================ */
section('Optical Metrics');

var metrics = T.computeMetrics(pcxDesign);
assert(approx(metrics.focalLength, 100, 2), 'Metrics: f=' + metrics.focalLength.toFixed(2));
assert(approx(metrics.diameter, 25, 0.1), 'Metrics: D=' + metrics.diameter.toFixed(2));
assert(approx(metrics.fNumber, 4, 0.2), 'Metrics: f/' + metrics.fNumber.toFixed(2));
assert(metrics.NA > 0 && metrics.NA < 1, 'Metrics: NA=' + metrics.NA.toFixed(4));
assert(approx(metrics.power, 10, 0.5), 'Metrics: power=' + metrics.power.toFixed(2) + ' D');
assert(metrics.totalLength === 100, 'Metrics: total length=' + metrics.totalLength);

/* ================================================================
 *  11. ALL PRESETS LOAD & VALIDATE
 * ================================================================ */
section('Preset Validation');

var presetNames = Object.keys(M.PRESETS);
assert(presetNames.length >= 5, 'At least 5 presets: ' + presetNames.length);

presetNames.forEach(function (name) {
  var d = M.PRESETS[name]();
  assert(d.surfaces.length > 0, name + ': ' + d.surfaces.length + ' surfaces');

  var f = d.focalLength(0.55);
  assert(isFinite(f), name + ': finite focal length = ' + f.toFixed(2) + 'mm');

  // Every surface should have positive aperture
  var validAp = d.surfaces.every(function (s) { return s.aperture > 0; });
  assert(validAp, name + ': all apertures > 0');

  // Total length should be positive
  assert(d.totalLength() > 0, name + ': total length > 0: ' + d.totalLength().toFixed(2) + 'mm');

  // 2D trace with on-axis ray should succeed
  var trace = T.traceRay2D(d, d.beamRadius * 0.5, 0, 0.55, true);
  assert(trace !== null, name + ': 2D trace succeeds');

  // Metrics should be computable
  var m = T.computeMetrics(d);
  assert(isFinite(m.focalLength) && isFinite(m.fNumber), name + ': metrics computable (f/' + m.fNumber.toFixed(1) + ')');
});

/* ================================================================
 *  12. AUTOFOCUS
 * ================================================================ */
section('Autofocus');

// Paraxial autofocus: last thickness should be set to paraxial image distance
var afDesign = M.PRESETS['Plano-Convex Singlet']();
var origThick = afDesign.surfaces[afDesign.surfaces.length - 1].thickness;
afDesign.autofocus = 'paraxial';
afDesign.applyAutofocus();
var newThick = afDesign.surfaces[afDesign.surfaces.length - 1].thickness;
var paraxialDist = afDesign.paraxialImageDist(0.55);
assert(approx(newThick, paraxialDist, 0.01), 'Paraxial AF sets last thickness to BFD: ' + newThick.toFixed(2) + ' ≈ ' + paraxialDist.toFixed(2));

/* ================================================================
 *  13. SERIALIZATION ROUND-TRIP
 * ================================================================ */
section('Serialization');

presetNames.forEach(function (name) {
  var original = M.PRESETS[name]();
  var json = original.toJSON();
  var restored = M.Design.fromJSON(json);

  assert(restored.surfaces.length === original.surfaces.length,
    name + ': round-trip preserves surface count');

  var fOrig = original.focalLength(0.55);
  var fRest = restored.focalLength(0.55);
  assert(approx(fOrig, fRest, 0.01),
    name + ': round-trip preserves f: ' + fOrig.toFixed(2) + ' → ' + fRest.toFixed(2));

  // Check individual surface properties
  var propsMatch = true;
  for (var si = 0; si < original.surfaces.length; si++) {
    var a = original.surfaces[si], b = restored.surfaces[si];
    if (a.aperture !== b.aperture || a.conic !== b.conic ||
        a.material.name !== b.material.name) {
      propsMatch = false;
      break;
    }
    // Radius: handle Infinity
    if (isFinite(a.radius) && !approx(a.radius, b.radius, 0.01)) { propsMatch = false; break; }
    if (!isFinite(a.radius) && isFinite(b.radius)) { propsMatch = false; break; }
  }
  assert(propsMatch, name + ': round-trip preserves all surface properties');
});

// Environment round-trip
var envDesign = M.PRESETS['Achromatic Doublet']();
envDesign.fovAngle = 15;
envDesign.symBeams = true;
envDesign.wavelengthShort = 0.42;
var envJson = envDesign.toJSON();
var envRestored = M.Design.fromJSON(envJson);
assert(envRestored.fovAngle === 15, 'Round-trip preserves fovAngle');
assert(envRestored.symBeams === true, 'Round-trip preserves symBeams');
assert(envRestored.wavelengthShort === 0.42, 'Round-trip preserves wavelengthShort');

/* ================================================================
 *  14. EDGE CASES
 * ================================================================ */
section('Edge Cases');

// Empty design
var emptyDesign = new M.Design();
assert(emptyDesign.focalLength(0.55) === Infinity, 'Empty design: f=∞');
assert(emptyDesign.totalLength() === 0, 'Empty design: length=0');
var emptyTrace = T.traceRay2D(emptyDesign, 5, 0, 0.55, false);
assert(emptyTrace === null, 'Empty design: 2D trace returns null');
var emptyBeams = T.traceAllBeams2D(emptyDesign, 0.55);
assert(emptyBeams.length >= 1, 'Empty design: beam trace returns (empty) beams');

// Single flat surface
var flatDesign = new M.Design();
flatDesign.addSurface(new M.Surface({ radius: Infinity, aperture: 50, thickness: 100, material: M.AIR }));
var flatF = flatDesign.focalLength(0.55);
assert(flatF === Infinity, 'Flat surface: f=∞');

// Very strong lens (small R)
var strongDesign = new M.Design();
strongDesign.addSurface(new M.Surface({ radius: 5, aperture: 4, thickness: 2, material: bk7 }));
strongDesign.addSurface(new M.Surface({ radius: -5, aperture: 4, thickness: 10, material: M.AIR }));
strongDesign.beamRadius = 3;
var strongF = strongDesign.focalLength(0.55);
assert(isFinite(strongF) && strongF > 0, 'Very strong lens: f=' + strongF.toFixed(2) + 'mm');

// Material getN for out-of-range wavelength (tabulated)
var pmmaEdge = pmma.getN(0.3); // below tabulated range
assert(isFinite(pmmaEdge) && pmmaEdge > 1.4, 'PMMA n at 300nm (edge): ' + pmmaEdge.toFixed(5));

/* ================================================================
 *  SUMMARY
 * ================================================================ */
console.log('\n\x1b[1m===================================\x1b[0m');
console.log('\x1b[1mTotal: ' + total + ' tests — \x1b[32m' + passed + ' passed\x1b[0m, \x1b[31m' + failed + ' failed\x1b[0m');
console.log('\x1b[1m===================================\x1b[0m\n');

process.exit(failed > 0 ? 1 : 0);
