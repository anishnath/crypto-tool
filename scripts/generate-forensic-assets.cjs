#!/usr/bin/env node
/**
 * Generate static forensic CTF assets.
 * Run: node scripts/generate-forensic-assets.cjs
 * Output: src/main/webapp/ctf/assets/forensic/*.bin + MANIFEST.json
 */
'use strict';

var fs = require('fs');
var path = require('path');

var OUT_DIR = path.join(__dirname, '..', 'src', 'main', 'webapp', 'ctf', 'assets', 'forensic');

var VARIANTS = [
    { id: 'mem-dump-1', flag: 'flag{volatility_master}', proc: 'notepad.exe', path: 'C:\\Users\\admin\\Desktop\\secret.txt' },
    { id: 'mem-dump-2', flag: 'flag{memory_carve_dump}', proc: 'mspaint.exe', path: 'C:\\Users\\victim\\Documents\\stash.txt' },
    { id: 'mem-dump-3', flag: 'flag{volatility_cmd_inject}', proc: 'cmd.exe', path: 'D:\\temp\\credentials.bak' },
    { id: 'ntfs-mft-1', flag: 'flag{ntfs_forensic_master}', filename: 'flag.txt' },
    { id: 'ntfs-mft-2', flag: 'flag{mft_record_carve}', filename: 'secret.dat' },
    { id: 'ntfs-mft-3', flag: 'flag{deleted_ntfs_recover}', filename: 'confidential.log' },
    { id: 'firmware-router-1', flag: 'flag{firmware_carve_master}', zipname: 'flag.txt' },
    { id: 'firmware-router-2', flag: 'flag{hidden_squashfs_partition}', zipname: 'backdoor.conf' },
    { id: 'recycle-bin-1', flag: 'flag{recycle_bin_master}', filename: 'flag.txt', path: 'C:\\Users\\admin\\Desktop\\' },
    { id: 'recycle-bin-2', flag: 'flag{trash_forensics}', filename: 'password.txt', path: 'C:\\Users\\sysadmin\\Downloads\\' },
    { id: 'wpa-handshake-1', flag: 'flag{wpa_crack_master}' },
    { id: 'wpa-handshake-2', flag: 'flag{aircrack_pwned}' }
];

function ensureDir(dir) {
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
}

function writeBin(filename, data) {
    var p = path.join(OUT_DIR, filename);
    fs.writeFileSync(p, Buffer.from(data), 'binary');
    console.log('Wrote:', p);
}

function randomBytes(len) {
    var out = new Uint8Array(len);
    for (var i = 0; i < len; i++) out[i] = Math.floor(Math.random() * 256);
    return out;
}

function genMemDump(v) {
    v = v || VARIANTS.find(function(x) { return x.id === 'mem-dump-1'; });
    var parts = [];
    parts.push(randomBytes(4096));
    parts.push(new TextEncoder().encode((v.proc || 'notepad.exe') + '\x00'));
    parts.push(randomBytes(256));
    parts.push(new TextEncoder().encode((v.path || 'C:\\Users\\admin\\Desktop\\secret.txt') + '\x00'));
    parts.push(randomBytes(512));
    parts.push(new TextEncoder().encode(v.flag + '\x00'));
    parts.push(randomBytes(8192));
    parts.push(new TextEncoder().encode('cmd.exe\x00'));
    parts.push(randomBytes(2048));
    var total = parts.reduce(function(s, p) { return s + p.length; }, 0);
    var out = new Uint8Array(total);
    var pos = 0;
    for (var i = 0; i < parts.length; i++) { out.set(parts[i], pos); pos += parts[i].length; }
    return out;
}

function genNtfsMft(v) {
    v = v || VARIANTS.find(function(x) { return x.id === 'ntfs-mft-1'; });
    var FILE = [0x46, 0x49, 0x4C, 0x45];
    var chunk = new Uint8Array(1024);
    chunk[0] = FILE[0]; chunk[1] = FILE[1]; chunk[2] = FILE[2]; chunk[3] = FILE[3];
    var name = v.filename || 'flag.txt';
    for (var i = 0; i < name.length; i++) chunk[0x58 + i] = name.charCodeAt(i);
    var flagBytes = new TextEncoder().encode(v.flag);
    for (var j = 0; j < flagBytes.length; j++) chunk[0x200 + j] = flagBytes[j];
    var out = new Uint8Array(8192);
    out.set(randomBytes(1024), 0);
    out.set(chunk, 1024);
    out.set(randomBytes(1024), 2048);
    out.set(chunk, 3072);
    out.set(randomBytes(4096), 4096);
    return out;
}

function _crc32zip(data) {
    var table = [];
    for (var n = 0; n < 256; n++) {
        var c = n;
        for (var k = 0; k < 8; k++) c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
        table[n] = c >>> 0;
    }
    var crc = 0xFFFFFFFF;
    for (var i = 0; i < data.length; i++) crc = table[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8);
    return (crc ^ 0xFFFFFFFF) >>> 0;
}

function genMinimalZip(content, filename) {
    var fn = Buffer.from(filename, 'utf8');
    var data = Buffer.from(content, 'utf8');
    var crc = _crc32zip(data);
    var h = Buffer.alloc(30 + fn.length);
    h.writeUInt32LE(0x04034b50, 0);
    h.writeUInt16LE(20, 4);
    h.writeUInt16LE(0, 12);
    h.writeUInt32LE(crc, 14);
    h.writeUInt32LE(data.length, 18);
    h.writeUInt32LE(data.length, 22);
    h.writeUInt16LE(fn.length, 26);
    fn.copy(h, 30);
    var local = Buffer.concat([h, data]);
    var cen = Buffer.alloc(46 + fn.length);
    cen.writeUInt32LE(0x02014b50, 0);
    cen.writeUInt16LE(20, 4);
    cen.writeUInt32LE(crc, 16);
    cen.writeUInt32LE(data.length, 20);
    cen.writeUInt32LE(data.length, 24);
    cen.writeUInt16LE(fn.length, 28);
    fn.copy(cen, 46);
    var eocd = Buffer.alloc(22);
    eocd.writeUInt32LE(0x06054b50, 0);
    eocd.writeUInt16LE(1, 8);
    eocd.writeUInt16LE(1, 10);
    eocd.writeUInt32LE(cen.length, 12);
    eocd.writeUInt32LE(local.length, 16);
    return Buffer.concat([local, cen, eocd]);
}

function genFirmwareRouter(v) {
    v = v || VARIANTS.find(function(x) { return x.id === 'firmware-router-1'; });
    var zipBin = genMinimalZip(v.flag, v.zipname || 'flag.txt');
    var squashfsSig = [0x68, 0x73, 0x71, 0x73];
    var parts = [];
    parts.push(Buffer.from([0x00, 0x00, 0x00, 0x00]));
    parts.push(Buffer.from(squashfsSig));
    parts.push(Buffer.alloc(64, 0));
    parts.push(randomBytes(512));
    parts.push(zipBin);
    parts.push(randomBytes(256));
    return Buffer.concat(parts);
}

function genRecycleBin(v) {
    v = v || VARIANTS.find(function(x) { return x.id === 'recycle-bin-1'; });
    var filename = v.filename || 'flag.txt';
    var origPath = (v.path || 'C:\\Users\\admin\\Desktop\\') + filename;
    var delim = Buffer.from([0, 0]);
    var iContent = Buffer.alloc(1024, 0);
    iContent.write(origPath, 0);
    var rContent = Buffer.from(v.flag);
    var rFile = Buffer.concat([rContent, Buffer.alloc(1024 - rContent.length, 0)]);
    return Buffer.concat([
        Buffer.from('$I', 'utf8'), delim, iContent,
        Buffer.from('$R', 'utf8'), delim, rFile
    ]);
}

function genWpaHandshake(v) {
    v = v || VARIANTS.find(function(x) { return x.id === 'wpa-handshake-1'; });
    var flag = v.flag;
    var magic = [0xa1, 0xb2, 0xc3, 0xd4];
    var gheader = Buffer.alloc(24);
    gheader[0] = magic[0]; gheader[1] = magic[1]; gheader[2] = magic[2]; gheader[3] = magic[3];
    gheader[4] = 2; gheader[5] = 0; gheader[6] = 4; gheader[7] = 0;
    gheader[16] = 0; gheader[17] = 0; gheader[18] = 6; gheader[19] = 0;
    gheader[20] = 1; gheader[21] = 0; gheader[22] = 0; gheader[23] = 0;
    var pheader = Buffer.alloc(16);
    var ts = Math.floor(Date.now() / 1000);
    pheader.writeUInt32BE(ts, 0);
    var eth = Buffer.alloc(14 + 8);
    eth[12] = 0x88; eth[13] = 0x8e;
    var radiotap = Buffer.alloc(26, 0);
    radiotap[0] = 0; radiotap[2] = 26;
    var body = Buffer.alloc(64);
    body.write('WPA_HANDSHAKE_HINT: use aircrack-ng with rockyou. Password: password123', 0);
    var payload = Buffer.concat([radiotap, eth, body]);
    pheader.writeUInt32BE(payload.length, 8);
    pheader.writeUInt32BE(payload.length, 12);
    var packet = Buffer.concat([pheader, payload]);
    var hint = Buffer.from('HINT: Decrypted traffic contains: ' + flag, 'utf8');
    var p2 = Buffer.concat([Buffer.alloc(16, 0), Buffer.alloc(14, 0), hint]);
    p2.writeUInt32BE(ts + 1, 0);
    p2.writeUInt32BE(p2.length - 16, 8);
    p2.writeUInt32BE(p2.length - 16, 12);
    return Buffer.concat([gheader, packet, p2]);
}

var manifest = {
    version: '1.0',
    generator: '8gwifi.org Forensic CTF Static Assets',
    assets: {}
};

var TOOL_HINTS = {
    mem: 'strings, volatility (conceptual)',
    ntfs: 'sleuthkit, analyzeMFT, or manual parse',
    firmware: 'binwalk -e, unzip carved ZIP',
    recycle: 'Parse $I/$R format, read $R content',
    wpa: 'Wireshark: packet contains hint with flag'
};

ensureDir(OUT_DIR);
ensureDir(path.dirname(OUT_DIR));

VARIANTS.forEach(function(v) {
    var id = v.id;
    var data;
    if (id.startsWith('mem-dump-')) data = genMemDump(v);
    else if (id.startsWith('ntfs-mft-')) data = genNtfsMft(v);
    else if (id.startsWith('firmware-router-')) data = genFirmwareRouter(v);
    else if (id.startsWith('recycle-bin-')) data = genRecycleBin(v);
    else if (id.startsWith('wpa-handshake-')) data = genWpaHandshake(v);
    else return;
    writeBin(id + '.bin', data);
    var toolKey = id.split('-')[0];
    manifest.assets[id] = { flag: v.flag, tool: TOOL_HINTS[toolKey] || 'See MANIFEST' };
});

fs.writeFileSync(path.join(OUT_DIR, 'MANIFEST.json'), JSON.stringify(manifest, null, 2), 'utf8');
console.log('Wrote MANIFEST.json');
console.log('Done. Generated', Object.keys(manifest.assets).length, 'asset variants.');
