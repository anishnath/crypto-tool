// Piano Chord Finder - 8gwifi.org
// Comprehensive piano chord library with Tone.js audio

// ============================================
// PIANO CHORD DATABASE
// Notes: C, C#, D, D#, E, F, F#, G, G#, A, A#, B
// Each chord contains: notes array, fingering (LH/RH), inversions
// ============================================

const PIANO_CHORD_DATABASE = {
  // ============================================
  // MAJOR CHORDS
  // ============================================
  'C': {
    name: 'C Major',
    notes: ['C4', 'E4', 'G4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'C#': {
    name: 'C# Major',
    notes: ['C#4', 'E#4', 'G#4'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'Db': {
    name: 'Db Major',
    notes: ['Db4', 'F4', 'Ab4'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'D': {
    name: 'D Major',
    notes: ['D4', 'F#4', 'A4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'Eb': {
    name: 'Eb Major',
    notes: ['Eb4', 'G4', 'Bb4'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'E': {
    name: 'E Major',
    notes: ['E4', 'G#4', 'B4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'F': {
    name: 'F Major',
    notes: ['F4', 'A4', 'C5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'F#': {
    name: 'F# Major',
    notes: ['F#4', 'A#4', 'C#5'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'Gb': {
    name: 'Gb Major',
    notes: ['Gb4', 'Bb4', 'Db5'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'G': {
    name: 'G Major',
    notes: ['G4', 'B4', 'D5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'Ab': {
    name: 'Ab Major',
    notes: ['Ab4', 'C5', 'Eb5'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'A': {
    name: 'A Major',
    notes: ['A4', 'C#5', 'E5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'Bb': {
    name: 'Bb Major',
    notes: ['Bb4', 'D5', 'F5'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },
  'B': {
    name: 'B Major',
    notes: ['B4', 'D#5', 'F#5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - P5',
    category: 'major'
  },

  // ============================================
  // MINOR CHORDS
  // ============================================
  'Cm': {
    name: 'C Minor',
    notes: ['C4', 'Eb4', 'G4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'C#m': {
    name: 'C# Minor',
    notes: ['C#4', 'E4', 'G#4'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Dm': {
    name: 'D Minor',
    notes: ['D4', 'F4', 'A4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'D#m': {
    name: 'D# Minor',
    notes: ['D#4', 'F#4', 'A#4'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Ebm': {
    name: 'Eb Minor',
    notes: ['Eb4', 'Gb4', 'Bb4'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Em': {
    name: 'E Minor',
    notes: ['E4', 'G4', 'B4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Fm': {
    name: 'F Minor',
    notes: ['F4', 'Ab4', 'C5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'F#m': {
    name: 'F# Minor',
    notes: ['F#4', 'A4', 'C#5'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Gm': {
    name: 'G Minor',
    notes: ['G4', 'Bb4', 'D5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'G#m': {
    name: 'G# Minor',
    notes: ['G#4', 'B4', 'D#5'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Am': {
    name: 'A Minor',
    notes: ['A4', 'C5', 'E5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Bbm': {
    name: 'Bb Minor',
    notes: ['Bb4', 'Db5', 'F5'],
    fingering: { rh: [2, 3, 5], lh: [5, 3, 2] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },
  'Bm': {
    name: 'B Minor',
    notes: ['B4', 'D5', 'F#5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - P5',
    category: 'minor'
  },

  // ============================================
  // DOMINANT 7TH CHORDS
  // ============================================
  'C7': {
    name: 'C Dominant 7th',
    notes: ['C4', 'E4', 'G4', 'Bb4'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'D7': {
    name: 'D Dominant 7th',
    notes: ['D4', 'F#4', 'A4', 'C5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'E7': {
    name: 'E Dominant 7th',
    notes: ['E4', 'G#4', 'B4', 'D5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'F7': {
    name: 'F Dominant 7th',
    notes: ['F4', 'A4', 'C5', 'Eb5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'G7': {
    name: 'G Dominant 7th',
    notes: ['G4', 'B4', 'D5', 'F5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'A7': {
    name: 'A Dominant 7th',
    notes: ['A4', 'C#5', 'E5', 'G5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'B7': {
    name: 'B Dominant 7th',
    notes: ['B4', 'D#5', 'F#5', 'A5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'Bb7': {
    name: 'Bb Dominant 7th',
    notes: ['Bb4', 'D5', 'F5', 'Ab5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'Eb7': {
    name: 'Eb Dominant 7th',
    notes: ['Eb4', 'G4', 'Bb4', 'Db5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },
  'Ab7': {
    name: 'Ab Dominant 7th',
    notes: ['Ab4', 'C5', 'Eb5', 'Gb5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - M3 - P5 - m7',
    category: '7th'
  },

  // ============================================
  // MAJOR 7TH CHORDS
  // ============================================
  'Cmaj7': {
    name: 'C Major 7th',
    notes: ['C4', 'E4', 'G4', 'B4'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Dmaj7': {
    name: 'D Major 7th',
    notes: ['D4', 'F#4', 'A4', 'C#5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Emaj7': {
    name: 'E Major 7th',
    notes: ['E4', 'G#4', 'B4', 'D#5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Fmaj7': {
    name: 'F Major 7th',
    notes: ['F4', 'A4', 'C5', 'E5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Gmaj7': {
    name: 'G Major 7th',
    notes: ['G4', 'B4', 'D5', 'F#5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Amaj7': {
    name: 'A Major 7th',
    notes: ['A4', 'C#5', 'E5', 'G#5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Bmaj7': {
    name: 'B Major 7th',
    notes: ['B4', 'D#5', 'F#5', 'A#5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Bbmaj7': {
    name: 'Bb Major 7th',
    notes: ['Bb4', 'D5', 'F5', 'A5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Ebmaj7': {
    name: 'Eb Major 7th',
    notes: ['Eb4', 'G4', 'Bb4', 'D5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },
  'Abmaj7': {
    name: 'Ab Major 7th',
    notes: ['Ab4', 'C5', 'Eb5', 'G5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - M3 - P5 - M7',
    category: 'maj7'
  },

  // ============================================
  // MINOR 7TH CHORDS
  // ============================================
  'Cm7': {
    name: 'C Minor 7th',
    notes: ['C4', 'Eb4', 'G4', 'Bb4'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'Dm7': {
    name: 'D Minor 7th',
    notes: ['D4', 'F4', 'A4', 'C5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'Em7': {
    name: 'E Minor 7th',
    notes: ['E4', 'G4', 'B4', 'D5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'Fm7': {
    name: 'F Minor 7th',
    notes: ['F4', 'Ab4', 'C5', 'Eb5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'Gm7': {
    name: 'G Minor 7th',
    notes: ['G4', 'Bb4', 'D5', 'F5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'Am7': {
    name: 'A Minor 7th',
    notes: ['A4', 'C5', 'E5', 'G5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'Bm7': {
    name: 'B Minor 7th',
    notes: ['B4', 'D5', 'F#5', 'A5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'Bbm7': {
    name: 'Bb Minor 7th',
    notes: ['Bb4', 'Db5', 'F5', 'Ab5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'F#m7': {
    name: 'F# Minor 7th',
    notes: ['F#4', 'A4', 'C#5', 'E5'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },
  'C#m7': {
    name: 'C# Minor 7th',
    notes: ['C#4', 'E4', 'G#4', 'B4'],
    fingering: { rh: [2, 3, 4, 5], lh: [5, 4, 2, 1] },
    intervals: 'R - m3 - P5 - m7',
    category: 'm7'
  },

  // ============================================
  // DIMINISHED CHORDS
  // ============================================
  'Cdim': {
    name: 'C Diminished',
    notes: ['C4', 'Eb4', 'Gb4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - d5',
    category: 'dim'
  },
  'Ddim': {
    name: 'D Diminished',
    notes: ['D4', 'F4', 'Ab4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - d5',
    category: 'dim'
  },
  'Edim': {
    name: 'E Diminished',
    notes: ['E4', 'G4', 'Bb4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - d5',
    category: 'dim'
  },
  'Fdim': {
    name: 'F Diminished',
    notes: ['F4', 'Ab4', 'Cb5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - d5',
    category: 'dim'
  },
  'Gdim': {
    name: 'G Diminished',
    notes: ['G4', 'Bb4', 'Db5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - d5',
    category: 'dim'
  },
  'Adim': {
    name: 'A Diminished',
    notes: ['A4', 'C5', 'Eb5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - d5',
    category: 'dim'
  },
  'Bdim': {
    name: 'B Diminished',
    notes: ['B4', 'D5', 'F5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - m3 - d5',
    category: 'dim'
  },

  // ============================================
  // AUGMENTED CHORDS
  // ============================================
  'Caug': {
    name: 'C Augmented',
    notes: ['C4', 'E4', 'G#4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - A5',
    category: 'aug'
  },
  'Daug': {
    name: 'D Augmented',
    notes: ['D4', 'F#4', 'A#4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - A5',
    category: 'aug'
  },
  'Eaug': {
    name: 'E Augmented',
    notes: ['E4', 'G#4', 'B#4'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - A5',
    category: 'aug'
  },
  'Faug': {
    name: 'F Augmented',
    notes: ['F4', 'A4', 'C#5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - A5',
    category: 'aug'
  },
  'Gaug': {
    name: 'G Augmented',
    notes: ['G4', 'B4', 'D#5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - A5',
    category: 'aug'
  },
  'Aaug': {
    name: 'A Augmented',
    notes: ['A4', 'C#5', 'E#5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - A5',
    category: 'aug'
  },
  'Baug': {
    name: 'B Augmented',
    notes: ['B4', 'D#5', 'F##5'],
    fingering: { rh: [1, 3, 5], lh: [5, 3, 1] },
    intervals: 'R - M3 - A5',
    category: 'aug'
  },

  // ============================================
  // SUSPENDED CHORDS
  // ============================================
  'Csus2': {
    name: 'C Suspended 2nd',
    notes: ['C4', 'D4', 'G4'],
    fingering: { rh: [1, 2, 5], lh: [5, 4, 1] },
    intervals: 'R - M2 - P5',
    category: 'sus'
  },
  'Csus4': {
    name: 'C Suspended 4th',
    notes: ['C4', 'F4', 'G4'],
    fingering: { rh: [1, 3, 5], lh: [5, 2, 1] },
    intervals: 'R - P4 - P5',
    category: 'sus'
  },
  'Dsus2': {
    name: 'D Suspended 2nd',
    notes: ['D4', 'E4', 'A4'],
    fingering: { rh: [1, 2, 5], lh: [5, 4, 1] },
    intervals: 'R - M2 - P5',
    category: 'sus'
  },
  'Dsus4': {
    name: 'D Suspended 4th',
    notes: ['D4', 'G4', 'A4'],
    fingering: { rh: [1, 3, 5], lh: [5, 2, 1] },
    intervals: 'R - P4 - P5',
    category: 'sus'
  },
  'Esus4': {
    name: 'E Suspended 4th',
    notes: ['E4', 'A4', 'B4'],
    fingering: { rh: [1, 3, 5], lh: [5, 2, 1] },
    intervals: 'R - P4 - P5',
    category: 'sus'
  },
  'Fsus2': {
    name: 'F Suspended 2nd',
    notes: ['F4', 'G4', 'C5'],
    fingering: { rh: [1, 2, 5], lh: [5, 4, 1] },
    intervals: 'R - M2 - P5',
    category: 'sus'
  },
  'Gsus2': {
    name: 'G Suspended 2nd',
    notes: ['G4', 'A4', 'D5'],
    fingering: { rh: [1, 2, 5], lh: [5, 4, 1] },
    intervals: 'R - M2 - P5',
    category: 'sus'
  },
  'Gsus4': {
    name: 'G Suspended 4th',
    notes: ['G4', 'C5', 'D5'],
    fingering: { rh: [1, 3, 5], lh: [5, 2, 1] },
    intervals: 'R - P4 - P5',
    category: 'sus'
  },
  'Asus2': {
    name: 'A Suspended 2nd',
    notes: ['A4', 'B4', 'E5'],
    fingering: { rh: [1, 2, 5], lh: [5, 4, 1] },
    intervals: 'R - M2 - P5',
    category: 'sus'
  },
  'Asus4': {
    name: 'A Suspended 4th',
    notes: ['A4', 'D5', 'E5'],
    fingering: { rh: [1, 3, 5], lh: [5, 2, 1] },
    intervals: 'R - P4 - P5',
    category: 'sus'
  },

  // ============================================
  // ADD9 CHORDS
  // ============================================
  'Cadd9': {
    name: 'C Add 9',
    notes: ['C4', 'E4', 'G4', 'D5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M9',
    category: 'add'
  },
  'Dadd9': {
    name: 'D Add 9',
    notes: ['D4', 'F#4', 'A4', 'E5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M9',
    category: 'add'
  },
  'Eadd9': {
    name: 'E Add 9',
    notes: ['E4', 'G#4', 'B4', 'F#5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M9',
    category: 'add'
  },
  'Fadd9': {
    name: 'F Add 9',
    notes: ['F4', 'A4', 'C5', 'G5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M9',
    category: 'add'
  },
  'Gadd9': {
    name: 'G Add 9',
    notes: ['G4', 'B4', 'D5', 'A5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M9',
    category: 'add'
  },
  'Aadd9': {
    name: 'A Add 9',
    notes: ['A4', 'C#5', 'E5', 'B5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - M3 - P5 - M9',
    category: 'add'
  },

  // ============================================
  // DIMINISHED 7TH CHORDS
  // ============================================
  'Cdim7': {
    name: 'C Diminished 7th',
    notes: ['C4', 'Eb4', 'Gb4', 'Bbb4'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - d7',
    category: 'dim7'
  },
  'Ddim7': {
    name: 'D Diminished 7th',
    notes: ['D4', 'F4', 'Ab4', 'Cb5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - d7',
    category: 'dim7'
  },
  'Edim7': {
    name: 'E Diminished 7th',
    notes: ['E4', 'G4', 'Bb4', 'Db5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - d7',
    category: 'dim7'
  },

  // ============================================
  // HALF-DIMINISHED (m7b5) CHORDS
  // ============================================
  'Cm7b5': {
    name: 'C Half-Diminished',
    notes: ['C4', 'Eb4', 'Gb4', 'Bb4'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - m7',
    category: 'm7b5'
  },
  'Dm7b5': {
    name: 'D Half-Diminished',
    notes: ['D4', 'F4', 'Ab4', 'C5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - m7',
    category: 'm7b5'
  },
  'Em7b5': {
    name: 'E Half-Diminished',
    notes: ['E4', 'G4', 'Bb4', 'D5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - m7',
    category: 'm7b5'
  },
  'Fm7b5': {
    name: 'F Half-Diminished',
    notes: ['F4', 'Ab4', 'Cb5', 'Eb5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - m7',
    category: 'm7b5'
  },
  'Gm7b5': {
    name: 'G Half-Diminished',
    notes: ['G4', 'Bb4', 'Db5', 'F5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - m7',
    category: 'm7b5'
  },
  'Am7b5': {
    name: 'A Half-Diminished',
    notes: ['A4', 'C5', 'Eb5', 'G5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - m7',
    category: 'm7b5'
  },
  'Bm7b5': {
    name: 'B Half-Diminished',
    notes: ['B4', 'D5', 'F5', 'A5'],
    fingering: { rh: [1, 2, 3, 5], lh: [5, 3, 2, 1] },
    intervals: 'R - m3 - d5 - m7',
    category: 'm7b5'
  }
};

// ============================================
// CHORD PROGRESSIONS FOR PIANO
// ============================================
const PIANO_PROGRESSIONS = [
  {
    name: 'Hotel California',
    numerals: ['i', 'VII', 'VI', 'V', 'VI', 'V'],
    description: 'The legendary Eagles chord progression',
    songs: ['Hotel California'],
    genre: 'Classic Rock'
  },
  {
    name: 'Creep / Radiohead',
    numerals: ['I', 'III', 'IV', 'iv'],
    description: 'Distinctive major-to-minor shift',
    songs: ['Creep', 'Get Free', 'Space Oddity'],
    genre: 'Alternative'
  },
  {
    name: 'Don\'t Stop Believin\'',
    numerals: ['I', 'V', 'vi', 'IV', 'I', 'V', 'iii', 'IV'],
    description: 'Journey\'s massive arena rock anthem',
    songs: ['Don\'t Stop Believin\'', 'So Lonely'],
    genre: 'Rock'
  },
  {
    name: 'Imagine / Let It Be',
    numerals: ['I', 'V', 'vi', 'IV'],
    description: 'The "Axis of Awesome" 4-chord progression',
    songs: ['Imagine', 'Let It Be', 'No Woman No Cry', 'Someone Like You'],
    genre: 'Pop/Piano'
  },
  {
    name: 'Hallelujah',
    numerals: ['I', 'vi', 'I', 'vi', 'IV', 'V', 'I', 'V'],
    description: 'Leonard Cohen\'s spiritual masterpiece',
    songs: ['Hallelujah'],
    genre: 'Folk/Gospel'
  },
  {
    name: 'Zombie / Cranberries',
    numerals: ['vi', 'IV', 'I', 'V'], // Em C G D
    description: 'Powerful 90s grunge progression',
    songs: ['Zombie'],
    genre: 'Rock'
  },
  {
    name: 'Wonderwall',
    numerals: ['vi', 'VII', 'i', 'VII'], // Capo 2 Em7 G Dsus4 A7sus4 roughly
    description: 'The quintessential 90s acoustic song',
    songs: ['Wonderwall', 'Boulevard of Broken Dreams'],
    genre: 'Britpop'
  },
  {
    name: 'Country Roads',
    numerals: ['I', 'V', 'vi', 'IV', 'I', 'V', 'IV', 'I'],
    description: 'John Denver\'s folk classic',
    songs: ['Country Roads'],
    genre: 'Country/Folk'
  },
  {
    name: 'Wicked Game',
    numerals: ['ii', 'I', 'ii', 'I'], // Bm A E (actually ii I V) -> Bm A E
    description: 'Hauntingly beautiful 3-chord loop',
    songs: ['Wicked Game'],
    genre: 'Ballad'
  },
  {
    name: 'Every Breath You Take',
    numerals: ['I', 'vi', 'IV', 'V'],
    description: 'The 50s progression (Doo-wop)',
    songs: ['Every Breath You Take', 'Stand By Me', 'Beautiful Girls'],
    genre: 'Pop/Rock'
  },
  {
    name: 'Hey Jude',
    numerals: ['I', 'V', 'V7', 'I', 'IV', 'I'],
    description: 'The Beatles classic ending',
    songs: ['Hey Jude'],
    genre: 'Classic Rock'
  },
  {
    name: 'House of Rising Sun',
    numerals: ['i', 'III', 'IV', 'VI', 'i', 'V', 'i'],
    description: 'Animals\' folk rock standard',
    songs: ['House of the Rising Sun'],
    genre: 'Folk Rock'
  },
  {
    name: 'Guitar Gently Weeps',
    numerals: ['i', 'VII', 'VI', 'V'], // Am G F E
    description: 'Andalusian cadence (Beatles)',
    songs: ['While My Guitar Gently Weeps', 'Sultans of Swing'],
    genre: 'Rock'
  },
  {
    name: 'Jazz ii-V-I',
    numerals: ['ii7', 'V7', 'Imaj7'],
    description: 'The foundation of all Jazz standards',
    songs: ['Autumn Leaves', 'Fly Me To The Moon'],
    genre: 'Jazz'
  }
];

// Keys database for progressions
const PIANO_KEYS = {
  'C': { I: 'C', ii: 'Dm', iii: 'Em', IV: 'F', V: 'G', vi: 'Am', vii: 'Bdim', 'Imaj7': 'Cmaj7', 'ii7': 'Dm7', 'V7': 'G7', 'I7': 'C7', 'IV7': 'F7', i: 'Cm', VII: 'Bb', VI: 'Ab', 'IVmaj7': 'Fmaj7', III: 'E', iv: 'Fm' },
  'G': { I: 'G', ii: 'Am', iii: 'Bm', IV: 'C', V: 'D', vi: 'Em', vii: 'F#dim', 'Imaj7': 'Gmaj7', 'ii7': 'Am7', 'V7': 'D7', 'I7': 'G7', 'IV7': 'C7', i: 'Gm', VII: 'F', VI: 'Eb', 'IVmaj7': 'Cmaj7', III: 'B', iv: 'Cm' },
  'D': { I: 'D', ii: 'Em', iii: 'F#m', IV: 'G', V: 'A', vi: 'Bm', vii: 'C#dim', 'Imaj7': 'Dmaj7', 'ii7': 'Em7', 'V7': 'A7', 'I7': 'D7', 'IV7': 'G7', i: 'Dm', VII: 'C', VI: 'Bb', 'IVmaj7': 'Gmaj7', III: 'F#', iv: 'Gm' },
  'A': { I: 'A', ii: 'Bm', iii: 'C#m', IV: 'D', V: 'E', vi: 'F#m', vii: 'G#dim', 'Imaj7': 'Amaj7', 'ii7': 'Bm7', 'V7': 'E7', 'I7': 'A7', 'IV7': 'D7', i: 'Am', VII: 'G', VI: 'F', 'IVmaj7': 'Dmaj7', III: 'C#', iv: 'Dm' },
  'E': { I: 'E', ii: 'F#m', iii: 'G#m', IV: 'A', V: 'B', vi: 'C#m', vii: 'D#dim', 'Imaj7': 'Emaj7', 'ii7': 'F#m7', 'V7': 'B7', 'I7': 'E7', 'IV7': 'A7', i: 'Em', VII: 'D', VI: 'C', 'IVmaj7': 'Amaj7', III: 'G#', iv: 'Am' },
  'F': { I: 'F', ii: 'Gm', iii: 'Am', IV: 'Bb', V: 'C', vi: 'Dm', vii: 'Edim', 'Imaj7': 'Fmaj7', 'ii7': 'Gm7', 'V7': 'C7', 'I7': 'F7', 'IV7': 'Bb7', i: 'Fm', VII: 'Eb', VI: 'Db', 'IVmaj7': 'Bbmaj7', III: 'A', iv: 'Bbm' },
  'Bb': { I: 'Bb', ii: 'Cm', iii: 'Dm', IV: 'Eb', V: 'F', vi: 'Gm', vii: 'Adim', 'Imaj7': 'Bbmaj7', 'ii7': 'Cm7', 'V7': 'F7', 'I7': 'Bb7', 'IV7': 'Eb7', i: 'Bbm', VII: 'Ab', VI: 'Gb', 'IVmaj7': 'Ebmaj7', III: 'D', iv: 'Ebm' },
  'Eb': { I: 'Eb', ii: 'Fm', iii: 'Gm', IV: 'Ab', V: 'Bb', vi: 'Cm', vii: 'Ddim', 'Imaj7': 'Ebmaj7', 'ii7': 'Fm7', 'V7': 'Bb7', 'I7': 'Eb7', 'IV7': 'Ab7', i: 'Ebm', VII: 'Db', VI: 'Cb', 'IVmaj7': 'Abmaj7', III: 'G', iv: 'Abm' }
};

// Difficulty ratings
const PIANO_DIFFICULTY = {
  // Beginner
  'C': 'beginner', 'G': 'beginner', 'F': 'beginner', 'Am': 'beginner', 'Dm': 'beginner', 'Em': 'beginner',
  'C7': 'beginner', 'G7': 'beginner', 'D7': 'beginner',
  // Intermediate
  'D': 'intermediate', 'A': 'intermediate', 'E': 'intermediate', 'Bb': 'intermediate', 'Eb': 'intermediate',
  'Fm': 'intermediate', 'Gm': 'intermediate', 'Bm': 'intermediate', 'Cm': 'intermediate',
  'Cmaj7': 'intermediate', 'Fmaj7': 'intermediate', 'Gmaj7': 'intermediate',
  'Dm7': 'intermediate', 'Am7': 'intermediate', 'Em7': 'intermediate',
  'Csus2': 'intermediate', 'Csus4': 'intermediate', 'Dsus2': 'intermediate', 'Dsus4': 'intermediate',
  'Cadd9': 'intermediate', 'Gadd9': 'intermediate',
  // Advanced
  'C#': 'advanced', 'F#': 'advanced', 'Db': 'advanced', 'Gb': 'advanced', 'Ab': 'advanced',
  'C#m': 'advanced', 'F#m': 'advanced', 'G#m': 'advanced', 'Bbm': 'advanced', 'Ebm': 'advanced',
  'Cdim': 'advanced', 'Ddim': 'advanced', 'Edim': 'advanced',
  'Caug': 'advanced', 'Daug': 'advanced',
  'Cdim7': 'advanced', 'Ddim7': 'advanced', 'Edim7': 'advanced',
  'Cm7b5': 'advanced', 'Dm7b5': 'advanced', 'Em7b5': 'advanced'
};

// ============================================
// GLOBAL STATE
// ============================================
let currentPianoChord = null;
let pianoSynth = null;
let toneReady = false;
let arpeggioMode = false;
let soundEnabled = true;
let currentInversion = 0;
let selectedHand = 'rh'; // 'rh' or 'lh'
let currentKey = 'C';

// Playback tracking - to cancel ongoing sequences
let activePlaybackId = 0;
let playbackTimeouts = [];

// ============================================
// TONE.JS INITIALIZATION
// ============================================
async function initPianoSynth() {
  if (toneReady) return true;

  if (typeof Tone === 'undefined') {
    console.log('Tone.js not loaded');
    return false;
  }

  try {
    await Tone.start();
    console.log('Tone.js audio started');

    // Create a polyphonic synth that sounds like a piano
    pianoSynth = new Tone.PolySynth(Tone.Synth, {
      oscillator: {
        type: 'triangle8'  // Rich harmonics like piano
      },
      envelope: {
        attack: 0.005,
        decay: 0.2,
        sustain: 0.3,
        release: 0.8  // Shorter release for better polyphony
      }
    }).toDestination();

    // Set polyphony limit
    pianoSynth.maxPolyphony = 32;

    // Add reverb for concert hall feel
    const reverb = new Tone.Reverb({
      decay: 1.5,
      wet: 0.2
    }).toDestination();

    pianoSynth.connect(reverb);
    pianoSynth.volume.value = -6;

    toneReady = true;
    console.log('Piano synth initialized');

    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('Piano audio ready!', 2000, 'success');
    }

    return true;
  } catch (error) {
    console.error('Failed to init piano synth:', error);
    return false;
  }
}

// ============================================
// PIANO KEYBOARD RENDERING
// ============================================
function renderPianoKeyboard() {
  const container = document.getElementById('pianoKeyboard');
  if (!container) return;

  const whiteKeyWidth = 40;
  const blackKeyWidth = 28;
  const whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  const blackKeyPositions = { 'C': 0.65, 'D': 1.65, 'F': 3.65, 'G': 4.65, 'A': 5.65 }; // Position relative to white key index

  let html = '<div class="piano-keys">';

  // Generate 3 octaves (C3 to B5)
  for (let octave = 3; octave <= 5; octave++) {
    whiteKeys.forEach((note, index) => {
      const noteId = `${note}${octave}`;
      const label = octave === 4 ? note : `${note}${octave}`;
      html += `<div class="piano-key white-key" data-note="${noteId}" onclick="playNote('${noteId}')">
        <span class="key-label">${label}</span>
      </div>`;
    });
  }

  html += '</div>';

  // Black keys overlay with calculated positions
  html += '<div class="black-keys-container">';
  for (let octave = 3; octave <= 5; octave++) {
    const octaveOffset = (octave - 3) * 7 * whiteKeyWidth;
    Object.entries(blackKeyPositions).forEach(([whiteName, relPos]) => {
      const blackNote = `${whiteName}#${octave}`;
      const leftPos = octaveOffset + (relPos * whiteKeyWidth) - (blackKeyWidth / 2);
      html += `<div class="piano-key black-key" data-note="${blackNote}" style="left: ${leftPos}px;" onclick="playNote('${blackNote}')"></div>`;
    });
  }
  html += '</div>';

  container.innerHTML = html;
}

// Highlight keys for current chord
function highlightChordKeys(notes) {
  // Clear previous highlights
  document.querySelectorAll('.piano-key').forEach(key => {
    key.classList.remove('active', 'root', 'third', 'fifth', 'seventh');
  });

  if (!notes || notes.length === 0) return;

  notes.forEach((note, index) => {
    // Normalize note for lookup (handle enharmonics)
    const normalizedNote = normalizeNote(note);
    const key = document.querySelector(`.piano-key[data-note="${normalizedNote}"]`);

    if (key) {
      key.classList.add('active');
      if (index === 0) key.classList.add('root');
      else if (index === 1) key.classList.add('third');
      else if (index === 2) key.classList.add('fifth');
      else if (index === 3) key.classList.add('seventh');
    }
  });
}

// Normalize enharmonic notes
function normalizeNote(note) {
  const enharmonics = {
    'Db': 'C#', 'Eb': 'D#', 'Fb': 'E', 'Gb': 'F#', 'Ab': 'G#', 'Bb': 'A#', 'Cb': 'B',
    'E#': 'F', 'B#': 'C', 'F##': 'G', 'Bbb': 'A'
  };

  const noteName = note.slice(0, -1);
  const octave = note.slice(-1);

  return (enharmonics[noteName] || noteName) + octave;
}

// ============================================
// CHORD DISPLAY
// ============================================
window.displayPianoChord = function (chordName) {
  const chordData = PIANO_CHORD_DATABASE[chordName];
  if (!chordData) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast(`Chord "${chordName}" not found`, 2000, 'error');
    }
    return;
  }

  currentPianoChord = chordName;
  currentInversion = 0;

  // Update chord info
  document.getElementById('chordName').textContent = chordData.name;
  document.getElementById('chordNotes').textContent = chordData.notes.join(' - ');

  // Update fingering
  updateFingeringDisplay(chordData);

  // Update difficulty badge
  const difficulty = PIANO_DIFFICULTY[chordName] || 'intermediate';
  const badge = document.getElementById('difficultyBadge');
  if (badge) {
    badge.textContent = difficulty.charAt(0).toUpperCase() + difficulty.slice(1);
    badge.className = `difficulty-badge difficulty-${difficulty}`;
  }

  // Highlight keys
  highlightChordKeys(chordData.notes);

  // Show/hide 3rd inversion button based on number of notes
  const thirdInvBtn = document.querySelector('.inversion-btn[data-inversion="3"]');
  if (thirdInvBtn) {
    thirdInvBtn.style.display = chordData.notes.length >= 4 ? 'inline-block' : 'none';
  }

  // Reset inversion buttons
  document.querySelectorAll('.inversion-btn').forEach((btn, i) => {
    btn.classList.toggle('active', i === 0);
  });
  const inversionLabel = document.getElementById('inversionLabel');
  if (inversionLabel) inversionLabel.textContent = 'Root Position';

  // Show chord display
  document.getElementById('welcomeInstructions').style.display = 'none';
  document.getElementById('chordDisplay').style.display = 'block';
};

function updateFingeringDisplay(chordData) {
  const container = document.getElementById('fingeringDisplay');
  if (!container) return;

  const fingering = selectedHand === 'rh' ? chordData.fingering.rh : chordData.fingering.lh;
  const handLabel = selectedHand === 'rh' ? 'Right Hand' : 'Left Hand';

  let html = `<div class="fingering-hand">${handLabel}:</div>`;
  html += '<div class="fingering-numbers">';

  chordData.notes.forEach((note, index) => {
    html += `<div class="finger-note">
      <span class="finger-number">${fingering[index]}</span>
      <span class="finger-note-name">${note.slice(0, -1)}</span>
    </div>`;
  });

  html += '</div>';
  html += `<div class="fingering-legend">1=Thumb, 2=Index, 3=Middle, 4=Ring, 5=Pinky</div>`;

  container.innerHTML = html;
}

// ============================================
// AUDIO PLAYBACK
// ============================================
window.playPianoChord = async function () {
  if (!soundEnabled) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('Sound is muted', 1500, 'info');
    }
    return;
  }

  if (!currentPianoChord) return;

  const chordData = PIANO_CHORD_DATABASE[currentPianoChord];
  if (!chordData) return;

  // Initialize synth if needed
  if (!toneReady) {
    await initPianoSynth();
  }

  if (!pianoSynth) return;

  // Ensure Tone.js context is running (can get suspended by browser)
  if (Tone.context.state !== 'running') {
    await Tone.start();
    await Tone.context.resume();
  }

  // Get notes (apply inversion if needed)
  const notes = getInversionNotes(chordData.notes, currentInversion);

  // Animate button
  const playBtn = document.querySelector('.play-btn');
  if (playBtn) {
    playBtn.classList.add('playing');
    setTimeout(() => playBtn.classList.remove('playing'), 500);
  }

  // Release previous notes and play new ones
  pianoSynth.releaseAll(Tone.now());

  // Start slightly in the future to allow release
  const startTime = Tone.now() + 0.05;

  if (arpeggioMode) {
    // Arpeggio - play notes sequentially
    notes.forEach((note, i) => {
      const normalizedNote = normalizeNote(note);
      pianoSynth.triggerAttackRelease(normalizedNote, 0.5, startTime + i * 0.15);
      animateKey(normalizedNote, 50 + i * 150);
    });
  } else {
    // Block chord - play all at once
    const normalizedNotes = notes.map(normalizeNote);
    pianoSynth.triggerAttackRelease(normalizedNotes, 0.8, startTime);
    normalizedNotes.forEach(note => animateKey(note, 50));
  }
};

// Play single note
window.playNote = async function (note) {
  if (!soundEnabled) return;

  if (!toneReady) {
    await initPianoSynth();
  }

  if (pianoSynth) {
    pianoSynth.triggerAttackRelease(note, '8n');
    animateKey(note, 0);
  }
};

function animateKey(note, delay) {
  setTimeout(() => {
    const key = document.querySelector(`.piano-key[data-note="${note}"]`);
    if (key) {
      key.classList.add('pressed');
      setTimeout(() => key.classList.remove('pressed'), 300);
    }
  }, delay);
}

// Get notes for current inversion
function getInversionNotes(notes, inversion) {
  if (inversion === 0) return notes;

  const result = [...notes];
  for (let i = 0; i < inversion; i++) {
    const first = result.shift();
    // Move to next octave
    const noteName = first.slice(0, -1);
    const octave = parseInt(first.slice(-1)) + 1;
    result.push(noteName + octave);
  }
  return result;
}

// ============================================
// INVERSIONS
// ============================================
window.changeInversion = function (inv) {
  if (!currentPianoChord) return;

  const chordData = PIANO_CHORD_DATABASE[currentPianoChord];
  const maxInversion = chordData.notes.length - 1;

  currentInversion = Math.max(0, Math.min(inv, maxInversion));

  // Update button states
  document.querySelectorAll('.inversion-btn').forEach((btn, i) => {
    btn.classList.toggle('active', i === currentInversion);
  });

  // Update displayed notes
  const inversionNotes = getInversionNotes(chordData.notes, currentInversion);
  document.getElementById('chordNotes').textContent = inversionNotes.join(' - ');

  // Update keyboard highlight
  highlightChordKeys(inversionNotes);

  // Update inversion label
  const labels = ['Root Position', '1st Inversion', '2nd Inversion', '3rd Inversion'];
  document.getElementById('inversionLabel').textContent = labels[currentInversion] || '';
};

// ============================================
// HAND SELECTION
// ============================================
window.selectHand = function (hand) {
  selectedHand = hand;

  document.querySelectorAll('.hand-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.hand === hand);
  });

  if (currentPianoChord) {
    const chordData = PIANO_CHORD_DATABASE[currentPianoChord];
    updateFingeringDisplay(chordData);
  }
};

// ============================================
// SEARCH & AUTOCOMPLETE
// ============================================
function setupSearchAutocomplete() {
  const searchInput = document.getElementById('chordInput');
  if (!searchInput) return;

  const allChords = Object.keys(PIANO_CHORD_DATABASE);
  let selectedIndex = -1;
  let currentMatches = [];

  // Create dropdown
  const dropdown = document.createElement('div');
  dropdown.className = 'chord-autocomplete';
  dropdown.id = 'chordAutocomplete';
  searchInput.parentElement.appendChild(dropdown);

  function renderAutocomplete(matches) {
    currentMatches = matches;
    selectedIndex = -1;

    if (matches.length === 0) {
      dropdown.innerHTML = '<div class="chord-autocomplete-empty">No matching chords</div>';
      dropdown.classList.add('active');
      return;
    }

    const displayMatches = matches.slice(0, 10);
    let html = displayMatches.map((chord, index) => {
      const chordData = PIANO_CHORD_DATABASE[chord];
      const difficulty = PIANO_DIFFICULTY[chord] || 'intermediate';
      return `
        <div class="chord-autocomplete-item" data-chord="${chord}" data-index="${index}">
          <div>
            <span class="chord-name">${chord}</span>
            <span class="chord-full-name">${chordData.name}</span>
          </div>
          <span class="chord-difficulty ${difficulty}">${difficulty}</span>
        </div>
      `;
    }).join('');

    if (matches.length > 10) {
      html += `<div class="chord-autocomplete-hint">Showing 10 of ${matches.length} matches</div>`;
    }

    dropdown.innerHTML = html;
    dropdown.classList.add('active');

    dropdown.querySelectorAll('.chord-autocomplete-item').forEach(item => {
      item.addEventListener('click', () => {
        searchInput.value = item.dataset.chord;
        dropdown.classList.remove('active');
        displayPianoChord(item.dataset.chord);
      });
    });
  }

  function hideAutocomplete() {
    dropdown.classList.remove('active');
  }

  searchInput.addEventListener('input', function () {
    const query = this.value.trim().toLowerCase();
    if (query.length === 0) {
      hideAutocomplete();
      return;
    }

    const matches = allChords.filter(c =>
      c.toLowerCase().startsWith(query) ||
      PIANO_CHORD_DATABASE[c].name.toLowerCase().includes(query)
    );
    renderAutocomplete(matches);
  });

  searchInput.addEventListener('keydown', function (e) {
    if (!dropdown.classList.contains('active')) {
      if (e.key === 'Enter') searchChord();
      return;
    }

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      selectedIndex = Math.min(selectedIndex + 1, currentMatches.length - 1);
      updateSelection();
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      selectedIndex = Math.max(selectedIndex - 1, 0);
      updateSelection();
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (selectedIndex >= 0) {
        displayPianoChord(currentMatches[selectedIndex]);
        hideAutocomplete();
      } else if (currentMatches.length > 0) {
        displayPianoChord(currentMatches[0]);
        hideAutocomplete();
      }
    } else if (e.key === 'Escape') {
      hideAutocomplete();
    }
  });

  function updateSelection() {
    dropdown.querySelectorAll('.chord-autocomplete-item').forEach((item, i) => {
      item.classList.toggle('selected', i === selectedIndex);
    });
  }

  document.addEventListener('click', (e) => {
    if (!searchInput.contains(e.target) && !dropdown.contains(e.target)) {
      hideAutocomplete();
    }
  });
}

window.searchChord = function () {
  const input = document.getElementById('chordInput');
  const chord = input.value.trim();

  if (PIANO_CHORD_DATABASE[chord]) {
    displayPianoChord(chord);
  } else {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast(`Chord "${chord}" not found`, 2000, 'warning');
    }
  }
};

// ============================================
// QUICK CHORDS & CHORD TYPES
// ============================================
function populateQuickChords() {
  const quickChords = ['C', 'G', 'Am', 'F', 'Dm', 'Em', 'D', 'A'];
  const container = document.getElementById('quickChords');
  if (!container) return;

  quickChords.forEach(chord => {
    const btn = document.createElement('button');
    btn.className = 'quick-chord-btn';
    btn.textContent = chord;
    btn.onclick = () => displayPianoChord(chord);
    container.appendChild(btn);
  });
}

function populateChordTypes() {
  const types = [
    { name: 'Major', filter: c => /^[A-G][b#]?$/.test(c) },
    { name: 'Minor', filter: c => /^[A-G][b#]?m$/.test(c) },
    { name: '7th', filter: c => /^[A-G][b#]?7$/.test(c) },
    { name: 'Maj7', filter: c => c.includes('maj7') },
    { name: 'm7', filter: c => /m7$/.test(c) && !c.includes('maj') && !c.includes('b5') },
    { name: 'Sus', filter: c => c.includes('sus') },
    { name: 'Dim', filter: c => c.includes('dim') },
    { name: 'Aug', filter: c => c.includes('aug') },
    { name: 'Add9', filter: c => c.includes('add9') }
  ];

  const container = document.getElementById('chordTypes');
  if (!container) return;

  types.forEach(type => {
    const btn = document.createElement('button');
    btn.className = 'chord-type-btn';
    btn.textContent = type.name;
    btn.onclick = () => {
      const matches = Object.keys(PIANO_CHORD_DATABASE).filter(type.filter);
      if (matches.length > 0) {
        displayPianoChord(matches[0]);
      }
    };
    container.appendChild(btn);
  });
}

// ============================================
// PROGRESSIONS
// ============================================
window.renderProgressions = function () {
  const container = document.getElementById('progressionsContainer');
  if (!container) return;

  const keyChords = PIANO_KEYS[currentKey];
  let html = '';

  PIANO_PROGRESSIONS.forEach((prog, index) => {
    const chords = prog.numerals.map(num => keyChords[num] || num);
    const playableChords = chords.filter(c => PIANO_CHORD_DATABASE[c]);

    html += `
      <div class="progression-card" onclick="loadProgression(${index})">
        <div class="progression-header">
          <span class="progression-name">${prog.name}</span>
          <span class="progression-genre">${prog.genre}</span>
        </div>
        <div class="progression-numerals">${prog.numerals.join(' - ')}</div>
        <div class="progression-chords">${chords.join(' → ')}</div>
        <div class="progression-description">${prog.description}</div>
        <button class="progression-play-btn" onclick="event.stopPropagation(); playProgression(${index})">
          ▶ Play
        </button>
      </div>
    `;
  });

  container.innerHTML = html;
};

window.changeKey = function (key) {
  currentKey = key;
  renderProgressions();
};

window.loadProgression = function (index) {
  const prog = PIANO_PROGRESSIONS[index];
  const keyChords = PIANO_KEYS[currentKey];
  const chords = prog.numerals.map(num => keyChords[num] || num);

  if (chords.length > 0 && PIANO_CHORD_DATABASE[chords[0]]) {
    displayPianoChord(chords[0]);
  }

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(`Loaded: ${prog.name} in ${currentKey}`, 2000, 'success');
  }
};

// Cancel all ongoing playback sequences
window.cancelPlayback = function () {
  // Increment playback ID to invalidate old callbacks
  activePlaybackId++;

  // Clear all pending timeouts
  playbackTimeouts.forEach(timeoutId => clearTimeout(timeoutId));
  playbackTimeouts = [];
};

window.playProgression = async function (index) {
  const prog = PIANO_PROGRESSIONS[index];
  const keyChords = PIANO_KEYS[currentKey];
  const chords = prog.numerals.map(num => keyChords[num] || num);

  if (!toneReady) {
    await initPianoSynth();
  }

  // Ensure Tone.js context is running
  if (Tone.context.state !== 'running') {
    await Tone.start();
    await Tone.context.resume();
  }

  // Cancel any ongoing playback
  cancelPlayback();
  const currentPlaybackId = activePlaybackId;

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(`Playing: ${prog.name}`, 2000, 'info');
  }

  // Musical timing - 100 BPM, 4 beats per chord
  const bpm = 100;
  const beatDuration = 60000 / bpm; // ms per beat
  const beatsPerChord = 4;

  let delay = 0;

  // Play each chord with a rhythm pattern
  chords.forEach((chord) => {
    if (PIANO_CHORD_DATABASE[chord]) {
      const chordData = PIANO_CHORD_DATABASE[chord];
      const notes = chordData.notes.map(normalizeNote);
      const bassNote = notes[0]; // Root note as bass

      // Beat 1: Bass note (strong)
      scheduleNote(bassNote, delay, 0.4, currentPlaybackId);

      // Beat 2: Full chord
      scheduleChord(notes, delay + beatDuration, 0.3, currentPlaybackId);

      // Beat 3: Bass note
      scheduleNote(bassNote, delay + beatDuration * 2, 0.3, currentPlaybackId);

      // Beat 4: Full chord (lighter)
      scheduleChord(notes, delay + beatDuration * 3, 0.25, currentPlaybackId);

      // Update display on beat 1
      const timeoutId = setTimeout(() => {
        if (activePlaybackId === currentPlaybackId) {
          displayPianoChord(chord);
        }
      }, delay);
      playbackTimeouts.push(timeoutId);

      delay += beatDuration * beatsPerChord;
    }
  });
};

// Schedule a single note
function scheduleNote(note, delayMs, duration, playbackId) {
  const timeoutId = setTimeout(() => {
    if (activePlaybackId === playbackId && pianoSynth) {
      pianoSynth.triggerAttackRelease(note, duration, Tone.now());
      animateKey(note, 0);
    }
  }, delayMs);
  playbackTimeouts.push(timeoutId);
}

// Schedule a chord (multiple notes)
function scheduleChord(notes, delayMs, duration, playbackId) {
  const timeoutId = setTimeout(() => {
    if (activePlaybackId === playbackId && pianoSynth) {
      pianoSynth.triggerAttackRelease(notes, duration, Tone.now());
      notes.forEach(note => animateKey(note, 0));
    }
  }, delayMs);
  playbackTimeouts.push(timeoutId);
}

// ============================================
// SETTINGS TOGGLES
// ============================================
window.toggleArpeggio = function () {
  arpeggioMode = !arpeggioMode;
  const toggle = document.getElementById('arpeggioToggle');
  if (toggle) toggle.checked = arpeggioMode;

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(arpeggioMode ? 'Arpeggio mode ON' : 'Block chord mode', 1500, 'info');
  }
};

window.toggleSound = function () {
  soundEnabled = !soundEnabled;
  const toggle = document.getElementById('soundToggle');
  if (toggle) toggle.checked = soundEnabled;
};

// ============================================
// KEYBOARD SHORTCUTS
// ============================================
function setupKeyboardShortcuts() {
  document.addEventListener('keydown', (e) => {
    if (e.target.tagName === 'INPUT') return;

    const key = e.key.toUpperCase();

    // A-G for major chords
    if (/^[A-G]$/.test(key) && !e.ctrlKey && !e.metaKey) {
      e.preventDefault();
      if (e.shiftKey) {
        // Minor chord
        const minor = key + 'm';
        if (PIANO_CHORD_DATABASE[minor]) displayPianoChord(minor);
      } else {
        if (PIANO_CHORD_DATABASE[key]) displayPianoChord(key);
      }
    }

    // Space to play
    if (e.code === 'Space' && currentPianoChord) {
      e.preventDefault();
      playPianoChord();
    }

    // P for arpeggio toggle
    if (key === 'P') {
      e.preventDefault();
      toggleArpeggio();
    }

    // M for mute
    if (key === 'M') {
      e.preventDefault();
      toggleSound();
    }

    // 0-3 for inversions
    if (/^[0-3]$/.test(e.key) && currentPianoChord) {
      e.preventDefault();
      changeInversion(parseInt(e.key));
    }
  });
}

// ============================================
// SHARE & FAVORITES (using ToolUtils)
// ============================================
window.shareChord = function () {
  if (!currentPianoChord) return;

  if (typeof ToolUtils !== 'undefined') {
    const url = ToolUtils.generateShareUrl({ chord: currentPianoChord });
    ToolUtils.copyToClipboard(url);
    ToolUtils.showToast('Link copied to clipboard!', 2000, 'success');
  }
};

window.saveFavorite = function () {
  if (!currentPianoChord) return;

  if (typeof ToolUtils !== 'undefined') {
    const favorites = ToolUtils.storage.get('piano_favorites', []);
    if (!favorites.includes(currentPianoChord)) {
      favorites.push(currentPianoChord);
      ToolUtils.storage.set('piano_favorites', favorites);
      ToolUtils.showToast(`${currentPianoChord} saved to favorites!`, 2000, 'success');
    } else {
      ToolUtils.showToast('Already in favorites', 1500, 'info');
    }
  }
};

window.copyChordInfo = function () {
  if (!currentPianoChord) return;

  const chordData = PIANO_CHORD_DATABASE[currentPianoChord];
  const text = `${chordData.name}\nNotes: ${chordData.notes.join(', ')}\nIntervals: ${chordData.intervals}`;

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.copyToClipboard(text);
    ToolUtils.showToast('Chord info copied!', 2000, 'success');
  }
};

// Load chord from URL
function loadChordFromUrl() {
  const params = new URLSearchParams(window.location.search);
  const chord = params.get('chord');
  if (chord && PIANO_CHORD_DATABASE[chord]) {
    displayPianoChord(chord);
  }
}

// ============================================
// INITIALIZATION
// ============================================
document.addEventListener('DOMContentLoaded', function () {
  renderPianoKeyboard();
  populateQuickChords();
  populateChordTypes();
  setupSearchAutocomplete();
  setupKeyboardShortcuts();
  renderProgressions();
  loadChordFromUrl();
  setupMIDI();

  console.log('Piano Chord Finder initialized');
  console.log(`${Object.keys(PIANO_CHORD_DATABASE).length} chords loaded`);
});

// ============================================
// MIDI INPUT SUPPORT
// ============================================
let midiAccess = null;

function setupMIDI() {
  if (navigator.requestMIDIAccess) {
    navigator.requestMIDIAccess()
      .then(onMIDISuccess, onMIDIFailure);
  }
}

function onMIDISuccess(access) {
  midiAccess = access;

  // Show the UI container
  const container = document.getElementById('midiStatusContainer');
  if (container) container.style.display = 'block';

  updateMIDIStatus();

  // Listen for connection changes
  midiAccess.onstatechange = (e) => {
    updateMIDIStatus();
  };

  // Attach to current inputs
  startMidiListening();
}

function startMidiListening() {
  if (!midiAccess) return;
  const inputs = midiAccess.inputs.values();
  for (let input of inputs) {
    input.onmidimessage = getMIDIMessage;
  }
}

function onMIDIFailure() {
  console.log('Could not access MIDI devices.');
}

function updateMIDIStatus() {
  if (!midiAccess) return;
  const inputs = midiAccess.inputs.values();
  let isConnected = false;
  let deviceNames = [];

  for (let input of inputs) {
    // Re-attach listener to ensure we catch new devices
    input.onmidimessage = getMIDIMessage;

    // Check if at least one device is connected
    if (input.state === 'connected' && input.connection === 'open') {
      isConnected = true;
      if (!deviceNames.includes(input.name)) {
        deviceNames.push(input.name);
      }
    }
  }

  const badge = document.getElementById('midiStatusBadge');
  if (badge) {
    if (isConnected || deviceNames.length > 0) {
      badge.textContent = 'Connected';
      badge.style.background = '#dcfce7';
      badge.style.color = '#166534';
      badge.title = deviceNames.join(', ');

      // Update text to show device name if single device
      if (deviceNames.length === 1) {
        badge.textContent = deviceNames[0].substring(0, 15) + (deviceNames[0].length > 15 ? '...' : '');
      }
    } else {
      badge.textContent = 'Not Connected';
      badge.style.background = '#e2e8f0';
      badge.style.color = '#64748b';
      badge.title = 'Connect a MIDI keyboard';
    }
  }
}

function getMIDIMessage(message) {
  const command = message.data[0];
  const note = message.data[1];
  const velocity = (message.data.length > 2) ? message.data[2] : 0;

  // Note On (typically 144-159)
  if (command >= 144 && command <= 159 && velocity > 0) {
    handleMidiNoteOn(note, velocity);
  }

  // Note Off (128-143 or Note On with 0 velocity)
  if ((command >= 128 && command <= 143) || (command >= 144 && command <= 159 && velocity === 0)) {
    handleMidiNoteOff(note);
  }
}

function midiNoteToName(note) {
  const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  const octave = Math.floor(note / 12) - 1;
  const noteIndex = note % 12;
  return noteNames[noteIndex] + octave;
}

function handleMidiNoteOn(note, velocity) {
  const noteName = midiNoteToName(note);

  // Visual feedback
  const key = document.querySelector(`.piano-key[data-note="${noteName}"]`);
  if (key) {
    key.classList.add('pressed');
  }

  // Audio feedback
  if (soundEnabled) {
    // Resume context if needed (browsers block auto-audio)
    if (typeof Tone !== 'undefined' && Tone.context.state !== 'running') {
      Tone.context.resume();
    }

    // Initialize if first interaction is MIDI
    if (!pianoSynth) {
      initPianoSynth().then(() => {
        if (pianoSynth) pianoSynth.triggerAttack(noteName, Tone.now(), velocity / 127);
      });
    } else {
      pianoSynth.triggerAttack(noteName, Tone.now(), velocity / 127);
    }
  }
}

function handleMidiNoteOff(note) {
  const noteName = midiNoteToName(note);

  // Visual feedback
  const key = document.querySelector(`.piano-key[data-note="${noteName}"]`);
  if (key) {
    key.classList.remove('pressed');
  }

  // Audio feedback
  if (soundEnabled && pianoSynth) {
    pianoSynth.triggerRelease(noteName);
  }
}
