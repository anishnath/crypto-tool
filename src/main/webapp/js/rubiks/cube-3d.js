/**
 * Vanilla Three.js port of Cube3D.tsx.
 *
 * Builds 26 cubie meshes (skipping the unseen core), maps each face's outward
 * normal to a BoxGeometry material slot (+x,-x,+y,-y,+z,-z), and animates
 * face turns by diffing old vs new state across all 18 single-move
 * possibilities — if a single move matches, animate the matching face's 9
 * cubies as a rotating group; otherwise snap (paste / scramble / reset).
 *
 * Three.js is loaded from unpkg as ES module. The TrackballControls /
 * OrbitControls are also loaded from there.
 */

import { FACE_COLORS } from './cube.js';
import {
    STICKERS_BY_CUBIE, cubieKey, cubieOnFace,
    rotationAxis, rotationAngle,
} from './cubies.js';
import { parseMove } from './moves.js';
import { applyMoves } from './solver.js';

// Three.js + OrbitControls resolved via the page's <script type="importmap">.
// Bare specifiers are the canonical Three.js setup — OrbitControls itself
// does `import * as THREE from 'three'` internally, so the same map serves
// both this module and the addon.
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

const INTERIOR_COLOR = '#161616';
const CUBIE_SIZE = 0.94;

const ALL_CUBIES = (() => {
    const out = [];
    for (const x of [-1, 0, 1]) {
        for (const y of [-1, 0, 1]) {
            for (const z of [-1, 0, 1]) {
                if (x === 0 && y === 0 && z === 0) continue;
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

async function detectSingleMove(prev, next) {
    if (prev === next) return null;
    for (const move of ALL_MOVE_STRINGS) {
        const candidate = await applyMoves(prev, move);
        if (candidate === next) return move;
    }
    return null;
}

/**
 * @param {HTMLElement} host
 * @param {string} initialState
 * @returns {Promise<{ setState: (state:string)=>void, dispose: ()=>void, el:HTMLCanvasElement }>}
 */
export async function mountCube3D(host, initialState) {
    const width = host.clientWidth || 320;
    const height = host.clientHeight || 320;

    const scene = new THREE.Scene();
    scene.background = null;

    const camera = new THREE.PerspectiveCamera(35, width / height, 0.1, 100);
    camera.position.set(5.5, 5, 7);

    // preserveDrawingBuffer:true so gif.js can read pixels reliably when
    // the user clicks "Record GIF".  Tiny perf cost; cube is mostly idle.
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
    controls.minDistance = 5;
    controls.maxDistance = 14;

    /** Map cubieKey → { mesh, materials } so we can recolor without rebuilding geometry. */
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
    let activeTurn = null; // {face, turns, group, axis, target, started, durationMs, endState}

    function startTurnAnimation(face, turns, endState) {
        // Move the face's 9 cubies into a child group so we can rotate them.
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
        // Bake the layer's rotation into each child's local position, then
        // re-parent back to root.  CRITICAL: capture world position BEFORE
        // calling group.remove(m), otherwise getWorldPosition() reads the
        // detached mesh's local position and you end up snapping cubies back
        // to where they started (defeating the animation).
        const { group } = activeTurn;
        const children = [...group.children];
        const wp = new THREE.Vector3();
        for (const m of children) {
            m.getWorldPosition(wp);
            group.remove(m);
            root.add(m);
            // Root has identity transform, so local position = world position.
            // Snap to integer cubie coords to absorb floating-point drift.
            m.position.set(Math.round(wp.x), Math.round(wp.y), Math.round(wp.z));
            // Mesh visual rotation doesn't matter — recolor() reassigns face
            // colors based on each cubie's NEW position, and the cube material
            // slots are by axis (+x/-x/+y/-y/+z/-z), so a 90° turn needs no
            // mesh-level rotation tracking.
            m.rotation.set(0, 0, 0);
        }
        root.remove(group);
        // Rebuild cubieMap by current mesh positions, then recolor.
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

    async function setState(next) {
        if (next === renderedState) return;
        if (activeTurn) {
            // An animation is in flight — let it finish and re-call.
            // Cheap recursive defer.
            const oldEnd = activeTurn.endState;
            activeTurn.endState = next;
            // If the queued state is reachable from oldEnd via single move,
            // we'd still animate; but for simplicity just snap on completion.
            return;
        }
        const move = await detectSingleMove(renderedState, next);
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
