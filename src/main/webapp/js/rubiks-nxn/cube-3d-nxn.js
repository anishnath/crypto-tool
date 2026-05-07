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
    function sliceForMove(face, wide) {
        // Returns {axis, lo, hi} describing the cubies that rotate.
        const layers = wide ? 2 : 1;
        // outer layer is at ±off; wide adds the next inner layer at ±(off-1)
        switch (face) {
            case 'U': return { axis: 'y', lo:  off - (layers - 1), hi:  off };
            case 'D': return { axis: 'y', lo: -off,                hi: -off + (layers - 1) };
            case 'R': return { axis: 'x', lo:  off - (layers - 1), hi:  off };
            case 'L': return { axis: 'x', lo: -off,                hi: -off + (layers - 1) };
            case 'F': return { axis: 'z', lo:  off - (layers - 1), hi:  off };
            case 'B': return { axis: 'z', lo: -off,                hi: -off + (layers - 1) };
        }
    }
    function rotationSign(face) {
        // CW from outside the face = negative rotation around that face's
        // outward-axis (right-hand rule).
        return (face === 'U' || face === 'R' || face === 'F') ? -1 : 1;
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
        const m = /^([URFDLB])(w?)(['2]?)$/.exec(move || '');
        if (!m) { setState(newState); return; }
        const face = m[1];
        const wide = m[2] === 'w';
        const turns = m[3] === "'" ? -1 : m[3] === '2' ? 2 : 1;
        if (wide && N < 4) { setState(newState); return; }

        const dur = (durationMs == null ? 220 : durationMs) * (turns === 2 ? 1.4 : 1);
        const { axis, lo, hi } = sliceForMove(face, wide);
        const slice = cubiesInSlice(axis, lo, hi);
        if (slice.length === 0) { setState(newState); return; }

        const group = new THREE.Group();
        scene.add(group);
        for (const c of slice) {
            scene.remove(c.mesh);
            group.add(c.mesh);
        }

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
        if (Math.abs(v - off) < EPS)  return axisLetter === 'x' ? 'R' : axisLetter === 'y' ? 'U' : 'F';
        if (Math.abs(v + off) < EPS)  return axisLetter === 'x' ? 'L' : axisLetter === 'y' ? 'D' : 'B';
        return null;     // middle slice — no outer face turn
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
        const facePositive = (faceChar === 'U' || faceChar === 'R' || faceChar === 'F');
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
