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

    /** US7869142B2 Embodiment 1 — 4 plastic mobile camera, f=4.91 mm F/2.8 */
    var EXAMPLE_US7869142B2 =
        'Surface\tLabel\tType\tRadius\tThickness\tn\tAbbe\n' +
        'ST\tAperture\tStop\tInfinity\t-0.122\t\t\n' +
        'S1\tL1\tAspheric\t2.01425\t0.721\t1.544\t55.9\n' +
        'S2\t\tAspheric\t-18.76480\t0.100\t\t\n' +
        'S3\tL2\tAspheric\t-46.86700\t0.550\t1.632\t23.4\n' +
        'S4\t\tAspheric\t4.69770\t0.937\t\t\n' +
        'S5\tL3\tAspheric\t-2.09486\t0.556\t1.530\t55.8\n' +
        'S6\t\tAspheric\t-2.37611\t0.070\t\t\n' +
        'S7\tL4\tAspheric\t1.85930\t0.972\t1.530\t55.8\n' +
        'S8\t\tAspheric\t1.57766\t0.700\t\t\n' +
        'S9\tIR\tGlass\tInfinity\t0.300\t1.517\t64.2\n' +
        'S10\t\tGlass\tInfinity\t0.622\t\t\n';

    /** US20140211324A1 Example 1 — 7-element compact imaging lens, f=4.54 mm F/1.64 */
    var EXAMPLE_US20140211324 =
        'Surface\tLabel\tType\tRadius\tThickness\tn\tAbbe\n' +
        'S1\tL1\tAspheric\t1.902\t0.415\t1.5346\t56.16\n' +
        'S2\t\tAspheric\t2.154\t0.372\t\t\n' +
        'ST\tStop\tPlane\tInfinity\t-0.310\t\t\n' +
        'S4\tL2\tAspheric\t2.804\t0.835\t1.5346\t56.16\n' +
        'S5\t\tAspheric\t-4.629\t0.025\t\t\n' +
        'S6\tL3\tAspheric\t2.635\t0.281\t1.6355\t23.91\n' +
        'S7\t\tAspheric\t1.229\t0.215\t\t\n' +
        'S8\tL4\tAspheric\t10.737\t0.390\t1.5346\t56.16\n' +
        'S9\t\tAspheric\t-6.667\t0.504\t\t\n' +
        'S10\tL5\tAspheric\t-2.053\t0.475\t1.6355\t23.91\n' +
        'S11\t\tAspheric\t-2.334\t0.033\t\t\n' +
        'S12\tL6\tAspheric\t2.335\t0.392\t1.5438\t55.57\n' +
        'S13\t\tAspheric\t5.444\t0.504\t\t\n' +
        'S14\tL7\tAspheric\t-4.682\t0.300\t1.5438\t55.57\n' +
        'S15\t\tAspheric\t4.277\t0.060\t\t\n' +
        'S16\tCover\tGlass\tInfinity\t0.300\t1.5168\t64.19\n' +
        'S17\t\tGlass\tInfinity\t0.711\t\t\n';

    /** Classic Cooke triplet (Taylor-Hobson style prescription) */
    var EXAMPLE_COOKETAYLOR1913 =
        'Surface\tRadius\tThickness\tn\tAbbe\n' +
        'S1\t26.1\t4.0\t1.611\t58.9\n' +
        'S2\t-198.0\t2.0\t\t\n' +
        'ST\tInfinity\t2.0\t\t\n' +
        'S3\t-20.5\t1.0\t1.603\t38.0\n' +
        'S4\t21.3\t4.0\t\t\n' +
        'S5\t128.0\t3.5\t1.611\t58.9\n' +
        'S6\t-28.6\t45.0\t\t\n';

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

    var PATENT_TABLES = {
        'US11125971B2': EXAMPLE_US11125971B2,
        'US7869142B2': EXAMPLE_US7869142B2,
        'US20140211324': EXAMPLE_US20140211324,
        'COOKE1913': EXAMPLE_COOKETAYLOR1913
    };

    var PATENT_CATALOG = [
        { id: 'US11125971B2', title: '6-element smartphone wide', surfaces: 11, note: 'Plastic aspherics, stop mid-stack' },
        { id: 'US7869142B2', title: '4-element mobile camera', surfaces: 10, note: 'f≈4.9 mm F/2.8, IR filter' },
        { id: 'US20140211324', title: '7-element fast compact', surfaces: 17, note: 'f≈4.5 mm F/1.64, +++−+−− layout' },
        { id: 'COOKE1913', title: 'Classic Cooke triplet', surfaces: 7, note: 'Photographic anastigmat' }
    ];

    function getPatentTable(id) {
        if (!id) return null;
        var key = String(id).toUpperCase().replace(/[^A-Z0-9]/g, '');
        if (key.indexOf('US11125971') === 0) return PATENT_TABLES.US11125971B2;
        if (key.indexOf('US7869142') === 0) return PATENT_TABLES.US7869142B2;
        if (key.indexOf('US20140211324') === 0) return PATENT_TABLES.US20140211324;
        if (key === 'COOKE1913' || key === 'COOKE') return PATENT_TABLES.COOKE1913;
        return PATENT_TABLES[id] || PATENT_TABLES[key] || null;
    }

    win.ODPrescription = {
        parseTable: parseTable,
        buildDesign: buildDesign,
        findMaterial: findMaterial,
        importPrescription: importPrescription,
        getPatentTable: getPatentTable,
        PATENT_CATALOG: PATENT_CATALOG,
        EXAMPLE_US11125971B2: EXAMPLE_US11125971B2,
        EXAMPLE_US7869142B2: EXAMPLE_US7869142B2,
        EXAMPLE_US20140211324: EXAMPLE_US20140211324,
        EXAMPLE_COOKETAYLOR1913: EXAMPLE_COOKETAYLOR1913,
        EXAMPLE_DOUBLET: EXAMPLE_DOUBLET,
        EXAMPLE_COOKE_TRIPLET: EXAMPLE_COOKE_TRIPLET,
        EXAMPLE_SINGLET: EXAMPLE_SINGLET,
        EXAMPLE_ASPHERIC: EXAMPLE_ASPHERIC
    };

})(window);
