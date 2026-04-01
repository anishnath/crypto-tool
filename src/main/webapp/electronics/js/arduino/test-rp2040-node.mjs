/**
 * Node.js test for RP2040 boot sequence using locally installed rp2040js.
 *
 * Run: node test-rp2040-node.mjs
 */

import { RP2040, GPIOPinState, ConsoleLogger, LogLevel } from 'rp2040js';
import { bootromB1 } from './rp2040-bootrom.js';
import { uf2BytesToFlash } from './uf2-parser.js';
import { readFileSync } from 'fs';
import { execSync } from 'child_process';
import { mkdtempSync, writeFileSync, mkdirSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

console.log('=== RP2040 Boot Sequence Test ===\n');

// Step 1: Compile a real Pico sketch
console.log('Step 1: Compiling Pico Blink sketch...');
const tmpDir = mkdtempSync(join(tmpdir(), 'pico-'));
const sketchDir = join(tmpDir, 'sketch');
mkdirSync(sketchDir);
writeFileSync(join(sketchDir, 'sketch.ino'), `
void setup() {
  Serial.begin(115200);
  pinMode(25, OUTPUT);
}
void loop() {
  Serial.println("HELLO");
  digitalWrite(25, HIGH);
  delay(500);
  Serial.println("BYE");
  digitalWrite(25, LOW);
  delay(500);
}
`);

const outDir = join(tmpDir, 'out');
mkdirSync(outDir);
try {
  execSync(`arduino-cli compile --fqbn rp2040:rp2040:rpipico --output-dir "${outDir}" "${sketchDir}"`, { stdio: 'pipe' });
} catch (e) {
  console.error('Compile failed:', e.stderr?.toString());
  process.exit(1);
}

// Find the UF2 file
const uf2Path = join(outDir, 'sketch.ino.uf2');
const uf2Bytes = readFileSync(uf2Path);
console.log('UF2 file size:', uf2Bytes.length, 'bytes');

// Step 2: Parse UF2 to flash image
console.log('\nStep 2: Parsing UF2...');
const flash = uf2BytesToFlash(new Uint8Array(uf2Bytes));
console.log('Flash image size:', flash.length, 'bytes');
console.log('Flash[0:8]:', Array.from(flash.slice(0, 8)).map(b => '0x' + b.toString(16).padStart(2, '0')).join(' '));

// Step 3: Create RP2040 and boot
console.log('\nStep 3: Booting RP2040...');
const mcu = new RP2040();
mcu.logger = new ConsoleLogger(LogLevel.Error);

// Load bootrom (for lookup tables), then flash, then skip bootrom boot
mcu.loadBootrom(bootromB1);
mcu.flash.set(flash, 0);
mcu.core.PC = 0x10000000; // skip bootrom CRC check, jump to flash

console.log('After setup: PC=0x' + mcu.core.PC.toString(16) + ' SP=0x' + mcu.core.SP.toString(16));

// Step 4: Wire UART0
let serialOut = '';
mcu.uart[0].onByte = (value) => {
  const ch = String.fromCharCode(value);
  serialOut += ch;
  if (ch === '\n') {
    console.log('[UART0]', serialOut.trimEnd());
    serialOut = '';
  }
};

// Step 5: Wire GPIO25
let ledState = false;
let ledChanges = 0;
if (mcu.gpio[25]) {
  mcu.gpio[25].addListener((state) => {
    const high = (state === GPIOPinState.High);
    if (high !== ledState) {
      ledState = high;
      ledChanges++;
      if (ledChanges <= 10) {
        console.log('[GPIO25] LED', high ? 'ON' : 'OFF');
      }
    }
  });
}

// Step 6: Patch PIO (same as our runner)
for (const pio of mcu.pio) {
  pio.run = function() {
    if (this.runTimer) { clearTimeout(this.runTimer); this.runTimer = null; }
  };
}

// Step 7: Run simulation for a few seconds of simulated time
console.log('\nStep 4: Running simulation...');
const CYCLE_NANOS = 8; // 125MHz
const targetCycles = 125_000_000 * 3; // 3 seconds of simulated time
let totalCycles = 0;
let instructions = 0;
let wfiCount = 0;
const startTime = Date.now();

while (totalCycles < targetCycles) {
  if (mcu.core.waiting) {
    const jump = mcu.clock.nanosToNextAlarm;
    if (jump <= 0) {
      mcu.clock.tick(CYCLE_NANOS);
      totalCycles++;
      // Step PIO
      for (const pio of mcu.pio) {
        if (!pio.stopped) pio.step();
      }
      wfiCount++;
      if (wfiCount > 1000000) {
        console.log('WFI stuck after', totalCycles, 'cycles. PC=0x' + mcu.core.PC.toString(16));
        break;
      }
      continue;
    }
    const jumped = Math.ceil(jump / CYCLE_NANOS);
    mcu.clock.tick(jump);
    totalCycles += jumped;
    for (const pio of mcu.pio) {
      if (!pio.stopped) pio.step();
    }
    wfiCount = 0;
  } else {
    const cycles = mcu.core.executeInstruction();
    mcu.clock.tick(cycles * CYCLE_NANOS);
    totalCycles += cycles;
    instructions++;
    wfiCount = 0;

    // Log PC progression in early boot
    if (instructions <= 5) {
      console.log('  instr', instructions, ': PC=0x' + mcu.core.PC.toString(16));
    }
    if (instructions === 100) {
      console.log('  instr 100: PC=0x' + mcu.core.PC.toString(16));
    }
    if (instructions === 10000) {
      console.log('  instr 10000: PC=0x' + mcu.core.PC.toString(16));
    }
  }
}

const elapsed = ((Date.now() - startTime) / 1000).toFixed(1);
console.log('\nResults:');
console.log('  Total cycles:', totalCycles);
console.log('  Instructions executed:', instructions);
console.log('  LED state changes:', ledChanges);
console.log('  Final PC: 0x' + mcu.core.PC.toString(16));
console.log('  Wall time:', elapsed + 's');
console.log('  Final LED:', ledState ? 'ON' : 'OFF');

if (ledChanges > 0) {
  console.log('\n=== PASS: RP2040 boots and toggles LED ===');
} else if (instructions > 0) {
  console.log('\n=== PARTIAL: CPU executes but no GPIO output ===');
} else {
  console.log('\n=== FAIL: CPU did not execute any instructions ===');
}
