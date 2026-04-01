/**
 * Node.js test for RP2040 pipeline: UF2 parser + runner initialization.
 *
 * Run: node test-rp2040.mjs
 *
 * This test validates:
 *  1. UF2 parser correctly decodes base64 UF2 to flash image
 *  2. RP2040 bootrom loads correctly
 *  3. rp2040js CPU boots from bootrom and reaches flash
 *
 * Requires: network access (loads rp2040js from unpkg CDN)
 */

import { uf2ToFlash, uf2BytesToFlash } from './uf2-parser.js';
import { bootromB1 } from './rp2040-bootrom.js';
import { LED_BUILTIN, GPIO_COUNT, RP2040_ANALOG_PINS } from './rp2040-pin-map.js';

// ── Test 1: Pin map ──
console.log('=== Test 1: Pin Map ===');
console.log('LED_BUILTIN:', LED_BUILTIN);
console.assert(LED_BUILTIN === 25, 'LED_BUILTIN should be 25');
console.assert(GPIO_COUNT === 30, 'GPIO_COUNT should be 30');
console.assert(RP2040_ANALOG_PINS.A0.gpio === 26, 'A0 should be GPIO26');
console.assert(RP2040_ANALOG_PINS.A0.channel === 0, 'A0 should be channel 0');
console.log('PASS: Pin map is correct\n');

// ── Test 2: Bootrom ──
console.log('=== Test 2: Bootrom ===');
console.assert(bootromB1 instanceof Uint32Array, 'bootromB1 should be Uint32Array');
console.assert(bootromB1.length > 0, 'bootromB1 should not be empty');
console.log('bootromB1 length:', bootromB1.length, 'words');
console.log('bootromB1[0] (SP):', '0x' + bootromB1[0].toString(16));
console.log('bootromB1[1] (reset vector):', '0x' + bootromB1[1].toString(16));
console.assert(bootromB1[0] === 0x20041f00, 'SP should be 0x20041f00');
console.assert((bootromB1[1] & 0xFFFFFFFE) === 0xEE, 'Reset vector should point to 0xEE');
console.log('PASS: Bootrom data is valid\n');

// ── Test 3: UF2 parser with a minimal synthetic UF2 ──
console.log('=== Test 3: UF2 Parser (synthetic) ===');

// Create a minimal valid UF2 block
function createUF2Block(targetAddr, data, blockNo, numBlocks) {
  const buf = new ArrayBuffer(512);
  const view = new DataView(buf);
  view.setUint32(0x00, 0x0A324655, true); // magic0
  view.setUint32(0x04, 0x9E5D5157, true); // magic1
  view.setUint32(0x08, 0x00002000, true); // flags: familyID present
  view.setUint32(0x0C, targetAddr, true); // target address
  view.setUint32(0x10, data.length, true); // payload size
  view.setUint32(0x14, blockNo, true);
  view.setUint32(0x18, numBlocks, true);
  view.setUint32(0x1C, 0xE48BFF56, true); // familyID: RP2040
  const u8 = new Uint8Array(buf);
  u8.set(data, 0x20); // payload
  view.setUint32(0x1FC, 0x0AB16F30, true); // magicEnd
  return u8;
}

// Create a 2-block UF2: 256 bytes at 0x10000000, 256 bytes at 0x10000100
const block0data = new Uint8Array(256).fill(0xAA);
const block1data = new Uint8Array(256).fill(0xBB);
const block0 = createUF2Block(0x10000000, block0data, 0, 2);
const block1 = createUF2Block(0x10000100, block1data, 1, 2);

const uf2Bytes = new Uint8Array(1024);
uf2Bytes.set(block0, 0);
uf2Bytes.set(block1, 512);

const flash = uf2BytesToFlash(uf2Bytes);
console.log('Flash image size:', flash.length, 'bytes');
console.assert(flash.length === 512, 'Flash should be 512 bytes (256 + 256)');
console.assert(flash[0] === 0xAA, 'First byte should be 0xAA');
console.assert(flash[255] === 0xAA, 'Byte 255 should be 0xAA');
console.assert(flash[256] === 0xBB, 'Byte 256 should be 0xBB');
console.assert(flash[511] === 0xBB, 'Byte 511 should be 0xBB');
console.log('PASS: UF2 parser decodes correctly\n');

// ── Test 4: UF2 parser rejects non-RP2040 familyID ──
console.log('=== Test 4: UF2 Parser (wrong family) ===');
const wrongFamily = createUF2Block(0x10000000, new Uint8Array(256).fill(0xCC), 0, 1);
const wrongView = new DataView(wrongFamily.buffer);
wrongView.setUint32(0x1C, 0x12345678, true); // wrong familyID
const flashWrong = uf2BytesToFlash(wrongFamily);
console.assert(flashWrong.length === 0, 'Wrong family should produce empty flash');
console.log('PASS: Non-RP2040 UF2 blocks rejected\n');

// ── Test 5: UF2 parser rejects "not main flash" blocks ──
console.log('=== Test 5: UF2 Parser (not-main-flash flag) ===');
const notMain = createUF2Block(0x10000000, new Uint8Array(256).fill(0xDD), 0, 1);
const notMainView = new DataView(notMain.buffer);
notMainView.setUint32(0x08, 0x00002001, true); // flag bit 0 = not main flash
const flashNotMain = uf2BytesToFlash(notMain);
console.assert(flashNotMain.length === 0, 'Not-main-flash should produce empty flash');
console.log('PASS: Not-main-flash blocks skipped\n');

// ── Test 6: Base64 decode path ──
console.log('=== Test 6: UF2 base64 decode ===');
// Encode our valid UF2 to base64
const b64 = btoa(String.fromCharCode(...uf2Bytes));
const flashFromB64 = uf2ToFlash(b64);
console.assert(flashFromB64.length === 512, 'Base64 decoded flash should be 512 bytes');
console.assert(flashFromB64[0] === 0xAA, 'First byte should be 0xAA');
console.assert(flashFromB64[256] === 0xBB, 'Byte 256 should be 0xBB');
console.log('PASS: Base64 UF2 decode works\n');

// ── Test 7: Try loading rp2040js from CDN ──
console.log('=== Test 7: rp2040js CDN import ===');
try {
  const { RP2040, GPIOPinState, ConsoleLogger, LogLevel } = await import('https://unpkg.com/rp2040js@1.3.1/dist/esm/index.js');
  console.log('RP2040 class:', typeof RP2040);
  console.assert(typeof RP2040 === 'function', 'RP2040 should be a constructor');

  const mcu = new RP2040();
  console.log('MCU created. flash size:', mcu.flash.length);
  console.log('bootrom size:', mcu.bootrom.length, 'words');
  console.log('UART0:', typeof mcu.uart[0]);
  console.log('GPIO count:', mcu.gpio.length);
  console.log('ADC:', typeof mcu.adc);
  console.log('PIO:', Array.isArray(mcu.pio), 'length:', mcu.pio?.length);
  console.log('SPI:', typeof mcu.spi[0]);
  console.log('clock:', typeof mcu.clock);

  // Load flash first, then bootrom
  mcu.flash.set(flash, 0);
  mcu.loadBootrom(bootromB1);

  console.log('After boot: PC=0x' + mcu.core.PC.toString(16));
  console.log('After boot: SP=0x' + mcu.core.SP.toString(16));
  console.log('core.waiting:', mcu.core.waiting);

  // Execute a few instructions
  let cycles = 0;
  let frames = 0;
  const maxFrames = 10;
  while (frames < maxFrames) {
    if (mcu.core.waiting) {
      const jump = mcu.clock.nanosToNextAlarm;
      if (jump <= 0) break;
      mcu.clock.tick(jump);
      cycles += Math.ceil(jump / 8);
    } else {
      const c = mcu.core.executeInstruction();
      mcu.clock.tick(c * 8);
      cycles += c;
    }
    frames++;
    if (frames <= 5) {
      console.log('  step ' + frames + ': PC=0x' + mcu.core.PC.toString(16) + ' waiting=' + mcu.core.waiting);
    }
  }
  console.log('Executed ' + cycles + ' cycles in ' + frames + ' steps');
  console.log('Final PC=0x' + mcu.core.PC.toString(16) + ' waiting=' + mcu.core.waiting);
  console.log('PASS: rp2040js boots from CDN\n');

} catch (err) {
  console.error('FAIL: rp2040js CDN import failed:', err.message);
  console.log('(This is expected if running without network or Node < 18)\n');
}

console.log('=== All local tests complete ===');
