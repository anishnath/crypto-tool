/**
 * UF2 Parser — decodes UF2 binary into a flash image for rp2040js.
 *
 * UF2 format (Microsoft):
 *   Each block is 512 bytes:
 *     0x00: magic0  (0x0A324655 "UF2\n")
 *     0x04: magic1  (0x9E5D5157)
 *     0x08: flags
 *     0x0C: targetAddr  (flash address)
 *     0x10: payloadSize (max 476 bytes, usually 256)
 *     0x14: blockNo
 *     0x18: numBlocks
 *     0x1C: familyID (0xE48BFF56 for RP2040)
 *     0x20: data[476]
 *     0x1FC: magicEnd (0x0AB16F30)
 *
 * RP2040 flash starts at 0x10000000 (XIP base).
 * We extract all data blocks and place them at (targetAddr - 0x10000000).
 */

const UF2_MAGIC0 = 0x0A324655;
const UF2_MAGIC1 = 0x9E5D5157;
const UF2_MAGIC_END = 0x0AB16F30;
const RP2040_FLASH_BASE = 0x10000000;
const BLOCK_SIZE = 512;

/**
 * Decode base64 UF2 string into a Uint8Array flash image.
 * @param {string} base64 - base64-encoded UF2 file
 * @returns {Uint8Array} flash image (offset from 0x10000000)
 */
export function uf2ToFlash(base64) {
  // Decode base64 to binary
  const raw = atob(base64);
  const bytes = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) {
    bytes[i] = raw.charCodeAt(i);
  }
  return uf2BytesToFlash(bytes);
}

/**
 * Decode UF2 Uint8Array into a flash image.
 * @param {Uint8Array} uf2 - raw UF2 file bytes
 * @returns {Uint8Array} flash image
 */
export function uf2BytesToFlash(uf2) {
  const view = new DataView(uf2.buffer, uf2.byteOffset, uf2.byteLength);
  const numBlocks = Math.floor(uf2.length / BLOCK_SIZE);

  /** Validate a single UF2 block. Returns true if valid and should be processed. */
  function isValidBlock(off) {
    const magic0 = view.getUint32(off + 0x00, true);
    const magic1 = view.getUint32(off + 0x04, true);
    const magicEnd = view.getUint32(off + 0x1FC, true);
    if (magic0 !== UF2_MAGIC0 || magic1 !== UF2_MAGIC1 || magicEnd !== UF2_MAGIC_END) return false;

    const flags = view.getUint32(off + 0x08, true);
    if (flags & 0x00000001) return false; // "not main flash" — skip

    // Check familyID if present
    if (flags & 0x00002000) {
      const familyID = view.getUint32(off + 0x1C, true);
      if (familyID !== 0xE48BFF56) return false; // not RP2040
    }
    return true;
  }

  // First pass: find max address to size the flash array
  let maxAddr = 0;
  for (let i = 0; i < numBlocks; i++) {
    const off = i * BLOCK_SIZE;
    if (!isValidBlock(off)) continue;

    const targetAddr = view.getUint32(off + 0x0C, true);
    const payloadSize = view.getUint32(off + 0x10, true);
    const flashOffset = targetAddr - RP2040_FLASH_BASE;
    if (flashOffset >= 0) {
      maxAddr = Math.max(maxAddr, flashOffset + payloadSize);
    }
  }

  // Allocate flash image
  const flash = new Uint8Array(maxAddr);

  // Second pass: copy data
  for (let i = 0; i < numBlocks; i++) {
    const off = i * BLOCK_SIZE;
    if (!isValidBlock(off)) continue;

    const targetAddr = view.getUint32(off + 0x0C, true);
    const payloadSize = view.getUint32(off + 0x10, true);
    const flashOffset = targetAddr - RP2040_FLASH_BASE;

    if (flashOffset >= 0 && payloadSize <= 476) {
      const data = uf2.subarray(off + 0x20, off + 0x20 + payloadSize);
      flash.set(data, flashOffset);
    }
  }

  return flash;
}
