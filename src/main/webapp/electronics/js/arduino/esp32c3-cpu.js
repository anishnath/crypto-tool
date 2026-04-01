/**
 * RV32IMC CPU Core — RISC-V emulator for ESP32-C3.
 *
 * Implements:
 *   - RV32I base integer instruction set (37 instructions)
 *   - M extension: multiply / divide (8 instructions)
 *   - C extension: compressed 16-bit instructions
 *   - CSR registers: mstatus, mie, mip, mtvec, mepc, mcause, mtval, mcycle, minstret
 *   - Machine-mode trap handling (ecall, ebreak, illegal instruction)
 *   - WFI (wait for interrupt)
 *
 * Memory access is delegated to a read32/write32/read16/read8/write16/write8 interface
 * provided by the runner (ESP32C3Runner), which maps addresses to RAM, flash, and peripherals.
 */

// Opcode constants (bits [6:0])
const OP_LUI     = 0b0110111;
const OP_AUIPC   = 0b0010111;
const OP_JAL     = 0b1101111;
const OP_JALR    = 0b1100111;
const OP_BRANCH  = 0b1100011;
const OP_LOAD    = 0b0000011;
const OP_STORE   = 0b0100011;
const OP_IMM     = 0b0010011;
const OP_REG     = 0b0110011;
const OP_FENCE   = 0b0001111;
const OP_SYSTEM  = 0b1110011;
const OP_AMO     = 0b0101111;

// CSR addresses
const CSR_MSTATUS  = 0x300;
const CSR_MISA     = 0x301;
const CSR_MIE      = 0x304;
const CSR_MTVEC    = 0x305;
const CSR_MSCRATCH = 0x340;
const CSR_MEPC     = 0x341;
const CSR_MCAUSE   = 0x342;
const CSR_MTVAL    = 0x343;
const CSR_MIP      = 0x344;
const CSR_MCYCLE   = 0xB00;
const CSR_MCYCLEH  = 0xB80;
const CSR_MINSTRET = 0xB02;
const CSR_MINSTRETH= 0xB82;
const CSR_MHARTID  = 0xF14;
// Read-only aliases
const CSR_CYCLE    = 0xC00;
const CSR_CYCLEH   = 0xC80;
const CSR_INSTRET  = 0xC02;
const CSR_INSTRETH = 0xC82;

// Exception causes
const CAUSE_MISALIGNED_FETCH = 0;
const CAUSE_ILLEGAL_INSN     = 2;
const CAUSE_BREAKPOINT       = 3;
const CAUSE_LOAD_MISALIGNED  = 4;
const CAUSE_STORE_MISALIGNED = 6;
const CAUSE_ECALL_M          = 11;

/**
 * Sign-extend a value from `bits` width to 32 bits.
 */
function signExtend(value, bits) {
  const shift = 32 - bits;
  return (value << shift) >> shift;
}

export class RV32IMC_CPU {
  constructor() {
    // 32 general-purpose registers (x0 is hardwired to 0)
    this.x = new Int32Array(32);
    this.pc = 0;

    // CSR registers
    this.csrs = new Map();
    this.csrs.set(CSR_MSTATUS, 0);
    this.csrs.set(CSR_MISA, 0x40001104); // RV32IMC
    this.csrs.set(CSR_MIE, 0);
    this.csrs.set(CSR_MTVEC, 0);
    this.csrs.set(CSR_MSCRATCH, 0);
    this.csrs.set(CSR_MEPC, 0);
    this.csrs.set(CSR_MCAUSE, 0);
    this.csrs.set(CSR_MTVAL, 0);
    this.csrs.set(CSR_MIP, 0);
    this.csrs.set(CSR_MHARTID, 0);

    // Cycle / instret counters (64-bit as two 32-bit halves)
    this._cycleCount = 0;
    this._instretCount = 0;

    // State
    this.waiting = false; // WFI state
    this.halted = false;

    // Pending external interrupt (set by interrupt matrix, consumed at next step)
    /** @type {number|null} */
    this.pendingInterrupt = null;

    // Callback fired when mstatus.MIE transitions 0→1 (for deferred interrupt delivery)
    /** @type {(() => void)|null} */
    this.onMieEnabled = null;

    // Memory interface (set by runner)
    /** @type {(addr: number) => number} */
    this.read32 = null;
    /** @type {(addr: number, value: number) => void} */
    this.write32 = null;
    /** @type {(addr: number) => number} */
    this.read16 = null;
    /** @type {(addr: number, value: number) => void} */
    this.write16 = null;
    /** @type {(addr: number) => number} */
    this.read8 = null;
    /** @type {(addr: number, value: number) => void} */
    this.write8 = null;
  }

  /** Inject an external interrupt (called by interrupt matrix) */
  triggerInterrupt(cause) {
    this.pendingInterrupt = cause >>> 0;
    this.waiting = false; // wake from WFI
  }

  /** Read a CSR register */
  readCSR(addr) {
    addr &= 0xFFF;
    switch (addr) {
      case CSR_MCYCLE: case CSR_CYCLE:
        return this._cycleCount & 0xFFFFFFFF;
      case CSR_MCYCLEH: case CSR_CYCLEH:
        return (this._cycleCount / 0x100000000) & 0xFFFFFFFF;
      case CSR_MINSTRET: case CSR_INSTRET:
        return this._instretCount & 0xFFFFFFFF;
      case CSR_MINSTRETH: case CSR_INSTRETH:
        return (this._instretCount / 0x100000000) & 0xFFFFFFFF;
      default:
        return this.csrs.get(addr) || 0;
    }
  }

  /** Write a CSR register */
  writeCSR(addr, value) {
    addr &= 0xFFF;
    value = value | 0;
    switch (addr) {
      case CSR_MISA:
      case CSR_MHARTID:
        return; // read-only
      case CSR_CYCLE: case CSR_CYCLEH:
      case CSR_INSTRET: case CSR_INSTRETH:
        return; // read-only aliases
      case CSR_MCYCLE:
        this._cycleCount = (this._cycleCount & 0xFFFFFFFF00000000) | (value >>> 0);
        return;
      case CSR_MCYCLEH:
        this._cycleCount = ((value >>> 0) * 0x100000000) | (this._cycleCount & 0xFFFFFFFF);
        return;
      case CSR_MSTATUS: {
        const oldMie = this.csrs.get(CSR_MSTATUS) & 0x8;
        this.csrs.set(CSR_MSTATUS, value);
        // Fire callback when MIE transitions 0→1
        if (!oldMie && (value & 0x8) && this.onMieEnabled) this.onMieEnabled();
        return;
      }
      default:
        this.csrs.set(addr, value);
    }
  }

  /**
   * Take a trap (exception or interrupt).
   * @param {number} cause - mcause value
   * @param {number} tval - mtval value (faulting address / instruction)
   */
  trap(cause, tval = 0) {
    const mstatus = this.csrs.get(CSR_MSTATUS) || 0;
    // Save MIE to MPIE (bit 7), clear MIE (bit 3), set MPP=M (bits 12:11 = 0b11)
    const newMstatus = (mstatus & ~0x1888) | ((mstatus & 0x8) << 4) | 0x1800;
    this.csrs.set(CSR_MSTATUS, newMstatus);
    this.csrs.set(CSR_MEPC, this.pc);
    this.csrs.set(CSR_MCAUSE, cause);
    this.csrs.set(CSR_MTVAL, tval);

    const mtvec = this.csrs.get(CSR_MTVEC) || 0;
    const mode = mtvec & 3;
    const base = mtvec & ~3;

    if (mode === 1 && cause >= 0) {
      // Vectored: base + 4*cause for interrupts
      this.pc = (base + 4 * (cause & 0x7FFFFFFF)) >>> 0;
    } else {
      this.pc = base;
    }
    this.waiting = false;
  }

  /**
   * Return from machine-mode trap (MRET).
   */
  mret() {
    const mstatus = this.csrs.get(CSR_MSTATUS) || 0;
    const oldMie = mstatus & 0x8;
    // Restore MIE from MPIE, set MPIE=1, set MPP=M
    const newMstatus = (mstatus & ~0x1888) | ((mstatus >> 4) & 0x8) | 0x80;
    this.csrs.set(CSR_MSTATUS, newMstatus);
    this.pc = (this.csrs.get(CSR_MEPC) || 0) >>> 0;
    // Fire callback when MIE transitions 0→1
    if (!oldMie && (newMstatus & 0x8) && this.onMieEnabled) this.onMieEnabled();
  }

  /**
   * Check and handle pending interrupts.
   * @returns {boolean} true if an interrupt was taken
   */
  checkInterrupts() {
    const mstatus = this.csrs.get(CSR_MSTATUS) || 0;
    const mie_bit = mstatus & 0x8; // MIE (global interrupt enable)
    if (!mie_bit) return false;

    const mie = this.csrs.get(CSR_MIE) || 0;
    const mip = this.csrs.get(CSR_MIP) || 0;
    const pending = mie & mip;
    if (!pending) return false;

    // Priority: MEI (11) > MSI (3) > MTI (7)
    let cause = -1;
    if (pending & (1 << 11)) cause = 11; // Machine External Interrupt
    else if (pending & (1 << 3)) cause = 3;  // Machine Software Interrupt
    else if (pending & (1 << 7)) cause = 7;  // Machine Timer Interrupt
    if (cause < 0) return false;

    // Clear pending bit
    this.csrs.set(CSR_MIP, mip & ~(1 << cause));

    // Take interrupt (bit 31 set = interrupt, not exception)
    this.trap((cause | 0x80000000) >>> 0, 0);
    return true;
  }

  /**
   * Execute one instruction. Returns number of cycles consumed.
   * @returns {number} cycles
   */
  executeInstruction() {
    if (this.halted) return 1;
    if (this.waiting && this.pendingInterrupt === null) return 1;

    // Check for pending external interrupt (injected by interrupt matrix)
    if (this.pendingInterrupt !== null) {
      const mstatus = this.csrs.get(CSR_MSTATUS) || 0;
      if (mstatus & 0x8) { // MIE enabled
        const cause = this.pendingInterrupt;
        this.pendingInterrupt = null;
        this.waiting = false;
        // Save MIE→MPIE, clear MIE
        const oldMie = (mstatus >> 3) & 1;
        const newMstatus = (mstatus & ~0x88) | (oldMie << 7);
        this.csrs.set(CSR_MSTATUS, newMstatus);
        this.csrs.set(CSR_MEPC, this.pc);
        this.csrs.set(CSR_MCAUSE, cause);
        const intNum = cause & 0x1F;
        const mtvec = this.csrs.get(CSR_MTVEC) || 0;
        this.pc = ((mtvec & 3) === 1)
          ? (((mtvec & ~3) >>> 0) + (intNum << 2)) >>> 0
          : (mtvec & ~3) >>> 0;
        this._cycleCount++;
        return 1;
      }
    }

    const pc = this.pc >>> 0;

    // Fetch (check for compressed instruction)
    let insn;
    try {
      insn = this.read32(pc) >>> 0;
    } catch (e) {
      this.trap(CAUSE_MISALIGNED_FETCH, pc);
      return 1;
    }

    // Check if compressed instruction (bits [1:0] != 0b11)
    if ((insn & 3) !== 3) {
      // 16-bit compressed instruction
      const cInsn = insn & 0xFFFF;
      const cycles = this._executeCompressed(cInsn, pc);
      this._cycleCount += cycles;
      this._instretCount++;
      return cycles;
    }

    // 32-bit instruction
    const opcode = insn & 0x7F;
    const rd = (insn >> 7) & 0x1F;
    const funct3 = (insn >> 12) & 0x7;
    const rs1 = (insn >> 15) & 0x1F;
    const rs2 = (insn >> 20) & 0x1F;
    const funct7 = (insn >> 25) & 0x7F;

    let cycles = 1;
    let nextPC = pc + 4;

    switch (opcode) {
      case OP_LUI:
        if (rd) this.x[rd] = insn & 0xFFFFF000;
        break;

      case OP_AUIPC:
        if (rd) this.x[rd] = (pc + (insn & 0xFFFFF000)) | 0;
        break;

      case OP_JAL: {
        const imm = this._decodeJImm(insn);
        if (rd) this.x[rd] = (pc + 4) | 0;
        nextPC = (pc + imm) >>> 0;
        cycles = 2;
        break;
      }

      case OP_JALR: {
        const imm = signExtend(insn >> 20, 12);
        const target = ((this.x[rs1] + imm) & ~1) >>> 0;
        if (rd) this.x[rd] = (pc + 4) | 0;
        nextPC = target;
        cycles = 2;
        break;
      }

      case OP_BRANCH: {
        const imm = this._decodeBImm(insn);
        const a = this.x[rs1];
        const b = this.x[rs2];
        let taken = false;
        switch (funct3) {
          case 0: taken = (a === b); break;                     // BEQ
          case 1: taken = (a !== b); break;                     // BNE
          case 4: taken = (a < b); break;                       // BLT
          case 5: taken = (a >= b); break;                      // BGE
          case 6: taken = ((a >>> 0) < (b >>> 0)); break;       // BLTU
          case 7: taken = ((a >>> 0) >= (b >>> 0)); break;      // BGEU
          default:
            this.trap(CAUSE_ILLEGAL_INSN, insn);
            return 1;
        }
        if (taken) {
          nextPC = (pc + imm) >>> 0;
          cycles = 2;
        }
        break;
      }

      case OP_LOAD: {
        const imm = signExtend(insn >> 20, 12);
        const addr = ((this.x[rs1] + imm) >>> 0);
        let value;
        try {
          switch (funct3) {
            case 0: value = signExtend(this.read8(addr), 8); break;        // LB
            case 1: value = signExtend(this.read16(addr), 16); break;      // LH
            case 2: value = this.read32(addr); break;                       // LW
            case 4: value = this.read8(addr) & 0xFF; break;                // LBU
            case 5: value = this.read16(addr) & 0xFFFF; break;             // LHU
            default:
              this.trap(CAUSE_ILLEGAL_INSN, insn);
              return 1;
          }
        } catch (e) {
          this.trap(CAUSE_LOAD_MISALIGNED, addr);
          return 1;
        }
        if (rd) this.x[rd] = value | 0;
        cycles = 2;
        break;
      }

      case OP_STORE: {
        const imm = signExtend(((insn >> 20) & 0xFE0) | ((insn >> 7) & 0x1F), 12);
        const addr = ((this.x[rs1] + imm) >>> 0);
        const value = this.x[rs2];
        try {
          switch (funct3) {
            case 0: this.write8(addr, value & 0xFF); break;                // SB
            case 1: this.write16(addr, value & 0xFFFF); break;             // SH
            case 2: this.write32(addr, value); break;                       // SW
            default:
              this.trap(CAUSE_ILLEGAL_INSN, insn);
              return 1;
          }
        } catch (e) {
          this.trap(CAUSE_STORE_MISALIGNED, addr);
          return 1;
        }
        break;
      }

      case OP_IMM: {
        const imm = signExtend(insn >> 20, 12);
        const src = this.x[rs1];
        let result;
        switch (funct3) {
          case 0: result = (src + imm) | 0; break;                         // ADDI
          case 1: // SLLI
            if (funct7 & ~0x00) { /* allow shamt */ }
            result = (src << (imm & 0x1F)) | 0;
            break;
          case 2: result = (src < imm) ? 1 : 0; break;                    // SLTI
          case 3: result = ((src >>> 0) < (imm >>> 0)) ? 1 : 0; break;    // SLTIU
          case 4: result = (src ^ imm) | 0; break;                         // XORI
          case 5: // SRLI / SRAI
            if (funct7 === 0x20) {
              result = (src >> (imm & 0x1F)) | 0;   // SRAI
            } else {
              result = (src >>> (imm & 0x1F)) | 0;  // SRLI
            }
            break;
          case 6: result = (src | imm) | 0; break;                         // ORI
          case 7: result = (src & imm) | 0; break;                         // ANDI
          default:
            this.trap(CAUSE_ILLEGAL_INSN, insn);
            return 1;
        }
        if (rd) this.x[rd] = result;
        break;
      }

      case OP_REG: {
        const a = this.x[rs1];
        const b = this.x[rs2];
        let result;

        if (funct7 === 0x01) {
          // M extension
          result = this._executeMul(funct3, a, b);
          cycles = (funct3 >= 4) ? 8 : 3; // div/rem are slower
        } else {
          switch (funct3) {
            case 0: result = funct7 === 0x20 ? (a - b) | 0 : (a + b) | 0; break; // ADD/SUB
            case 1: result = (a << (b & 0x1F)) | 0; break;                         // SLL
            case 2: result = (a < b) ? 1 : 0; break;                               // SLT
            case 3: result = ((a >>> 0) < (b >>> 0)) ? 1 : 0; break;               // SLTU
            case 4: result = (a ^ b) | 0; break;                                    // XOR
            case 5: // SRL / SRA
              result = funct7 === 0x20 ? (a >> (b & 0x1F)) | 0 : (a >>> (b & 0x1F)) | 0;
              break;
            case 6: result = (a | b) | 0; break;                                    // OR
            case 7: result = (a & b) | 0; break;                                    // AND
            default:
              this.trap(CAUSE_ILLEGAL_INSN, insn);
              return 1;
          }
        }
        if (rd) this.x[rd] = result;
        break;
      }

      case OP_FENCE:
        // FENCE — treat as NOP in emulation
        break;

      case OP_SYSTEM: {
        const imm12 = (insn >>> 20) & 0xFFF;
        if (funct3 === 0) {
          // ECALL / EBREAK / MRET / WFI
          switch (imm12) {
            case 0x000: // ECALL
              this.trap(CAUSE_ECALL_M, 0);
              return 1;
            case 0x001: // EBREAK
              this.trap(CAUSE_BREAKPOINT, pc);
              return 1;
            case 0x302: // MRET
              this.mret();
              return 1;
            case 0x105: // WFI
              this.waiting = true;
              nextPC = pc + 4;
              break;
            default:
              // Unknown system instruction — treat as NOP
              break;
          }
        } else {
          // CSR instructions
          const csrAddr = imm12;
          const oldVal = this.readCSR(csrAddr);
          let newVal;
          switch (funct3) {
            case 1: // CSRRW
              newVal = this.x[rs1];
              this.writeCSR(csrAddr, newVal);
              if (rd) this.x[rd] = oldVal;
              break;
            case 2: // CSRRS
              if (rs1) this.writeCSR(csrAddr, oldVal | this.x[rs1]);
              if (rd) this.x[rd] = oldVal;
              break;
            case 3: // CSRRC
              if (rs1) this.writeCSR(csrAddr, oldVal & ~this.x[rs1]);
              if (rd) this.x[rd] = oldVal;
              break;
            case 5: // CSRRWI
              newVal = rs1; // rs1 field used as 5-bit immediate
              this.writeCSR(csrAddr, newVal);
              if (rd) this.x[rd] = oldVal;
              break;
            case 6: // CSRRSI
              if (rs1) this.writeCSR(csrAddr, oldVal | rs1);
              if (rd) this.x[rd] = oldVal;
              break;
            case 7: // CSRRCI
              if (rs1) this.writeCSR(csrAddr, oldVal & ~rs1);
              if (rd) this.x[rd] = oldVal;
              break;
            default:
              this.trap(CAUSE_ILLEGAL_INSN, insn);
              return 1;
          }
        }
        break;
      }

      case OP_AMO: {
        // Atomic Memory Operations (A extension — partial support for LR/SC)
        const funct5 = funct7 >> 2;
        const addr = (this.x[rs1]) >>> 0;

        if (funct5 === 0x02) {
          // LR.W (load reserved)
          const val = this.read32(addr);
          if (rd) this.x[rd] = val;
          this._reservation = addr;
          cycles = 2;
        } else if (funct5 === 0x03) {
          // SC.W (store conditional)
          if (this._reservation === addr) {
            this.write32(addr, this.x[rs2]);
            if (rd) this.x[rd] = 0; // success
          } else {
            if (rd) this.x[rd] = 1; // fail
          }
          this._reservation = -1;
          cycles = 2;
        } else if (funct5 === 0x01) {
          // AMOSWAP.W
          const old = this.read32(addr);
          this.write32(addr, this.x[rs2]);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x00) {
          // AMOADD.W
          const old = this.read32(addr);
          this.write32(addr, (old + this.x[rs2]) | 0);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x04) {
          // AMOXOR.W
          const old = this.read32(addr);
          this.write32(addr, old ^ this.x[rs2]);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x0C) {
          // AMOAND.W
          const old = this.read32(addr);
          this.write32(addr, old & this.x[rs2]);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x08) {
          // AMOOR.W
          const old = this.read32(addr);
          this.write32(addr, old | this.x[rs2]);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x10) {
          // AMOMIN.W
          const old = this.read32(addr);
          this.write32(addr, Math.min(old | 0, this.x[rs2] | 0) | 0);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x14) {
          // AMOMAX.W
          const old = this.read32(addr);
          this.write32(addr, Math.max(old | 0, this.x[rs2] | 0) | 0);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x18) {
          // AMOMINU.W
          const old = this.read32(addr);
          this.write32(addr, Math.min(old >>> 0, this.x[rs2] >>> 0) | 0);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else if (funct5 === 0x1C) {
          // AMOMAXU.W
          const old = this.read32(addr);
          this.write32(addr, Math.max(old >>> 0, this.x[rs2] >>> 0) | 0);
          if (rd) this.x[rd] = old;
          cycles = 3;
        } else {
          this.trap(CAUSE_ILLEGAL_INSN, insn);
          return 1;
        }
        break;
      }

      default:
        this.trap(CAUSE_ILLEGAL_INSN, insn);
        return 1;
    }

    this.x[0] = 0; // x0 is always zero
    this.pc = nextPC >>> 0;
    this._cycleCount += cycles;
    this._instretCount++;
    return cycles;
  }

  // ── M extension ──

  _executeMul(funct3, a, b) {
    switch (funct3) {
      case 0: { // MUL
        return Math.imul(a, b);
      }
      case 1: { // MULH (signed × signed, high 32 bits)
        const result = BigInt(a) * BigInt(b);
        return Number((result >> 32n) & 0xFFFFFFFFn) | 0;
      }
      case 2: { // MULHSU (signed × unsigned, high 32 bits)
        const result = BigInt(a) * BigInt(b >>> 0);
        return Number((result >> 32n) & 0xFFFFFFFFn) | 0;
      }
      case 3: { // MULHU (unsigned × unsigned, high 32 bits)
        const result = BigInt(a >>> 0) * BigInt(b >>> 0);
        return Number((result >> 32n) & 0xFFFFFFFFn) | 0;
      }
      case 4: { // DIV
        if (b === 0) return -1;
        if (a === (-2147483648 | 0) && b === -1) return a; // overflow
        return (a / b) | 0;
      }
      case 5: { // DIVU
        if (b === 0) return 0xFFFFFFFF | 0;
        return ((a >>> 0) / (b >>> 0)) | 0;
      }
      case 6: { // REM
        if (b === 0) return a;
        if (a === (-2147483648 | 0) && b === -1) return 0;
        return (a % b) | 0;
      }
      case 7: { // REMU
        if (b === 0) return a;
        return ((a >>> 0) % (b >>> 0)) | 0;
      }
    }
    return 0;
  }

  // ── C extension (compressed instructions) ──

  _executeCompressed(insn, pc) {
    const op = insn & 3;
    const funct3 = (insn >> 13) & 7;
    let nextPC = pc + 2;
    let cycles = 1;

    switch (op) {
      case 0: // Quadrant 0
        cycles = this._execC_Q0(insn, funct3, pc);
        if (cycles < 0) { nextPC = this.pc; cycles = -cycles; }
        else this.pc = nextPC;
        this.x[0] = 0;
        return cycles;
      case 1: // Quadrant 1
        cycles = this._execC_Q1(insn, funct3, pc);
        if (cycles < 0) { nextPC = this.pc; cycles = -cycles; }
        else this.pc = nextPC;
        this.x[0] = 0;
        return cycles;
      case 2: // Quadrant 2
        cycles = this._execC_Q2(insn, funct3, pc);
        if (cycles < 0) { nextPC = this.pc; cycles = -cycles; }
        else this.pc = nextPC;
        this.x[0] = 0;
        return cycles;
    }

    this.trap(CAUSE_ILLEGAL_INSN, insn);
    return 1;
  }

  /** Compressed Quadrant 0 */
  _execC_Q0(insn, funct3, pc) {
    const rd_p = ((insn >> 2) & 7) + 8;  // x8–x15
    const rs1_p = ((insn >> 7) & 7) + 8;

    switch (funct3) {
      case 0: { // C.ADDI4SPN
        // nzuimm[5:4] = insn[12:11], nzuimm[9:6] = insn[10:7],
        // nzuimm[2] = insn[6], nzuimm[3] = insn[5]
        const nz = ((insn >> 4) & 0x04) |   // insn[6] → nzuimm[2]
                   ((insn >> 2) & 0x08) |    // insn[5] → nzuimm[3]
                   ((insn >> 7) & 0x30) |    // insn[12:11] → nzuimm[5:4]
                   ((insn >> 1) & 0x3C0);    // insn[10:7] → nzuimm[9:6]
        if (nz === 0) { this.trap(CAUSE_ILLEGAL_INSN, insn); return 1; }
        this.x[rd_p] = (this.x[2] + nz) | 0; // sp + nzuimm
        return 1;
      }
      case 2: { // C.LW
        const off = ((insn >> 7) & 0x38) | ((insn >> 4) & 0x04) | ((insn << 1) & 0x40);
        // Proper: offset[5:3] = insn[12:10], offset[2] = insn[6], offset[6] = insn[5]
        const offset = ((insn >> 7) & 0x38) | ((insn >> 4) & 0x04) | ((insn << 1) & 0x40);
        const addr = ((this.x[rs1_p] + offset) >>> 0);
        this.x[rd_p] = this.read32(addr) | 0;
        return 2;
      }
      case 6: { // C.SW
        const offset = ((insn >> 7) & 0x38) | ((insn >> 4) & 0x04) | ((insn << 1) & 0x40);
        const addr = ((this.x[rs1_p] + offset) >>> 0);
        this.write32(addr, this.x[rd_p]);
        return 1;
      }
      default:
        this.trap(CAUSE_ILLEGAL_INSN, insn);
        return 1;
    }
  }

  /** Compressed Quadrant 1 */
  _execC_Q1(insn, funct3, pc) {
    switch (funct3) {
      case 0: { // C.NOP / C.ADDI
        const rd = (insn >> 7) & 0x1F;
        const imm = signExtend(((insn >> 7) & 0x20) | ((insn >> 2) & 0x1F), 6);
        if (rd) this.x[rd] = (this.x[rd] + imm) | 0;
        return 1;
      }
      case 1: { // C.JAL
        const imm = this._decodeCJImm(insn);
        this.x[1] = (pc + 2) | 0; // ra
        this.pc = (pc + imm) >>> 0;
        return -2; // negative = pc already set
      }
      case 2: { // C.LI
        const rd = (insn >> 7) & 0x1F;
        const imm = signExtend(((insn >> 7) & 0x20) | ((insn >> 2) & 0x1F), 6);
        if (rd) this.x[rd] = imm;
        return 1;
      }
      case 3: { // C.ADDI16SP / C.LUI
        const rd = (insn >> 7) & 0x1F;
        if (rd === 2) {
          // C.ADDI16SP
          const imm = signExtend(
            ((insn >> 3) & 0x200) | ((insn >> 2) & 0x10) |
            ((insn << 1) & 0x40) | ((insn << 4) & 0x180) |
            ((insn << 3) & 0x20), 10);
          if (imm === 0) { this.trap(CAUSE_ILLEGAL_INSN, insn); return 1; }
          this.x[2] = (this.x[2] + imm) | 0;
        } else if (rd) {
          // C.LUI
          const imm = signExtend(((insn >> 7) & 0x20) | ((insn >> 2) & 0x1F), 6);
          if (imm === 0) { this.trap(CAUSE_ILLEGAL_INSN, insn); return 1; }
          this.x[rd] = imm << 12;
        }
        return 1;
      }
      case 4: { // C.SRLI / C.SRAI / C.ANDI / C.SUB / C.XOR / C.OR / C.AND
        const rd_p = ((insn >> 7) & 7) + 8;
        const funct2 = (insn >> 10) & 3;
        switch (funct2) {
          case 0: { // C.SRLI
            const shamt = ((insn >> 7) & 0x20) | ((insn >> 2) & 0x1F);
            this.x[rd_p] = (this.x[rd_p] >>> shamt) | 0;
            return 1;
          }
          case 1: { // C.SRAI
            const shamt = ((insn >> 7) & 0x20) | ((insn >> 2) & 0x1F);
            this.x[rd_p] = (this.x[rd_p] >> shamt) | 0;
            return 1;
          }
          case 2: { // C.ANDI
            const imm = signExtend(((insn >> 7) & 0x20) | ((insn >> 2) & 0x1F), 6);
            this.x[rd_p] = (this.x[rd_p] & imm) | 0;
            return 1;
          }
          case 3: {
            const rs2_p = ((insn >> 2) & 7) + 8;
            const bit12 = (insn >> 12) & 1;
            const funct2b = (insn >> 5) & 3;
            if (bit12 === 0) {
              switch (funct2b) {
                case 0: this.x[rd_p] = (this.x[rd_p] - this.x[rs2_p]) | 0; break;   // C.SUB
                case 1: this.x[rd_p] = (this.x[rd_p] ^ this.x[rs2_p]) | 0; break;   // C.XOR
                case 2: this.x[rd_p] = (this.x[rd_p] | this.x[rs2_p]) | 0; break;   // C.OR
                case 3: this.x[rd_p] = (this.x[rd_p] & this.x[rs2_p]) | 0; break;   // C.AND
              }
            } else {
              // Reserved / C.SUBW etc (RV64 only) — illegal on RV32
              this.trap(CAUSE_ILLEGAL_INSN, insn);
              return 1;
            }
            return 1;
          }
        }
        return 1;
      }
      case 5: { // C.J
        const imm = this._decodeCJImm(insn);
        this.pc = (pc + imm) >>> 0;
        return -2;
      }
      case 6: { // C.BEQZ
        const rs1_p = ((insn >> 7) & 7) + 8;
        const off = this._decodeCBImm(insn);
        if (this.x[rs1_p] === 0) {
          this.pc = (pc + off) >>> 0;
          return -2;
        }
        return 1;
      }
      case 7: { // C.BNEZ
        const rs1_p = ((insn >> 7) & 7) + 8;
        const off = this._decodeCBImm(insn);
        if (this.x[rs1_p] !== 0) {
          this.pc = (pc + off) >>> 0;
          return -2;
        }
        return 1;
      }
    }
    this.trap(CAUSE_ILLEGAL_INSN, insn);
    return 1;
  }

  /** Compressed Quadrant 2 */
  _execC_Q2(insn, funct3, pc) {
    switch (funct3) {
      case 0: { // C.SLLI
        const rd = (insn >> 7) & 0x1F;
        const shamt = ((insn >> 7) & 0x20) | ((insn >> 2) & 0x1F);
        if (rd) this.x[rd] = (this.x[rd] << shamt) | 0;
        return 1;
      }
      case 2: { // C.LWSP
        const rd = (insn >> 7) & 0x1F;
        if (rd === 0) { this.trap(CAUSE_ILLEGAL_INSN, insn); return 1; }
        const offset = ((insn >> 7) & 0x20) | ((insn >> 2) & 0x1C) | ((insn << 4) & 0xC0);
        const addr = ((this.x[2] + offset) >>> 0);
        this.x[rd] = this.read32(addr) | 0;
        return 2;
      }
      case 4: {
        const bit12 = (insn >> 12) & 1;
        const rd = (insn >> 7) & 0x1F;
        const rs2 = (insn >> 2) & 0x1F;
        if (bit12 === 0) {
          if (rs2 === 0) {
            // C.JR
            if (rd === 0) { this.trap(CAUSE_ILLEGAL_INSN, insn); return 1; }
            this.pc = (this.x[rd] & ~1) >>> 0;
            return -2;
          } else {
            // C.MV
            if (rd) this.x[rd] = this.x[rs2];
            return 1;
          }
        } else {
          if (rs2 === 0) {
            if (rd === 0) {
              // C.EBREAK
              this.trap(CAUSE_BREAKPOINT, pc);
              return 1;
            } else {
              // C.JALR
              const t = this.pc;
              this.pc = (this.x[rd] & ~1) >>> 0;
              this.x[1] = (pc + 2) | 0;
              return -2;
            }
          } else {
            // C.ADD
            if (rd) this.x[rd] = (this.x[rd] + this.x[rs2]) | 0;
            return 1;
          }
        }
      }
      case 6: { // C.SWSP
        const rs2 = (insn >> 2) & 0x1F;
        const offset = ((insn >> 7) & 0x3C) | ((insn >> 1) & 0xC0);
        const addr = ((this.x[2] + offset) >>> 0);
        this.write32(addr, this.x[rs2]);
        return 1;
      }
      default:
        this.trap(CAUSE_ILLEGAL_INSN, insn);
        return 1;
    }
  }

  // ── Immediate decoders ──

  _decodeJImm(insn) {
    // J-type: imm[20|10:1|11|19:12]
    return signExtend(
      ((insn >> 11) & 0x100000) | // bit 31 → imm[20]
      (insn & 0xFF000) |          // bits 19:12
      ((insn >> 9) & 0x800) |     // bit 20 → imm[11]
      ((insn >> 20) & 0x7FE),     // bits 30:21 → imm[10:1]
      21
    );
  }

  _decodeBImm(insn) {
    // B-type: imm[12|10:5|4:1|11]
    return signExtend(
      ((insn >> 19) & 0x1000) |   // bit 31 → imm[12]
      ((insn << 4) & 0x800) |     // bit 7 → imm[11]
      ((insn >> 20) & 0x7E0) |    // bits 30:25 → imm[10:5]
      ((insn >> 7) & 0x1E),       // bits 11:8 → imm[4:1]
      13
    );
  }

  _decodeCJImm(insn) {
    // C.J/C.JAL: imm[11|4|9:8|10|6|7|3:1|5]
    return signExtend(
      ((insn >> 1) & 0x800) |     // bit 12 → imm[11]
      ((insn << 2) & 0x400) |     // bit 8 → imm[10]
      ((insn >> 1) & 0x300) |     // bits 10:9 → imm[9:8]
      ((insn << 1) & 0x80) |      // bit 6 → imm[7]
      ((insn >> 1) & 0x40) |      // bit 7 → imm[6]
      ((insn << 3) & 0x20) |      // bit 2 → imm[5]
      ((insn >> 7) & 0x10) |      // bit 11 → imm[4]
      ((insn >> 2) & 0x0E),       // bits 5:3 → imm[3:1]
      12
    );
  }

  _decodeCBImm(insn) {
    // C.BEQZ/C.BNEZ: offset[8|4:3|7:6|2:1|5]
    return signExtend(
      ((insn >> 4) & 0x100) |     // bit 12 → off[8]
      ((insn << 1) & 0xC0) |      // bits 6:5 → off[7:6]
      ((insn << 3) & 0x20) |      // bit 2 → off[5]
      ((insn >> 7) & 0x18) |      // bits 11:10 → off[4:3]
      ((insn >> 2) & 0x06),       // bits 4:3 → off[2:1]
      9
    );
  }
}
