/**
 * Steganography Tool - Reed-Solomon Error Correction Module
 * GF(2^8) arithmetic with primitive polynomial 0x11d
 * Uses Petersons algorithm for decoding (simpler, works well for moderate error counts)
 */
(function() {
'use strict';

// GF(2^8) lookup tables
var GF_EXP = new Uint8Array(512);
var GF_LOG = new Int16Array(256);

(function initGF() {
    var x = 1;
    for (var i = 0; i < 255; i++) {
        GF_EXP[i] = x;
        GF_LOG[x] = i;
        x <<= 1;
        if (x & 0x100) x ^= 0x11d;
    }
    for (var j = 255; j < 512; j++) {
        GF_EXP[j] = GF_EXP[j - 255];
    }
    GF_LOG[0] = -1;
})();

function gfMul(a, b) {
    if (a === 0 || b === 0) return 0;
    return GF_EXP[(GF_LOG[a] + GF_LOG[b]) % 255];
}

function gfDiv(a, b) {
    if (b === 0) throw new Error('GF division by zero');
    if (a === 0) return 0;
    return GF_EXP[((GF_LOG[a] - GF_LOG[b]) % 255 + 255) % 255];
}

function gfPow(a, n) {
    if (n === 0) return 1;
    if (a === 0) return 0;
    return GF_EXP[(GF_LOG[a] * n) % 255];
}

function gfInverse(a) {
    if (a === 0) throw new Error('GF inverse of zero');
    return GF_EXP[255 - GF_LOG[a]];
}

// Polynomial multiply (arrays of GF(2^8) coefficients, highest degree first)
function polyMul(p, q) {
    var r = new Array(p.length + q.length - 1);
    for (var i = 0; i < r.length; i++) r[i] = 0;
    for (var i = 0; i < p.length; i++) {
        for (var j = 0; j < q.length; j++) {
            r[i + j] ^= gfMul(p[i], q[j]);
        }
    }
    return r;
}

// Evaluate polynomial at x (highest degree first)
function polyEval(poly, x) {
    var result = poly[0];
    for (var i = 1; i < poly.length; i++) {
        result = gfMul(result, x) ^ poly[i];
    }
    return result;
}

/**
 * Generate RS generator polynomial for nsym parity symbols.
 * g(x) = (x - a^0)(x - a^1)...(x - a^(nsym-1))
 * Returned with highest degree first.
 */
function rsGeneratorPoly(nsym) {
    var g = [1];
    for (var i = 0; i < nsym; i++) {
        g = polyMul(g, [1, GF_EXP[i]]);
    }
    return g;
}

/**
 * RS encode: append nsym parity bytes to data.
 * Returns Uint8Array of data + parity.
 */
function rsEncode(data, nsym) {
    var gen = rsGeneratorPoly(nsym);
    // Dividend: data followed by nsym zeros
    var dividend = new Array(data.length + nsym);
    for (var i = 0; i < data.length; i++) dividend[i] = data[i];
    for (var j = data.length; j < dividend.length; j++) dividend[j] = 0;

    // Polynomial long division
    for (var i = 0; i < data.length; i++) {
        var coeff = dividend[i];
        if (coeff !== 0) {
            for (var j = 1; j < gen.length; j++) {
                dividend[i + j] ^= gfMul(gen[j], coeff);
            }
        }
    }

    // Result: original data + remainder (parity)
    var result = new Uint8Array(data.length + nsym);
    for (var k = 0; k < data.length; k++) result[k] = data[k];
    for (var m = 0; m < nsym; m++) result[data.length + m] = dividend[data.length + m];
    return result;
}

/**
 * Compute syndromes.
 * S_i = msg(a^i) for i = 0..nsym-1
 */
function calcSyndromes(msg, nsym) {
    var synd = new Array(nsym);
    for (var i = 0; i < nsym; i++) {
        var val = 0;
        for (var j = 0; j < msg.length; j++) {
            val = gfMul(val, GF_EXP[i]) ^ msg[j];
        }
        synd[i] = val;
    }
    return synd;
}

/**
 * Berlekamp-Massey algorithm.
 * Returns error locator polynomial (highest degree first).
 */
function berlekampMassey(synd, nsym) {
    // C = current connection polynomial, B = previous
    var C = [1];
    var B = [1];
    var L = 0;
    var m = 1;
    var b = 1;

    for (var n = 0; n < nsym; n++) {
        // Compute discrepancy
        var d = synd[n];
        for (var i = 1; i <= L; i++) {
            d ^= gfMul(C[i], synd[n - i]);
        }

        if (d === 0) {
            m++;
        } else if (2 * L <= n) {
            var T = C.slice();
            var coeff = gfDiv(d, b);
            // C = C - (d/b) * x^m * B
            while (C.length < B.length + m) C.push(0);
            for (var j = 0; j < B.length; j++) {
                C[j + m] ^= gfMul(coeff, B[j]);
            }
            L = n + 1 - L;
            B = T;
            b = d;
            m = 1;
        } else {
            var coeff2 = gfDiv(d, b);
            while (C.length < B.length + m) C.push(0);
            for (var k = 0; k < B.length; k++) {
                C[k + m] ^= gfMul(coeff2, B[k]);
            }
            m++;
        }
    }

    // C is the error locator polynomial (index 0 = constant term = 1)
    // Convert to highest-degree-first format
    var errLoc = new Array(C.length);
    for (var p = 0; p < C.length; p++) {
        errLoc[p] = C[C.length - 1 - p];
    }
    return errLoc;
}

/**
 * Find error positions using Chien search.
 */
function chienSearch(errLoc, msgLen) {
    var errs = errLoc.length - 1;
    var positions = [];

    for (var i = 0; i < msgLen; i++) {
        // Evaluate errLoc at a^(-i) = a^(255-i)
        if (polyEval(errLoc, GF_EXP[255 - i]) === 0) {
            positions.push(msgLen - 1 - i);
        }
    }

    if (positions.length !== errs) {
        throw new Error('Too many errors to correct');
    }
    return positions;
}

/**
 * Compute error magnitudes by solving linear system from syndromes.
 * Given error positions (array indices), the syndromes form a linear system:
 * S_j = sum(e_i * X_i^j) for each syndrome j
 * where X_i = a^(msgLen-1-pos_i) maps array index to polynomial power.
 */
function computeMagnitudes(synd, positions, msgLen) {
    var n = positions.length;
    if (n === 0) return [];

    // X_i values: array index pos maps to polynomial power (msgLen-1-pos)
    var X = new Array(n);
    for (var i = 0; i < n; i++) {
        X[i] = GF_EXP[(msgLen - 1 - positions[i]) % 255];
    }

    // Build matrix: row j, col i = X[i]^j
    // Solve using Gaussian elimination in GF(2^8)
    // Augmented matrix [A | synd]
    var matrix = new Array(n);
    for (var j = 0; j < n; j++) {
        matrix[j] = new Array(n + 1);
        for (var i = 0; i < n; i++) {
            matrix[j][i] = gfPow(X[i], j);
        }
        matrix[j][n] = synd[j];
    }

    // Gaussian elimination with partial pivoting
    for (var col = 0; col < n; col++) {
        // Find pivot
        var pivotRow = -1;
        for (var row = col; row < n; row++) {
            if (matrix[row][col] !== 0) { pivotRow = row; break; }
        }
        if (pivotRow === -1) throw new Error('Singular matrix in magnitude computation');

        // Swap rows
        if (pivotRow !== col) {
            var temp = matrix[col];
            matrix[col] = matrix[pivotRow];
            matrix[pivotRow] = temp;
        }

        // Scale pivot row
        var pivotVal = matrix[col][col];
        var pivotInv = gfInverse(pivotVal);
        for (var c = col; c <= n; c++) {
            matrix[col][c] = gfMul(matrix[col][c], pivotInv);
        }

        // Eliminate column
        for (var row = 0; row < n; row++) {
            if (row === col) continue;
            var factor = matrix[row][col];
            if (factor === 0) continue;
            for (var c2 = col; c2 <= n; c2++) {
                matrix[row][c2] ^= gfMul(factor, matrix[col][c2]);
            }
        }
    }

    // Extract magnitudes
    var magnitudes = new Array(n);
    for (var i = 0; i < n; i++) {
        magnitudes[i] = matrix[i][n];
    }
    return magnitudes;
}

/**
 * RS decode with error correction.
 * Returns corrected data (without parity).
 */
function rsDecode(encoded, nsym) {
    var msg = new Uint8Array(encoded);
    var synd = calcSyndromes(msg, nsym);

    // Check if any errors
    var hasError = false;
    for (var i = 0; i < synd.length; i++) {
        if (synd[i] !== 0) { hasError = true; break; }
    }
    if (!hasError) {
        return msg.slice(0, msg.length - nsym);
    }

    var errLoc = berlekampMassey(synd, nsym);
    var numErrors = errLoc.length - 1;

    if (numErrors * 2 > nsym) {
        throw new Error('Too many errors: ' + numErrors + ' detected, max correctable: ' + Math.floor(nsym / 2));
    }

    var positions = chienSearch(errLoc, msg.length);
    var magnitudes = computeMagnitudes(synd, positions, msg.length);

    // Apply corrections
    for (var j = 0; j < positions.length; j++) {
        if (positions[j] >= msg.length) throw new Error('Error position out of range');
        msg[positions[j]] ^= magnitudes[j];
    }

    // Verify
    var newSynd = calcSyndromes(msg, nsym);
    for (var k = 0; k < newSynd.length; k++) {
        if (newSynd[k] !== 0) throw new Error('RS decode verification failed');
    }

    return msg.slice(0, msg.length - nsym);
}

/**
 * Protect data with RS: split into blocks, encode each.
 * Format: [2-byte BE block count][block0][block1]...
 * Each block: [1-byte data length][RS-encoded data (dataLen + parityBytes)]
 */
function rsProtect(data, parityBytes) {
    if (!(data instanceof Uint8Array)) data = new Uint8Array(data);
    var blockDataSize = 255 - parityBytes;
    var numBlocks = Math.ceil(data.length / blockDataSize);
    var blocks = [];
    var totalSize = 2;

    for (var i = 0; i < numBlocks; i++) {
        var start = i * blockDataSize;
        var end = Math.min(start + blockDataSize, data.length);
        var blockData = data.slice(start, end);
        var encoded = rsEncode(blockData, parityBytes);
        var block = new Uint8Array(1 + encoded.length);
        block[0] = blockData.length;
        block.set(encoded, 1);
        blocks.push(block);
        totalSize += block.length;
    }

    var result = new Uint8Array(totalSize);
    result[0] = (numBlocks >>> 8) & 0xFF;
    result[1] = numBlocks & 0xFF;
    var offset = 2;
    for (var j = 0; j < blocks.length; j++) {
        result.set(blocks[j], offset);
        offset += blocks[j].length;
    }
    return result;
}

/**
 * Unprotect RS-encoded data.
 */
function rsUnprotect(protected_, parityBytes) {
    if (!(protected_ instanceof Uint8Array)) protected_ = new Uint8Array(protected_);
    if (protected_.length < 2) throw new Error('RS data too short');
    var numBlocks = (protected_[0] << 8) | protected_[1];
    var offset = 2;
    var chunks = [];

    for (var i = 0; i < numBlocks; i++) {
        if (offset >= protected_.length) throw new Error('RS data truncated at block ' + i);
        var actualDataLen = protected_[offset];
        offset++;
        var encodedLen = actualDataLen + parityBytes;
        if (offset + encodedLen > protected_.length) throw new Error('RS block ' + i + ' truncated');
        var encoded = protected_.slice(offset, offset + encodedLen);
        offset += encodedLen;
        var decoded = rsDecode(encoded, parityBytes);
        chunks.push(decoded.slice(0, actualDataLen));
    }

    var totalLen = 0;
    for (var j = 0; j < chunks.length; j++) totalLen += chunks[j].length;
    var result = new Uint8Array(totalLen);
    var pos = 0;
    for (var k = 0; k < chunks.length; k++) {
        result.set(chunks[k], pos);
        pos += chunks[k].length;
    }
    return result;
}

// Export
window.StegoRS = {
    GF_EXP: GF_EXP,
    GF_LOG: GF_LOG,
    gfMul: gfMul,
    gfDiv: gfDiv,
    gfPow: gfPow,
    gfInverse: gfInverse,
    rsEncode: rsEncode,
    rsDecode: rsDecode,
    rsProtect: rsProtect,
    rsUnprotect: rsUnprotect
};

})();
