/**
 * Arduino Uno (ATmega328p) Pin Mapping
 *
 * Maps Arduino pin numbers to AVR port names and bit positions.
 *
 *   PORTD bits 0–7 → Arduino D0–D7
 *   PORTB bits 0–5 → Arduino D8–D13
 *   PORTC bits 0–5 → Arduino A0–A5 (digital 14–19)
 */

/** @type {Array<{port: string, bit: number}>} Index = Arduino pin number */
export const PIN_MAP = [
  /* D0  */ { port: 'portD', bit: 0 },
  /* D1  */ { port: 'portD', bit: 1 },
  /* D2  */ { port: 'portD', bit: 2 },
  /* D3  */ { port: 'portD', bit: 3 },
  /* D4  */ { port: 'portD', bit: 4 },
  /* D5  */ { port: 'portD', bit: 5 },
  /* D6  */ { port: 'portD', bit: 6 },
  /* D7  */ { port: 'portD', bit: 7 },
  /* D8  */ { port: 'portB', bit: 0 },
  /* D9  */ { port: 'portB', bit: 1 },
  /* D10 */ { port: 'portB', bit: 2 },
  /* D11 */ { port: 'portB', bit: 3 },
  /* D12 */ { port: 'portB', bit: 4 },
  /* D13 */ { port: 'portB', bit: 5 },
  /* A0  */ { port: 'portC', bit: 0 },
  /* A1  */ { port: 'portC', bit: 1 },
  /* A2  */ { port: 'portC', bit: 2 },
  /* A3  */ { port: 'portC', bit: 3 },
  /* A4  */ { port: 'portC', bit: 4 },
  /* A5  */ { port: 'portC', bit: 5 },
];

/** PWM-capable pins and their OCR register addresses (for analogWrite) */
export const PWM_PINS = [
  { pin: 6,  ocrAddr: 0x47, label: 'OCR0A' },  // Timer0A → D6
  { pin: 5,  ocrAddr: 0x48, label: 'OCR0B' },  // Timer0B → D5
  { pin: 9,  ocrAddr: 0x88, label: 'OCR1AL' }, // Timer1A → D9
  { pin: 10, ocrAddr: 0x8A, label: 'OCR1BL' }, // Timer1B → D10
  { pin: 11, ocrAddr: 0xB3, label: 'OCR2A' },  // Timer2A → D11
  { pin: 3,  ocrAddr: 0xB4, label: 'OCR2B' },  // Timer2B → D3
];

/** Set of PWM-capable pin numbers for quick lookup */
export const PWM_PIN_SET = new Set(PWM_PINS.map(p => p.pin));

/** Arduino analog pin A0–A5 → ADC channel mapping */
export const ANALOG_PINS = {
  A0: 0, A1: 1, A2: 2, A3: 3, A4: 4, A5: 5,
  14: 0, 15: 1, 16: 2, 17: 3, 18: 4, 19: 5,
};
