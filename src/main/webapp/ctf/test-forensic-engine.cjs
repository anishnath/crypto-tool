#!/usr/bin/env node
/**
 * Forensic CTF Engine - Node.js Test
 * Run: node test-forensic-engine.cjs
 * Or from project root: node src/main/webapp/ctf/test-forensic-engine.cjs
 */
'use strict';

var path = require('path');

var jsDir = path.join(__dirname, 'js');
require(path.join(jsDir, 'ctf-steps.js'));
var Engine = require(path.join(jsDir, 'ctf-forensic-engine.js'));
if (!Engine || !Engine.generate) {
    Engine = global.CTFForensicEngine;
}
if (!Engine || !Engine.generate) {
    console.error('CTFForensicEngine not loaded. Engine keys:', Engine ? Object.keys(Engine) : 'null');
    process.exit(1);
}

var steps = global.CTFSteps;
if (!steps) {
    console.error('CTFSteps not loaded');
    process.exit(1);
}

var FLAG = 'flag{forensic_master}';
var passed = 0;
var failed = 0;

function assert(cond, msg) {
    if (cond) {
        passed++;
        console.log('  PASS: ' + msg);
    } else {
        failed++;
        console.log('  FAIL: ' + msg);
    }
}

function bytesFromB64(b64) {
    var bin = Buffer.from(b64, 'base64').toString('binary');
    return new Uint8Array(bin.length).map(function(_, i) { return bin.charCodeAt(i); });
}

function verifySolve(bundle, expectedFlag) {
    var c = bundle.challenge;
    var s = bundle.solution;
    var stepsObj = steps;

    if (bundle.meta.type === 'magicByteCarve') {
        var blob = bytesFromB64(c.data);
        var pk = [0x50, 0x4B, 0x03, 0x04];
        var idx = -1;
        for (var i = 0; i <= blob.length - 4; i++) {
            if (blob[i] === pk[0] && blob[i+1] === pk[1] && blob[i+2] === pk[2] && blob[i+3] === pk[3]) {
                idx = i;
                break;
            }
        }
        assert(idx >= 0, 'magicByteCarve: PK found');
        var zipBytes = blob.subarray(idx);
        var zipB64 = btoa(String.fromCharCode.apply(null, zipBytes));
        var extracted = stepsObj.zipWrap.decode(zipB64, {});
        assert(extracted === expectedFlag, 'magicByteCarve: flag matches');
    } else if (bundle.meta.type === 'wrongExtension') {
        var dec = stepsObj.zipWrap.decode(c.data, {});
        assert(dec === expectedFlag, 'wrongExtension: flag matches');
    } else if (bundle.meta.type === 'corruptedPngMagic') {
        var corr = bytesFromB64(c.data);
        corr[0] = 0x89; corr[1] = 0x50; corr[2] = 0x4E; corr[3] = 0x47;
        corr[4] = 0x0D; corr[5] = 0x0A; corr[6] = 0x1A; corr[7] = 0x0A;
        var fixedB64 = btoa(String.fromCharCode.apply(null, corr));
        var offset = 8;
        while (offset + 12 <= corr.length) {
            var len = (corr[offset] << 24) | (corr[offset+1] << 16) | (corr[offset+2] << 8) | corr[offset+3];
            var type = String.fromCharCode(corr[offset+4], corr[offset+5], corr[offset+6], corr[offset+7]);
            if (type === 'tEXt' && offset + 12 + len <= corr.length) {
                var data = corr.subarray(offset + 8, offset + 8 + len);
                var nul = data.indexOf(0);
                if (nul > 0) {
                    var txt = new TextDecoder().decode(data.subarray(nul + 1));
                    assert(txt === expectedFlag, 'corruptedPngMagic: flag from tEXt');
                    break;
                }
            }
            offset += 12 + len + (len % 2);
        }
    } else if (bundle.meta.type === 'pngMetadataFlag' || bundle.meta.type === 'base64InMetadata') {
        var pngBytes = bytesFromB64(c.data);
        var off = 8;
        var found = false;
        while (off + 12 <= pngBytes.length) {
            var l = (pngBytes[off] << 24) | (pngBytes[off+1] << 16) | (pngBytes[off+2] << 8) | pngBytes[off+3];
            var t = String.fromCharCode(pngBytes[off+4], pngBytes[off+5], pngBytes[off+6], pngBytes[off+7]);
            if (t === 'tEXt' && off + 12 + l <= pngBytes.length) {
                var d = pngBytes.subarray(off + 8, off + 8 + l);
                var n = -1;
                for (var j = 0; j < d.length; j++) { if (d[j] === 0) { n = j; break; } }
                if (n >= 0 && n < d.length - 1) {
                    var val = new TextDecoder().decode(d.subarray(n + 1));
                    if (bundle.meta.type === 'base64InMetadata') {
                        val = stepsObj.base64.decode(val, {});
                    }
                    assert(val === expectedFlag, 'metadata: flag matches');
                    found = true;
                    break;
                }
            }
            off += 12 + l;
            if (l % 2) off++;
            if (t === 'IEND') break;
        }
        if (!found) assert(pngBytes[0] === 0x89, 'metadata: valid PNG');
    } else if (bundle.meta.type === 'stringsExtract') {
        var bin = bytesFromB64(c.data);
        var text = new TextDecoder('utf-8', { fatal: false }).decode(bin);
        var marker = s.marker || 'STEG_FLAG';
        var re = new RegExp(marker.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ':(.+?):' + marker.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
        var m = text.match(re);
        assert(m && m[1] === expectedFlag, 'stringsExtract: flag matches');
    } else if (bundle.meta.type === 'reversedBinary') {
        var revBin = Buffer.from(c.data, 'base64');
        var reversed = Buffer.alloc(revBin.length);
        for (var r = 0; r < revBin.length; r++) reversed[r] = revBin[revBin.length - 1 - r];
        var decoded = new TextDecoder().decode(reversed);
        assert(decoded === expectedFlag, 'reversedBinary: flag matches');
    } else if (bundle.meta.type === 'appendEofZip') {
        var wavBytes = bytesFromB64(c.data);
        var riff = wavBytes[0] === 0x52 && wavBytes[1] === 0x49 && wavBytes[2] === 0x46;
        assert(riff, 'appendEofZip: WAV header');
        var dataOff = 12;
        while (dataOff + 8 <= wavBytes.length) {
            var ctype = String.fromCharCode(wavBytes[dataOff], wavBytes[dataOff+1], wavBytes[dataOff+2], wavBytes[dataOff+3]);
            var cs = (wavBytes[dataOff+4] | (wavBytes[dataOff+5]<<8) | (wavBytes[dataOff+6]<<16) | (wavBytes[dataOff+7]<<24)) >>> 0;
            dataOff += 8 + cs;
            if (cs % 2) dataOff++;
            if (ctype === 'data') break;
        }
        var zipPart = wavBytes.subarray(dataOff);
        var zpk = zipPart[0] === 0x50 && zipPart[1] === 0x4B;
        assert(zpk, 'appendEofZip: ZIP after WAV');
        var zipB64 = btoa(String.fromCharCode.apply(null, zipPart));
        var ex = stepsObj.zipWrap.decode(zipB64, {});
        assert(ex === expectedFlag, 'appendEofZip: flag matches');
    } else if (bundle.meta.type === 'nestedContainers') {
        var zipDec = stepsObj.zipWrap.decode(c.data, {});
        var tarDec = stepsObj.tarWrap.decode(zipDec, {});
        assert(tarDec === expectedFlag, 'nestedContainers: flag matches');
    } else if (bundle.meta.type === 'decoyBlocks') {
        var blks = Buffer.from(c.data, 'base64').toString();
        var marker = s.marker || '<<<REAL>>>';
        var parts = blks.split('\n---\n');
        var found2 = false;
        for (var pp = 0; pp < parts.length; pp++) {
            if (parts[pp].indexOf(marker) === 0) {
                assert(parts[pp].substring(marker.length) === expectedFlag, 'decoyBlocks: flag matches');
                found2 = true;
                break;
            }
        }
        assert(found2, 'decoyBlocks: block found');
    } else if (bundle.meta.type === 'xorMaskedRegion') {
        var xb = bytesFromB64(c.data);
        var off = s.offset || 0;
        var key = s.xorKey;
        var out = new Uint8Array(s.length || expectedFlag.length);
        for (var xi = 0; xi < out.length; xi++) out[xi] = xb[off + xi] ^ key;
        assert(new TextDecoder().decode(out) === expectedFlag, 'xorMaskedRegion: flag matches');
    } else if (bundle.meta.type === 'hiddenDotFile') {
        var tarB = stepsObj.tarWrap.decode(c.data, {});
        assert(tarB === expectedFlag, 'hiddenDotFile: flag matches');
    } else if (bundle.meta.type === 'base64HexChain') {
        var dec = stepsObj.base64.decode(stepsObj.hex.decode(c.ciphertext, {}), {});
        assert(dec === expectedFlag, 'base64HexChain: flag matches');
    }
}

var STATIC_TYPES = { volatilityMemDump:1, ntfsArtifacts:1, firmwareHidden:1, recycleBin:1, wpaHandshake:1 };

function runTest(type) {
    return Engine.generate(type, FLAG, { seed: 42, hintCount: 3 }).then(function(bundle) {
        assert(bundle && bundle.meta && bundle.challenge && bundle.solution && bundle.hints, type + ': bundle structure');
        if (STATIC_TYPES[type]) {
            assert(bundle.challenge.staticAsset && typeof bundle.solution.flag === 'string' && /^flag\{.+\}$/.test(bundle.solution.flag), type + ': solution flag');
        } else {
            assert(bundle.solution.flag === FLAG, type + ': solution flag');
        }
        assert(bundle.meta.type === type, type + ': meta type');
        if (typeof verifySolve === 'function') {
            try {
                verifySolve(bundle, FLAG);
            } catch (e) {
                assert(false, type + ': solve verification - ' + e.message);
            }
        }
    }).catch(function(err) {
        assert(false, type + ': ' + (err.message || err));
    });
}

var types = Engine.listTypes ? Engine.listTypes() : Object.keys(Engine.GENERATORS || {});
if (Array.isArray(types) && types[0] && typeof types[0] === 'object') {
    types = types.map(function(t) { return t.id; });
}

console.log('Forensic CTF Engine Tests');
console.log('========================\n');

var tests = types.filter(function(t) { return t; });
var chain = Promise.resolve();
tests.forEach(function(type) {
    chain = chain.then(function() { return runTest(type); });
});

chain.then(function() {
    console.log('\nTotal: ' + (passed + failed) + ', Passed: ' + passed + ', Failed: ' + failed);
    process.exit(failed > 0 ? 1 : 0);
}).catch(function(err) {
    console.error(err);
    process.exit(1);
});
