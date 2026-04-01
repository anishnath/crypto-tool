/**
 * ESP-IDF Application Binary Parser
 *
 * Parses the .bin firmware image produced by arduino-cli for ESP32 targets.
 *
 * ESP-IDF app image format:
 *   - esp_image_header_t (24 bytes)
 *       magic: 0xE9
 *       segment_count: number of segments
 *       entry_addr: program entry point
 *       ...
 *   - For each segment:
 *       esp_image_segment_header_t (8 bytes): load_addr, data_len
 *       data[data_len]
 *   - Hash/checksum at end (ignored for emulation)
 *
 * Memory map (ESP32-C3):
 *   IRAM:  0x4037_C000 – 0x4038_0000  (16 KB, instruction RAM)
 *   DRAM:  0x3FC8_0000 – 0x3FCE_0000  (384 KB, data RAM)
 *   Flash: 0x4200_0000 – 0x427F_FFFF  (mapped, up to 8 MB)
 *   ROM:   0x4000_0000 – 0x4004_FFFF  (internal ROM)
 */

const ESP_IMAGE_MAGIC = 0xE9;

/**
 * Parsed firmware result.
 * @typedef {Object} ParsedFirmware
 * @property {number} entryAddr - Entry point address
 * @property {Array<{loadAddr: number, data: Uint8Array}>} segments - Memory segments
 * @property {number} chipId - Chip ID from header (ESP32-C3 = 5)
 */

/**
 * Decode base64 .bin string into parsed firmware.
 * @param {string} base64 - base64-encoded .bin file
 * @returns {ParsedFirmware}
 */
export function binToFirmware(base64) {
  const raw = atob(base64);
  const bytes = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) {
    bytes[i] = raw.charCodeAt(i);
  }
  return parseBin(bytes);
}

/**
 * Parse raw .bin Uint8Array into firmware segments.
 * @param {Uint8Array} bin - raw .bin file bytes
 * @returns {ParsedFirmware}
 */
export function parseBin(bin) {
  if (bin.length < 24) throw new Error('Binary too small for ESP image header');

  const view = new DataView(bin.buffer, bin.byteOffset, bin.byteLength);

  // esp_image_header_t (24 bytes)
  const magic = bin[0];
  if (magic !== ESP_IMAGE_MAGIC) {
    throw new Error(`Invalid ESP image magic: 0x${magic.toString(16)} (expected 0xE9)`);
  }

  const segmentCount = bin[1];
  // bytes 2: spi_mode, 3: spi_speed(lo)/spi_size(hi)
  const entryAddr = view.getUint32(4, true);
  // bytes 8-11: wp_pin, spi_pin_drv[3]
  // bytes 12-13: chip_id (ESP32=0, ESP32-S2=2, ESP32-C3=5, ESP32-S3=9)
  const chipId = view.getUint16(12, true);
  // bytes 14: min_chip_rev_old
  // bytes 15-22: reserved / min/max chip rev
  // byte 23: hash_appended

  const segments = [];
  let offset = 24; // after header

  for (let i = 0; i < segmentCount; i++) {
    if (offset + 8 > bin.length) {
      console.warn(`[bin-parser] Segment ${i}: header truncated at offset ${offset}`);
      break;
    }

    const loadAddr = view.getUint32(offset, true);
    const dataLen = view.getUint32(offset + 4, true);
    offset += 8;

    if (offset + dataLen > bin.length) {
      console.warn(`[bin-parser] Segment ${i}: data truncated (need ${dataLen}, have ${bin.length - offset})`);
      const available = bin.length - offset;
      segments.push({
        loadAddr,
        data: bin.slice(offset, offset + available),
      });
      offset += available;
      break;
    }

    segments.push({
      loadAddr,
      data: bin.slice(offset, offset + dataLen),
    });
    offset += dataLen;
  }

  return { entryAddr, segments, chipId };
}
