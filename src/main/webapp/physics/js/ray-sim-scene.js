/**
 * Ray Optics Simulator — Scene Data Model
 * ES5 IIFE, no dependencies
 *
 * Exports: window.RayScene
 *   .Scene        — constructor
 *   .OBJ_TYPES    — registry of object constructors
 *   .createObject — factory
 *   .cauchyN      — Cauchy refractive index n(λ)
 */
;(function (win) {
  'use strict';

  var nextId = 1;
  function uid() { return nextId++; }

  /* ================================================================
   *  Cauchy dispersion:  n(λ) = A + B/λ² + C/λ⁴
   *  λ in micrometers
   * ================================================================ */
  var CAUCHY_PRESETS = {
    'Glass':       { A: 1.5046, B: 0.00420, C: 0 },
    'Crown':       { A: 1.5220, B: 0.00459, C: 0 },
    'Flint':       { A: 1.6200, B: 0.00900, C: 0 },
    'Diamond':     { A: 2.3800, B: 0.01540, C: 0 },
    'Water':       { A: 1.3199, B: 0.00306, C: 0 },
    'Acrylic':     { A: 1.4849, B: 0.00420, C: 0 }
  };

  function cauchyN(wavelength_um, A, B, C) {
    C = C || 0;
    var l2 = wavelength_um * wavelength_um;
    return A + B / l2 + C / (l2 * l2);
  }

  /* ================================================================
   *  Base SceneObject
   * ================================================================ */

  function SceneObject(opts) {
    opts = opts || {};
    this.id = opts.id || uid();
    this.type = opts.type || 'unknown';
    this.x = opts.x || 0;
    this.y = opts.y || 0;
    this.angle = opts.angle || 0; // radians, CCW from +x
    this.locked = !!opts.locked;
  }

  SceneObject.prototype.toJSON = function () {
    return {
      id: this.id, type: this.type,
      x: this.x, y: this.y, angle: this.angle,
      locked: this.locked
    };
  };

  /* ---- Helper: rotate point (px,py) by angle around origin ---- */
  function rotPt(px, py, angle) {
    var c = Math.cos(angle), s = Math.sin(angle);
    return { x: px * c - py * s, y: px * s + py * c };
  }

  /* ---- Helper: transform local coords to world ---- */
  function toWorld(obj, lx, ly) {
    var r = rotPt(lx, ly, obj.angle);
    return { x: obj.x + r.x, y: obj.y + r.y };
  }

  /* ================================================================
   *  LIGHT SOURCES
   * ================================================================ */

  // ---- Point Source ----
  function PointSource(opts) {
    opts = opts || {};
    opts.type = 'PointSource';
    SceneObject.call(this, opts);
    this.numRays = opts.numRays || 36;
    this.brightness = opts.brightness !== undefined ? opts.brightness : 1;
    this.wavelength = opts.wavelength || 0;  // 0 = white
    this.spreadAngle = opts.spreadAngle !== undefined ? opts.spreadAngle : 360; // degrees
  }
  PointSource.prototype = Object.create(SceneObject.prototype);
  PointSource.prototype.constructor = PointSource;
  PointSource.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.numRays = this.numRays;
    o.brightness = this.brightness;
    o.wavelength = this.wavelength;
    o.spreadAngle = this.spreadAngle;
    return o;
  };
  PointSource.prototype.generateRays = function () {
    var rays = [];
    var spread = this.spreadAngle * Math.PI / 180;
    var startA = this.angle - spread / 2;
    var n = this.numRays;
    for (var i = 0; i < n; i++) {
      var a = n <= 1 ? this.angle : startA + spread * i / (n - (this.spreadAngle >= 360 ? 0 : 1));
      rays.push({
        ox: this.x, oy: this.y,
        dx: Math.cos(a), dy: Math.sin(a),
        wavelength: this.wavelength,
        brightness: this.brightness,
        sourceId: this.id
      });
    }
    return rays;
  };

  // ---- Parallel Beam ----
  function ParallelBeam(opts) {
    opts = opts || {};
    opts.type = 'ParallelBeam';
    SceneObject.call(this, opts);
    this.numRays = opts.numRays || 10;
    this.width = opts.width || 40;
    this.brightness = opts.brightness !== undefined ? opts.brightness : 1;
    this.wavelength = opts.wavelength || 0;
  }
  ParallelBeam.prototype = Object.create(SceneObject.prototype);
  ParallelBeam.prototype.constructor = ParallelBeam;
  ParallelBeam.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.numRays = this.numRays;
    o.width = this.width;
    o.brightness = this.brightness;
    o.wavelength = this.wavelength;
    return o;
  };
  ParallelBeam.prototype.generateRays = function () {
    var rays = [];
    var dx = Math.cos(this.angle), dy = Math.sin(this.angle);
    // Perpendicular direction for beam width
    var px = -dy, py = dx;
    var n = this.numRays;
    for (var i = 0; i < n; i++) {
      var frac = n <= 1 ? 0 : (2 * i / (n - 1) - 1);
      var offset = frac * this.width / 2;
      rays.push({
        ox: this.x + px * offset,
        oy: this.y + py * offset,
        dx: dx, dy: dy,
        wavelength: this.wavelength,
        brightness: this.brightness,
        sourceId: this.id
      });
    }
    return rays;
  };

  // ---- Single Ray ----
  function SingleRay(opts) {
    opts = opts || {};
    opts.type = 'SingleRay';
    SceneObject.call(this, opts);
    this.brightness = opts.brightness !== undefined ? opts.brightness : 1;
    this.wavelength = opts.wavelength || 0;
  }
  SingleRay.prototype = Object.create(SceneObject.prototype);
  SingleRay.prototype.constructor = SingleRay;
  SingleRay.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.brightness = this.brightness;
    o.wavelength = this.wavelength;
    return o;
  };
  SingleRay.prototype.generateRays = function () {
    return [{
      ox: this.x, oy: this.y,
      dx: Math.cos(this.angle), dy: Math.sin(this.angle),
      wavelength: this.wavelength,
      brightness: this.brightness,
      sourceId: this.id
    }];
  };

  /* ================================================================
   *  MIRRORS
   * ================================================================ */

  // ---- Flat Mirror (with optional dichroic filter) ----
  function FlatMirror(opts) {
    opts = opts || {};
    opts.type = 'FlatMirror';
    SceneObject.call(this, opts);
    this.length = opts.length || 60;
    // Dichroic: only reflect wavelengths in [minWL, maxWL] (μm), transmit others
    this.dichroic = !!opts.dichroic;
    this.dichroicMinWL = opts.dichroicMinWL || 0;
    this.dichroicMaxWL = opts.dichroicMaxWL || 0;
  }
  FlatMirror.prototype = Object.create(SceneObject.prototype);
  FlatMirror.prototype.constructor = FlatMirror;
  FlatMirror.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.length = this.length;
    if (this.dichroic) {
      o.dichroic = true;
      o.dichroicMinWL = this.dichroicMinWL;
      o.dichroicMaxWL = this.dichroicMaxWL;
    }
    return o;
  };
  /** Returns the two endpoints in world coords */
  FlatMirror.prototype.getEndpoints = function () {
    var half = this.length / 2;
    return {
      p1: toWorld(this, 0, -half),
      p2: toWorld(this, 0, half)
    };
  };
  /** Returns edges for ray intersection [{p1, p2, interaction}] */
  FlatMirror.prototype.getEdges = function () {
    var ep = this.getEndpoints();
    return [{ p1: ep.p1, p2: ep.p2, interaction: 'reflect', obj: this }];
  };

  // ---- Curved Mirror (circular arc) ----
  function CurvedMirror(opts) {
    opts = opts || {};
    opts.type = 'CurvedMirror';
    SceneObject.call(this, opts);
    this.radius = opts.radius || 100;    // positive = concave, negative = convex
    this.arcAngle = opts.arcAngle || 60; // degrees, total arc span
    this.length = opts.length || 60;     // chord length (alternative sizing)
  }
  CurvedMirror.prototype = Object.create(SceneObject.prototype);
  CurvedMirror.prototype.constructor = CurvedMirror;
  CurvedMirror.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.radius = this.radius;
    o.arcAngle = this.arcAngle;
    return o;
  };
  /** Returns arc definition in world coords */
  CurvedMirror.prototype.getArc = function () {
    var R = Math.abs(this.radius);
    // Center of curvature is at distance R along the mirror's facing direction
    // For concave (radius > 0), center is in front (along +x local)
    // For convex (radius < 0), center is behind (along -x local)
    var sign = this.radius > 0 ? 1 : -1;
    var center = toWorld(this, sign * R, 0);
    var halfArc = (this.arcAngle * Math.PI / 180) / 2;
    // Arc is centered perpendicular to the mirror's facing direction
    // The mirror faces along +x in local coords, so the arc center angle
    // is opposite to the facing direction from the center of curvature
    var centerAngle = this.angle + (this.radius > 0 ? Math.PI : 0);
    return {
      center: center,
      radius: R,
      startAngle: centerAngle - halfArc,
      endAngle: centerAngle + halfArc,
      interaction: 'reflect',
      concave: this.radius > 0
    };
  };

  // ---- Parabolic Mirror ----
  function ParabolicMirror(opts) {
    opts = opts || {};
    opts.type = 'ParabolicMirror';
    SceneObject.call(this, opts);
    this.focalLength = opts.focalLength || 50;
    this.height = opts.height || 60; // half-aperture * 2
  }
  ParabolicMirror.prototype = Object.create(SceneObject.prototype);
  ParabolicMirror.prototype.constructor = ParabolicMirror;
  ParabolicMirror.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.focalLength = this.focalLength;
    o.height = this.height;
    return o;
  };
  /** Returns polyline approximation in world coords */
  ParabolicMirror.prototype.getPolyline = function (nPts) {
    nPts = nPts || 30;
    var pts = [];
    var halfH = this.height / 2;
    var f = this.focalLength;
    for (var i = 0; i <= nPts; i++) {
      var frac = 2 * i / nPts - 1; // -1 to 1
      var ly = frac * halfH;
      var lx = ly * ly / (4 * f); // parabola: x = y²/(4f)
      pts.push(toWorld(this, lx, ly));
    }
    return pts;
  };
  /** Returns edges as line segment chain */
  ParabolicMirror.prototype.getEdges = function () {
    var pts = this.getPolyline(24);
    var edges = [];
    for (var i = 0; i < pts.length - 1; i++) {
      edges.push({ p1: pts[i], p2: pts[i + 1], interaction: 'reflect' });
    }
    return edges;
  };

  /* ================================================================
   *  REFRACTORS (glass objects)
   * ================================================================ */

  // ---- Glass Slab (rectangle) ----
  function GlassSlab(opts) {
    opts = opts || {};
    opts.type = 'GlassSlab';
    SceneObject.call(this, opts);
    this.width = opts.width || 40;
    this.height = opts.height || 80;
    this.refractiveIndex = opts.refractiveIndex || 1.5;
    this.cauchyB = opts.cauchyB || 0.00420;
    this.cauchyC = opts.cauchyC || 0;
  }
  GlassSlab.prototype = Object.create(SceneObject.prototype);
  GlassSlab.prototype.constructor = GlassSlab;
  GlassSlab.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.width = this.width; o.height = this.height;
    o.refractiveIndex = this.refractiveIndex;
    o.cauchyB = this.cauchyB; o.cauchyC = this.cauchyC;
    return o;
  };
  GlassSlab.prototype.getN = function (wavelength) {
    if (!wavelength || wavelength <= 0) return this.refractiveIndex;
    return cauchyN(wavelength, this.refractiveIndex, this.cauchyB, this.cauchyC);
  };
  /** Returns 4 edges with outward normals implied by vertex order */
  GlassSlab.prototype.getEdges = function () {
    var hw = this.width / 2, hh = this.height / 2;
    var corners = [
      toWorld(this, -hw, -hh), // bottom-left  (CW winding for outward normals)
      toWorld(this, -hw,  hh), // top-left
      toWorld(this,  hw,  hh), // top-right
      toWorld(this,  hw, -hh)  // bottom-right
    ];
    var edges = [];
    for (var i = 0; i < 4; i++) {
      edges.push({
        p1: corners[i], p2: corners[(i + 1) % 4],
        interaction: 'refract', obj: this
      });
    }
    return edges;
  };
  GlassSlab.prototype.getCorners = function () {
    var hw = this.width / 2, hh = this.height / 2;
    return [
      toWorld(this, -hw, -hh), toWorld(this,  hw, -hh),
      toWorld(this,  hw,  hh), toWorld(this, -hw,  hh)
    ];
  };

  // ---- Prism (triangle) ----
  function Prism(opts) {
    opts = opts || {};
    opts.type = 'Prism';
    SceneObject.call(this, opts);
    this.sideLength = opts.sideLength || 60;
    this.apexAngle = opts.apexAngle || 60; // degrees
    this.refractiveIndex = opts.refractiveIndex || 1.5;
    this.cauchyB = opts.cauchyB || 0.00420;
    this.cauchyC = opts.cauchyC || 0;
  }
  Prism.prototype = Object.create(SceneObject.prototype);
  Prism.prototype.constructor = Prism;
  Prism.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.sideLength = this.sideLength;
    o.apexAngle = this.apexAngle;
    o.refractiveIndex = this.refractiveIndex;
    o.cauchyB = this.cauchyB; o.cauchyC = this.cauchyC;
    return o;
  };
  Prism.prototype.getN = function (wavelength) {
    if (!wavelength || wavelength <= 0) return this.refractiveIndex;
    return cauchyN(wavelength, this.refractiveIndex, this.cauchyB, this.cauchyC);
  };
  /** Isosceles triangle: apex at top, base at bottom */
  Prism.prototype.getVertices = function () {
    var apex = this.apexAngle * Math.PI / 180;
    var s = this.sideLength;
    // Apex at local (0, h/2), base corners at (±base/2, -h/2)
    var h = s * Math.cos(apex / 2);
    var base = 2 * s * Math.sin(apex / 2);
    var cy = 0; // centroid offset
    // Place centroid at origin: centroid of triangle is at h/3 from base
    var centroidY = -h / 2 + h / 3;
    return [
      toWorld(this, 0, h / 2 - centroidY),          // apex (top)  (CW winding for outward normals)
      toWorld(this,  base / 2, -h / 2 - centroidY), // bottom-right
      toWorld(this, -base / 2, -h / 2 - centroidY)  // bottom-left
    ];
  };
  Prism.prototype.getEdges = function () {
    var v = this.getVertices();
    return [
      { p1: v[0], p2: v[1], interaction: 'refract', obj: this },
      { p1: v[1], p2: v[2], interaction: 'refract', obj: this },
      { p1: v[2], p2: v[0], interaction: 'refract', obj: this }
    ];
  };

  // ---- Circle Lens (solid circle of glass) ----
  function CircleLens(opts) {
    opts = opts || {};
    opts.type = 'CircleLens';
    SceneObject.call(this, opts);
    this.radius = opts.radius || 30;
    this.refractiveIndex = opts.refractiveIndex || 1.5;
    this.cauchyB = opts.cauchyB || 0.00420;
    this.cauchyC = opts.cauchyC || 0;
  }
  CircleLens.prototype = Object.create(SceneObject.prototype);
  CircleLens.prototype.constructor = CircleLens;
  CircleLens.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.radius = this.radius;
    o.refractiveIndex = this.refractiveIndex;
    o.cauchyB = this.cauchyB; o.cauchyC = this.cauchyC;
    return o;
  };
  CircleLens.prototype.getN = function (wavelength) {
    if (!wavelength || wavelength <= 0) return this.refractiveIndex;
    return cauchyN(wavelength, this.refractiveIndex, this.cauchyB, this.cauchyC);
  };
  /** Returns circle definition */
  CircleLens.prototype.getCircle = function () {
    return { cx: this.x, cy: this.y, radius: this.radius, interaction: 'refract', obj: this };
  };

  // ---- Ideal Lens (thin lens, no thickness) ----
  function IdealLens(opts) {
    opts = opts || {};
    opts.type = 'IdealLens';
    SceneObject.call(this, opts);
    this.focalLength = opts.focalLength || 50;
    this.height = opts.height || 60;
  }
  IdealLens.prototype = Object.create(SceneObject.prototype);
  IdealLens.prototype.constructor = IdealLens;
  IdealLens.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.focalLength = this.focalLength;
    o.height = this.height;
    return o;
  };
  /** Thin lens acts on a line segment — deflects rays by -(y/f) */
  IdealLens.prototype.getEdges = function () {
    var half = this.height / 2;
    var ep = {
      p1: toWorld(this, 0, -half),
      p2: toWorld(this, 0, half)
    };
    return [{ p1: ep.p1, p2: ep.p2, interaction: 'ideal_lens', obj: this }];
  };

  // ---- Spherical Lens (two spherical surfaces with glass in between) ----
  function SphericalLens(opts) {
    opts = opts || {};
    opts.type = 'SphericalLens';
    SceneObject.call(this, opts);
    this.radius1 = opts.radius1 || 80;  // front surface radius (positive = convex)
    this.radius2 = opts.radius2 || 80;  // back surface radius (positive = convex)
    this.thickness = opts.thickness || 12;
    this.diameter = opts.diameter || 60;
    this.refractiveIndex = opts.refractiveIndex || 1.5;
    this.cauchyB = opts.cauchyB || 0.00420;
    this.cauchyC = opts.cauchyC || 0;
  }
  SphericalLens.prototype = Object.create(SceneObject.prototype);
  SphericalLens.prototype.constructor = SphericalLens;
  SphericalLens.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.radius1 = this.radius1; o.radius2 = this.radius2;
    o.thickness = this.thickness; o.diameter = this.diameter;
    o.refractiveIndex = this.refractiveIndex;
    o.cauchyB = this.cauchyB; o.cauchyC = this.cauchyC;
    return o;
  };
  SphericalLens.prototype.getN = function (wavelength) {
    if (!wavelength || wavelength <= 0) return this.refractiveIndex;
    return cauchyN(wavelength, this.refractiveIndex, this.cauchyB, this.cauchyC);
  };
  /**
   * Returns two arcs in world coords for the front and back surfaces.
   * Positive radius = convex outward. The lens is oriented along its local +x axis.
   * Front surface at local x = -thickness/2, back at +thickness/2.
   */
  SphericalLens.prototype.getArcs = function () {
    var ht = this.thickness / 2;
    var halfD = this.diameter / 2;
    var arcs = [];

    // Front surface (R1): convex toward incoming light (left)
    var R1 = this.radius1;
    var absR1 = Math.abs(R1);
    if (absR1 > halfD + 0.01) {
      // Center of curvature: for R1>0 (convex), center is to the right of surface
      var cx1 = -ht + (R1 > 0 ? absR1 : -absR1);
      var halfAngle1 = Math.asin(Math.min(halfD / absR1, 1));
      // Arc faces left for convex front: center angle from CoC toward surface
      var faceAngle1 = R1 > 0 ? Math.PI : 0;
      var wCenter1 = toWorld(this, cx1, 0);
      arcs.push({
        center: wCenter1,
        radius: absR1,
        startAngle: this.angle + faceAngle1 - halfAngle1,
        endAngle: this.angle + faceAngle1 + halfAngle1,
        interaction: 'refract',
        obj: this
      });
    }

    // Back surface (R2): convex toward outgoing light (right)
    var R2 = this.radius2;
    var absR2 = Math.abs(R2);
    if (absR2 > halfD + 0.01) {
      var cx2 = ht - (R2 > 0 ? absR2 : -absR2);
      var halfAngle2 = Math.asin(Math.min(halfD / absR2, 1));
      var faceAngle2 = R2 > 0 ? 0 : Math.PI;
      var wCenter2 = toWorld(this, cx2, 0);
      arcs.push({
        center: wCenter2,
        radius: absR2,
        startAngle: this.angle + faceAngle2 - halfAngle2,
        endAngle: this.angle + faceAngle2 + halfAngle2,
        interaction: 'refract',
        obj: this
      });
    }

    return arcs;
  };

  /* ================================================================
   *  BEAM SPLITTER & IDEAL MIRROR
   * ================================================================ */

  // ---- Beam Splitter (partial reflection + transmission) ----
  function BeamSplitter(opts) {
    opts = opts || {};
    opts.type = 'BeamSplitter';
    SceneObject.call(this, opts);
    this.length = opts.length || 60;
    this.transmissionRatio = opts.transmissionRatio !== undefined ? opts.transmissionRatio : 0.5;
    this.dichroic = !!opts.dichroic;
    this.dichroicMinWL = opts.dichroicMinWL || 0;
    this.dichroicMaxWL = opts.dichroicMaxWL || 0;
  }
  BeamSplitter.prototype = Object.create(SceneObject.prototype);
  BeamSplitter.prototype.constructor = BeamSplitter;
  BeamSplitter.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.length = this.length;
    o.transmissionRatio = this.transmissionRatio;
    if (this.dichroic) {
      o.dichroic = true;
      o.dichroicMinWL = this.dichroicMinWL;
      o.dichroicMaxWL = this.dichroicMaxWL;
    }
    return o;
  };
  BeamSplitter.prototype.getEndpoints = function () {
    var half = this.length / 2;
    return { p1: toWorld(this, 0, -half), p2: toWorld(this, 0, half) };
  };
  BeamSplitter.prototype.getEdges = function () {
    var ep = this.getEndpoints();
    return [{
      p1: ep.p1, p2: ep.p2,
      interaction: 'beam_split',
      obj: this
    }];
  };

  // ---- Ideal Mirror (curved mirror with focal length, no thickness) ----
  function IdealMirror(opts) {
    opts = opts || {};
    opts.type = 'IdealMirror';
    SceneObject.call(this, opts);
    this.focalLength = opts.focalLength || 50;
    this.height = opts.height || 60;
  }
  IdealMirror.prototype = Object.create(SceneObject.prototype);
  IdealMirror.prototype.constructor = IdealMirror;
  IdealMirror.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.focalLength = this.focalLength;
    o.height = this.height;
    return o;
  };
  IdealMirror.prototype.getEdges = function () {
    var half = this.height / 2;
    return [{
      p1: toWorld(this, 0, -half),
      p2: toWorld(this, 0, half),
      interaction: 'ideal_mirror',
      obj: this
    }];
  };

  /* ================================================================
   *  BLOCKERS
   * ================================================================ */

  function Blocker(opts) {
    opts = opts || {};
    opts.type = 'Blocker';
    SceneObject.call(this, opts);
    this.length = opts.length || 60;
  }
  Blocker.prototype = Object.create(SceneObject.prototype);
  Blocker.prototype.constructor = Blocker;
  Blocker.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.length = this.length;
    return o;
  };
  Blocker.prototype.getEdges = function () {
    var half = this.length / 2;
    return [{
      p1: toWorld(this, 0, -half),
      p2: toWorld(this, 0, half),
      interaction: 'absorb'
    }];
  };

  function Aperture(opts) {
    opts = opts || {};
    opts.type = 'Aperture';
    SceneObject.call(this, opts);
    this.length = opts.length || 80;
    this.opening = opts.opening || 20;
  }
  Aperture.prototype = Object.create(SceneObject.prototype);
  Aperture.prototype.constructor = Aperture;
  Aperture.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.length = this.length; o.opening = this.opening;
    return o;
  };
  Aperture.prototype.getEdges = function () {
    var half = this.length / 2;
    var halfO = this.opening / 2;
    return [
      { p1: toWorld(this, 0, -half), p2: toWorld(this, 0, -halfO), interaction: 'absorb' },
      { p1: toWorld(this, 0,  halfO), p2: toWorld(this, 0,  half), interaction: 'absorb' }
    ];
  };

  // ---- Diffraction Grating ----
  function DiffractionGrating(opts) {
    opts = opts || {};
    opts.type = 'DiffractionGrating';
    SceneObject.call(this, opts);
    this.length = opts.length || 60;
    this.lineDensity = opts.lineDensity || 500; // lines per mm
    this.maxOrder = opts.maxOrder || 3;
    this.slitRatio = opts.slitRatio !== undefined ? opts.slitRatio : 0.5; // slit width / period
  }
  DiffractionGrating.prototype = Object.create(SceneObject.prototype);
  DiffractionGrating.prototype.constructor = DiffractionGrating;
  DiffractionGrating.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.length = this.length;
    o.lineDensity = this.lineDensity;
    o.maxOrder = this.maxOrder;
    o.slitRatio = this.slitRatio;
    return o;
  };
  DiffractionGrating.prototype.getEdges = function () {
    var half = this.length / 2;
    return [{
      p1: toWorld(this, 0, -half),
      p2: toWorld(this, 0, half),
      interaction: 'diffract',
      obj: this
    }];
  };
  /** Grating period in μm (for wavelength calculations) */
  DiffractionGrating.prototype.getPeriod = function () {
    return 1000 / this.lineDensity; // lines/mm → μm per line
  };

  // ---- GRIN Lens (gradient-index circular medium) ----
  // n(r) = n0 * sqrt(1 - alpha^2 * r^2) for radial GRIN (selfoc)
  // Simplification: n(r) = n0 - 0.5 * gradCoeff * (r/R)^2
  function GrinLens(opts) {
    opts = opts || {};
    opts.type = 'GrinLens';
    SceneObject.call(this, opts);
    this.radius = opts.radius || 40;
    this.refractiveIndex = opts.refractiveIndex || 1.5; // n at center
    this.gradientCoeff = opts.gradientCoeff || 0.1; // n drops by this at edge
    this.cauchyB = opts.cauchyB || 0;
    this.cauchyC = opts.cauchyC || 0;
  }
  GrinLens.prototype = Object.create(SceneObject.prototype);
  GrinLens.prototype.constructor = GrinLens;
  GrinLens.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.radius = this.radius;
    o.refractiveIndex = this.refractiveIndex;
    o.gradientCoeff = this.gradientCoeff;
    o.cauchyB = this.cauchyB; o.cauchyC = this.cauchyC;
    return o;
  };
  /** n at center (with optional wavelength) */
  GrinLens.prototype.getN0 = function (wavelength) {
    if (!wavelength || wavelength <= 0) return this.refractiveIndex;
    return cauchyN(wavelength, this.refractiveIndex, this.cauchyB, this.cauchyC);
  };
  /** n(x,y) at a world point: n0 - gradCoeff * (r/R)^2 */
  GrinLens.prototype.getNAt = function (wx, wy, wavelength) {
    var dx = wx - this.x, dy = wy - this.y;
    var r2 = (dx * dx + dy * dy) / (this.radius * this.radius);
    return this.getN0(wavelength) - this.gradientCoeff * r2;
  };
  /** Gradient of n at world point: ∂n/∂x, ∂n/∂y */
  GrinLens.prototype.getGradN = function (wx, wy) {
    var dx = wx - this.x, dy = wy - this.y;
    var R2 = this.radius * this.radius;
    return {
      x: -2 * this.gradientCoeff * dx / R2,
      y: -2 * this.gradientCoeff * dy / R2
    };
  };
  GrinLens.prototype.getCircle = function () {
    return { cx: this.x, cy: this.y, radius: this.radius, interaction: 'grin', obj: this };
  };

  // ---- Observer (eye point for observer mode) ----
  function Observer(opts) {
    opts = opts || {};
    opts.type = 'Observer';
    SceneObject.call(this, opts);
    this.pupilRadius = opts.pupilRadius || 10;
  }
  Observer.prototype = Object.create(SceneObject.prototype);
  Observer.prototype.constructor = Observer;
  Observer.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.pupilRadius = this.pupilRadius;
    return o;
  };

  // ---- Circle Blocker (circular absorber) ----
  function CircleBlocker(opts) {
    opts = opts || {};
    opts.type = 'CircleBlocker';
    SceneObject.call(this, opts);
    this.radius = opts.radius || 30;
  }
  CircleBlocker.prototype = Object.create(SceneObject.prototype);
  CircleBlocker.prototype.constructor = CircleBlocker;
  CircleBlocker.prototype.toJSON = function () {
    var o = SceneObject.prototype.toJSON.call(this);
    o.radius = this.radius;
    return o;
  };
  CircleBlocker.prototype.getCircle = function () {
    return { cx: this.x, cy: this.y, radius: this.radius, interaction: 'absorb', obj: this };
  };

  /* ================================================================
   *  SCENE container
   * ================================================================ */

  function Scene(opts) {
    opts = opts || {};
    this.objects = opts.objects || [];
    this.width = opts.width || 800;
    this.height = opts.height || 600;
    this.gridSize = opts.gridSize || 20;
    this.showGrid = opts.showGrid !== undefined ? opts.showGrid : true;
    this.maxBounces = opts.maxBounces || 64;
    this.backgroundN = opts.backgroundN || 1.0; // background refractive index (air)
    this.rayMode = opts.rayMode || 'rays'; // 'rays' | 'extended' | 'images'
    this.fresnelEnabled = !!opts.fresnelEnabled;
  }

  Scene.prototype.addObject = function (obj) {
    this.objects.push(obj);
    return obj;
  };

  Scene.prototype.removeObject = function (id) {
    for (var i = 0; i < this.objects.length; i++) {
      if (this.objects[i].id === id) {
        this.objects.splice(i, 1);
        return true;
      }
    }
    return false;
  };

  Scene.prototype.findObject = function (id) {
    for (var i = 0; i < this.objects.length; i++) {
      if (this.objects[i].id === id) return this.objects[i];
    }
    return null;
  };

  Scene.prototype.getLightSources = function () {
    var sources = [];
    for (var i = 0; i < this.objects.length; i++) {
      var o = this.objects[i];
      if (o.generateRays) sources.push(o);
    }
    return sources;
  };

  Scene.prototype.toJSON = function () {
    var objs = [];
    for (var i = 0; i < this.objects.length; i++) {
      objs.push(this.objects[i].toJSON());
    }
    return JSON.stringify({
      version: 1,
      width: this.width, height: this.height,
      gridSize: this.gridSize, showGrid: this.showGrid,
      maxBounces: this.maxBounces, backgroundN: this.backgroundN,
      rayMode: this.rayMode, fresnelEnabled: this.fresnelEnabled,
      objects: objs
    });
  };

  Scene.fromJSON = function (json) {
    var data = typeof json === 'string' ? JSON.parse(json) : json;
    var scene = new Scene({
      width: data.width, height: data.height,
      gridSize: data.gridSize, showGrid: data.showGrid,
      maxBounces: data.maxBounces, backgroundN: data.backgroundN,
      rayMode: data.rayMode, fresnelEnabled: data.fresnelEnabled
    });
    var objs = data.objects || [];
    for (var i = 0; i < objs.length; i++) {
      var o = createObject(objs[i]);
      if (o) scene.addObject(o);
    }
    return scene;
  };

  /* ================================================================
   *  OBJECT REGISTRY & FACTORY
   * ================================================================ */

  var OBJ_TYPES = {
    'PointSource':     PointSource,
    'ParallelBeam':    ParallelBeam,
    'SingleRay':       SingleRay,
    'FlatMirror':      FlatMirror,
    'CurvedMirror':    CurvedMirror,
    'ParabolicMirror': ParabolicMirror,
    'GlassSlab':       GlassSlab,
    'Prism':           Prism,
    'CircleLens':      CircleLens,
    'SphericalLens':   SphericalLens,
    'IdealLens':       IdealLens,
    'IdealMirror':     IdealMirror,
    'BeamSplitter':    BeamSplitter,
    'DiffractionGrating': DiffractionGrating,
    'GrinLens':        GrinLens,
    'Blocker':         Blocker,
    'Aperture':        Aperture,
    'CircleBlocker':   CircleBlocker,
    'Observer':        Observer
  };

  function createObject(opts) {
    var Ctor = OBJ_TYPES[opts.type];
    if (!Ctor) return null;
    return new Ctor(opts);
  }

  /* ================================================================
   *  PRESETS — ready-made scenes
   * ================================================================ */

  var PRESETS = {};

  PRESETS['Empty Scene'] = function () {
    return new Scene({ width: 800, height: 600 });
  };

  PRESETS['Plane Mirror'] = function () {
    var s = new Scene({ width: 800, height: 600 });
    s.addObject(new PointSource({ x: 250, y: 300, numRays: 8, spreadAngle: 60, angle: 0 }));
    s.addObject(new FlatMirror({ x: 550, y: 300, angle: Math.PI / 12, length: 120 }));
    return s;
  };

  PRESETS['Concave Mirror'] = function () {
    var s = new Scene({ width: 800, height: 600 });
    s.addObject(new ParallelBeam({ x: 150, y: 300, numRays: 9, width: 80, angle: 0 }));
    s.addObject(new CurvedMirror({ x: 550, y: 300, radius: 200, arcAngle: 50, angle: Math.PI }));
    return s;
  };

  PRESETS['Prism Rainbow'] = function () {
    var s = new Scene({ width: 900, height: 600 });
    // White beam = multiple wavelengths
    var wls = [0.38, 0.44, 0.47, 0.50, 0.55, 0.58, 0.60, 0.65, 0.70];
    for (var i = 0; i < wls.length; i++) {
      s.addObject(new SingleRay({
        x: 150, y: 280 + i * 3, angle: 0.05,
        wavelength: wls[i], brightness: 1
      }));
    }
    s.addObject(new Prism({ x: 400, y: 300, sideLength: 100, apexAngle: 60,
      refractiveIndex: 1.5, cauchyB: 0.00420 }));
    return s;
  };

  PRESETS['Convex Lens'] = function () {
    var s = new Scene({ width: 800, height: 600 });
    s.addObject(new ParallelBeam({ x: 150, y: 300, numRays: 9, width: 60, angle: 0 }));
    s.addObject(new IdealLens({ x: 400, y: 300, focalLength: 100, height: 100, angle: 0 }));
    return s;
  };

  PRESETS['Total Internal Reflection'] = function () {
    var s = new Scene({ width: 800, height: 600 });
    s.addObject(new SingleRay({ x: 200, y: 250, angle: 0.3, wavelength: 0.55 }));
    s.addObject(new GlassSlab({ x: 400, y: 350, width: 300, height: 100,
      angle: 0, refractiveIndex: 1.5 }));
    return s;
  };

  PRESETS['Telescope'] = function () {
    var s = new Scene({ width: 1000, height: 600 });
    s.addObject(new ParallelBeam({ x: 100, y: 300, numRays: 7, width: 60, angle: 0 }));
    s.addObject(new IdealLens({ x: 300, y: 300, focalLength: 120, height: 100, angle: 0 }));
    s.addObject(new IdealLens({ x: 460, y: 300, focalLength: 40, height: 60, angle: 0 }));
    return s;
  };

  PRESETS['Periscope'] = function () {
    var s = new Scene({ width: 600, height: 700 });
    s.addObject(new ParallelBeam({ x: 100, y: 200, numRays: 5, width: 30, angle: 0 }));
    s.addObject(new FlatMirror({ x: 350, y: 200, angle: -Math.PI / 4, length: 80 }));
    s.addObject(new FlatMirror({ x: 350, y: 500, angle: -Math.PI / 4, length: 80 }));
    return s;
  };

  PRESETS['Beam Splitter'] = function () {
    var s = new Scene({ width: 800, height: 600 });
    s.addObject(new ParallelBeam({ x: 100, y: 300, numRays: 5, width: 30, angle: 0 }));
    s.addObject(new BeamSplitter({ x: 400, y: 300, angle: Math.PI / 4, length: 80, transmissionRatio: 0.5 }));
    s.addObject(new FlatMirror({ x: 400, y: 100, angle: 0, length: 80 }));
    s.addObject(new FlatMirror({ x: 650, y: 300, angle: 0, length: 80 }));
    return s;
  };

  PRESETS['Spherical Lens'] = function () {
    var s = new Scene({ width: 800, height: 600 });
    s.addObject(new ParallelBeam({ x: 100, y: 300, numRays: 9, width: 60, angle: 0 }));
    s.addObject(new SphericalLens({ x: 400, y: 300, radius1: 80, radius2: 80,
      thickness: 14, diameter: 70, refractiveIndex: 1.5 }));
    return s;
  };

  PRESETS['Concave + Convex Mirrors'] = function () {
    var s = new Scene({ width: 900, height: 600 });
    s.addObject(new ParallelBeam({ x: 100, y: 300, numRays: 7, width: 50, angle: 0 }));
    s.addObject(new IdealMirror({ x: 500, y: 300, focalLength: 80, height: 100, angle: 0 }));
    return s;
  };

  /* ---- gallery-inspired presets ---- */

  PRESETS['Retroreflector'] = function () {
    // Two flat mirrors at 90° — light returns parallel to incoming direction
    var s = new Scene({ width: 900, height: 600 });
    // Incoming beam (angled down)
    s.addObject(new ParallelBeam({ x: 120, y: 200, numRays: 5, width: 40, angle: 0.25 }));
    // Mirror 1: horizontal-ish
    s.addObject(new FlatMirror({ x: 500, y: 380, angle: -Math.PI / 4, length: 120 }));
    // Mirror 2: vertical-ish, perpendicular to mirror 1
    s.addObject(new FlatMirror({ x: 560, y: 320, angle: Math.PI / 4, length: 120 }));
    // Second retroreflector pair
    s.addObject(new ParallelBeam({ x: 120, y: 450, numRays: 5, width: 40, angle: -0.15 }));
    s.addObject(new FlatMirror({ x: 500, y: 520, angle: -Math.PI / 4, length: 100 }));
    s.addObject(new FlatMirror({ x: 560, y: 460, angle: Math.PI / 4, length: 100 }));
    return s;
  };

  PRESETS['Camera Obscura'] = function () {
    // Point source → small aperture → inverted image on screen
    var s = new Scene({ width: 900, height: 600 });
    // Three point sources (top, mid, bottom of "object")
    s.addObject(new PointSource({ x: 150, y: 200, numRays: 36, spreadAngle: 360, brightness: 1, wavelength: 0.65 }));
    s.addObject(new PointSource({ x: 150, y: 300, numRays: 36, spreadAngle: 360, brightness: 1, wavelength: 0.55 }));
    s.addObject(new PointSource({ x: 150, y: 400, numRays: 36, spreadAngle: 360, brightness: 1, wavelength: 0.45 }));
    // Wall with small aperture
    s.addObject(new Aperture({ x: 450, y: 300, angle: 0, length: 350, opening: 10 }));
    // Back wall (screen)
    s.addObject(new Blocker({ x: 750, y: 300, angle: 0, length: 400 }));
    return s;
  };

  PRESETS['Compound Microscope'] = function () {
    // Objective lens + eyepiece lens magnification
    var s = new Scene({ width: 1000, height: 600 });
    // Object emitting light
    s.addObject(new PointSource({ x: 150, y: 300, numRays: 12, spreadAngle: 50, angle: 0 }));
    // Objective lens (short focal length, close to object)
    s.addObject(new IdealLens({ x: 280, y: 300, focalLength: 50, height: 80, angle: 0 }));
    // Eyepiece lens (magnifies intermediate image)
    s.addObject(new IdealLens({ x: 620, y: 300, focalLength: 80, height: 100, angle: 0 }));
    return s;
  };

  PRESETS['Optical Cavity'] = function () {
    // Two facing curved mirrors — ray bounces back and forth (resonator)
    var s = new Scene({ width: 900, height: 600 });
    // Left concave mirror facing right
    s.addObject(new CurvedMirror({ x: 200, y: 300, radius: 250, arcAngle: 40, angle: 0 }));
    // Right concave mirror facing left
    s.addObject(new CurvedMirror({ x: 700, y: 300, radius: 250, arcAngle: 40, angle: Math.PI }));
    // Single ray to start the bouncing
    s.addObject(new SingleRay({ x: 250, y: 310, angle: 0.05, wavelength: 0.55 }));
    return s;
  };

  PRESETS['Rainbow (Dispersion)'] = function () {
    // White light hitting a raindrop — chromatic dispersion
    var s = new Scene({ width: 900, height: 650 });
    // Multiple wavelength beams simulating white light
    var colors = [
      { wl: 0.40, y: 248 }, { wl: 0.44, y: 256 }, { wl: 0.47, y: 264 },
      { wl: 0.50, y: 272 }, { wl: 0.55, y: 280 }, { wl: 0.58, y: 288 },
      { wl: 0.60, y: 296 }, { wl: 0.65, y: 304 }, { wl: 0.70, y: 312 }
    ];
    for (var i = 0; i < colors.length; i++) {
      s.addObject(new SingleRay({ x: 120, y: colors[i].y, angle: 0, wavelength: colors[i].wl, brightness: 1 }));
    }
    // Raindrop (circular glass with water's refractive index)
    s.addObject(new CircleLens({ x: 420, y: 280, radius: 80, refractiveIndex: 1.333, cauchyB: 0.00312 }));
    return s;
  };

  PRESETS['Two-Way Mirror'] = function () {
    // Interrogation room: beam splitter acts as one-way mirror
    var s = new Scene({ width: 900, height: 600 });
    // Bright light on one side
    s.addObject(new PointSource({ x: 250, y: 300, numRays: 12, spreadAngle: 100, angle: 0 }));
    // Two-way mirror (beam splitter)
    s.addObject(new BeamSplitter({ x: 500, y: 300, angle: 0, length: 200, transmissionRatio: 0.5 }));
    // Walls
    s.addObject(new Blocker({ x: 100, y: 300, angle: 0, length: 350 }));
    s.addObject(new Blocker({ x: 900, y: 300, angle: 0, length: 350 }));
    return s;
  };

  PRESETS['Kaleidoscope'] = function () {
    // Two mirrors at 60° — creates 6-fold symmetric reflections
    var s = new Scene({ width: 800, height: 700 });
    var cx = 400, cy = 400;
    // Point source inside the mirrors
    s.addObject(new PointSource({ x: cx - 40, y: cy - 30, numRays: 18, spreadAngle: 360, wavelength: 0.55 }));
    // Mirror 1 — horizontal
    s.addObject(new FlatMirror({ x: cx, y: cy, angle: 0, length: 250 }));
    // Mirror 2 — at 60° to mirror 1
    s.addObject(new FlatMirror({ x: cx, y: cy, angle: Math.PI / 3, length: 250 }));
    return s;
  };

  PRESETS['Fiber Optic'] = function () {
    // Total internal reflection guides light through a glass slab
    var s = new Scene({ width: 900, height: 500 });
    // Light entering at steep angle
    s.addObject(new SingleRay({ x: 100, y: 220, angle: 0.18, wavelength: 0.55 }));
    s.addObject(new SingleRay({ x: 100, y: 240, angle: 0.10, wavelength: 0.50 }));
    s.addObject(new SingleRay({ x: 100, y: 260, angle: 0.05, wavelength: 0.60 }));
    // Long glass slab acting as fiber
    s.addObject(new GlassSlab({ x: 450, y: 250, width: 600, height: 50, angle: 0, refractiveIndex: 1.5 }));
    return s;
  };

  PRESETS['Fresnel Lens'] = function () {
    // Multiple prism-like segments approximating a large lens
    var s = new Scene({ width: 900, height: 600 });
    s.addObject(new ParallelBeam({ x: 100, y: 300, numRays: 11, width: 120, angle: 0 }));
    // Approximate Fresnel with a thin ideal lens (large aperture, short focal length)
    s.addObject(new IdealLens({ x: 400, y: 300, focalLength: 80, height: 150, angle: 0 }));
    // Blocker as screen at focal point
    s.addObject(new Blocker({ x: 480, y: 300, angle: 0, length: 8 }));
    return s;
  };

  PRESETS['GRIN Lens Focus'] = function () {
    // Gradient-index lens bends parallel rays to focus
    var s = new Scene({ width: 800, height: 600 });
    s.addObject(new ParallelBeam({ x: 100, y: 300, numRays: 9, width: 60, angle: 0 }));
    s.addObject(new GrinLens({ x: 350, y: 300, radius: 50, refractiveIndex: 1.6, gradientCoeff: 0.15 }));
    return s;
  };

  PRESETS['Diffraction Grating'] = function () {
    // White light split into spectrum by a grating
    var s = new Scene({ width: 900, height: 600 });
    var wls = [0.42, 0.47, 0.50, 0.55, 0.58, 0.62, 0.68];
    for (var i = 0; i < wls.length; i++) {
      s.addObject(new SingleRay({ x: 200, y: 295 + i * 2, angle: 0, wavelength: wls[i], brightness: 1 }));
    }
    s.addObject(new DiffractionGrating({ x: 500, y: 300, angle: 0, length: 120, lineDensity: 600, maxOrder: 2 }));
    return s;
  };

  PRESETS['Parabolic Dish'] = function () {
    // Parabolic mirror focuses distant parallel light to a single point
    var s = new Scene({ width: 900, height: 600 });
    s.addObject(new ParallelBeam({ x: 100, y: 300, numRays: 15, width: 140, angle: 0 }));
    s.addObject(new ParabolicMirror({ x: 600, y: 300, focalLength: 80, height: 160, angle: Math.PI }));
    return s;
  };

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.RayScene = {
    Scene:        Scene,
    SceneObject:  SceneObject,
    OBJ_TYPES:    OBJ_TYPES,
    createObject: createObject,
    cauchyN:      cauchyN,
    CAUCHY_PRESETS: CAUCHY_PRESETS,
    PRESETS:       PRESETS,
    // Constructors
    PointSource:     PointSource,
    ParallelBeam:    ParallelBeam,
    SingleRay:       SingleRay,
    FlatMirror:      FlatMirror,
    CurvedMirror:    CurvedMirror,
    ParabolicMirror: ParabolicMirror,
    GlassSlab:       GlassSlab,
    Prism:           Prism,
    CircleLens:      CircleLens,
    IdealLens:       IdealLens,
    SphericalLens:   SphericalLens,
    IdealMirror:     IdealMirror,
    BeamSplitter:    BeamSplitter,
    DiffractionGrating: DiffractionGrating,
    GrinLens:        GrinLens,
    Blocker:         Blocker,
    Aperture:        Aperture,
    CircleBlocker:   CircleBlocker,
    Observer:        Observer,
    // Helpers
    _toWorld: toWorld,
    _rotPt:   rotPt
  };

})(window);
