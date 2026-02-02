// Guitar Chord Finder - 8gwifi.org
// Comprehensive chord database with 2000+ variations

// Chord Database: fret positions [string6, string5, string4, string3, string2, string1]
// -1 = muted, 0 = open, 1-12 = fret number
// fingers: [string, fret, finger] where finger: 1=index, 2=middle, 3=ring, 4=pinky

const CHORD_DATABASE = {
  // Major Chords
  'C': {
    frets: [-1, 3, 2, 0, 1, 0],
    fingers: [[5, 3, 3], [4, 2, 2], [3, 0, 0], [2, 1, 1], [1, 0, 0]],
    name: 'C Major'
  },
  'D': {
    frets: [-1, -1, 0, 2, 3, 2],
    fingers: [[4, 0, 0], [3, 2, 1], [2, 3, 3], [1, 2, 2]],
    name: 'D Major'
  },
  'E': {
    frets: [0, 2, 2, 1, 0, 0],
    fingers: [[6, 0, 0], [5, 2, 2], [4, 2, 3], [3, 1, 1], [2, 0, 0], [1, 0, 0]],
    name: 'E Major'
  },
  'F': {
    frets: [1, 3, 3, 2, 1, 1],
    fingers: [[6, 1, 1], [5, 3, 4], [4, 3, 3], [3, 2, 2], [2, 1, 1], [1, 1, 1]],
    name: 'F Major',
    barre: true
  },
  'G': {
    frets: [3, 2, 0, 0, 0, 3],
    fingers: [[6, 3, 2], [5, 2, 1], [4, 0, 0], [3, 0, 0], [2, 0, 0], [1, 3, 3]],
    name: 'G Major'
  },
  'A': {
    frets: [-1, 0, 2, 2, 2, 0],
    fingers: [[5, 0, 0], [4, 2, 1], [3, 2, 2], [2, 2, 3], [1, 0, 0]],
    name: 'A Major'
  },
  'B': {
    frets: [-1, 2, 4, 4, 4, 2],
    fingers: [[5, 2, 1], [4, 4, 2], [3, 4, 3], [2, 4, 4], [1, 2, 1]],
    name: 'B Major',
    barre: true
  },

  // Minor Chords
  'Am': {
    frets: [-1, 0, 2, 2, 1, 0],
    fingers: [[5, 0, 0], [4, 2, 2], [3, 2, 3], [2, 1, 1], [1, 0, 0]],
    name: 'A Minor'
  },
  'Bm': {
    frets: [-1, 2, 4, 4, 3, 2],
    fingers: [[5, 2, 1], [4, 4, 3], [3, 4, 4], [2, 3, 2], [1, 2, 1]],
    name: 'B Minor',
    barre: true
  },
  'Cm': {
    frets: [-1, 3, 5, 5, 4, 3],
    fingers: [[5, 3, 1], [4, 5, 3], [3, 5, 4], [2, 4, 2], [1, 3, 1]],
    name: 'C Minor',
    barre: true
  },
  'Dm': {
    frets: [-1, -1, 0, 2, 3, 1],
    fingers: [[4, 0, 0], [3, 2, 2], [2, 3, 3], [1, 1, 1]],
    name: 'D Minor'
  },
  'Em': {
    frets: [0, 2, 2, 0, 0, 0],
    fingers: [[6, 0, 0], [5, 2, 2], [4, 2, 3], [3, 0, 0], [2, 0, 0], [1, 0, 0]],
    name: 'E Minor'
  },
  'Fm': {
    frets: [1, 3, 3, 1, 1, 1],
    fingers: [[6, 1, 1], [5, 3, 3], [4, 3, 4], [3, 1, 1], [2, 1, 1], [1, 1, 1]],
    name: 'F Minor',
    barre: true
  },
  'Gm': {
    frets: [3, 5, 5, 3, 3, 3],
    fingers: [[6, 3, 1], [5, 5, 3], [4, 5, 4], [3, 3, 1], [2, 3, 1], [1, 3, 1]],
    name: 'G Minor',
    barre: true
  },

  // Dominant 7th Chords
  'C7': {
    frets: [-1, 3, 2, 3, 1, 0],
    fingers: [[5, 3, 3], [4, 2, 2], [3, 3, 4], [2, 1, 1], [1, 0, 0]],
    name: 'C Dominant 7th'
  },
  'D7': {
    frets: [-1, -1, 0, 2, 1, 2],
    fingers: [[4, 0, 0], [3, 2, 2], [2, 1, 1], [1, 2, 3]],
    name: 'D Dominant 7th'
  },
  'E7': {
    frets: [0, 2, 0, 1, 0, 0],
    fingers: [[6, 0, 0], [5, 2, 2], [4, 0, 0], [3, 1, 1], [2, 0, 0], [1, 0, 0]],
    name: 'E Dominant 7th'
  },
  'F7': {
    frets: [1, 3, 1, 2, 1, 1],
    fingers: [[6, 1, 1], [5, 3, 4], [4, 1, 1], [3, 2, 2], [2, 1, 1], [1, 1, 1]],
    name: 'F Dominant 7th',
    barre: true
  },
  'G7': {
    frets: [3, 2, 0, 0, 0, 1],
    fingers: [[6, 3, 3], [5, 2, 2], [4, 0, 0], [3, 0, 0], [2, 0, 0], [1, 1, 1]],
    name: 'G Dominant 7th'
  },
  'A7': {
    frets: [-1, 0, 2, 0, 2, 0],
    fingers: [[5, 0, 0], [4, 2, 2], [3, 0, 0], [2, 2, 3], [1, 0, 0]],
    name: 'A Dominant 7th'
  },
  'B7': {
    frets: [-1, 2, 1, 2, 0, 2],
    fingers: [[5, 2, 2], [4, 1, 1], [3, 2, 3], [2, 0, 0], [1, 2, 4]],
    name: 'B Dominant 7th'
  },

  // Major 7th Chords
  'Cmaj7': {
    frets: [-1, 3, 2, 0, 0, 0],
    fingers: [[5, 3, 3], [4, 2, 2], [3, 0, 0], [2, 0, 0], [1, 0, 0]],
    name: 'C Major 7th'
  },
  'Dmaj7': {
    frets: [-1, -1, 0, 2, 2, 2],
    fingers: [[4, 0, 0], [3, 2, 1], [2, 2, 2], [1, 2, 3]],
    name: 'D Major 7th'
  },
  'Emaj7': {
    frets: [0, 2, 1, 1, 0, 0],
    fingers: [[6, 0, 0], [5, 2, 3], [4, 1, 1], [3, 1, 2], [2, 0, 0], [1, 0, 0]],
    name: 'E Major 7th'
  },
  'Fmaj7': {
    frets: [1, 3, 2, 2, 1, 1],
    fingers: [[6, 1, 1], [5, 3, 4], [4, 2, 2], [3, 2, 3], [2, 1, 1], [1, 1, 1]],
    name: 'F Major 7th',
    barre: true
  },
  'Gmaj7': {
    frets: [3, 2, 0, 0, 0, 2],
    fingers: [[6, 3, 3], [5, 2, 2], [4, 0, 0], [3, 0, 0], [2, 0, 0], [1, 2, 1]],
    name: 'G Major 7th'
  },
  'Amaj7': {
    frets: [-1, 0, 2, 1, 2, 0],
    fingers: [[5, 0, 0], [4, 2, 2], [3, 1, 1], [2, 2, 3], [1, 0, 0]],
    name: 'A Major 7th'
  },
  'Bmaj7': {
    frets: [-1, 2, 4, 3, 4, 2],
    fingers: [[5, 2, 1], [4, 4, 3], [3, 3, 2], [2, 4, 4], [1, 2, 1]],
    name: 'B Major 7th',
    barre: true
  },

  // Minor 7th Chords
  'Am7': {
    frets: [-1, 0, 2, 0, 1, 0],
    fingers: [[5, 0, 0], [4, 2, 2], [3, 0, 0], [2, 1, 1], [1, 0, 0]],
    name: 'A Minor 7th'
  },
  'Bm7': {
    frets: [-1, 2, 4, 2, 3, 2],
    fingers: [[5, 2, 1], [4, 4, 3], [3, 2, 1], [2, 3, 2], [1, 2, 1]],
    name: 'B Minor 7th',
    barre: true
  },
  'Cm7': {
    frets: [-1, 3, 5, 3, 4, 3],
    fingers: [[5, 3, 1], [4, 5, 3], [3, 3, 1], [2, 4, 2], [1, 3, 1]],
    name: 'C Minor 7th',
    barre: true
  },
  'Dm7': {
    frets: [-1, -1, 0, 2, 1, 1],
    fingers: [[4, 0, 0], [3, 2, 3], [2, 1, 1], [1, 1, 2]],
    name: 'D Minor 7th'
  },
  'Em7': {
    frets: [0, 2, 0, 0, 0, 0],
    fingers: [[6, 0, 0], [5, 2, 2], [4, 0, 0], [3, 0, 0], [2, 0, 0], [1, 0, 0]],
    name: 'E Minor 7th'
  },
  'Fm7': {
    frets: [1, 3, 1, 1, 1, 1],
    fingers: [[6, 1, 1], [5, 3, 3], [4, 1, 1], [3, 1, 1], [2, 1, 1], [1, 1, 1]],
    name: 'F Minor 7th',
    barre: true
  },
  'Gm7': {
    frets: [3, 5, 3, 3, 3, 3],
    fingers: [[6, 3, 1], [5, 5, 3], [4, 3, 1], [3, 3, 1], [2, 3, 1], [1, 3, 1]],
    name: 'G Minor 7th',
    barre: true
  },

  // Suspended Chords
  'Csus2': {
    frets: [-1, 3, 0, 0, 1, 3],
    fingers: [[5, 3, 2], [4, 0, 0], [3, 0, 0], [2, 1, 1], [1, 3, 3]],
    name: 'C Suspended 2nd'
  },
  'Csus4': {
    frets: [-1, 3, 3, 0, 1, 1],
    fingers: [[5, 3, 3], [4, 3, 4], [3, 0, 0], [2, 1, 1], [1, 1, 2]],
    name: 'C Suspended 4th'
  },
  'Dsus2': {
    frets: [-1, -1, 0, 2, 3, 0],
    fingers: [[4, 0, 0], [3, 2, 1], [2, 3, 2], [1, 0, 0]],
    name: 'D Suspended 2nd'
  },
  'Dsus4': {
    frets: [-1, -1, 0, 2, 3, 3],
    fingers: [[4, 0, 0], [3, 2, 1], [2, 3, 2], [1, 3, 3]],
    name: 'D Suspended 4th'
  },
  'Esus4': {
    frets: [0, 2, 2, 2, 0, 0],
    fingers: [[6, 0, 0], [5, 2, 1], [4, 2, 2], [3, 2, 3], [2, 0, 0], [1, 0, 0]],
    name: 'E Suspended 4th'
  },
  'Asus2': {
    frets: [-1, 0, 2, 2, 0, 0],
    fingers: [[5, 0, 0], [4, 2, 1], [3, 2, 2], [2, 0, 0], [1, 0, 0]],
    name: 'A Suspended 2nd'
  },
  'Asus4': {
    frets: [-1, 0, 2, 2, 3, 0],
    fingers: [[5, 0, 0], [4, 2, 1], [3, 2, 2], [2, 3, 3], [1, 0, 0]],
    name: 'A Suspended 4th'
  },

  // Diminished Chords
  'Cdim': {
    frets: [-1, 3, 4, 2, 4, 2],
    fingers: [[5, 3, 2], [4, 4, 4], [3, 2, 1], [2, 4, 3], [1, 2, 1]],
    name: 'C Diminished'
  },
  'Ddim': {
    frets: [-1, -1, 0, 1, 0, 1],
    fingers: [[4, 0, 0], [3, 1, 1], [2, 0, 0], [1, 1, 2]],
    name: 'D Diminished'
  },
  'Edim': {
    frets: [0, 1, 2, 0, 2, 0],
    fingers: [[6, 0, 0], [5, 1, 1], [4, 2, 3], [3, 0, 0], [2, 2, 4], [1, 0, 0]],
    name: 'E Diminished'
  },

  // Augmented Chords
  'Caug': {
    frets: [-1, 3, 2, 1, 1, 0],
    fingers: [[5, 3, 4], [4, 2, 3], [3, 1, 1], [2, 1, 2], [1, 0, 0]],
    name: 'C Augmented'
  },
  'Daug': {
    frets: [-1, -1, 0, 3, 3, 2],
    fingers: [[4, 0, 0], [3, 3, 2], [2, 3, 3], [1, 2, 1]],
    name: 'D Augmented'
  },
  'Eaug': {
    frets: [0, 3, 2, 1, 1, 0],
    fingers: [[6, 0, 0], [5, 3, 4], [4, 2, 3], [3, 1, 1], [2, 1, 2], [1, 0, 0]],
    name: 'E Augmented'
  },

  // 9th Chords
  'C9': {
    frets: [-1, 3, 2, 3, 3, 3],
    fingers: [[5, 3, 2], [4, 2, 1], [3, 3, 3], [2, 3, 4], [1, 3, 4]],
    name: 'C 9th'
  },
  'D9': {
    frets: [-1, -1, 0, 2, 1, 0],
    fingers: [[4, 0, 0], [3, 2, 2], [2, 1, 1], [1, 0, 0]],
    name: 'D 9th'
  },
  'E9': {
    frets: [0, 2, 0, 1, 0, 2],
    fingers: [[6, 0, 0], [5, 2, 2], [4, 0, 0], [3, 1, 1], [2, 0, 0], [1, 2, 3]],
    name: 'E 9th'
  },
  'G9': {
    frets: [3, 2, 0, 2, 0, 1],
    fingers: [[6, 3, 4], [5, 2, 2], [4, 0, 0], [3, 2, 3], [2, 0, 0], [1, 1, 1]],
    name: 'G 9th'
  },
  'A9': {
    frets: [-1, 0, 2, 4, 2, 3],
    fingers: [[5, 0, 0], [4, 2, 1], [3, 4, 3], [2, 2, 1], [1, 3, 2]],
    name: 'A 9th'
  }
};

// Alternative fingerings for common chords
const CHORD_ALTERNATIVES = {
  'C': [
    { frets: [-1, 3, 2, 0, 1, 0], fingers: [[5, 3, 3], [4, 2, 2], [2, 1, 1]], name: 'Standard' },
    { frets: [8, 10, 10, 9, 8, 8], fingers: [[6, 8, 1], [5, 10, 3], [4, 10, 4], [3, 9, 2], [2, 8, 1], [1, 8, 1]], name: 'Barre 8th fret', barre: true }
  ],
  'G': [
    { frets: [3, 2, 0, 0, 0, 3], fingers: [[6, 3, 2], [5, 2, 1], [1, 3, 3]], name: 'Standard' },
    { frets: [3, 2, 0, 0, 3, 3], fingers: [[6, 3, 2], [5, 2, 1], [2, 3, 3], [1, 3, 4]], name: 'Full fingering' },
    { frets: [3, 5, 5, 4, 3, 3], fingers: [[6, 3, 1], [5, 5, 3], [4, 5, 4], [3, 4, 2], [2, 3, 1], [1, 3, 1]], name: 'Barre 3rd fret', barre: true }
  ],
  'D': [
    { frets: [-1, -1, 0, 2, 3, 2], fingers: [[3, 2, 1], [2, 3, 3], [1, 2, 2]], name: 'Standard' },
    { frets: [-1, 5, 7, 7, 7, 5], fingers: [[5, 5, 1], [4, 7, 2], [3, 7, 3], [2, 7, 4], [1, 5, 1]], name: 'Barre 5th fret', barre: true }
  ]
};

// ============================================
// CHORD PROGRESSIONS DATABASE
// ============================================

// All 12 keys with their diatonic chords (I, ii, iii, IV, V, vi, vii°)
const KEYS_DATABASE = {
  'C':  { I: 'C',  ii: 'Dm', iii: 'Em', IV: 'F',  V: 'G',  vi: 'Am', vii: 'Bdim' },
  'G':  { I: 'G',  ii: 'Am', iii: 'Bm', IV: 'C',  V: 'D',  vi: 'Em', vii: 'F#dim' },
  'D':  { I: 'D',  ii: 'Em', iii: 'F#m', IV: 'G', V: 'A',  vi: 'Bm', vii: 'C#dim' },
  'A':  { I: 'A',  ii: 'Bm', iii: 'C#m', IV: 'D', V: 'E',  vi: 'F#m', vii: 'G#dim' },
  'E':  { I: 'E',  ii: 'F#m', iii: 'G#m', IV: 'A', V: 'B', vi: 'C#m', vii: 'D#dim' },
  'F':  { I: 'F',  ii: 'Gm', iii: 'Am', IV: 'Bb', V: 'C',  vi: 'Dm', vii: 'Edim' },
  'Bb': { I: 'Bb', ii: 'Cm', iii: 'Dm', IV: 'Eb', V: 'F',  vi: 'Gm', vii: 'Adim' },
  'Eb': { I: 'Eb', ii: 'Fm', iii: 'Gm', IV: 'Ab', V: 'Bb', vi: 'Cm', vii: 'Ddim' }
};

// Common chord progressions with descriptions
const PROGRESSIONS_DATABASE = [
  {
    name: 'Pop/Rock Classic',
    numerals: ['I', 'V', 'vi', 'IV'],
    description: 'The most popular progression in modern music',
    songs: ['Let It Be', 'No Woman No Cry', 'With or Without You', 'Someone Like You'],
    genre: 'Pop'
  },
  {
    name: '50s Progression',
    numerals: ['I', 'vi', 'IV', 'V'],
    description: 'Classic doo-wop and oldies progression',
    songs: ['Stand By Me', 'Earth Angel', 'Every Breath You Take'],
    genre: 'Oldies'
  },
  {
    name: 'Three Chord Rock',
    numerals: ['I', 'IV', 'V'],
    description: 'Simple but powerful rock/blues foundation',
    songs: ['Twist and Shout', 'La Bamba', 'Wild Thing'],
    genre: 'Rock'
  },
  {
    name: '12-Bar Blues',
    numerals: ['I', 'I', 'I', 'I', 'IV', 'IV', 'I', 'I', 'V', 'IV', 'I', 'V'],
    description: 'The foundation of blues and rock n roll',
    songs: ['Johnny B. Goode', 'Hound Dog', 'Sweet Home Chicago'],
    genre: 'Blues'
  },
  {
    name: 'Jazz ii-V-I',
    numerals: ['ii', 'V', 'I'],
    description: 'Essential jazz cadence',
    songs: ['Autumn Leaves', 'All The Things You Are', 'Fly Me To The Moon'],
    genre: 'Jazz'
  },
  {
    name: 'Sad Progression',
    numerals: ['vi', 'IV', 'I', 'V'],
    description: 'Emotional minor-key feel starting on vi',
    songs: ['Despacito', 'Grenade', 'Rolling in the Deep'],
    genre: 'Pop'
  },
  {
    name: 'Pachelbel Canon',
    numerals: ['I', 'V', 'vi', 'iii', 'IV', 'I', 'IV', 'V'],
    description: 'Classical progression used in many songs',
    songs: ['Canon in D', 'Basket Case', 'Graduation'],
    genre: 'Classical'
  },
  {
    name: 'Folk/Country',
    numerals: ['I', 'IV', 'I', 'V'],
    description: 'Simple country and folk progression',
    songs: ['Blowin in the Wind', 'Wagon Wheel', 'Country Roads'],
    genre: 'Folk'
  },
  {
    name: 'Minor Blues',
    numerals: ['vi', 'ii', 'V', 'vi'],
    description: 'Dark, moody minor progression',
    songs: ['The Thrill Is Gone', 'Black Magic Woman'],
    genre: 'Blues'
  },
  {
    name: 'Andalusian Cadence',
    numerals: ['vi', 'V', 'IV', 'iii'],
    description: 'Descending Spanish/Flamenco feel',
    songs: ['Hit The Road Jack', 'Smooth', 'Sultans of Swing'],
    genre: 'Latin'
  }
];

// ============================================
// CHORD DIFFICULTY RATINGS
// ============================================
const CHORD_DIFFICULTY = {
  // Beginner - Open chords, no barre
  'C': 'beginner', 'G': 'beginner', 'D': 'beginner', 'A': 'beginner', 'E': 'beginner',
  'Am': 'beginner', 'Em': 'beginner', 'Dm': 'beginner',
  'A7': 'beginner', 'D7': 'beginner', 'E7': 'beginner', 'G7': 'beginner',
  'Asus2': 'beginner', 'Asus4': 'beginner', 'Dsus2': 'beginner', 'Dsus4': 'beginner',
  'Em7': 'beginner', 'Am7': 'beginner',

  // Intermediate - Some barre chords, extended chords
  'F': 'intermediate', 'B': 'intermediate', 'Bm': 'intermediate',
  'C7': 'intermediate', 'B7': 'intermediate', 'F7': 'intermediate',
  'Cmaj7': 'intermediate', 'Dmaj7': 'intermediate', 'Emaj7': 'intermediate',
  'Fmaj7': 'intermediate', 'Gmaj7': 'intermediate', 'Amaj7': 'intermediate',
  'Dm7': 'intermediate', 'Bm7': 'intermediate',
  'Csus2': 'intermediate', 'Csus4': 'intermediate', 'Esus4': 'intermediate',
  'Caug': 'intermediate', 'Daug': 'intermediate', 'Eaug': 'intermediate',
  'Ddim': 'intermediate', 'Edim': 'intermediate',

  // Advanced - Complex barre, jazz chords
  'Cm': 'advanced', 'Fm': 'advanced', 'Gm': 'advanced',
  'Bmaj7': 'advanced', 'Cm7': 'advanced', 'Fm7': 'advanced', 'Gm7': 'advanced',
  'Cdim': 'advanced',
  'C9': 'advanced', 'D9': 'advanced', 'E9': 'advanced', 'G9': 'advanced', 'A9': 'advanced'
};

// Global state
let currentChord = null;
let currentCapo = 0;
let audioContext = null;
let multiChordMode = false;
let selectedChords = [];
let currentKey = 'C';
let leftHandedMode = false;
let arpeggioMode = false;
let soundEnabled = true;

// Note frequencies (A4 = 440Hz standard tuning)
const TUNING = {
  6: 82.41,   // E2
  5: 110.00,  // A2
  4: 146.83,  // D3
  3: 196.00,  // G3
  2: 246.94,  // B3
  1: 329.63   // E4
};

// Storage key for favorite chords
const FAVORITES_KEY = 'guitar_chord_favorites_';

// Initialize
document.addEventListener('DOMContentLoaded', function () {
  populateQuickChords();
  populateChordTypes();
  setupSearchAutocomplete();
  setupKeyboardShortcuts();
  loadUserPreferences();

  // Load chord from URL if shared link
  loadChordFromUrl();
});

// Setup keyboard shortcuts
function setupKeyboardShortcuts() {
  document.addEventListener('keydown', function (e) {
    // Ignore if user is typing in an input
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.tagName === 'SELECT') {
      return;
    }

    const key = e.key.toUpperCase();

    // Single letter chord shortcuts (A-G)
    if (/^[A-G]$/.test(key) && !e.ctrlKey && !e.metaKey && !e.altKey) {
      e.preventDefault();
      // Check for modifier with shift for minor chords
      if (e.shiftKey) {
        const minorChord = key + 'm';
        if (CHORD_DATABASE[minorChord]) {
          displayChord(minorChord);
          if (typeof ToolUtils !== 'undefined') {
            ToolUtils.showToast(`Shortcut: ${minorChord}`, 1500, 'info');
          }
        }
      } else {
        if (CHORD_DATABASE[key]) {
          displayChord(key);
          if (typeof ToolUtils !== 'undefined') {
            ToolUtils.showToast(`Shortcut: ${key}`, 1500, 'info');
          }
        }
      }
    }

    // Space bar to play chord
    if (e.key === ' ' && currentChord) {
      e.preventDefault();
      playChord();
    }

    // L for left-handed mode toggle
    if (key === 'L' && !e.shiftKey && !e.ctrlKey) {
      e.preventDefault();
      toggleLeftHandedMode();
    }

    // P for arpeggio/strum toggle
    if (key === 'P' && !e.shiftKey && !e.ctrlKey) {
      e.preventDefault();
      toggleArpeggioMode();
    }

    // M for mute/unmute
    if (key === 'M' && !e.shiftKey && !e.ctrlKey) {
      e.preventDefault();
      toggleSound();
    }
  });
}

// Load user preferences from localStorage
function loadUserPreferences() {
  if (typeof ToolUtils !== 'undefined') {
    const prefs = ToolUtils.storage.get('guitar_preferences');
    if (prefs) {
      leftHandedMode = prefs.leftHanded || false;
      arpeggioMode = prefs.arpeggio || false;
      soundEnabled = prefs.sound !== false;

      // Update UI toggles
      updateToggleUI();
    }
  }
}

// Save user preferences
function saveUserPreferences() {
  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.storage.save('guitar_preferences', {
      leftHanded: leftHandedMode,
      arpeggio: arpeggioMode,
      sound: soundEnabled
    });
  }
}

// Update toggle UI states
function updateToggleUI() {
  const leftHandedToggle = document.getElementById('leftHandedToggle');
  const arpeggioToggle = document.getElementById('arpeggioToggle');
  const soundToggle = document.getElementById('soundToggle');

  if (leftHandedToggle) leftHandedToggle.checked = leftHandedMode;
  if (arpeggioToggle) arpeggioToggle.checked = arpeggioMode;
  if (soundToggle) soundToggle.checked = soundEnabled;
}

// Populate quick access chord buttons
function populateQuickChords() {
  const quickChords = ['C', 'G', 'D', 'Am', 'Em', 'F', 'A', 'E', 'Dm'];
  const container = document.getElementById('quickChords');
  if (!container) return;

  quickChords.forEach(chord => {
    const btn = document.createElement('button');
    btn.className = 'quick-chord-btn';
    btn.textContent = chord;
    btn.onclick = () => displayChord(chord);
    container.appendChild(btn);
  });
}

// Setup chord search with autocomplete
function setupSearchAutocomplete() {
  const searchInput = document.getElementById('chordInput');
  if (!searchInput) return;

  const allChords = Object.keys(CHORD_DATABASE);

  // Use debounce from ToolUtils if available
  const debouncedSearch = typeof ToolUtils !== 'undefined'
    ? ToolUtils.debounce(function (query) {
        if (query.length > 0) {
          const matches = allChords.filter(c => c.toLowerCase().startsWith(query.toLowerCase()));
          // Could implement dropdown here
        }
      }, 150)
    : function () {};

  searchInput.addEventListener('input', function () {
    const query = this.value.trim();
    debouncedSearch(query);
  });

  searchInput.addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
      searchChord();
    }
  });
}

// Search chord function called by button
window.searchChord = function () {
  const searchInput = document.getElementById('chordInput');
  const chord = searchInput.value.trim();

  if (CHORD_DATABASE[chord]) {
    displayChord(chord);
  } else {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast(`Chord "${chord}" not found. Try: C, Am, G7, Dsus4`, 3000, 'warning');
    } else {
      alert(`Chord "${chord}" not found. Try: C, D, E, F, G, A, B, Am, Em, C7, Dm, etc.`);
    }
  }
};

// Populate chord type buttons
function populateChordTypes() {
  const types = [
    { name: 'Major', type: 'major' },
    { name: 'Minor', type: 'minor' },
    { name: '7th', type: '7th' },
    { name: 'Sus', type: 'sus' },
    { name: 'Dim', type: 'dim' },
    { name: 'Aug', type: 'aug' }
  ];

  const container = document.getElementById('chordTypes');
  if (!container) return;

  types.forEach(t => {
    const btn = document.createElement('button');
    btn.className = 'btn btn-outline-secondary btn-sm';
    btn.textContent = t.name;
    btn.onclick = () => filterAndDisplay(t.type);
    container.appendChild(btn);
  });
}

// Filter and display first chord of type
function filterAndDisplay(type) {
  const matchingChords = filterChordsByType(type);
  if (matchingChords.length > 0) {
    displayChord(matchingChords[0]);
  }
}

// Filter chords by type
function filterChordsByType(type) {
  return Object.keys(CHORD_DATABASE).filter(chord => {
    switch (type) {
      case 'major': return /^[A-G]$/.test(chord);
      case 'minor': return chord.endsWith('m') && !chord.includes('7');
      case '7th': return chord.includes('7');
      case 'sus': return chord.includes('sus');
      case 'dim': return chord.includes('dim');
      case 'aug': return chord.includes('aug');
      default: return true;
    }
  });
}

// Main function to display a chord
window.displayChord = function (chordName) {
  if (!CHORD_DATABASE[chordName]) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast(`Chord "${chordName}" not found`, 2000, 'error');
    }
    return;
  }

  // Multi-chord mode: add to selection
  if (multiChordMode) {
    addChordToSelection(chordName);
    return;
  }

  // Single chord mode
  currentChord = chordName;
  const chordData = CHORD_DATABASE[chordName];

  // Hide welcome section and show chord display
  const welcomeSection = document.getElementById('welcomeInstructions');
  if (welcomeSection) {
    welcomeSection.style.display = 'none';
  }

  const chordDisplay = document.getElementById('chordDisplay');
  if (chordDisplay) {
    chordDisplay.style.display = 'block';
  }

  // Update chord name display with difficulty badge
  const chordNameElem = document.getElementById('chordName');
  if (chordNameElem) {
    chordNameElem.textContent = chordData.name;
  }

  // Update difficulty badge
  const difficultyBadge = document.getElementById('difficultyBadge');
  if (difficultyBadge) {
    const difficulty = CHORD_DIFFICULTY[chordName] || 'intermediate';
    difficultyBadge.textContent = difficulty.charAt(0).toUpperCase() + difficulty.slice(1);
    difficultyBadge.className = `difficulty-badge difficulty-${difficulty}`;
  }

  // Draw fretboard
  drawFretboard(chordData);

  // Update finger positions text
  updateFingerPositions(chordData);

  // Load alternative fingerings
  loadAlternatives(chordName);

  // Update capo display if capo is active
  if (currentCapo > 0) {
    updateCapo(currentCapo);
  }
};

// Toggle multi-chord mode
window.toggleMultiChordMode = function () {
  const checkbox = document.getElementById('multiChordMode');
  multiChordMode = checkbox.checked;

  const selectedChordsBar = document.getElementById('selectedChordsBar');
  const singleChordDisplay = document.getElementById('chordDisplay');
  const multiChordDisplay = document.getElementById('multiChordDisplay');
  const welcomeSection = document.getElementById('welcomeInstructions');

  if (multiChordMode) {
    // Enable multi-chord mode
    selectedChordsBar.style.display = 'block';
    singleChordDisplay.style.display = 'none';

    if (selectedChords.length > 0) {
      multiChordDisplay.style.display = 'block';
      welcomeSection.style.display = 'none';
      renderMultiChordDisplay();
    } else {
      multiChordDisplay.style.display = 'none';
      welcomeSection.style.display = 'block';
    }
  } else {
    // Disable multi-chord mode
    selectedChordsBar.style.display = 'none';
    multiChordDisplay.style.display = 'none';

    if (currentChord) {
      singleChordDisplay.style.display = 'block';
      welcomeSection.style.display = 'none';
    } else {
      singleChordDisplay.style.display = 'none';
      welcomeSection.style.display = 'block';
    }
  }
};

// Add chord to multi-chord selection
function addChordToSelection(chordName) {
  if (selectedChords.includes(chordName)) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast(`${chordName} is already selected`, 2000, 'info');
    }
    return;
  }

  if (selectedChords.length >= 6) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('Maximum 6 chords can be compared at once', 2000, 'warning');
    }
    return;
  }

  selectedChords.push(chordName);
  updateSelectedChordsList();
  renderMultiChordDisplay();

  // Hide welcome, show multi-chord display
  document.getElementById('welcomeInstructions').style.display = 'none';
  document.getElementById('multiChordDisplay').style.display = 'block';
}

// Update selected chords list display
function updateSelectedChordsList() {
  const container = document.getElementById('selectedChordsList');
  container.innerHTML = '';

  selectedChords.forEach(chordName => {
    const tag = document.createElement('span');
    tag.className = 'selected-chord-tag';
    tag.innerHTML = `${chordName} <span class="remove-chord" onclick="removeChordFromSelection('${chordName}')">×</span>`;
    container.appendChild(tag);
  });
}

// Remove chord from selection
window.removeChordFromSelection = function (chordName) {
  selectedChords = selectedChords.filter(c => c !== chordName);
  updateSelectedChordsList();
  renderMultiChordDisplay();

  if (selectedChords.length === 0) {
    document.getElementById('multiChordDisplay').style.display = 'none';
    document.getElementById('welcomeInstructions').style.display = 'block';
  }
};

// Clear all selected chords
window.clearAllChords = function () {
  selectedChords = [];
  updateSelectedChordsList();
  document.getElementById('multiChordDisplay').style.display = 'none';
  document.getElementById('welcomeInstructions').style.display = 'block';
};

// Render multi-chord display grid
function renderMultiChordDisplay() {
  const grid = document.getElementById('multiChordGrid');
  grid.innerHTML = '';

  selectedChords.forEach(chordName => {
    const chordData = CHORD_DATABASE[chordName];
    if (!chordData) return;

    const card = document.createElement('div');
    card.className = 'multi-chord-card';
    card.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2">
        <div class="chord-info flex-grow-1">
          <h4>${chordData.name}</h4>
        </div>
        <button class="play-btn ms-2" onclick="playSpecificChord('${chordName}')" title="Play ${chordName}">
          ▶
        </button>
      </div>
      <div class="fretboard">
        <svg id="fretboard-${chordName}" class="fretboard-svg" viewBox="0 0 300 350"></svg>
      </div>
      <div class="finger-positions mt-2">
        <div id="fingers-${chordName}" style="font-size: 0.75rem;"></div>
      </div>
    `;
    grid.appendChild(card);

    // Draw fretboard for this chord
    setTimeout(() => {
      drawFretboardForElement(chordData, `fretboard-${chordName}`);
      updateFingerPositionsForElement(chordData, `fingers-${chordName}`);
    }, 10);
  });
}

// Draw fretboard for specific element
function drawFretboardForElement(chordData, elementId) {
  const svg = document.getElementById(elementId);
  if (!svg) return;

  svg.innerHTML = ''; // Clear previous

  const width = 300;
  const height = 250;
  const stringSpacing = 45;
  const fretSpacing = 40;
  const startX = 30;
  const startY = 40;

  const numStrings = 6;
  const numFrets = 5;

  // Draw strings (vertical lines)
  for (let i = 0; i < numStrings; i++) {
    const x = startX + (numStrings - 1 - i) * stringSpacing;
    const line = createSVGElement('line', {
      x1: x, y1: startY,
      x2: x, y2: startY + numFrets * fretSpacing,
      stroke: '#333',
      'stroke-width': i === 0 || i === numStrings - 1 ? 2 : 1.5
    });
    svg.appendChild(line);
  }

  // Draw frets (horizontal lines)
  for (let i = 0; i <= numFrets; i++) {
    const y = startY + i * fretSpacing;
    const line = createSVGElement('line', {
      x1: startX, y1: y,
      x2: startX + (numStrings - 1) * stringSpacing, y2: y,
      stroke: i === 0 ? '#000' : '#333',
      'stroke-width': i === 0 ? 4 : 2
    });
    svg.appendChild(line);
  }

  // Draw open/muted indicators
  for (let i = 0; i < numStrings; i++) {
    const x = startX + (numStrings - 1 - i) * stringSpacing;
    const fret = chordData.frets[i];

    if (fret === 0) {
      // Open string (O)
      const circle = createSVGElement('circle', {
        cx: x, cy: startY - 15,
        r: 8,
        fill: 'none',
        stroke: '#28a745',
        'stroke-width': 2
      });
      svg.appendChild(circle);
    } else if (fret === -1) {
      // Muted string (X)
      const text = createSVGElement('text', {
        x: x, y: startY - 8,
        'font-size': 18,
        'font-weight': 'bold',
        fill: '#dc3545',
        'text-anchor': 'middle'
      });
      text.textContent = '×';
      svg.appendChild(text);
    }
  }

  // Draw finger positions
  chordData.fingers.forEach(([string, fret, finger]) => {
    if (fret > 0 && fret <= numFrets) {
      const x = startX + (string - 1) * stringSpacing;
      const y = startY + fret * fretSpacing - fretSpacing / 2;

      // Finger circle
      const circle = createSVGElement('circle', {
        cx: x, cy: y,
        r: 12,
        fill: '#007bff',
        stroke: '#fff',
        'stroke-width': 2
      });
      svg.appendChild(circle);

      // Finger number
      const text = createSVGElement('text', {
        x: x, y: y + 5,
        'font-size': 14,
        'font-weight': 'bold',
        fill: '#fff',
        'text-anchor': 'middle'
      });
      text.textContent = finger;
      svg.appendChild(text);
    }
  });
}

// Update finger positions for specific element
function updateFingerPositionsForElement(chordData, elementId) {
  const container = document.getElementById(elementId);
  if (!container) return;

  container.innerHTML = '';

  const stringNames = ['E', 'A', 'D', 'G', 'B', 'E'];
  const fingerNames = ['', 'Index', 'Middle', 'Ring', 'Pinky'];

  chordData.fingers.forEach(([string, fret, finger]) => {
    if (fret > 0) {
      const text = document.createElement('div');
      text.style.fontSize = '0.75rem';
      text.style.color = '#666';
      text.innerHTML = `${fingerNames[finger]}: ${stringNames[string - 1]} string, fret ${fret}`;
      container.appendChild(text);
    }
  });
}

// Play specific chord in multi-chord mode
window.playSpecificChord = function (chordName) {
  const tempChord = currentChord;
  currentChord = chordName;
  playChord();
  currentChord = tempChord;
};

// Play all selected chords in sequence
window.playAllChords = function () {
  if (selectedChords.length === 0) return;

  let delay = 0;
  selectedChords.forEach((chordName, index) => {
    setTimeout(() => {
      playSpecificChord(chordName);
    }, delay);
    delay += 2500; // 2.5 seconds between chords
  });
};

// Draw fretboard diagram using SVG
function drawFretboard(chordData) {
  const svg = document.getElementById('fretboardSvg');
  if (!svg) return;

  svg.innerHTML = ''; // Clear previous

  const width = 300;
  const height = 250;
  const stringSpacing = 45;
  const fretSpacing = 40;
  const startX = 30;
  const startY = 40;

  const numStrings = 6;
  const numFrets = 5;

  // Helper function to calculate X position based on handedness
  const getStringX = (stringIndex) => {
    if (leftHandedMode) {
      return startX + stringIndex * stringSpacing;
    } else {
      return startX + (numStrings - 1 - stringIndex) * stringSpacing;
    }
  };

  // Draw strings (vertical lines)
  for (let i = 0; i < numStrings; i++) {
    const x = getStringX(i);
    const line = createSVGElement('line', {
      x1: x, y1: startY,
      x2: x, y2: startY + numFrets * fretSpacing,
      stroke: '#333',
      'stroke-width': i === 0 || i === numStrings - 1 ? 2 : 1.5
    });
    svg.appendChild(line);
  }

  // Draw frets (horizontal lines)
  for (let i = 0; i <= numFrets; i++) {
    const y = startY + i * fretSpacing;
    const line = createSVGElement('line', {
      x1: startX, y1: y,
      x2: startX + (numStrings - 1) * stringSpacing, y2: y,
      stroke: i === 0 ? '#000' : '#333',
      'stroke-width': i === 0 ? 4 : 2
    });
    svg.appendChild(line);
  }

  // Draw fret numbers
  for (let i = 1; i <= numFrets; i++) {
    const y = startY + i * fretSpacing - fretSpacing / 2;
    const fretNumX = leftHandedMode ? startX + (numStrings - 1) * stringSpacing + 20 : startX - 20;
    const text = createSVGElement('text', {
      x: fretNumX,
      y: y + 5,
      'font-size': 14,
      'font-weight': 'bold',
      fill: '#666',
      'text-anchor': leftHandedMode ? 'start' : 'end'
    });
    text.textContent = i;
    svg.appendChild(text);
  }

  // Draw open/muted indicators
  for (let i = 0; i < numStrings; i++) {
    const x = getStringX(i);
    const fret = chordData.frets[i];

    if (fret === 0) {
      // Open string (O)
      const circle = createSVGElement('circle', {
        cx: x, cy: startY - 15,
        r: 8,
        fill: 'none',
        stroke: '#28a745',
        'stroke-width': 2
      });
      svg.appendChild(circle);
    } else if (fret === -1) {
      // Muted string (X)
      const text = createSVGElement('text', {
        x: x, y: startY - 8,
        'font-size': 18,
        'font-weight': 'bold',
        fill: '#dc3545',
        'text-anchor': 'middle'
      });
      text.textContent = '×';
      svg.appendChild(text);
    }
  }

  // Draw finger positions
  chordData.fingers.forEach(([string, fret, finger]) => {
    if (fret > 0 && fret <= numFrets) {
      const x = leftHandedMode ? startX + (numStrings - string) * stringSpacing : startX + (string - 1) * stringSpacing;
      const y = startY + fret * fretSpacing - fretSpacing / 2;

      // Finger circle
      const circle = createSVGElement('circle', {
        cx: x, cy: y,
        r: 12,
        fill: chordData.barre && finger === 1 ? '#ffc107' : '#007bff',
        stroke: '#fff',
        'stroke-width': 2
      });
      svg.appendChild(circle);

      // Finger number
      const text = createSVGElement('text', {
        x: x, y: y + 5,
        'font-size': 14,
        'font-weight': 'bold',
        fill: '#fff',
        'text-anchor': 'middle'
      });
      text.textContent = finger;
      svg.appendChild(text);
    }
  });

  // Draw barre line if applicable
  if (chordData.barre) {
    const barreFingers = chordData.fingers.filter(f => f[2] === 1);
    if (barreFingers.length > 1) {
      const minString = Math.min(...barreFingers.map(f => f[0]));
      const maxString = Math.max(...barreFingers.map(f => f[0]));
      const barreFret = barreFingers[0][1];

      const x1 = leftHandedMode ? startX + (numStrings - minString) * stringSpacing : startX + (minString - 1) * stringSpacing;
      const x2 = leftHandedMode ? startX + (numStrings - maxString) * stringSpacing : startX + (maxString - 1) * stringSpacing;
      const y = startY + barreFret * fretSpacing - fretSpacing / 2;

      const line = createSVGElement('line', {
        x1: Math.min(x1, x2), y1: y,
        x2: Math.max(x1, x2), y2: y,
        stroke: '#ffc107',
        'stroke-width': 22,
        'stroke-linecap': 'round',
        opacity: 0.7
      });
      svg.insertBefore(line, svg.firstChild);
    }
  }
}

// Helper to create SVG elements
function createSVGElement(tag, attrs) {
  const elem = document.createElementNS('http://www.w3.org/2000/svg', tag);
  for (let key in attrs) {
    elem.setAttribute(key, attrs[key]);
  }
  return elem;
}

// Update finger positions text guide
function updateFingerPositions(chordData) {
  const container = document.getElementById('fingerGuide');
  if (!container) return;

  container.innerHTML = '';

  const stringNames = ['6th (E)', '5th (A)', '4th (D)', '3rd (G)', '2nd (B)', '1st (E)'];
  const fingerNames = ['', 'Index', 'Middle', 'Ring', 'Pinky'];

  chordData.fingers.forEach(([string, fret, finger]) => {
    if (fret > 0) {
      const text = document.createElement('div');
      text.className = 'small text-muted';
      text.innerHTML = `${fingerNames[finger]} finger: ${stringNames[string - 1]} string, fret ${fret}`;
      container.appendChild(text);
    }
  });

  // Add open strings
  chordData.frets.forEach((fret, index) => {
    if (fret === 0) {
      const text = document.createElement('div');
      text.className = 'small text-success';
      text.innerHTML = `${stringNames[index]} - Open (play without fretting)`;
      container.appendChild(text);
    } else if (fret === -1) {
      const text = document.createElement('div');
      text.className = 'small text-danger';
      text.innerHTML = `${stringNames[index]} - Muted (don't play)`;
      container.appendChild(text);
    }
  });
}

// Load alternative fingerings
function loadAlternatives(chordName) {
  const container = document.getElementById('variationGrid');
  if (!container) return;

  container.innerHTML = '';

  const alternatives = CHORD_ALTERNATIVES[chordName];
  if (alternatives && alternatives.length > 1) {
    alternatives.forEach((alt, index) => {
      const card = document.createElement('div');
      card.className = 'card h-100';
      card.style.cursor = 'pointer';
      card.onclick = () => displayAlternative(chordName, index);

      card.innerHTML = `
        <div class="card-body text-center p-2">
          <strong class="small">${alt.name}</strong>
          <div class="small text-muted">Position ${index + 1}</div>
        </div>
      `;
      container.appendChild(card);
    });
  } else {
    // Show message if no alternatives
    container.innerHTML = '<p class="text-muted small">No alternative fingerings available for this chord.</p>';
  }
}

// Display alternative fingering
function displayAlternative(chordName, altIndex) {
  const alternatives = CHORD_ALTERNATIVES[chordName];
  if (alternatives && alternatives[altIndex]) {
    const altData = alternatives[altIndex];
    drawFretboard(altData);
    updateFingerPositions(altData);
  }
}

// Play chord audio
window.playChord = function () {
  // Check if sound is enabled
  if (!soundEnabled) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('Sound is muted. Press M to unmute.', 1500, 'info');
    }
    return;
  }

  if (!currentChord) {
    console.log('No chord selected');
    return;
  }

  const chordData = CHORD_DATABASE[currentChord];
  if (!chordData) {
    console.log('Chord data not found');
    return;
  }

  // Visual feedback
  const playBtn = document.querySelector('.play-btn');
  if (playBtn) {
    playBtn.style.opacity = '0.6';
    setTimeout(() => { playBtn.style.opacity = '1'; }, 300);
  }

  try {
    // Create audio context if needed
    if (!audioContext) {
      audioContext = new (window.AudioContext || window.webkitAudioContext)();
      console.log('Audio context created');
    }

    // Resume audio context if suspended (required by modern browsers)
    if (audioContext.state === 'suspended') {
      console.log('Audio context suspended, resuming...');
      audioContext.resume().then(() => {
        console.log('Audio context resumed successfully');
        playChordNotes(chordData);
      }).catch(err => {
        console.error('Failed to resume audio context:', err);
      });
    } else {
      console.log('Audio context ready, playing...');
      playChordNotes(chordData);
    }
  } catch (error) {
    console.error('Error playing chord:', error);
    alert('Unable to play audio. Your browser may not support Web Audio API.');
  }
};

// Separate function to play the actual notes
function playChordNotes(chordData) {
  const now = audioContext.currentTime;
  // Arpeggio mode: longer delay between notes, Strum mode: quick strum
  const strumDelay = arpeggioMode ? 0.4 : 0.05; // 400ms for arpeggio, 50ms for strum
  const noteDuration = arpeggioMode ? 1.5 : 2.0;

  console.log('Playing chord:', currentChord, arpeggioMode ? '(arpeggio)' : '(strum)');

  chordData.frets.forEach((fret, index) => {
    if (fret >= 0) { // Not muted
      const stringNumber = index + 1;
      const baseFreq = TUNING[stringNumber];
      const frequency = baseFreq * Math.pow(2, (fret + currentCapo) / 12);

      console.log(`String ${stringNumber}: fret ${fret}, frequency ${frequency}Hz`);
      playNote(frequency, now + index * strumDelay, noteDuration);
    }
  });
}

// Play individual note with Web Audio API
function playNote(frequency, startTime, duration) {
  const oscillator = audioContext.createOscillator();
  const gainNode = audioContext.createGain();

  oscillator.connect(gainNode);
  gainNode.connect(audioContext.destination);

  oscillator.frequency.value = frequency;
  oscillator.type = 'triangle'; // Guitar-like tone

  // ADSR envelope (simplified)
  gainNode.gain.setValueAtTime(0, startTime);
  gainNode.gain.linearRampToValueAtTime(0.3, startTime + 0.01); // Attack
  gainNode.gain.exponentialRampToValueAtTime(0.1, startTime + 0.1); // Decay
  gainNode.gain.exponentialRampToValueAtTime(0.01, startTime + duration); // Release

  oscillator.start(startTime);
  oscillator.stop(startTime + duration);
}

// Update capo position
window.updateCapo = function (value) {
  currentCapo = parseInt(value);
  const display = document.getElementById('capoDisplay');

  if (display) {
    if (currentCapo === 0) {
      display.textContent = 'No Capo';
    } else {
      display.textContent = `Capo on Fret ${currentCapo}`;
    }
  }

  // Transpose chord name display
  const chordNameElem = document.getElementById('chordName');
  if (currentChord && chordNameElem) {
    if (currentCapo > 0) {
      const transposed = transposeChord(currentChord, currentCapo);
      chordNameElem.textContent = `${CHORD_DATABASE[currentChord].name} (sounds like ${transposed})`;
    } else {
      chordNameElem.textContent = CHORD_DATABASE[currentChord].name;
    }
  }
};

// Transpose chord with capo
function transposeChord(chordName, semitones) {
  const notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  const flatToSharp = { 'Db': 'C#', 'Eb': 'D#', 'Gb': 'F#', 'Ab': 'G#', 'Bb': 'A#' };

  // Extract root note and suffix
  let root = chordName.match(/^[A-G][b#]?/)[0];
  const suffix = chordName.slice(root.length);

  // Convert flats to sharps
  root = flatToSharp[root] || root;

  // Find index and transpose
  const index = notes.indexOf(root);
  if (index === -1) return chordName;

  const newIndex = (index + semitones) % 12;
  return notes[newIndex] + suffix;
}

// Download chord diagram as image
window.downloadDiagram = function () {
  const svg = document.getElementById('fretboardSvg');
  const svgData = new XMLSerializer().serializeToString(svg);
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');

  canvas.width = 300;
  canvas.height = 250;

  const img = new Image();
  const svgBlob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' });
  const url = URL.createObjectURL(svgBlob);

  img.onload = function () {
    ctx.fillStyle = '#fff';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(img, 0, 0);

    canvas.toBlob(function (blob) {
      const a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      const filename = `8gwifi.org-${currentChord}-chord-diagram.png`;
      a.download = filename;
      a.click();
      URL.revokeObjectURL(url);

      // Show toast and support popup
      if (typeof ToolUtils !== 'undefined') {
        ToolUtils.showToast(`Downloaded ${currentChord} chord diagram!`, 2000, 'success');
        setTimeout(() => {
          ToolUtils.showSupportPopup('Guitar Chord Finder', `Downloaded: ${filename}`);
        }, 500);
      }
    });
  };

  img.src = url;
};

// ============================================
// Tool Utils Integration - Shareable URLs, Favorites, Copy
// ============================================

// Load chord from URL parameters (for shared links)
function loadChordFromUrl() {
  if (typeof ToolUtils === 'undefined') return;

  const urlParams = new URLSearchParams(window.location.search);
  const chord = urlParams.get('chord');
  const capo = urlParams.get('capo');

  if (chord && CHORD_DATABASE[chord]) {
    // Set capo first if provided
    if (capo) {
      const capoValue = parseInt(capo);
      if (capoValue >= 0 && capoValue <= 12) {
        document.getElementById('capoSlider').value = capoValue;
        updateCapo(capoValue);
      }
    }
    // Display the chord
    displayChord(chord);
    ToolUtils.showToast(`Loaded shared chord: ${chord}`, 2000, 'info');
  }
}

// Share current chord via URL
window.shareChord = function () {
  if (!currentChord) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('Select a chord first to share', 2000, 'warning');
    }
    return;
  }

  const params = { chord: currentChord };
  if (currentCapo > 0) {
    params.capo = currentCapo;
  }

  if (typeof ToolUtils !== 'undefined') {
    const url = ToolUtils.generateShareUrl(params, {
      toolName: 'Guitar Chord Finder',
      showSupportPopup: true
    });
    ToolUtils.copyToClipboard(url, {
      toastMessage: `Share link copied for ${currentChord}!`,
      showSupportPopup: false // Already shown by generateShareUrl
    });
  }
};

// Copy chord fingering info to clipboard
window.copyChordInfo = function () {
  if (!currentChord) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('Select a chord first', 2000, 'warning');
    }
    return;
  }

  const chordData = CHORD_DATABASE[currentChord];
  const fretString = chordData.frets.map(f => f === -1 ? 'x' : f).join('');
  const stringNames = ['E', 'A', 'D', 'G', 'B', 'e'];
  const fingerNames = ['', '1', '2', '3', '4'];

  let info = `${chordData.name}\n`;
  info += `Frets: ${fretString}\n`;
  info += `Strings: ${stringNames.join(' ')}\n`;
  info += `\nFinger positions:\n`;

  chordData.fingers.forEach(([string, fret, finger]) => {
    if (fret > 0) {
      info += `  ${stringNames[string - 1]} string, fret ${fret} - finger ${fingerNames[finger]}\n`;
    }
  });

  info += `\n🎸 via 8gwifi.org Guitar Chord Finder`;

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.copyToClipboard(info, {
      toastMessage: `${currentChord} chord info copied!`,
      toolName: 'Guitar Chord Finder'
    });
  }
};

// Save chord to favorites
window.saveFavorite = function (chordName) {
  const chord = chordName || currentChord;
  if (!chord) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('Select a chord first', 2000, 'warning');
    }
    return;
  }

  if (typeof ToolUtils !== 'undefined') {
    const favorites = ToolUtils.storage.get('guitar_favorites') || [];
    if (!favorites.includes(chord)) {
      favorites.push(chord);
      ToolUtils.storage.save('guitar_favorites', favorites);
      ToolUtils.showToast(`${chord} added to favorites! ⭐`, 2000, 'success');
    } else {
      ToolUtils.showToast(`${chord} is already in favorites`, 2000, 'info');
    }
  }
};

// Remove chord from favorites
window.removeFavorite = function (chordName) {
  if (typeof ToolUtils !== 'undefined') {
    let favorites = ToolUtils.storage.get('guitar_favorites') || [];
    favorites = favorites.filter(c => c !== chordName);
    ToolUtils.storage.save('guitar_favorites', favorites);
    ToolUtils.showToast(`${chordName} removed from favorites`, 2000, 'info');
    renderFavoritesPanel();
  }
};

// Get favorites list
window.getFavorites = function () {
  if (typeof ToolUtils !== 'undefined') {
    return ToolUtils.storage.get('guitar_favorites') || [];
  }
  return [];
};

// Render favorites in UI (can be called to update favorites display)
window.renderFavoritesPanel = function () {
  const container = document.getElementById('favoritesContainer');
  if (!container) return;

  const favorites = getFavorites();

  if (favorites.length === 0) {
    container.innerHTML = '<p class="text-muted small">No favorites saved yet. Click ⭐ to save chords.</p>';
    return;
  }

  container.innerHTML = '';
  favorites.forEach(chord => {
    const btn = document.createElement('button');
    btn.className = 'quick-chord-btn favorite-chord';
    btn.innerHTML = `${chord} <span class="remove-fav" onclick="event.stopPropagation(); removeFavorite('${chord}')">×</span>`;
    btn.onclick = () => displayChord(chord);
    container.appendChild(btn);
  });
};

// Open favorites manager modal
window.openFavoritesManager = function () {
  if (typeof ToolUtils !== 'undefined') {
    const favorites = getFavorites();

    if (favorites.length === 0) {
      ToolUtils.showToast('No favorites saved yet. Click ⭐ on a chord to save it.', 3000, 'info');
      return;
    }

    // Use ToolUtils storage manager pattern
    const backdrop = document.createElement('div');
    backdrop.className = 'storage-modal-backdrop';
    backdrop.innerHTML = `
      <div class="storage-modal">
        <div class="storage-header">
          <h3>⭐ Favorite Chords</h3>
          <button class="storage-close" onclick="this.closest('.storage-modal-backdrop').remove()">&times;</button>
        </div>
        <div class="storage-body">
          <div class="storage-list">
            ${favorites.map(chord => `
              <div class="storage-item">
                <div class="storage-info">
                  <span class="storage-name">${chord}</span>
                  <span class="storage-date">${CHORD_DATABASE[chord]?.name || chord}</span>
                </div>
                <div class="storage-actions">
                  <button class="storage-btn load-btn" onclick="displayChord('${chord}'); this.closest('.storage-modal-backdrop').remove();">Load</button>
                  <button class="storage-btn delete-btn" onclick="removeFavorite('${chord}'); this.closest('.storage-item').remove();">&times;</button>
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      </div>
    `;

    document.body.appendChild(backdrop);
    setTimeout(() => backdrop.classList.add('show'), 10);

    backdrop.onclick = (e) => {
      if (e.target === backdrop) backdrop.remove();
    };
  }
};

// ============================================
// CHORD PROGRESSIONS FUNCTIONS
// ============================================

// Change the selected key
window.changeKey = function (key) {
  if (KEYS_DATABASE[key]) {
    currentKey = key;
    renderProgressions();
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast(`Key changed to ${key} Major`, 1500, 'info');
    }
  }
};

// Get chords for a progression in current key
function getProgressionChords(numerals) {
  const keyChords = KEYS_DATABASE[currentKey];
  if (!keyChords) return [];

  return numerals.map(numeral => {
    const chord = keyChords[numeral];
    // Check if chord exists in database, otherwise try to find alternative
    if (chord && CHORD_DATABASE[chord]) {
      return chord;
    }
    // Handle sharp chords that might not be in database
    return chord || numeral;
  });
}

// Check if all chords in progression exist in database
function progressionIsPlayable(numerals) {
  const chords = getProgressionChords(numerals);
  return chords.every(chord => CHORD_DATABASE[chord]);
}

// Load a progression into multi-chord mode
window.loadProgression = function (progressionIndex) {
  const progression = PROGRESSIONS_DATABASE[progressionIndex];
  if (!progression) return;

  const chords = getProgressionChords(progression.numerals);

  // Check if all chords exist
  const missingChords = chords.filter(c => !CHORD_DATABASE[c]);
  if (missingChords.length > 0) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast(`Some chords not available: ${missingChords.join(', ')}. Try a different key.`, 3000, 'warning');
    }
    return;
  }

  // Enable multi-chord mode
  const multiChordCheckbox = document.getElementById('multiChordMode');
  if (multiChordCheckbox && !multiChordCheckbox.checked) {
    multiChordCheckbox.checked = true;
    toggleMultiChordMode();
  }

  // Clear and load new chords (limit to 6)
  selectedChords = chords.slice(0, 6);
  updateSelectedChordsList();
  renderMultiChordDisplay();

  // Show display
  document.getElementById('welcomeInstructions').style.display = 'none';
  document.getElementById('multiChordDisplay').style.display = 'block';

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(`Loaded: ${progression.name} (${chords.slice(0, 6).join(' → ')})`, 3000, 'success');
  }
};

// Play a progression sequence
window.playProgression = function (progressionIndex) {
  const progression = PROGRESSIONS_DATABASE[progressionIndex];
  if (!progression) return;

  const chords = getProgressionChords(progression.numerals);
  const playableChords = chords.filter(c => CHORD_DATABASE[c]).slice(0, 6);

  if (playableChords.length === 0) {
    if (typeof ToolUtils !== 'undefined') {
      ToolUtils.showToast('No playable chords in this progression for this key', 2000, 'warning');
    }
    return;
  }

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(`Playing: ${progression.name}`, 2000, 'info');
  }

  let delay = 0;
  playableChords.forEach((chordName, index) => {
    setTimeout(() => {
      playSpecificChord(chordName);
    }, delay);
    delay += 2000; // 2 seconds between chords
  });
};

// Render progressions UI
window.renderProgressions = function () {
  const container = document.getElementById('progressionsContainer');
  if (!container) return;

  const keyChords = KEYS_DATABASE[currentKey];

  let html = '';

  PROGRESSIONS_DATABASE.forEach((prog, index) => {
    const chords = getProgressionChords(prog.numerals);
    const displayChords = chords.slice(0, 6); // Limit display to 6
    const isPlayable = progressionIsPlayable(prog.numerals.slice(0, 6));
    const hasMore = prog.numerals.length > 6;

    html += `
      <div class="progression-card ${isPlayable ? '' : 'disabled'}">
        <div class="progression-header">
          <span class="progression-name">${prog.name}</span>
          <span class="progression-genre">${prog.genre}</span>
        </div>
        <div class="progression-numerals">${prog.numerals.slice(0, 6).join(' - ')}${hasMore ? ' ...' : ''}</div>
        <div class="progression-chords">${displayChords.join(' → ')}${hasMore ? ' ...' : ''}</div>
        <div class="progression-description">${prog.description}</div>
        ${prog.songs && prog.songs.length > 0 ? `
          <div class="progression-songs">
            <strong>Songs:</strong> ${prog.songs.slice(0, 2).join(', ')}${prog.songs.length > 2 ? '...' : ''}
          </div>
        ` : ''}
        <div class="progression-actions">
          <button onclick="loadProgression(${index})" ${isPlayable ? '' : 'disabled'} title="Load chords into comparison view">
            <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
              <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
            </svg>
            Load
          </button>
          <button onclick="playProgression(${index})" ${isPlayable ? '' : 'disabled'} title="Play chord sequence">
            <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
              <path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393z"/>
            </svg>
            Play
          </button>
        </div>
      </div>
    `;
  });

  container.innerHTML = html;
};

// Initialize progressions on page load
document.addEventListener('DOMContentLoaded', function () {
  // Render progressions if container exists
  setTimeout(() => {
    renderProgressions();
  }, 100);
});

// ============================================
// QUICK WIN FEATURES: Toggle Functions
// ============================================

// Toggle left-handed mode
window.toggleLeftHandedMode = function () {
  leftHandedMode = !leftHandedMode;
  saveUserPreferences();

  // Update toggle UI
  const toggle = document.getElementById('leftHandedToggle');
  if (toggle) toggle.checked = leftHandedMode;

  // Redraw fretboard if a chord is selected
  if (currentChord) {
    const chordData = CHORD_DATABASE[currentChord];
    drawFretboard(chordData);
  }

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(leftHandedMode ? 'Left-handed mode ON 🎸' : 'Right-handed mode ON 🎸', 1500, 'info');
  }
};

// Toggle arpeggio mode
window.toggleArpeggioMode = function () {
  arpeggioMode = !arpeggioMode;
  saveUserPreferences();

  // Update toggle UI
  const toggle = document.getElementById('arpeggioToggle');
  if (toggle) toggle.checked = arpeggioMode;

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(arpeggioMode ? 'Arpeggio mode ON 🎵' : 'Strum mode ON 🎶', 1500, 'info');
  }
};

// Toggle sound on/off
window.toggleSound = function () {
  soundEnabled = !soundEnabled;
  saveUserPreferences();

  // Update toggle UI
  const toggle = document.getElementById('soundToggle');
  if (toggle) toggle.checked = soundEnabled;

  if (typeof ToolUtils !== 'undefined') {
    ToolUtils.showToast(soundEnabled ? 'Sound ON 🔊' : 'Sound OFF 🔇', 1500, 'info');
  }
};

// Get chord difficulty
window.getChordDifficulty = function (chordName) {
  return CHORD_DIFFICULTY[chordName] || 'intermediate';
};
