/**
 * Optical Designer — Data Model & Material System
 * ES5 IIFE, no dependencies
 *
 * Exports:  window.ODModel
 *   .Vector        — 3-component helpers
 *   .Complex       — {re, im} pair
 *   .Material      — constructor (name, sellmeier|tabulated, meta)
 *   .Surface       — constructor (opts)
 *   .Design        — constructor ()
 *   .MATERIALS     — { name: Material } dictionary
 *   .AIR, .VACUUM, .MIRROR — singletons
 *   .PRESETS       — named preset designs
 */
;(function (win) {
  'use strict';

  /* ================================================================
   *  VECTOR  (3-component)
   * ================================================================ */
  var Vec = {
    add:   function (a, b) { return [a[0]+b[0], a[1]+b[1], a[2]+b[2]]; },
    sub:   function (a, b) { return [a[0]-b[0], a[1]-b[1], a[2]-b[2]]; },
    scale: function (a, s) { return [a[0]*s, a[1]*s, a[2]*s]; },
    dot:   function (a, b) { return a[0]*b[0] + a[1]*b[1] + a[2]*b[2]; },
    mag:   function (a) { return Math.sqrt(a[0]*a[0]+a[1]*a[1]+a[2]*a[2]); },
    mag2:  function (a) { return Math.sqrt(a[0]*a[0]+a[1]*a[1]); }, // XY only
    norm:  function (a) {
      var m = Vec.mag(a);
      return m === 0 ? [0,0,0] : [a[0]/m, a[1]/m, a[2]/m];
    }
  };

  /* ================================================================
   *  COMPLEX  (real, imag)
   * ================================================================ */
  function Complex(re, im) { this.re = re; this.im = im || 0; }

  /* ================================================================
   *  2×2 MATRIX  (row-major flat [m00, m01, m10, m11])
   * ================================================================ */
  function mat2mul(a, b) {
    return [
      a[0]*b[0] + a[1]*b[2],  a[0]*b[1] + a[1]*b[3],
      a[2]*b[0] + a[3]*b[2],  a[2]*b[1] + a[3]*b[3]
    ];
  }

  /* ================================================================
   *  SELLMEIER  n(λ) — 3-term Sellmeier equation
   *  n²(λ) = 1 + Σ Bᵢ λ² / (λ² − Cᵢ)
   *  λ in micrometers
   * ================================================================ */
  function sellmeierN(coeffs, wavelength_um) {
    var lam2 = wavelength_um * wavelength_um;
    var nsq = 1;
    for (var i = 0; i < coeffs.length; i += 2) {
      nsq += coeffs[i] * lam2 / (lam2 - coeffs[i + 1]);
    }
    return nsq > 0 ? Math.sqrt(nsq) : 1;
  }

  /* ================================================================
   *  MATERIAL
   * ================================================================ */

  /**
   * @param {string} name
   * @param {object} opts
   *   .sellmeier  — [B1, C1, B2, C2, B3, C3]   (preferred)
   *   .n_fixed    — constant n (for air/vacuum)
   *   .tabulated  — [[λ, n], …]  (linear interpolation fallback)
   *   .tags       — string[]
   *   .description — string
   */
  function Material(name, opts) {
    this.name = name;
    this.sellmeier   = opts.sellmeier   || null;
    this.n_fixed     = (opts.n_fixed !== undefined && opts.n_fixed !== null) ? opts.n_fixed : null;
    this.tabulated   = opts.tabulated   || null;
    this.tags        = opts.tags        || [];
    this.description = opts.description || '';
  }

  Material.prototype.getN = function (wavelength_um) {
    if (this.n_fixed !== null && this.n_fixed !== undefined) return this.n_fixed;
    if (this.sellmeier) return sellmeierN(this.sellmeier, wavelength_um);
    if (this.tabulated) return tabulatedN(this.tabulated, wavelength_um);
    return 1;
  };

  function tabulatedN(table, lam) {
    if (table.length === 0) return 1;
    if (table.length === 1) return table[0][1];
    if (lam <= table[0][0]) return table[0][1];
    if (lam >= table[table.length - 1][0]) return table[table.length - 1][1];
    for (var i = 0; i < table.length - 1; i++) {
      if (lam >= table[i][0] && lam <= table[i + 1][0]) {
        var t = (lam - table[i][0]) / (table[i + 1][0] - table[i][0]);
        return table[i][1] + t * (table[i + 1][1] - table[i][1]);
      }
    }
    return table[table.length - 1][1];
  }

  /* ---- Built-in materials (Sellmeier coefficients from Schott / literature) ---- */

  var MATERIALS = {};

  function addMat(name, opts) {
    var m = new Material(name, opts);
    MATERIALS[name] = m;
    return m;
  }

  // Special constants
  var AIR    = addMat('Air',            { n_fixed: 1.000293, tags: ['gas'], description: 'Standard air' });
  var VACUUM = addMat('Vacuum',         { n_fixed: 1.0, tags: ['gas'], description: 'Perfect vacuum' });
  var MIRROR = addMat('Perfect Mirror', { n_fixed: 0, tags: ['mirror'], description: 'Ideal reflector' });

  // Schott glasses — Sellmeier [B1, C1, B2, C2, B3, C3]
  addMat('N-BK7', {
    sellmeier: [1.03961212, 0.00600069867, 0.231792344, 0.0200179144, 1.01046945, 103.560653],
    tags: ['glass','schott'], description: 'Borosilicate crown'
  });
  addMat('N-SF11', {
    sellmeier: [1.73759695, 0.013188707, 0.313747346, 0.0623068142, 1.89878101, 155.23629],
    tags: ['glass','schott'], description: 'Dense flint'
  });
  addMat('N-SF2', {
    sellmeier: [1.47343127, 0.0109019098, 0.163681849, 0.0585683687, 1.36920899, 127.404933],
    tags: ['glass','schott'], description: 'Dense flint (light)'
  });
  addMat('F2', {
    sellmeier: [1.34533359, 0.00997743871, 0.209073176, 0.0470450767, 0.937357162, 111.886764],
    tags: ['glass','schott'], description: 'Flint glass'
  });
  addMat('N-FK51A', {
    sellmeier: [0.971247817, 0.00472301995, 0.216901417, 0.0153575612, 0.904651666, 168.68133],
    tags: ['glass','schott'], description: 'Fluorophosphate crown (low dispersion)'
  });
  addMat('N-LAK9', {
    sellmeier: [1.46231905, 0.00724270156, 0.344399589, 0.0243353131, 1.15508372, 85.4686868],
    tags: ['glass','schott'], description: 'Lanthanum crown'
  });

  // Common optical materials
  addMat('Fused Silica', {
    sellmeier: [0.6961663, 0.0046791, 0.4079426, 0.01351206, 0.8974794, 97.934003],
    tags: ['glass'], description: 'Synthetic quartz (SiO₂)'
  });
  addMat('CaF₂', {
    sellmeier: [0.5675888, 0.00252643, 0.4710914, 0.01007833, 3.8484723, 1200.556],
    tags: ['crystal'], description: 'Calcium fluoride'
  });
  addMat('BaF₂', {
    sellmeier: [0.643356, 0.00301700, 0.506762, 0.01345700, 3.8261, 2045.5],
    tags: ['crystal'], description: 'Barium fluoride'
  });
  addMat('MgF₂', {
    sellmeier: [0.48755108, 0.00188217800, 0.39875031, 0.00886636500, 2.3120353, 566.13559],
    tags: ['crystal'], description: 'Magnesium fluoride'
  });
  addMat('Sapphire', {
    sellmeier: [1.4313493, 0.0052799261, 0.65054713, 0.0142382647, 5.3414021, 325.01783],
    tags: ['crystal'], description: 'Al₂O₃ (ordinary ray)'
  });
  addMat('Diamond', {
    sellmeier: [4.3356, 0.0106, 0.3306, 0.0],
    tags: ['crystal'], description: 'CVD / natural diamond'
  });

  // Plastics
  addMat('PMMA', {
    tabulated: [[0.420, 1.502], [0.450, 1.497], [0.500, 1.492], [0.550, 1.489],
                [0.589, 1.4917], [0.600, 1.488], [0.650, 1.486], [0.700, 1.484]],
    tags: ['plastic'], description: 'Acrylic / Plexiglass'
  });
  addMat('Polycarbonate', {
    tabulated: [[0.440, 1.604], [0.500, 1.593], [0.550, 1.587], [0.589, 1.5855],
                [0.600, 1.584], [0.650, 1.580], [0.700, 1.577]],
    tags: ['plastic'], description: 'Polycarbonate (PC)'
  });

  // Water / liquids
  addMat('Water', {
    sellmeier: [0.75831, 0.01007, 0.08495, 8.91377],
    tags: ['liquid'], description: 'Distilled water at 20°C'
  });

  /* ================================================================
   *  SURFACE
   * ================================================================ */

  /**
   * @param {object} opts
   *   .radius    — radius of curvature (mm), Infinity = flat  (default Infinity)
   *   .aperture  — semi-diameter (mm)                          (default 25)
   *   .thickness — distance to next surface vertex (mm)        (default 0)
   *   .material  — Material after this surface                 (default AIR)
   *   .conic     — conic constant K                            (default 0)
   */
  function Surface(opts) {
    opts = opts || {};
    this.radius    = (opts.radius    !== undefined) ? opts.radius    : Infinity;
    this.aperture  = (opts.aperture  !== undefined) ? opts.aperture  : 25;
    this.thickness = (opts.thickness !== undefined) ? opts.thickness : 0;
    this.material  = opts.material || AIR;
    this.conic     = (opts.conic     !== undefined) ? opts.conic     : 0;
  }

  /**
   * Conic sag at height y:
   *   sag(y) = sign * y² / (|R| + √(R² - (K+1)y²))
   */
  Surface.prototype.sag = function (y) {
    var R = Math.abs(this.radius);
    if (R > 1e12) return 0;  // plane
    var K = this.conic;
    var sign = this.radius < 0 ? -1 : 1;
    var y2 = y * y;
    var disc = R * R - (K + 1) * y2;
    if (disc < 0) return NaN;
    return sign * y2 / (R + Math.sqrt(disc));
  };

  /**
   * Generate outline points [z, y] for drawing.
   * Returns array of {z, y} from +aperture to -aperture.
   */
  Surface.prototype.outline = function (steps) {
    steps = steps || 60;
    var pts = [];
    var ap = this.aperture;
    for (var i = 0; i <= steps; i++) {
      var y = ap * (1 - 2 * i / steps);
      var z = this.sag(Math.abs(y));
      if (isNaN(z)) continue;
      pts.push({ z: z, y: y });
    }
    return pts;
  };

  /**
   * Create an image-plane backstop (infinite aperture, flat).
   */
  Surface.createBackstop = function () {
    return new Surface({ radius: Infinity, aperture: 1e6, thickness: 0, material: AIR });
  };

  /* ================================================================
   *  DESIGN
   * ================================================================ */

  function Design() {
    this.surfaces = [];

    // Wavelengths (μm)
    this.wavelengthCenter = 0.550;
    this.wavelengthShort  = 0.440;
    this.wavelengthLong   = 0.620;

    // Environment
    this.beamRadius    = 10;
    this.raysPerBeam   = 5;
    this.fovAngle      = 0;       // full field-of-view (degrees)
    this.symBeams      = false;   // draw symmetric negative-angle beams
    this.imageRadius   = 21.6;    // image plane half-height (mm)
    this.initialMaterial = AIR;

    // Autofocus mode: 'off' | 'paraxial' | 'marginal'
    this.autofocus = 'off';
  }

  /** Total axial length from first surface to image plane */
  Design.prototype.totalLength = function () {
    var t = 0;
    for (var i = 0; i < this.surfaces.length; i++) {
      t += this.surfaces[i].thickness;
    }
    return t;
  };

  /** Maximum aperture radius across all surfaces */
  Design.prototype.maxAperture = function () {
    var m = 0;
    for (var i = 0; i < this.surfaces.length; i++) {
      if (this.surfaces[i].aperture > m) m = this.surfaces[i].aperture;
    }
    return m;
  };

  /**
   * Add a surface.
   * @param {Surface} surf
   * @param {number} [index] — insert position. Omit to append.
   */
  Design.prototype.addSurface = function (surf, index) {
    if (index !== undefined) {
      this.surfaces.splice(index, 0, surf);
    } else {
      this.surfaces.push(surf);
    }
  };

  /** Remove surface at index */
  Design.prototype.removeSurface = function (index) {
    this.surfaces.splice(index, 1);
  };

  /**
   * ABCD system matrix (Meyer-Arendt convention).
   * Returns flat [m00, m01, m10, m11].
   */
  Design.prototype.systemMatrix = function (wavelength_um) {
    wavelength_um = wavelength_um || this.wavelengthCenter;
    var M = [1, 0, 0, 1]; // identity
    var n1 = this.initialMaterial.getN(wavelength_um);

    for (var i = 0; i < this.surfaces.length; i++) {
      var s = this.surfaces[i];
      var n2 = s.material.getN(wavelength_um);
      var R = s.radius;

      // Refraction matrix
      var phi = (Math.abs(R) > 1e12) ? 0 : (n2 - n1) / R;
      var rm = [1, phi, 0, 1];
      M = mat2mul(M, rm);

      // Transfer matrix (skip for last surface — its thickness is to image plane)
      if (i < this.surfaces.length - 1) {
        var t = s.thickness;
        var tm = [1, 0, -t / n2, 1];
        M = mat2mul(M, tm);
      }

      n1 = n2;
    }
    return M;
  };

  /** Equivalent focal length from ABCD matrix */
  Design.prototype.focalLength = function (wavelength_um) {
    var M = this.systemMatrix(wavelength_um);
    return (Math.abs(M[1]) < 1e-15) ? Infinity : 1 / M[1];
  };

  /**
   * Find paraxial image distance for the last surface.
   * Uses the full system matrix: image distance = m00 / m01
   * (from the condition that the imaging conjugate maps obj at infinity).
   */
  Design.prototype.paraxialImageDist = function (wavelength_um) {
    var M = this.systemMatrix(wavelength_um);
    if (Math.abs(M[1]) < 1e-15) return Infinity;
    return M[0] / M[1];
  };

  /**
   * Set last surface thickness via autofocus.
   */
  Design.prototype.applyAutofocus = function () {
    if (this.autofocus === 'off' || this.surfaces.length === 0) return;
    var last = this.surfaces[this.surfaces.length - 1];

    if (this.autofocus === 'paraxial') {
      var imgDist = this.paraxialImageDist(this.wavelengthCenter);
      if (isFinite(imgDist) && imgDist > 0) last.thickness = imgDist;
    } else if (this.autofocus === 'marginal') {
      // Trace a marginal ray and find axis crossing
      var imgDist2 = this._marginalImageDist(this.wavelengthCenter);
      if (isFinite(imgDist2) && imgDist2 > 0) last.thickness = imgDist2;
    }
  };

  /**
   * Marginal ray image distance — trace a ray at beam edge, find axis crossing.
   * (Uses 2D trace for efficiency.)
   */
  /**
   * Marginal ray image distance.
   * NOTE: requires ODTrace to be loaded. Called lazily at runtime.
   */
  Design.prototype._marginalImageDist = function (wavelength_um) {
    if (!win.ODTrace) return Infinity;
    var h = this.beamRadius * 0.999;
    var result = win.ODTrace.traceRay2D(this, h, 0, wavelength_um, true);
    if (!result || result.length === 0) return Infinity;
    var lastSeg = result[result.length - 1];
    if (Math.abs(lastSeg.slope) < 1e-15) return Infinity;
    var xCross = lastSeg.x2 - lastSeg.y2 / lastSeg.slope;
    var lastVertexX = 0;
    for (var i = 0; i < this.surfaces.length - 1; i++) {
      lastVertexX += this.surfaces[i].thickness;
    }
    return xCross - lastVertexX;
  };

  /* ================================================================
   *  PRESETS
   * ================================================================ */

  var PRESETS = {};

  // Helper: build a Design from a surface spec array
  function buildPreset(opts) {
    var d = new Design();
    if (opts.wavelengthCenter) d.wavelengthCenter = opts.wavelengthCenter;
    if (opts.wavelengthShort)  d.wavelengthShort  = opts.wavelengthShort;
    if (opts.wavelengthLong)   d.wavelengthLong   = opts.wavelengthLong;
    if (opts.beamRadius !== undefined) d.beamRadius = opts.beamRadius;
    if (opts.raysPerBeam !== undefined) d.raysPerBeam = opts.raysPerBeam;
    if (opts.fovAngle !== undefined)   d.fovAngle = opts.fovAngle;
    if (opts.imageRadius !== undefined) d.imageRadius = opts.imageRadius;
    if (opts.autofocus) d.autofocus = opts.autofocus;

    var surfs = opts.surfaces || [];
    for (var i = 0; i < surfs.length; i++) {
      var s = surfs[i];
      var mat = (typeof s.material === 'string') ? (MATERIALS[s.material] || AIR) : (s.material || AIR);
      d.addSurface(new Surface({
        radius:    s.radius    !== undefined ? s.radius    : Infinity,
        aperture:  s.aperture  !== undefined ? s.aperture  : 25,
        thickness: s.thickness !== undefined ? s.thickness : 0,
        material:  mat,
        conic:     s.conic     !== undefined ? s.conic     : 0
      }));
    }
    return d;
  }

  // ---- Preset: Plano-Convex Singlet (f≈100mm, BK7) ----
  PRESETS['Plano-Convex Singlet'] = function () {
    return buildPreset({
      beamRadius: 12.5, raysPerBeam: 7, fovAngle: 0, autofocus: 'paraxial',
      surfaces: [
        { radius:  51.68,    aperture: 12.5, thickness: 5,   material: 'N-BK7' },
        { radius:  Infinity, aperture: 12.5, thickness: 95,  material: 'Air'   }
      ]
    });
  };

  // ---- Preset: Symmetric Biconvex (f≈50mm, BK7) ----
  PRESETS['Symmetric Biconvex'] = function () {
    return buildPreset({
      beamRadius: 10, raysPerBeam: 7, fovAngle: 0, autofocus: 'paraxial',
      surfaces: [
        { radius:  51.68,   aperture: 12.5, thickness: 6,  material: 'N-BK7' },
        { radius: -51.68,   aperture: 12.5, thickness: 45, material: 'Air'   }
      ]
    });
  };

  // ---- Preset: Achromatic Doublet (f≈95mm, BK7 + SF2) ----
  PRESETS['Achromatic Doublet'] = function () {
    return buildPreset({
      beamRadius: 12.5, raysPerBeam: 7, fovAngle: 0, autofocus: 'paraxial',
      surfaces: [
        { radius:  61.47, aperture: 12.5, thickness: 6.0, material: 'N-BK7'  },
        { radius: -43.47, aperture: 12.5, thickness: 2.5, material: 'N-SF2'  },
        { radius: -124.6, aperture: 12.5, thickness: 90,  material: 'Air'    }
      ]
    });
  };

  // ---- Preset: Cooke Triplet (BK7 + F2, 6 surfaces) ----
  // Classic positive-negative-positive triplet
  // Prescription based on H. D. Taylor patent (1893) adapted for BK7/F2
  PRESETS['Cooke Triplet'] = function () {
    return buildPreset({
      beamRadius: 7.5, raysPerBeam: 7, fovAngle: 14, autofocus: 'paraxial',
      imageRadius: 21.6,
      surfaces: [
        { radius:  21.25,   aperture: 8.5, thickness: 4.0,  material: 'N-BK7' },
        { radius: -163.0,   aperture: 8.5, thickness: 2.0,  material: 'Air'   },
        { radius: -45.0,    aperture: 5.0, thickness: 1.0,  material: 'F2'    },
        { radius:  32.0,    aperture: 5.0, thickness: 4.0,  material: 'Air'   },
        { radius:  78.0,    aperture: 8.5, thickness: 3.5,  material: 'N-BK7' },
        { radius: -21.25,   aperture: 8.5, thickness: 35,   material: 'Air'   }
      ]
    });
  };

  // ---- Preset: Petzval Lens (BK7 + SF11, two achromatic groups) ----
  // Two separated doublet groups — fast with curved field
  PRESETS['Petzval Lens'] = function () {
    return buildPreset({
      beamRadius: 12.5, raysPerBeam: 7, fovAngle: 8, autofocus: 'paraxial',
      imageRadius: 21.6,
      surfaces: [
        { radius:  60.0,  aperture: 14, thickness: 6.0,  material: 'N-BK7'  },
        { radius: -48.0,  aperture: 14, thickness: 2.0,  material: 'N-SF11' },
        { radius: -180.0, aperture: 14, thickness: 40.0, material: 'Air'    },
        { radius:  45.0,  aperture: 12, thickness: 5.0,  material: 'N-BK7'  },
        { radius: -40.0,  aperture: 12, thickness: 2.0,  material: 'N-SF11' },
        { radius: -120.0, aperture: 12, thickness: 60,   material: 'Air'    }
      ]
    });
  };

  // ---- Preset: Plastic Camera Lens (13 aspherical surfaces, PMMA + PC) ----
  // From open-optical-designer default sample — smartphone-style lens
  PRESETS['Plastic Camera Lens'] = function () {
    return buildPreset({
      beamRadius: 24, raysPerBeam: 5, fovAngle: 19, autofocus: 'off',
      imageRadius: 21.6,
      surfaces: [
        { radius:  59,       aperture: 25, thickness: 8,     material: 'PMMA',          conic: 0    },
        { radius:  700,      aperture: 25, thickness: 0.5,   material: 'Air',           conic: 0    },
        { radius:  38,       aperture: 25, thickness: 10,    material: 'PMMA',          conic: -0.2 },
        { radius:  100,      aperture: 25, thickness: 1.2,   material: 'Air',           conic: 2    },
        { radius:  160,      aperture: 21, thickness: 2,     material: 'Polycarbonate', conic: 0    },
        { radius:  40,       aperture: 20, thickness: 12,    material: 'Air',           conic: 0    },
        { radius: -40,       aperture: 20, thickness: 2,     material: 'Polycarbonate', conic: 1.025},
        { radius:  Infinity, aperture: 21, thickness: 5,     material: 'PMMA',          conic: 0    },
        { radius: -48,       aperture: 21, thickness: 0.5,   material: 'Air',           conic: 0.5  },
        { radius: -300,      aperture: 23, thickness: 6,     material: 'Polycarbonate', conic: 0    },
        { radius: -48,       aperture: 23, thickness: 0.5,   material: 'Air',           conic: -0.15},
        { radius:  150,      aperture: 23, thickness: 4,     material: 'Polycarbonate', conic: -20  },
        { radius: -150,      aperture: 23, thickness: 37.95, material: 'Air',           conic: -15  }
      ]
    });
  };

  /* ================================================================
   *  SERIALIZATION
   * ================================================================ */

  Design.prototype.toJSON = function () {
    var surfs = [];
    for (var i = 0; i < this.surfaces.length; i++) {
      var s = this.surfaces[i];
      surfs.push({
        radius:    s.radius === Infinity ? 'Inf' : s.radius === -Infinity ? '-Inf' : s.radius,
        aperture:  s.aperture,
        thickness: s.thickness,
        material:  s.material.name,
        conic:     s.conic
      });
    }
    return JSON.stringify({
      version: 1,
      wavelengthCenter: this.wavelengthCenter,
      wavelengthShort:  this.wavelengthShort,
      wavelengthLong:   this.wavelengthLong,
      beamRadius:    this.beamRadius,
      raysPerBeam:   this.raysPerBeam,
      fovAngle:      this.fovAngle,
      symBeams:      this.symBeams,
      imageRadius:   this.imageRadius,
      initialMaterial: this.initialMaterial.name,
      autofocus:     this.autofocus,
      surfaces:      surfs
    });
  };

  Design.fromJSON = function (json) {
    var data = (typeof json === 'string') ? JSON.parse(json) : json;
    var d = new Design();
    d.wavelengthCenter = data.wavelengthCenter || 0.550;
    d.wavelengthShort  = data.wavelengthShort  || 0.440;
    d.wavelengthLong   = data.wavelengthLong   || 0.620;
    d.beamRadius    = data.beamRadius    || 10;
    d.raysPerBeam   = data.raysPerBeam   || 5;
    d.fovAngle      = data.fovAngle      || 0;
    d.symBeams      = !!data.symBeams;
    d.imageRadius   = data.imageRadius   || 21.6;
    d.autofocus     = data.autofocus     || 'off';
    d.initialMaterial = MATERIALS[data.initialMaterial] || AIR;

    var surfs = data.surfaces || [];
    for (var i = 0; i < surfs.length; i++) {
      var s = surfs[i];
      var r = s.radius === 'Inf' ? Infinity : s.radius === '-Inf' ? -Infinity : s.radius;
      d.addSurface(new Surface({
        radius:    r,
        aperture:  s.aperture,
        thickness: s.thickness,
        material:  MATERIALS[s.material] || AIR,
        conic:     s.conic || 0
      }));
    }
    return d;
  };

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.ODModel = {
    Vector:    Vec,
    Complex:   Complex,
    mat2mul:   mat2mul,
    Material:  Material,
    Surface:   Surface,
    Design:    Design,
    MATERIALS: MATERIALS,
    AIR:       AIR,
    VACUUM:    VACUUM,
    MIRROR:    MIRROR,
    PRESETS:   PRESETS,
    sellmeierN: sellmeierN
  };

})(window);
