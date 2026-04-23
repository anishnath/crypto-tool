/**
 * Client-side "is this a circuit request?" guard.
 *
 * The AI generator now goes through the generic `/ai` proxy, which has no
 * domain knowledge.  The old `CFExamMarkerFunctionality.handleCircuitGenerate`
 * performed this validation server-side before forwarding — the client is
 * the only guard now, so the lists below mirror that Java source of truth.
 *
 *   Java source:  CFExamMarkerFunctionality.java:774–836
 *
 * Keep both sides in sync when adding components or patterns.
 */

export const MAX_CIRCUIT_DESC_LENGTH = 500;
export const MIN_CIRCUIT_DESC_LENGTH = 5;

// Mirror of Java CIRCUIT_KEYWORDS set.  At least one must appear in the
// lower-cased description for it to be accepted.
export const CIRCUIT_KEYWORDS = new Set([
    // ── Components ──
    'resistor', 'capacitor', 'inductor', 'diode', 'led', 'transistor', 'bjt', 'mosfet', 'jfet',
    'opamp', 'op-amp', 'op amp', 'amplifier', 'oscillator', 'timer', '555',
    'relay', 'fuse', 'lamp', 'bulb', 'switch', 'transformer', 'zener', 'darlington',
    'comparator', 'schmitt', 'counter', 'flip-flop', 'flipflop', 'latch', 'adder',
    'mux', 'multiplexer', 'demux', 'demultiplexer', 'shift register', 'gate', 'inverter',
    'potentiometer', 'pot', 'rheostat', 'varistor', 'thermistor', 'photoresistor', 'ldr',
    'photodiode', 'optocoupler', 'triac', 'scr', 'thyristor', 'diac', 'igbt',
    'crystal', 'quartz', 'piezo', 'solenoid', 'motor', 'speaker', 'buzzer', 'antenna',
    'battery', 'cell', 'power supply', 'regulator', 'converter',
    // ── Circuit types ──
    'circuit', 'filter', 'rectifier', 'divider', 'bridge',
    'oscilloscope', 'waveform', 'signal', 'generator', 'detector', 'demodulator',
    'attenuator', 'coupler', 'mixer', 'modulator',
    'low-pass', 'high-pass', 'band-pass', 'band-stop', 'notch', 'bandpass', 'lowpass', 'highpass',
    'half-wave', 'full-wave', 'clamp', 'clipper', 'clamper', 'doubler', 'tripler',
    'colpitts', 'hartley', 'wien', 'astable', 'monostable', 'bistable', 'multivibrator',
    'schmitt trigger', 'wheatstone', 'h-bridge', 'push-pull', 'cascode', 'emitter follower',
    'common emitter', 'common base', 'common collector', 'common source', 'common drain', 'common gate',
    'current mirror', 'differential', 'instrumentation', 'summing', 'integrator', 'differentiator',
    // ── Electrical terms ──
    'voltage', 'current', 'resistance', 'ohm', 'volt', 'amp', 'ampere', 'watt', 'farad', 'henry',
    'ac', 'dc', 'frequency', 'impedance', 'reactance', 'resonance', 'bandwidth', 'gain',
    'series', 'parallel', 'kirchhoff', 'kvl', 'kcl', 'thevenin', 'norton', 'superposition',
    'power', 'energy', 'charge', 'capacitance', 'inductance', 'conductance', 'admittance',
    'phase', 'phasor', 'decibel', 'bode', 'transfer function', 'cutoff', 'rolloff',
    'bias', 'quiescent', 'operating point', 'load line', 'saturation', 'cutoff region',
    'feedback', 'negative feedback', 'positive feedback', 'closed loop', 'open loop',
    'ground', 'node', 'mesh', 'loop', 'branch', 'terminal', 'pin', 'anode', 'cathode',
    'collector', 'emitter', 'base', 'drain', 'source',
    // ── Shorthand ──
    'nmos', 'pmos', 'cmos', 'npn', 'pnp', 'rlc', 'rc', 'rl', 'lc', 'cr',
    'adc', 'dac', 'pwm', 'vco', 'pll', 'ldo', 'smps', 'pcb', 'ttl', 'ecl',
    'and gate', 'or gate', 'nand gate', 'nor gate', 'xor gate', 'xnor gate', 'not gate',
    'sr latch', 'jk flip', 'd flip', 't flip',
    // ── Units ──
    'kohm', 'mohm', 'uf', 'nf', 'pf', 'mh', 'uh', 'khz', 'mhz', 'ghz',
    'milliamp', 'microamp', 'millivolt', 'microvolt', 'kilohm', 'megohm',
    // ── Actions ──
    'build', 'design', 'create', 'make', 'draw', 'simulate', 'wire', 'connect', 'solder',
]);

// Mirror of Java PROMPT_INJECTION_PATTERN (blocks jailbreak + off-topic prompts).
// Keeping one combined regex to match the Java single-compile behavior.
export const PROMPT_INJECTION_PATTERN = new RegExp(
    '(?:ignore|forget|disregard|override).*(?:instructions|prompt|rules|system)' +
    '|(?:write|generate|create).*(?:code|script|program|essay|story|poem)' +
    '|(?:tell|say|explain).*(?:joke|story|yourself|who are you)' +
    '|(?:pretend|act as|you are now|roleplay)' +
    '|(?:hack|exploit|inject|xss|sql|eval|exec)\\b' +
    '|\\b(?:password|credential|secret|api.?key|token)\\b',
    'i'
);

/**
 * Validate a user-supplied circuit description.
 * Returns null on success, or a user-facing error message string.
 *
 * @param {string} desc
 * @returns {string | null}
 */
export function validateCircuitInput(desc) {
    if (!desc || desc.length < MIN_CIRCUIT_DESC_LENGTH) {
        return 'Too short (min ' + MIN_CIRCUIT_DESC_LENGTH + ' chars)';
    }
    if (desc.length > MAX_CIRCUIT_DESC_LENGTH) {
        return 'Too long (max ' + MAX_CIRCUIT_DESC_LENGTH + ' chars)';
    }
    if (PROMPT_INJECTION_PATTERN.test(desc)) {
        return 'Please describe an electronic circuit';
    }
    const lower = desc.toLowerCase();
    let matched = false;
    for (const kw of CIRCUIT_KEYWORDS) {
        if (lower.includes(kw)) { matched = true; break; }
    }
    if (!matched) {
        return 'Please describe a circuit (e.g. "LED with 220 ohm resistor and 5V supply")';
    }
    return null;
}
