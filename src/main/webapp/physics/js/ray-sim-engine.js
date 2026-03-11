/**
 * Ray Optics Simulator — Tracing Engine
 * ES5 IIFE, depends on RayScene
 *
 * Exports: window.RayEngine
 *   .traceAll(scene)             — trace all rays, returns array of ray paths
 *   .Vec                         — 2D vector helpers
 *   .intersectRaySegment(ray, p1, p2)
 *   .intersectRayCircle(ray, cx, cy, r)
 *   .reflect(dx, dy, nx, ny)
 *   .refract(dx, dy, nx, ny, n1, n2)
 */
;(function (win) {
  'use strict';

  var S = win.RayScene;
  var EPS = 1e-9;
  var MIN_BRIGHTNESS = 0.01;

  /* ================================================================
   *  2D VECTOR HELPERS
   * ================================================================ */

  var Vec = {
    add:    function (a, b) { return { x: a.x + b.x, y: a.y + b.y }; },
    sub:    function (a, b) { return { x: a.x - b.x, y: a.y - b.y }; },
    scale:  function (v, s) { return { x: v.x * s, y: v.y * s }; },
    dot:    function (a, b) { return a.x * b.x + a.y * b.y; },
    cross:  function (a, b) { return a.x * b.y - a.y * b.x; },
    len:    function (v) { return Math.sqrt(v.x * v.x + v.y * v.y); },
    len2:   function (v) { return v.x * v.x + v.y * v.y; },
    norm:   function (v) {
      var l = Math.sqrt(v.x * v.x + v.y * v.y);
      return l > EPS ? { x: v.x / l, y: v.y / l } : { x: 0, y: 0 };
    },
    perp:   function (v) { return { x: -v.y, y: v.x }; },
    rotate: function (v, a) {
      var c = Math.cos(a), s = Math.sin(a);
      return { x: v.x * c - v.y * s, y: v.x * s + v.y * c };
    },
    dist:   function (a, b) {
      var dx = a.x - b.x, dy = a.y - b.y;
      return Math.sqrt(dx * dx + dy * dy);
    }
  };

  /* ================================================================
   *  RAY–GEOMETRY INTERSECTIONS
   * ================================================================ */

  /**
   * Ray vs line segment.
   * Ray: origin (ox,oy), direction (dx,dy)
   * Segment: p1 to p2
   * Returns {t, point, normal} or null.
   * Normal points to the LEFT of the segment direction (p1→p2).
   */
  function intersectRaySegment(ray, p1, p2) {
    var ex = p2.x - p1.x, ey = p2.y - p1.y;
    var denom = ray.dx * ey - ray.dy * ex;
    if (Math.abs(denom) < EPS) return null; // parallel

    var fx = p1.x - ray.ox, fy = p1.y - ray.oy;
    var t = (fx * ey - fy * ex) / denom;
    var u = (fx * ray.dy - fy * ray.dx) / denom;

    if (t < EPS || u < -EPS || u > 1 + EPS) return null;

    var px = ray.ox + ray.dx * t;
    var py = ray.oy + ray.dy * t;

    // Normal: perpendicular to edge, pointing left of (p1→p2)
    var nl = Vec.norm({ x: -ey, y: ex });

    return { t: t, point: { x: px, y: py }, normal: nl };
  }

  /**
   * Ray vs circle.
   * Returns array of {t, point, normal} (0, 1, or 2 hits), sorted by t.
   * Normal points outward (away from center).
   */
  function intersectRayCircle(ray, cx, cy, radius) {
    var fx = ray.ox - cx, fy = ray.oy - cy;
    var a = ray.dx * ray.dx + ray.dy * ray.dy;
    var b = 2 * (fx * ray.dx + fy * ray.dy);
    var c = fx * fx + fy * fy - radius * radius;
    var disc = b * b - 4 * a * c;
    if (disc < 0) return [];

    var sqrtD = Math.sqrt(disc);
    var hits = [];
    var t1 = (-b - sqrtD) / (2 * a);
    var t2 = (-b + sqrtD) / (2 * a);

    if (t1 > EPS) {
      var px1 = ray.ox + ray.dx * t1, py1 = ray.oy + ray.dy * t1;
      hits.push({
        t: t1,
        point: { x: px1, y: py1 },
        normal: Vec.norm({ x: px1 - cx, y: py1 - cy })
      });
    }
    if (t2 > EPS && Math.abs(t2 - t1) > EPS) {
      var px2 = ray.ox + ray.dx * t2, py2 = ray.oy + ray.dy * t2;
      hits.push({
        t: t2,
        point: { x: px2, y: py2 },
        normal: Vec.norm({ x: px2 - cx, y: py2 - cy })
      });
    }
    return hits;
  }

  /**
   * Ray vs circular arc.
   * Arc defined by center, radius, startAngle, endAngle (radians).
   * Returns array of {t, point, normal} for hits within the arc span.
   */
  function intersectRayArc(ray, arc) {
    var hits = intersectRayCircle(ray, arc.center.x, arc.center.y, arc.radius);
    var result = [];
    for (var i = 0; i < hits.length; i++) {
      var h = hits[i];
      var a = Math.atan2(h.point.y - arc.center.y, h.point.x - arc.center.x);
      if (isAngleInArc(a, arc.startAngle, arc.endAngle)) {
        result.push(h);
      }
    }
    return result;
  }

  /** Check if angle a is within arc [start, end], handling wraparound */
  function isAngleInArc(a, start, end) {
    // Normalize all angles to [0, 2π)
    var TWO_PI = 2 * Math.PI;
    a = ((a % TWO_PI) + TWO_PI) % TWO_PI;
    start = ((start % TWO_PI) + TWO_PI) % TWO_PI;
    end = ((end % TWO_PI) + TWO_PI) % TWO_PI;

    if (start <= end) {
      return a >= start - EPS && a <= end + EPS;
    } else {
      // Arc wraps around 0
      return a >= start - EPS || a <= end + EPS;
    }
  }

  /* ================================================================
   *  PHYSICS: REFLECTION & REFRACTION
   * ================================================================ */

  /**
   * Reflect direction (dx,dy) about normal (nx,ny).
   * Returns {x,y} — reflected direction.
   */
  function reflect(dx, dy, nx, ny) {
    var dot2 = 2 * (dx * nx + dy * ny);
    return { x: dx - dot2 * nx, y: dy - dot2 * ny };
  }

  /**
   * Refract direction (dx,dy) through surface with normal (nx,ny).
   * n1 = incoming medium, n2 = outgoing medium.
   * Normal points FROM n2 side TOWARD n1 side.
   * Returns {x,y} or null (total internal reflection).
   */
  function refract(dx, dy, nx, ny, n1, n2) {
    var ratio = n1 / n2;
    var cosI = -(dx * nx + dy * ny); // dot(incident, normal), negated
    var sin2T = ratio * ratio * (1 - cosI * cosI);
    if (sin2T > 1) return null; // TIR
    var cosT = Math.sqrt(1 - sin2T);
    return {
      x: ratio * dx + (ratio * cosI - cosT) * nx,
      y: ratio * dy + (ratio * cosI - cosT) * ny
    };
  }

  /**
   * Fresnel reflectance (unpolarized average) for given angles.
   * Returns value between 0 and 1.
   */
  function fresnelReflectance(cosI, n1, n2) {
    var sinI2 = 1 - cosI * cosI;
    var ratio = n1 / n2;
    var sin2T = ratio * ratio * sinI2;
    if (sin2T > 1) return 1; // TIR
    var cosT = Math.sqrt(1 - sin2T);
    var rs = (n1 * cosI - n2 * cosT) / (n1 * cosI + n2 * cosT);
    var rp = (n2 * cosI - n1 * cosT) / (n2 * cosI + n1 * cosT);
    return (rs * rs + rp * rp) / 2;
  }

  /* ================================================================
   *  IDEAL LENS DEFLECTION
   * ================================================================ */

  /**
   * Deflect a ray through an ideal thin lens.
   * The lens line goes from p1 to p2; focal length is f.
   * Returns new direction {x,y}.
   */
  function idealLensDeflect(ray, hitPoint, p1, p2, focalLength) {
    // Lens axis direction (perpendicular to the lens line)
    var lx = p2.x - p1.x, ly = p2.y - p1.y;
    var lLen = Math.sqrt(lx * lx + ly * ly);
    // Optical axis direction: perpendicular to lens, choose consistent side
    var ax = -ly / lLen, ay = lx / lLen;
    // If ray is going against the axis, flip
    if (ray.dx * ax + ray.dy * ay < 0) { ax = -ax; ay = -ay; }

    // Height on the lens (signed distance from lens center along lens direction)
    var midX = (p1.x + p2.x) / 2, midY = (p1.y + p2.y) / 2;
    var hx = hitPoint.x - midX, hy = hitPoint.y - midY;
    var h = (hx * lx + hy * ly) / lLen; // signed height

    // Input angle relative to optical axis
    // Component along lens line (dot product with l̂) gives sin(θ)
    // Component along optical axis (dot product with â) gives cos(θ)
    var inAngle = Math.atan2(
      ray.dx * lx / lLen + ray.dy * ly / lLen,
      ray.dx * ax + ray.dy * ay
    );

    // Thin lens equation: outAngle = inAngle - h/f
    var outAngle = inAngle - h / focalLength;

    // Convert back to direction
    return {
      x: ax * Math.cos(outAngle) + (lx / lLen) * Math.sin(outAngle),
      y: ay * Math.cos(outAngle) + (ly / lLen) * Math.sin(outAngle)
    };
  }

  /* ================================================================
   *  DIFFRACTION
   * ================================================================ */

  /**
   * Compute diffraction output angles for a grating.
   * d = grating period (μm), wavelength (μm), incidentAngle (radians from normal).
   * Returns array of { order, angle } for valid orders.
   * Grating equation: d * (sin(θ_out) - sin(θ_in)) = m * λ
   */
  function diffractionOrders(gratingPeriod, wavelength, sinIn, maxOrder) {
    var orders = [];
    if (!wavelength || wavelength <= 0) {
      // White light: just transmit (order 0)
      orders.push({ order: 0, sinOut: sinIn, brightness: 1 });
      return orders;
    }
    for (var m = -maxOrder; m <= maxOrder; m++) {
      var sinOut = sinIn + m * wavelength / gratingPeriod;
      if (sinOut >= -1 && sinOut <= 1) {
        // Simple intensity model: 0th order strongest, higher orders weaker
        var intensity = m === 0 ? 0.4 : 0.3 / (Math.abs(m));
        orders.push({ order: m, sinOut: sinOut, brightness: intensity });
      }
    }
    return orders;
  }

  /* ================================================================
   *  GRIN MEDIUM TRACING
   * ================================================================ */

  /**
   * Trace a ray through a GRIN (gradient-index) medium using Euler integration.
   * Returns { segments: [...], exitPoint, exitDir, exitN }
   */
  function traceGrinMedium(entryPoint, entryDir, grinObj, bgN) {
    var cx = grinObj.x, cy = grinObj.y, R = grinObj.radius;
    var R2 = R * R;
    var stepSize = R / 50; // adaptive step size
    var maxSteps = 2000;

    // Refract at entry
    var dx0 = entryPoint.x - cx, dy0 = entryPoint.y - cy;
    var entryN = grinObj.getNAt(entryPoint.x, entryPoint.y);
    var outNorm = Vec.norm({ x: dx0, y: dy0 }); // outward normal
    var cosI = -(entryDir.x * outNorm.x + entryDir.y * outNorm.y);
    var entering = cosI > 0;
    var n1, n2, norm;
    if (entering) {
      n1 = bgN; n2 = entryN;
      norm = outNorm;
    } else {
      n1 = entryN; n2 = bgN;
      norm = { x: -outNorm.x, y: -outNorm.y };
      cosI = -cosI;
    }
    var refr = refract(entryDir.x, entryDir.y, norm.x, norm.y, n1, n2);
    if (!refr) {
      // TIR at entry — reflect
      var tirR = reflect(entryDir.x, entryDir.y, norm.x, norm.y);
      return { segments: [], exitPoint: entryPoint, exitDir: tirR, exitN: bgN };
    }

    var px = entryPoint.x, py = entryPoint.y;
    var ddx = refr.x, ddy = refr.y;
    var segments = [];

    for (var step = 0; step < maxSteps; step++) {
      var nx = px + ddx * stepSize;
      var ny = py + ddy * stepSize;

      // Check if exited circle
      var dr2 = (nx - cx) * (nx - cx) + (ny - cy) * (ny - cy);
      if (dr2 > R2) {
        // Find exact exit using line-circle intersection
        var tExit = lineCircleExitT(px, py, ddx, ddy, cx, cy, R);
        var ex = px + ddx * tExit, ey = py + ddy * tExit;
        if (tExit > EPS) {
          segments.push({ x1: px, y1: py, x2: ex, y2: ey });
        }
        // Refract at exit
        var exitOutN = Vec.norm({ x: ex - cx, y: ey - cy });
        var exitN = grinObj.getNAt(ex, ey);
        var exitRefr = refract(ddx, ddy, { x: -exitOutN.x, y: -exitOutN.y }.x,
                               { x: -exitOutN.x, y: -exitOutN.y }.y, exitN, bgN);
        if (!exitRefr) {
          // TIR — reflect back inside
          var tirR2 = reflect(ddx, ddy, { x: -exitOutN.x, y: -exitOutN.y }.x,
                              { x: -exitOutN.x, y: -exitOutN.y }.y);
          ddx = tirR2.x; ddy = tirR2.y;
          px = ex - exitOutN.x * EPS * 10;
          py = ey - exitOutN.y * EPS * 10;
          continue;
        }
        return {
          segments: segments,
          exitPoint: { x: ex + exitRefr.x * EPS * 10, y: ey + exitRefr.y * EPS * 10 },
          exitDir: exitRefr,
          exitN: bgN
        };
      }

      // Record curved segment
      segments.push({ x1: px, y1: py, x2: nx, y2: ny });

      // Update direction: d/ds(n * t) = grad(n)
      var nHere = grinObj.getNAt(nx, ny);
      var grad = grinObj.getGradN(nx, ny);
      ddx += grad.x / nHere * stepSize;
      ddy += grad.y / nHere * stepSize;
      var dLen = Math.sqrt(ddx * ddx + ddy * ddy);
      ddx /= dLen; ddy /= dLen;

      px = nx; py = ny;
    }

    // Didn't exit — stuck inside (shouldn't happen normally)
    return { segments: segments, exitPoint: { x: px, y: py }, exitDir: { x: ddx, y: ddy }, exitN: bgN };
  }

  /** Helper: find t where line from (px,py) in direction (dx,dy) exits circle (cx,cy,R) */
  function lineCircleExitT(px, py, dx, dy, cx, cy, R) {
    var fx = px - cx, fy = py - cy;
    var a = dx * dx + dy * dy;
    var b = 2 * (fx * dx + fy * dy);
    var c = fx * fx + fy * fy - R * R;
    var disc = b * b - 4 * a * c;
    if (disc < 0) return 0;
    var t = (-b + Math.sqrt(disc)) / (2 * a);
    return t > 0 ? t : 0;
  }

  /* ================================================================
   *  DICHROIC FILTER CHECK
   * ================================================================ */

  /** Returns true if wavelength passes through (NOT reflected) by a dichroic object */
  function dichroicPassesThrough(obj, wavelength) {
    if (!obj || !obj.dichroic) return false;
    if (!wavelength || wavelength <= 0) return false; // white light always interacts
    return wavelength < obj.dichroicMinWL || wavelength > obj.dichroicMaxWL;
  }

  /* ================================================================
   *  IMAGE POINT DETECTION
   * ================================================================ */

  /**
   * Find image points by intersecting backward-extended rays from the same source.
   * Returns array of { x, y, real, sourceId }
   */
  function findImagePoints(paths, scene) {
    var maxExt = Math.max(scene.width, scene.height) * 2;
    // Group paths by sourceId
    var bySource = {};
    for (var i = 0; i < paths.length; i++) {
      var p = paths[i];
      if (!p.sourceId) continue;
      if (!bySource[p.sourceId]) bySource[p.sourceId] = [];
      bySource[p.sourceId].push(p);
    }

    var imagePoints = [];
    for (var sid in bySource) {
      if (!bySource.hasOwnProperty(sid)) continue;
      var group = bySource[sid];
      if (group.length < 2) continue;

      // Get last segment direction for each path
      var rayLines = [];
      for (var gi = 0; gi < group.length; gi++) {
        var segs = group[gi].segments;
        if (segs.length < 1) continue;
        var last = segs[segs.length - 1];
        var ldx = last.x2 - last.x1, ldy = last.y2 - last.y1;
        var llen = Math.sqrt(ldx * ldx + ldy * ldy);
        if (llen < EPS) continue;
        rayLines.push({
          ox: last.x1, oy: last.y1,
          dx: ldx / llen, dy: ldy / llen
        });
      }

      // Find pairwise intersections of extended rays
      if (rayLines.length < 2) continue;
      var sumX = 0, sumY = 0, count = 0;
      for (var a = 0; a < rayLines.length - 1; a++) {
        for (var b = a + 1; b < rayLines.length; b++) {
          var pt = rayRayIntersect(rayLines[a], rayLines[b]);
          if (pt && Math.abs(pt.x) < maxExt && Math.abs(pt.y) < maxExt) {
            sumX += pt.x; sumY += pt.y; count++;
          }
        }
      }
      if (count > 0) {
        var avgX = sumX / count, avgY = sumY / count;
        // Check if it's a real image (rays converge forward) or virtual (backward)
        var sample = rayLines[0];
        var toImg = { x: avgX - sample.ox, y: avgY - sample.oy };
        var isReal = (toImg.x * sample.dx + toImg.y * sample.dy) > 0;
        imagePoints.push({ x: avgX, y: avgY, real: isReal, sourceId: parseInt(sid) });
      }
    }
    return imagePoints;
  }

  /** Find intersection point of two ray-lines (or null if parallel/too far) */
  function rayRayIntersect(r1, r2) {
    var denom = r1.dx * r2.dy - r1.dy * r2.dx;
    if (Math.abs(denom) < EPS) return null;
    var fx = r2.ox - r1.ox, fy = r2.oy - r1.oy;
    var t = (fx * r2.dy - fy * r2.dx) / denom;
    return { x: r1.ox + r1.dx * t, y: r1.oy + r1.dy * t };
  }

  /* ================================================================
   *  OBSERVER MODE
   * ================================================================ */

  /**
   * Filter paths for observer mode: only keep paths whose last segment
   * passes within pupilRadius of the observer position.
   * Modifies paths in place (sets .observerVisible flag).
   */
  function filterForObserver(paths, scene) {
    // Find observer object in scene
    var observer = null;
    for (var i = 0; i < scene.objects.length; i++) {
      if (scene.objects[i].type === 'Observer') {
        observer = scene.objects[i];
        break;
      }
    }
    if (!observer) return;

    var ox = observer.x, oy = observer.y;
    var pr = observer.pupilRadius;

    for (var pi = 0; pi < paths.length; pi++) {
      var segs = paths[pi].segments;
      paths[pi].observerVisible = false;
      if (segs.length < 1) continue;

      // Check if any segment passes near observer
      for (var si = 0; si < segs.length; si++) {
        var seg = segs[si];
        var dist = pointToSegmentDist(ox, oy, seg.x1, seg.y1, seg.x2, seg.y2);
        if (dist <= pr) {
          paths[pi].observerVisible = true;
          break;
        }
      }
    }
  }

  /** Distance from point (px,py) to line segment (x1,y1)-(x2,y2) */
  function pointToSegmentDist(px, py, x1, y1, x2, y2) {
    var dx = x2 - x1, dy = y2 - y1;
    var len2 = dx * dx + dy * dy;
    if (len2 < EPS) return Math.sqrt((px - x1) * (px - x1) + (py - y1) * (py - y1));
    var t = Math.max(0, Math.min(1, ((px - x1) * dx + (py - y1) * dy) / len2));
    var projX = x1 + t * dx, projY = y1 + t * dy;
    return Math.sqrt((px - projX) * (px - projX) + (py - projY) * (py - projY));
  }

  /* ================================================================
   *  POINT-IN-POLYGON (for glass objects)
   * ================================================================ */

  /** Test if point (px,py) is inside a convex polygon (vertices array) */
  function pointInPolygon(px, py, vertices) {
    var n = vertices.length;
    var sign = 0;
    for (var i = 0; i < n; i++) {
      var v1 = vertices[i], v2 = vertices[(i + 1) % n];
      var cross = (v2.x - v1.x) * (py - v1.y) - (v2.y - v1.y) * (px - v1.x);
      if (Math.abs(cross) < EPS) continue;
      if (sign === 0) sign = cross > 0 ? 1 : -1;
      else if ((cross > 0 ? 1 : -1) !== sign) return false;
    }
    return true;
  }

  /** Test if point is inside a circle */
  function pointInCircle(px, py, cx, cy, radius) {
    var dx = px - cx, dy = py - cy;
    return dx * dx + dy * dy < radius * radius + EPS;
  }

  /* ================================================================
   *  MAIN RAY TRACING ENGINE
   * ================================================================ */

  /**
   * Trace all rays in a scene.
   * Returns array of ray paths, each path is:
   *   { segments: [{x1,y1,x2,y2}], extendedSegments: [...], color: string, sourceId: number }
   */
  function traceAll(scene) {
    var interactables = collectInteractables(scene);
    var sources = scene.getLightSources();
    var allPaths = [];
    var queue = [];
    var MAX_TOTAL_PATHS = 2000; // safety limit for beam splitters

    for (var si = 0; si < sources.length; si++) {
      var rays = sources[si].generateRays();
      for (var ri = 0; ri < rays.length; ri++) {
        queue.push(rays[ri]);
      }
    }

    while (queue.length > 0 && allPaths.length < MAX_TOTAL_PATHS) {
      var ray = queue.shift();
      var path = traceRay(scene, interactables, ray);
      allPaths.push(path);
      // Enqueue any spawned rays (from beam splitters)
      if (path.spawnedRays) {
        for (var sp = 0; sp < path.spawnedRays.length; sp++) {
          queue.push(path.spawnedRays[sp]);
        }
      }
    }

    // Extended rays mode: back-project rays
    if (scene.rayMode === 'extended' || scene.rayMode === 'images') {
      computeExtendedRays(allPaths, scene);
    }

    // Image point detection
    if (scene.rayMode === 'images') {
      allPaths.imagePoints = findImagePoints(allPaths, scene);
    }

    // Observer mode filtering
    filterForObserver(allPaths, scene);

    return allPaths;
  }

  /**
   * Collect all interactable geometry from scene objects.
   * Returns { segments: [...], circles: [...], arcs: [...] }
   */
  function collectInteractables(scene) {
    var segments = [];
    var circles = [];
    var arcs = [];

    for (var i = 0; i < scene.objects.length; i++) {
      var obj = scene.objects[i];
      // Skip light sources
      if (obj.generateRays) continue;

      if (obj.getCircle) {
        circles.push(obj.getCircle());
      } else if (obj.type === 'CurvedMirror') {
        arcs.push(obj.getArc());
      } else if (obj.getArcs) {
        // SphericalLens: multiple arcs
        var objArcs = obj.getArcs();
        for (var ai = 0; ai < objArcs.length; ai++) {
          arcs.push(objArcs[ai]);
        }
      }
      // Also collect edges (some objects have both arcs and edges, but most have one)
      if (obj.getEdges) {
        var edges = obj.getEdges();
        for (var ei = 0; ei < edges.length; ei++) {
          segments.push(edges[ei]);
        }
      }
    }
    return { segments: segments, circles: circles, arcs: arcs };
  }

  /**
   * Trace a single ray through the scene, collecting segments.
   */
  function traceRay(scene, interactables, ray) {
    var segments = [];
    var spawnedRays = [];
    var curRay = {
      ox: ray.ox, oy: ray.oy,
      dx: ray.dx, dy: ray.dy,
      wavelength: ray.wavelength,
      brightness: ray.brightness
    };
    var color = wavelengthToColor(ray.wavelength);
    var maxExt = Math.max(scene.width, scene.height) * 2;

    for (var bounce = 0; bounce <= scene.maxBounces; bounce++) {
      if (curRay.brightness < MIN_BRIGHTNESS) break;

      var hit = findClosestHit(interactables, curRay);

      if (!hit) {
        // Ray escapes — extend to scene boundary
        segments.push({
          x1: curRay.ox, y1: curRay.oy,
          x2: curRay.ox + curRay.dx * maxExt,
          y2: curRay.oy + curRay.dy * maxExt
        });
        break;
      }

      // Record segment to hit point
      segments.push({
        x1: curRay.ox, y1: curRay.oy,
        x2: hit.point.x, y2: hit.point.y
      });

      // Handle interaction
      var normal = hit.normal;
      var interaction = hit.interaction;

      if (interaction === 'absorb') {
        break;
      }

      if (interaction === 'reflect') {
        // Dichroic check: if wavelength outside band, transmit through
        if (hit.obj && dichroicPassesThrough(hit.obj, curRay.wavelength)) {
          curRay.ox = hit.point.x + curRay.dx * EPS * 10;
          curRay.oy = hit.point.y + curRay.dy * EPS * 10;
          continue;
        }
        var refl = reflect(curRay.dx, curRay.dy, normal.x, normal.y);
        curRay.ox = hit.point.x + refl.x * EPS * 10;
        curRay.oy = hit.point.y + refl.y * EPS * 10;
        curRay.dx = refl.x;
        curRay.dy = refl.y;
        continue;
      }

      if (interaction === 'beam_split') {
        var bsObj = hit.obj;
        // Dichroic beam splitter: out-of-band wavelengths pass through
        if (dichroicPassesThrough(bsObj, curRay.wavelength)) {
          curRay.ox = hit.point.x + curRay.dx * EPS * 10;
          curRay.oy = hit.point.y + curRay.dy * EPS * 10;
          continue;
        }
        var tr = bsObj.transmissionRatio;
        var bsRefl = reflect(curRay.dx, curRay.dy, normal.x, normal.y);
        spawnedRays.push({
          ox: hit.point.x + bsRefl.x * EPS * 10,
          oy: hit.point.y + bsRefl.y * EPS * 10,
          dx: bsRefl.x, dy: bsRefl.y,
          wavelength: curRay.wavelength,
          brightness: curRay.brightness * (1 - tr),
          sourceId: ray.sourceId
        });
        curRay.ox = hit.point.x + curRay.dx * EPS * 10;
        curRay.oy = hit.point.y + curRay.dy * EPS * 10;
        curRay.brightness *= tr;
        continue;
      }

      if (interaction === 'refract') {
        var glassObj = hit.obj;
        var n_glass = glassObj.getN ? glassObj.getN(curRay.wavelength) : 1.5;
        var n_bg = scene.backgroundN;

        var cosI = -(curRay.dx * normal.x + curRay.dy * normal.y);
        var entering = cosI > 0;
        var n1, n2;
        if (entering) {
          n1 = n_bg; n2 = n_glass;
        } else {
          n1 = n_glass; n2 = n_bg;
          normal = { x: -normal.x, y: -normal.y };
          cosI = -cosI;
        }

        var refr = refract(curRay.dx, curRay.dy, normal.x, normal.y, n1, n2);
        if (refr === null) {
          // TIR — reflect
          var tirRefl = reflect(curRay.dx, curRay.dy, normal.x, normal.y);
          curRay.ox = hit.point.x + tirRefl.x * EPS * 10;
          curRay.oy = hit.point.y + tirRefl.y * EPS * 10;
          curRay.dx = tirRefl.x;
          curRay.dy = tirRefl.y;
        } else {
          // Fresnel partial reflection (if enabled)
          if (scene.fresnelEnabled) {
            var R = fresnelReflectance(Math.abs(cosI), n1, n2);
            if (R > 0.01 && curRay.brightness * R > MIN_BRIGHTNESS) {
              var frRefl = reflect(curRay.dx, curRay.dy, normal.x, normal.y);
              spawnedRays.push({
                ox: hit.point.x + frRefl.x * EPS * 10,
                oy: hit.point.y + frRefl.y * EPS * 10,
                dx: frRefl.x, dy: frRefl.y,
                wavelength: curRay.wavelength,
                brightness: curRay.brightness * R,
                sourceId: ray.sourceId
              });
              curRay.brightness *= (1 - R);
            }
          }
          curRay.ox = hit.point.x + refr.x * EPS * 10;
          curRay.oy = hit.point.y + refr.y * EPS * 10;
          curRay.dx = refr.x;
          curRay.dy = refr.y;
        }
        continue;
      }

      if (interaction === 'ideal_lens') {
        var lensObj = hit.obj;
        var edges = lensObj.getEdges();
        var newDir = idealLensDeflect(curRay, hit.point, edges[0].p1, edges[0].p2, lensObj.focalLength);
        curRay.ox = hit.point.x + newDir.x * EPS * 10;
        curRay.oy = hit.point.y + newDir.y * EPS * 10;
        curRay.dx = newDir.x;
        curRay.dy = newDir.y;
        continue;
      }

      if (interaction === 'ideal_mirror') {
        var mirObj = hit.obj;
        var mEdges = mirObj.getEdges();
        // First reflect, then apply focal deflection
        var mRefl = reflect(curRay.dx, curRay.dy, normal.x, normal.y);
        // Use idealLensDeflect on the reflected ray
        var mRay = { ox: curRay.ox, oy: curRay.oy, dx: mRefl.x, dy: mRefl.y };
        var mDir = idealLensDeflect(mRay, hit.point, mEdges[0].p1, mEdges[0].p2, mirObj.focalLength);
        curRay.ox = hit.point.x + mDir.x * EPS * 10;
        curRay.oy = hit.point.y + mDir.y * EPS * 10;
        curRay.dx = mDir.x;
        curRay.dy = mDir.y;
        continue;
      }

      if (interaction === 'diffract') {
        var grObj = hit.obj;
        var period = grObj.getPeriod(); // μm
        // Compute incidence angle relative to grating normal
        var grCosI = -(curRay.dx * normal.x + curRay.dy * normal.y);
        var grSinI = Math.sqrt(Math.max(0, 1 - grCosI * grCosI));
        // Determine sign of sinI
        var tangent = { x: -normal.y, y: normal.x };
        if (curRay.dx * tangent.x + curRay.dy * tangent.y < 0) grSinI = -grSinI;

        var orders = diffractionOrders(period, curRay.wavelength, grSinI, grObj.maxOrder);
        // Spawn all orders except the first (which the current ray becomes)
        var first = true;
        for (var oi = 0; oi < orders.length; oi++) {
          var ord = orders[oi];
          var cosOut = Math.sqrt(Math.max(0, 1 - ord.sinOut * ord.sinOut));
          // Output direction: project onto normal + tangent
          // Transmitted side: same side as incoming
          var outDx = normal.x * (-cosOut) + tangent.x * ord.sinOut;
          var outDy = normal.y * (-cosOut) + tangent.y * ord.sinOut;
          // Flip if ray was going in the other direction
          if (grCosI < 0) { outDx = -outDx; outDy = -outDy; }

          if (first) {
            curRay.ox = hit.point.x + outDx * EPS * 10;
            curRay.oy = hit.point.y + outDy * EPS * 10;
            curRay.dx = outDx; curRay.dy = outDy;
            curRay.brightness *= ord.brightness;
            first = false;
          } else {
            spawnedRays.push({
              ox: hit.point.x + outDx * EPS * 10,
              oy: hit.point.y + outDy * EPS * 10,
              dx: outDx, dy: outDy,
              wavelength: curRay.wavelength,
              brightness: curRay.brightness * ord.brightness,
              sourceId: ray.sourceId
            });
          }
        }
        if (orders.length === 0) break; // no valid orders
        continue;
      }

      if (interaction === 'grin') {
        var grinObj = hit.obj;
        var grinResult = traceGrinMedium(hit.point, { x: curRay.dx, y: curRay.dy },
                                          grinObj, scene.backgroundN);
        for (var gsi = 0; gsi < grinResult.segments.length; gsi++) {
          segments.push(grinResult.segments[gsi]);
        }
        curRay.ox = grinResult.exitPoint.x;
        curRay.oy = grinResult.exitPoint.y;
        curRay.dx = grinResult.exitDir.x;
        curRay.dy = grinResult.exitDir.y;
        continue;
      }

      // Unknown interaction — absorb
      break;
    }

    return {
      segments: segments,
      extendedSegments: [],
      spawnedRays: spawnedRays,
      color: color,
      wavelength: ray.wavelength,
      brightness: ray.brightness,
      sourceId: ray.sourceId
    };
  }

  /**
   * Find the closest intersection of a ray with all interactables.
   */
  function findClosestHit(interactables, ray) {
    var best = null;
    var bestT = Infinity;

    // Segment intersections
    for (var si = 0; si < interactables.segments.length; si++) {
      var seg = interactables.segments[si];
      var hit = intersectRaySegment(ray, seg.p1, seg.p2);
      if (hit && hit.t < bestT) {
        bestT = hit.t;
        best = {
          t: hit.t, point: hit.point, normal: hit.normal,
          interaction: seg.interaction, obj: seg.obj || null
        };
      }
    }

    // Circle intersections
    for (var ci = 0; ci < interactables.circles.length; ci++) {
      var circ = interactables.circles[ci];
      var cHits = intersectRayCircle(ray, circ.cx, circ.cy, circ.radius);
      for (var ch = 0; ch < cHits.length; ch++) {
        if (cHits[ch].t < bestT) {
          bestT = cHits[ch].t;
          best = {
            t: cHits[ch].t, point: cHits[ch].point, normal: cHits[ch].normal,
            interaction: circ.interaction, obj: circ.obj || null
          };
        }
      }
    }

    // Arc intersections
    for (var ai = 0; ai < interactables.arcs.length; ai++) {
      var arc = interactables.arcs[ai];
      var aHits = intersectRayArc(ray, arc);
      for (var ah = 0; ah < aHits.length; ah++) {
        if (aHits[ah].t < bestT) {
          bestT = aHits[ah].t;
          var norm = aHits[ah].normal;
          // For concave mirrors, flip normal inward
          if (arc.concave && arc.interaction === 'reflect') {
            norm = { x: -norm.x, y: -norm.y };
          }
          best = {
            t: aHits[ah].t, point: aHits[ah].point, normal: norm,
            interaction: arc.interaction, obj: arc.obj || null
          };
        }
      }
    }

    return best;
  }

  /* ================================================================
   *  EXTENDED RAYS — backward-project to show virtual images
   * ================================================================ */

  /**
   * Compute backward-projected (extended) ray segments for each path.
   * For each path with ≥2 segments, back-project the last segment to show
   * where the virtual image appears.  Also back-project the first reflected/
   * refracted segment for virtual-object visualization.
   */
  function computeExtendedRays(paths, scene) {
    var maxExt = Math.max(scene.width, scene.height) * 2;
    for (var i = 0; i < paths.length; i++) {
      var segs = paths[i].segments;
      paths[i].extendedSegments = [];
      if (segs.length < 2) continue;

      // Back-project last segment (virtual image location)
      var last = segs[segs.length - 1];
      var ldx = last.x2 - last.x1, ldy = last.y2 - last.y1;
      var llen = Math.sqrt(ldx * ldx + ldy * ldy);
      if (llen > EPS) {
        ldx /= llen; ldy /= llen;
        paths[i].extendedSegments.push({
          x1: last.x1, y1: last.y1,
          x2: last.x1 - ldx * maxExt, y2: last.y1 - ldy * maxExt,
          extended: true
        });
      }

      // Back-project first segment (virtual source location)
      var first = segs[0];
      var fdx = first.x2 - first.x1, fdy = first.y2 - first.y1;
      var flen = Math.sqrt(fdx * fdx + fdy * fdy);
      if (flen > EPS) {
        fdx /= flen; fdy /= flen;
        // Extend from hit point (end of first segment) forward beyond
        paths[i].extendedSegments.push({
          x1: first.x2, y1: first.y2,
          x2: first.x2 + fdx * maxExt, y2: first.y2 + fdy * maxExt,
          extended: true
        });
      }
    }
  }

  /* ================================================================
   *  WAVELENGTH → COLOR
   * ================================================================ */

  /**
   * Convert wavelength (μm) to CSS color string.
   * 0 or undefined = white.
   */
  function wavelengthToColor(wl) {
    if (!wl || wl <= 0) return 'rgba(255,200,50,0.8)'; // warm white

    // Convert μm to nm
    var nm = wl * 1000;
    var r = 0, g = 0, b = 0;

    if (nm >= 380 && nm < 440) {
      r = -(nm - 440) / (440 - 380);
      b = 1;
    } else if (nm >= 440 && nm < 490) {
      g = (nm - 440) / (490 - 440);
      b = 1;
    } else if (nm >= 490 && nm < 510) {
      g = 1;
      b = -(nm - 510) / (510 - 490);
    } else if (nm >= 510 && nm < 580) {
      r = (nm - 510) / (580 - 510);
      g = 1;
    } else if (nm >= 580 && nm < 645) {
      r = 1;
      g = -(nm - 645) / (645 - 580);
    } else if (nm >= 645 && nm <= 780) {
      r = 1;
    }

    // Intensity falloff at edges
    var factor = 1;
    if (nm >= 380 && nm < 420) factor = 0.3 + 0.7 * (nm - 380) / (420 - 380);
    else if (nm > 700 && nm <= 780) factor = 0.3 + 0.7 * (780 - nm) / (780 - 700);
    else if (nm < 380 || nm > 780) factor = 0;

    r = Math.round(255 * Math.pow(r * factor, 0.8));
    g = Math.round(255 * Math.pow(g * factor, 0.8));
    b = Math.round(255 * Math.pow(b * factor, 0.8));

    return 'rgba(' + r + ',' + g + ',' + b + ',0.85)';
  }

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.RayEngine = {
    traceAll:              traceAll,
    traceRay:              traceRay,
    collectInteractables:  collectInteractables,
    findClosestHit:        findClosestHit,
    findImagePoints:       findImagePoints,
    diffractionOrders:     diffractionOrders,
    Vec:                   Vec,
    intersectRaySegment:   intersectRaySegment,
    intersectRayCircle:    intersectRayCircle,
    intersectRayArc:       intersectRayArc,
    reflect:               reflect,
    refract:               refract,
    fresnelReflectance:    fresnelReflectance,
    idealLensDeflect:      idealLensDeflect,
    pointInPolygon:        pointInPolygon,
    pointInCircle:         pointInCircle,
    pointToSegmentDist:    pointToSegmentDist,
    wavelengthToColor:     wavelengthToColor
  };

})(window);
