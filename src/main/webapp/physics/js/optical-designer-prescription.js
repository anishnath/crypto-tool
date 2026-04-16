/**
 * Lens Prescription Import for Optical Designer.
 *
 * Parses patent/paper-style surface tables and creates an ODModel.Design
 * with proper Surface objects, materials, and conic constants.
 *
 * Patent table maps 1:1 to OD surfaces — no pairing or sign conversion needed
 * since Optical Designer uses standard optics sign convention.
 *
 * Exposed as window.ODPrescription
 */
;(function (win) {
    'use strict';

    var M = win.ODModel;

    // ═══════════════════════════════════════
    // PARSER — text → surface array
    // ═══════════════════════════════════════

    function parseTable(text) {
        if (!text || !text.trim()) return [];

        var lines = text.trim().split('\n').map(function (l) { return l.trim(); }).filter(Boolean);

        // Detect and skip header/separator rows
        var startIdx = 0;
        for (var i = 0; i < Math.min(4, lines.length); i++) {
            var lower = lines[i].toLowerCase();
            if (lower.indexOf('surface') !== -1 || lower.indexOf('radius') !== -1 ||
                lower.indexOf('thickness') !== -1 || lower.indexOf('refractive') !== -1 ||
                /^[\s|─═\-:]+$/.test(lines[i])) {
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
        var parts = line.split(/[\t|,]|  +/).map(function (p) { return p.trim(); }).filter(Boolean);
        if (parts.length < 2) return null;

        var surface = { label: '' };
        var numericCols = [];

        for (var i = 0; i < parts.length; i++) {
            var val = parts[i];
            var num = parseNumber(val);

            if (i === 0) {
                surface.surfId = val;
                continue;
            }
            if (num === null && i <= 2) {
                if (/^(L\d+|G\d+|ST|STO|STOP)/i.test(val)) {
                    surface.label = val;
                } else if (/sphere|aspher|plane|flat|mirror|conic/i.test(val)) {
                    surface.surfType = val;
                } else {
                    surface.label = val;
                }
                continue;
            }
            if (num !== null) numericCols.push(num);
        }

        // Map: radius, thickness, [n, [abbe, [conic]]]
        if (numericCols.length >= 2) {
            surface.radius = numericCols[0];
            surface.thickness = numericCols[1];
            surface.n = numericCols.length >= 3 ? numericCols[2] : null;
            surface.abbe = numericCols.length >= 4 ? numericCols[3] : null;
            surface.conic = numericCols.length >= 5 ? numericCols[4] : 0;
        } else if (numericCols.length === 1) {
            surface.radius = Infinity;
            surface.thickness = numericCols[0];
        } else {
            return null;
        }

        // Handle infinity
        var allText = parts.join(' ').toLowerCase();
        if (/infinity|inf|∞|plane|flat/i.test(allText) && surface.radius !== Infinity) {
            // Only override if the first numeric wasn't already parsed
            if (numericCols[0] === 0 || /infinity|inf|∞/i.test(parts[2] || parts[1] || '')) {
                surface.radius = Infinity;
            }
        }

        // Detect stop
        surface.isStop = /\bst\b|\bsto\b|\bstop\b|\baperture/i.test(allText);
        surface.isObject = /\bobject\b/i.test(allText);
        surface.isImage = /\bimage\b/i.test(allText);

        return surface;
    }

    function parseNumber(str) {
        if (!str) return null;
        str = str.trim();
        if (/^[-+]?infinity$|^[-+]?inf$|^∞$/i.test(str)) return Infinity;
        var num = Number(str);
        return isNaN(num) ? null : num;
    }

    // ═══════════════════════════════════════
    // MATERIAL MATCHING
    // ═══════════════════════════════════════

    /**
     * Find the best matching material from the OD material library
     * based on refractive index (nd at 587.56nm) and Abbe number.
     *
     * Returns Material object or creates a custom one.
     */
    function findMaterial(nd, abbe) {
        if (!nd || nd <= 1.0) return M.AIR;

        var lambdaD = 0.58756; // d-line in µm
        var bestMatch = null;
        var bestError = Infinity;
        var mats = M.MATERIALS;

        for (var name in mats) {
            if (!mats.hasOwnProperty(name)) continue;
            var mat = mats[name];
            if (mat === M.AIR || mat === M.VACUUM || mat === M.MIRROR) continue;

            var matN = mat.getN(lambdaD);
            if (!matN || matN <= 1.0) continue;

            // Weighted error: n difference weighted 10x more than Abbe difference
            var nErr = Math.abs(matN - nd) * 10;
            var abbeErr = 0;
            if (abbe && abbe > 0) {
                // Compute material's Abbe number
                var nF = mat.getN(0.48613);
                var nC = mat.getN(0.65627);
                if (nF && nC && nF !== nC) {
                    var matAbbe = (matN - 1) / (nF - nC);
                    abbeErr = Math.abs(matAbbe - abbe) / 50; // normalize
                }
            }
            var totalErr = nErr + abbeErr;
            if (totalErr < bestError) {
                bestError = totalErr;
                bestMatch = mat;
            }
        }

        // Accept match if n is within ±0.05
        if (bestMatch && bestError < 0.6) {
            return bestMatch;
        }

        // No good match — create a custom material with Cauchy approximation
        var cauchyB = 0.0042;
        if (abbe && abbe > 0) {
            var nF_nC = (nd - 1) / abbe;
            var lF = 0.48613, lC = 0.65627;
            cauchyB = nF_nC / (1 / (lF * lF) - 1 / (lC * lC));
        }
        // Create a tabulated material as approximation
        var custom = new M.Material('Custom (n=' + nd.toFixed(3) + ')', {
            tabulated: [
                [0.44, nd + cauchyB / (0.44 * 0.44) - cauchyB / (0.58756 * 0.58756)],
                [0.48613, nd + cauchyB / (0.48613 * 0.48613) - cauchyB / (0.58756 * 0.58756)],
                [0.55, nd + cauchyB / (0.55 * 0.55) - cauchyB / (0.58756 * 0.58756)],
                [0.58756, nd],
                [0.65627, nd - cauchyB * (1 / (0.58756 * 0.58756) - 1 / (0.65627 * 0.65627))],
                [0.70, nd - cauchyB * (1 / (0.58756 * 0.58756) - 1 / (0.70 * 0.70))]
            ],
            tags: ['custom'],
            description: 'Custom glass (nd=' + nd.toFixed(4) + ', Vd=' + (abbe || '?') + ')'
        });
        // Register it so it appears in the material dropdown
        M.MATERIALS[custom.name] = custom;
        return custom;
    }

    // ═══════════════════════════════════════
    // BUILD DESIGN
    // ═══════════════════════════════════════

    /**
     * Build an ODModel.Design from parsed surfaces.
     *
     * @param {Array} surfaces — from parseTable()
     * @param {Object} opts — { aperture, beamRadius, addImageSurface }
     * @returns {Object} { design, error, surfaceCount, materialNames }
     */
    function buildDesign(surfaces, opts) {
        opts = opts || {};
        var defaultAperture = opts.aperture || 12.5;

        // Filter out object/image surfaces
        var surfs = surfaces.filter(function (s) { return !s.isObject && !s.isImage; });
        if (surfs.length === 0) {
            return { error: 'No valid surfaces found.', design: null };
        }

        var design = new M.Design();
        design.autofocus = 'paraxial';
        if (opts.beamRadius) design.beamRadius = opts.beamRadius;
        else design.beamRadius = defaultAperture * 0.8;
        design.raysPerBeam = 7;
        design.fovAngle = 0;

        var materialNames = [];

        for (var i = 0; i < surfs.length; i++) {
            var s = surfs[i];

            var material;
            if (s.n && s.n > 1.0) {
                material = findMaterial(s.n, s.abbe);
            } else {
                material = M.AIR;
            }
            materialNames.push(material.name);

            var radius = (s.radius === Infinity || s.radius === -Infinity) ? Infinity : s.radius;
            if (s.isStop) radius = Infinity;

            design.addSurface(new M.Surface({
                radius: radius,
                aperture: opts.aperture || defaultAperture,
                thickness: s.thickness || 0,
                material: material,
                conic: s.conic || 0
            }));
        }

        // Ensure last surface has enough thickness for image plane
        var lastSurf = design.surfaces[design.surfaces.length - 1];
        if (lastSurf && lastSurf.thickness < 10) {
            lastSurf.thickness = Math.max(lastSurf.thickness, 50);
        }

        return {
            design: design,
            error: null,
            surfaceCount: design.surfaces.length,
            materialNames: materialNames
        };
    }

    // ═══════════════════════════════════════
    // MAIN API
    // ═══════════════════════════════════════

    function importPrescription(text, opts) {
        var surfaces = parseTable(text);
        if (surfaces.length === 0) {
            return { error: 'No valid surfaces found. Check the data format.', surfaces: [], design: null };
        }
        var result = buildDesign(surfaces, opts);
        result.surfaces = surfaces;
        return result;
    }

    // ═══════════════════════════════════════
    // EXAMPLES
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

    var EXAMPLE_DOUBLET =
        'Surface\tRadius\tThickness\tn\tAbbe\n' +
        'S1\t61.47\t6.0\t1.517\t64.2\n' +
        'S2\t-43.47\t2.5\t1.620\t36.4\n' +
        'S3\t-124.6\t90.0\t\t\n';

    var EXAMPLE_COOKE_TRIPLET =
        'Surface\tRadius\tThickness\tn\tAbbe\n' +
        'S1\t21.25\t4.0\t1.517\t64.2\n' +
        'S2\t-163.0\t2.0\t\t\n' +
        'S3\t-45.0\t1.0\t1.620\t36.4\n' +
        'S4\t32.0\t4.0\t\t\n' +
        'S5\t78.0\t3.5\t1.517\t64.2\n' +
        'S6\t-21.25\t35.0\t\t\n';

    var EXAMPLE_SINGLET =
        'Surface\tRadius\tThickness\tn\n' +
        'S1\t50\t5\t1.517\n' +
        'S2\t-50\t45\t\n';

    // With conic constants (aspheric singlet)
    var EXAMPLE_ASPHERIC =
        'Surface\tRadius\tThickness\tn\tAbbe\tConic K\n' +
        'S1\t25.0\t4.0\t1.517\t64.2\t-0.5\n' +
        'S2\t-25.0\t50.0\t\t\t-1.0\n';

    win.ODPrescription = {
        parseTable: parseTable,
        buildDesign: buildDesign,
        findMaterial: findMaterial,
        importPrescription: importPrescription,
        EXAMPLE_US11125971B2: EXAMPLE_US11125971B2,
        EXAMPLE_DOUBLET: EXAMPLE_DOUBLET,
        EXAMPLE_COOKE_TRIPLET: EXAMPLE_COOKE_TRIPLET,
        EXAMPLE_SINGLET: EXAMPLE_SINGLET,
        EXAMPLE_ASPHERIC: EXAMPLE_ASPHERIC
    };

})(window);
