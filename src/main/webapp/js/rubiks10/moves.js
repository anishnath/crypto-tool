/**
 * 10×10 move application — thin shim over the generic moves-builder.
 */

import { buildMoveSet } from '../rubiks-nxn/moves-builder.js';

const set = buildMoveSet(10);

export const ALL_MOVES = set.ALL_MOVES;
export const permFor   = set.permFor;
export const applyMove = set.applyMove;
export const applyMoves = set.applyMoves;
