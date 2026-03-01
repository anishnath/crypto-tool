/* hexdump-analyzer.js — Magic bytes database + analysis orchestrator
   Exposes: window.HexAnalyzer
   Depends: window.HexFormats */
(function() {
    'use strict';

    var F = window.HexFormats;
    var HexAnalyzer = {};

    // Magic bytes database — [pattern (hex), offset, fileType, icon, parser]
    var SIGNATURES = [
        // Images
        [[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A], 0, 'PNG Image', '\uD83D\uDDBC\uFE0F', 'parsePNG'],
        [[0xFF, 0xD8, 0xFF], 0, 'JPEG Image', '\uD83D\uDDBC\uFE0F', 'parseJPEG'],
        [[0x47, 0x49, 0x46, 0x38, 0x37, 0x61], 0, 'GIF87a Image', '\uD83D\uDDBC\uFE0F', 'parseGIF'],
        [[0x47, 0x49, 0x46, 0x38, 0x39, 0x61], 0, 'GIF89a Image', '\uD83D\uDDBC\uFE0F', 'parseGIF'],
        [[0x42, 0x4D], 0, 'BMP Image', '\uD83D\uDDBC\uFE0F', 'parseBMP'],
        [[0x52, 0x49, 0x46, 0x46], 0, 'RIFF', '\uD83C\uDFB5', 'parseRIFF'],
        // TIFF
        [[0x49, 0x49, 0x2A, 0x00], 0, 'TIFF (LE)', '\uD83D\uDDBC\uFE0F', null],
        [[0x4D, 0x4D, 0x00, 0x2A], 0, 'TIFF (BE)', '\uD83D\uDDBC\uFE0F', null],
        // WebP (RIFF + WEBP at offset 8)
        [[0x57, 0x45, 0x42, 0x50], 8, 'WebP Image', '\uD83D\uDDBC\uFE0F', 'parseRIFF'],
        // ICO
        [[0x00, 0x00, 0x01, 0x00], 0, 'ICO Icon', '\uD83D\uDDBC\uFE0F', null],

        // Documents
        [[0x25, 0x50, 0x44, 0x46], 0, 'PDF Document', '\uD83D\uDCC4', 'parsePDF'],

        // Archives
        [[0x50, 0x4B, 0x03, 0x04], 0, 'ZIP Archive', '\uD83D\uDCE6', 'parseZIP'],
        [[0x50, 0x4B, 0x05, 0x06], 0, 'ZIP (Empty)', '\uD83D\uDCE6', 'parseZIP'],
        [[0x50, 0x4B, 0x07, 0x08], 0, 'ZIP (Spanned)', '\uD83D\uDCE6', 'parseZIP'],
        [[0x1F, 0x8B], 0, 'GZIP', '\uD83D\uDCE6', 'parseGZIP'],
        [[0x42, 0x5A, 0x68], 0, 'BZip2', '\uD83D\uDCE6', null],
        [[0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00], 0, 'XZ', '\uD83D\uDCE6', null],
        [[0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C], 0, '7-Zip', '\uD83D\uDCE6', null],
        [[0x52, 0x61, 0x72, 0x21, 0x1A, 0x07], 0, 'RAR', '\uD83D\uDCE6', null],
        [[0x75, 0x73, 0x74, 0x61, 0x72], 257, 'TAR (ustar)', '\uD83D\uDCE6', 'parseTAR'],
        [[0x5D, 0x00, 0x00], 0, 'LZMA', '\uD83D\uDCE6', null],
        [[0x04, 0x22, 0x4D, 0x18], 0, 'LZ4', '\uD83D\uDCE6', null],
        [[0x28, 0xB5, 0x2F, 0xFD], 0, 'Zstandard', '\uD83D\uDCE6', null],

        // Executables
        [[0x7F, 0x45, 0x4C, 0x46], 0, 'ELF', '\u2699\uFE0F', 'parseELF'],
        [[0x4D, 0x5A], 0, 'PE/EXE', '\u2699\uFE0F', 'parsePE'],
        [[0xFE, 0xED, 0xFA, 0xCE], 0, 'Mach-O (32-bit)', '\u2699\uFE0F', 'parseMachO'],
        [[0xFE, 0xED, 0xFA, 0xCF], 0, 'Mach-O (64-bit)', '\u2699\uFE0F', 'parseMachO'],
        [[0xCE, 0xFA, 0xED, 0xFE], 0, 'Mach-O (32 swap)', '\u2699\uFE0F', 'parseMachO'],
        [[0xCF, 0xFA, 0xED, 0xFE], 0, 'Mach-O (64 swap)', '\u2699\uFE0F', 'parseMachO'],
        [[0xCA, 0xFE, 0xBA, 0xBE], 0, 'Java Class / Fat Mach-O', '\u2615', 'parseJavaClass'],
        [[0xDE, 0xC0, 0x17, 0x1B], 0, 'Mach-O (dSYM)', '\u2699\uFE0F', null],

        // WebAssembly
        [[0x00, 0x61, 0x73, 0x6D], 0, 'WebAssembly', '\uD83D\uDD27', 'parseWASM'],

        // Databases
        [[0x53, 0x51, 0x4C, 0x69, 0x74, 0x65, 0x20, 0x66, 0x6F, 0x72, 0x6D, 0x61, 0x74, 0x20, 0x33, 0x00], 0, 'SQLite Database', '\uD83D\uDDC3\uFE0F', 'parseSQLite'],

        // Audio/Video
        [[0x49, 0x44, 0x33], 0, 'MP3 (ID3)', '\uD83C\uDFB5', 'parseMP3'],
        [[0xFF, 0xFB], 0, 'MP3', '\uD83C\uDFB5', 'parseMP3'],
        [[0xFF, 0xF3], 0, 'MP3', '\uD83C\uDFB5', 'parseMP3'],
        [[0xFF, 0xF2], 0, 'MP3', '\uD83C\uDFB5', 'parseMP3'],
        [[0x66, 0x74, 0x79, 0x70], 4, 'MP4/MOV', '\uD83C\uDFAC', 'parseMP4'],
        [[0x4F, 0x67, 0x67, 0x53], 0, 'OGG', '\uD83C\uDFB5', null],
        [[0x66, 0x4C, 0x61, 0x43], 0, 'FLAC', '\uD83C\uDFB5', null],

        // Crypto/Security
        [[0xFE, 0xED, 0xFE, 0xED], 0, 'Java KeyStore (JKS)', '\uD83D\uDD10', 'parseJKS'],

        // PGP
        [[0xA8], 0, 'PGP', '\uD83D\uDD10', 'parsePGP'],
        [[0x99], 0, 'PGP Public Key', '\uD83D\uDD10', 'parsePGP'],
        [[0x95], 0, 'PGP Secret Key', '\uD83D\uDD10', 'parsePGP'],
        [[0x85], 0, 'PGP Compressed', '\uD83D\uDD10', 'parsePGP'],
        [[0xC0], 0, 'PGP (new format)', '\uD83D\uDD10', 'parsePGP'],

        // Fonts
        [[0x00, 0x01, 0x00, 0x00, 0x00], 0, 'TrueType Font', '\uD83D\uDD24', null],
        [[0x4F, 0x54, 0x54, 0x4F], 0, 'OpenType Font', '\uD83D\uDD24', null],
        [[0x77, 0x4F, 0x46, 0x46], 0, 'WOFF', '\uD83D\uDD24', null],
        [[0x77, 0x4F, 0x46, 0x32], 0, 'WOFF2', '\uD83D\uDD24', null],

        // Misc
        [[0x04, 0x00, 0x00, 0x00], 0, 'Windows Prefetch', '\uD83D\uDCBE', null],
        [[0xED, 0xAB, 0xEE, 0xDB], 0, 'RPM Package', '\uD83D\uDCE6', null],
        [[0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E], 0, 'Unix AR/Deb', '\uD83D\uDCE6', null]
    ];

    /**
     * Analyze binary data: detect file type, parse structure, build region map.
     * @param {Uint8Array} data
     * @returns {{ fileType, icon, regions[], regionMap, summary[] }}
     */
    HexAnalyzer.analyze = function(data) {
        if (!data || data.length === 0) {
            return { fileType: null, icon: '', regions: [], regionMap: new Map(), summary: [] };
        }

        var detected = detectType(data);
        var regions = [];

        if (detected && detected.parser && F[detected.parser]) {
            try {
                regions = F[detected.parser](data);
            } catch (e) {
                // Fall back to generic on parse error
                regions = F.parseGeneric(data);
            }
        } else if (detected) {
            // Known type but no deep parser — just mark magic bytes
            var sig = detected.signature;
            var magicEnd = sig.offset + sig.pattern.length - 1;
            regions.push({
                start: sig.offset, end: magicEnd, type: 'magic',
                label: detected.fileType + ' Signature', color: 'magic',
                description: 'Magic bytes identifying file as ' + detected.fileType,
                fields: []
            });
        } else {
            // Check for PEM (text-based, no magic bytes)
            if (isPEM(data)) {
                detected = { fileType: 'PEM Certificate/Key', icon: '\uD83D\uDD10', parser: 'parsePEM' };
                try { regions = F.parsePEM(data); } catch (e) { regions = []; }
            }
            // Check for DER (starts with 0x30 = SEQUENCE)
            else if (data.length > 2 && data[0] === 0x30) {
                detected = { fileType: 'DER/ASN.1', icon: '\uD83D\uDD10', parser: 'parseDER' };
                try { regions = F.parseDER(data); } catch (e) { regions = []; }
            }
        }

        // Build O(1) lookup map: byte index → region
        var regionMap = new Map();
        for (var ri = 0; ri < regions.length; ri++) {
            var reg = regions[ri];
            for (var bi = reg.start; bi <= reg.end && bi < data.length; bi++) {
                // First region wins (most specific — parsers emit specific regions first)
                if (!regionMap.has(bi)) {
                    regionMap.set(bi, reg);
                }
            }
        }

        // Build summary (top-level regions for structure map)
        var summary = buildSummary(regions);

        return {
            fileType: detected ? detected.fileType : null,
            icon: detected ? detected.icon : '',
            regions: regions,
            regionMap: regionMap,
            summary: summary
        };
    };

    function detectType(data) {
        for (var i = 0; i < SIGNATURES.length; i++) {
            var sig = SIGNATURES[i];
            var pattern = sig[0];
            var offset = sig[1];
            if (offset + pattern.length > data.length) continue;

            var match = true;
            for (var j = 0; j < pattern.length; j++) {
                if (data[offset + j] !== pattern[j]) { match = false; break; }
            }
            if (match) {
                return {
                    fileType: sig[2],
                    icon: sig[3],
                    parser: sig[4],
                    signature: { pattern: pattern, offset: offset }
                };
            }
        }
        return null;
    }

    function isPEM(data) {
        if (data.length < 20) return false;
        // Check for "-----BEGIN"
        var start = '';
        for (var i = 0; i < Math.min(data.length, 30); i++) {
            start += String.fromCharCode(data[i]);
        }
        return start.indexOf('-----BEGIN') >= 0;
    }

    function buildSummary(regions) {
        // De-duplicate overlapping regions, keep the most informative ones
        var seen = {};
        var summary = [];
        for (var i = 0; i < regions.length; i++) {
            var reg = regions[i];
            var key = reg.start + ':' + reg.label;
            if (seen[key]) continue;
            seen[key] = true;
            summary.push(reg);
        }
        // Sort by start offset
        summary.sort(function(a, b) { return a.start - b.start; });
        return summary;
    }

    window.HexAnalyzer = HexAnalyzer;
})();
