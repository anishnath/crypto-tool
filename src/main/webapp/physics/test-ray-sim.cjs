/**
 * Ray Optics Simulator — Node.js CJS Test Suite
 * Run:  node test-ray-sim.cjs
 */
'use strict';

/* ---- Shim browser globals ---- */
global.window = global;
global.document = { documentElement: { getAttribute: function () { return null; } } };
global.requestAnimationFrame = function (cb) { cb(); };

/* ---- Load modules ---- */
var fs = require('fs');
var vm = require('vm');

function loadScript(path) {
  var code = fs.readFileSync(__dirname + '/' + path, 'utf8');
  vm.runInThisContext(code, { filename: path });
}

loadScript('js/ray-sim-scene.js');
loadScript('js/ray-sim-engine.js');
// renderer + ui need real DOM/canvas — skip

var S = global.RayScene;
var E = global.RayEngine;
var Vec = E.Vec;

/* ---- Test framework ---- */
var passed = 0, failed = 0, total = 0;

function assert(cond, msg) {
  total++;
  if (cond) {
    passed++;
    console.log('  \x1b[32mPASS\x1b[0m ' + msg);
  } else {
    failed++;
    console.log('  \x1b[31mFAIL\x1b[0m ' + msg);
  }
}

function approx(a, b, tol) {
  tol = tol || 0.001;
  return Math.abs(a - b) < tol;
}

function section(name) {
  console.log('\n\x1b[1m--- ' + name + ' ---\x1b[0m');
}

/* ================================================================
 *  1. VECTOR MATH
 * ================================================================ */
section('Vector Math');

var v1 = { x: 3, y: 4 };
var v2 = { x: 1, y: -2 };

assert(approx(Vec.len(v1), 5), 'len(3,4) = 5');
assert(approx(Vec.dot(v1, v2), -5), 'dot((3,4),(1,-2)) = -5');
assert(approx(Vec.cross(v1, v2), -10), 'cross((3,4),(1,-2)) = -10');

var n1 = Vec.norm(v1);
assert(approx(Vec.len(n1), 1), 'normalize produces unit vector');
assert(approx(n1.x, 0.6) && approx(n1.y, 0.8), 'norm(3,4) = (0.6,0.8)');

var added = Vec.add(v1, v2);
assert(added.x === 4 && added.y === 2, 'add: (4,2)');

var sub = Vec.sub(v1, v2);
assert(sub.x === 2 && sub.y === 6, 'sub: (2,6)');

var scaled = Vec.scale(v1, 2);
assert(scaled.x === 6 && scaled.y === 8, 'scale: (6,8)');

var perp = Vec.perp({ x: 1, y: 0 });
assert(perp.x === 0 && perp.y === 1, 'perp(1,0) = (0,1)');

var rot = Vec.rotate({ x: 1, y: 0 }, Math.PI / 2);
assert(approx(rot.x, 0) && approx(rot.y, 1), 'rotate 90°');

assert(approx(Vec.dist({ x: 0, y: 0 }, { x: 3, y: 4 }), 5), 'dist = 5');

/* ================================================================
 *  2. RAY-SEGMENT INTERSECTION
 * ================================================================ */
section('Ray-Segment Intersection');

// Horizontal ray hitting vertical segment
var hit1 = E.intersectRaySegment(
  { ox: 0, oy: 5, dx: 1, dy: 0 },
  { x: 10, y: 0 }, { x: 10, y: 10 }
);
assert(hit1 !== null, 'Horizontal ray hits vertical segment');
assert(approx(hit1.point.x, 10) && approx(hit1.point.y, 5), 'Hit at (10,5)');
assert(approx(hit1.t, 10), 't = 10');

// Ray missing segment (above)
var hit2 = E.intersectRaySegment(
  { ox: 0, oy: 15, dx: 1, dy: 0 },
  { x: 10, y: 0 }, { x: 10, y: 10 }
);
assert(hit2 === null, 'Ray above segment misses');

// Ray going backwards
var hit3 = E.intersectRaySegment(
  { ox: 0, oy: 5, dx: -1, dy: 0 },
  { x: 10, y: 0 }, { x: 10, y: 10 }
);
assert(hit3 === null, 'Ray in opposite direction misses');

// Parallel ray
var hit4 = E.intersectRaySegment(
  { ox: 0, oy: 5, dx: 0, dy: 1 },
  { x: 10, y: 0 }, { x: 10, y: 10 }
);
assert(hit4 === null, 'Parallel ray misses');

// Angled ray
var hit5 = E.intersectRaySegment(
  { ox: 0, oy: 0, dx: 1, dy: 1 },
  { x: 5, y: 0 }, { x: 5, y: 10 }
);
assert(hit5 !== null && approx(hit5.point.x, 5) && approx(hit5.point.y, 5), 'Angled ray hits at (5,5)');

// Normal direction (left of p1→p2)
assert(hit1.normal !== null, 'Normal is computed');
var nl = Vec.len(hit1.normal);
assert(approx(nl, 1), 'Normal is unit length: ' + nl.toFixed(4));

/* ================================================================
 *  3. RAY-CIRCLE INTERSECTION
 * ================================================================ */
section('Ray-Circle Intersection');

// Ray through center of circle
var cHits1 = E.intersectRayCircle(
  { ox: -20, oy: 0, dx: 1, dy: 0 },
  0, 0, 10
);
assert(cHits1.length === 2, 'Ray through center: 2 hits');
assert(approx(cHits1[0].point.x, -10), 'First hit at x=-10');
assert(approx(cHits1[1].point.x, 10), 'Second hit at x=10');

// Check normals point outward
assert(cHits1[0].normal.x < 0, 'First hit normal points left');
assert(cHits1[1].normal.x > 0, 'Second hit normal points right');

// Tangent ray
var cHits2 = E.intersectRayCircle(
  { ox: -20, oy: 10, dx: 1, dy: 0 },
  0, 0, 10
);
assert(cHits2.length <= 1, 'Tangent ray: 0 or 1 hits');

// Miss
var cHits3 = E.intersectRayCircle(
  { ox: -20, oy: 15, dx: 1, dy: 0 },
  0, 0, 10
);
assert(cHits3.length === 0, 'Ray above circle: 0 hits');

// Ray starting inside circle
var cHits4 = E.intersectRayCircle(
  { ox: 0, oy: 0, dx: 1, dy: 0 },
  0, 0, 10
);
assert(cHits4.length === 1, 'Ray from center: 1 forward hit');
assert(approx(cHits4[0].point.x, 10), 'Exits at x=10');

/* ================================================================
 *  4. REFLECTION
 * ================================================================ */
section('Reflection');

// Horizontal ray reflecting off vertical mirror
var refl1 = E.reflect(1, 0, -1, 0);
assert(approx(refl1.x, -1) && approx(refl1.y, 0), 'Reflect (1,0) off (-1,0): (-1,0)');

// 45-degree reflection
var refl2 = E.reflect(1, 0, -Math.SQRT1_2, Math.SQRT1_2);
assert(approx(refl2.x, 0) && approx(refl2.y, 1, 0.01), 'Reflect at 45°: turns 90°: (' + refl2.x.toFixed(3) + ',' + refl2.y.toFixed(3) + ')');

// Reflection preserves speed (unit length)
var refl3 = E.reflect(0.6, 0.8, 1, 0);
assert(approx(Vec.len(refl3), 1, 0.001), 'Reflection preserves length');

/* ================================================================
 *  5. REFRACTION (Snell's Law)
 * ================================================================ */
section('Refraction');

// Normal incidence — no bending
var refr1 = E.refract(1, 0, -1, 0, 1, 1.5);
assert(refr1 !== null, 'Normal incidence: refraction succeeds');
assert(approx(refr1.x, 1) && approx(refr1.y, 0, 0.001), 'Normal incidence: no bending');

// Oblique incidence (30° from normal) entering glass
var inDir = Vec.norm({ x: Math.cos(Math.PI / 6), y: Math.sin(Math.PI / 6) });
var refr2 = E.refract(inDir.x, inDir.y, -1, 0, 1.0, 1.5);
assert(refr2 !== null, 'Oblique: refraction succeeds');
// Snell: sin(30°)/sin(θ_t) = 1.5  → sin(θ_t) = 0.5/1.5 = 0.333  → θ_t ≈ 19.47°
var outAngle = Math.atan2(Math.abs(refr2.y), refr2.x);
assert(approx(outAngle, 19.47 * Math.PI / 180, 0.01), 'Refraction angle ≈ 19.5°: ' + (outAngle * 180 / Math.PI).toFixed(2) + '°');

// Refracted ray is unit length
assert(approx(Vec.len(refr2), 1, 0.001), 'Refracted ray is unit length');

// TIR — glass to air at steep angle
var tirDir = Vec.norm({ x: 0.3, y: 0.95 });
var refr3 = E.refract(tirDir.x, tirDir.y, -1, 0, 1.5, 1.0);
assert(refr3 === null, 'TIR at steep angle: refract returns null');

// Critical angle for glass (n=1.5): sin(θ_c) = 1/1.5 = 0.667 → θ_c ≈ 41.8°
var critAngle = Math.asin(1.0 / 1.5);
// Just below critical angle — should refract
var justBelow = Vec.norm({ x: Math.cos(critAngle - 0.01), y: Math.sin(critAngle - 0.01) });
var refr4 = E.refract(justBelow.x, justBelow.y, -1, 0, 1.5, 1.0);
assert(refr4 !== null, 'Just below critical angle: refracts');

// Just above critical angle — should TIR
var justAbove = Vec.norm({ x: Math.cos(critAngle + 0.01), y: Math.sin(critAngle + 0.01) });
var refr5 = E.refract(justAbove.x, justAbove.y, -1, 0, 1.5, 1.0);
assert(refr5 === null, 'Just above critical angle: TIR');

/* ================================================================
 *  6. FRESNEL REFLECTANCE
 * ================================================================ */
section('Fresnel Reflectance');

var fr1 = E.fresnelReflectance(1, 1, 1.5); // normal incidence
assert(fr1 > 0 && fr1 < 0.1, 'Normal incidence: low reflectance: ' + fr1.toFixed(4));

var fr2 = E.fresnelReflectance(0.1, 1.5, 1); // near-grazing from glass
assert(fr2 > 0.5, 'Near-grazing from glass: high reflectance: ' + fr2.toFixed(4));

var fr3 = E.fresnelReflectance(Math.cos(critAngle + 0.01), 1.5, 1); // TIR
assert(fr3 === 1, 'Beyond critical angle: R = 1');

/* ================================================================
 *  7. CAUCHY DISPERSION
 * ================================================================ */
section('Cauchy Dispersion');

var nRed = S.cauchyN(0.65, 1.5046, 0.00420, 0);
var nBlue = S.cauchyN(0.45, 1.5046, 0.00420, 0);
assert(nBlue > nRed, 'Blue has higher n than red (normal dispersion): ' + nBlue.toFixed(4) + ' > ' + nRed.toFixed(4));

var nCenter = S.cauchyN(0.55, 1.5046, 0.00420, 0);
assert(approx(nCenter, 1.518, 0.01), 'n at 550nm ≈ 1.518: ' + nCenter.toFixed(4));

// Presets
var crown = S.CAUCHY_PRESETS['Crown'];
assert(crown.A > 1.5, 'Crown glass A > 1.5');
var diamond = S.CAUCHY_PRESETS['Diamond'];
assert(diamond.A > 2.3, 'Diamond A > 2.3');

/* ================================================================
 *  8. SCENE OBJECT CREATION
 * ================================================================ */
section('Scene Objects');

var ps = new S.PointSource({ x: 100, y: 200, numRays: 12, spreadAngle: 120 });
assert(ps.type === 'PointSource', 'PointSource type');
assert(ps.x === 100 && ps.y === 200, 'PointSource position');
var psRays = ps.generateRays();
assert(psRays.length === 12, 'PointSource generates 12 rays');

var pb = new S.ParallelBeam({ x: 50, y: 100, numRays: 5, width: 40, angle: 0 });
var pbRays = pb.generateRays();
assert(pbRays.length === 5, 'ParallelBeam generates 5 rays');
// All rays should have same direction
for (var i = 0; i < pbRays.length; i++) {
  assert(approx(pbRays[i].dx, 1) && approx(pbRays[i].dy, 0), 'Beam ray ' + i + ' direction is (1,0)');
}
// Rays should span the width
var minY = Infinity, maxY = -Infinity;
for (var j = 0; j < pbRays.length; j++) {
  if (pbRays[j].oy < minY) minY = pbRays[j].oy;
  if (pbRays[j].oy > maxY) maxY = pbRays[j].oy;
}
assert(approx(maxY - minY, 40, 0.1), 'Beam rays span width=40: ' + (maxY - minY).toFixed(2));

var sr = new S.SingleRay({ x: 0, y: 0, angle: Math.PI / 4 });
var srRays = sr.generateRays();
assert(srRays.length === 1, 'SingleRay generates 1 ray');
assert(approx(srRays[0].dx, Math.SQRT1_2) && approx(srRays[0].dy, Math.SQRT1_2), 'SingleRay at 45°');

/* ================================================================
 *  9. MIRROR OBJECTS
 * ================================================================ */
section('Mirror Objects');

var fm = new S.FlatMirror({ x: 100, y: 100, angle: 0, length: 60 });
var fmEdges = fm.getEdges();
assert(fmEdges.length === 1, 'FlatMirror: 1 edge');
assert(fmEdges[0].interaction === 'reflect', 'FlatMirror: reflects');
var fmEp = fm.getEndpoints();
assert(approx(Vec.dist(fmEp.p1, fmEp.p2), 60), 'FlatMirror length = 60');

var cm = new S.CurvedMirror({ x: 300, y: 300, radius: 100, arcAngle: 60, angle: Math.PI });
var arc = cm.getArc();
assert(arc.radius === 100, 'CurvedMirror radius = 100');
assert(arc.interaction === 'reflect', 'CurvedMirror reflects');
assert(arc.concave === true, 'Positive radius = concave');

var pm = new S.ParabolicMirror({ x: 500, y: 300, focalLength: 50, height: 60 });
var pmEdges = pm.getEdges();
assert(pmEdges.length > 10, 'ParabolicMirror: polyline has many edges: ' + pmEdges.length);
assert(pmEdges[0].interaction === 'reflect', 'ParabolicMirror reflects');

/* ================================================================
 *  10. GLASS OBJECTS
 * ================================================================ */
section('Glass Objects');

var slab = new S.GlassSlab({ x: 200, y: 200, width: 40, height: 80, refractiveIndex: 1.5 });
var slabEdges = slab.getEdges();
assert(slabEdges.length === 4, 'GlassSlab: 4 edges');
assert(slabEdges[0].interaction === 'refract', 'GlassSlab: refracts');
assert(slabEdges[0].obj === slab, 'Edge references parent object');

var prism = new S.Prism({ x: 300, y: 300, sideLength: 60, apexAngle: 60 });
var prismEdges = prism.getEdges();
assert(prismEdges.length === 3, 'Prism: 3 edges');
var prismVerts = prism.getVertices();
assert(prismVerts.length === 3, 'Prism: 3 vertices');

var cl = new S.CircleLens({ x: 400, y: 400, radius: 30, refractiveIndex: 1.5 });
var clCircle = cl.getCircle();
assert(clCircle.radius === 30, 'CircleLens radius = 30');
assert(clCircle.interaction === 'refract', 'CircleLens: refracts');

// Dispersion
var nR = slab.getN(0.65);
var nB = slab.getN(0.45);
assert(nB > nR, 'Slab: blue n > red n (dispersion)');

/* ================================================================
 *  11. IDEAL LENS
 * ================================================================ */
section('Ideal Lens');

var il = new S.IdealLens({ x: 300, y: 300, focalLength: 80, height: 60, angle: Math.PI / 2 });
var ilEdges = il.getEdges();
assert(ilEdges.length === 1, 'IdealLens: 1 edge');
assert(ilEdges[0].interaction === 'ideal_lens', 'IdealLens interaction type');

/* ================================================================
 *  12. BLOCKERS
 * ================================================================ */
section('Blockers');

var bl = new S.Blocker({ x: 500, y: 300, length: 60, angle: Math.PI / 2 });
var blEdges = bl.getEdges();
assert(blEdges.length === 1, 'Blocker: 1 edge');
assert(blEdges[0].interaction === 'absorb', 'Blocker: absorbs');

var ap = new S.Aperture({ x: 500, y: 300, length: 80, opening: 20, angle: Math.PI / 2 });
var apEdges = ap.getEdges();
assert(apEdges.length === 2, 'Aperture: 2 edges (with gap)');
assert(apEdges[0].interaction === 'absorb', 'Aperture edges absorb');

/* ================================================================
 *  13. SCENE & SERIALIZATION
 * ================================================================ */
section('Scene & Serialization');

var scene1 = new S.Scene({ width: 800, height: 600 });
scene1.addObject(new S.PointSource({ x: 100, y: 300, numRays: 8 }));
scene1.addObject(new S.FlatMirror({ x: 500, y: 300, length: 60 }));

assert(scene1.objects.length === 2, 'Scene has 2 objects');
var sources = scene1.getLightSources();
assert(sources.length === 1, 'Scene has 1 light source');

// Serialization round-trip
var json = scene1.toJSON();
var scene2 = S.Scene.fromJSON(json);
assert(scene2.objects.length === 2, 'Round-trip: 2 objects');
assert(scene2.objects[0].type === 'PointSource', 'Round-trip: first is PointSource');
assert(scene2.objects[1].type === 'FlatMirror', 'Round-trip: second is FlatMirror');
assert(scene2.width === 800, 'Round-trip: width preserved');

// Remove object
var removeId = scene1.objects[0].id;
assert(scene1.removeObject(removeId), 'Remove returns true');
assert(scene1.objects.length === 1, 'After remove: 1 object');
assert(!scene1.removeObject(999), 'Remove non-existent: false');

/* ================================================================
 *  14. FLAT MIRROR RAY TRACE
 * ================================================================ */
section('Flat Mirror Ray Trace');

var mirScene = new S.Scene({ width: 800, height: 600, maxBounces: 10 });
mirScene.addObject(new S.SingleRay({ x: 0, y: 50, angle: 0 }));
mirScene.addObject(new S.FlatMirror({ x: 100, y: 50, angle: Math.PI / 4, length: 80 }));

var mirPaths = E.traceAll(mirScene);
assert(mirPaths.length === 1, 'Mirror trace: 1 path');
assert(mirPaths[0].segments.length >= 2, 'Mirror trace: at least 2 segments (incoming + reflected)');

// First segment ends near x=100
var seg1 = mirPaths[0].segments[0];
assert(approx(seg1.x1, 0) && approx(seg1.y1, 50), 'First segment starts at ray origin');
assert(seg1.x2 > 90 && seg1.x2 < 110, 'First segment ends near mirror: x=' + seg1.x2.toFixed(1));

/* ================================================================
 *  15. GLASS SLAB RAY TRACE
 * ================================================================ */
section('Glass Slab Ray Trace');

var glassScene = new S.Scene({ width: 800, height: 600, maxBounces: 20 });
glassScene.addObject(new S.SingleRay({ x: 0, y: 200, angle: 0.2 }));
glassScene.addObject(new S.GlassSlab({ x: 200, y: 200, width: 60, height: 120, refractiveIndex: 1.5, angle: 0 }));

var glassPaths = E.traceAll(glassScene);
assert(glassPaths.length === 1, 'Glass trace: 1 path');
assert(glassPaths[0].segments.length >= 3, 'Glass trace: ≥3 segments (before, inside, after): ' + glassPaths[0].segments.length);

// Ray should exit roughly parallel to input (slab with parallel faces)
if (glassPaths[0].segments.length >= 3) {
  var firstSeg = glassPaths[0].segments[0];
  var lastSeg = glassPaths[0].segments[glassPaths[0].segments.length - 1];
  var inSlope = (firstSeg.y2 - firstSeg.y1) / (firstSeg.x2 - firstSeg.x1);
  var outSlope = (lastSeg.y2 - lastSeg.y1) / (lastSeg.x2 - lastSeg.x1);
  assert(approx(inSlope, outSlope, 0.02), 'Parallel slab: exit ray parallel to input: in=' + inSlope.toFixed(4) + ' out=' + outSlope.toFixed(4));
}

/* ================================================================
 *  16. PRISM DISPERSION
 * ================================================================ */
section('Prism Dispersion');

var prismScene = new S.Scene({ width: 800, height: 600, maxBounces: 20 });
prismScene.addObject(new S.SingleRay({ x: 100, y: 295, angle: 0, wavelength: 0.45 })); // blue
prismScene.addObject(new S.SingleRay({ x: 100, y: 305, angle: 0, wavelength: 0.65 })); // red
prismScene.addObject(new S.Prism({ x: 350, y: 300, sideLength: 80, apexAngle: 60,
  refractiveIndex: 1.5, cauchyB: 0.00420 }));

var prismPaths = E.traceAll(prismScene);
assert(prismPaths.length === 2, 'Prism: 2 paths (blue + red)');

// Both should have refracted segments
assert(prismPaths[0].segments.length >= 2, 'Blue ray: ≥2 segments: ' + prismPaths[0].segments.length);
assert(prismPaths[1].segments.length >= 2, 'Red ray: ≥2 segments: ' + prismPaths[1].segments.length);

/* ================================================================
 *  17. CIRCLE LENS RAY TRACE
 * ================================================================ */
section('Circle Lens Ray Trace');

var circScene = new S.Scene({ width: 800, height: 600, maxBounces: 20 });
circScene.addObject(new S.SingleRay({ x: 0, y: 300, angle: 0 }));
circScene.addObject(new S.CircleLens({ x: 200, y: 300, radius: 40, refractiveIndex: 1.5 }));

var circPaths = E.traceAll(circScene);
assert(circPaths.length === 1, 'Circle lens: 1 path');
assert(circPaths[0].segments.length >= 3, 'Circle lens: ≥3 segments: ' + circPaths[0].segments.length);

/* ================================================================
 *  18. BLOCKER / APERTURE
 * ================================================================ */
section('Blocker & Aperture');

// Ray hits blocker — should stop
var blockScene = new S.Scene({ width: 800, height: 600 });
blockScene.addObject(new S.SingleRay({ x: 0, y: 300, angle: 0 }));
blockScene.addObject(new S.Blocker({ x: 200, y: 300, angle: 0, length: 100 }));

var blockPaths = E.traceAll(blockScene);
assert(blockPaths.length === 1, 'Blocker: 1 path');
assert(blockPaths[0].segments.length === 1, 'Blocker: ray absorbed (1 segment to blocker)');
assert(blockPaths[0].segments[0].x2 < 210, 'Blocker: ray ends near blocker');

// Aperture — ray through opening should pass
var apScene = new S.Scene({ width: 800, height: 600 });
apScene.addObject(new S.SingleRay({ x: 0, y: 300, angle: 0 }));
apScene.addObject(new S.Aperture({ x: 200, y: 300, angle: 0, length: 100, opening: 40 }));

var apPaths = E.traceAll(apScene);
assert(apPaths.length === 1, 'Aperture: 1 path');
// Ray at y=300 should pass through opening (aperture centered at y=300, opening=40 → gap from y=280 to y=320)
assert(apPaths[0].segments.length === 1, 'Aperture: ray passes through opening (1 segment to boundary)');
assert(apPaths[0].segments[0].x2 > 500, 'Aperture: ray continues past aperture: x2=' + apPaths[0].segments[0].x2.toFixed(0));

/* ================================================================
 *  19. MULTIPLE BOUNCES
 * ================================================================ */
section('Multiple Bounces');

// Two parallel mirrors — ray should bounce back and forth
var bounceScene = new S.Scene({ width: 800, height: 600, maxBounces: 20 });
bounceScene.addObject(new S.SingleRay({ x: 250, y: 300, angle: 0.02 }));
bounceScene.addObject(new S.FlatMirror({ x: 200, y: 300, angle: 0, length: 400 }));
bounceScene.addObject(new S.FlatMirror({ x: 600, y: 300, angle: 0, length: 400 }));

var bouncePaths = E.traceAll(bounceScene);
assert(bouncePaths[0].segments.length > 5, 'Parallel mirrors: many bounces: ' + bouncePaths[0].segments.length);

/* ================================================================
 *  20. WAVELENGTH → COLOR
 * ================================================================ */
section('Wavelength to Color');

var white = E.wavelengthToColor(0);
assert(white.indexOf('rgba') === 0, 'White light: rgba string');

var red = E.wavelengthToColor(0.65);
assert(red.indexOf('rgba') === 0, 'Red: rgba string');

var blue = E.wavelengthToColor(0.45);
assert(blue.indexOf('rgba') === 0, 'Blue: rgba string');

// Red should have r > g, b
// Parse components
function parseRGBA(s) {
  var m = s.match(/rgba\((\d+),(\d+),(\d+)/);
  return m ? { r: +m[1], g: +m[2], b: +m[3] } : null;
}
var redC = parseRGBA(red);
var blueC = parseRGBA(blue);
assert(redC && redC.r > redC.g && redC.r > redC.b, 'Red: R dominant');
assert(blueC && blueC.b > blueC.r && blueC.b > blueC.g, 'Blue: B dominant');

/* ================================================================
 *  21. PRESETS
 * ================================================================ */
section('Presets');

var presetNames = Object.keys(S.PRESETS);
assert(presetNames.length >= 5, 'At least 5 presets: ' + presetNames.length);

for (var pi = 0; pi < presetNames.length; pi++) {
  var pName = presetNames[pi];
  if (pName === 'Empty Scene') continue; // skip empty preset
  var pScene = S.PRESETS[pName]();
  assert(pScene.objects.length > 0, pName + ': has objects');
  var pSources = pScene.getLightSources();
  assert(pSources.length > 0, pName + ': has light sources');
  // Trace should not crash
  var pPaths = E.traceAll(pScene);
  assert(pPaths.length > 0, pName + ': trace produces paths');
  assert(pPaths[0].segments.length > 0, pName + ': paths have segments');
}

/* ================================================================
 *  22. POINT IN POLYGON / CIRCLE
 * ================================================================ */
section('Point in Polygon/Circle');

var square = [{ x: 0, y: 0 }, { x: 10, y: 0 }, { x: 10, y: 10 }, { x: 0, y: 10 }];
assert(E.pointInPolygon(5, 5, square), 'Center of square: inside');
assert(!E.pointInPolygon(15, 5, square), 'Outside square: outside');
assert(E.pointInPolygon(1, 1, square), 'Near corner: inside');

assert(E.pointInCircle(0, 0, 0, 0, 10), 'Center of circle: inside');
assert(!E.pointInCircle(15, 0, 0, 0, 10), 'Outside circle: outside');
assert(E.pointInCircle(9, 0, 0, 0, 10), 'Near edge: inside');

/* ================================================================
 *  23. TOTAL INTERNAL REFLECTION (right-angle prism)
 * ================================================================ */
section('Total Internal Reflection');

// TIR is impossible at the parallel exit face of a slab from air (sin(θ_int) = sin(θ_ext)/n ≤ 1/n < critical).
// Instead, test TIR inside a right-angle prism (90° apex) where internal angle can exceed critical.
// A ray entering the hypotenuse of a 45-45-90 prism hits a short face at 45° internally.
// For n=1.5, critical angle = arcsin(1/1.5) ≈ 41.8°. So 45° > 41.8° → TIR.
var tirScene = new S.Scene({ width: 800, height: 600, maxBounces: 20 });
tirScene.addObject(new S.SingleRay({ x: 50, y: 300, angle: 0 }));
tirScene.addObject(new S.Prism({ x: 300, y: 300, sideLength: 80, apexAngle: 90, refractiveIndex: 1.5, angle: 0 }));

var tirPaths = E.traceAll(tirScene);
assert(tirPaths.length === 1, 'TIR prism: 1 path');
// Ray enters, hits internal face at 45° (>critical), TIR bounces → more segments
assert(tirPaths[0].segments.length >= 3, 'TIR: ≥3 segments (entry + TIR bounce + exit): ' + tirPaths[0].segments.length);

/* ================================================================
 *  24. OBJECT FACTORY
 * ================================================================ */
section('Object Factory');

var objTypes = ['PointSource', 'ParallelBeam', 'SingleRay', 'FlatMirror',
  'CurvedMirror', 'ParabolicMirror', 'GlassSlab', 'Prism',
  'CircleLens', 'SphericalLens', 'IdealLens', 'IdealMirror',
  'BeamSplitter', 'Blocker', 'Aperture', 'CircleBlocker'];

for (var oi = 0; oi < objTypes.length; oi++) {
  var created = S.createObject({ type: objTypes[oi], x: 100, y: 100 });
  assert(created !== null && created.type === objTypes[oi], 'Factory creates ' + objTypes[oi]);
}

assert(S.createObject({ type: 'Nonexistent' }) === null, 'Factory returns null for unknown type');

/* ================================================================
 *  25. BEAM SPLITTER
 * ================================================================ */
section('Beam Splitter');

var bs = new S.BeamSplitter({ x: 300, y: 300, angle: Math.PI / 4, length: 80, transmissionRatio: 0.5 });
assert(bs.type === 'BeamSplitter', 'BeamSplitter type');
assert(bs.transmissionRatio === 0.5, 'BeamSplitter transmission ratio');
var bsEdges = bs.getEdges();
assert(bsEdges.length === 1, 'BeamSplitter: 1 edge');
assert(bsEdges[0].interaction === 'beam_split', 'BeamSplitter: beam_split interaction');

// Trace: ray should split into transmitted + reflected
var bsScene = new S.Scene({ width: 800, height: 600 });
bsScene.addObject(new S.SingleRay({ x: 100, y: 300, angle: 0 }));
bsScene.addObject(new S.BeamSplitter({ x: 400, y: 300, angle: Math.PI / 4, length: 120, transmissionRatio: 0.5 }));
var bsPaths = E.traceAll(bsScene);
assert(bsPaths.length === 2, 'BeamSplitter: 2 paths (transmitted + reflected): ' + bsPaths.length);
// Transmitted path continues roughly to the right
var bsTrans = bsPaths[0];
assert(bsTrans.segments.length >= 2, 'BeamSplitter: transmitted path has ≥2 segments');
// Reflected path exists
var bsRefl2 = bsPaths[1];
assert(bsRefl2.segments.length >= 1, 'BeamSplitter: reflected path has segments');

// Brightness: reflected ray spawned with brightness = original * (1 - tr) = 0.5
assert(approx(bsRefl2.brightness, 0.5, 0.01),
  'BeamSplitter: reflected brightness = 0.5: ' + bsRefl2.brightness.toFixed(3));

/* ================================================================
 *  26. CIRCLE BLOCKER
 * ================================================================ */
section('Circle Blocker');

var cb = new S.CircleBlocker({ x: 200, y: 200, radius: 40 });
assert(cb.type === 'CircleBlocker', 'CircleBlocker type');
assert(cb.radius === 40, 'CircleBlocker radius');
var cbCirc = cb.getCircle();
assert(cbCirc.interaction === 'absorb', 'CircleBlocker: absorb interaction');
assert(cbCirc.cx === 200, 'CircleBlocker: center x');

// Trace: ray should be absorbed by circle blocker
var cbScene = new S.Scene({ width: 800, height: 600 });
cbScene.addObject(new S.SingleRay({ x: 50, y: 200, angle: 0 }));
cbScene.addObject(new S.CircleBlocker({ x: 300, y: 200, radius: 40 }));
var cbPaths = E.traceAll(cbScene);
assert(cbPaths.length === 1, 'CircleBlocker: 1 path');
assert(cbPaths[0].segments.length === 1, 'CircleBlocker: ray absorbed (1 segment)');
assert(cbPaths[0].segments[0].x2 < 270, 'CircleBlocker: ray stops at circle: x=' + cbPaths[0].segments[0].x2.toFixed(0));

/* ================================================================
 *  27. IDEAL MIRROR
 * ================================================================ */
section('Ideal Mirror');

var im = new S.IdealMirror({ x: 400, y: 300, focalLength: 100, height: 80 });
assert(im.type === 'IdealMirror', 'IdealMirror type');
assert(im.focalLength === 100, 'IdealMirror focalLength');
var imEdges = im.getEdges();
assert(imEdges.length === 1, 'IdealMirror: 1 edge');
assert(imEdges[0].interaction === 'ideal_mirror', 'IdealMirror: ideal_mirror interaction');

// Trace: parallel beam hitting ideal mirror should converge to focal point
var imScene = new S.Scene({ width: 800, height: 600 });
imScene.addObject(new S.ParallelBeam({ x: 100, y: 300, numRays: 5, width: 40, angle: 0 }));
imScene.addObject(new S.IdealMirror({ x: 500, y: 300, focalLength: 80, height: 100, angle: 0 }));
var imPaths = E.traceAll(imScene);
assert(imPaths.length === 5, 'IdealMirror: 5 reflected paths');
// All reflected rays should converge — check that center ray reflects straight back
var centerPath = imPaths[2]; // middle ray
assert(centerPath.segments.length >= 2, 'IdealMirror: center ray reflects');

/* ================================================================
 *  28. SPHERICAL LENS
 * ================================================================ */
section('Spherical Lens');

var sl = new S.SphericalLens({ x: 400, y: 300, radius1: 80, radius2: 80,
  thickness: 12, diameter: 60, refractiveIndex: 1.5 });
assert(sl.type === 'SphericalLens', 'SphericalLens type');
assert(sl.radius1 === 80, 'SphericalLens radius1');
assert(sl.radius2 === 80, 'SphericalLens radius2');
var slArcs = sl.getArcs();
assert(slArcs.length === 2, 'SphericalLens: 2 arcs (front + back): ' + slArcs.length);
assert(slArcs[0].interaction === 'refract', 'SphericalLens: front arc refracts');
assert(slArcs[1].interaction === 'refract', 'SphericalLens: back arc refracts');
assert(slArcs[0].obj === sl, 'SphericalLens: arc references parent');

// Dispersion
var slN_blue = sl.getN(0.45);
var slN_red = sl.getN(0.65);
assert(slN_blue > slN_red, 'SphericalLens: blue n > red n');

// Trace: parallel beam through spherical lens
var slScene = new S.Scene({ width: 800, height: 600 });
slScene.addObject(new S.ParallelBeam({ x: 100, y: 300, numRays: 5, width: 40, angle: 0 }));
slScene.addObject(new S.SphericalLens({ x: 400, y: 300, radius1: 80, radius2: 80,
  thickness: 14, diameter: 70, refractiveIndex: 1.5 }));
var slPaths = E.traceAll(slScene);
assert(slPaths.length === 5, 'SphericalLens: 5 paths');
// Each ray should pass through the lens (≥3 segments: before, inside, after)
assert(slPaths[0].segments.length >= 3, 'SphericalLens: ray refracts through lens: ' + slPaths[0].segments.length + ' segs');

// JSON round-trip
var slJSON = sl.toJSON();
assert(slJSON.radius1 === 80, 'SphericalLens: toJSON preserves radius1');
assert(slJSON.thickness === 12, 'SphericalLens: toJSON preserves thickness');
var slRestore = S.createObject(slJSON);
assert(slRestore.type === 'SphericalLens', 'SphericalLens: factory restores');
assert(slRestore.radius1 === 80, 'SphericalLens: restored radius1');

/* ================================================================
 *  29. EXTENDED RAYS MODE
 * ================================================================ */
section('Extended Rays');

// Mirror scene in extended mode should have back-projected rays
var extScene = new S.Scene({ width: 800, height: 600, rayMode: 'extended' });
extScene.addObject(new S.PointSource({ x: 200, y: 300, numRays: 5, spreadAngle: 40, angle: 0 }));
extScene.addObject(new S.FlatMirror({ x: 500, y: 300, angle: Math.PI / 12, length: 120 }));
var extPaths = E.traceAll(extScene);
assert(extPaths.length === 5, 'Extended: 5 paths');
// Each path should have extended segments
var hasExtended = false;
for (var ei = 0; ei < extPaths.length; ei++) {
  if (extPaths[ei].extendedSegments && extPaths[ei].extendedSegments.length > 0) {
    hasExtended = true;
    break;
  }
}
assert(hasExtended, 'Extended: paths have extended segments');
// Find first path with extended segments
var extPath = null;
for (var epi = 0; epi < extPaths.length; epi++) {
  if (extPaths[epi].extendedSegments && extPaths[epi].extendedSegments.length > 0) {
    extPath = extPaths[epi]; break;
  }
}
assert(extPath && extPath.extendedSegments[0].extended === true, 'Extended: segment marked as extended');

// Normal mode should NOT have extended segments
var normalScene = new S.Scene({ width: 800, height: 600, rayMode: 'rays' });
normalScene.addObject(new S.PointSource({ x: 200, y: 300, numRays: 3, spreadAngle: 40, angle: 0 }));
normalScene.addObject(new S.FlatMirror({ x: 500, y: 300, angle: 0, length: 120 }));
var normalPaths = E.traceAll(normalScene);
assert(normalPaths[0].extendedSegments.length === 0, 'Normal mode: no extended segments');

/* ================================================================
 *  30. NEW PRESETS TRACE
 * ================================================================ */
section('New Presets');

var newPresetNames = ['Beam Splitter', 'Spherical Lens', 'Concave + Convex Mirrors'];
for (var npi = 0; npi < newPresetNames.length; npi++) {
  var npName = newPresetNames[npi];
  assert(S.PRESETS[npName], npName + ': preset exists');
  var npScene = S.PRESETS[npName]();
  assert(npScene.objects.length > 0, npName + ': has objects');
  var npPaths = E.traceAll(npScene);
  assert(npPaths.length > 0, npName + ': trace produces paths');
  assert(npPaths[0].segments.length > 0, npName + ': paths have segments');
}

/* ================================================================
 *  31. ANGLE SOURCE (PointSource with spreadAngle)
 * ================================================================ */
section('Angle Source (PointSource cone)');

var angleS = new S.PointSource({ x: 100, y: 200, numRays: 8, spreadAngle: 45, angle: 0 });
var aRays = angleS.generateRays();
assert(aRays.length === 8, 'AngleSource: 8 rays');
// All rays should be within ±22.5° of angle 0
var allInCone = true;
for (var ari = 0; ari < aRays.length; ari++) {
  var rayAngle = Math.atan2(aRays[ari].dy, aRays[ari].dx);
  if (Math.abs(rayAngle) > 23 * Math.PI / 180) { allInCone = false; break; }
}
assert(allInCone, 'AngleSource: all rays within 45° cone');

// Full 360 source vs narrow cone
var fullS = new S.PointSource({ x: 0, y: 0, numRays: 36, spreadAngle: 360 });
var fullRays = fullS.generateRays();
var narrowS = new S.PointSource({ x: 0, y: 0, numRays: 36, spreadAngle: 10 });
var narrowRays = narrowS.generateRays();
// Full should cover all directions; narrow should be concentrated
var fullSpread = Math.abs(Math.atan2(fullRays[0].dy, fullRays[0].dx) -
                          Math.atan2(fullRays[18].dy, fullRays[18].dx));
var narrowSpread = 0;
for (var nri = 0; nri < narrowRays.length; nri++) {
  var na = Math.abs(Math.atan2(narrowRays[nri].dy, narrowRays[nri].dx));
  if (na > narrowSpread) narrowSpread = na;
}
assert(narrowSpread < 0.15, 'AngleSource: narrow cone < 0.15 rad spread: ' + narrowSpread.toFixed(3));

/* ================================================================
 *  32. BEAM SPLITTER CASCADE
 * ================================================================ */
section('Beam Splitter Cascade');

// Two beam splitters — should produce 4 output paths (ray splits twice)
var bsCascade = new S.Scene({ width: 1000, height: 600 });
bsCascade.addObject(new S.SingleRay({ x: 50, y: 300, angle: 0 }));
bsCascade.addObject(new S.BeamSplitter({ x: 300, y: 300, angle: Math.PI / 4, length: 120, transmissionRatio: 0.5 }));
bsCascade.addObject(new S.BeamSplitter({ x: 600, y: 300, angle: Math.PI / 4, length: 120, transmissionRatio: 0.5 }));
var cascadePaths = E.traceAll(bsCascade);
// First splitter → 2 paths (transmitted continues to 2nd splitter, reflected escapes)
// 2nd splitter splits the transmitted → total 3 paths
// Reflected from 1st goes up → if it hits 2nd, could be 4
assert(cascadePaths.length >= 3, 'Cascade: ≥3 paths from 2 splitters: ' + cascadePaths.length);

/* ================================================================
 *  33. FRESNEL PARTIAL REFLECTION
 * ================================================================ */
section('Fresnel Partial Reflection');

// With fresnelEnabled, glass surface should spawn a reflected ray
var frScene = new S.Scene({ width: 800, height: 600, fresnelEnabled: true });
frScene.addObject(new S.SingleRay({ x: 50, y: 250, angle: 0.3 }));
frScene.addObject(new S.GlassSlab({ x: 300, y: 350, width: 200, height: 100, refractiveIndex: 1.5 }));
var frPaths = E.traceAll(frScene);
assert(frPaths.length >= 2, 'Fresnel: spawns reflected ray: ' + frPaths.length + ' paths');
// Main path should have reduced brightness from (1-R) factor
assert(frPaths[0].segments.length >= 2, 'Fresnel: main path refracts through');

// Without fresnelEnabled, same scene should produce 1 path
var noFrScene = new S.Scene({ width: 800, height: 600, fresnelEnabled: false });
noFrScene.addObject(new S.SingleRay({ x: 50, y: 250, angle: 0.3 }));
noFrScene.addObject(new S.GlassSlab({ x: 300, y: 350, width: 200, height: 100, refractiveIndex: 1.5 }));
var noFrPaths = E.traceAll(noFrScene);
assert(noFrPaths.length === 1, 'No Fresnel: single path: ' + noFrPaths.length);

/* ================================================================
 *  34. DIFFRACTION GRATING
 * ================================================================ */
section('Diffraction Grating');

var dg = new S.DiffractionGrating({ x: 300, y: 300, angle: 0, length: 80, lineDensity: 500, maxOrder: 2 });
assert(dg.type === 'DiffractionGrating', 'DiffractionGrating type');
assert(dg.lineDensity === 500, 'DiffractionGrating lineDensity');
var dgPeriod = dg.getPeriod();
assert(approx(dgPeriod, 2.0, 0.01), 'DiffractionGrating period = 2μm: ' + dgPeriod);
var dgEdges = dg.getEdges();
assert(dgEdges[0].interaction === 'diffract', 'DiffractionGrating: diffract interaction');

// diffractionOrders function test
var orders = E.diffractionOrders(2.0, 0.55, 0, 2); // normal incidence, 550nm
assert(orders.length >= 3, 'Diffraction: ≥3 orders (0, ±1): ' + orders.length);
// Order 0 should have sinOut ≈ 0 (straight through)
var order0 = null;
for (var doi = 0; doi < orders.length; doi++) {
  if (orders[doi].order === 0) { order0 = orders[doi]; break; }
}
assert(order0 && approx(order0.sinOut, 0, 0.01), 'Diffraction: order 0 straight through');

// Order +1: sinOut = 0 + 1 * 0.55/2 = 0.275
var order1 = null;
for (var d1i = 0; d1i < orders.length; d1i++) {
  if (orders[d1i].order === 1) { order1 = orders[d1i]; break; }
}
assert(order1 && approx(order1.sinOut, 0.275, 0.01), 'Diffraction: order +1 sinOut=0.275: ' + (order1 ? order1.sinOut.toFixed(3) : 'null'));

// Trace: monochromatic ray through grating should split into multiple paths
var dgScene = new S.Scene({ width: 800, height: 600 });
dgScene.addObject(new S.SingleRay({ x: 50, y: 300, angle: 0, wavelength: 0.55 }));
dgScene.addObject(new S.DiffractionGrating({ x: 300, y: 300, angle: 0, length: 120, lineDensity: 500, maxOrder: 2 }));
var dgPaths = E.traceAll(dgScene);
assert(dgPaths.length >= 3, 'Diffraction trace: ≥3 paths (multiple orders): ' + dgPaths.length);

// White light (wavelength=0) should just pass through (order 0 only)
var dgWhiteScene = new S.Scene({ width: 800, height: 600 });
dgWhiteScene.addObject(new S.SingleRay({ x: 50, y: 300, angle: 0, wavelength: 0 }));
dgWhiteScene.addObject(new S.DiffractionGrating({ x: 300, y: 300, angle: 0, length: 120, lineDensity: 500, maxOrder: 2 }));
var dgWhitePaths = E.traceAll(dgWhiteScene);
assert(dgWhitePaths.length === 1, 'Diffraction white light: 1 path (order 0): ' + dgWhitePaths.length);

/* ================================================================
 *  35. DICHROIC FILTERING
 * ================================================================ */
section('Dichroic Filtering');

// Dichroic mirror reflects blue (0.4-0.5μm) and transmits red (0.6-0.7μm)
var dcScene = new S.Scene({ width: 800, height: 600 });
dcScene.addObject(new S.SingleRay({ x: 50, y: 300, angle: 0, wavelength: 0.45 })); // blue
dcScene.addObject(new S.FlatMirror({ x: 300, y: 300, angle: Math.PI / 4, length: 100,
  dichroic: true, dichroicMinWL: 0.4, dichroicMaxWL: 0.5 }));
var dcBlue = E.traceAll(dcScene);
// Blue should be reflected — path bends
assert(dcBlue.length === 1, 'Dichroic: blue ray - 1 path');
assert(dcBlue[0].segments.length >= 2, 'Dichroic: blue reflected (≥2 segments)');

// Red should pass through dichroic mirror
var dcSceneRed = new S.Scene({ width: 800, height: 600 });
dcSceneRed.addObject(new S.SingleRay({ x: 50, y: 300, angle: 0, wavelength: 0.65 })); // red
dcSceneRed.addObject(new S.FlatMirror({ x: 300, y: 300, angle: Math.PI / 4, length: 100,
  dichroic: true, dichroicMinWL: 0.4, dichroicMaxWL: 0.5 }));
var dcRed = E.traceAll(dcSceneRed);
// Red should pass through — 2 segments (to mirror, then escape past it)
assert(dcRed.length === 1, 'Dichroic: red ray - 1 path');
// Red ray should continue past mirror — check last segment
var dcRedLast = dcRed[0].segments[dcRed[0].segments.length - 1];
assert(dcRedLast.x2 > 500, 'Dichroic: red passes through mirror: x2=' + dcRedLast.x2.toFixed(0));

/* ================================================================
 *  36. GRIN LENS
 * ================================================================ */
section('GRIN Lens');

var gl = new S.GrinLens({ x: 300, y: 300, radius: 40, refractiveIndex: 1.5, gradientCoeff: 0.1 });
assert(gl.type === 'GrinLens', 'GrinLens type');
assert(gl.radius === 40, 'GrinLens radius');
// n at center should be max
var nCenter = gl.getNAt(300, 300);
assert(approx(nCenter, 1.5, 0.01), 'GrinLens: n at center = 1.5: ' + nCenter.toFixed(4));
// n at edge should be lower
var nEdge = gl.getNAt(340, 300);
assert(nEdge < nCenter, 'GrinLens: n at edge < n at center: ' + nEdge.toFixed(4));
// Gradient
var grad = gl.getGradN(310, 300);
assert(grad.x < 0, 'GrinLens: gradient points inward (negative x): ' + grad.x.toFixed(4));
assert(approx(grad.y, 0, 0.01), 'GrinLens: no y gradient on axis');

// getCircle
var glCirc = gl.getCircle();
assert(glCirc.interaction === 'grin', 'GrinLens: grin interaction');

// Trace: ray through GRIN should curve
var glScene = new S.Scene({ width: 800, height: 600 });
glScene.addObject(new S.SingleRay({ x: 50, y: 310, angle: 0 })); // slightly off-axis
glScene.addObject(new S.GrinLens({ x: 300, y: 300, radius: 50, refractiveIndex: 1.5, gradientCoeff: 0.08 }));
var glPaths = E.traceAll(glScene);
assert(glPaths.length >= 1, 'GrinLens trace: has paths');
// GRIN path should have many small segments (curved ray)
assert(glPaths[0].segments.length >= 3, 'GrinLens: ray has ≥3 segments (curved): ' + glPaths[0].segments.length);

// JSON round-trip
var glJSON = gl.toJSON();
assert(glJSON.gradientCoeff === 0.1, 'GrinLens: toJSON preserves gradient');
var glRestore = S.createObject(glJSON);
assert(glRestore.type === 'GrinLens', 'GrinLens: factory restores');

/* ================================================================
 *  37. IMAGE POINT DETECTION
 * ================================================================ */
section('Image Point Detection');

// Convex lens should produce a real image point
var imgScene = new S.Scene({ width: 800, height: 600, rayMode: 'images' });
imgScene.addObject(new S.PointSource({ x: 150, y: 300, numRays: 5, spreadAngle: 20, angle: 0 }));
imgScene.addObject(new S.IdealLens({ x: 350, y: 300, focalLength: 80, height: 120, angle: 0 }));
var imgPaths = E.traceAll(imgScene);
assert(imgPaths.imagePoints, 'Image mode: imagePoints computed');
assert(imgPaths.imagePoints.length >= 1, 'Image mode: found image point: ' + imgPaths.imagePoints.length);
// Image should be on the right side of the lens (real image)
// Thin lens equation: 1/v = 1/f - 1/u → v = f*u/(u-f) = 80*200/(200-80) = 133.3
// Image at x = 350 + 133.3 ≈ 483
if (imgPaths.imagePoints.length > 0) {
  assert(imgPaths.imagePoints[0].x > 400, 'Image point is past lens: x=' + imgPaths.imagePoints[0].x.toFixed(0));
  assert(approx(imgPaths.imagePoints[0].x, 483, 20), 'Image point near thin-lens prediction (483): x=' + imgPaths.imagePoints[0].x.toFixed(0));
  assert(imgPaths.imagePoints[0].real === true, 'Image point is real (rays converge forward)');
}

// Extended segments should also exist in images mode
var hasExt = false;
for (var imgei = 0; imgei < imgPaths.length; imgei++) {
  if (imgPaths[imgei].extendedSegments && imgPaths[imgei].extendedSegments.length > 0) {
    hasExt = true; break;
  }
}
assert(hasExt, 'Image mode: extended segments computed');

/* ================================================================
 *  38. OBSERVER MODE
 * ================================================================ */
section('Observer Mode');

var obsScene = new S.Scene({ width: 800, height: 600 });
obsScene.addObject(new S.PointSource({ x: 100, y: 300, numRays: 36, spreadAngle: 90, angle: 0 }));
obsScene.addObject(new S.Observer({ x: 600, y: 300, pupilRadius: 50 }));
var obsPaths = E.traceAll(obsScene);
assert(obsPaths.length === 36, 'Observer: 36 paths traced');
// Some paths should be marked observerVisible, others not
var visCount = 0;
for (var ovi = 0; ovi < obsPaths.length; ovi++) {
  if (obsPaths[ovi].observerVisible) visCount++;
}
assert(visCount > 0 && visCount < 36, 'Observer: some visible, some not: ' + visCount + '/36');

// Observer with very large pupil should see all rays
var obsAllScene = new S.Scene({ width: 800, height: 600 });
obsAllScene.addObject(new S.SingleRay({ x: 100, y: 300, angle: 0 }));
obsAllScene.addObject(new S.Observer({ x: 500, y: 300, pupilRadius: 50 }));
var obsAllPaths = E.traceAll(obsAllScene);
assert(obsAllPaths[0].observerVisible === true, 'Observer: direct ray visible');

// Observer object properties
var obs = new S.Observer({ x: 500, y: 300, pupilRadius: 15 });
assert(obs.type === 'Observer', 'Observer type');
assert(obs.pupilRadius === 15, 'Observer pupilRadius');

/* ================================================================
 *  39. NEW OBJECT FACTORY (Phase 2 types)
 * ================================================================ */
section('Phase 2 Factory');

var p2Types = ['DiffractionGrating', 'GrinLens', 'Observer'];
for (var p2i = 0; p2i < p2Types.length; p2i++) {
  var p2Created = S.createObject({ type: p2Types[p2i], x: 100, y: 100 });
  assert(p2Created !== null && p2Created.type === p2Types[p2i], 'Factory creates ' + p2Types[p2i]);
}

/* ================================================================
 *  40. POINT-TO-SEGMENT DISTANCE
 * ================================================================ */
section('Point-to-Segment Distance');

// Point on the segment
assert(approx(E.pointToSegmentDist(5, 0, 0, 0, 10, 0), 0, 0.01), 'Point on segment: dist=0');
// Point perpendicular to midpoint
assert(approx(E.pointToSegmentDist(5, 3, 0, 0, 10, 0), 3, 0.01), 'Point above segment: dist=3');
// Point past endpoint
assert(approx(E.pointToSegmentDist(15, 0, 0, 0, 10, 0), 5, 0.01), 'Point past end: dist=5');

/* ================================================================
 *  SUMMARY
 * ================================================================ */
console.log('\n\x1b[1m===================================\x1b[0m');
console.log('\x1b[1mTotal: ' + total + ' tests — \x1b[32m' + passed + ' passed\x1b[0m, \x1b[31m' + failed + ' failed\x1b[0m');
console.log('\x1b[1m===================================\x1b[0m\n');

process.exit(failed > 0 ? 1 : 0);
