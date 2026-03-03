#!/usr/bin/env node
/**
 * Reverse Engineering CTF Engine - Node.js Test
 * Run: node test-re-engine.cjs
 * Or from project root: node src/main/webapp/ctf/test-re-engine.cjs
 */
'use strict';

var path = require('path');

var jsDir = path.join(__dirname, 'js');
require(path.join(jsDir, 'ctf-steps.js'));
var Engine = require(path.join(jsDir, 'ctf-re-engine.js'));
if (!Engine || !Engine.generate) {
    Engine = global.CTFREEngine;
}
if (!Engine || !Engine.generate) {
    console.error('CTFREEngine not loaded. Engine keys:', Engine ? Object.keys(Engine) : 'null');
    process.exit(1);
}

var steps = global.CTFSteps;
if (!steps) {
    console.error('CTFSteps not loaded');
    process.exit(1);
}

var FLAG = 'flag{re_test_master}';
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

    switch (bundle.meta.type) {
        case 'obfuscatedString': {
            var codeBin = bytesFromB64(c.data);
            var code = new TextDecoder().decode(codeBin);
            var hexMatch = code.match(/"([0-9a-fA-F]+)"/);
            var b64Match = code.match(/"([A-Za-z0-9+/=]+)"/);
            var decoded = null;
            if (hexMatch && hexMatch[1].length % 2 === 0) {
                var hex = hexMatch[1];
                var buf = [];
                for (var i = 0; i < hex.length; i += 2) buf.push(parseInt(hex.substr(i, 2), 16));
                decoded = new TextDecoder().decode(new Uint8Array(buf));
            } else if (b64Match) {
                try {
                    decoded = Buffer.from(b64Match[1], 'base64').toString('utf8');
                } catch (_) {}
            }
            assert(decoded === expectedFlag, 'obfuscatedString: flag matches');
            break;
        }
        case 'obfuscatedControlFlow': {
            var tMatch = c.code.match(/var t="([^"]+)"/);
            assert(tMatch && tMatch[1] === expectedFlag, 'obfuscatedControlFlow: flag in code');
            break;
        }
        case 'logicGateOutput': {
            var bits = c.outputBits;
            var bytes = [];
            for (var bi = 0; bi < bits.length; bi += 8) {
                if (bi + 8 <= bits.length) {
                    var byte = 0;
                    for (var bj = 0; bj < 8; bj++) byte = (byte << 1) | (bits[bi + bj] === '1' ? 1 : 0);
                    bytes.push(byte);
                }
            }
            var str = new TextDecoder().decode(new Uint8Array(bytes));
            assert(str === expectedFlag, 'logicGateOutput: flag matches');
            break;
        }
        case 'logicGateTruthTable': {
            var chars = [];
            for (var ti = 0; ti < c.table.length; ti++) {
                var row = c.table[ti];
                var out = row.a ^ row.b;
                var hi = (out >> 4) & 0xF;
                var lo = out & 0xF;
                var ch = (row.a << 4) | row.b;
                chars.push(ch);
            }
            var tblStr = new TextDecoder().decode(new Uint8Array(chars));
            assert(tblStr === expectedFlag, 'logicGateTruthTable: flag matches');
            break;
        }
        case 'stateMachineFlag': {
            var reads = c.transitions.map(function(t) { return t.read; });
            var fsmStr = reads.join('');
            assert(fsmStr === expectedFlag, 'stateMachineFlag: flag matches');
            break;
        }
        case 'bitwiseXorChain': {
            var hex = c.encodedHex;
            var key = s.xorKey;
            var encBuf = Buffer.from(hex, 'hex');
            var decBuf = new Uint8Array(encBuf.length);
            for (var bi = 0; bi < encBuf.length; bi++) decBuf[bi] = encBuf[bi] ^ key;
            var xorStr = new TextDecoder().decode(decBuf);
            assert(xorStr === expectedFlag, 'bitwiseXorChain: flag matches');
            break;
        }
        case 'hexDumpCarve': {
            var blob = bytesFromB64(c.data);
            var txt = new TextDecoder('utf-8', { fatal: false }).decode(blob);
            var idx = txt.indexOf(expectedFlag);
            assert(idx >= 0, 'hexDumpCarve: flag in data');
            break;
        }
        case 'structLayoutParse': {
            var arr = bytesFromB64(c.data);
            var len = arr[12] | (arr[13] << 8);
            var dataStart = 14;
            var data = arr.slice(dataStart, dataStart + len);
            var parsed = new TextDecoder().decode(data);
            assert(parsed === expectedFlag, 'structLayoutParse: flag matches');
            break;
        }
        case 'endianSwap': {
            var swapped = bytesFromB64(c.data);
            var unswap = [];
            for (var ei = 0; ei < swapped.length; ei += 2) {
                if (ei + 1 < swapped.length) {
                    unswap.push(swapped[ei + 1]);
                    unswap.push(swapped[ei]);
                } else {
                    unswap.push(swapped[ei]);
                }
            }
            var endStr = new TextDecoder().decode(new Uint8Array(unswap));
            assert(endStr === expectedFlag, 'endianSwap: flag matches');
            break;
        }
        case 'nativeElfStrings':
        case 'nativeElfSymbols':
            assert(s.flag === bundle.meta.type === 'nativeElfStrings' ? 'flag{elf_strings_master}' : 'flag{readelf_dynsym}', 'static: solution flag');
            break;
        default:
            break;
    }
}

var STATIC_TYPES = { nativeElfStrings: 1, nativeElfSymbols: 1 };
var STATIC_FLAGS = { nativeElfStrings: 'flag{elf_strings_master}', nativeElfSymbols: 'flag{readelf_dynsym}' };

function runTest(type) {
    var flag = STATIC_TYPES[type] ? STATIC_FLAGS[type] : FLAG;
    return Engine.generate(type, flag, { seed: 42, hintCount: 3 }).then(function(bundle) {
        assert(bundle && bundle.meta && bundle.challenge && bundle.solution && bundle.hints, type + ': bundle structure');
        if (STATIC_TYPES[type]) {
            assert(bundle.solution.flag === STATIC_FLAGS[type], type + ': solution flag');
        } else {
            assert(bundle.solution.flag === FLAG, type + ': solution flag');
        }
        assert(bundle.meta.type === type, type + ': meta type');
        try {
            verifySolve(bundle, STATIC_TYPES[type] ? STATIC_FLAGS[type] : FLAG);
        } catch (e) {
            assert(false, type + ': solve verification - ' + e.message);
        }
    }).catch(function(err) {
        assert(false, type + ': ' + (err.message || err));
    });
}

var types = Engine.listTypes ? Engine.listTypes() : Object.keys(Engine.GENERATORS || {});
if (Array.isArray(types) && types[0] && typeof types[0] === 'object') {
    types = types.map(function(t) { return t.id; });
}

console.log('Reverse Engineering CTF Engine Tests');
console.log('====================================\n');

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
