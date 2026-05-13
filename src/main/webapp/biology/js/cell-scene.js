/*
 * biology/js/cell-scene.js
 *
 * Three.js scene module for Cell Atlas 3D. Loaded as an ES module via
 * the import-map declared in cell-atlas.jsp; depends only on three.js
 * and its OrbitControls / GLTFLoader / RoundedBoxGeometry addons.
 *
 * Public API:
 *   const controller = BiologyCellScene.mount(canvasEl, opts);
 *   controller.update({ cell, activeOrganelle, viewMode, crossSection, autoRotate });
 *   controller.reset();
 *   controller.dispose();
 *
 * The controller is exposed on window.BiologyCellScene so the page
 * script can call it once the module has loaded.
 */

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader.js";
import { RoundedBoxGeometry } from "three/addons/geometries/RoundedBoxGeometry.js";

/* ------------------------------------------------------------------ */
/* Tagging                                                            */
/* ------------------------------------------------------------------ */

// Every mesh in the scene gets an organelleId in userData. updateMaterials
// uses it to compute the active highlight + focus-mode dimming. Meshes for
// the outer membrane shell get id "membrane" — never an active organelle —
// so they always fall into the "other" branch with their base opacity.
function tagMesh(mesh, organelleId, baseOpacity, baseColor) {
    mesh.userData.organelleId = organelleId;
    mesh.userData.baseOpacity = baseOpacity == null ? 1 : baseOpacity;
    mesh.userData.baseColor = baseColor || null;
    mesh.castShadow = true;
    mesh.receiveShadow = true;
    return mesh;
}

/* ------------------------------------------------------------------ */
/* Material factory (studio mode — used by procedural models + non-   */
/* native GLBs)                                                       */
/* ------------------------------------------------------------------ */

function makeStudioMaterial(color, opacity, roughness, metalness) {
    return new THREE.MeshStandardMaterial({
        color: new THREE.Color(color),
        roughness: roughness == null ? 0.66 : roughness,
        metalness: metalness == null ? 0.03 : metalness,
        transparent: opacity < 1,
        opacity: opacity == null ? 1 : opacity,
        side: THREE.DoubleSide
    });
}

/* ------------------------------------------------------------------ */
/* Procedural helpers                                                 */
/* ------------------------------------------------------------------ */

function curveTubeMesh(id, color, points, radius) {
    const curve = new THREE.CatmullRomCurve3(
        points.map(p => new THREE.Vector3(p[0], p[1], p[2]))
    );
    const geom = new THREE.TubeGeometry(curve, 80, radius || 0.035, 12, false);
    const mat = makeStudioMaterial(color, 1, 0.58, 0.03);
    return tagMesh(new THREE.Mesh(geom, mat), id, 1, color);
}

function dotsGroup(id, color, count, spread) {
    const group = new THREE.Group();
    for (let i = 0; i < count; i++) {
        const a = i * 1.71;
        const b = i * 2.37;
        const x = Math.sin(a) * spread[0];
        const y = Math.cos(b) * spread[1];
        const z = Math.sin(a + b) * spread[2];
        const radius = 0.055 + (i % 3) * 0.018;
        const geom = new THREE.SphereGeometry(radius, 18, 18);
        const mat = makeStudioMaterial(color, 0.92, 0.66, 0.03);
        const mesh = tagMesh(new THREE.Mesh(geom, mat), id, 0.92, color);
        mesh.position.set(x, y, z);
        group.add(mesh);
    }
    return group;
}

function nucleusGroup(id, position, scale, color) {
    id = id || "nucleus";
    color = color || "#7047a8";
    const group = new THREE.Group();

    const outer = new THREE.Mesh(
        new THREE.SphereGeometry(1, 48, 48),
        makeStudioMaterial(color, 0.92, 0.44, 0.03)
    );
    tagMesh(outer, id, 0.92, color);
    group.add(outer);

    const dot = new THREE.Mesh(
        new THREE.SphereGeometry(0.23, 28, 28),
        makeStudioMaterial("#b56ad8", 0.9, 0.66, 0.03)
    );
    tagMesh(dot, id, 0.9, "#b56ad8");
    dot.position.set(0.2, 0.16, 0.38);
    group.add(dot);

    group.position.set(position[0], position[1], position[2]);
    group.scale.set(scale[0], scale[1], scale[2]);
    return group;
}

function mitochondrionGroup(id, position, rotation, scale) {
    id = id || "mitochondrion";
    rotation = rotation || [0, 0, 0];
    scale = scale || [1, 1, 1];
    const group = new THREE.Group();

    const body = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.16, 0.46, 10, 24),
        makeStudioMaterial("#cf7042", 1, 0.66, 0.03)
    );
    tagMesh(body, id, 1, "#cf7042");
    group.add(body);

    for (let i = 0; i < 3; i++) {
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.09, 0.012, 8, 18),
            makeStudioMaterial("#f0b074", 1, 0.66, 0.03)
        );
        tagMesh(ring, id, 1, "#f0b074");
        ring.position.set(0, -0.18 + i * 0.18, 0.02);
        ring.rotation.x = Math.PI / 2;
        group.add(ring);
    }

    group.position.set(position[0], position[1], position[2]);
    group.rotation.set(rotation[0], rotation[1], rotation[2]);
    group.scale.set(scale[0], scale[1], scale[2]);
    return group;
}

/* ------------------------------------------------------------------ */
/* Procedural cell models                                             */
/* ------------------------------------------------------------------ */

function buildPlantModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.1, -0.28, 0);

    const wallOuter = new THREE.Mesh(
        new RoundedBoxGeometry(4.7, 2.7, 0.42, 8, 0.18),
        makeStudioMaterial("#84ad4a", crossSection ? 0.34 : 0.5, 0.66, 0.03)
    );
    tagMesh(wallOuter, "cellWall", crossSection ? 0.34 : 0.5, "#84ad4a");
    root.add(wallOuter);

    const wallInner = new THREE.Mesh(
        new RoundedBoxGeometry(4.18, 2.24, 0.24, 8, 0.12),
        makeStudioMaterial("#4f9f83", 0.24, 0.66, 0.03)
    );
    tagMesh(wallInner, "cellWall", 0.24, "#4f9f83");
    wallInner.position.set(0.02, 0.02, 0.08);
    root.add(wallInner);

    const vacuole = new THREE.Mesh(
        new THREE.SphereGeometry(0.78, 46, 46),
        makeStudioMaterial("#62bdd2", 0.74, 0.66, 0.03)
    );
    tagMesh(vacuole, "vacuole", 0.74, "#62bdd2");
    vacuole.position.set(-0.45, -0.12, 0.32);
    vacuole.scale.set(1.05, 0.78, 0.28);
    root.add(vacuole);

    root.add(nucleusGroup("nucleus", [0.92, 0.42, 0.45], [0.52, 0.52, 0.38]));

    [[-1.65, 0.48, 0.28], [1.68, -0.38, 0.3], [-1.52, -0.62, 0.22]].forEach((pos, i) => {
        const grp = new THREE.Group();
        grp.position.set(pos[0], pos[1], pos[2]);
        grp.rotation.z = i * 0.7;
        const body = new THREE.Mesh(
            new THREE.SphereGeometry(1, 30, 20),
            makeStudioMaterial("#67ad46", 1, 0.66, 0.03)
        );
        tagMesh(body, "chloroplast", 1, "#67ad46");
        body.scale.set(0.35, 0.18, 0.12);
        grp.add(body);

        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.22, 0.012, 8, 42),
            makeStudioMaterial("#9ed36a", 1, 0.66, 0.03)
        );
        tagMesh(ring, "chloroplast", 1, "#9ed36a");
        ring.rotation.x = Math.PI / 2;
        ring.scale.set(1, 0.82, 1);
        grp.add(ring);

        root.add(grp);
    });

    root.add(mitochondrionGroup("mitochondrion",
        [0.28, -0.72, 0.42], [0.3, 0.2, 1.35], [0.95, 0.95, 0.95]));

    root.add(curveTubeMesh("nucleus", "#ce785c",
        [[0.42, 0.12, 0.42], [0.62, -0.06, 0.5], [1.05, -0.08, 0.46], [1.44, 0.06, 0.38]],
        0.05));

    root.add(dotsGroup("vacuole", "#c76ac5", 18, [1.72, 0.92, 0.42]));

    return root;
}

function buildWhiteBloodModel(crossSection) {
    const root = new THREE.Group();
    root.scale.set(1.2, 1.2, 1.2);

    const membrane = new THREE.Mesh(
        new THREE.SphereGeometry(1.35, 64, 64),
        makeStudioMaterial("#d6d7e6", crossSection ? 0.28 : 0.45, 0.66, 0.03)
    );
    tagMesh(membrane, "membrane", crossSection ? 0.28 : 0.45, "#d6d7e6");
    root.add(membrane);

    [[-0.42, 0.22, 0.34], [0.28, 0.06, 0.36], [0.02, -0.42, 0.28]].forEach(pos => {
        root.add(nucleusGroup("nucleus", pos, [0.42, 0.36, 0.28], "#6c35a0"));
    });

    root.add(dotsGroup("granules", "#c06696", 30, [1.05, 1.02, 0.72]));
    root.add(dotsGroup("lysosome", "#8b54b7", 12, [0.92, 0.88, 0.62]));

    return root;
}

function buildNeuronModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.02, -0.2, 0);
    root.scale.set(1.05, 1.05, 1.05);

    root.add(nucleusGroup("soma", [-0.55, 0, 0.08], [0.64, 0.58, 0.44], "#774eb2"));

    const somaShell = new THREE.Mesh(
        new THREE.SphereGeometry(1, 52, 52),
        makeStudioMaterial("#8db5d8", crossSection ? 0.36 : 0.55, 0.66, 0.03)
    );
    tagMesh(somaShell, "soma", crossSection ? 0.36 : 0.55, "#8db5d8");
    somaShell.position.set(-0.55, 0, 0);
    somaShell.scale.set(0.94, 0.82, 0.62);
    root.add(somaShell);

    root.add(curveTubeMesh("axon", "#6b7dc6",
        [[0.04, 0.02, 0.04], [0.72, -0.02, 0.02], [1.56, 0.04, 0.02], [2.35, -0.04, 0]],
        0.08));

    [0.55, 1.06, 1.58, 2.08].forEach(x => {
        const seg = new THREE.Mesh(
            new THREE.CapsuleGeometry(0.16, 0.24, 8, 24),
            makeStudioMaterial("#bfd1df", 0.94, 0.66, 0.03)
        );
        tagMesh(seg, "axon", 0.94, "#bfd1df");
        seg.position.set(x, 0, 0.02);
        seg.rotation.z = Math.PI / 2;
        root.add(seg);
    });

    const dendritePaths = [
        [[-1.08, 0.28, 0], [-1.55, 0.82, 0.08], [-2.1, 1.03, 0]],
        [[-1.16, -0.18, 0], [-1.7, -0.54, 0.05], [-2.2, -0.9, 0]],
        [[-0.78, 0.58, 0.04], [-0.82, 1.16, 0.02], [-1.12, 1.58, 0]],
        [[-0.9, -0.55, 0.04], [-0.92, -1.04, 0], [-1.2, -1.44, 0.02]]
    ];
    dendritePaths.forEach(pts => {
        root.add(curveTubeMesh("dendrites", "#7d9bcf", pts, 0.052));
    });

    root.add(dotsGroup("dendrites", "#b46ac7", 12, [2.2, 1.4, 0.2]));

    return root;
}

function buildEpithelialModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.08, -0.22, 0);
    root.scale.set(1.08, 1.08, 1.08);

    const membrane = new THREE.Mesh(
        new RoundedBoxGeometry(2.4, 2.0, 0.72, 8, 0.1),
        makeStudioMaterial("#d79baa", crossSection ? 0.32 : 0.52, 0.66, 0.03)
    );
    tagMesh(membrane, "membrane", crossSection ? 0.32 : 0.52, "#d79baa");
    membrane.position.set(0, -0.12, 0);
    root.add(membrane);

    for (let i = 0; i < 12; i++) {
        const villus = new THREE.Mesh(
            new THREE.CapsuleGeometry(0.045, 0.34, 8, 14),
            makeStudioMaterial("#c86f80", 1, 0.66, 0.03)
        );
        tagMesh(villus, "microvilli", 1, "#c86f80");
        villus.position.set(-1.1 + i * 0.2, 1.04, 0.08);
        root.add(villus);
    }

    root.add(nucleusGroup("nucleus", [0.15, -0.2, 0.32], [0.55, 0.5, 0.36]));

    root.add(curveTubeMesh("junctions", "#9f6cbd",
        [[-1.18, 0.74, 0.38], [-0.6, 0.7, 0.44], [0.1, 0.73, 0.4], [0.96, 0.68, 0.42]],
        0.04));

    root.add(dotsGroup("nucleus", "#d082a2", 18, [0.96, 0.72, 0.38]));

    return root;
}

function buildBacteriaModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.02, 0.1, -0.02);
    root.scale.set(1.12, 1.12, 1.12);

    const outer = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.78, 2.9, 14, 48),
        makeStudioMaterial("#65b8ae", crossSection ? 0.36 : 0.62, 0.66, 0.03)
    );
    tagMesh(outer, "cellWall", crossSection ? 0.36 : 0.62, "#65b8ae");
    outer.rotation.z = Math.PI / 2;
    root.add(outer);

    const inner = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.62, 2.6, 12, 40),
        makeStudioMaterial("#235a74", 0.44, 0.66, 0.03)
    );
    tagMesh(inner, "cellWall", 0.44, "#235a74");
    inner.rotation.z = Math.PI / 2;
    inner.scale.set(0.88, 0.88, 0.82);
    root.add(inner);

    root.add(curveTubeMesh("nucleoid", "#7a43ad",
        [[-0.9, 0.12, 0.3], [-0.42, -0.14, 0.38], [0.1, 0.18, 0.34], [0.62, -0.12, 0.36], [1.02, 0.06, 0.32]],
        0.12));

    root.add(curveTubeMesh("flagellum", "#b87438",
        [[1.82, -0.22, 0.08], [2.35, -0.72, 0], [2.95, -0.5, 0.02], [3.55, -0.95, 0]],
        0.055));

    root.add(dotsGroup("nucleoid", "#e59b3a", 34, [1.42, 0.48, 0.36]));

    return root;
}

function buildAnimalModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.06, -0.34, 0);
    root.scale.set(1.08, 1.08, 1.08);

    const membrane = new THREE.Mesh(
        new THREE.SphereGeometry(1, 64, 64),
        makeStudioMaterial("#9db6dc", crossSection ? 0.28 : 0.48, 0.66, 0.03)
    );
    tagMesh(membrane, "membrane", crossSection ? 0.28 : 0.48, "#9db6dc");
    membrane.scale.set(1.7, 1.25, 0.72);
    root.add(membrane);

    root.add(nucleusGroup("nucleus", [0.22, 0.18, 0.36], [0.55, 0.55, 0.42]));
    root.add(mitochondrionGroup("mitochondrion", [-0.82, 0.44, 0.32], [0.4, 0.1, 1.12]));
    root.add(mitochondrionGroup("mitochondrion", [0.82, -0.42, 0.25], [0.1, 0.35, -0.75], [0.9, 0.9, 0.9]));

    for (let i = 0; i < 4; i++) {
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.38 + i * 0.035, 0.025, 10, 52),
            makeStudioMaterial("#d49057", 1, 0.66, 0.03)
        );
        tagMesh(ring, "golgi", 1, "#d49057");
        ring.position.set(-0.24 + i * 0.18, -0.56 + i * 0.08, 0.46);
        ring.rotation.set(0.2, 0, 0.7);
        root.add(ring);
    }

    root.add(dotsGroup("nucleus", "#b35fc8", 28, [1.25, 0.85, 0.46]));

    return root;
}

function buildMuscleModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.15, -0.26, -0.03);
    root.scale.set(1.08, 1.08, 1.08);

    const sheath = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.76, 2.9, 14, 48),
        makeStudioMaterial("#d7b284", crossSection ? 0.26 : 0.42, 0.66, 0.03)
    );
    tagMesh(sheath, "sarcolemma", crossSection ? 0.26 : 0.42, "#d7b284");
    sheath.rotation.z = Math.PI / 2;
    sheath.scale.set(0.95, 1, 0.82);
    root.add(sheath);

    [-0.42, 0, 0.42].forEach((y, row) => {
        [-0.58, 0.24, 1.06].forEach((x, i) => {
            const fiber = new THREE.Mesh(
                new THREE.CylinderGeometry(0.13, 0.13, 0.86, 24),
                makeStudioMaterial(i % 2 === 0 ? "#bd3d51" : "#cf6272", 1, 0.66, 0.03)
            );
            tagMesh(fiber, "myofibril", 1, i % 2 === 0 ? "#bd3d51" : "#cf6272");
            fiber.position.set(x, y, 0.15);
            fiber.rotation.y = Math.PI / 2;
            root.add(fiber);
        });
    });

    [-1.1, 1.42].forEach((x, i) => {
        root.add(nucleusGroup("mitochondria",
            [x, 0.54 - i * 0.92, 0.36], [0.26, 0.2, 0.18], "#cf7042"));
    });

    for (let i = 0; i < 5; i++) {
        root.add(curveTubeMesh("sarcolemma", "#ead2a7",
            [[-1.55 + i * 0.65, -0.86, 0.26],
             [-1.45 + i * 0.65, -0.24, 0.34],
             [-1.55 + i * 0.65, 0.72, 0.28]],
            0.035));
    }

    return root;
}

/* ------------------------------------------------------------------ */
/* Extended cell models (red blood, sperm, yeast, cardiomyocyte, virus)
/* ------------------------------------------------------------------ */

function buildRedBloodModel() {
    const root = new THREE.Group();
    root.scale.set(1.5, 1.5, 1.5);

    // Biconcave-disc profile (Evans-Fung approximation, revolved via
    // LatheGeometry). Profile traces the top half of the cross-section
    // outward, then the bottom half back inward, forming a closed
    // silhouette that the lathe revolves 360° into a complete disc.
    const D0 = 0.40, C0 = 0.21, C1 = 2.0, C2 = -1.12;
    const N = 32;
    const profile = [];
    for (let i = 0; i <= N; i++) {
        const r = i / N;
        const r2 = r * r;
        const halfThick = D0 * Math.sqrt(Math.max(0, 1 - r2)) * (C0 + C1 * r2 + C2 * r2 * r2);
        profile.push(new THREE.Vector2(r, halfThick));
    }
    for (let i = N - 1; i >= 0; i--) {
        const r = i / N;
        const r2 = r * r;
        const halfThick = D0 * Math.sqrt(Math.max(0, 1 - r2)) * (C0 + C1 * r2 + C2 * r2 * r2);
        profile.push(new THREE.Vector2(r, -halfThick));
    }
    const discGeom = new THREE.LatheGeometry(profile, 64);
    const disc = new THREE.Mesh(discGeom, makeStudioMaterial("#d96565", 0.86, 0.5, 0.03));
    tagMesh(disc, "membrane", 0.86, "#d96565");
    root.add(disc);

    // Hemoglobin grains scattered through the interior.
    root.add(dotsGroup("hemoglobin", "#b8323a", 36, [0.85, 0.18, 0.85]));

    // Spectrin cytoskeleton — thin arcs hugging the rim.
    const RING = 14;
    for (let i = 0; i < RING; i++) {
        const a = (i / RING) * Math.PI * 2;
        const x = Math.cos(a), z = Math.sin(a);
        root.add(curveTubeMesh("cytoskeleton", "#8b465a",
            [[x * 0.08, 0.04, z * 0.08], [x * 0.55, 0.0, z * 0.55], [x * 0.95, 0.02, z * 0.95]],
            0.012));
    }

    return root;
}

function buildSpermModel() {
    const root = new THREE.Group();
    root.rotation.set(0.02, 0.18, 0);
    root.scale.set(1.0, 1.0, 1.0);

    // Head — flattened oval.
    const head = new THREE.Mesh(
        new THREE.SphereGeometry(0.42, 36, 36),
        makeStudioMaterial("#7a49b0", 0.95, 0.48, 0.03)
    );
    tagMesh(head, "head", 0.95, "#7a49b0");
    head.scale.set(0.7, 0.5, 0.7);
    head.position.set(-1.55, 0, 0);
    root.add(head);

    // Acrosome — translucent cap at the front tip.
    const acrosome = new THREE.Mesh(
        new THREE.SphereGeometry(0.42, 32, 32),
        makeStudioMaterial("#c9a8ee", 0.78, 0.5, 0.04)
    );
    tagMesh(acrosome, "acrosome", 0.78, "#c9a8ee");
    acrosome.scale.set(0.6, 0.42, 0.6);
    acrosome.position.set(-1.92, 0, 0);
    root.add(acrosome);

    // Midpiece — thin cylinder linking head to flagellum.
    const midpiece = new THREE.Mesh(
        new THREE.CylinderGeometry(0.085, 0.08, 0.7, 28),
        makeStudioMaterial("#cf7042", 0.95, 0.5, 0.03)
    );
    tagMesh(midpiece, "midpiece", 0.95, "#cf7042");
    midpiece.rotation.z = Math.PI / 2;
    midpiece.position.set(-0.95, 0, 0);
    root.add(midpiece);

    // Mitochondrial spiral wrapped around the midpiece.
    const COILS = 22;
    for (let i = 0; i < COILS; i++) {
        const t = i / (COILS - 1);
        const phase = t * Math.PI * 8;
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.115, 0.02, 8, 16),
            makeStudioMaterial("#f0b074", 1, 0.5, 0.03)
        );
        tagMesh(ring, "midpiece", 1, "#f0b074");
        ring.position.set(-1.29 + t * 0.7, 0, 0);
        ring.rotation.z = Math.PI / 2;
        ring.rotation.y = phase;
        root.add(ring);
    }

    // Flagellum — sinuous tube extending behind the midpiece.
    root.add(curveTubeMesh("flagellum", "#7d9bcf",
        [[-0.6, 0.0, 0.0], [0.05, 0.14, 0], [0.7, -0.16, 0],
         [1.4, 0.12, 0], [2.05, -0.06, 0]],
        0.05));

    return root;
}

function buildYeastModel() {
    const root = new THREE.Group();
    root.rotation.set(0.02, -0.12, 0);
    root.scale.set(1.1, 1.1, 1.1);

    // Mother cell — chitin/glucan outer wall (translucent).
    const wall = new THREE.Mesh(
        new THREE.SphereGeometry(1.15, 56, 56),
        makeStudioMaterial("#d5a849", 0.42, 0.6, 0.03)
    );
    tagMesh(wall, "cellWall", 0.42, "#d5a849");
    root.add(wall);

    // Inner plasma-membrane shell, slightly darker.
    const inner = new THREE.Mesh(
        new THREE.SphereGeometry(1.0, 48, 48),
        makeStudioMaterial("#b88040", 0.3, 0.6, 0.03)
    );
    tagMesh(inner, "cellWall", 0.3, "#b88040");
    root.add(inner);

    // Daughter bud — smaller sphere attached at one shoulder.
    const budCenter = new THREE.Vector3(1.05, 0.45, 0.3);
    const budR = 0.55;
    const bud = new THREE.Mesh(
        new THREE.SphereGeometry(budR, 44, 44),
        makeStudioMaterial("#dab15c", 0.42, 0.6, 0.03)
    );
    tagMesh(bud, "bud", 0.42, "#dab15c");
    bud.position.copy(budCenter);
    root.add(bud);

    const budInner = new THREE.Mesh(
        new THREE.SphereGeometry(budR * 0.87, 32, 32),
        makeStudioMaterial("#b88040", 0.3, 0.6, 0.03)
    );
    tagMesh(budInner, "bud", 0.3, "#b88040");
    budInner.position.copy(budCenter);
    root.add(budInner);

    // Central nucleus.
    root.add(nucleusGroup("nucleus", [0.05, 0.05, 0.1], [0.42, 0.42, 0.42], "#7047a8"));

    // Vacuole — translucent blue sphere offset to one side.
    const vacuole = new THREE.Mesh(
        new THREE.SphereGeometry(0.5, 36, 36),
        makeStudioMaterial("#62bdd2", 0.55, 0.5, 0.03)
    );
    tagMesh(vacuole, "vacuole", 0.55, "#62bdd2");
    vacuole.position.set(-0.42, -0.32, 0.28);
    root.add(vacuole);

    // A few mitochondria scattered in the cytoplasm.
    root.add(mitochondrionGroup("nucleus", [0.32, 0.55, 0.42], [0.2, 0, 0.9], [0.55, 0.55, 0.55]));
    root.add(mitochondrionGroup("nucleus", [0.52, -0.5, -0.18], [0.15, 0.4, -0.55], [0.5, 0.5, 0.5]));

    return root;
}

function buildCardiomyocyteModel() {
    const root = new THREE.Group();
    root.rotation.set(0.08, -0.22, 0);
    root.scale.set(1.05, 1.05, 1.05);

    // Main fibre body — long capsule.
    const body = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.52, 2.6, 14, 32),
        makeStudioMaterial("#d18494", 0.5, 0.6, 0.03)
    );
    tagMesh(body, "sarcolemma", 0.5, "#d18494");
    body.rotation.z = Math.PI / 2;
    root.add(body);

    // Branching daughter fibres (the "Y" that distinguishes cardiac
    // muscle from the parallel-bundled skeletal cell).
    const branchA = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.36, 1.0, 12, 28),
        makeStudioMaterial("#d18494", 0.5, 0.6, 0.03)
    );
    tagMesh(branchA, "sarcolemma", 0.5, "#d18494");
    branchA.rotation.z = Math.PI / 2 + Math.PI / 4;
    branchA.position.set(1.55, 0.6, 0);
    root.add(branchA);

    const branchB = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.34, 0.95, 12, 28),
        makeStudioMaterial("#d18494", 0.5, 0.6, 0.03)
    );
    tagMesh(branchB, "sarcolemma", 0.5, "#d18494");
    branchB.rotation.z = Math.PI / 2 - Math.PI / 4;
    branchB.position.set(-1.45, -0.55, 0);
    root.add(branchB);

    // Single central nucleus — distinguishes from skeletal (many nuclei).
    root.add(nucleusGroup("sarcomere", [0.05, 0.0, 0.25], [0.38, 0.32, 0.32], "#7a49b0"));

    // Sarcomere striations — bands across the body length.
    for (let i = -6; i <= 6; i++) {
        const stripe = new THREE.Mesh(
            new THREE.CylinderGeometry(0.5, 0.5, 0.05, 28),
            makeStudioMaterial(i % 2 === 0 ? "#a04d5a" : "#c1626e", 0.62, 0.6, 0.03)
        );
        tagMesh(stripe, "sarcomere", 0.62, i % 2 === 0 ? "#a04d5a" : "#c1626e");
        stripe.rotation.z = Math.PI / 2;
        stripe.position.set(i * 0.22, 0, 0);
        root.add(stripe);
    }

    // Mitochondria — cardiomyocytes are mitochondria-rich.
    for (let i = 0; i < 7; i++) {
        const x = -1.3 + i * 0.45;
        root.add(mitochondrionGroup("mitochondrion",
            [x, 0.32 * Math.sin(i * 1.3), 0.3], [0.15, 0, 1.55], [0.62, 0.62, 0.62]));
    }

    // Intercalated discs — at the end-to-end junctions.
    [-1.55, 1.55].forEach(x => {
        const disc = new THREE.Mesh(
            new THREE.CylinderGeometry(0.5, 0.5, 0.06, 28),
            makeStudioMaterial("#5e3a4d", 0.92, 0.65, 0.05)
        );
        tagMesh(disc, "intercalatedDisc", 0.92, "#5e3a4d");
        disc.rotation.z = Math.PI / 2;
        disc.position.set(x, 0, 0);
        root.add(disc);
    });

    return root;
}

function buildVirusModel() {
    const root = new THREE.Group();
    root.scale.set(1.35, 1.35, 1.35);

    // Icosahedral capsid — detail level 1 to get a faceted look.
    const capsidGeom = new THREE.IcosahedronGeometry(1.0, 1);
    const capsid = new THREE.Mesh(capsidGeom, makeStudioMaterial("#b85a9c", 0.92, 0.45, 0.05));
    tagMesh(capsid, "capsid", 0.92, "#b85a9c");
    root.add(capsid);

    // Spike proteins — cones pointing outward at the 12 icosahedron vertices.
    // Hand-built unit vectors instead of de-duping geometry attributes
    // (the IcosahedronGeometry duplicates verts per face).
    const phi = (1 + Math.sqrt(5)) / 2;
    const inv = 1 / Math.sqrt(1 + phi * phi);
    const icoVerts = [
        [0,  1,  phi], [0,  1, -phi], [0, -1,  phi], [0, -1, -phi],
        [ 1,  phi, 0], [ 1, -phi, 0], [-1,  phi, 0], [-1, -phi, 0],
        [ phi, 0,  1], [ phi, 0, -1], [-phi, 0,  1], [-phi, 0, -1]
    ].map(v => new THREE.Vector3(v[0] * inv, v[1] * inv, v[2] * inv));

    icoVerts.forEach(dir => {
        const spike = new THREE.Mesh(
            new THREE.ConeGeometry(0.08, 0.32, 14),
            makeStudioMaterial("#e07ec0", 0.96, 0.5, 0.05)
        );
        tagMesh(spike, "spike", 0.96, "#e07ec0");
        spike.position.copy(dir).multiplyScalar(1.08);
        spike.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), dir.clone().normalize());
        root.add(spike);
    });

    // Genome — a tangled curve tube hinting at the packed nucleic acid.
    root.add(curveTubeMesh("genome", "#7a43ad",
        [[-0.35, 0.22, 0.12], [0.12, -0.18, 0.32], [-0.22, 0.16, -0.22],
         [0.24, 0.28, 0.04], [-0.12, -0.32, 0.20], [0.30, -0.05, -0.18]],
        0.06));

    return root;
}

const PROCEDURAL_BUILDERS = {
    plant: buildPlantModel,
    whiteBlood: buildWhiteBloodModel,
    neuron: buildNeuronModel,
    epithelial: buildEpithelialModel,
    bacteria: buildBacteriaModel,
    animal: buildAnimalModel,
    muscle: buildMuscleModel,
    redBlood: buildRedBloodModel,
    sperm: buildSpermModel,
    yeast: buildYeastModel,
    cardiomyocyte: buildCardiomyocyteModel,
    virus: buildVirusModel
};

/* ------------------------------------------------------------------ */
/* Vertex-color painting for non-native GLB assets                    */
/* ------------------------------------------------------------------ */

function applyAssetVertexColors(mesh, cell) {
    const geometry = mesh.geometry;
    const position = geometry.getAttribute("position");
    if (!position) return;
    geometry.computeBoundingBox();
    const box = geometry.boundingBox;
    if (!box) return;

    const sizeX = Math.max(box.max.x - box.min.x, 0.001);
    const sizeY = Math.max(box.max.y - box.min.y, 0.001);
    const sizeZ = Math.max(box.max.z - box.min.z, 0.001);
    const palette = [new THREE.Color(cell.color), new THREE.Color(cell.accent)]
        .concat(cell.organelles.map(o => new THREE.Color(o.color)));
    const highlight = new THREE.Color("#fff4d8");
    const shadow = new THREE.Color("#3d4a72");
    const base = new THREE.Color(cell.color);
    const colors = [];

    for (let i = 0; i < position.count; i++) {
        const x = position.getX(i);
        const y = position.getY(i);
        const z = position.getZ(i);
        const nx = (x - box.min.x) / sizeX;
        const ny = (y - box.min.y) / sizeY;
        const nz = (z - box.min.z) / sizeZ;
        const flow = Math.sin(nx * 11.6 + ny * 4.8) + Math.cos(ny * 9.4 + nz * 7.2);
        const pIdx = Math.abs(Math.floor((flow + nx * 3.2 + ny * 2.6) * palette.length)) % palette.length;
        const c = base.clone().lerp(palette[pIdx], 0.48);
        c.lerp(highlight, Math.max(0, nz - 0.24) * 0.22);
        c.lerp(shadow, Math.max(0, 0.32 - nz) * 0.12);
        colors.push(c.r, c.g, c.b);
    }
    geometry.setAttribute("color", new THREE.Float32BufferAttribute(colors, 3));
}

function createStudioAssetMaterial(original, cell, viewMode, crossSection) {
    const source = Array.isArray(original) ? original[0] : original;
    const src = source || {};
    const material = new THREE.MeshStandardMaterial({
        color: 0xffffff,
        map: src.map || null,
        normalMap: src.normalMap || null,
        roughnessMap: src.roughnessMap || null,
        metalnessMap: src.metalnessMap || null,
        side: THREE.DoubleSide,
        vertexColors: true,
        transparent: crossSection || viewMode === "focus" || !!src.transparent,
        opacity: crossSection ? 0.92 : viewMode === "focus" ? 0.95 : (src.opacity != null ? src.opacity : 1),
        roughness: Math.min(0.82, src.roughness != null ? src.roughness : 0.46),
        metalness: Math.min(0.12, src.metalness != null ? src.metalness : 0.03),
        emissive: new THREE.Color(cell.accent).lerp(new THREE.Color("#ffffff"), 0.58),
        emissiveIntensity: viewMode === "focus" ? 0.045 : 0.016
    });
    material.envMapIntensity = 0.75 * ((cell.modelAsset && cell.modelAsset.exposure) || 1);
    material.needsUpdate = true;
    return material;
}

function cloneNativeAssetMaterial(source, asset, crossSection) {
    const clone = source.clone();
    clone.side = THREE.DoubleSide;
    clone.transparent = crossSection || clone.transparent;
    clone.opacity = crossSection ? Math.min(clone.opacity, 0.86) : clone.opacity;

    if (clone.isMeshStandardMaterial) {
        const displayMap = clone.map || null;
        if (displayMap) {
            displayMap.anisotropy = 8;
            displayMap.needsUpdate = true;
        }
        clone.vertexColors = false;
        clone.emissive = new THREE.Color("#fff8eb");
        clone.emissiveMap = displayMap;
        clone.emissiveIntensity = 0.07 * (asset.exposure || 1);
        clone.envMapIntensity = 0.62 * (asset.exposure || 1);
        clone.roughness = Math.max(0.34, Math.min(clone.roughness, 0.58));
        clone.metalness = Math.min(clone.metalness, 0.08);
        clone.color.setRGB(1.04, 1.035, 1.02);
    }
    clone.needsUpdate = true;
    return clone;
}

/* ------------------------------------------------------------------ */
/* Material updates per state change                                  */
/* ------------------------------------------------------------------ */

function updateMaterials(group, activeOrganelle, viewMode) {
    group.traverse(node => {
        if (!node.isMesh) return;
        const mat = node.material;
        if (!mat || Array.isArray(mat)) return;
        if (!mat.isMeshStandardMaterial) return;
        if (node.userData.assetMode === "native") return; // native materials managed elsewhere

        const id = node.userData.organelleId;
        const baseOpacity = node.userData.baseOpacity != null ? node.userData.baseOpacity : 1;
        const baseColor = node.userData.baseColor;
        const active = id && id === activeOrganelle;
        const dimmed = viewMode === "focus" && !active;

        mat.transparent = baseOpacity < 1 || dimmed;
        mat.opacity = dimmed ? Math.min(baseOpacity, 0.18) : baseOpacity;
        if (active && baseColor) {
            mat.emissive.set(baseColor);
            mat.emissiveIntensity = 0.34;
        } else {
            mat.emissive.set(0x000000);
            mat.emissiveIntensity = 0;
        }
        mat.needsUpdate = true;
    });
}

/* ------------------------------------------------------------------ */
/* GLB loading                                                        */
/* ------------------------------------------------------------------ */

const gltfLoader = new GLTFLoader();
const gltfCache = new Map();

/* loadGLB optionally surfaces real byte-level progress to the caller —
   the underlying GLTFLoader passes through XHR ProgressEvents which have
   {loaded, total, lengthComputable}. Cached hits resolve synchronously
   with a single 100% tick so the loader UI can dismiss immediately. */
function loadGLB(url, onProgress) {
    if (gltfCache.has(url)) {
        if (onProgress) onProgress({ loaded: 1, total: 1 });
        return Promise.resolve(gltfCache.get(url));
    }
    return new Promise((resolve, reject) => {
        gltfLoader.load(
            url,
            gltf => { gltfCache.set(url, gltf); resolve(gltf); },
            xhr => {
                if (onProgress && xhr && xhr.total > 0) {
                    onProgress({ loaded: xhr.loaded, total: xhr.total });
                }
            },
            err => reject(err)
        );
    });
}

function buildAssetGroup(gltf, cell, viewMode, crossSection) {
    const asset = cell.modelAsset;
    const clone = gltf.scene.clone(true);
    const isNative = asset.materialMode === "native";

    clone.traverse(node => {
        if (!node.isMesh) return;
        node.castShadow = true;
        node.receiveShadow = true;
        if (isNative) {
            const orig = node.material;
            node.material = Array.isArray(orig)
                ? orig.map(m => cloneNativeAssetMaterial(m, asset, crossSection))
                : cloneNativeAssetMaterial(orig, asset, crossSection);
            node.userData.assetMode = "native";
        } else {
            node.geometry.computeVertexNormals();
            applyAssetVertexColors(node, cell);
            node.material = createStudioAssetMaterial(node.material, cell, viewMode, crossSection);
            node.userData.assetMode = "studio-asset";
            // GLB meshes don't carry organelle ids, so they always render
            // with their base opacity; viewMode focus dimming is baked into
            // the studio-asset material itself.
            node.userData.organelleId = "_asset_";
            node.userData.baseOpacity = node.material.opacity;
        }
    });

    // Center the scene at the origin.
    const box = new THREE.Box3().setFromObject(clone);
    const center = box.getCenter(new THREE.Vector3());
    clone.position.sub(center);

    const outer = new THREE.Group();
    outer.add(clone);

    const pos = asset.position || [0, 0, 0];
    const rot = asset.rotation || [0, 0, 0];
    outer.position.set(pos[0], pos[1], pos[2]);
    outer.rotation.set(rot[0], rot[1], rot[2]);
    outer.scale.set(asset.scale, asset.scale, asset.scale);
    return outer;
}

/* ------------------------------------------------------------------ */
/* Disposal                                                           */
/* ------------------------------------------------------------------ */

function disposeGroup(group) {
    group.traverse(node => {
        if (node.isMesh) {
            // Geometry is per-mesh and safe to dispose.
            if (node.geometry) node.geometry.dispose();
            // Materials may be shared (GLB clone reuses textures); only
            // dispose materials we own (studio mode creates fresh ones).
            const m = node.material;
            if (m) {
                if (Array.isArray(m)) m.forEach(x => x.dispose && x.dispose());
                else if (m.dispose) m.dispose();
            }
        }
    });
}

/* ------------------------------------------------------------------ */
/* Main controller                                                    */
/* ------------------------------------------------------------------ */

function mount(canvas, opts) {
    opts = opts || {};
    const onProgress = opts.onProgress || function () {};
    const onError = opts.onError || function () {};
    const onPick = opts.onPick || function () {};

    const renderer = new THREE.WebGLRenderer({
        canvas,
        antialias: true,
        alpha: true,
        premultipliedAlpha: false
    });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    renderer.outputColorSpace = THREE.SRGBColorSpace;
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    /* Real cross-section: a single horizontal clipping plane drives every
       material in the scene at GPU level. clipPlane.constant is the Y
       value below which geometry stays visible (normal (0,-1,0) clips
       where -y + constant < 0, i.e. y > constant). The translucent
       membrane on top of the clipped interior gives a "cut-open" look. */
    renderer.localClippingEnabled = true;

    const scene = new THREE.Scene();

    const camera = new THREE.PerspectiveCamera(38, 1, 0.1, 100);
    camera.position.set(0, 0.2, 5.8);

    const controls = new OrbitControls(camera, canvas);
    controls.enableDamping = true;
    controls.dampingFactor = 0.08;
    controls.enablePan = true;
    controls.minDistance = 3.2;
    controls.maxDistance = 8.4;

    // Lights — re-tuned each cell change for native vs. studio modes.
    const ambient = new THREE.AmbientLight(0xffffff, 1.28);
    const hemi = new THREE.HemisphereLight(0xfff8ea, 0xe3ded2, 1.18);
    const dir = new THREE.DirectionalLight(0xffffff, 2.75);
    dir.position.set(4.2, 5.2, 5.8);
    dir.castShadow = true;
    dir.shadow.mapSize.set(1024, 1024);
    dir.shadow.camera.near = 0.5;
    dir.shadow.camera.far = 30;
    dir.shadow.camera.left = -5;
    dir.shadow.camera.right = 5;
    dir.shadow.camera.top = 5;
    dir.shadow.camera.bottom = -5;
    const dirFill = new THREE.DirectionalLight(0xfff1df, 0); // only for native mode
    dirFill.position.set(-4.4, 2.2, 3.6);
    const spot = new THREE.SpotLight(0xfff8ec, 1.45, 0, 0.42, 0.74, 1);
    spot.position.set(-3.6, 3.2, 4.6);
    const point = new THREE.PointLight(0xffffff, 0.6);
    point.position.set(2.8, -1.2, 3.2);
    scene.add(ambient, hemi, dir, dirFill, spot, point);

    /* Contact-shadow ground — drei's <ContactShadows> replacement.
       Stack of two planes so we approximate the soft circular blur:
         (a) a radial-gradient CanvasTexture (always visible, gives the
             ambient-occlusion-like blob beneath the cell), and
         (b) a ShadowMaterial plane that catches geometric shadows cast
             by the directional light (adds shape-aware detail on top).
       Opacity + scale are retuned per native/studio mode in
       applyLightsForCell so we match the reference's two-mode tuning. */
    function makeContactShadowTexture() {
        const size = 256;
        const canvas = document.createElement("canvas");
        canvas.width = size; canvas.height = size;
        const ctx = canvas.getContext("2d");
        const grad = ctx.createRadialGradient(size / 2, size / 2, 0,
                                              size / 2, size / 2, size / 2);
        grad.addColorStop(0,    "rgba(0,0,0,0.55)");
        grad.addColorStop(0.35, "rgba(0,0,0,0.28)");
        grad.addColorStop(0.65, "rgba(0,0,0,0.08)");
        grad.addColorStop(1,    "rgba(0,0,0,0)");
        ctx.fillStyle = grad;
        ctx.fillRect(0, 0, size, size);
        const tex = new THREE.CanvasTexture(canvas);
        tex.colorSpace = THREE.SRGBColorSpace;
        return tex;
    }
    const groundSoft = new THREE.Mesh(
        new THREE.PlaneGeometry(7.2, 7.2),
        new THREE.MeshBasicMaterial({
            map: makeContactShadowTexture(),
            transparent: true,
            opacity: 0.26,
            depthWrite: false
        })
    );
    groundSoft.rotation.x = -Math.PI / 2;
    groundSoft.position.y = -1.8;
    groundSoft.renderOrder = -1;
    scene.add(groundSoft);

    const groundHard = new THREE.Mesh(
        new THREE.PlaneGeometry(8, 8),
        new THREE.ShadowMaterial({ opacity: 0.14 })
    );
    groundHard.rotation.x = -Math.PI / 2;
    groundHard.position.y = -1.799; // hair above the soft shadow to avoid z-fight
    groundHard.receiveShadow = true;
    scene.add(groundHard);

    // The Float wrapper from drei animates rotation+position with sin/cos.
    const floatRoot = new THREE.Group();
    scene.add(floatRoot);

    // The current cell's geometry lives in `currentGroup` (a child of floatRoot).
    let currentGroup = null;
    let currentCellId = null;
    let pendingLoadToken = 0;

    // Current state echoes the controller's last-known props.
    const state = {
        cell: null,
        activeOrganelle: null,
        viewMode: "mesh",
        crossSection: false,
        clipY: 0,
        autoRotate: true
    };

    /* Clipping plane — only attached to renderer.clippingPlanes when
       cross-section is on. Normal (0,-1,0) means everything with
       y > constant is clipped, so dragging clipY DOWN clips more of
       the top of the cell. UI range: -1.5 to 1.5. */
    const clipPlane = new THREE.Plane(new THREE.Vector3(0, -1, 0), 0);
    function applyClipping() {
        if (state.crossSection) {
            clipPlane.constant = state.clipY != null ? state.clipY : 0;
            renderer.clippingPlanes = [clipPlane];
        } else {
            renderer.clippingPlanes = [];
        }
    }

    let backgroundColor = "#fbf7ee";
    scene.background = new THREE.Color(backgroundColor);

    function applyLightsForCell(cell, nativeMode) {
        ambient.intensity = nativeMode ? 1.42 : 1.28;
        hemi.color.set(nativeMode ? 0xfffaf0 : 0xfff8ea);
        hemi.groundColor.set(nativeMode ? 0xefe3d2 : 0xe3ded2);
        hemi.intensity = nativeMode ? 1.26 : 1.18;
        dir.intensity = nativeMode ? 2.72 : 2.75;
        dirFill.intensity = nativeMode ? 0.82 : 0;
        spot.intensity = nativeMode ? 0.78 : 1.45;
        spot.color.set(nativeMode ? 0xfff8ec : cell.accentSoft);
        point.intensity = nativeMode ? 0.46 : 0.6;
        point.color.set(nativeMode ? 0xffffff : cell.accent);
        // Native asset already textured; let canvas show through.
        scene.background = nativeMode ? null : new THREE.Color(backgroundColor);
        // Mirror drei's ContactShadows two-mode tuning: native renders
        // slightly larger + dimmer (the textured model already has its
        // own self-shading); studio bumps it up.
        groundSoft.material.opacity = nativeMode ? 0.18 : 0.26;
        const scale = nativeMode ? (7.8 / 7.2) : 1;
        groundSoft.scale.setScalar(scale);
        groundHard.material.opacity = nativeMode ? 0.10 : 0.14;
    }

    function clearCurrentGroup() {
        if (currentGroup) {
            floatRoot.remove(currentGroup);
            disposeGroup(currentGroup);
            currentGroup = null;
        }
    }

    function installGroup(group, nativeMode) {
        clearCurrentGroup();
        currentGroup = group;
        currentGroup.userData.nativeMode = nativeMode;
        floatRoot.add(currentGroup);
    }

    function rebuildFor(cell) {
        const native = cell.modelAsset && cell.modelAsset.materialMode === "native";
        applyLightsForCell(cell, !!native);

        if (cell.modelAsset) {
            onProgress({ phase: "loading", cell: cell, progress: 0 });
            const token = ++pendingLoadToken;
            loadGLB(cell.modelAsset.url, function (p) {
                if (token !== pendingLoadToken) return;
                if (!p || !p.total) return;
                const pct = Math.min(99, Math.round((p.loaded / p.total) * 100));
                onProgress({ phase: "loading", cell: cell, progress: pct });
            }).then(gltf => {
                if (token !== pendingLoadToken) return;
                const group = buildAssetGroup(gltf, cell, state.viewMode, state.crossSection);
                installGroup(group, !!native);
                if (!native) updateMaterials(group, state.activeOrganelle, state.viewMode);
                onProgress({ phase: "loaded", cell: cell, progress: 100 });
            }).catch(err => {
                if (token !== pendingLoadToken) return;
                // GLB load failed (CORS, 404, malformed) — fall back to
                // procedural geometry so the page still renders something.
                console.warn("biology: GLB load failed for " + cell.id + ", using procedural fallback", err);
                const proc = (PROCEDURAL_BUILDERS[cell.modelKind] || buildAnimalModel)(state.crossSection);
                installGroup(proc, false);
                updateMaterials(proc, state.activeOrganelle, state.viewMode);
                onProgress({ phase: "error", cell: cell, error: err });
                onError(err);
            });
        } else {
            ++pendingLoadToken; // cancel any in-flight async load
            const proc = (PROCEDURAL_BUILDERS[cell.modelKind] || buildAnimalModel)(state.crossSection);
            installGroup(proc, false);
            updateMaterials(proc, state.activeOrganelle, state.viewMode);
            onProgress({ phase: "loaded", cell: cell, progress: 100 });
        }
        currentCellId = cell.id;
    }

    function update(props) {
        const next = Object.assign({}, state, props);

        const cellChanged = next.cell && (!state.cell || next.cell.id !== state.cell.id);
        const crossSectionChanged = next.crossSection !== state.crossSection;

        // For procedural models, the cross-section opacity is baked into the
        // membrane meshes at build time — so flipping crossSection means
        // rebuild. For GLB-asset models, the rebuild also re-clones the
        // scene to set new transparent/opacity material values. clipY
        // changes don't need a rebuild — clip plane updates are GPU-side.
        const needsRebuild = cellChanged || (crossSectionChanged && next.cell);

        Object.assign(state, next);

        // Apply clipping every update — cheap (just swaps the renderer's
        // clippingPlanes array reference), and handles both crossSection
        // toggles and clipY scrubs in one place.
        applyClipping();

        if (needsRebuild) {
            rebuildFor(state.cell);
        } else if (currentGroup) {
            updateMaterials(currentGroup, state.activeOrganelle, state.viewMode);
        }
    }

    function reset() {
        controls.reset();
        camera.position.set(0, 0.2, 5.8);
        camera.lookAt(0, 0, 0);
    }

    /* Capture the current frame as a PNG data URL.
       The renderer is created with preserveDrawingBuffer:false (default),
       which means canvas.toDataURL() returns a blank PNG by the time the
       browser hands control to a script — the GL drawing buffer has been
       cleared for the next frame. Forcing a render *inside* this same
       turn-of-the-event-loop, before yielding, makes the buffer readable.
       This avoids the memory cost of preserveDrawingBuffer:true. */
    function screenshot(mimeType) {
        renderer.render(scene, camera);
        return canvas.toDataURL(mimeType || "image/png");
    }

    function dispose() {
        cancelAnimationFrame(rafId);
        controls.dispose();
        clearCurrentGroup();
        groundSoft.geometry.dispose();
        if (groundSoft.material.map) groundSoft.material.map.dispose();
        groundSoft.material.dispose();
        groundHard.geometry.dispose();
        groundHard.material.dispose();
        renderer.dispose();
        window.removeEventListener("resize", onResize);
        if (resizeObserver) resizeObserver.disconnect();
    }

    /* ----- Resize tracking ----- */

    function fitCanvas() {
        const rect = canvas.getBoundingClientRect();
        const w = Math.max(1, Math.floor(rect.width));
        const h = Math.max(1, Math.floor(rect.height));
        renderer.setSize(w, h, false);
        camera.aspect = w / h;
        camera.updateProjectionMatrix();
    }
    function onResize() { fitCanvas(); }
    window.addEventListener("resize", onResize);
    let resizeObserver = null;
    if (typeof ResizeObserver !== "undefined") {
        resizeObserver = new ResizeObserver(onResize);
        resizeObserver.observe(canvas);
    }
    fitCanvas();

    /* ----- Raycaster picker -------------------------------------
       Pointer-driven organelle selection. Hover changes the cursor;
       a no-drag click fires opts.onPick(organelleId). We skip ids
       'membrane' (the outer shell — never an active organelle) and
       '_asset_' (GLB meshes don't carry organelle ids). */
    const raycaster = new THREE.Raycaster();
    const pointer = new THREE.Vector2();

    function organelleAtPointer(event) {
        const rect = canvas.getBoundingClientRect();
        if (rect.width === 0 || rect.height === 0) return null;
        pointer.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
        pointer.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
        raycaster.setFromCamera(pointer, camera);
        if (!currentGroup) return null;
        const hits = raycaster.intersectObject(currentGroup, true);
        for (let i = 0; i < hits.length; i++) {
            const ud = hits[i].object.userData;
            const id = ud && ud.organelleId;
            if (id && id !== "membrane" && id !== "_asset_") return id;
        }
        return null;
    }

    canvas.style.cursor = "grab";
    canvas.addEventListener("pointermove", function (e) {
        if (e.buttons !== 0) return; // mid-drag — let OrbitControls own the cursor
        const id = organelleAtPointer(e);
        canvas.style.cursor = id ? "pointer" : "grab";
    });

    let pointerDownAt = null;
    canvas.addEventListener("pointerdown", function (e) {
        pointerDownAt = { x: e.clientX, y: e.clientY };
    });
    canvas.addEventListener("pointerup", function (e) {
        const start = pointerDownAt;
        pointerDownAt = null;
        if (!start) return;
        // 5-pixel threshold — anything bigger is an OrbitControls drag, not a click.
        const dx = e.clientX - start.x;
        const dy = e.clientY - start.y;
        if (dx * dx + dy * dy > 25) return;
        const id = organelleAtPointer(e);
        if (id) onPick(id);
    });

    /* ----- Animation loop --------------------------------------- */

    let rafId = 0;
    let isRunning = true;
    const clock = new THREE.Clock();
    function frame() {
        if (!isRunning) return;
        rafId = requestAnimationFrame(frame);
        const dt = clock.getDelta();
        const t = clock.elapsedTime;

        // Float-like oscillation (drei's <Float speed=1.25 rotInt=0.08 floatInt=0.18>)
        floatRoot.rotation.x = Math.sin(t * 1.25) * 0.08 * 0.5;
        floatRoot.rotation.z = Math.cos(t * 1.0) * 0.08 * 0.5;
        floatRoot.position.y = Math.sin(t * 1.25) * 0.18 * 0.25;

        if (state.autoRotate && currentGroup) {
            currentGroup.rotation.y += dt * 0.1;
        }
        controls.update();
        renderer.render(scene, camera);
    }
    frame();

    /* Pause the render loop when the tab is hidden — saves battery
       and GPU on background tabs. Three.Clock keeps elapsedTime
       monotonic from start, so we reset the delta-source when we
       resume so the Float oscillation doesn't lurch. */
    function onVisibilityChange() {
        if (document.hidden) {
            isRunning = false;
            cancelAnimationFrame(rafId);
        } else if (!isRunning) {
            isRunning = true;
            clock.getDelta(); // drain stale delta
            frame();
        }
    }
    document.addEventListener("visibilitychange", onVisibilityChange);

    /* Extend dispose() to also detach the visibility listener. */
    const originalDispose = dispose;
    dispose = function () {
        document.removeEventListener("visibilitychange", onVisibilityChange);
        originalDispose();
    };

    return { update: update, reset: reset, dispose: dispose, screenshot: screenshot };
}

window.BiologyCellScene = { mount: mount };
