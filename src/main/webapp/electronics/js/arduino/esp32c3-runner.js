/**
 * ESP32C3Runner — wires RV32IMC CPU + ESP32-C3 peripherals.
 *
 * Same public API as AVRRunner / RP2040Runner so bindings work unchanged.
 *
 * Peripheral emulation approach (matching Velxio):
 *   - Echo-back: all unhandled register writes are stored and echoed on read
 *   - Specific handlers for: UART0, GPIO, SYSTIMER, Interrupt Matrix, EXTMEM
 *   - Stub "done" bits for: flash cache, WDT calibration, RTC clock, SPI flash
 *   - ROM function hooks for: memcpy, memset, libgcc math, ESP-IDF helpers
 *   - SYSTIMER fires every 160K cycles (1ms) for FreeRTOS tick
 */

import { RV32IMC_CPU } from './esp32c3-cpu.js';
import { GPIO_COUNT, LED_BUILTIN } from './esp32c3-pin-map.js';

const F_CPU = 160_000_000;
const FPS = 60;
const CYCLES_PER_FRAME = Math.floor(F_CPU / FPS);   // ~2,666,667
const CYCLES_PER_TICK  = 160_000;                    // 1ms FreeRTOS tick
const RTC_CALI_VALUE = 140_000;
const RTC_SLOW_CLK_HZ = 136_000;
const RTC_SLOW_CLK_CAL = Math.floor((1_000_000 * (1 << 19)) / RTC_SLOW_CLK_HZ);
const RTC_TIMER1_RESET =
  (20 << 24) | // PLL_BUF_WAIT default
  (100 << 14) | // XTL_BUF_WAIT default
  (0x10 << 6) | // CK8M_WAIT default
  (1 << 1) | // CPU_STALL_WAIT default
  1; // CPU_STALL_EN default
const RTC_TIMER3_RESET =
  (5 << 25) | // BT_POWERUP_TIMER default
  (8 << 16) | // BT_WAIT_TIMER default
  (5 << 9) | // WIFI_POWERUP_TIMER default
  8; // WIFI_WAIT_TIMER default
const RTC_TIMER5_RESET = (0x80 << 8); // MIN_SLP_VAL default
const RTC_TIMER6_RESET =
  (5 << 25) | // DG_PERI_POWERUP_TIMER default
  (8 << 16); // DG_PERI_WAIT_TIMER default
const RTC_ANA_CONF_RESET =
  (1 << 23) | // PLLA_FORCE_PD default
  (1 << 22); // SAR_I2C_PU default

// ── Memory Map ──
// ESP32-C3 SRAM1 (384 KB) is dual-mapped:
//   DRAM bus: 0x3FC80000 – 0x3FCE0000
//   IRAM bus: 0x40380000 – 0x403E0000  (same physical memory)
// SRAM0 (16 KB): 0x4037C000 – 0x40380000 (IRAM only, separate)
const DRAM_BASE       = 0x3FC80000;
const DRAM_SIZE       = 0x00060000; // 384 KB (SRAM1)
const IRAM0_BASE      = 0x4037C000; // SRAM0 (IRAM only, 16 KB)
const IRAM0_SIZE      = 0x00004000;
const IRAM1_BASE      = 0x40380000; // SRAM1 IRAM alias (maps to DRAM)
const IRAM1_SIZE      = 0x00060000; // 384 KB
const FLASH_DBUS_BASE = 0x3C000000; // DROM — read-only flash data alias
const FLASH_IBUS_BASE = 0x42000000; // IROM — flash instruction
const FLASH_SIZE      = 0x00400000; // 4 MB
const ROM_BASE        = 0x40000000;
const ROM_SIZE        = 0x00060000;

// ── Peripheral Bases ──
const UART0_BASE    = 0x60000000;
const SPI1_BASE     = 0x60002000;
const SPI0_BASE     = 0x60003000;
const GPIO_BASE     = 0x60004000;
const RTC_CNTL_BASE = 0x60008000;
const IO_MUX_BASE   = 0x60009000;
const LEDC_BASE     = 0x60019000;
const TIMG0_BASE    = 0x6001F000;
const TIMG1_BASE    = 0x60020000;
const SYSTIMER_BASE = 0x60023000;
const APB_CTRL0     = 0x60026000; // TIMG aliases used by ESP-IDF
const APB_CTRL1     = 0x60027000;
const SYSTEM_BASE   = 0x600C0000;
const INTMTX_BASE   = 0x600C2000;
const EXTMEM_BASE   = 0x600C4000;
const PERIPH_END    = 0x70000000;

// Interrupt sources
const ETS_FROM_CPU_INTR0_SRC  = 28;
const ETS_SYSTIMER_TARGET0_SRC = 37;

// Flash functions we emulate directly to smooth early ESP-IDF boot on the browser runner.
// These addresses are from the arduino-esp32 v3.3.7 ESP32-C3 core used by this project.
const SOC_GET_AVAILABLE_MEMORY_REGION_MAX_COUNT = new Set([0x420080E0, 0x42008ACC]);
const SOC_GET_AVAILABLE_MEMORY_REGIONS = new Set([0x42008102, 0x42008AEE]);
const ESP_MPROT_SET_PROT = new Set([0x42009D96, 0x4200A782]);

// ── ROM function addresses (ESP32-C3 ROM) ──
const ROM_FUNCS = {
  // C library
  0x40000354: 'memset',
  0x40000358: 'memcpy',
  0x4000035c: 'memmove',
  0x40000360: 'memcmp',
  0x40000364: 'strcpy',
  0x4000036c: 'strcmp',
  0x40000374: 'strlen',
  0x4000037c: 'bzero',
  // ESP-IDF helpers
  0x40000018: 'rtc_get_reset_reason',
  0x40000050: 'ets_delay_us',
  0x40000084: 'uart_tx_wait_idle',
  0x40000548: 'Cache_Set_IDROM_MMU_Size',
  0x40000588: 'ets_update_cpu_frequency',
  0x400005f4: 'intr_matrix_set',
  0x4000195c: 'rom_i2c_writeReg',
  0x40001960: 'rom_i2c_writeReg_Mask',
  // libgcc math
  0x400008ac: '__udivdi3',
  0x400008b0: '__udivmoddi4',
  0x400008b4: '__udivsi3',
  0x400008bc: '__umoddi3',
  0x400008c0: '__umodsi3',
  0x400007b4: '__divdi3',
  0x400007c0: '__divsi3',
  0x4000083c: '__moddi3',
  0x40000840: '__modsi3',
  0x4000084c: '__muldi3',
  0x40000858: '__mulsi3',
  0x4000077c: '__ashldi3',
  0x40000780: '__ashrdi3',
  0x40000830: '__lshrdi3',
  0x4000079c: '__clzsi2',
  0x40000798: '__clzdi2',
  0x400007a8: '__ctzsi2',
  0x400007a4: '__ctzdi2',
  0x4000086c: '__negdi2',
  0x400007d0: '__ffsdi2',
  0x400007d4: '__ffssi2',
  0x40000784: '__bswapdi2',
  0x40000788: '__bswapsi2',
  0x400007a0: '__cmpdi2',
  0x400008a8: '__ucmpdi2',
  0x40000764: '__absvdi2',
};

export class ESP32C3Runner {
  constructor(firmware) {
    this._firmware = firmware;
    this.cpu = new RV32IMC_CPU();

    // ── Memory ──
    this._dram  = new Uint8Array(DRAM_SIZE);  // SRAM1 (384KB) — also IRAM1 alias
    this._iram0 = new Uint8Array(IRAM0_SIZE); // SRAM0 (16KB) — IRAM only
    this._flash = new Uint8Array(FLASH_SIZE); // 4MB flash backing store
    this._rom   = new Uint8Array(ROM_SIZE);
    this._flashDataImage = null;
    this._flashDataBase = 0;

    // ── Peripheral echo-back store ──
    this._periRegs = new Map();

    // ── GPIO state ──
    this._gpioOut    = 0;
    this._gpioEnable = 0;
    this._gpioIn     = 0;
    this._prevGpioOut = 0;

    // ── UART state ──
    this._uartTxFifo = [];
    this._uartRxFifo = [];

    // ── SYSTIMER state ──
    this._stIntEna = 0;
    this._stIntRaw = 0;
    this._systimerTickArmed = false;

    // ── Interrupt Matrix (62 sources → 31 CPU lines) ──
    this._intSrcMap     = new Uint8Array(62);
    this._intLineEnable = 0;
    this._intLinePrio   = new Uint8Array(32);
    this._intThreshold  = 0;
    this._intPending    = 0;
    this._intSrcActive  = new Uint8Array(62);

    // ── ADC ──
    this._adcValues = new Uint16Array(6);
    for (let i = 0; i < 6; i++) this._adcValues[i] = 2048;

    // ── ROM ets_delay_us multiplier ──
    this._ticksPerUs = 160; // default 160 MHz
    this._rtcTimeSnapshot = 0n;

    // ── Public API state ──
    this.vRef    = 3.3;
    this.running = false;
    this.speed   = 1.0;
    this._frameId = null;
    this._pinChangeListeners = [];
    this._pwmChangeListeners = [];
    /** @type {((char: string) => void)|null} */
    this.onSerial = null;

    // Wire CPU memory interface
    this.cpu.read32  = (a) => this._read32(a);
    this.cpu.write32 = (a, v) => this._write32(a, v);
    this.cpu.read16  = (a) => this._read16(a);
    this.cpu.write16 = (a, v) => this._write16(a, v);
    this.cpu.read8   = (a) => this._read8(a);
    this.cpu.write8  = (a, v) => this._write8(a, v);

    // Wire MIE callback for deferred interrupt delivery
    this.cpu.onMieEnabled = () => this._onMieEnabled();

    // Hook a handful of flash-resident helpers that are easier to virtualize
    // than to model through the full ESP-IDF hardware discovery path.
    const origExecuteInstruction = this.cpu.executeInstruction.bind(this.cpu);
    this.cpu.executeInstruction = () => {
      if (this._emulateFlashFunction()) {
        this.cpu.x[0] = 0;
        this.cpu._cycleCount++;
        this.cpu._instretCount++;
        return 1;
      }
      return origExecuteInstruction();
    };

    // Load firmware and init ROM stubs
    this._loadFirmware(firmware);
    this._initROM();
    this._initRtcState();
  }

  // ════════════════════════════════════════════════════
  //  Public API (same as AVRRunner / RP2040Runner)
  // ════════════════════════════════════════════════════

  addPinChangeListener(fn) {
    this._pinChangeListeners.push(fn);
    return () => { const i = this._pinChangeListeners.indexOf(fn); if (i >= 0) this._pinChangeListeners.splice(i, 1); };
  }
  addPwmChangeListener(fn) {
    this._pwmChangeListeners.push(fn);
    return () => { const i = this._pwmChangeListeners.indexOf(fn); if (i >= 0) this._pwmChangeListeners.splice(i, 1); };
  }
  setPinState(pin, high) {
    if (pin < 0 || pin >= GPIO_COUNT) return;
    if (high) this._gpioIn |= (1 << pin);
    else this._gpioIn &= ~(1 << pin);
  }
  setADCValue(channel, voltage) {
    if (channel < 0 || channel >= 6) return;
    this._adcValues[channel] = Math.max(0, Math.min(4095, Math.round((voltage / 3.3) * 4095)));
  }
  get waiting() { return this.cpu.waiting; }

  start() {
    if (this.running) return;
    this.running = true;
    let _spinCount = 0;
    let _lastPC = 0;

    const loop = () => {
      if (!this.running) return;
      let rem = Math.floor(CYCLES_PER_FRAME * this.speed);
      try {
        while (rem > 0) {
          const chunk = rem < CYCLES_PER_TICK ? rem : CYCLES_PER_TICK;
          for (let i = 0; i < chunk; i++) {
            const pc = this.cpu.pc;
            this.cpu.executeInstruction();
            // Detect spin loops (`j .` / `wfi` stuck) — force return if stuck
            if (this.cpu.pc === pc) {
              _spinCount++;
              if (_spinCount > 500) {
                // Force return from stuck function (set PC to ra, like c.ret)
                this.cpu.pc = (this.cpu.x[1] & ~1) >>> 0;
                this.cpu.x[10] = 0; // return 0
                _spinCount = 0;
              }
            } else {
              _spinCount = 0;
            }
          }
          rem -= chunk;
          // Fire 1ms FreeRTOS tick.
          // ESP-IDF v5 uses CLIC (not legacy interrupt matrix) on ESP32-C3.
          // The firmware configures SYSTIMER via CSRs, not SOURCE_MAP registers.
          // We inject the timer interrupt directly when threshold allows it.
          this._stIntRaw |= 1;
          this._injectTimerInterrupt();
          // Flush peripherals
          this._processGPIOChanges();
          this._flushUART();
        }
      } catch (err) {
        console.error('[ESP32-C3] Simulation error:', err);
        this.stop();
        return;
      }
      this._frameId = requestAnimationFrame(loop);
    };
    this._frameId = requestAnimationFrame(loop);
  }

  pause() {
    this.running = false;
    if (this._frameId) { cancelAnimationFrame(this._frameId); this._frameId = null; }
  }
  stop() { this.pause(); }

  reset() {
    if (!this._firmware) return;
    const was = this.running;
    this.pause();
    this._dram.fill(0); this._iram0.fill(0); this._flash.fill(0);
    this._gpioOut = 0; this._gpioEnable = 0; this._gpioIn = 0; this._prevGpioOut = 0;
    this._uartTxFifo = []; this._uartRxFifo = [];
    this._stIntEna = 0; this._stIntRaw = 0; this._systimerTickArmed = false;
    this._intSrcMap.fill(0); this._intLineEnable = 0;
    this._intLinePrio.fill(0); this._intThreshold = 0;
    this._intPending = 0; this._intSrcActive.fill(0);
    this._periRegs.clear();
    this.cpu.x.fill(0);
    this.cpu.csrs.set(0x300, 0); this.cpu.csrs.set(0x305, 0);
    this.cpu.waiting = false; this.cpu.halted = false;
    this.cpu.pendingInterrupt = null;
    this.cpu._cycleCount = 0; this.cpu._instretCount = 0;
    this._loadFirmware(this._firmware);
    this._initROM();
    this._initRtcState();
    if (was) this.start();
  }

  // ════════════════════════════════════════════════════
  //  Firmware Loading
  // ════════════════════════════════════════════════════

  /**
   * Load firmware into emulated memory.
   *
   * Flash model: one coherent 4MB _flash buffer.
   *   - Merged image: copied in whole; _appOffset from partition table.
   *   - App-only image (.bin): placed at _appOffset=0; rawImage IS the flash.
   *
   * MMU mapping (same as real hardware after bootloader configures cache):
   *   IROM virtual 0x42000000+X  →  _flash[_appOffset + X]
   *   DROM virtual 0x3C000000+X  →  _flash[_appOffset + X]
   *
   * RAM segments (0x3FC8xxxx DRAM, 0x4037xxxx/0x4038xxxx IRAM) are still
   * loaded into their respective RAM buffers.
   */
  /**
   * Load firmware into emulated memory.
   *
   * Flash model: single 4MB flash buffer.
   *   - IROM segment (virtual 0x42XXXXXX): loaded at flash[vaddr - 0x42000000]
   *   - DROM segment (virtual 0x3CXXXXXX): loaded at flash[vaddr - 0x3C000000]
   *   IROM and DROM occupy non-overlapping regions of the same flash buffer
   *   because their virtual offsets differ (IROM at low offsets, DROM at higher).
   *
   * RAM segments loaded into separate RAM buffers:
   *   - DRAM (0x3FC8XXXX) → _dram
   *   - IRAM1 (0x4038XXXX) → _dram (SRAM1 alias)
   *   - IRAM0 (0x4037XXXX) → _iram0
   *
   * For reads: IROM/DROM virtual addr → flash[vaddr - base] (no appOffset).
   */
  _loadFirmware(fw) {
    this._flashDataImage = fw.rawImage || null;
    this._flashDataBase = fw.rawImageBase || 0;
    for (const seg of fw.segments) {
      const a = seg.loadAddr >>> 0;
      const data = seg.data;
      const len = data.length;

      // IROM (flash instruction) — load at virtual offset
      if (a >= FLASH_IBUS_BASE && a < FLASH_IBUS_BASE + FLASH_SIZE) {
        const off = a - FLASH_IBUS_BASE;
        this._flash.set(data.subarray(0, Math.min(len, FLASH_SIZE - off)), off);
      }
      // DROM (flash data) — load at virtual offset (same flash buffer)
      else if (a >= FLASH_DBUS_BASE && a < FLASH_DBUS_BASE + FLASH_SIZE) {
        const off = a - FLASH_DBUS_BASE;
        this._flash.set(data.subarray(0, Math.min(len, FLASH_SIZE - off)), off);
      }
      // DRAM
      else if (a >= DRAM_BASE && a < DRAM_BASE + DRAM_SIZE) {
        const off = a - DRAM_BASE;
        this._dram.set(data.subarray(0, Math.min(len, DRAM_SIZE - off)), off);
      }
      // IRAM1 (SRAM1 alias → same physical memory as DRAM)
      else if (a >= IRAM1_BASE && a < IRAM1_BASE + IRAM1_SIZE) {
        const off = a - IRAM1_BASE;
        this._dram.set(data.subarray(0, Math.min(len, IRAM1_SIZE - off)), off);
      }
      // IRAM0 (SRAM0, separate 16KB)
      else if (a >= IRAM0_BASE && a < IRAM0_BASE + IRAM0_SIZE) {
        const off = a - IRAM0_BASE;
        this._iram0.set(data.subarray(0, Math.min(len, IRAM0_SIZE - off)), off);
      }
      // Skip other segments (ROM, ULP, etc.)
    }

    this.cpu.pc = fw.entryAddr >>> 0;
    this.cpu.x[2] = (DRAM_BASE + DRAM_SIZE - 16) >>> 0;
  }

  _readFlashData(off, size) {
    if (!this._flashDataImage) return undefined;
    const idx = this._flashDataBase + off;
    if (idx < 0 || idx + size > this._flashDataImage.length) return undefined;
    const buf = this._flashDataImage;
    if (size === 1) return buf[idx];
    if (size === 2) return buf[idx] | (buf[idx + 1] << 8);
    return buf[idx] | (buf[idx + 1] << 8) | (buf[idx + 2] << 16) | (buf[idx + 3] << 24);
  }

  _initROM() {
    // Fill ROM with C.RET (0x8082) stubs — any call into ROM returns immediately
    const view = new DataView(this._rom.buffer);
    for (let i = 0; i < ROM_SIZE - 1; i += 2) {
      view.setUint16(i, 0x8082, true);
    }
  }

  _initRtcState() {
    this._rtcTimeSnapshot = 0n;
    // RTC store registers used by esp_clk helpers during early boot.
    this._periRegs.set(RTC_CNTL_BASE + 0x54, RTC_SLOW_CLK_CAL >>> 0); // RTC_SLOW_CLK_CAL_REG
    // RTC reset defaults that ESP-IDF early init reads before it programs them.
    this._periRegs.set(RTC_CNTL_BASE + 0x1C, RTC_TIMER1_RESET >>> 0); // TIMER1
    this._periRegs.set(RTC_CNTL_BASE + 0x24, RTC_TIMER3_RESET >>> 0); // TIMER3
    this._periRegs.set(RTC_CNTL_BASE + 0x2C, RTC_TIMER5_RESET >>> 0); // TIMER5
    this._periRegs.set(RTC_CNTL_BASE + 0x30, RTC_TIMER6_RESET >>> 0); // TIMER6
    this._periRegs.set(RTC_CNTL_BASE + 0x34, RTC_ANA_CONF_RESET >>> 0); // ANA_CONF
  }

  _getRtcTime() {
    return (BigInt(this.cpu._cycleCount) * BigInt(RTC_SLOW_CLK_HZ)) / BigInt(F_CPU);
  }

  _snapshotRtcTime() {
    this._rtcTimeSnapshot = this._getRtcTime();
    this._periRegs.set(RTC_CNTL_BASE + 0x10, Number(this._rtcTimeSnapshot & 0xFFFFFFFFn) >>> 0);
    this._periRegs.set(RTC_CNTL_BASE + 0x14, Number((this._rtcTimeSnapshot >> 32n) & 0xFFFFn) >>> 0);
  }

  _emulateFlashFunction() {
    const pc = this.cpu.pc >>> 0;
    if (SOC_GET_AVAILABLE_MEMORY_REGION_MAX_COUNT.has(pc)) {
      this.cpu.x[10] = 1; // one synthesized DRAM heap region
      this.cpu.pc = (this.cpu.x[1] & ~1) >>> 0;
      return true;
    }
    if (SOC_GET_AVAILABLE_MEMORY_REGIONS.has(pc)) {
      const ptr = this.cpu.x[10] >>> 0;
      const heapStart = DRAM_BASE + 0x20000; // stay clear of early boot static/data usage
      const heapSize = (DRAM_BASE + DRAM_SIZE) - heapStart;
      const iramAlias = IRAM1_BASE + (heapStart - DRAM_BASE);
      // struct soc_memory_region_t { intptr_t start; size_t size; size_t type; intptr_t iram_address; bool startup_stack; }
      this._write32(ptr + 0, heapStart);
      this._write32(ptr + 4, heapSize);
      this._write32(ptr + 8, 0); // type index 0 is sufficient for emulator heap bootstrap
      this._write32(ptr + 12, iramAlias);
      this._write8(ptr + 16, 0);
      this.cpu.x[10] = 1;
      this.cpu.pc = (this.cpu.x[1] & ~1) >>> 0;
      return true;
    }
    if (ESP_MPROT_SET_PROT.has(pc)) {
      // Memory protection setup is not meaningful in the browser runner and
      // currently trips several ESP-IDF early-boot checks. Report success.
      this.cpu.x[10] = 0;
      this.cpu.pc = (this.cpu.x[1] & ~1) >>> 0;
      return true;
    }
    return false;
  }

  // ════════════════════════════════════════════════════
  //  Memory Access
  // ════════════════════════════════════════════════════

  _read8(addr)  { return this._readMem(addr, 1); }
  _read16(addr) { return this._readMem(addr, 2); }
  _read32(addr) { return this._readMem(addr, 4); }

  _write8(addr, v)  { this._writeMem(addr, v, 1); }
  _write16(addr, v) { this._writeMem(addr, v, 2); }
  _write32(addr, v) { this._writeMem(addr, v, 4); }

  _readMem(addr, size) {
    const a = addr >>> 0;
    // DRAM (SRAM1 data bus)
    if (a >= DRAM_BASE && a < DRAM_BASE + DRAM_SIZE)
      return this._readBuf(this._dram, a - DRAM_BASE, size);
    // IRAM1 (SRAM1 instruction bus — alias of DRAM)
    if (a >= IRAM1_BASE && a < IRAM1_BASE + IRAM1_SIZE)
      return this._readBuf(this._dram, a - IRAM1_BASE, size);
    // IRAM0 (SRAM0, separate 16KB)
    if (a >= IRAM0_BASE && a < IRAM0_BASE + IRAM0_SIZE)
      return this._readBuf(this._iram0, a - IRAM0_BASE, size);
    // Flash instruction (IROM): virtual 0x42000000+X → _flash[X]
    if (a >= FLASH_IBUS_BASE && a < FLASH_IBUS_BASE + FLASH_SIZE)
      return this._readBuf(this._flash, a - FLASH_IBUS_BASE, size);
    // Flash data (DROM): prefer raw flash image if present so early boot can
    // inspect app headers/metadata using the real flash layout.
    if (a >= FLASH_DBUS_BASE && a < FLASH_DBUS_BASE + FLASH_SIZE) {
      const off = a - FLASH_DBUS_BASE;
      const raw = this._readFlashData(off, size);
      if (raw !== undefined) return raw;
      return this._readBuf(this._flash, off, size);
    }
    // ROM — check for function hooks first
    if (a >= ROM_BASE && a < ROM_BASE + ROM_SIZE) {
      if (size >= 2 && this._checkRomHook(a)) {
        // Return C.RET opcode (0x8082)
        return 0x8082;
      }
      return this._readBuf(this._rom, a - ROM_BASE, size);
    }
    // Peripherals
    if (a >= 0x60000000 && a < PERIPH_END)
      return this._readPeripheral(a, size);
    return 0;
  }

  _writeMem(addr, value, size) {
    const a = addr >>> 0;
    if (a >= DRAM_BASE && a < DRAM_BASE + DRAM_SIZE)
      { this._writeBuf(this._dram, a - DRAM_BASE, value, size); return; }
    if (a >= IRAM1_BASE && a < IRAM1_BASE + IRAM1_SIZE)
      { this._writeBuf(this._dram, a - IRAM1_BASE, value, size); return; }
    if (a >= IRAM0_BASE && a < IRAM0_BASE + IRAM0_SIZE)
      { this._writeBuf(this._iram0, a - IRAM0_BASE, value, size); return; }
    if (a >= 0x60000000 && a < PERIPH_END)
      { this._writePeripheral(a, value, size); return; }
  }

  _readBuf(buf, off, size) {
    if (size === 1) return buf[off];
    if (size === 2) return buf[off] | (buf[off + 1] << 8);
    return buf[off] | (buf[off + 1] << 8) | (buf[off + 2] << 16) | (buf[off + 3] << 24);
  }

  _writeBuf(buf, off, val, size) {
    if (size === 1) { buf[off] = val & 0xFF; return; }
    if (size === 2) { buf[off] = val & 0xFF; buf[off + 1] = (val >> 8) & 0xFF; return; }
    buf[off] = val & 0xFF; buf[off + 1] = (val >> 8) & 0xFF;
    buf[off + 2] = (val >> 16) & 0xFF; buf[off + 3] = (val >> 24) & 0xFF;
  }

  // ════════════════════════════════════════════════════
  //  ROM Function Hooks
  // ════════════════════════════════════════════════════

  _checkRomHook(addr) {
    if (this.cpu.pc !== addr) return false;
    const name = ROM_FUNCS[addr];
    if (!name) {
      // Unknown ROM function — return a0=0 (ESP_OK) and let C.RET return
      this.cpu.x[10] = 0;
      return true;
    }
    this._emulateRomFunc(name);
    return true;
  }

  _emulateRomFunc(name) {
    const x = this.cpu.x;
    switch (name) {
      case 'memset': {
        const dest = x[10] >>> 0, val = x[11] & 0xFF, n = x[12] >>> 0;
        for (let i = 0; i < n; i++) this._write8(dest + i, val);
        break; // a0 = dest (already set)
      }
      case 'bzero': {
        const dest = x[10] >>> 0, n = x[11] >>> 0;
        for (let i = 0; i < n; i++) this._write8(dest + i, 0);
        break;
      }
      case 'memcpy': case 'memmove': {
        const dest = x[10] >>> 0, src = x[11] >>> 0, n = x[12] >>> 0;
        if (dest < src) {
          for (let i = 0; i < n; i++) this._write8(dest + i, this._read8(src + i));
        } else {
          for (let i = n - 1; i >= 0; i--) this._write8(dest + i, this._read8(src + i));
        }
        break; // a0 = dest
      }
      case 'memcmp': {
        const a = x[10] >>> 0, b = x[11] >>> 0, n = x[12] >>> 0;
        let res = 0;
        for (let i = 0; i < n; i++) {
          const d = (this._read8(a + i) & 0xFF) - (this._read8(b + i) & 0xFF);
          if (d !== 0) { res = d > 0 ? 1 : -1; break; }
        }
        x[10] = res;
        break;
      }
      case 'strcpy': {
        const dest = x[10] >>> 0, src = x[11] >>> 0;
        let i = 0;
        while (true) {
          const c = this._read8(src + i) & 0xFF;
          this._write8(dest + i, c);
          if (c === 0) break;
          i++;
        }
        break;
      }
      case 'strcmp': {
        let a = x[10] >>> 0, b = x[11] >>> 0;
        while (true) {
          const ca = this._read8(a) & 0xFF, cb = this._read8(b) & 0xFF;
          if (ca !== cb || ca === 0) { x[10] = ca - cb; break; }
          a++; b++;
        }
        break;
      }
      case 'strlen': {
        let s = x[10] >>> 0, len = 0;
        while ((this._read8(s + len) & 0xFF) !== 0) len++;
        x[10] = len;
        break;
      }
      case 'rtc_get_reset_reason': x[10] = 1; break; // POWERON_RESET
      case 'ets_delay_us': {
        this.cpu._cycleCount += (x[10] >>> 0) * this._ticksPerUs;
        x[10] = 0;
        break;
      }
      case 'ets_update_cpu_frequency':
        this._ticksPerUs = x[10] | 0;
        x[10] = 0;
        break;
      case 'intr_matrix_set':
        // a0=cpu_no, a1=source, a2=cpu_line
        if ((x[11] >>> 0) < 62) this._intSrcMap[x[11] >>> 0] = x[12] & 0x1F;
        x[10] = 0;
        break;
      case 'uart_tx_wait_idle':
      case 'Cache_Set_IDROM_MMU_Size':
      case 'rom_i2c_writeReg':
      case 'rom_i2c_writeReg_Mask':
        x[10] = 0;
        break;
      // libgcc 32-bit math
      case '__mulsi3':  x[10] = Math.imul(x[10], x[11]); break;
      case '__divsi3':  x[10] = x[11] ? (x[10] / x[11]) | 0 : 0; break;
      case '__udivsi3': x[10] = x[11] ? ((x[10] >>> 0) / (x[11] >>> 0)) | 0 : 0; break;
      case '__modsi3':  x[10] = x[11] ? (x[10] % x[11]) | 0 : 0; break;
      case '__umodsi3': x[10] = x[11] ? ((x[10] >>> 0) % (x[11] >>> 0)) | 0 : 0; break;
      case '__clzsi2':  x[10] = Math.clz32(x[10]); break;
      case '__ctzsi2':  x[10] = x[10] ? 31 - Math.clz32(x[10] & -x[10]) : 32; break;
      case '__ffssi2':  x[10] = x[10] ? 32 - Math.clz32(x[10] & -x[10]) : 0; break;
      case '__bswapsi2': {
        const v = x[10] >>> 0;
        x[10] = ((v >>> 24) | ((v >> 8) & 0xFF00) | ((v << 8) & 0xFF0000) | (v << 24)) | 0;
        break;
      }
      // libgcc 64-bit math (a0:a1 = lo:hi, a2:a3 = lo:hi)
      case '__muldi3': case '__udivdi3': case '__udivmoddi4': case '__umoddi3':
      case '__divdi3': case '__moddi3': case '__ashldi3': case '__ashrdi3':
      case '__lshrdi3': case '__negdi2': case '__clzdi2': case '__ctzdi2':
      case '__ffsdi2': case '__bswapdi2': case '__cmpdi2': case '__ucmpdi2':
      case '__absvdi2':
        this._emulate64(name);
        break;
      default:
        x[10] = 0; // ESP_OK for unknown
    }
  }

  _emulate64(name) {
    const x = this.cpu.x;
    const aLo = x[10] >>> 0, aHi = x[11] | 0;
    const bLo = x[12] >>> 0, bHi = x[13] | 0;
    const a = BigInt(aLo) | (BigInt(aHi) << 32n);
    const b = BigInt(bLo) | (BigInt(bHi) << 32n);
    let r = 0n;
    switch (name) {
      case '__muldi3':  r = a * b; break;
      case '__udivdi3': r = b ? BigInt.asUintN(64, a) / BigInt.asUintN(64, b) : 0n; break;
      case '__umoddi3': r = b ? BigInt.asUintN(64, a) % BigInt.asUintN(64, b) : a; break;
      case '__divdi3':  r = b ? BigInt.asIntN(64, a) / BigInt.asIntN(64, b) : 0n; break;
      case '__moddi3':  r = b ? BigInt.asIntN(64, a) % BigInt.asIntN(64, b) : a; break;
      case '__ashldi3': r = a << (BigInt(bLo) & 63n); break;
      case '__ashrdi3': r = BigInt.asIntN(64, a) >> (BigInt(bLo) & 63n); break;
      case '__lshrdi3': r = BigInt.asUintN(64, a) >> (BigInt(bLo) & 63n); break;
      case '__negdi2':  r = -a; break;
      case '__udivmoddi4': {
        const ua = BigInt.asUintN(64, a), ub = BigInt.asUintN(64, b);
        r = ub ? ua / ub : 0n;
        if ((x[14] >>> 0) !== 0) { // *rem pointer in a4
          const rem = ub ? ua % ub : ua;
          const ptr = x[14] >>> 0;
          this._write32(ptr, Number(rem & 0xFFFFFFFFn));
          this._write32(ptr + 4, Number((rem >> 32n) & 0xFFFFFFFFn));
        }
        break;
      }
      default: r = 0n;
    }
    x[10] = Number(r & 0xFFFFFFFFn) | 0;
    x[11] = Number((r >> 32n) & 0xFFFFFFFFn) | 0;
  }

  // ════════════════════════════════════════════════════
  //  Peripheral Read/Write
  // ════════════════════════════════════════════════════

  _readPeripheral(addr, size) {
    const a = addr >>> 0;
    const wordAddr = a & ~3;
    const byteIdx  = a & 3;
    let val = 0;

    // ── UART0 ──
    if (a >= UART0_BASE && a < UART0_BASE + 0x400) {
      const off = wordAddr - UART0_BASE;
      if (off === 0x00) val = this._uartRxFifo.length > 0 ? this._uartRxFifo.shift() : 0;
      else if (off === 0x1C) val = 0; // TXFIFO empty
      else val = this._periRegs.get(wordAddr) || 0;
    }
    // ── GPIO ──
    else if (a >= GPIO_BASE && a < GPIO_BASE + 0x1000) {
      const off = wordAddr - GPIO_BASE;
      if (off === 0x04)      val = this._gpioOut;
      else if (off === 0x20) val = 0xFF; // GPIO_ENABLE
      else if (off === 0x3C) val = this._gpioIn;
      else val = this._periRegs.get(wordAddr) || 0;
    }
    // ── SYSTIMER ──
    else if (a >= SYSTIMER_BASE && a < SYSTIMER_BASE + 0x100) {
      const off = wordAddr - SYSTIMER_BASE;
      if (off === 0x04) val = this._stIntEna;
      else if (off === 0x08) val = this._stIntRaw;
      else if (off === 0x0C) val = 0; // INT_CLR write-only
      else if (off === 0x10) val = this._stIntRaw & this._stIntEna;
      else if (off === 0x14) val = (1 << 29); // UNIT0_OP: VALID=1
      else if (off === 0x54) val = ((this.cpu._cycleCount / 10) >>> 0); // UNIT0_VAL_LO
      else if (off === 0x58) val = 0; // UNIT0_VAL_HI
      else val = this._periRegs.get(wordAddr) || 0;
    }
    // ── Interrupt Matrix ──
    else if (a >= INTMTX_BASE && a < INTMTX_BASE + 0x800) {
      val = this._readIntMatrix(wordAddr - INTMTX_BASE);
    }
    // ── RTC_CNTL ──
    else if (a >= RTC_CNTL_BASE && a < RTC_CNTL_BASE + 0x1000) {
      const off = wordAddr - RTC_CNTL_BASE;
      if (off === 0x38) val = 1; // RESET_STATE: POWERON_RESET
      else if (off === 0x10 || off === 0x14) val = this._periRegs.get(wordAddr) || 0; // TIME_LOW0/HIGH0 snapshot
      else val = this._periRegs.get(wordAddr) || 0;
    }
    // ── Timer Groups (WDT calibration stubs) ──
    else if (this._isTimerGroup(a)) {
      const off = wordAddr & 0xFF;
      if (off === 0x68) val = (1 << 15) | (1 << 31); // RTCCALICFG: RDY + done
      else if (off === 0x6C || off === 0x80) val = (RTC_CALI_VALUE << 7) >>> 0; // calibration result (tuned for ESP-IDF v5 RTC tolerance checks)
      else val = this._periRegs.get(wordAddr) || 0;
    }
    // ── SPI Flash Controllers ──
    else if ((a >= SPI0_BASE && a < SPI0_BASE + 0x200) || (a >= SPI1_BASE && a < SPI1_BASE + 0x200)) {
      const off = wordAddr & 0x1FF;
      if (off === 0x00) val = 0; // SPI_MEM_CMD: all done
      else val = this._periRegs.get(wordAddr) || 0;
    }
    // ── EXTMEM (Flash Cache) ──
    else if (a >= EXTMEM_BASE && a < EXTMEM_BASE + 0x1000) {
      val = this._periRegs.get(wordAddr) || 0;
      const off = wordAddr - EXTMEM_BASE;
      if (off === 0x00) val |= 1;           // ICACHE_CTRL: cache ENABLED
      else if (off === 0x1C) val |= (1 << 2); // ICACHE_LOCK_DONE
      else if (off === 0x28) val |= (1 << 1); // ICACHE_SYNC_DONE
      else if (off === 0x34) val |= (1 << 1); // ICACHE_PRELOAD_DONE
      else if (off === 0x40) val |= (1 << 3); // ICACHE_AUTOLOAD_DONE
    }
    // ── SYSTEM (clock control) ──
    else if (a >= SYSTEM_BASE && a < SYSTEM_BASE + 0x800) {
      const off = wordAddr - SYSTEM_BASE;
      // FROM_CPU_INTR registers
      if (off >= 0x28 && off <= 0x34) {
        val = this._periRegs.get(wordAddr) || 0;
      }
      // Clock enables: return all-on
      else if (off === 0x00 || off === 0x10 || off === 0x14) val = 0xFFFFFFFF;
      else if (off === 0x04 || off === 0x18 || off === 0x1C) val = 0; // resets off
      else val = this._periRegs.get(wordAddr) || 0;
    }
    // ── Catch-all echo-back ──
    else {
      val = this._periRegs.get(wordAddr) || 0;
    }

    // Extract byte/halfword from 32-bit value
    if (size === 1) return (val >> (byteIdx * 8)) & 0xFF;
    if (size === 2) return (val >> (byteIdx * 8)) & 0xFFFF;
    return val;
  }

  _writePeripheral(addr, value, size) {
    const a = addr >>> 0;
    const wordAddr = a & ~3;
    const byteIdx  = a & 3;

    // Merge byte/halfword into word
    if (size < 4) {
      const old = this._periRegs.get(wordAddr) || 0;
      const mask = size === 1 ? 0xFF : 0xFFFF;
      const shift = byteIdx * 8;
      value = (old & ~(mask << shift)) | ((value & mask) << shift);
    }

    // ── UART0 ──
    if (a >= UART0_BASE && a < UART0_BASE + 0x400) {
      const off = wordAddr - UART0_BASE;
      if (off === 0x00) { this._uartTxFifo.push(value & 0xFF); return; }
      this._periRegs.set(wordAddr, value);
      return;
    }
    // ── GPIO ──
    if (a >= GPIO_BASE && a < GPIO_BASE + 0x1000) {
      const off = wordAddr - GPIO_BASE;
      if (off === 0x04)      this._gpioOut = value;
      else if (off === 0x08) this._gpioOut |= value;  // W1TS
      else if (off === 0x0C) this._gpioOut &= ~value;  // W1TC
      else if (off === 0x20) this._gpioEnable = value;
      else if (off === 0x24) this._gpioEnable |= value;
      else if (off === 0x28) this._gpioEnable &= ~value;
      else this._periRegs.set(wordAddr, value);
      return;
    }
    // ── SYSTIMER ──
    if (a >= SYSTIMER_BASE && a < SYSTIMER_BASE + 0x100) {
      const off = wordAddr - SYSTIMER_BASE;
      if (off === 0x04) {
        this._stIntEna = value;
        if (value & 1) this._systimerTickArmed = true;
      }
      else if (off === 0x0C) {
        // INT_CLR: write-1-to-clear
        this._stIntRaw &= ~value;
        if (value & 1) this._lowerIntSource(ETS_SYSTIMER_TARGET0_SRC);
      }
      else this._periRegs.set(wordAddr, value);
      return;
    }
    // ── Interrupt Matrix ──
    if (a >= INTMTX_BASE && a < INTMTX_BASE + 0x800) {
      this._writeIntMatrix(wordAddr - INTMTX_BASE, value);
      this._periRegs.set(wordAddr, value);
      return;
    }
    // ── SYSTEM: FROM_CPU_INTR ──
    if (a >= SYSTEM_BASE && a < SYSTEM_BASE + 0x800) {
      const off = wordAddr - SYSTEM_BASE;
      if (off >= 0x28 && off <= 0x34) {
        const idx = (off - 0x28) >> 2;
        this._periRegs.set(wordAddr, value);
        if (value & 1) this._raiseIntSource(ETS_FROM_CPU_INTR0_SRC + idx);
        else this._lowerIntSource(ETS_FROM_CPU_INTR0_SRC + idx);
        return;
      }
    }
    // ── RTC_CNTL ──
    if (a >= RTC_CNTL_BASE && a < RTC_CNTL_BASE + 0x1000) {
      const off = wordAddr - RTC_CNTL_BASE;
      if (off === 0x0C && (value & 0x80000000)) {
        this._snapshotRtcTime();
        this._periRegs.set(wordAddr, value & ~0x80000000);
      } else {
        this._periRegs.set(wordAddr, value);
      }
      return;
    }
    // ── EXTMEM ──
    if (a >= EXTMEM_BASE && a < EXTMEM_BASE + 0x1000) {
      this._periRegs.set(wordAddr, value);
      return;
    }
    // ── Catch-all echo-back ──
    this._periRegs.set(wordAddr, value);
  }

  _isTimerGroup(addr) {
    return (addr >= TIMG0_BASE && addr < TIMG0_BASE + 0x100) ||
           (addr >= TIMG1_BASE && addr < TIMG1_BASE + 0x100) ||
           (addr >= APB_CTRL0  && addr < APB_CTRL0 + 0x100)  ||
           (addr >= APB_CTRL1  && addr < APB_CTRL1 + 0x100);
  }

  // ════════════════════════════════════════════════════
  //  Interrupt Matrix
  // ════════════════════════════════════════════════════

  _readIntMatrix(off) {
    // SOURCE_MAP[0..61]: offset 0x000–0x0F4
    if (off <= 0x0F4) {
      const src = off >> 2;
      return src < 62 ? this._intSrcMap[src] & 0x1F : 0;
    }
    if (off === 0x104) return this._intLineEnable;
    if (off === 0x108) return this._periRegs.get(INTMTX_BASE + off) || 0; // INT_TYPE
    if (off === 0x10C) return this._intPending;
    if (off >= 0x114 && off <= 0x190) {
      const line = (off - 0x114) >> 2;
      return this._intLinePrio[line] || 0;
    }
    if (off === 0x194) return this._intThreshold;
    return 0;
  }

  _writeIntMatrix(off, val) {
    if (off <= 0x0F4) {
      const src = off >> 2;
      if (src < 62) this._intSrcMap[src] = val & 0x1F;
      return;
    }
    if (off === 0x104) { this._intLineEnable = val; return; }
    if (off >= 0x114 && off <= 0x190) {
      this._intLinePrio[(off - 0x114) >> 2] = val & 0xF;
      return;
    }
    if (off === 0x194) { this._intThreshold = val & 0xF; return; }
  }

  _raiseIntSource(src) {
    if (src >= 62) return;
    this._intSrcActive[src] = 1;
    const line = this._intSrcMap[src] & 0x1F;
    if (!line) return;
    this._intPending |= (1 << line);
    this._tryDeliverInt(line);
  }

  _lowerIntSource(src) {
    if (src >= 62) return;
    this._intSrcActive[src] = 0;
    const line = this._intSrcMap[src] & 0x1F;
    if (!line) return;
    // Only clear pending if no other active source maps to this line
    for (let s = 0; s < 62; s++) {
      if (this._intSrcActive[s] && (this._intSrcMap[s] & 0x1F) === line) return;
    }
    this._intPending &= ~(1 << line);
  }

  _tryDeliverInt(line) {
    if (!(this._intLineEnable & (1 << line))) return;
    const prio = this._intLinePrio[line] || 0;
    if (prio <= this._intThreshold) return;
    const mstatus = this.cpu.csrs.get(0x300) || 0;
    if (!(mstatus & 0x8)) return; // MIE disabled
    this._intPending &= ~(1 << line);
    this.cpu.triggerInterrupt((0x80000000 | line) >>> 0);
  }

  _onMieEnabled() {
    // MIE just transitioned 0→1 — scan for pending interrupts (legacy matrix)
    let bestLine = -1, bestPrio = -1;
    let pending = this._intPending & this._intLineEnable;
    while (pending) {
      const line = 31 - Math.clz32(pending);
      pending &= ~(1 << line);
      const prio = this._intLinePrio[line] || 0;
      if (prio > this._intThreshold && prio > bestPrio) {
        bestPrio = prio;
        bestLine = line;
      }
    }
    if (bestLine >= 0) {
      this._intPending &= ~(1 << bestLine);
      this.cpu.triggerInterrupt((0x80000000 | bestLine) >>> 0);
    }
    // Also check CLIC-style timer interrupt
    if (this._stIntRaw & this._stIntEna & 1) {
      this._injectTimerInterrupt();
    }
  }

  /**
   * Inject SYSTIMER_TARGET0 interrupt via CLIC model.
   * ESP-IDF v5 on ESP32-C3 uses CLIC where the timer interrupt is routed
   * to a specific CPU interrupt line (typically line 7 for systimer).
   * The firmware configures this via CSRs, not SOURCE_MAP registers.
   * We deliver the interrupt when: MIE=1 and threshold=0.
   */
  _injectTimerInterrupt() {
    if (!(this._stIntRaw & 1)) return;
    const mstatus = this.cpu.csrs.get(0x300) || 0;
    if (!(mstatus & 0x8)) return; // MIE disabled
    if (this._intThreshold > 0) return; // interrupts gated by threshold

    // Find the SYSTIMER interrupt line. ESP-IDF v5 typically uses line 1
    // for the systimer on ESP32-C3 (configured via esp_intr_alloc).
    // If the firmware mapped src37 via SOURCE_MAP, use that line.
    // Otherwise, scan for any configured line or use line 7 as default.
    let line = this._intSrcMap[ETS_SYSTIMER_TARGET0_SRC] & 0x1F;
    if (!line) {
      // CLIC fallback: the firmware may have configured interrupt priority
      // for a specific line. Find the first line with non-zero priority.
      for (let l = 1; l < 32; l++) {
        if (this._intLinePrio[l] > 0 && (this._intLineEnable & (1 << l))) {
          line = l;
          break;
        }
      }
    }
    if (!line) line = 7; // absolute fallback: machine timer interrupt line

    this.cpu.triggerInterrupt((0x80000000 | line) >>> 0);
  }

  // ════════════════════════════════════════════════════
  //  GPIO / UART helpers
  // ════════════════════════════════════════════════════

  _processGPIOChanges() {
    const changed = this._gpioOut ^ this._prevGpioOut;
    if (!changed) return;
    for (let i = 0; i < GPIO_COUNT; i++) {
      if (changed & (1 << i)) {
        const high = !!(this._gpioOut & (1 << i));
        for (const fn of this._pinChangeListeners) fn(i, high);
      }
    }
    this._prevGpioOut = this._gpioOut;
  }

  _flushUART() {
    if (!this._uartTxFifo.length) return;
    if (this.onSerial) {
      for (const b of this._uartTxFifo) this.onSerial(String.fromCharCode(b));
    }
    this._uartTxFifo.length = 0;
  }

  serialWrite(char) {
    this._uartRxFifo.push(char.charCodeAt(0));
  }
}
