/**
 * Test: QEMU SSE simulation flow for ESP32-C3.
 *
 * Run: QEMU_RISCV32_BINARY=/path/to/qemu-system-riscv32 API_BASE=http://localhost:8080 node test-qemu-sse.mjs
 *
 * Tests the full flow:
 *   1. Compile ESP32-C3 sketch with DIO flash mode
 *   2. POST /api/arduino-simulate/start with merged firmware
 *   3. GET /api/arduino-simulate/stream (SSE) and wait for serial output
 *   4. POST /api/arduino-simulate/stop
 *
 * Can run against:
 *   - Go API directly (API_BASE=http://localhost:8080)
 *   - Java servlet proxy (API_BASE=http://localhost:8080, path prefix /api/arduino/simulate/)
 *
 * If API_BASE is not set, runs a standalone QEMU test using the Go QemuManager directly.
 */

import { execSync, spawnSync } from 'child_process';
import { mkdtempSync, writeFileSync, mkdirSync, readFileSync, existsSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

const API_BASE = process.env.API_BASE || '';

let passed = 0;
let failed = 0;

function assert(cond, msg) {
  if (cond) { passed++; }
  else { failed++; console.error('  FAIL:', msg); }
}

// ── Check prerequisites ──
let hasArduinoCli = false;
try { execSync('arduino-cli version', { stdio: 'pipe' }); hasArduinoCli = true; } catch {}

if (!hasArduinoCli) {
  console.log('SKIP: arduino-cli not available');
  process.exit(0);
}

// ── Test 1: Compile ESP32-C3 with DIO flash mode ──
console.log('=== Test 1: Compile ESP32-C3 (DIO flash mode) ===');

const dir = mkdtempSync(join(tmpdir(), 'qemu-sse-'));
const sketchDir = join(dir, 'sketch');
mkdirSync(sketchDir);
writeFileSync(join(sketchDir, 'sketch.ino'), `
void setup() {
  Serial.begin(115200);
  pinMode(8, OUTPUT);
}
void loop() {
  Serial.println("QEMU_SSE_TEST_OK");
  digitalWrite(8, HIGH);
  delay(200);
  digitalWrite(8, LOW);
  delay(200);
}
`);

const outDir = join(dir, 'out');
mkdirSync(outDir);

const compileResult = spawnSync('arduino-cli', [
  'compile', '--fqbn', 'esp32:esp32:esp32c3:FlashMode=dio', '--output-dir', outDir, sketchDir
], { timeout: 120000, stdio: 'pipe' });

assert(compileResult.status === 0, 'Compile should succeed');

const mergedPath = join(outDir, 'sketch.ino.merged.bin');
assert(existsSync(mergedPath), 'merged.bin should exist');

const mergedBytes = readFileSync(mergedPath);
const mergedB64 = mergedBytes.toString('base64');
console.log('  Merged image:', mergedBytes.length, 'bytes');
console.log('PASS: Compilation\n');

// ── Test 2: SSE flow (API-based or standalone) ──

if (API_BASE) {
  console.log('=== Test 2: SSE Flow (API at ' + API_BASE + ') ===');

  const sessionId = 'test-' + Date.now();

  // Start
  const startResp = await fetch(API_BASE + '/api/arduino-simulate/start', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id: sessionId, board: 'esp32:esp32:esp32c3', firmware: mergedB64 }),
  });
  const startData = await startResp.json();
  assert(startData.success, 'Start should succeed: ' + JSON.stringify(startData));
  console.log('  Started:', startData);

  // Stream SSE events
  let serialOut = '';
  let gotTestOK = false;
  const sseUrl = API_BASE + '/api/arduino-simulate/stream?id=' + encodeURIComponent(sessionId);

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 15000);

  try {
    const sseResp = await fetch(sseUrl, { signal: controller.signal });
    const reader = sseResp.body.getReader();
    const decoder = new TextDecoder();

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      const text = decoder.decode(value, { stream: true });
      // Parse SSE lines
      for (const line of text.split('\n')) {
        if (line.startsWith('data: ')) {
          try {
            const ev = JSON.parse(line.slice(6));
            if (ev.type === 'serial_output' && ev.data?.data) {
              serialOut += ev.data.data;
              process.stdout.write(ev.data.data);
              if (serialOut.includes('QEMU_SSE_TEST_OK')) {
                gotTestOK = true;
                controller.abort();
              }
            } else if (ev.type === 'system') {
              console.log('  [system]', ev.data?.event);
            }
          } catch {}
        }
      }
    }
  } catch (e) {
    if (e.name !== 'AbortError') console.error('  SSE error:', e.message);
  }
  clearTimeout(timeout);

  assert(gotTestOK, 'Should receive QEMU_SSE_TEST_OK from serial');

  // Stop
  const stopResp = await fetch(API_BASE + '/api/arduino-simulate/stop', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id: sessionId }),
  });
  const stopData = await stopResp.json();
  assert(stopData.success, 'Stop should succeed');

  console.log('  Serial output:', serialOut.length, 'chars');
  console.log(gotTestOK ? 'PASS: SSE flow\n' : 'FAIL: SSE flow\n');

} else {
  console.log('=== Test 2: Standalone QEMU test (no API server) ===');
  console.log('  Set API_BASE=http://localhost:8080 to test SSE flow');
  console.log('  Running direct QEMU verification instead...\n');

  // Direct QEMU test using child process
  const qemuBinary = process.env.QEMU_RISCV32_BINARY || 'qemu-system-riscv32';
  let hasQemu = false;
  try { execSync(qemuBinary + ' --version', { stdio: 'pipe' }); hasQemu = true; } catch {}

  if (!hasQemu) {
    console.log('  SKIP: qemu-system-riscv32 not available');
    console.log('  Set QEMU_RISCV32_BINARY=/path/to/qemu-system-riscv32');
  } else {
    console.log('  Running QEMU directly for 8 seconds...');

    const { spawn } = await import('child_process');
    const qemu = spawn(qemuBinary, [
      '-machine', 'esp32c3',
      '-nographic',
      '-drive', `file=${mergedPath},if=mtd,format=raw`,
      '-serial', 'mon:stdio',
      '-no-reboot',
    ]);

    let output = '';
    let gotOK = false;

    qemu.stdout.on('data', (data) => {
      output += data.toString();
      if (output.includes('QEMU_SSE_TEST_OK') && !gotOK) {
        gotOK = true;
        qemu.kill();
      }
    });
    qemu.stderr.on('data', (data) => { output += data.toString(); });

    await new Promise((resolve) => {
      const kill = setTimeout(() => { qemu.kill(); resolve(); }, 8000);
      qemu.on('close', () => { clearTimeout(kill); resolve(); });
    });

    assert(gotOK, 'QEMU should output QEMU_SSE_TEST_OK');
    console.log('  QEMU output:', output.length, 'chars');
    if (gotOK) console.log('PASS: Direct QEMU\n');
    else {
      console.log('  First 300 chars:', output.slice(0, 300));
      console.log('FAIL: Direct QEMU\n');
    }
  }
}

// ── Results ──
console.log('=== Results ===');
console.log('Passed:', passed);
console.log('Failed:', failed);
console.log(failed === 0 ? '\nALL TESTS PASSED' : '\nSOME TESTS FAILED');
process.exit(failed > 0 ? 1 : 0);
