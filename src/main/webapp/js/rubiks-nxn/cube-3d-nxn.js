/**
 * Generic N×N×N Three.js cube renderer with face-turn animation.
 *
 * Builds N³ cubies (skipping inner cubies that have no visible face), maps
 * each sticker to a BoxGeometry material slot, and exposes:
 *
 *   setState(state)               — snap to a new state (no animation)
 *   animateMove(move, newState)   — animate a single move, then snap to newState
 *
 * Sticker → cubie convention: matches js/rubiks/cubies.js (3×3) and
 * extended to arbitrary N.  For (face, col, row) ∈ {0..N-1}², with
 * c = col - off, r = row - off, off = (N-1)/2:
 *   U → [ c,  off,  r]   D → [ c, -off, -r]
 *   F → [ c,   -r,  off] B → [-c,  -r, -off]
 *   L → [-off, -r,   c]  R → [off, -r,  -c]
 *
 * Wide moves ("Uw", "Rw'") rotate the outer + one inner slice together —
 * the standard WCA convention for 4×4+ cubes.
 */

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

const FACE_COLORS = {
    U: '#ffffff', // white
    R: '#b71234', // red
    F: '#009b48', // green
    D: '#ffd500', // yellow
    L: '#ff5800', // orange
    B: '#0046ad', // blue
};

const FACES = ['U', 'R', 'F', 'D', 'L', 'B'];

const INTERIOR_COLOR = '#161616';

/** Build the per-sticker descriptor list for an N-cube. */
function buildPlacements(N) {
    const off = (N - 1) / 2;
    const perFace = N * N;
    const offsets = { U: 0, R: perFace, F: 2 * perFace, D: 3 * perFace, L: 4 * perFace, B: 5 * perFace };
    const out = [];
    for (const face of FACES) {
        for (let row = 0; row < N; row++) {
            for (let col = 0; col < N; col++) {
                const c = col - off;
                const r = row - off;
                let cubie;
                switch (face) {
                    case 'U': cubie = [ c,   off,  r];  break;
                    case 'D': cubie = [ c,  -off, -r];  break;
                    case 'F': cubie = [ c,   -r,   off]; break;
                    case 'B': cubie = [-c,   -r,  -off]; break;
                    case 'L': cubie = [-off, -r,   c];  break;
                    case 'R': cubie = [ off, -r,  -c];  break;
                }
                // Outward normal in BoxGeometry material-slot order
                // (+x, -x, +y, -y, +z, -z).
                let slot;
                switch (face) {
                    case 'R': slot = 0; break;
                    case 'L': slot = 1; break;
                    case 'U': slot = 2; break;
                    case 'D': slot = 3; break;
                    case 'F': slot = 4; break;
                    case 'B': slot = 5; break;
                }
                out.push({
                    index: offsets[face] + row * N + col,
                    face,
                    cubie,
                    slot,
                });
            }
        }
    }
    return out;
}

/**
 * @param {HTMLElement} host
 * @param {number}      N
 * @param {string}      initialState
 * @returns {Promise<{ setState:(s:string)=>void, dispose:()=>void }>}
 */
export async function mountCubeNxN(host, N, initialState) {
    const placements = buildPlacements(N);
    /** Group placements by cubie key. */
    const byCubie = new Map();
    for (const p of placements) {
        const key = p.cubie.join(',');
        let arr = byCubie.get(key);
        if (!arr) { arr = []; byCubie.set(key, arr); }
        arr.push(p);
    }

    const width  = host.clientWidth  || 320;
    const height = host.clientHeight || 360;

    const scene = new THREE.Scene();
    scene.background = null;

    // Camera distance scales with N so larger cubes still fit.
    const camDist = 5 + N;
    const camera = new THREE.PerspectiveCamera(35, width / height, 0.1, 100);
    camera.position.set(camDist, camDist * 0.9, camDist * 1.1);

    const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true, preserveDrawingBuffer: true });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setSize(width, height);
    host.innerHTML = '';
    host.appendChild(renderer.domElement);

    scene.add(new THREE.AmbientLight(0xffffff, 0.65));
    const dl1 = new THREE.DirectionalLight(0xffffff, 0.8);
    dl1.position.set(5, 8, 5);
    scene.add(dl1);
    const dl2 = new THREE.DirectionalLight(0xffffff, 0.25);
    dl2.position.set(-3, -2, -4);
    scene.add(dl2);

    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enablePan = false;
    controls.enableZoom = true;
    controls.minDistance = 4;
    controls.maxDistance = 25;
    controls.autoRotate = false;

    /** cubieKey → { mesh, materials[6] } */
    const cubies = new Map();

    const CUBIE_SIZE = 0.94;
    for (const [key, group] of byCubie.entries()) {
        const [x, y, z] = key.split(',').map(Number);
        const geom = new THREE.BoxGeometry(CUBIE_SIZE, CUBIE_SIZE, CUBIE_SIZE);
        const materials = [
            new THREE.MeshStandardMaterial({ color: INTERIOR_COLOR, roughness: 0.6 }),
            new THREE.MeshStandardMaterial({ color: INTERIOR_COLOR, roughness: 0.6 }),
            new THREE.MeshStandardMaterial({ color: INTERIOR_COLOR, roughness: 0.6 }),
            new THREE.MeshStandardMaterial({ color: INTERIOR_COLOR, roughness: 0.6 }),
            new THREE.MeshStandardMaterial({ color: INTERIOR_COLOR, roughness: 0.6 }),
            new THREE.MeshStandardMaterial({ color: INTERIOR_COLOR, roughness: 0.6 }),
        ];
        const mesh = new THREE.Mesh(geom, materials);
        mesh.position.set(x, y, z);
        scene.add(mesh);
        cubies.set(key, { mesh, materials, group });
    }

    function setState(state) {
        for (const { materials, group } of cubies.values()) {
            for (const p of group) {
                const ch = state[p.index];
                const col = FACE_COLORS[ch] || INTERIOR_COLOR;
                materials[p.slot].color.set(col);
            }
        }
    }

    setState(initialState);

    let alive = true;
    function tick() {
        if (!alive) return;
        controls.update();
        renderer.render(scene, camera);
        requestAnimationFrame(tick);
    }
    tick();

    // ── face-turn animation ───────────────────────────────────────
    const off = (N - 1) / 2;
    const EPS = 0.001;
    /** Cubies whose `axis` coordinate is in [lo, hi] (inclusive, with EPS). */
    function cubiesInSlice(axis, lo, hi) {
        const out = [];
        for (const [key, c] of cubies.entries()) {
            const [x, y, z] = key.split(',').map(Number);
            const v = axis === 'x' ? x : axis === 'y' ? y : z;
            if (v >= lo - EPS && v <= hi + EPS) out.push(c);
        }
        return out;
    }
    function sliceForMove(face, wide, prefix) {
        // Returns {axis, lo, hi} describing the cubies that rotate.
        // `prefix` is the "n" in "nR" / "nRw" notation (string or "").
        // Middle slices (3×3 only — there's only one "middle" then).
        if (face === 'M') return { axis: 'x', lo: 0, hi: 0 };
        if (face === 'E') return { axis: 'y', lo: 0, hi: 0 };
        if (face === 'S') return { axis: 'z', lo: 0, hi: 0 };
        // Whole-cube rotations: every cubie rotates.
        if (face === 'x') return { axis: 'x', lo: -off, hi: off };
        if (face === 'y') return { axis: 'y', lo: -off, hi: off };
        if (face === 'z') return { axis: 'z', lo: -off, hi: off };

        const axis = (face === 'U' || face === 'D') ? 'y'
                   : (face === 'R' || face === 'L') ? 'x' : 'z';
        const positive = (face === 'U' || face === 'R' || face === 'F');
        // Default counts: wide-w/o-prefix = 2 layers, non-wide = 1 layer.
        const n = prefix ? parseInt(prefix, 10) : (wide ? 2 : 1);

        if (wide) {
            // Outer + n-1 layers inward (n total layers).
            return positive
                ? { axis, lo: off - (n - 1), hi: off }
                : { axis, lo: -off,          hi: -off + (n - 1) };
        }
        // Single-layer turn: only layer n-1 (0-indexed from `face`).
        const v = positive ? (off - (n - 1)) : (-off + (n - 1));
        return { axis, lo: v, hi: v };
    }
    function rotationSign(face) {
        // CW from outside the face = negative rotation around that face's
        // outward-axis (right-hand rule).  Conventions:
        //   M follows L (+),  E follows D (+),  S follows F (−).
        //   x/y/z follow R/U/F respectively (cube rotations).
        return (face === 'U' || face === 'R' || face === 'F' || face === 'S'
             || face === 'x' || face === 'y' || face === 'z') ? -1 : 1;
    }

    // ── highlight the moving slice ────────────────────────────────
    // During a face turn, darken the non-moving cubies AND brighten
    // the moving slice so the user's eye is drawn to exactly which
    // layer is rotating.  Especially useful during solution playback
    // so cubers can follow along with WCA notation they aren't fluent
    // in yet.  We modulate `color` (multiplicative darken) and
    // `emissive` (additive brighten) on each material — both are
    // dynamic uniforms so no shader recompile is needed.
    const DIM_FACTOR = 0.25;          // multiply non-slice colors by this
    const HIGHLIGHT_EMISSIVE = 0x222222;
    function snapshotMaterials() {
        // Cache the original color of every face slot so we can restore.
        // Lazy: only run once, on first highlight.
        if (snapshotMaterials.done) return;
        for (const c of cubies.values()) {
            c._origColors = c.materials.map(m => m.color.getHex());
        }
        snapshotMaterials.done = true;
    }
    function setSliceHighlight(sliceArr) {
        snapshotMaterials();
        const inSlice = new Set(sliceArr);
        for (const c of cubies.values()) {
            // Re-snapshot on every highlight in case stickers were edited
            // between turns (edit mode + manual paint).
            c._origColors = c.materials.map(m => m.color.getHex());
            const keep = inSlice.has(c);
            for (let i = 0; i < c.materials.length; i++) {
                const m = c.materials[i];
                if (keep) {
                    m.emissive.setHex(HIGHLIGHT_EMISSIVE);
                } else {
                    m.color.multiplyScalar(DIM_FACTOR);
                    m.emissive.setHex(0x000000);
                }
            }
        }
    }
    function clearHighlight() {
        for (const c of cubies.values()) {
            if (!c._origColors) continue;
            for (let i = 0; i < c.materials.length; i++) {
                c.materials[i].color.setHex(c._origColors[i]);
                c.materials[i].emissive.setHex(0x000000);
            }
        }
    }

    // ── directional arrow for the upcoming face turn ──────────────
    // A curved arrow (TorusGeometry partial arc + ConeGeometry head)
    // floats just outside the moving face, showing direction at a
    // glance.  Critical for accessibility (color-blind users can't
    // rely on the dim/bright contrast alone).
    const FACE_NORMALS = {
        U: new THREE.Vector3(0,  1, 0),  D: new THREE.Vector3(0, -1, 0),
        R: new THREE.Vector3(1,  0, 0),  L: new THREE.Vector3(-1, 0, 0),
        F: new THREE.Vector3(0,  0, 1),  B: new THREE.Vector3(0,  0, -1),
    };
    const FACE_POSITIVE = { U: true, R: true, F: true, D: false, L: false, B: false };

    function buildMoveArrow(face, turns) {
        const ARROW_COLOR = 0xfff200;             // bright yellow, high-contrast
        const radius = N * 0.30;
        const tube = 0.05 * Math.max(1, N / 3);
        const arc = (turns === 2 ? 1.2 : 0.7) * Math.PI;
        const mat = new THREE.MeshBasicMaterial({
            color: ARROW_COLOR, depthTest: false, transparent: true, opacity: 0.95,
        });

        const torusGeom = new THREE.TorusGeometry(radius, tube, 8, 48, arc);
        const torus = new THREE.Mesh(torusGeom, mat);

        // Arrowhead at the end of the arc.  Torus default sweeps CCW
        // around its local +Z, starting at local +X.
        const headLen = 0.40 * Math.max(1, N / 3);
        const head = new THREE.Mesh(
            new THREE.ConeGeometry(tube * 2.6, headLen, 14), mat);
        const endX = radius * Math.cos(arc);
        const endY = radius * Math.sin(arc);
        head.position.set(endX, endY, 0);
        // Cone default points +Y; we want it tangent to the arc at the
        // end point.  Tangent direction at angle θ on a CCW circle is
        // (−sin θ, cos θ, 0).  So rotate cone around local Z by `arc`.
        head.rotation.z = arc;

        const arrow = new THREE.Group();
        arrow.add(torus);
        arrow.add(head);
        // Render arrows ABOVE the cube, ignoring depth.
        torus.renderOrder = 999;
        head.renderOrder = 999;

        // Orient: align local +Z to the face's outward normal, position
        // just outside the face.
        const normal = FACE_NORMALS[face];
        const quat = new THREE.Quaternion()
            .setFromUnitVectors(new THREE.Vector3(0, 0, 1), normal);
        arrow.quaternion.copy(quat);
        arrow.position.copy(normal).multiplyScalar(off + 0.55);

        // Mirror the arc direction when it would otherwise point the
        // wrong way.  Default torus arc sweeps CCW around local +Z.
        // After orientation, that's CCW around the face's outward
        // normal, which corresponds to the *prime* direction on
        // positive-axis faces (U/R/F) and *non-prime* on negative-axis
        // faces (D/L/B).  We want the arrow to point in the actual
        // turn direction — flip when needed by negating local X.
        const isPrime = turns < 0;
        const positive = FACE_POSITIVE[face];
        // Default arc direction matches: (positive face && isPrime) ||
        // (!positive && !isPrime).  Flip in the opposite cases.
        const defaultMatches = (positive && isPrime) || (!positive && !isPrime);
        if (!defaultMatches) {
            arrow.scale.x = -1;
        }
        return arrow;
    }

    function showMoveArrow(face, turns) {
        const arrow = buildMoveArrow(face, turns);
        scene.add(arrow);
        return arrow;
    }
    function disposeArrow(arrow) {
        if (!arrow) return;
        scene.remove(arrow);
        arrow.traverse((o) => {
            if (o.geometry) o.geometry.dispose();
            if (o.material) o.material.dispose();
        });
    }

    let animating = null;   // current animation Promise (or null)

    /**
     * Animate `move` then snap to `newState`.
     *
     * Move syntax: /^([URFDLB])(w?)(['2]?)$/.  If parsing fails or the move
     * isn't applicable to this size (e.g. wide on 3×3), falls back to snap.
     */
    async function animateMove(move, newState, durationMs) {
        if (animating) await animating;     // serialise back-to-back moves
        const m = /^(\d*)([URFDLBMESxyz])(w?)(['2]?)$/.exec(move || '');
        if (!m) { setState(newState); return; }
        const prefix = m[1];
        const face = m[2];
        const wide = m[3] === 'w';
        const turns = m[4] === "'" ? -1 : m[4] === '2' ? 2 : 1;
        if (wide && N < 4) { setState(newState); return; }

        const dur = (durationMs == null ? 220 : durationMs) * (turns === 2 ? 1.4 : 1);
        const { axis, lo, hi } = sliceForMove(face, wide, prefix);
        const slice = cubiesInSlice(axis, lo, hi);
        if (slice.length === 0) { setState(newState); return; }

        const group = new THREE.Group();
        scene.add(group);
        for (const c of slice) {
            scene.remove(c.mesh);
            group.add(c.mesh);
        }

        // Whole-cube rotations (x/y/z) move every cubie, so the
        // "dim everything else" highlight has nothing to dim and is
        // skipped.  Same for the directional arrow — there's no
        // single face anchor.
        const isCubeRotation = (face === 'x' || face === 'y' || face === 'z');
        if (!isCubeRotation) setSliceHighlight(slice);
        // Skip the arrow for middle/inner slices and cube rotations.
        const isInnerSlice = (face === 'M' || face === 'E' || face === 'S')
            || (prefix && parseInt(prefix, 10) >= 2 && !wide);
        const arrow = (isInnerSlice || isCubeRotation)
            ? null : showMoveArrow(face, turns);

        const targetAngle = rotationSign(face) * turns * (Math.PI / 2);

        animating = new Promise((resolve) => {
            const start = performance.now();
            function tick2() {
                const t = Math.min(1, (performance.now() - start) / dur);
                const eased = t * (2 - t); // ease-out quad
                group.rotation[axis] = targetAngle * eased;
                if (t < 1) {
                    requestAnimationFrame(tick2);
                    return;
                }
                // Detach: reparent meshes back to scene, then snap to newState.
                for (const c of slice) {
                    group.remove(c.mesh);
                    scene.add(c.mesh);
                }
                scene.remove(group);
                clearHighlight();
                disposeArrow(arrow);
                if (newState != null) setState(newState);
                animating = null;
                resolve();
            }
            requestAnimationFrame(tick2);
        });
        return animating;
    }

    function onResize() {
        const w = host.clientWidth || width;
        const h = host.clientHeight || height;
        renderer.setSize(w, h);
        camera.aspect = w / h;
        camera.updateProjectionMatrix();
    }
    const ro = new ResizeObserver(onResize);
    ro.observe(host);

    /* ── Drag-to-turn faces ─────────────────────────────────────────
     *
     * Mouse-down on a sticker → start tracking.  On mouse-move past a
     * threshold, decide which face turn the gesture wants based on:
     *
     *   1. The clicked sticker's outward normal (which face was hit).
     *   2. The dominant axis of the screen-space drag, projected back
     *      into the world's coordinate frame.
     *   3. The clicked cubie's position along the rotation axis
     *      (determines layer = U vs middle vs D, etc.).
     *
     * Disables OrbitControls during drag-turns so the camera doesn't
     * also pan; re-enables on mouseup.  Calls back to a registered
     * onMove handler with the resolved WCA move string ("U", "R'", etc.)
     * — the app layer applies the move and animates it (via animateMove
     * above), so the visual feedback is the same as clicking a twist
     * button.
     */
    const raycaster = new THREE.Raycaster();
    const ndcPos = new THREE.Vector2();
    let dragHandler = null;
    let drag = null;     // { cubie, normal, startX, startY, locked, move }
    const DRAG_THRESHOLD = 10;          // px before we lock a direction

    function setOnMove(fn) { dragHandler = fn; }

    /** Map a face-normal vector (one of ±X/±Y/±Z) to its face letter. */
    function normalToFaceChar(n) {
        if (Math.abs(n.x) > 0.5) return n.x > 0 ? 'R' : 'L';
        if (Math.abs(n.y) > 0.5) return n.y > 0 ? 'U' : 'D';
        if (Math.abs(n.z) > 0.5) return n.z > 0 ? 'F' : 'B';
        return null;
    }
    /** Given a clicked cubie position + a rotation axis, pick the face
     *  letter for the OUTERMOST layer along that axis containing the
     *  cubie.  Returns null if the cubie is in the central (middle)
     *  slice on odd-N cubes. */
    function layerToFaceChar(cubieXYZ, axisLetter) {
        const v = axisLetter === 'x' ? cubieXYZ.x
                 : axisLetter === 'y' ? cubieXYZ.y : cubieXYZ.z;
        const posFace = axisLetter === 'x' ? 'R' : axisLetter === 'y' ? 'U' : 'F';
        const negFace = axisLetter === 'x' ? 'L' : axisLetter === 'y' ? 'D' : 'B';

        // Layer index from each end (0 = outermost on that side).
        const layerFromPos = Math.round(off - v);   // distance from +face
        const layerFromNeg = Math.round(v + off);   // distance from -face
        // Pick the closer face.  Ties (exact middle on odd N) favour the
        // positive side by convention.
        const useNeg = layerFromNeg < layerFromPos;
        const face   = useNeg ? negFace : posFace;
        const layer  = useNeg ? layerFromNeg : layerFromPos;

        if (layer === 0) return face;       // outer face turn

        // 3×3 middle layer → use M / E / S (more idiomatic than "2R" on a 3×3).
        if (N === 3 && layer === 1) {
            return axisLetter === 'x' ? 'M' : axisLetter === 'y' ? 'E' : 'S';
        }
        // Inner-slice notation: nF where n is 1-indexed layer count from F.
        return `${layer + 1}${face}`;
    }

    function pickIntersection(clientX, clientY) {
        const rect = renderer.domElement.getBoundingClientRect();
        ndcPos.x = ((clientX - rect.left) / rect.width)  *  2 - 1;
        ndcPos.y = ((clientY - rect.top)  / rect.height) * -2 + 1;
        raycaster.setFromCamera(ndcPos, camera);
        const hits = raycaster.intersectObjects(
            Array.from(cubies.values()).map(c => c.mesh), false);
        return hits.length ? hits[0] : null;
    }

    function onPointerDown(e) {
        if (animating) return;
        const hit = pickIntersection(e.clientX, e.clientY);
        if (!hit || !hit.face) return;
        // World-space outward normal at the hit point.
        const normal = hit.face.normal.clone()
            .transformDirection(hit.object.matrixWorld).normalize();
        const faceChar = normalToFaceChar(normal);
        if (!faceChar) return;
        drag = {
            mesh: hit.object,
            cubiePos: hit.object.position.clone(),
            normal,
            startX: e.clientX,
            startY: e.clientY,
            locked: false,
            move: null,
        };
        // Disable orbit while the user might be drag-turning.  We only
        // re-enable orbit if they drag too small a distance and we
        // decide the gesture was a click rather than a face-turn.
        controls.enabled = false;
    }

    function onPointerMove(e) {
        if (!drag || drag.locked) return;
        const dx = e.clientX - drag.startX;
        const dy = e.clientY - drag.startY;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < DRAG_THRESHOLD) return;

        // Project screen-space drag back into world space using the
        // camera's right + up vectors.
        const camRight = new THREE.Vector3(1, 0, 0).applyQuaternion(camera.quaternion);
        const camUp    = new THREE.Vector3(0, 1, 0).applyQuaternion(camera.quaternion);
        const dragWorld = new THREE.Vector3()
            .addScaledVector(camRight, dx)
            .addScaledVector(camUp, -dy);

        // The clicked face has 2 in-plane axes (perpendicular to its
        // outward normal).  Find them by removing the normal-aligned
        // component from dragWorld, then snapping to the nearest world
        // axis perpendicular to the normal.
        const projected = dragWorld.clone().projectOnPlane(drag.normal);

        // The two cardinal directions perpendicular to the normal:
        const candidates = [];
        const axes = [
            new THREE.Vector3(1, 0, 0),
            new THREE.Vector3(-1, 0, 0),
            new THREE.Vector3(0, 1, 0),
            new THREE.Vector3(0, -1, 0),
            new THREE.Vector3(0, 0, 1),
            new THREE.Vector3(0, 0, -1),
        ];
        for (const a of axes) {
            // Skip axes parallel to the face normal.
            if (Math.abs(a.dot(drag.normal)) > 0.5) continue;
            candidates.push({ axis: a, dot: a.dot(projected) });
        }
        candidates.sort((p, q) => q.dot - p.dot);
        const swipe = candidates[0].axis;            // dominant world-space swipe direction

        // Rotation axis = normal × swipe   (right-hand rule).
        const rotAxis = new THREE.Vector3().crossVectors(drag.normal, swipe).normalize();
        const axisLetter = Math.abs(rotAxis.x) > 0.5 ? 'x'
                         : Math.abs(rotAxis.y) > 0.5 ? 'y' : 'z';
        // Which outermost layer along the rotation axis contains the cubie?
        const faceChar = layerToFaceChar(drag.cubiePos, axisLetter);
        if (!faceChar) {
            // Middle slice on a 3×3 / 5×5 / 7×7 — no outer turn maps here.
            // Treat as a no-op gesture; let go and re-enable orbit.
            drag.locked = true;
            controls.enabled = true;
            return;
        }

        // Direction sign: matches the right-hand rule.  If the rotation
        // axis points in the +face-letter direction, prime; else CW.
        // (Each face's "CW from outside" is a -rotation around its
        // outward normal axis using right-hand rule — so we invert when
        // the rotation axis aligns with the face's normal direction.)
        // The face letter is the LAST char of `faceChar` (handles "2R",
        // "3L", "M", etc.).  S/M/E follow F/L/D direction respectively.
        const baseLetter = faceChar[faceChar.length - 1];
        const facePositive = (baseLetter === 'U' || baseLetter === 'R' || baseLetter === 'F'
                            || baseLetter === 'S');
        const axisPositive = (rotAxis.x + rotAxis.y + rotAxis.z) > 0;
        const prime = facePositive === axisPositive;       // empirically derived
        const move = prime ? faceChar + "'" : faceChar;

        drag.locked = true;
        drag.move = move;
        controls.enabled = true;
        if (dragHandler) {
            try { dragHandler(move); } catch (err) { /* swallow */ }
        }
    }

    function onPointerUp() {
        if (!drag) return;
        controls.enabled = true;
        drag = null;
    }

    renderer.domElement.addEventListener('pointerdown', onPointerDown);
    renderer.domElement.addEventListener('pointermove', onPointerMove);
    renderer.domElement.addEventListener('pointerup',   onPointerUp);
    renderer.domElement.addEventListener('pointerleave', onPointerUp);
    renderer.domElement.style.touchAction = 'none';   // allow drag on touch devices

    return {
        setState,
        animateMove,
        setOnMove,
        get canvas() { return renderer.domElement; },
        dispose() {
            alive = false;
            ro.disconnect();
            controls.dispose();
            renderer.dispose();
            for (const { mesh, materials } of cubies.values()) {
                mesh.geometry.dispose();
                for (const m of materials) m.dispose();
            }
            host.innerHTML = '';
        },
    };
}
