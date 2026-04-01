/**
 * Node.js test for ESP32-C3 pipeline: bin parser + RV32IMC CPU + runner.
 *
 * Run: node test-esp32c3.mjs
 *
 * Tests:
 *  1. Pin map constants
 *  2. Bin parser with synthetic ESP-IDF image
 *  3. Bin parser with real compiled firmware
 *  4. RV32IMC CPU — RV32I base instructions
 *  5. RV32IMC CPU — M extension (mul/div)
 *  6. RV32IMC CPU — C extension (compressed)
 *  7. ESP32C3Runner — memory map
 *  8. ESP32C3Runner — GPIO peripheral
 *  9. ESP32C3Runner — UART TX
 * 10. ESP32C3Runner — SYSTIMER
 * 11. Full boot test with compiled firmware
 */

import { LED_BUILTIN, GPIO_COUNT, ESP32C3_ANALOG_PINS, ESP32C3_PINS } from './esp32c3-pin-map.js';
import { binToFirmware, parseBin } from './bin-parser.js';
import { RV32IMC_CPU } from './esp32c3-cpu.js';
import { ESP32C3Runner } from './esp32c3-runner.js';
import { execSync, spawnSync } from 'child_process';
import { readFileSync, mkdtempSync, writeFileSync, mkdirSync, existsSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

let passed = 0;
let failed = 0;

function assert(cond, msg) {
  if (cond) { passed++; }
  else { failed++; console.error('  FAIL:', msg); }
}

// ── Test 1: Pin Map ──
console.log('=== Test 1: Pin Map ===');
assert(LED_BUILTIN === 8, 'LED_BUILTIN should be 8');
assert(GPIO_COUNT === 22, 'GPIO_COUNT should be 22');
assert(ESP32C3_ANALOG_PINS.A0.gpio === 0, 'A0 should be GPIO0');
assert(ESP32C3_ANALOG_PINS.A0.channel === 0, 'A0 should be channel 0');
assert(ESP32C3_ANALOG_PINS.A5.gpio === 5, 'A5 should be GPIO5');
assert(ESP32C3_PINS.length === 22, 'Should have 22 pin entries');
assert(ESP32C3_PINS[8].label.includes('LED'), 'Pin 8 label should mention LED');
console.log('PASS: Pin map correct\n');

// ── Test 2: Bin Parser (synthetic) ──
console.log('=== Test 2: Bin Parser (synthetic) ===');
{
  // Create a minimal ESP-IDF image header + 1 segment
  const segData = new Uint8Array(16).fill(0x42);
  const headerSize = 24;
  const segHeaderSize = 8;
  const totalSize = headerSize + segHeaderSize + segData.length;
  const bin = new Uint8Array(totalSize);
  const view = new DataView(bin.buffer);

  bin[0] = 0xE9;           // magic
  bin[1] = 1;              // segment_count = 1
  view.setUint32(4, 0x42000000, true);  // entry_addr
  view.setUint16(12, 5, true);          // chip_id = 5 (ESP32-C3)

  // Segment header: load_addr + data_len
  view.setUint32(headerSize, 0x3FC80000, true);    // load to DRAM
  view.setUint32(headerSize + 4, segData.length, true);
  bin.set(segData, headerSize + segHeaderSize);

  const fw = parseBin(bin);
  assert(fw.entryAddr === 0x42000000, 'Entry addr should be 0x42000000');
  assert(fw.chipId === 5, 'Chip ID should be 5 (ESP32-C3)');
  assert(fw.segments.length === 1, 'Should have 1 segment');
  assert(fw.segments[0].loadAddr === 0x3FC80000, 'Segment load addr should be DRAM base');
  assert(fw.segments[0].data.length === 16, 'Segment data should be 16 bytes');
  assert(fw.segments[0].data[0] === 0x42, 'Segment data should be 0x42');
  console.log('PASS: Synthetic bin parsed correctly\n');
}

// ── Test 3: Bin Parser (base64 path) ──
console.log('=== Test 3: Bin Parser (base64) ===');
{
  const segData = new Uint8Array(8).fill(0xAB);
  const bin = new Uint8Array(24 + 8 + 8);
  const view = new DataView(bin.buffer);
  bin[0] = 0xE9; bin[1] = 1;
  view.setUint32(4, 0x42001000, true);
  view.setUint16(12, 5, true);
  view.setUint32(24, 0x42001000, true);
  view.setUint32(28, 8, true);
  bin.set(segData, 32);

  const b64 = btoa(String.fromCharCode(...bin));
  const fw = binToFirmware(b64);
  assert(fw.entryAddr === 0x42001000, 'Base64: entry addr correct');
  assert(fw.segments.length === 1, 'Base64: 1 segment');
  assert(fw.segments[0].data[0] === 0xAB, 'Base64: data correct');
  console.log('PASS: Base64 bin decode works\n');
}

// ── Test 4: RV32I Base Instructions ──
console.log('=== Test 4: RV32I Base Instructions ===');
{
  // Mini-assembler to avoid hand-encoding errors
  function R(funct7, rs2, rs1, funct3, rd, op) {
    return ((funct7 & 0x7F) << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) |
           ((funct3 & 7) << 12) | ((rd & 0x1F) << 7) | (op & 0x7F);
  }
  function I(imm, rs1, funct3, rd, op) {
    return ((imm & 0xFFF) << 20) | ((rs1 & 0x1F) << 15) |
           ((funct3 & 7) << 12) | ((rd & 0x1F) << 7) | (op & 0x7F);
  }
  function S(imm, rs2, rs1, funct3, op) {
    return (((imm >> 5) & 0x7F) << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) |
           ((funct3 & 7) << 12) | ((imm & 0x1F) << 7) | (op & 0x7F);
  }
  function U(imm20, rd, op) {
    return ((imm20 & 0xFFFFF) << 12) | ((rd & 0x1F) << 7) | (op & 0x7F);
  }

  const cpu = new RV32IMC_CPU();
  const mem = new Uint8Array(4096);
  const memView = new DataView(mem.buffer);

  cpu.read32 = (addr) => memView.getInt32(addr & 0xFFF, true);
  cpu.write32 = (addr, val) => memView.setInt32(addr & 0xFFF, val, true);
  cpu.read16 = (addr) => memView.getUint16(addr & 0xFFF, true);
  cpu.write16 = (addr, val) => memView.setUint16(addr & 0xFFF, val, true);
  cpu.read8 = (addr) => mem[addr & 0xFFF];
  cpu.write8 = (addr, val) => { mem[addr & 0xFFF] = val; };

  let off = 0;
  function emit(insn) { memView.setUint32(off, insn, true); off += 4; }

  // ADDI x1, x0, 42
  emit(I(42, 0, 0, 1, 0x13));
  cpu.pc = 0;
  cpu.executeInstruction();
  assert(cpu.x[1] === 42, 'ADDI x1, x0, 42 → x1=42 (got ' + cpu.x[1] + ')');
  assert(cpu.pc === 4, 'PC should advance to 4');

  // ADD x2, x1, x1
  emit(R(0, 1, 1, 0, 2, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[2] === 84, 'ADD x2, x1, x1 → x2=84 (got ' + cpu.x[2] + ')');

  // SUB x3, x2, x1
  emit(R(0x20, 1, 2, 0, 3, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[3] === 42, 'SUB x3, x2, x1 → x3=42 (got ' + cpu.x[3] + ')');

  // LUI x4, 0x12345
  emit(U(0x12345, 4, 0x37));
  cpu.executeInstruction();
  assert(cpu.x[4] === 0x12345000, 'LUI x4, 0x12345 → 0x12345000 (got 0x' + (cpu.x[4] >>> 0).toString(16) + ')');

  // SLTI x5, x1, 100
  emit(I(100, 1, 2, 5, 0x13));
  cpu.executeInstruction();
  assert(cpu.x[5] === 1, 'SLTI x5, x1, 100 → 1 (got ' + cpu.x[5] + ')');

  // XORI x6, x1, 0xFF
  emit(I(0xFF, 1, 4, 6, 0x13));
  cpu.executeInstruction();
  assert(cpu.x[6] === (42 ^ 0xFF), 'XORI x6, x1, 0xFF → ' + (42 ^ 0xFF) + ' (got ' + cpu.x[6] + ')');

  // ORI x7, x0, 0x55
  emit(I(0x55, 0, 6, 7, 0x13));
  cpu.executeInstruction();
  assert(cpu.x[7] === 0x55, 'ORI x7, x0, 0x55 → 0x55 (got ' + cpu.x[7] + ')');

  // ANDI x8, x7, 0x0F
  emit(I(0x0F, 7, 7, 8, 0x13));
  cpu.executeInstruction();
  assert(cpu.x[8] === 0x05, 'ANDI x8, x7, 0x0F → 0x05 (got ' + cpu.x[8] + ')');

  // SW x1, 2048(x0) — store to address 2048 (away from code)
  emit(S(2048, 1, 0, 2, 0x23));
  cpu.executeInstruction();
  // LW x9, 2048(x0)
  emit(I(2048, 0, 2, 9, 0x03));
  cpu.executeInstruction();
  assert(cpu.x[9] === 42, 'SW/LW round-trip → 42 (got ' + cpu.x[9] + ')');

  // SLL x10, x1, x8 (42 << 5 = 1344)
  emit(R(0, 8, 1, 1, 10, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[10] === (42 << 5), 'SLL x10, x1, x8 → ' + (42 << 5) + ' (got ' + cpu.x[10] + ')');

  // SRL x11, x10, x8 (1344 >>> 5 = 42)
  emit(R(0, 8, 10, 5, 11, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[11] === 42, 'SRL x10>>5 → 42 (got ' + cpu.x[11] + ')');

  // ADDI x12, x0, -1 (0xFFF sign-extended = -1)
  emit(I(0xFFF, 0, 0, 12, 0x13));
  cpu.executeInstruction();
  assert(cpu.x[12] === -1, 'ADDI x12, x0, -1 → -1 (got ' + cpu.x[12] + ')');

  console.log('PASS: RV32I base instructions\n');
}

// ── Test 5: M Extension ──
console.log('=== Test 5: M Extension (mul/div) ===');
{
  function R(funct7, rs2, rs1, funct3, rd, op) {
    return ((funct7 & 0x7F) << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) |
           ((funct3 & 7) << 12) | ((rd & 0x1F) << 7) | (op & 0x7F);
  }

  const cpu = new RV32IMC_CPU();
  const mem = new Uint8Array(4096);
  const memView = new DataView(mem.buffer);

  cpu.read32 = (addr) => memView.getInt32(addr & 0xFFF, true);
  cpu.write32 = (addr, val) => memView.setInt32(addr & 0xFFF, val, true);
  cpu.read16 = (addr) => memView.getUint16(addr & 0xFFF, true);
  cpu.write16 = (addr, val) => memView.setUint16(addr & 0xFFF, val, true);
  cpu.read8 = (addr) => mem[addr & 0xFFF];
  cpu.write8 = (addr, val) => { mem[addr & 0xFFF] = val; };

  cpu.x[1] = 7;
  cpu.x[2] = 6;
  let off = 0;
  function emit(insn) { memView.setUint32(off, insn, true); off += 4; }

  // MUL x3, x1, x2 (funct7=1, funct3=0)
  emit(R(1, 2, 1, 0, 3, 0x33));
  cpu.pc = 0;
  cpu.executeInstruction();
  assert(cpu.x[3] === 42, 'MUL 7*6 → 42 (got ' + cpu.x[3] + ')');

  // DIV x4, x3, x1 (funct7=1, funct3=4)
  emit(R(1, 1, 3, 4, 4, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[4] === 6, 'DIV 42/7 → 6 (got ' + cpu.x[4] + ')');

  // REM x5, x3, x1 (funct7=1, funct3=6)
  emit(R(1, 1, 3, 6, 5, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[5] === 0, 'REM 42%7 → 0 (got ' + cpu.x[5] + ')');

  // DIV by zero → -1
  cpu.x[6] = 0;
  emit(R(1, 6, 1, 4, 7, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[7] === -1, 'DIV by zero → -1 (got ' + cpu.x[7] + ')');

  // MULH x8, x1, x2 (funct3=1, signed high)
  emit(R(1, 2, 1, 1, 8, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[8] === 0, 'MULH 7*6 high → 0 (got ' + cpu.x[8] + ')');

  // DIVU x9, x3, x1 (funct3=5, unsigned)
  emit(R(1, 1, 3, 5, 9, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[9] === 6, 'DIVU 42/7 → 6 (got ' + cpu.x[9] + ')');

  // REMU x10, x3, x2 (funct3=7, unsigned)
  emit(R(1, 2, 3, 7, 10, 0x33));
  cpu.executeInstruction();
  assert(cpu.x[10] === 0, 'REMU 42%6 → 0 (got ' + cpu.x[10] + ')');

  console.log('PASS: M extension\n');
}

// ── Test 6: C Extension ──
console.log('=== Test 6: C Extension (compressed) ===');
{
  const cpu = new RV32IMC_CPU();
  const mem = new Uint8Array(4096);
  const memView = new DataView(mem.buffer);

  cpu.read32 = (addr) => memView.getInt32(addr & 0xFFF, true);
  cpu.write32 = (addr, val) => memView.setInt32(addr & 0xFFF, val, true);
  cpu.read16 = (addr) => memView.getUint16(addr & 0xFFF, true);
  cpu.write16 = (addr, val) => memView.setUint16(addr & 0xFFF, val, true);
  cpu.read8 = (addr) => mem[addr & 0xFFF];
  cpu.write8 = (addr, val) => { mem[addr & 0xFFF] = val; };

  let off = 0;
  function emit16(insn) { memView.setUint16(off, insn, true); off += 2; }

  // C.LI rd, imm: 010 imm[5] rd[4:0] imm[4:0] 01
  // C.LI x10, 5: 010 0 01010 00101 01 = 0b010_0_01010_00101_01 = 0x4515
  emit16(0x4515);
  cpu.pc = 0;
  cpu.executeInstruction();
  assert(cpu.x[10] === 5, 'C.LI x10, 5 → 5 (got ' + cpu.x[10] + ')');
  assert(cpu.pc === 2, 'PC should advance by 2');

  // C.MV rd, rs2: 100 0 rd[4:0] rs2[4:0] 10  (bit12=0)
  // C.MV x11, x10: 100 0 01011 01010 10 = 0b100_0_01011_01010_10 = 0x85AA
  emit16(0x85AA);
  cpu.executeInstruction();
  assert(cpu.x[11] === 5, 'C.MV x11, x10 → 5 (got ' + cpu.x[11] + ')');

  // C.ADDI rd, imm: 000 imm[5] rd[4:0] imm[4:0] 01
  // C.ADDI x10, 3: 000 0 01010 00011 01 = 0b000_0_01010_00011_01 = 0x050D
  emit16(0x050D);
  cpu.executeInstruction();
  assert(cpu.x[10] === 8, 'C.ADDI x10, 3 → 8 (got ' + cpu.x[10] + ')');

  // C.SLLI rd, shamt: 000 shamt[5] rd[4:0] shamt[4:0] 10
  // C.SLLI x10, 2: 000 0 01010 00010 10 = 0b000_0_01010_00010_10 = 0x050A
  emit16(0x050A);
  cpu.executeInstruction();
  assert(cpu.x[10] === 32, 'C.SLLI x10, 2 → 32 (got ' + cpu.x[10] + ')');

  // C.ADD rd, rs2: 100 1 rd[4:0] rs2[4:0] 10  (bit12=1)
  // C.ADD x10, x11: 100 1 01010 01011 10 = 0b100_1_01010_01011_10 = 0x952E
  emit16(0x952E);
  cpu.executeInstruction();
  assert(cpu.x[10] === 37, 'C.ADD x10, x11 → 37 (got ' + cpu.x[10] + ')');

  // C.NOP: 000 0 00000 00000 01 = 0x0001
  const pcBefore = cpu.pc;
  emit16(0x0001);
  cpu.executeInstruction();
  assert(cpu.pc === pcBefore + 2, 'C.NOP should advance PC by 2');

  console.log('PASS: C extension\n');
}

// ── Test 7: ESP32C3Runner Memory Map ──
console.log('=== Test 7: Runner Memory Map ===');
{
  // Create minimal firmware with 1 segment in DRAM
  const firmware = {
    entryAddr: 0x42000000,
    segments: [{
      loadAddr: 0x3FC80000,
      data: new Uint8Array([0xDE, 0xAD, 0xBE, 0xEF]),
    }],
    chipId: 5,
  };

  const runner = new ESP32C3Runner(firmware);

  // Check DRAM loaded
  const val = runner._read32(0x3FC80000);
  assert((val & 0xFFFFFFFF) === (0xEFBEADDE | 0), 'DRAM should contain loaded data (got 0x' + (val >>> 0).toString(16) + ')');

  // Write/read DRAM
  runner._write32(0x3FC80100, 0x12345678);
  assert(runner._read32(0x3FC80100) === 0x12345678, 'DRAM write/read round-trip');

  // Write/read IRAM
  runner._write32(0x4037C000, 0xAABBCCDD);
  assert(runner._read32(0x4037C000) === (0xAABBCCDD | 0), 'IRAM write/read');

  // Unmapped reads should return 0
  assert(runner._read32(0x50000000) === 0, 'Unmapped read should return 0');

  // RTC slow-clock source register must default to RC_SLOW (0).
  // Returning bit 30 here makes ESP-IDF interpret RTC_MUX as 32K_XTAL and
  // breaks early boot calibration.
  assert(runner._read32(0x60008070) === 0, 'RTC slow clock source register should default to RC_SLOW');

  console.log('PASS: Memory map\n');
}

// ── Test 8: GPIO Peripheral ──
console.log('=== Test 8: GPIO Peripheral ===');
{
  const firmware = {
    entryAddr: 0x42000000,
    segments: [],
    chipId: 5,
  };
  const runner = new ESP32C3Runner(firmware);

  let lastPin = -1, lastHigh = false;
  runner.addPinChangeListener((pin, high) => {
    lastPin = pin;
    lastHigh = high;
  });

  // Set GPIO output enable for pin 8
  runner._write32(0x60004024, 1 << 8); // GPIO_ENABLE_W1TS

  // Set GPIO8 high via W1TS
  runner._write32(0x60004008, 1 << 8); // GPIO_OUT_W1TS
  runner._processGPIOChanges();
  assert(lastPin === 8, 'GPIO change should fire for pin 8 (got ' + lastPin + ')');
  assert(lastHigh === true, 'Pin 8 should be HIGH');

  // Set GPIO8 low via W1TC
  runner._write32(0x6000400C, 1 << 8); // GPIO_OUT_W1TC
  runner._processGPIOChanges();
  assert(lastHigh === false, 'Pin 8 should be LOW');

  // Read GPIO input
  runner.setPinState(5, true);
  const inVal = runner._read32(0x6000403C); // GPIO_IN_REG
  assert((inVal & (1 << 5)) !== 0, 'GPIO_IN should have pin 5 set');

  console.log('PASS: GPIO peripheral\n');
}

// ── Test 9: UART TX ──
console.log('=== Test 9: UART TX ===');
{
  const firmware = {
    entryAddr: 0x42000000,
    segments: [],
    chipId: 5,
  };
  const runner = new ESP32C3Runner(firmware);

  let serialOut = '';
  runner.onSerial = (ch) => { serialOut += ch; };

  // Write characters to UART FIFO
  runner._write32(0x60000000, 0x48); // 'H'
  runner._write32(0x60000000, 0x69); // 'i'
  runner._flushUART();

  assert(serialOut === 'Hi', 'UART should output "Hi" (got "' + serialOut + '")');
  console.log('PASS: UART TX\n');
}

// ── Test 10: SYSTIMER ──
console.log('=== Test 10: SYSTIMER ===');
{
  const firmware = {
    entryAddr: 0x42000000,
    segments: [],
    chipId: 5,
  };
  const runner = new ESP32C3Runner(firmware);

  // Advance CPU cycle counter to simulate execution
  runner.cpu._cycleCount = 1600;

  // Read UNIT0_VAL_LO (counter = cycles / 10)
  const lo = runner._read32(0x60023054); // SYSTIMER_UNIT0_VAL_LO
  assert(lo === 160, 'SYSTIMER should read 160 at 1600 cycles (got ' + lo + ')');

  // Verify UNIT0_OP returns VALID bit
  const op = runner._read32(0x60023014);
  assert(op & (1 << 29), 'UNIT0_OP should have VALID bit set');

  console.log('PASS: SYSTIMER\n');
}

// ── Test 11: Full Compile + Boot ──
console.log('=== Test 11: Full Compile + Boot ===');
let hasArduinoCli = false;
try {
  execSync('arduino-cli version', { stdio: 'pipe' });
  hasArduinoCli = true;
} catch { }

if (hasArduinoCli) {
  const dir = mkdtempSync(join(tmpdir(), 'esp32c3-'));
  const sketchDir = join(dir, 'sketch');
  mkdirSync(sketchDir);
  writeFileSync(join(sketchDir, 'sketch.ino'), `
void setup() {
  pinMode(8, OUTPUT);
}
void loop() {
  digitalWrite(8, HIGH);
  delay(500);
  digitalWrite(8, LOW);
  delay(500);
}
`);
  const outDir = join(dir, 'out');
  mkdirSync(outDir);

  try {
    const result = spawnSync('arduino-cli', [
      'compile', '--fqbn', 'esp32:esp32:esp32c3', '--output-dir', outDir, sketchDir
    ], { timeout: 120000, stdio: 'pipe' });

    if (result.status === 0) {
      passed++;
      const binPath = join(outDir, 'sketch.ino.bin');
      assert(existsSync(binPath), 'sketch.ino.bin should exist');

      const binData = readFileSync(binPath);
      console.log('  Bin file size:', binData.length, 'bytes');

      const fw = parseBin(new Uint8Array(binData));
      console.log('  Entry addr: 0x' + fw.entryAddr.toString(16));
      console.log('  Chip ID:', fw.chipId);
      console.log('  Segments:', fw.segments.length);
      for (const seg of fw.segments) {
        console.log('    0x' + seg.loadAddr.toString(16) + ' (' + seg.data.length + ' bytes)');
      }

      assert(fw.segments.length > 0, 'Should have at least 1 segment');
      assert(fw.chipId === 5, 'Chip ID should be 5 (ESP32-C3)');

      // Try booting
      const runner = new ESP32C3Runner(fw);
      let serialOut = '';
      runner.onSerial = (ch) => { serialOut += ch; };

      let ledChanges = 0;
      runner.addPinChangeListener((pin, high) => {
        if (pin === 8) ledChanges++;
      });

      // Execute instructions with periodic SYSTIMER tick (matching runner loop)
      let cycles = 0;
      const maxCycles = 10_000_000;
      const TICK = 160_000;
      const startTime = Date.now();
      while (cycles < maxCycles) {
        const chunk = Math.min(TICK, maxCycles - cycles);
        for (let i = 0; i < chunk; i++) {
          runner.cpu.executeInstruction();
        }
        cycles += chunk;
        // Fire 1ms FreeRTOS tick
        runner._stIntRaw |= 1;
        if (runner._stIntEna & 1) runner._raiseIntSource(37); // SYSTIMER_TARGET0
        runner._processGPIOChanges();
        runner._flushUART();
      }
      const elapsed = ((Date.now() - startTime)).toFixed(0);

      console.log('  Cycles executed:', cycles);
      console.log('  LED changes:', ledChanges);
      console.log('  Serial output:', serialOut.length > 0 ? JSON.stringify(serialOut.slice(0, 100)) : '(none)');
      console.log('  Final PC: 0x' + runner.cpu.pc.toString(16));
      console.log('  Wall time:', elapsed + 'ms');

      if (cycles > 100) {
        passed++;
        console.log('  PASS: ESP32-C3 firmware boots and executes');
      } else {
        failed++;
        console.error('  FAIL: Firmware did not execute enough instructions');
      }
    } else {
      failed++;
      console.error('  COMPILE FAIL:', result.stderr?.toString().slice(0, 200));
    }
  } catch (e) {
    failed++;
    console.error('  ERROR:', e.message);
  }
} else {
  console.log('  SKIPPED: arduino-cli not available');
}

console.log('\n=== Results ===');
console.log('Passed:', passed);
console.log('Failed:', failed);
console.log(failed === 0 ? '\nALL TESTS PASSED' : '\nSOME TESTS FAILED');
process.exit(failed > 0 ? 1 : 0);
