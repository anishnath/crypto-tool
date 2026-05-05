/**
 * 2×2 Pocket Cube — Three.js scene with animated face turns.
 *
 * Mirror of /js/rubiks/cube-3d.js, with two differences:
 *   - 8 cubies (corners only) instead of 26
 *   - synchronous applyMove (vanilla BFS, no cubejs/Web-Worker pipeline)
 *
 * Three.js is loaded via the page's <script type="importmap"> as bare
 * specifier 'three' + 'three/addons/'.
 */

import { FACE_COLORS } from './cube.js';
import { applyMove } from './cube.js';
import {
    STICKERS_BY_CUBIE, cubieKey, cubieOnFace,
    rotationAxis, rotationAngle,
} from './cubies.js';

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

const INTERIOR_COLOR = '#161616';
const CUBIE_SIZE = 0.94;

/** All 8 corner positions for a 2×2. */
const ALL_CUBIES = (() => {
    const out = [];
    for (const x of [-1, 1]) {
        for (const y of [-1, 1]) {
            for (const z of [-1, 1]) {
                out.push([x, y, z]);
            }
        }
    }
    return out;
})();

const ALL_MOVE_STRINGS = (() => {
    const out = [];
    for (const f of ['U', 'R', 'F', 'D', 'L', 'B']) {
        out.push(f, `${f}'`, `${f}2`);
    }
    return out;
})();

function colorsForState(state) {
    const out = new Map();
    for (const [x, y, z] of ALL_CUBIES) {
        const key = cubieKey(x, y, z);
        const stickers = STICKERS_BY_CUBIE[key] || [];
        const faces = [null, null, null, null, null, null];
        for (const s of stickers) {
            const letter = state[s.index];
            const color = FACE_COLORS[letter] || '#888';
            const slot =
                s.normal[0] ===  1 ? 0 :
                s.normal[0] === -1 ? 1 :
                s.normal[1] ===  1 ? 2 :
                s.normal[1] === -1 ? 3 :
                s.normal[2] ===  1 ? 4 : 5;
            faces[slot] = color;
        }
        out.set(key, faces);
    }
    return out;
}

function detectSingleMove(prev, next) {
    if (prev === next) return null;
    for (const move of ALL_MOVE_STRINGS) {
        if (applyMove(prev, move) === next) return move;
    }
    return null;
}

function parseMove(raw) {
    const m = /^([URFDLB])(['2]?)$/.exec(raw);
    if (!m) return null;
    return { face: m[1], turns: m[2] === "'" ? -1 : m[2] === '2' ? 2 : 1 };
}

export async function mountCube3D(host, initialState) {
    const width = host.clientWidth || 320;
    const height = host.clientHeight || 320;

    const scene = new THREE.Scene();
    scene.background = null;

    const camera = new THREE.PerspectiveCamera(35, width / height, 0.1, 100);
    camera.position.set(5.5, 5, 7);

    // preserveDrawingBuffer:true is required so gif.js (and any future
    // canvas → ImageBitmap pipeline) can read pixels reliably.  Tiny perf
    // cost for our use case where the cube is mostly idle.
    const renderer = new THREE.WebGLRenderer({
        antialias: true,
        alpha: true,
        preserveDrawingBuffer: true,
    });
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
    controls.minDistance = 4.5;
    controls.maxDistance = 12;

    const cubieMap = new Map();
    const root = new THREE.Group();
    scene.add(root);

    function buildAllCubies(state) {
        const colors = colorsForState(state);
        for (const [x, y, z] of ALL_CUBIES) {
            const key = cubieKey(x, y, z);
            const faces = colors.get(key) || [];
            const materials = faces.map((c) =>
                new THREE.MeshStandardMaterial({
                    color: new THREE.Color(c || INTERIOR_COLOR),
                    roughness: 0.55,
                    metalness: 0.05,
                }),
            );
            const geom = new THREE.BoxGeometry(CUBIE_SIZE, CUBIE_SIZE, CUBIE_SIZE);
            const mesh = new THREE.Mesh(geom, materials);
            mesh.position.set(x, y, z);
            mesh.userData = { cubie: [x, y, z] };
            root.add(mesh);
            cubieMap.set(key, { mesh, materials });
        }
    }

    function recolor(state) {
        const colors = colorsForState(state);
        for (const [x, y, z] of ALL_CUBIES) {
            const key = cubieKey(x, y, z);
            const entry = cubieMap.get(key);
            if (!entry) continue;
            const faces = colors.get(key) || [];
            for (let i = 0; i < 6; i++) {
                entry.materials[i].color.set(faces[i] || INTERIOR_COLOR);
            }
        }
    }

    buildAllCubies(initialState);

    let renderedState = initialState;
    let activeTurn = null;

    function startTurnAnimation(face, turns, endState) {
        const group = new THREE.Group();
        root.add(group);
        for (const [x, y, z] of ALL_CUBIES) {
            if (!cubieOnFace(face, [x, y, z])) continue;
            const key = cubieKey(x, y, z);
            const entry = cubieMap.get(key);
            if (!entry) continue;
            root.remove(entry.mesh);
            group.add(entry.mesh);
        }
        const axis = rotationAxis(face);
        const target = rotationAngle(face, turns);
        const durationMs = turns === 2 ? 380 : 240;
        activeTurn = {
            face, turns, group, axis, target,
            started: performance.now(), durationMs, endState,
        };
    }

    function finishTurnAnimation() {
        if (!activeTurn) return;
        const { group } = activeTurn;
        const children = [...group.children];
        const wp = new THREE.Vector3();
        for (const m of children) {
            // Capture world position BEFORE detaching from group.
            m.getWorldPosition(wp);
            group.remove(m);
            root.add(m);
            m.position.set(Math.round(wp.x), Math.round(wp.y), Math.round(wp.z));
            m.rotation.set(0, 0, 0);
        }
        root.remove(group);
        cubieMap.clear();
        for (const child of root.children) {
            if (!child.userData || !child.userData.cubie) continue;
            const [x, y, z] = [child.position.x, child.position.y, child.position.z];
            child.userData.cubie = [x, y, z];
            cubieMap.set(cubieKey(x, y, z), { mesh: child, materials: child.material });
        }
        recolor(activeTurn.endState);
        renderedState = activeTurn.endState;
        activeTurn = null;
    }

    let raf = null;
    function tick() {
        if (activeTurn) {
            const t = Math.min(1, (performance.now() - activeTurn.started) / activeTurn.durationMs);
            const eased = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
            const angle = eased * activeTurn.target;
            const g = activeTurn.group;
            g.rotation.x = activeTurn.axis === 'x' ? angle : 0;
            g.rotation.y = activeTurn.axis === 'y' ? angle : 0;
            g.rotation.z = activeTurn.axis === 'z' ? angle : 0;
            if (t >= 1) finishTurnAnimation();
        }
        controls.update();
        renderer.render(scene, camera);
        raf = requestAnimationFrame(tick);
    }
    raf = requestAnimationFrame(tick);

    function onResize() {
        const w = host.clientWidth || width;
        const h = host.clientHeight || height;
        camera.aspect = w / h;
        camera.updateProjectionMatrix();
        renderer.setSize(w, h);
    }
    const ro = new ResizeObserver(onResize);
    ro.observe(host);

    function setState(next) {
        if (next === renderedState) return;
        if (activeTurn) {
            // An animation is in flight — queue the new target by replacing
            // endState; once the current turn completes, recolor() applies
            // the latest state (potentially skipping intermediate animations).
            activeTurn.endState = next;
            return;
        }
        const move = detectSingleMove(renderedState, next);
        const parsed = move ? parseMove(move) : null;
        if (parsed) {
            startTurnAnimation(parsed.face, parsed.turns, next);
        } else {
            recolor(next);
            renderedState = next;
        }
    }

    return {
        el: renderer.domElement,
        setState,
        dispose() {
            if (raf !== null) cancelAnimationFrame(raf);
            ro.disconnect();
            renderer.dispose();
            renderer.domElement.remove();
        },
    };
}
