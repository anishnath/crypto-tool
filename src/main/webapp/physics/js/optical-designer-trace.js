/**
 * Optical Designer — Sequential Ray Tracing Engine
 * ES5 IIFE, depends on ODModel
 *
 * Exports:  window.ODTrace
 *   .traceRay3D(objPt, rayDir, n1, surface, wavelength)  → {hit, dir} | null
 *   .traceRay2D(design, height, slope, wavelength, skipClip)  → [{x1,y1,x2,y2,slope}]
 *   .traceSystem3D(design, objPt, rayDir, wavelength, opts) → [{src,dst}] | null
 *   .generateBeamRays(design, fieldAngleDeg) → [{origin, dir}]
 *   .computeSpotDiagram(design, fieldAngleDeg, wavelength, numRays) → [{x,y}]
 *   .computeRayAberration(design, fieldAngleDeg, wavelength, numRays) → [{h, dy}]
 */
;(function (win) {
  'use strict';

  var M = win.ODModel;
  var Vec = M.Vector;

  /* ================================================================
   *  3D RAY–CONIC INTERSECTION + SNELL'S LAW
   *
   *  Uses closed-form analytic solution for ray–conic intersection.
   *  Surface equation:  z = sign · y² / (|R| + √(R² − (K+1)y²))
   *  extended to 3D:    z = sign · (x²+y²) / (|R| + √(R² − (K+1)(x²+y²)))
   * ================================================================ */

  /**
   * Trace a single ray against a single surface.
   *
   * @param {number[3]} objPt  — ray origin relative to surface vertex
   * @param {number[3]} rayDir — ray direction (need not be unit)
   * @param {number}     n1     — refractive index of incoming medium
   * @param {Surface}    surf   — the surface to intersect
   * @param {number}     n2     — refractive index of outgoing medium
   * @returns {{ hit: number[3], dir: number[3] }} | null
   */
  function traceRay3D(objPt, rayDir, n1, surf, n2) {
    var x0 = objPt[0], y0 = objPt[1], z0 = objPt[2];
    var a = rayDir[0], b = rayDir[1], c = rayDir[2];

    // Radius handling
    var R = Math.abs(surf.radius);
    if (R > 1e12) R = 1e13;    // treat near-infinite as very large
    var K = surf.conic;
    if (Math.abs(K + 1) < 1e-13) K = -1 - 1e-13; // avoid degenerate parabola case
    var cs = surf.radius < 0 ? -1 : 1;  // curve sign

    /* ---- Closed-form t parameter ---- */
    var Kc = K;  // readability aliases
    var a2 = a*a, b2 = b*b, c2 = c*c;
    var x02 = x0*x0, y02 = y0*y0, z02 = z0*z0;

    var denom = Kc*c2 + a2 + b2 + c2;
    if (Math.abs(denom) < 1e-30) return null;

    // Discriminant under the square root
    var disc =
        -Kc*a2*z02 + 2*Kc*a*c*x0*z0 - Kc*b2*z02 + 2*Kc*b*c*y0*z0
      - Kc*c2*x02 - Kc*c2*y02 + R*R*c2
      + cs*(2*R*a2*z0 - 2*R*a*c*x0 + 2*R*b2*z0 - 2*R*b*c*y0)
      - a2*y02 - a2*z02 + 2*a*b*x0*y0 + 2*a*c*x0*z0
      - b2*x02 - b2*z02 + 2*b*c*y0*z0 - c2*x02 - c2*y02;

    if (disc < 0) return null;  // no intersection

    var t = (
        -Kc*c*z0 + cs*R*c - a*x0 - b*y0 - c*z0
        - cs * Math.sqrt(disc)
    ) / denom;

    // Intersection point
    var hx = x0 + t*a;
    var hy = y0 + t*b;
    var hz = z0 + t*c;

    /* ---- Surface normal (analytic partial derivatives of conic sag) ---- */
    var hxy2 = hx*hx + hy*hy;
    var innerSq = R*R - (K+1)*hxy2;
    if (innerSq < 0) return null;
    var sqrtInner = Math.sqrt(innerSq);
    var denom2 = R + sqrtInner;
    if (Math.abs(denom2) < 1e-30) return null;

    // dz/dx and dz/dy at the hit point
    var kp1 = K + 1;
    var commonFrac = cs * kp1 * hxy2 / (denom2 * denom2 * sqrtInner);
    var dzdx = commonFrac * hx + cs * 2 * hx / denom2;
    var dzdy = commonFrac * hy + cs * 2 * hy / denom2;

    // Normal pointing back toward incoming ray (−z direction)
    var nx = dzdx, ny = dzdy, nz = -1;
    var nMag = Math.sqrt(nx*nx + ny*ny + nz*nz);
    nx /= nMag; ny /= nMag; nz /= nMag;

    /* ---- Vector Snell's law ---- */
    var n = n1 / n2;
    var rMag = Math.sqrt(a*a + b*b + c*c);
    var ru = [a/rMag, b/rMag, c/rMag];

    var cosI = -(nx*ru[0] + ny*ru[1] + nz*ru[2]);
    if (cosI < 0) {
      // Flip normal
      nx = -nx; ny = -ny; nz = -nz;
      cosI = -cosI;
    }

    var sinT2 = n*n * (1 - cosI*cosI);
    if (sinT2 > 1) return null; // TIR

    var cosT = Math.sqrt(1 - sinT2);
    var factor = n * cosI - cosT;
    var dx = n*ru[0] + factor*nx;
    var dy = n*ru[1] + factor*ny;
    var dz = n*ru[2] + factor*nz;

    // Normalize
    var dMag = Math.sqrt(dx*dx + dy*dy + dz*dz);
    dx /= dMag; dy /= dMag; dz /= dMag;

    return { hit: [hx, hy, hz], dir: [dx, dy, dz] };
  }

  /* ================================================================
   *  2D TRACE  (cross-section: x = optical axis, y = height)
   *  Maps to 3D:  obj = [0, y, x], dir = [0, slope, 1]
   * ================================================================ */

  /**
   * Trace a ray through the full system in 2D.
   * @param {Design} design
   * @param {number} height — initial ray height (y in 2D)
   * @param {number} slope  — initial dy/dx in 2D (0 = parallel to axis)
   * @param {number} wavelength — μm
   * @param {boolean} skipClip — if true, don't clip at aperture
   * @returns {Array<{x1,y1,x2,y2,slope}>} segments, or null if blocked
   */
  function traceRay2D(design, height, slope, wavelength, skipClip) {
    var surfs = design.surfaces;
    if (surfs.length === 0) return null;

    var segments = [];
    var curX = 0;   // accumulated z position (surface vertex in design coords)
    var curY = height;
    var curSlope = slope;
    var curN = design.initialMaterial.getN(wavelength);

    for (var i = 0; i < surfs.length; i++) {
      var s = surfs[i];
      var n2 = s.material.getN(wavelength);

      // Map 2D → 3D
      var objPt = [0, curY, 0];       // origin at current surface vertex (shifted)
      var rayDir = [0, curSlope, 1];   // direction in 3D

      var result = traceRay3D(objPt, rayDir, curN, s, n2);
      if (!result) return null;

      var hitZ = result.hit[2]; // axial distance from surface vertex
      var hitY = result.hit[1];

      // Aperture check
      if (!skipClip && Math.abs(hitY) > s.aperture) return null;

      // New slope = dy/dz in 3D
      var newSlope = (Math.abs(result.dir[2]) < 1e-15) ? 1e10 : result.dir[1] / result.dir[2];

      segments.push({
        x1: curX, y1: curY,
        x2: curX + hitZ, y2: hitY,
        slope: newSlope
      });

      // Advance to next surface vertex
      curX += s.thickness;
      // New ray origin relative to next vertex
      curY = hitY + newSlope * (s.thickness - hitZ);
      curSlope = newSlope;
      curN = n2;
    }

    // Extend final ray to image plane (thickness of last surface)
    // Already captured in segments — the last segment ends at the last surface hit.
    // Add one more segment from last hit to image plane if needed.
    return segments;
  }

  /* ================================================================
   *  3D SYSTEM TRACE — returns segment list in absolute coords
   * ================================================================ */

  /**
   * @param {Design} design
   * @param {number[3]} objPt  — absolute ray origin
   * @param {number[3]} rayDir — ray direction
   * @param {number} wavelength
   * @param {object} [opts]
   *   .skipClip   — boolean, skip aperture clipping
   *   .backstopZ  — if set, append a backstop at this z
   * @returns {Array<{src: number[3], dst: number[3]}>} | null
   */
  function traceSystem3D(design, objPt, rayDir, wavelength, opts) {
    opts = opts || {};
    var surfs = design.surfaces.slice();

    // Optionally append backstop
    if (opts.backstopZ !== undefined) {
      var lastSurfZ = 0;
      for (var k = 0; k < surfs.length; k++) lastSurfZ += surfs[k].thickness;
      var backstop = M.Surface.createBackstop();
      backstop.thickness = 0;
      // We'll handle backstop manually
    }

    var segments = [];
    var curPt = objPt.slice();
    var curDir = Vec.norm(rayDir);
    var curN = design.initialMaterial.getN(wavelength);
    var zAccum = 0; // accumulated z to surface vertex

    for (var i = 0; i < surfs.length; i++) {
      var s = surfs[i];
      var n2 = s.material.getN(wavelength);

      // Transform ray origin to surface-local coords
      var localPt = [curPt[0], curPt[1], curPt[2] - zAccum];

      var result = traceRay3D(localPt, curDir, curN, s, n2);
      if (!result) return null;

      // Aperture check
      var hitR = Math.sqrt(result.hit[0]*result.hit[0] + result.hit[1]*result.hit[1]);
      if (!opts.skipClip && hitR > s.aperture) return null;

      // Convert hit back to absolute coords
      var absDst = [result.hit[0], result.hit[1], result.hit[2] + zAccum];

      segments.push({ src: curPt.slice(), dst: absDst });

      curPt = absDst;
      curDir = result.dir;
      curN = n2;
      zAccum += s.thickness;
    }

    // Extend to image plane (backstop)
    if (Math.abs(curDir[2]) > 1e-15) {
      var tToImage = (zAccum - curPt[2]) / curDir[2];
      if (tToImage > 0) {
        var imgPt = Vec.add(curPt, Vec.scale(curDir, tToImage));
        segments.push({ src: curPt.slice(), dst: imgPt });
      }
    }

    return segments;
  }

  /* ================================================================
   *  BEAM RAY GENERATION  (fan of rays for a given field angle)
   * ================================================================ */

  /**
   * Generate a fan of input rays for the 2D cross-section view.
   * Supports both infinite conjugate (collimated) and finite object distance.
   *
   * Infinite:  parallel rays at height h, slope from field angle
   * Finite:    rays diverge from object point at (-objectDistance, objHeight)
   *            through the entrance pupil (beam radius)
   *
   * @param {Design} design
   * @param {number} fieldAngleDeg — half-field angle in degrees (infinite) or object height selector (finite)
   * @param {number} [numRays] — override design.raysPerBeam
   * @returns {Array<{height: number, slope: number}>} — 2D rays
   */
  function generateBeamRays2D(design, fieldAngleDeg, numRays) {
    numRays = numRays || design.raysPerBeam;
    var rays = [];
    var objDist = design.objectDistance;

    if (!isFinite(objDist)) {
      // Infinite conjugate: collimated beam
      var slopeAngle = fieldAngleDeg * Math.PI / 180;
      var slope = Math.tan(slopeAngle);
      for (var i = 0; i < numRays; i++) {
        var frac = numRays <= 1 ? 0 : (2 * i / (numRays - 1) - 1);
        var h = design.beamRadius * frac;
        rays.push({ height: h, slope: slope });
      }
    } else {
      // Finite conjugate: rays diverge from object point
      // Object is at z = -objDist, y = objHeight
      // objHeight from field angle: tan(angle) * objDist
      var objHeight = Math.tan(fieldAngleDeg * Math.PI / 180) * objDist;
      for (var j = 0; j < numRays; j++) {
        var frac2 = numRays <= 1 ? 0 : (2 * j / (numRays - 1) - 1);
        var pupilH = design.beamRadius * frac2;
        // slope = (pupilH - objHeight) / objDist
        var s = (pupilH - objHeight) / objDist;
        rays.push({ height: pupilH, slope: s });
      }
    }
    return rays;
  }

  /**
   * Generate 3D input rays for spot diagram / PSF.
   * Grid pattern across the entrance pupil.
   * Supports finite object distance (rays diverge from object point).
   * @param {Design} design
   * @param {number} fieldAngleDeg
   * @param {number} numRays — total rays (gridded)
   * @returns {Array<{origin: number[3], dir: number[3]}>}
   */
  function generateBeamRays3D(design, fieldAngleDeg, numRays) {
    var gridN = Math.max(3, Math.round(Math.sqrt(numRays)));
    var rays = [];
    var R = design.beamRadius;
    var objDist = design.objectDistance;

    if (!isFinite(objDist)) {
      // Infinite conjugate: collimated beam
      var slopeAngle = fieldAngleDeg * Math.PI / 180;
      var dirZ = Math.cos(slopeAngle);
      var dirY = Math.sin(slopeAngle);

      for (var ix = -gridN; ix <= gridN; ix++) {
        for (var iy = -gridN; iy <= gridN; iy++) {
          var x = R * ix / gridN;
          var y = R * iy / gridN;
          if (x*x + y*y > R*R) continue;
          rays.push({ origin: [x, y, 0], dir: [0, dirY, dirZ] });
        }
      }
    } else {
      // Finite conjugate: rays from object point through pupil grid
      var objHeight = Math.tan(fieldAngleDeg * Math.PI / 180) * objDist;

      for (var jx = -gridN; jx <= gridN; jx++) {
        for (var jy = -gridN; jy <= gridN; jy++) {
          var px = R * jx / gridN;
          var py = R * jy / gridN;
          if (px*px + py*py > R*R) continue;
          // Direction from object point (-objDist on z-axis, objHeight on y-axis)
          // to pupil point (px, py, 0)
          var dx = px;                  // x: 0 → px
          var dy = py - objHeight;      // y: objHeight → py
          var dz = objDist;             // z: -objDist → 0
          var mag = Math.sqrt(dx*dx + dy*dy + dz*dz);
          rays.push({ origin: [px, py, 0], dir: [dx/mag, dy/mag, dz/mag] });
        }
      }
    }
    return rays;
  }

  /* ================================================================
   *  SPOT DIAGRAM  — trace grid of rays, collect image-plane hits
   * ================================================================ */

  /**
   * @param {Design} design
   * @param {number} fieldAngleDeg
   * @param {number} wavelength
   * @param {number} [numRays] — grid density (default 200)
   * @returns {Array<{x: number, y: number}>} — image plane hits
   */
  function computeSpotDiagram(design, fieldAngleDeg, wavelength, numRays) {
    numRays = numRays || 200;
    var rays = generateBeamRays3D(design, fieldAngleDeg, numRays);
    var spots = [];

    for (var i = 0; i < rays.length; i++) {
      var segs = traceSystem3D(design, rays[i].origin, rays[i].dir, wavelength, { skipClip: false });
      if (!segs || segs.length === 0) continue;
      var last = segs[segs.length - 1].dst;
      spots.push({ x: last[0], y: last[1] });
    }
    return spots;
  }

  /* ================================================================
   *  RAY ABERRATION — plot pupil height vs image-plane deviation
   * ================================================================ */

  /**
   * @param {Design} design
   * @param {number} fieldAngleDeg
   * @param {number} wavelength
   * @param {number} [numRays] — fan ray count
   * @returns {Array<{h: number, dy: number}>}
   */
  function computeRayAberration(design, fieldAngleDeg, wavelength, numRays) {
    numRays = numRays || 50;
    var R = design.beamRadius;
    var points = [];
    var objDist = design.objectDistance;

    // Helper: compute ray direction for a given pupil height
    function rayDir3D(pupilY) {
      if (!isFinite(objDist)) {
        var sa = fieldAngleDeg * Math.PI / 180;
        return [0, Math.sin(sa), Math.cos(sa)];
      } else {
        var objH = Math.tan(fieldAngleDeg * Math.PI / 180) * objDist;
        var dy = pupilY - objH;
        var mag = Math.sqrt(dy*dy + objDist*objDist);
        return [0, dy/mag, objDist/mag];
      }
    }

    // First trace the chief ray (h=0) to get reference
    var chiefSegs = traceSystem3D(design, [0, 0, 0], rayDir3D(0), wavelength, { skipClip: true });
    var chiefY = 0;
    if (chiefSegs && chiefSegs.length > 0) {
      chiefY = chiefSegs[chiefSegs.length - 1].dst[1];
    }

    for (var i = 0; i < numRays; i++) {
      var frac = 2 * i / (numRays - 1) - 1;
      var h = R * frac;
      var segs = traceSystem3D(design, [0, h, 0], rayDir3D(h), wavelength, { skipClip: true });
      if (!segs || segs.length === 0) continue;
      var imgY = segs[segs.length - 1].dst[1];
      points.push({ h: frac, dy: imgY - chiefY });
    }
    return points;
  }

  /* ================================================================
   *  CHROMATIC ABERRATION  — axial and lateral color
   * ================================================================ */

  /**
   * Compute axial chromatic aberration (focus shift between wavelengths).
   * @param {Design} design
   * @returns {{ axial: number, lateral: number, fCenter: number, fShort: number, fLong: number }}
   */
  function computeChromaticAberration(design) {
    var fC = design.focalLength(design.wavelengthCenter);
    var fS = design.focalLength(design.wavelengthShort);
    var fL = design.focalLength(design.wavelengthLong);
    return {
      fCenter: fC,
      fShort:  fS,
      fLong:   fL,
      axial:   fL - fS,     // longitudinal chromatic aberration
      lateral: 0             // TODO: compute transverse CA from off-axis ray trace
    };
  }

  /* ================================================================
   *  OPTICAL METRICS
   * ================================================================ */

  /**
   * Compute key optical metrics for the design.
   * @param {Design} design
   * @returns {object}
   */
  function computeMetrics(design) {
    var f = design.focalLength(design.wavelengthCenter);
    var D = design.beamRadius * 2;
    var fNum = Math.abs(f) / D;
    var NA = 1 / (2 * fNum);  // approximate for object at infinity
    var totalLen = design.totalLength();
    var objDist = design.objectDistance;

    // Magnification for finite conjugate: thin lens 1/v - 1/u = 1/f
    // u = -objDist (object to the left), so 1/v = 1/f + 1/u = 1/f - 1/objDist
    var magnification = null;
    if (isFinite(objDist) && isFinite(f) && Math.abs(f) > 0.01) {
      var invV = 1/f - 1/objDist;
      if (Math.abs(invV) > 1e-15) {
        var v = 1 / invV;
        magnification = -v / objDist;  // m = v/u = v/(-objDist) → -v/objDist
      }
    }

    return {
      focalLength:   f,
      fNumber:       fNum,
      NA:            NA,
      diameter:      D,
      totalLength:   totalLen,
      power:         1000 / f,   // diopters
      objectDistance: objDist,
      magnification: magnification
    };
  }

  /* ================================================================
   *  FULL 2D TRACE  — convenience: trace all beams for rendering
   * ================================================================ */

  /**
   * Trace all beams (on-axis + off-axis if FOV > 0) for 2D rendering.
   * @param {Design} design
   * @param {number} wavelength
   * @returns {Array<{angle: number, color: string, segments: Array}>}
   */
  function traceAllBeams2D(design, wavelength) {
    var beams = [];
    var halfFov = design.fovAngle / 2;

    // Color assignment
    var colors;
    if (halfFov < 0.01) {
      colors = { 0: '#f97316' }; // orange — on-axis only
    } else {
      colors = {
        0:   '#f97316',     // orange — on-axis
        0.5: '#eab308',     // gold — half-FOV
        1:   '#ef4444'      // red — full-FOV
      };
    }

    var angles = [0];
    if (halfFov >= 0.01) {
      angles.push(halfFov / 2);
      angles.push(halfFov);
    }

    for (var ai = 0; ai < angles.length; ai++) {
      var angle = angles[ai];
      var colorKey = (halfFov < 0.01) ? 0 : (angle / halfFov);
      var color = colors[colorKey] || '#f97316';

      var fanRays = generateBeamRays2D(design, angle);
      var allSegs = [];
      var inputSlopes = [];

      for (var ri = 0; ri < fanRays.length; ri++) {
        var segs = traceRay2D(design, fanRays[ri].height, fanRays[ri].slope, wavelength, false);
        if (segs) {
          allSegs.push(segs);
          inputSlopes.push(fanRays[ri].slope);
        }
      }

      beams.push({ angle: angle, color: color, raySegments: allSegs, inputSlopes: inputSlopes });

      // Symmetric negative beam
      if (design.symBeams && angle > 0.01) {
        var negFan = generateBeamRays2D(design, -angle);
        var negSegs = [];
        var negInputSlopes = [];
        for (var ni = 0; ni < negFan.length; ni++) {
          var ns = traceRay2D(design, negFan[ni].height, negFan[ni].slope, wavelength, false);
          if (ns) {
            negSegs.push(ns);
            negInputSlopes.push(negFan[ni].slope);
          }
        }
        var negColor = colorKey === 0.5 ? '#22c55e' : '#fb923c'; // green, salmon
        beams.push({ angle: -angle, color: negColor, raySegments: negSegs, inputSlopes: negInputSlopes });
      }
    }

    return beams;
  }

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.ODTrace = {
    traceRay3D:              traceRay3D,
    traceRay2D:              traceRay2D,
    traceSystem3D:           traceSystem3D,
    generateBeamRays2D:      generateBeamRays2D,
    generateBeamRays3D:      generateBeamRays3D,
    computeSpotDiagram:      computeSpotDiagram,
    computeRayAberration:    computeRayAberration,
    computeChromaticAberration: computeChromaticAberration,
    computeMetrics:          computeMetrics,
    traceAllBeams2D:         traceAllBeams2D
  };

})(window);
