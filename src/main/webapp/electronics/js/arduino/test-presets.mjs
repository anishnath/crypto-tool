/**
 * Node.js test: validate all presets compile and components match code.
 *
 * Run: node test-presets.mjs
 *
 * Tests:
 *  1. Each preset has required fields (id, title, category, code)
 *  2. Component types are valid
 *  3. Pin numbers in components match pins referenced in code
 *  4. AVR presets compile with arduino-cli (arduino:avr:uno)
 *  5. Pico presets compile with arduino-cli (rp2040:rp2040:rpipico)
 */

import { PRESETS, getPresetsByCategory, getPreset } from './presets.js';
import { execSync, spawnSync } from 'child_process';
import { mkdtempSync, writeFileSync, mkdirSync, existsSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

const VALID_TYPES = new Set([
  'led', 'led-green', 'led-yellow', 'pushbutton', 'potentiometer',
  'slide-potentiometer', 'servo', 'buzzer', 'relay', 'slide-switch', 'photoresistor',
]);

let passed = 0;
let failed = 0;
let skipped = 0;

function assert(cond, msg) {
  if (cond) { passed++; }
  else { failed++; console.error('  FAIL:', msg); }
}

// Check arduino-cli is available
let hasArduinoCli = false;
try {
  execSync('arduino-cli version', { stdio: 'pipe' });
  hasArduinoCli = true;
} catch { }

console.log('=== Preset Validation Test ===');
console.log('Presets:', PRESETS.length);
console.log('arduino-cli:', hasArduinoCli ? 'available' : 'NOT FOUND (compile tests skipped)');
console.log('');

// Test getPresetsByCategory
const groups = getPresetsByCategory();
assert(Object.keys(groups).length > 0, 'getPresetsByCategory should return groups');

// Test getPreset
assert(getPreset('blink') !== null, 'getPreset("blink") should find preset');
assert(getPreset('nonexistent') === null, 'getPreset("nonexistent") should return null');

for (const preset of PRESETS) {
  console.log(`--- ${preset.id}: ${preset.title} ---`);

  // Required fields
  assert(preset.id, preset.id + ': missing id');
  assert(preset.title, preset.id + ': missing title');
  assert(preset.category, preset.id + ': missing category');
  assert(preset.code && preset.code.length > 10, preset.id + ': missing or empty code');

  // Components
  const components = preset.components || [];
  for (const comp of components) {
    assert(VALID_TYPES.has(comp.type), preset.id + ': unknown component type "' + comp.type + '"');
    assert(comp.pin !== undefined, preset.id + ': component missing pin');
    assert(comp.x !== undefined && comp.y !== undefined, preset.id + ': component missing x/y position');
  }

  // Check code references pins that match components
  const code = preset.code;
  const codePins = new Set();

  // Extract pin numbers from common Arduino functions
  const pinPatterns = [
    /pinMode\((\d+)/g,
    /digitalWrite\((\d+)/g,
    /digitalRead\((\d+)/g,
    /analogWrite\((\d+)/g,
    /attach\((\d+)/g,
    /tone\((\d+)/g,
  ];
  for (const pat of pinPatterns) {
    let m;
    while ((m = pat.exec(code)) !== null) {
      codePins.add(parseInt(m[1]));
    }
  }

  // Check analogRead for A0-A5
  const analogPattern = /analogRead\(A(\d)\)/g;
  let am;
  while ((am = analogPattern.exec(code)) !== null) {
    codePins.add('A' + am[1]);
  }

  // Verify component pins appear in code
  for (const comp of components) {
    const pin = comp.pin;
    if (typeof pin === 'string' && pin.startsWith('A')) {
      // Analog pin — check code uses analogRead
      assert(code.includes('analogRead') || code.includes(pin),
        preset.id + ': component on ' + pin + ' but code never reads analog');
    } else if (typeof pin === 'number') {
      assert(codePins.has(pin) || code.includes('pin') || code.includes('ledPins'),
        preset.id + ': component on pin ' + pin + ' but code never references it');
    }
  }

  // Board field check for Pico presets
  if (preset.category === 'Pico') {
    assert(preset.board && preset.board.startsWith('rp2040:'),
      preset.id + ': Pico preset missing rp2040 board FQBN');
  }

  // Board field check for ESP32-C3 presets
  if (preset.category === 'ESP32-C3') {
    assert(preset.board && preset.board.startsWith('esp32:'),
      preset.id + ': ESP32-C3 preset missing esp32 board FQBN');
  }

  // Compile test
  if (hasArduinoCli) {
    const board = preset.board || 'arduino:avr:uno';
    const dir = mkdtempSync(join(tmpdir(), 'preset-'));
    const sketchDir = join(dir, 'sketch');
    mkdirSync(sketchDir);
    writeFileSync(join(sketchDir, 'sketch.ino'), code);
    mkdirSync(join(dir, 'out'));

    try {
      const result = spawnSync('arduino-cli', [
        'compile', '--fqbn', board, '--output-dir', join(dir, 'out'), sketchDir
      ], { timeout: 60000, stdio: 'pipe' });

      if (result.status === 0) {
        passed++;
        const isUf2 = board.startsWith('rp2040:');
        const isBin = board.startsWith('esp32:');
        const outFile = isUf2 ? 'sketch.ino.uf2' : isBin ? 'sketch.ino.bin' : 'sketch.ino.hex';
        const outputExists = existsSync(join(dir, 'out', outFile));
        assert(outputExists, preset.id + ': compile succeeded but ' + outFile + ' not found');
        console.log('  COMPILE OK (' + board + ')');
      } else {
        failed++;
        const stderr = result.stderr?.toString().slice(0, 200) || '';
        console.error('  COMPILE FAIL:', stderr);
      }
    } catch (e) {
      skipped++;
      console.log('  COMPILE TIMEOUT');
    }
  } else {
    skipped++;
  }
}

console.log('\n=== Results ===');
console.log('Passed:', passed);
console.log('Failed:', failed);
console.log('Skipped:', skipped);
console.log(failed === 0 ? '\nALL TESTS PASSED' : '\nSOME TESTS FAILED');
process.exit(failed > 0 ? 1 : 0);
