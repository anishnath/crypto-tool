/** URL hash sharing — port of share.ts. */

import { validateState } from './cube.js';

const HASH_KEY = 'state';

export function shareUrl(state, base) {
    const origin = base || (window.location.origin + window.location.pathname);
    return `${origin}#${HASH_KEY}=${state}`;
}

export function decodeStateFromHash(hash) {
    if (!hash) return null;
    const fragment = hash.startsWith('#') ? hash.slice(1) : hash;
    for (const part of fragment.split('&')) {
        const eq = part.indexOf('=');
        if (eq === -1) continue;
        const k = part.slice(0, eq);
        const v = part.slice(eq + 1);
        if (k === HASH_KEY && v) {
            const decoded = decodeURIComponent(v);
            if (validateState(decoded).ok) return decoded;
        }
    }
    return null;
}
