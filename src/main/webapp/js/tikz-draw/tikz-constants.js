// ============================================================================
// TikZ Draw - Constants
// ============================================================================

// Predefined TikZ colors
const TIKZ_COLORS = {
    black: '#000000',
    white: '#FFFFFF',
    red: '#FF0000',
    green: '#00FF00',
    blue: '#0000FF',
    cyan: '#00FFFF',
    magenta: '#FF00FF',
    yellow: '#FFFF00',
    orange: '#FF8000',
    purple: '#800080',
    brown: '#804000',
    gray: '#808080',
    lightgray: '#C0C0C0',
    darkgray: '#404040'
};

// Line thickness mapping
const THICKNESS_VALUES = {
    'ultra thin': 0.5,
    'very thin': 0.75,
    'thin': 1,
    'thick': 2,
    'very thick': 3,
    'ultra thick': 4
};

// TikZ patterns from patterns library
const TIKZ_PATTERNS = {
    'none': 'Solid',
    'horizontal lines': 'Horizontal Lines',
    'vertical lines': 'Vertical Lines',
    'north east lines': 'NE Lines',
    'north west lines': 'NW Lines',
    'grid': 'Grid',
    'crosshatch': 'Crosshatch',
    'dots': 'Dots',
    'crosshatch dots': 'Crosshatch Dots',
    'fivepointed stars': 'Stars',
    'sixpointed stars': '6-Point Stars',
    'bricks': 'Bricks',
    'checkerboard': 'Checkerboard'
};

// Object types
const TYPE_NAMES = {
    'coord': 'Point', 'line': 'Segment', 'vec': 'Vector',
    'circle': 'Circle', 'arc': 'Arc', 'rect': 'Rectangle',
    'path': 'Path', 'bezier': 'Bezier Curve', 'label': 'Label', 'image': 'Image', 'grid': 'Grid'
};

let objectIdCounter = 0;

function generateId(prefix = 'obj') {
    return `${prefix}_${++objectIdCounter}`;
}
