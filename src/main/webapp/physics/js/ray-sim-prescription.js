/**
 * Lens Prescription Import — parses patent/paper-style optical surface tables
 * and creates SphericalLens + Aperture + ParallelBeam objects in the scene.
 *
 * Patent table format (e.g. US11125971B2):
 *   Surface | Label | Type     | Radius | Thickness | n    | Abbe
 *   S1      | L1    | Aspheric | 8.363  | 1.219     | 1.81 | 40.7
 *   S2      |       | Aspheric | 3.299  | 2.825     |      |
 *   ...
 *
 * Convention conversion:
 *   Patent: positive R = center of curvature to the RIGHT of surface
 *   Engine: radius1 positive = convex outward (toward incoming light)
 *           radius2 positive = convex outward (toward outgoing light)
 *   → Back surface radius sign must be FLIPPED from patent convention.
 *
 * Exposed as window.RayPrescription
 */
var RayPrescription = (function () {
    'use strict';

    // ═══════════════════════════════════════
    // PARSER — text → surface array
    // ═══════════════════════════════════════

    /**
     * Parse pasted text into an array of surface objects.
     * Accepts tab/comma/pipe/whitespace-separated data.
     * Auto-detects header row.
     *
     * Returns: [{ surfNum, label, type, radius, thickness, n, abbe }]
     */
    function parseTable(text) {
        if (!text || !text.trim()) return [];

        var lines = text.trim().split('\n').map(function (l) { return l.trim(); }).filter(Boolean);

        // Detect and skip header row(s)
        var startIdx = 0;
        for (var i = 0; i < Math.min(3, lines.length); i++) {
            var lower = lines[i].toLowerCase();
            if (lower.indexOf('surface') !== -1 || lower.indexOf('radius') !== -1 ||
                lower.indexOf('thickness') !== -1 || lower.indexOf('refractive') !== -1 ||
                lower.indexOf('---') !== -1 || lower.indexOf('===') !== -1 ||
                /^[\s|─═\-]+$/.test(lines[i])) {
                startIdx = i + 1;
            }
        }

        var surfaces = [];
        for (var j = startIdx; j < lines.length; j++) {
            var s = parseLine(lines[j]);
            if (s) surfaces.push(s);
        }
        return surfaces;
    }

    function parseLine(line) {
        // Split by tab, pipe, comma, or 2+ spaces
        var parts = line.split(/[\t|,]|  +/).map(function (p) { return p.trim(); }).filter(Boolean);
        if (parts.length < 3) return null;

        // Try to identify columns by content
        var surface = {};
        var numericCols = [];

        for (var i = 0; i < parts.length; i++) {
            var val = parts[i];
            var num = parseNumber(val);

            if (i === 0) {
                // First column: surface number/label (S1, S2, ST, Object, Image, etc.)
                surface.surfNum = val;
                continue;
            }

            if (num === null && i <= 2) {
                // Non-numeric early column: label (L1, L2, ST, G1) or type (Aspheric, Spherical, Plane)
                if (/^(L\d+|G\d+|ST|STO|STOP)/i.test(val)) {
                    surface.label = val;
                } else if (/sphere|aspher|plane|flat|mirror/i.test(val)) {
                    surface.surfType = val;
                } else {
                    surface.label = val;
                }
                continue;
            }

            if (num !== null) {
                numericCols.push(num);
            }
        }

        // Map numeric columns: radius, thickness, [n, [abbe]]
        if (numericCols.length >= 2) {
            surface.radius = numericCols[0];
            surface.thickness = numericCols[1];
            surface.n = numericCols.length >= 3 ? numericCols[2] : null;
            surface.abbe = numericCols.length >= 4 ? numericCols[3] : null;
        } else if (numericCols.length === 1) {
            // Might be a stop or special surface with only thickness
            surface.radius = Infinity;
            surface.thickness = numericCols[0];
        } else {
            return null;
        }

        // Handle special values
        if (surface.radius === null || surface.radius === undefined) surface.radius = Infinity;
        if (/infinity|inf|∞|plane|flat/i.test(parts.join(' '))) {
            surface.radius = Infinity;
        }

        // Detect aperture stop
        var allText = parts.join(' ').toLowerCase();
        surface.isStop = /\bst\b|\bsto\b|\bstop\b|\baperture/i.test(allText);

        // Detect object/image surfaces (skip them)
        surface.isObject = /\bobject\b/i.test(allText);
        surface.isImage = /\bimage\b/i.test(allText);

        return surface;
    }

    function parseNumber(str) {
        if (!str) return null;
        str = str.trim();
        if (/^[-+]?infinity$|^[-+]?inf$|^∞$/i.test(str)) return Infinity;
        // Handle scientific notation: -3.9E-06
        var num = Number(str);
        return isNaN(num) ? null : num;
    }

    // ═══════════════════════════════════════
    // SURFACE → LENS PAIRING
    // ═══════════════════════════════════════

    /**
     * Group sequential surfaces into optical elements (lenses, stops, gaps).
     *
     * Logic: A surface with n > 1 is a lens entry surface.
     * The next surface (without n or n=1) is the exit surface.
     * Surfaces with n=1 or no n between lenses are air gaps.
     * Surfaces marked as stop are aperture stops.
     *
     * Returns: [{ type: 'lens'|'stop'|'gap', ... }]
     */
    function groupSurfaces(surfaces) {
        var elements = [];
        var i = 0;

        // Filter out object/image surfaces
        var surfs = surfaces.filter(function (s) { return !s.isObject && !s.isImage; });

        while (i < surfs.length) {
            var s = surfs[i];

            // Aperture stop
            if (s.isStop) {
                elements.push({
                    type: 'stop',
                    thickness: s.thickness || 0,
                    diameter: 0 // will be set later
                });
                i++;
                continue;
            }

            // Lens: surface with n > 1
            if (s.n && s.n > 1.0) {
                var frontRadius = s.radius;
                var lensThickness = s.thickness;
                var n = s.n;
                var abbe = s.abbe;
                var backRadius = Infinity;
                var airGap = 0;

                // Next surface is the back surface of this lens
                if (i + 1 < surfs.length) {
                    var next = surfs[i + 1];
                    // Check for cemented doublet: next surface also has n > 1
                    if (next.n && next.n > 1.0) {
                        // Cemented: back surface radius = next front radius
                        backRadius = next.radius;
                        // First lens: front to shared surface
                        elements.push({
                            type: 'lens',
                            radius1: frontRadius,
                            radius2: backRadius,
                            thickness: lensThickness,
                            n: n,
                            abbe: abbe
                        });
                        // Continue to process the second element of the doublet
                        i++;
                        continue;
                    }
                    backRadius = next.radius;
                    airGap = next.thickness || 0;
                    i += 2; // consumed both surfaces
                } else {
                    i++;
                }

                elements.push({
                    type: 'lens',
                    radius1: frontRadius,
                    radius2: backRadius,
                    thickness: lensThickness,
                    n: n,
                    abbe: abbe,
                    airGap: airGap
                });
                continue;
            }

            // Plain gap or filter (n=1 or no n)
            elements.push({
                type: 'gap',
                thickness: s.thickness || 0
            });
            i++;
        }

        return elements;
    }

    // ═══════════════════════════════════════
    // SIGN CONVENTION CONVERSION
    // ═══════════════════════════════════════

    /**
     * Convert patent sign convention to engine convention.
     *
     * Patent (standard optics):
     *   R > 0 = center of curvature to the RIGHT of surface
     *   R < 0 = center of curvature to the LEFT of surface
     *
     * Engine:
     *   radius1 > 0 = front surface convex (bulges toward incoming light = LEFT)
     *   radius2 > 0 = back surface convex (bulges toward outgoing light = RIGHT)
     *
     * For front surface (S1): patent R > 0 → convex left → engine radius1 > 0  ✓ (same sign)
     * For back surface (S2):  patent R < 0 → convex right → engine radius2 > 0  (FLIP sign)
     *                         patent R > 0 → concave right → engine radius2 < 0  (FLIP sign)
     */
    function convertRadii(patentR1, patentR2) {
        return {
            radius1: patentR1,          // front: same sign
            radius2: -patentR2          // back: flip sign
        };
    }

    // ═══════════════════════════════════════
    // ABBE → CAUCHY B CONVERSION
    // ═══════════════════════════════════════

    /**
     * Convert Abbe number (Vd) + refractive index (nd) to Cauchy B coefficient.
     *
     * Abbe number: Vd = (nd - 1) / (nF - nC)
     * Cauchy: n(λ) = A + B/λ²
     * → B ≈ (nd - 1) / Vd × 0.0304  (empirical approximation)
     *
     * More precise: use Fraunhofer lines (d=587.56nm, F=486.13nm, C=656.27nm)
     */
    function abbeToCauchyB(nd, abbe) {
        if (!abbe || abbe <= 0) return 0.00420; // default glass
        var nF_nC = (nd - 1) / abbe;
        // From Cauchy: nF - nC = B × (1/λF² - 1/λC²)
        var lambdaF = 0.48613; // µm
        var lambdaC = 0.65627; // µm
        var denom = 1 / (lambdaF * lambdaF) - 1 / (lambdaC * lambdaC);
        return nF_nC / denom;
    }

    // ═══════════════════════════════════════
    // BUILD SCENE OBJECTS
    // ═══════════════════════════════════════

    /**
     * Create scene objects from grouped elements.
     *
     * @param {Array} elements - from groupSurfaces()
     * @param {Object} opts - { startX, centerY, scale, beamWidth, beamRays, maxDiameter }
     * @returns {Array} scene objects ready for scene.addObject()
     */
    function buildSceneObjects(elements, opts) {
        opts = opts || {};
        var startX = opts.startX || 150;
        var centerY = opts.centerY || 300;
        var beamRays = opts.beamRays || 15;
        var maxDiameter = opts.maxDiameter || 50; // pixels, default lens diameter

        // Auto-scale: compute total track length and fit to ~500px if no explicit scale
        var scale = opts.scale;
        if (!scale) {
            var totalTrack = 0;
            elements.forEach(function (el) {
                if (el.type === 'lens') {
                    totalTrack += Math.abs(el.thickness || 0) + Math.abs(el.airGap || 0);
                } else {
                    totalTrack += Math.abs(el.thickness || 0);
                }
            });
            if (totalTrack > 0) {
                scale = Math.max(2, Math.min(20, Math.round(500 / totalTrack)));
            } else {
                scale = 8;
            }
        }

        var beamWidth = opts.beamWidth || maxDiameter * 0.7;

        var objects = [];
        var curX = startX;

        // Add parallel beam to the left of the system
        objects.push({
            type: 'ParallelBeam',
            x: startX - 80,
            y: centerY,
            angle: 0,
            numRays: beamRays,
            width: beamWidth,
            brightness: 1,
            wavelength: 0
        });

        for (var i = 0; i < elements.length; i++) {
            var el = elements[i];

            if (el.type === 'lens') {
                var radii = convertRadii(el.radius1, el.radius2);
                var thick = Math.max(el.thickness * scale, 4); // minimum visible thickness
                var cauchyB = el.abbe ? abbeToCauchyB(el.n, el.abbe) : 0.00420;

                // Handle infinity radius (plano surface) — use very large value preserving sign
                var r1 = isFinite(radii.radius1) ? radii.radius1 * scale
                       : (radii.radius1 < 0 ? -9999 : 9999);
                var r2 = isFinite(radii.radius2) ? radii.radius2 * scale
                       : (radii.radius2 < 0 ? -9999 : 9999);

                // Per-lens diameter: must be < 2×|radius| for arcs to render
                var absR1 = Math.abs(r1);
                var absR2 = Math.abs(r2);
                var diam = maxDiameter;
                // Clamp diameter to fit within both surface arcs
                var maxByR1 = (absR1 < 9000) ? absR1 * 1.8 : Infinity;
                var maxByR2 = (absR2 < 9000) ? absR2 * 1.8 : Infinity;
                diam = Math.min(diam, maxByR1, maxByR2);
                diam = Math.max(diam, 12); // minimum visible

                objects.push({
                    type: 'SphericalLens',
                    x: curX + thick / 2,
                    y: centerY,
                    angle: 0,
                    radius1: r1,
                    radius2: r2,
                    thickness: thick,
                    diameter: diam,
                    refractiveIndex: el.n,
                    cauchyB: cauchyB,
                    cauchyC: 0
                });

                curX += thick;

                // Air gap after lens (negative gap = small overlap, clamp to 0)
                if (el.airGap) {
                    curX += Math.max(0, el.airGap) * scale;
                }
            } else if (el.type === 'stop') {
                objects.push({
                    type: 'Aperture',
                    x: curX,
                    y: centerY,
                    angle: Math.PI / 2, // vertical
                    length: maxDiameter + 20,
                    opening: beamWidth * 0.8
                });
                curX += (el.thickness || 0) * scale;
            } else if (el.type === 'gap') {
                curX += (el.thickness || 0) * scale;
            }
        }

        // Add observer/screen at the end
        objects.push({
            type: 'Blocker',
            x: curX + 60,
            y: centerY,
            angle: Math.PI / 2, // vertical
            length: maxDiameter + 40
        });

        return { objects: objects, scale: scale };
    }

    // ═══════════════════════════════════════
    // MAIN API
    // ═══════════════════════════════════════

    /**
     * Full pipeline: text → parsed surfaces → grouped elements → scene objects.
     */
    function importPrescription(text, opts) {
        var surfaces = parseTable(text);
        if (surfaces.length === 0) {
            return { error: 'No valid surfaces found. Check the data format.', objects: [] };
        }
        var elements = groupSurfaces(surfaces);
        if (elements.length === 0) {
            return { error: 'Could not group surfaces into optical elements.', objects: [] };
        }
        var built = buildSceneObjects(elements, opts);
        return {
            surfaces: surfaces,
            elements: elements,
            objects: built.objects,
            scale: built.scale,
            error: null
        };
    }

    // ═══════════════════════════════════════
    // EXAMPLE DATA
    // ═══════════════════════════════════════

    var EXAMPLE_US11125971B2 =
        'Surface\tLabel\tType\tRadius\tThickness\tn\tAbbe\n' +
        'S1\tL1\tAspheric\t8.363\t1.219\t1.81\t40.7\n' +
        'S2\t\tAspheric\t3.299\t2.825\t\t\n' +
        'S3\tL2\tSpherical\t-7.174\t3.975\t1.91\t35.3\n' +
        'S4\t\tSpherical\t-8.533\t-0.239\t\t\n' +
        'ST\tST\tPlane\tInfinity\t2.540\t\t\n' +
        'S5\tL3\tAspheric\t13.069\t6.192\t1.50\t81.6\n' +
        'S6\t\tAspheric\t-9.982\t1.870\t\t\n' +
        'S7\tL4\tSpherical\t13.088\t5.9\t1.59\t61.2\n' +
        'S8\tL5\tSpherical\t-13.088\t0.892\t1.92\t18.9\n' +
        'S9\t\tSpherical\t-47.384\t1.098\t\t\n' +
        'S10\tL6\tAspheric\t7.802\t3.474\t1.54\t55.7\n' +
        'S11\t\tAspheric\t186.940\t0.400\t\t\n';

    // Simple doublet example
    var EXAMPLE_DOUBLET =
        'Surface\tRadius\tThickness\tn\tAbbe\n' +
        'S1\t61.9\t4.0\t1.517\t64.2\n' +
        'S2\t-44.2\t1.5\t1.649\t33.8\n' +
        'S3\t-129.0\t96.3\t\t\n';

    // Cooke Triplet (classic 3-element camera lens)
    var EXAMPLE_COOKE_TRIPLET =
        'Surface\tRadius\tThickness\tn\tAbbe\n' +
        'S1\t26.1\t4.0\t1.611\t58.9\n' +
        'S2\t-198.0\t2.0\t\t\n' +
        'ST\tInfinity\t2.0\t\t\n' +
        'S3\t-20.5\t1.0\t1.603\t38.0\n' +
        'S4\t21.3\t4.0\t\t\n' +
        'S5\t128.0\t3.5\t1.611\t58.9\n' +
        'S6\t-28.6\t45.0\t\t\n';

    // Simple biconvex singlet
    var EXAMPLE_SINGLET =
        'Surface\tRadius\tThickness\tn\n' +
        'S1\t50\t5\t1.517\n' +
        'S2\t-50\t45\t\n';

    return {
        parseTable: parseTable,
        groupSurfaces: groupSurfaces,
        buildSceneObjects: buildSceneObjects,
        importPrescription: importPrescription,
        convertRadii: convertRadii,
        abbeToCauchyB: abbeToCauchyB,
        EXAMPLE_US11125971B2: EXAMPLE_US11125971B2,
        EXAMPLE_DOUBLET: EXAMPLE_DOUBLET,
        EXAMPLE_COOKE_TRIPLET: EXAMPLE_COOKE_TRIPLET,
        EXAMPLE_SINGLET: EXAMPLE_SINGLET
    };

})();
