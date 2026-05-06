#!/usr/bin/env python3
"""
Generate a JSON trace of cube states using the rubiks-cube-NxNxN-solver
reference, so we can diff our JS applyMove against a known-correct oracle.

Run:
    python3 scratch-pyref.py > pyref-trace.json

The script picks several fixed scrambles, applies each to a solved 4×4 in
the reference solver, and dumps the resulting 96-sticker state in URFDLB
order — the same convention our cube.js uses.

Internal Python state layout (1-indexed, dummy at 0):
    state[1..16]   = U   stickers   (face index 0 in JS)
    state[17..32]  = L
    state[33..48]  = F
    state[49..64]  = R
    state[65..80]  = B
    state[81..96]  = D
We re-assemble in URFDLB to match cube.js.
"""

import json
import sys
import os

# Add the reference solver to the path so we can import it without needing
# pip install -e on it.
REF_PATH = os.path.expanduser('~/junk/rubiks-cube-NxNxN-solver')
sys.path.insert(0, REF_PATH)

from rubikscubennnsolver.RubiksCube444 import RubiksCube444  # noqa: E402

SOLVED = 'U' * 16 + 'R' * 16 + 'F' * 16 + 'D' * 16 + 'L' * 16 + 'B' * 16


def state_to_urfdlb(cube) -> str:
    """Re-pack cube.state (internal ULFRBD, 1-indexed) into URFDLB order."""
    s = cube.state  # list of length 97 with state[0] = 'dummy'
    blocks = {
        'U': s[1:17],
        'L': s[17:33],
        'F': s[33:49],
        'R': s[49:65],
        'B': s[65:81],
        'D': s[81:97],
    }
    return ''.join(
        ''.join(blocks[face]) for face in 'URFDLB'
    )


def trace(scramble: str) -> dict:
    """Apply scramble to a solved cube; emit input + output state."""
    cube = RubiksCube444(SOLVED, 'URFDLB')
    moves = scramble.split()
    for m in moves:
        cube.rotate(m)
    return {
        'scramble': scramble,
        'state': state_to_urfdlb(cube),
    }


# Test suite — chosen to exercise every base move at least once,
# in both wide and outer forms, in both directions.  The first few are
# minimal (single move) so a failure points at exactly which move table
# is wrong.
SCRAMBLES = [
    # Single outer moves
    "U", "U'", "U2",
    "R", "R'", "R2",
    "F", "F'", "F2",
    "D", "D'", "D2",
    "L", "L'", "L2",
    "B", "B'", "B2",
    # Single wide moves
    "Uw", "Uw'", "Uw2",
    "Rw", "Rw'", "Rw2",
    "Fw", "Fw'", "Fw2",
    "Dw", "Dw'", "Dw2",
    "Lw", "Lw'", "Lw2",
    "Bw", "Bw'", "Bw2",
    # Mixed sequences — short
    "U R F",
    "Uw Rw' Fw2",
    "R U R' U'",
    # Mixed — longer (representative scrambles)
    "Uw' Rw' Fw' Dw' Lw' Bw'",
    "F R U2 L' B Uw Rw' Fw2 Dw Lw Bw'",
    "U R2 F' Lw Dw' Bw2 R' Uw F2 Lw'",
    "Rw U Rw' U R U' Rw U Rw' U R U' R'",
]

if __name__ == '__main__':
    out = {'scrambles': [trace(s) for s in SCRAMBLES]}
    print(json.dumps(out, indent=2))
