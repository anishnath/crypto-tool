/**
 * Intel HEX Format Parser
 *
 * Converts Intel HEX string to Uint16Array suitable for avr8js CPU.progMem.
 *
 * Intel HEX line format:  :LLAAAATT[DD...]CC
 *   LL   = byte count
 *   AAAA = 16-bit address
 *   TT   = record type (00=data, 01=EOF)
 *   DD   = data bytes
 *   CC   = checksum (two's complement of sum of all preceding bytes)
 */

/**
 * Parse Intel HEX string into a raw Uint8Array of program bytes.
 * @param {string} hex - Intel HEX content
 * @returns {Uint8Array}
 */
export function hexToBytes(hex) {
  const lines = hex.split('\n');
  const records = [];
  let maxAddr = 0;

  for (const raw of lines) {
    const line = raw.trim();
    if (!line.startsWith(':')) continue;

    const h = line.substring(1);
    const byteCount = parseInt(h.substring(0, 2), 16);
    const address   = parseInt(h.substring(2, 6), 16);
    const type      = parseInt(h.substring(6, 8), 16);

    if (type === 0x00) {
      const data = [];
      for (let i = 0; i < byteCount; i++) {
        data.push(parseInt(h.substring(8 + i * 2, 10 + i * 2), 16));
      }
      records.push({ address, data });
      maxAddr = Math.max(maxAddr, address + byteCount);
    } else if (type === 0x01) {
      break; // EOF
    }
  }

  const bytes = new Uint8Array(maxAddr);
  for (const r of records) {
    for (let i = 0; i < r.data.length; i++) {
      bytes[r.address + i] = r.data[i];
    }
  }
  return bytes;
}

/**
 * Parse Intel HEX string into Uint16Array for avr8js CPU.progMem.
 * AVR uses 16-bit little-endian words for program memory.
 * @param {string} hex - Intel HEX content
 * @returns {Uint16Array}
 */
export function hexToProgMem(hex) {
  const bytes = hexToBytes(hex);
  const words = new Uint16Array(Math.ceil(bytes.length / 2));
  for (let i = 0; i < bytes.length; i += 2) {
    words[i >> 1] = (bytes[i] || 0) | ((bytes[i + 1] || 0) << 8);
  }
  return words;
}
