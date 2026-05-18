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
/* Label sprites                                                       */
/* ------------------------------------------------------------------ */

/* makeLabelSprite renders a small numbered puck — a colored circular
   badge with a number inside. Pairs with the side-legend that lists
   "1. Nucleus, 2. Chloroplast, …" so dense cells (10+ organelles)
   don't pile chip-style labels on top of each other. World size kept
   small (~0.18 units) so multiple pucks read cleanly even when their
   organelles cluster. */
function makeLabelSprite(number, color) {
    const DPR = Math.min(window.devicePixelRatio || 1, 2);
    const size = 64;                 // CSS pixel diameter
    const fontSize = 32;

    const canvas = document.createElement("canvas");
    canvas.width  = size * DPR;
    canvas.height = size * DPR;
    const ctx = canvas.getContext("2d");
    ctx.scale(DPR, DPR);

    const cx = size / 2;
    const cy = size / 2;
    const r = size / 2 - 3;

    // Outer dark ring — gives contrast against light and dark cell colors
    // alike so the puck reads against any background.
    ctx.fillStyle = "rgba(20, 18, 14, 0.92)";
    ctx.beginPath();
    ctx.arc(cx, cy, r + 3, 0, Math.PI * 2);
    ctx.fill();

    // Colored disc — matches the organelle accent for legend correspondence.
    ctx.fillStyle = color || "#9c9c9c";
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI * 2);
    ctx.fill();

    // Number with a thin dark stroke for legibility on any color.
    ctx.font = "800 " + fontSize + "px -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', sans-serif";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.lineWidth = 3;
    ctx.strokeStyle = "rgba(20, 18, 14, 0.85)";
    ctx.strokeText(String(number), cx, cy + 1);
    ctx.fillStyle = "#fffdf6";
    ctx.fillText(String(number), cx, cy + 1);

    const tex = new THREE.CanvasTexture(canvas);
    tex.colorSpace = THREE.SRGBColorSpace;
    tex.anisotropy = 4;

    const mat = new THREE.SpriteMaterial({
        map: tex,
        transparent: true,
        depthWrite: false,
        depthTest: false        // float pucks in front of everything
    });
    // Opt out of the global clipping plane so cross-section doesn't hide labels.
    mat.clippingPlanes = [];

    const sprite = new THREE.Sprite(mat);
    const worldSize = 0.18;
    sprite.scale.set(worldSize, worldSize, 1);
    sprite.renderOrder = 999;
    sprite.userData.isOrganelleLabel = true;
    return sprite;
}

/* For each unique organelleId in `group`, compute the average centroid
   of all meshes carrying that id (so the sprite sits at the visual
   center of multi-mesh organelles like the dotted ER) and attach a
   label sprite. Returns a freshly built THREE.Group that the caller
   parents under currentGroup so labels follow the cell's rotation.

   GLB-asset cells have every mesh tagged "_asset_" (filtered out), so
   the mesh-walk produces no buckets. For those, the data file may
   supply `organelle.labelPosition: [worldX, worldY, worldZ]` to anchor
   the label manually. This is the consistency fix that makes the
   neuron / animal / bacteria GLB cells show labels just like the
   procedural cells. */
function buildLabelsGroup(group, cell) {
    const labelsGroup = new THREE.Group();
    labelsGroup.userData.isLabelsGroup = true;
    if (!cell || !cell.organelles) return labelsGroup;

    // Index organelle metadata for quick id -> {name, color, number} lookup.
    // The "number" is the 1-based index in cell.organelles, used to label
    // the in-scene pucks and the side legend in matching order.
    const meta = {};
    cell.organelles.forEach((o, i) => { meta[o.id] = Object.assign({}, o, { _num: i + 1 }); });

    // Group scale compensation — currentGroup may carry a per-cell scale
    // (e.g. 3.15× for the neuron GLB, 0.044× for the animal GLB). The
    // sprite scale set in makeLabelSprite() is in world-units, so when
    // the sprite is parented INTO a scaled group it gets re-scaled by
    // that factor. We divide back out so labels read the same size
    // across every cell.
    const groupScale = group.scale.x || 1;

    // Group meshes by organelleId. We compute per-mesh bounding-box centers
    // in world-ish space (the group's local space — labelsGroup is attached
    // to the same parent so the basis is shared).
    const buckets = {};
    group.traverse(node => {
        if (!node.isMesh) return;
        const id = node.userData && node.userData.organelleId;
        if (!id || id === "membrane" || id === "_asset_") return;
        if (!meta[id]) return;
        const box = new THREE.Box3().setFromObject(node);
        const center = box.getCenter(new THREE.Vector3());
        // Convert from world → group-local so the label sits with the cell.
        group.worldToLocal(center);
        if (!buckets[id]) buckets[id] = { sum: new THREE.Vector3(), count: 0 };
        buckets[id].sum.add(center);
        buckets[id].count++;
    });

    Object.keys(buckets).forEach(id => {
        const b = buckets[id];
        const center = b.sum.divideScalar(b.count);
        const sprite = makeLabelSprite(meta[id]._num, meta[id].color);
        // Lift the puck slightly above the organelle's center so it doesn't
        // overlap the mesh — looks more like a textbook callout.
        sprite.position.set(center.x, center.y + 0.28, center.z);
        sprite.scale.divideScalar(groupScale);
        // Make the puck itself a pick target — clicking it fires the same
        // onPick(organelleId) as clicking the underlying mesh. Essential
        // for GLB cells where model meshes are tagged "_asset_".
        sprite.userData.organelleId = id;
        labelsGroup.add(sprite);
    });

    // labelPosition fallback — for organelles whose meshes can't be
    // resolved by the walk above (GLB cells, or any organelle on a
    // procedural cell that wasn't tagged). labelPosition is specified in
    // WORLD units so authors can reason about it the same way regardless
    // of the per-cell scale; we project it back into group-local space
    // here so it follows the cell's rotation / auto-rotate / float.
    cell.organelles.forEach((o, i) => {
        if (buckets[o.id]) return;
        if (!o.labelPosition) return;
        const sprite = makeLabelSprite(i + 1, o.color);
        const worldPos = new THREE.Vector3(
            o.labelPosition[0], o.labelPosition[1], o.labelPosition[2]
        );
        group.worldToLocal(worldPos);
        sprite.position.copy(worldPos);
        sprite.scale.divideScalar(groupScale);
        // Click-pick target — see comment in the mesh-bucket path above.
        sprite.userData.organelleId = o.id;
        labelsGroup.add(sprite);
    });

    return labelsGroup;
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

    /* Three nested transparent shells live here (wallOuter, plasma,
       wallInner). For each one we set:
         - renderOrder: explicit back-to-front order so Three.js doesn't
           re-sort them frame-to-frame by mesh-center distance (which
           flips with auto-rotate and causes flicker).
         - depthWrite:false: transparent shells shouldn't write to the
           depth buffer or they prevent the shell behind them from
           drawing. Standard pattern for nested glass-like layers. */
    const wallOuterMat = makeStudioMaterial("#84ad4a", crossSection ? 0.34 : 0.5, 0.66, 0.03);
    wallOuterMat.depthWrite = false;
    const wallOuter = new THREE.Mesh(
        new RoundedBoxGeometry(4.7, 2.7, 0.42, 8, 0.18),
        wallOuterMat
    );
    tagMesh(wallOuter, "cellWall", crossSection ? 0.34 : 0.5, "#84ad4a");
    wallOuter.renderOrder = 3;  // outermost — drawn last (on top)
    root.add(wallOuter);

    const wallInnerMat = makeStudioMaterial("#4f9f83", 0.24, 0.66, 0.03);
    wallInnerMat.depthWrite = false;
    const wallInner = new THREE.Mesh(
        new RoundedBoxGeometry(4.18, 2.24, 0.24, 8, 0.12),
        wallInnerMat
    );
    tagMesh(wallInner, "cellWall", 0.24, "#4f9f83");
    wallInner.position.set(0.02, 0.02, 0.08);
    wallInner.renderOrder = 1;
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

    // Endoplasmic Reticulum — was previously mistagged as "nucleus". Two
    // intertwined tubes give a network feel without a heavy mesh.
    root.add(curveTubeMesh("er", "#d97757",
        [[0.42, 0.12, 0.42], [0.62, -0.06, 0.5], [1.05, -0.08, 0.46], [1.44, 0.06, 0.38]],
        0.05));
    root.add(curveTubeMesh("er", "#d97757",
        [[-1.05, 0.55, 0.36], [-0.65, 0.32, 0.44], [-0.32, 0.58, 0.4], [0.08, 0.36, 0.38]],
        0.04));

    // Ribosomes — small scattered dots throughout the cytoplasm.
    // Was previously a "vacuole"-tagged pink-dot group, which made no
    // biological sense (vacuole is a single large compartment).
    root.add(dotsGroup("ribosomes", "#a05f9f", 26, [1.62, 0.82, 0.38]));

    // Golgi Apparatus — stack of curved torus discs (matches the animal
    // cell's Golgi idiom for visual consistency across cell types).
    for (let i = 0; i < 4; i++) {
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.26 + i * 0.028, 0.022, 10, 48),
            makeStudioMaterial("#d49057", 1, 0.66, 0.03)
        );
        tagMesh(ring, "golgi", 1, "#d49057");
        ring.position.set(-1.05 - i * 0.04, -0.42 + i * 0.06, 0.42);
        ring.rotation.set(0.18, 0, 0.6);
        root.add(ring);
    }

    // Plasma Membrane — sits CLEARLY inside wallInner (4.18×2.24×0.24)
    // so its surfaces don't share planes with the wall layers. Earlier
    // version was 4.32×2.38×0.30 — its +Z face landed at z=0.21 exactly
    // where wallOuter's face was, which produced z-fighting flicker as
    // the depth buffer flipped on every camera rotation.
    const plasmaMat = makeStudioMaterial("#b5cf95", crossSection ? 0.18 : 0.34, 0.7, 0.02);
    plasmaMat.depthWrite = false;
    const plasma = new THREE.Mesh(
        new RoundedBoxGeometry(4.02, 2.08, 0.18, 8, 0.10),
        plasmaMat
    );
    tagMesh(plasma, "plasmaMembrane", crossSection ? 0.18 : 0.34, "#b5cf95");
    plasma.position.set(0.02, 0.02, 0.08);
    plasma.renderOrder = 2;  // between wallInner (1) and wallOuter (3)
    root.add(plasma);

    // Plasmodesmata — plant-unique channels that pierce the cell wall.
    // Small cylinders distributed along the long edges of the wall;
    // hidden by the wall in normal view but pop out under cross-section
    // or when the cell is rotated.
    const plasmoMat = makeStudioMaterial("#c2a87a", 1, 0.62, 0.04);
    const plasmoPositions = [
        // [x, y, z, axis] — axis 'x' = horizontal (pierces top/bottom wall),
        //                  axis 'y' = vertical   (pierces left/right wall)
        [-1.4,  1.35, 0.18, "y"],
        [-0.4,  1.35, 0.20, "y"],
        [ 0.7,  1.35, 0.18, "y"],
        [ 1.55, 1.35, 0.20, "y"],
        [-1.4, -1.35, 0.18, "y"],
        [-0.4, -1.35, 0.20, "y"],
        [ 0.7, -1.35, 0.18, "y"],
        [ 1.55,-1.35, 0.20, "y"],
        [ 2.35, 0.5,  0.18, "x"],
        [ 2.35,-0.5,  0.18, "x"],
        [-2.35, 0.5,  0.18, "x"],
        [-2.35,-0.5,  0.18, "x"]
    ];
    plasmoPositions.forEach(p => {
        const cyl = new THREE.Mesh(
            new THREE.CylinderGeometry(0.045, 0.045, 0.34, 12),
            plasmoMat
        );
        // CylinderGeometry's axis is +Y by default; rotate to pierce the
        // appropriate wall face.
        if (p[3] === "x") cyl.rotation.z = Math.PI / 2; // axis along X
        // For "y" axis we leave the default Y orientation.
        cyl.position.set(p[0], p[1], p[2]);
        tagMesh(cyl, "plasmodesmata", 1, "#c2a87a");
        root.add(cyl);
    });

    return root;
}

function buildWhiteBloodModel(crossSection) {
    const root = new THREE.Group();
    root.scale.set(1.2, 1.2, 1.2);

    /* Plasma Membrane — outer transparent sphere. Previously tagged
       "membrane" (a filtered-out ID), which made it non-clickable and
       missing from data. Re-tagged as "plasmaMembrane" so it surfaces
       in the rail and accepts labels. depthWrite:false + renderOrder
       give a stable depth sort against inner translucent dots. */
    const plasmaMat = makeStudioMaterial("#b6c0e0", crossSection ? 0.28 : 0.45, 0.66, 0.03);
    plasmaMat.depthWrite = false;
    const plasma = new THREE.Mesh(
        new THREE.SphereGeometry(1.35, 64, 64),
        plasmaMat
    );
    tagMesh(plasma, "plasmaMembrane", crossSection ? 0.28 : 0.45, "#b6c0e0");
    plasma.renderOrder = 3;
    root.add(plasma);

    /* Lobed nucleus — three connected lobes, the textbook neutrophil look. */
    [[-0.42, 0.22, 0.34], [0.28, 0.06, 0.36], [0.02, -0.42, 0.28]].forEach(pos => {
        root.add(nucleusGroup("nucleus", pos, [0.42, 0.36, 0.28], "#6c35a0"));
    });

    /* Granules and lysosomes — the immune cell's chemical arsenal. */
    root.add(dotsGroup("granules", "#c06696", 30, [1.05, 1.02, 0.72]));
    root.add(dotsGroup("lysosome", "#8b54b7", 12, [0.92, 0.88, 0.62]));

    /* Mitochondria — two, placed away from the nucleus lobes so they
       read clearly through the translucent membrane. */
    root.add(mitochondrionGroup("mitochondrion",
        [0.78, 0.62, 0.32], [0.4, 0.1, 0.85], [0.85, 0.85, 0.85]));
    root.add(mitochondrionGroup("mitochondrion",
        [-0.82, -0.32, 0.28], [0.2, -0.2, 1.4], [0.78, 0.78, 0.78]));

    /* Endoplasmic Reticulum — two curve tubes for a network feel,
       hugging the membrane interior. */
    root.add(curveTubeMesh("er", "#d97757",
        [[-0.86, 0.62, 0.42], [-0.42, 0.78, 0.46], [0.18, 0.88, 0.44], [0.7, 0.74, 0.42]],
        0.045));
    root.add(curveTubeMesh("er", "#d97757",
        [[0.92, -0.22, 0.38], [0.62, -0.58, 0.42], [0.16, -0.72, 0.4], [-0.32, -0.66, 0.36]],
        0.04));

    /* Ribosomes — small scattered specks in the cytoplasm. */
    root.add(dotsGroup("ribosomes", "#a05f9f", 22, [1.05, 1.0, 0.62]));

    /* Golgi Apparatus — stack of curved discs near the membrane. */
    for (let i = 0; i < 4; i++) {
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.18 + i * 0.022, 0.020, 10, 48),
            makeStudioMaterial("#d49057", 1, 0.66, 0.03)
        );
        tagMesh(ring, "golgi", 1, "#d49057");
        ring.position.set(-0.55 + i * 0.03, 0.58, 0.42);
        ring.rotation.set(0.22, 0, 0.55);
        root.add(ring);
    }

    /* Phagosome — the immune-cell signature feature. A vesicle membrane
       wrapping an engulfed bacterium. Renders as a translucent shell
       with a darker rod inside, parked near the plasma membrane to
       suggest it was just pinched off by phagocytosis. */
    const phagoCenter = [0.65, -0.68, 0.28];
    const phagoShellMat = makeStudioMaterial("#aa8c5a", 0.55, 0.6, 0.04);
    phagoShellMat.depthWrite = false;
    const phagoShell = new THREE.Mesh(
        new THREE.SphereGeometry(0.22, 32, 32),
        phagoShellMat
    );
    tagMesh(phagoShell, "phagosome", 0.55, "#aa8c5a");
    phagoShell.position.set(phagoCenter[0], phagoCenter[1], phagoCenter[2]);
    phagoShell.renderOrder = 2;
    root.add(phagoShell);

    /* Engulfed "bacterium" — a small capsule inside the phagosome shell.
       Same tag so clicking the inner rod also activates the phagosome
       organelle (intuitive: the rod IS the phagosome's contents). */
    const engulfedMat = makeStudioMaterial("#6b5436", 1, 0.7, 0.05);
    const engulfed = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.06, 0.16, 8, 18),
        engulfedMat
    );
    tagMesh(engulfed, "phagosome", 1, "#6b5436");
    engulfed.position.set(phagoCenter[0] + 0.02, phagoCenter[1] - 0.02, phagoCenter[2] + 0.02);
    engulfed.rotation.set(0, 0, 0.5);
    root.add(engulfed);

    return root;
}

function buildNeuronModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.02, -0.2, 0);
    root.scale.set(1.05, 1.05, 1.05);

    /* Nucleus — sits inside the soma. Was previously tagged "soma" but
       nucleusGroup() visually renders a nucleus + nucleolus pair, not
       a cell-body shell, so the original tagging was a bug. */
    root.add(nucleusGroup("nucleus", [-0.55, 0, 0.08], [0.5, 0.46, 0.36], "#7047a8"));

    /* Soma shell — the cell-body envelope around all soma organelles.
       Transparent so inner Nissl, mitochondria, and Golgi read through.
       depthWrite:false + renderOrder for stable depth sort. */
    const somaMat = makeStudioMaterial("#8db5d8", crossSection ? 0.36 : 0.55, 0.66, 0.03);
    somaMat.depthWrite = false;
    const somaShell = new THREE.Mesh(
        new THREE.SphereGeometry(1, 52, 52),
        somaMat
    );
    tagMesh(somaShell, "soma", crossSection ? 0.36 : 0.55, "#8db5d8");
    somaShell.position.set(-0.55, 0, 0);
    somaShell.scale.set(0.94, 0.82, 0.62);
    somaShell.renderOrder = 3;
    root.add(somaShell);

    /* Mitochondrion — neurons cluster many; place one in soma upper-left
       and another at the axon terminal where ATP demand spikes. */
    root.add(mitochondrionGroup("mitochondrion",
        [-0.98, 0.36, 0.22], [0.4, 0.15, 0.85], [0.7, 0.7, 0.7]));

    /* Nissl bodies — concentrated rough ER in the soma. Two curve tubes
       on opposite sides of the nucleus echo the textbook stained-section
       look (densely packed dark patches around a central nucleus). */
    root.add(curveTubeMesh("er", "#d97757",
        [[-0.18, 0.34, 0.18], [-0.32, 0.18, 0.22], [-0.36, -0.14, 0.22], [-0.18, -0.32, 0.20]],
        0.04));
    root.add(curveTubeMesh("er", "#d97757",
        [[-0.92, 0.18, 0.20], [-1.02, -0.08, 0.22], [-0.92, -0.32, 0.18], [-0.72, -0.42, 0.18]],
        0.035));

    /* Golgi Apparatus — stack of curved discs in the soma, between the
       nucleus and the axon hillock (anatomically accurate position). */
    for (let i = 0; i < 4; i++) {
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.16 + i * 0.018, 0.018, 10, 48),
            makeStudioMaterial("#d49057", 1, 0.66, 0.03)
        );
        tagMesh(ring, "golgi", 1, "#d49057");
        ring.position.set(-0.25, -0.45, 0.24 + i * 0.012);
        ring.rotation.set(0.18, 0, 0.55);
        root.add(ring);
    }

    /* Axon backbone — the inner conductive tube. The myelin segments
       wrap around it; nodes of Ranvier are the exposed gaps. */
    root.add(curveTubeMesh("axon", "#6b7dc6",
        [[0.04, 0.02, 0.04], [0.72, -0.02, 0.02], [1.56, 0.04, 0.02], [2.35, -0.04, 0]],
        0.08));

    /* Myelin Sheath — four capsule segments WITH GAPS between them so
       the Nodes of Ranvier are visually distinct. Previously these were
       mistagged "axon"; the insulation isn't part of the axon itself,
       it's wrapped on by Schwann cells / oligodendrocytes. */
    const myelinPositions = [0.42, 1.0, 1.58, 2.15];
    myelinPositions.forEach(x => {
        const seg = new THREE.Mesh(
            new THREE.CapsuleGeometry(0.16, 0.18, 8, 24),
            makeStudioMaterial("#bfd1df", 0.94, 0.66, 0.03)
        );
        tagMesh(seg, "myelinSheath", 0.94, "#bfd1df");
        seg.position.set(x, 0, 0.02);
        seg.rotation.z = Math.PI / 2;
        root.add(seg);
    });

    /* Nodes of Ranvier — bright bands sitting in the gaps between
       myelin segments. Rendered as small spheres around the exposed
       axon backbone (radius slightly larger than the axon tube) so
       they pop visually against the myelin gray. */
    const nodePositions = [
        (myelinPositions[0] + myelinPositions[1]) / 2,
        (myelinPositions[1] + myelinPositions[2]) / 2,
        (myelinPositions[2] + myelinPositions[3]) / 2
    ];
    nodePositions.forEach(x => {
        const node = new THREE.Mesh(
            new THREE.SphereGeometry(0.11, 24, 24),
            makeStudioMaterial("#e8a76a", 1, 0.5, 0.08)
        );
        tagMesh(node, "nodesOfRanvier", 1, "#e8a76a");
        node.position.set(x, 0, 0.02);
        node.scale.set(0.55, 1, 1);  // squish along axon so it looks like a band
        root.add(node);
    });

    /* Axon Terminal — branching tip past the last myelin segment. Three
       small curve tubes fan out, each ending in a synaptic bouton with
       a cluster of vesicles. This is where signals leave the neuron. */
    const terminalBase = [2.45, 0, 0.02];
    const terminalEnds = [
        [3.05,  0.32, 0.04],
        [3.10,  0.00, 0.04],
        [3.05, -0.32, 0.04]
    ];
    terminalEnds.forEach(end => {
        // Branching curve from base to terminal end.
        root.add(curveTubeMesh("axonTerminal", "#b46ac7",
            [terminalBase,
             [(terminalBase[0] + end[0]) / 2, (terminalBase[1] + end[1]) / 2 * 1.1, end[2]],
             end],
            0.045));
        // Bouton — small bulge at the terminal end.
        const bouton = new THREE.Mesh(
            new THREE.SphereGeometry(0.10, 24, 24),
            makeStudioMaterial("#b46ac7", 1, 0.55, 0.04)
        );
        tagMesh(bouton, "axonTerminal", 1, "#b46ac7");
        bouton.position.set(end[0], end[1], end[2]);
        root.add(bouton);
    });

    /* Dendrites — branching input fibers off the back of the soma. */
    const dendritePaths = [
        [[-1.08, 0.28, 0], [-1.55, 0.82, 0.08], [-2.1, 1.03, 0]],
        [[-1.16, -0.18, 0], [-1.7, -0.54, 0.05], [-2.2, -0.9, 0]],
        [[-0.78, 0.58, 0.04], [-0.82, 1.16, 0.02], [-1.12, 1.58, 0]],
        [[-0.9, -0.55, 0.04], [-0.92, -1.04, 0], [-1.2, -1.44, 0.02]]
    ];
    dendritePaths.forEach(pts => {
        root.add(curveTubeMesh("dendrites", "#7d9bcf", pts, 0.052));
    });

    /* Dendritic spines — small dots at the dendrite tips. Stays tagged
       "dendrites" so clicking them activates the dendrite organelle. */
    root.add(dotsGroup("dendrites", "#b46ac7", 12, [2.2, 1.4, 0.2]));

    return root;
}

function buildEpithelialModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.08, -0.22, 0);
    root.scale.set(1.08, 1.08, 1.08);

    /* Plasma Membrane — was tagged "membrane" (filtered, non-clickable).
       Retagged as "plasmaMembrane" so it's a real organelle. Epithelia
       are polarized, so this membrane has a top (apical, with microvilli)
       and bottom (basal, sitting on the basement membrane). */
    const plasmaMat = makeStudioMaterial("#d79baa", crossSection ? 0.32 : 0.52, 0.66, 0.03);
    plasmaMat.depthWrite = false;
    const plasma = new THREE.Mesh(
        new RoundedBoxGeometry(2.4, 2.0, 0.72, 8, 0.1),
        plasmaMat
    );
    tagMesh(plasma, "plasmaMembrane", crossSection ? 0.32 : 0.52, "#d79baa");
    plasma.position.set(0, -0.12, 0);
    plasma.renderOrder = 3;
    root.add(plasma);

    /* Microvilli — finger-like projections on the apical (top) surface. */
    for (let i = 0; i < 12; i++) {
        const villus = new THREE.Mesh(
            new THREE.CapsuleGeometry(0.045, 0.34, 8, 14),
            makeStudioMaterial("#c86f80", 1, 0.66, 0.03)
        );
        tagMesh(villus, "microvilli", 1, "#c86f80");
        villus.position.set(-1.1 + i * 0.2, 1.04, 0.08);
        root.add(villus);
    }

    /* Nucleus — basal-ish, characteristic position in tall epithelia. */
    root.add(nucleusGroup("nucleus", [0.15, -0.2, 0.32], [0.55, 0.5, 0.36]));

    /* Tight Junctions — thin band where cells seal to neighbors,
       running just below the apical surface. */
    root.add(curveTubeMesh("junctions", "#9f6cbd",
        [[-1.18, 0.74, 0.38], [-0.6, 0.7, 0.44], [0.1, 0.73, 0.4], [0.96, 0.68, 0.42]],
        0.04));

    /* Mitochondria — concentrated near the basolateral membrane where
       energy-hungry Na+/K+ pumps live. */
    root.add(mitochondrionGroup("mitochondrion",
        [-0.85, -0.45, 0.36], [0.3, 0.1, 0.95], [0.78, 0.78, 0.78]));
    root.add(mitochondrionGroup("mitochondrion",
        [0.85, -0.55, 0.34], [0.2, -0.1, 1.1], [0.72, 0.72, 0.72]));

    /* Endoplasmic Reticulum — extensive in secretory epithelia (goblet
       cells). Two curve tubes around the nucleus suggest the network. */
    root.add(curveTubeMesh("er", "#d97757",
        [[-0.42, 0.15, 0.42], [-0.18, 0.32, 0.46], [0.18, 0.40, 0.44], [0.48, 0.22, 0.42]],
        0.04));
    root.add(curveTubeMesh("er", "#d97757",
        [[0.62, -0.18, 0.42], [0.50, -0.45, 0.46], [0.18, -0.55, 0.44], [-0.18, -0.42, 0.42]],
        0.035));

    /* Golgi Apparatus — sits above the nucleus, the polarity sorting
       point for apical-vs-basolateral cargo routing. */
    for (let i = 0; i < 4; i++) {
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.16 + i * 0.02, 0.018, 10, 48),
            makeStudioMaterial("#d49057", 1, 0.66, 0.03)
        );
        tagMesh(ring, "golgi", 1, "#d49057");
        ring.position.set(0.55, 0.45, 0.42 + i * 0.012);
        ring.rotation.set(0.15, 0, 0.5);
        root.add(ring);
    }

    /* Ribosomes — was previously a "nucleus"-tagged pink-dot cluster
       (scattered around the nucleus, made no sense). Retagged ribosomes. */
    root.add(dotsGroup("ribosomes", "#a05f9f", 22, [0.92, 0.68, 0.36]));

    /* Basement Membrane — extracellular protein mat that anchors the
       epithelium to the underlying connective tissue. Rendered as a thin
       wide slab sitting just below the basal surface of the cell.
       The defining epithelial-tissue feature. */
    const bm = new THREE.Mesh(
        new RoundedBoxGeometry(2.6, 0.06, 0.78, 6, 0.04),
        makeStudioMaterial("#a87f64", 1, 0.7, 0.04)
    );
    tagMesh(bm, "basementMembrane", 1, "#a87f64");
    bm.position.set(0, -1.16, 0);
    root.add(bm);

    /* Desmosomes — anchor-style cell-cell junctions on the lateral
       surfaces. Rendered as small disc-shaped buttons paired with their
       neighbor-cell partners (suggesting the spot-weld structure).
       Distinct from tight junctions, which seal the apical band. */
    const desmoPositions = [
        [-1.2,  0.20, 0.30],
        [-1.2, -0.10, 0.30],
        [-1.2, -0.45, 0.30],
        [ 1.2,  0.20, 0.30],
        [ 1.2, -0.10, 0.30],
        [ 1.2, -0.45, 0.30]
    ];
    desmoPositions.forEach(p => {
        const disc = new THREE.Mesh(
            new THREE.CylinderGeometry(0.07, 0.07, 0.04, 18),
            makeStudioMaterial("#c44b6e", 1, 0.55, 0.06)
        );
        tagMesh(disc, "desmosomes", 1, "#c44b6e");
        disc.position.set(p[0], p[1], p[2]);
        disc.rotation.z = Math.PI / 2;  // flat disc faces sideways into the gap
        root.add(disc);
    });

    return root;
}

function buildBacteriaModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.02, 0.1, -0.02);
    root.scale.set(1.12, 1.12, 1.12);

    /* Capsule — thin slime layer outside the cell wall. Bacteria-specific,
       not all species have one but it's important for pathogenic strains.
       depthWrite:false + renderOrder to keep depth-sort stable against
       the underlying wall layers. */
    const capsuleMat = makeStudioMaterial("#a8d3c4", crossSection ? 0.16 : 0.24, 0.7, 0.02);
    capsuleMat.depthWrite = false;
    const capsule = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.86, 2.95, 14, 48),
        capsuleMat
    );
    tagMesh(capsule, "capsule", crossSection ? 0.16 : 0.24, "#a8d3c4");
    capsule.rotation.z = Math.PI / 2;
    capsule.renderOrder = 4;
    root.add(capsule);

    const wallOuterMat = makeStudioMaterial("#65b8ae", crossSection ? 0.36 : 0.62, 0.66, 0.03);
    wallOuterMat.depthWrite = false;
    const outer = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.78, 2.9, 14, 48),
        wallOuterMat
    );
    tagMesh(outer, "cellWall", crossSection ? 0.36 : 0.62, "#65b8ae");
    outer.rotation.z = Math.PI / 2;
    outer.renderOrder = 3;
    root.add(outer);

    /* Plasma Membrane — between the wall's outer and inner layers. */
    const plasmaMat = makeStudioMaterial("#7ac6b8", crossSection ? 0.22 : 0.38, 0.7, 0.02);
    plasmaMat.depthWrite = false;
    const plasma = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.68, 2.7, 12, 40),
        plasmaMat
    );
    tagMesh(plasma, "plasmaMembrane", crossSection ? 0.22 : 0.38, "#7ac6b8");
    plasma.rotation.z = Math.PI / 2;
    plasma.renderOrder = 2;
    root.add(plasma);

    const wallInnerMat = makeStudioMaterial("#235a74", 0.44, 0.66, 0.03);
    wallInnerMat.depthWrite = false;
    const inner = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.62, 2.6, 12, 40),
        wallInnerMat
    );
    tagMesh(inner, "cellWall", 0.44, "#235a74");
    inner.rotation.z = Math.PI / 2;
    inner.scale.set(0.88, 0.88, 0.82);
    inner.renderOrder = 1;
    root.add(inner);

    /* Nucleoid — the chromosome region. Single coiled DNA loop. */
    root.add(curveTubeMesh("nucleoid", "#7a43ad",
        [[-0.9, 0.12, 0.3], [-0.42, -0.14, 0.38], [0.1, 0.18, 0.34], [0.62, -0.12, 0.36], [1.02, 0.06, 0.32]],
        0.12));

    /* Plasmid — small circular DNA off to the side. Bacterial differentiator
       (antibiotic-resistance / horizontal gene transfer). */
    const plasmid = new THREE.Mesh(
        new THREE.TorusGeometry(0.18, 0.032, 10, 36),
        makeStudioMaterial("#d04c8a", 1, 0.6, 0.04)
    );
    tagMesh(plasmid, "plasmid", 1, "#d04c8a");
    plasmid.position.set(0.7, -0.32, 0.34);
    plasmid.rotation.set(0.4, 0.3, 0.2);
    root.add(plasmid);

    /* Flagellum — long swimming tail off one end. */
    root.add(curveTubeMesh("flagellum", "#b87438",
        [[1.82, -0.22, 0.08], [2.35, -0.72, 0], [2.95, -0.5, 0.02], [3.55, -0.95, 0]],
        0.055));

    /* Pili — short surface fibers (adhesion + conjugation). Bacteria
       differentiator. Multiple short tubes radiating from the surface
       on the OPPOSITE end from the flagellum. */
    const piliEndpoints = [
        [-1.78, 0.62, 0.20],
        [-1.62, 0.78, -0.10],
        [-1.85, 0.40, -0.05],
        [-1.92, 0.20, 0.18],
        [-1.55, 0.85, 0.25]
    ];
    piliEndpoints.forEach(end => {
        root.add(curveTubeMesh("pili", "#c98f3e",
            [[-1.55, 0.18, 0.10],
             [(end[0] - 1.55) / 2, (end[1] + 0.18) / 2, end[2]],
             end],
            0.022));
    });

    /* Ribosomes — was previously a "nucleoid"-tagged dot cluster (orange,
       scattered). That made no biological sense — the nucleoid is one
       coherent region, not scattered dots. Retagged as ribosomes and
       recolored to match the bacterial-ribosome accent. */
    root.add(dotsGroup("ribosomes", "#a05f9f", 34, [1.32, 0.48, 0.36]));

    return root;
}

function buildAnimalModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.06, -0.34, 0);
    root.scale.set(1.08, 1.08, 1.08);

    /* Plasma Membrane — was tagged "membrane" (filtered out, non-clickable).
       Animal cells have no wall so this IS the outer boundary; tag it
       properly so it's a real organelle. depthWrite:false + renderOrder
       for stable transparent depth sort. */
    const plasmaMat = makeStudioMaterial("#9db6dc", crossSection ? 0.28 : 0.48, 0.66, 0.03);
    plasmaMat.depthWrite = false;
    const plasma = new THREE.Mesh(
        new THREE.SphereGeometry(1, 64, 64),
        plasmaMat
    );
    tagMesh(plasma, "plasmaMembrane", crossSection ? 0.28 : 0.48, "#9db6dc");
    plasma.scale.set(1.7, 1.25, 0.72);
    plasma.renderOrder = 3;
    root.add(plasma);

    /* Nucleus + Mitochondria + Golgi — kept from the original layout. */
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

    /* Endoplasmic Reticulum — two curve tubes extending from the nuclear
       envelope, the textbook "ER spreads out from the nucleus" look. */
    root.add(curveTubeMesh("er", "#d97757",
        [[0.48, 0.32, 0.42], [0.85, 0.20, 0.46], [1.20, 0.42, 0.42], [1.55, 0.18, 0.40]],
        0.045));
    root.add(curveTubeMesh("er", "#d97757",
        [[-0.18, 0.42, 0.46], [-0.05, 0.65, 0.46], [0.28, 0.78, 0.44], [0.62, 0.62, 0.42]],
        0.04));

    /* Lysosome — animal-specific waste-digestion vesicle. A small spherical
       compartment with a darker enzyme-rich inside. */
    const lyso = new THREE.Mesh(
        new THREE.SphereGeometry(0.18, 28, 28),
        makeStudioMaterial("#8b54b7", 0.85, 0.6, 0.04)
    );
    tagMesh(lyso, "lysosome", 0.85, "#8b54b7");
    lyso.position.set(-0.68, -0.52, 0.40);
    root.add(lyso);
    // Pair of smaller lysosomes nearby to suggest multiple vesicles.
    const lyso2 = new THREE.Mesh(
        new THREE.SphereGeometry(0.13, 24, 24),
        makeStudioMaterial("#8b54b7", 0.85, 0.6, 0.04)
    );
    tagMesh(lyso2, "lysosome", 0.85, "#8b54b7");
    lyso2.position.set(-0.42, -0.68, 0.44);
    root.add(lyso2);

    /* Centrosome — animal-only. Two perpendicular centriole cylinders
       sitting near the nucleus. Plant cells lack these entirely. */
    const centrosomeMat = makeStudioMaterial("#67b1c4", 1, 0.5, 0.08);
    const centriole1 = new THREE.Mesh(
        new THREE.CylinderGeometry(0.06, 0.06, 0.20, 16),
        centrosomeMat
    );
    tagMesh(centriole1, "centrosome", 1, "#67b1c4");
    centriole1.position.set(-0.05, -0.32, 0.46);
    root.add(centriole1);
    const centriole2 = new THREE.Mesh(
        new THREE.CylinderGeometry(0.06, 0.06, 0.20, 16),
        centrosomeMat
    );
    tagMesh(centriole2, "centrosome", 1, "#67b1c4");
    centriole2.position.set(0.08, -0.32, 0.46);
    centriole2.rotation.z = Math.PI / 2;  // second centriole perpendicular to first
    root.add(centriole2);

    /* Ribosomes — was previously a "nucleus"-tagged purple-dot cluster.
       That made no sense biologically (the nucleus is one compartment,
       not scattered dots). Retagged as ribosomes (animal-specific 80S). */
    root.add(dotsGroup("ribosomes", "#a05f9f", 28, [1.25, 0.85, 0.46]));

    return root;
}

function buildMuscleModel(crossSection) {
    const root = new THREE.Group();
    root.rotation.set(0.15, -0.26, -0.03);
    root.scale.set(1.08, 1.08, 1.08);

    /* Sarcolemma — the muscle's plasma membrane. Transparent so the
       internal myofibrils + nuclei + organelles read through. */
    const sheathMat = makeStudioMaterial("#d7b284", crossSection ? 0.26 : 0.42, 0.66, 0.03);
    sheathMat.depthWrite = false;
    const sheath = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.76, 2.9, 14, 48),
        sheathMat
    );
    tagMesh(sheath, "sarcolemma", crossSection ? 0.26 : 0.42, "#d7b284");
    sheath.rotation.z = Math.PI / 2;
    sheath.scale.set(0.95, 1, 0.82);
    sheath.renderOrder = 3;
    root.add(sheath);

    /* Myofibrils — the contracting threads. 9 fibers in a 3×3 grid. */
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

    /* Nuclei — was previously tagged "mitochondria" but nucleusGroup
       renders a nucleus visual (sphere + nucleolus). Muscle fibers are
       famously multinucleated — 3 nuclei here suggest the many that line
       a real fiber, positioned just under the sarcolemma. */
    [
        [-1.1,  0.54, 0.36],
        [ 1.42, -0.38, 0.36],
        [ 0.05,  0.62, 0.40]
    ].forEach(pos => {
        root.add(nucleusGroup("nucleus", pos, [0.26, 0.2, 0.18], "#7a4aa2"));
    });

    /* Mitochondria — actual rod-shaped meshes. Placed in the gaps
       BETWEEN myofibrils, the anatomically correct position. */
    root.add(mitochondrionGroup("mitochondrion",
        [-0.58, 0.0, 0.55], [0.25, 0.1, 1.55], [0.65, 0.65, 0.65]));
    root.add(mitochondrionGroup("mitochondrion",
        [ 0.24, 0.0, 0.55], [0.25, 0.1, 1.55], [0.65, 0.65, 0.65]));
    root.add(mitochondrionGroup("mitochondrion",
        [ 1.06, 0.0, 0.55], [0.25, 0.1, 1.55], [0.65, 0.65, 0.65]));

    /* T-Tubules — was previously tagged "sarcolemma" but these tubes
       traverse the cell INTERIOR (y from -0.86 to 0.72), not the outer
       surface. They're invaginations of the sarcolemma that dive between
       myofibrils to carry the action potential deep into the fiber. */
    for (let i = 0; i < 5; i++) {
        root.add(curveTubeMesh("tTubules", "#ead2a7",
            [[-1.55 + i * 0.65, -0.86, 0.26],
             [-1.45 + i * 0.65, -0.24, 0.34],
             [-1.55 + i * 0.65, 0.72, 0.28]],
            0.035));
    }

    /* Sarcoplasmic Reticulum — modified smooth ER that wraps each
       myofibril longitudinally, storing the Ca²⁺ that triggers
       contraction. Rendered as thin curve tubes running parallel to
       the myofibrils along the front row. */
    [-0.42, 0, 0.42].forEach(y => {
        root.add(curveTubeMesh("sarcoplasmicReticulum", "#b9c7e9",
            [[-1.05, y, -0.05],
             [-0.42, y + 0.04, -0.02],
             [ 0.20, y - 0.03, -0.05],
             [ 0.82, y + 0.02, -0.04],
             [ 1.42, y, -0.05]],
            0.022));
    });

    /* Z-Discs — sarcomere boundaries. Small ring bands wrapping each
       front-row myofibril at the ends (suggesting where one sarcomere
       ends and the next begins). The "striation" you see in microscopy. */
    [-0.58, 0.24, 1.06].forEach(x => {
        // Two Z-discs per myofibril: one near each end.
        [-0.30, 0.30].forEach(zOffset => {
            const disc = new THREE.Mesh(
                new THREE.TorusGeometry(0.15, 0.012, 6, 24),
                makeStudioMaterial("#e8a76a", 1, 0.55, 0.06)
            );
            tagMesh(disc, "zDisc", 1, "#e8a76a");
            disc.position.set(x + zOffset, 0, 0.15);
            disc.rotation.y = Math.PI / 2;  // ring lies in YZ plane, perpendicular to myofibril X-axis
            root.add(disc);
        });
    });

    /* Ribosomes — scattered between myofibrils for protein synthesis. */
    root.add(dotsGroup("ribosomes", "#a05f9f", 22, [1.45, 0.78, 0.42]));

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
    /* Plasma Membrane — was previously tagged "membrane" (filtered ID,
       non-clickable). Retagged as "plasmaMembrane" for consistency with
       every other cell. The biconcave disc IS the plasma membrane —
       RBCs have nothing else as an outer boundary. */
    const discMat = makeStudioMaterial("#d96565", 0.86, 0.5, 0.03);
    discMat.depthWrite = false;
    const disc = new THREE.Mesh(discGeom, discMat);
    tagMesh(disc, "plasmaMembrane", 0.86, "#d96565");
    disc.renderOrder = 3;
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

    /* Surface Antigens — Band 3 / Glycophorin / ABO + Rh markers. Render
       as small bright dots scattered around the disc rim (highest density
       at the periphery where they pack most thickly). Medically critical
       for blood typing and transfusion compatibility. */
    const ANTIGEN_COUNT = 24;
    for (let i = 0; i < ANTIGEN_COUNT; i++) {
        const a = (i / ANTIGEN_COUNT) * Math.PI * 2;
        const r = 0.88 + Math.sin(i * 2.4) * 0.04;       // hug the rim with slight jitter
        const yJ = (Math.sin(i * 3.1) * 0.05);
        const dot = new THREE.Mesh(
            new THREE.SphereGeometry(0.022, 12, 12),
            makeStudioMaterial("#e8b95a", 1, 0.5, 0.06)
        );
        tagMesh(dot, "surfaceAntigens", 1, "#e8b95a");
        dot.position.set(Math.cos(a) * r, yJ, Math.sin(a) * r);
        root.add(dot);
    }

    /* 2,3-BPG — small cytoplasmic molecules that gate hemoglobin's oxygen
       release. Rendered as a separate cluster of teal dots inside the
       disc body (paired with hemoglobin in real biology). */
    root.add(dotsGroup("bpg", "#7fc1c4", 18, [0.6, 0.10, 0.6]));

    return root;
}

function buildSpermModel() {
    const root = new THREE.Group();
    root.rotation.set(0.02, 0.18, 0);
    root.scale.set(1.0, 1.0, 1.0);

    /* Head — outer anatomical envelope. Made translucent so the inner
       nucleus reads through. depthWrite:false + renderOrder for stable
       depth sort against the nucleus inside. */
    const headMat = makeStudioMaterial("#7a49b0", 0.45, 0.48, 0.03);
    headMat.depthWrite = false;
    const head = new THREE.Mesh(
        new THREE.SphereGeometry(0.42, 36, 36),
        headMat
    );
    tagMesh(head, "head", 0.45, "#7a49b0");
    head.scale.set(0.7, 0.5, 0.7);
    head.position.set(-1.55, 0, 0);
    head.renderOrder = 3;
    root.add(head);

    /* Nucleus — dense haploid DNA core inside the head. Smaller and
       darker than the head envelope so it reads as the central payload. */
    const nucleus = new THREE.Mesh(
        new THREE.SphereGeometry(0.42, 30, 30),
        makeStudioMaterial("#5a368e", 0.98, 0.55, 0.04)
    );
    tagMesh(nucleus, "nucleus", 0.98, "#5a368e");
    nucleus.scale.set(0.50, 0.35, 0.50);  // slightly smaller than head
    nucleus.position.set(-1.50, 0, 0);
    root.add(nucleus);

    /* Acrosome — translucent enzyme cap at the front tip. */
    const acrosomeMat = makeStudioMaterial("#c9a8ee", 0.78, 0.5, 0.04);
    acrosomeMat.depthWrite = false;
    const acrosome = new THREE.Mesh(
        new THREE.SphereGeometry(0.42, 32, 32),
        acrosomeMat
    );
    tagMesh(acrosome, "acrosome", 0.78, "#c9a8ee");
    acrosome.scale.set(0.6, 0.42, 0.6);
    acrosome.position.set(-1.92, 0, 0);
    acrosome.renderOrder = 2;
    root.add(acrosome);

    /* Proximal Centriole — small cylinder at the head-midpiece junction.
       Sperm-specific story: the egg has lost its centrioles, so this is
       the single organelle the future embryo inherits from the father. */
    const centriole = new THREE.Mesh(
        new THREE.CylinderGeometry(0.05, 0.05, 0.12, 14),
        makeStudioMaterial("#67b1c4", 1, 0.5, 0.08)
    );
    tagMesh(centriole, "centriole", 1, "#67b1c4");
    centriole.rotation.z = Math.PI / 2;  // axis along X, behind the nucleus
    centriole.position.set(-1.28, 0, 0);
    root.add(centriole);

    /* Midpiece — connecting cylinder between head and flagellum. */
    const midpiece = new THREE.Mesh(
        new THREE.CylinderGeometry(0.085, 0.08, 0.7, 28),
        makeStudioMaterial("#cf7042", 0.95, 0.5, 0.03)
    );
    tagMesh(midpiece, "midpiece", 0.95, "#cf7042");
    midpiece.rotation.z = Math.PI / 2;
    midpiece.position.set(-0.95, 0, 0);
    root.add(midpiece);

    /* Mitochondria — the helical sheath wrapping the midpiece. Was
       previously tagged "midpiece" (catch-all); split out as its own
       organelle since the helix IS the energy-supply structure and
       has its own evolutionary story (paternal mtDNA destroyed after
       fertilisation). */
    const COILS = 22;
    for (let i = 0; i < COILS; i++) {
        const t = i / (COILS - 1);
        const phase = t * Math.PI * 8;
        const ring = new THREE.Mesh(
            new THREE.TorusGeometry(0.115, 0.02, 8, 16),
            makeStudioMaterial("#f0b074", 1, 0.5, 0.03)
        );
        tagMesh(ring, "mitochondrion", 1, "#f0b074");
        ring.position.set(-1.29 + t * 0.7, 0, 0);
        ring.rotation.z = Math.PI / 2;
        ring.rotation.y = phase;
        root.add(ring);
    }

    /* Flagellum — sinuous propulsion tail with 9+2 axoneme inside. */
    root.add(curveTubeMesh("flagellum", "#7d9bcf",
        [[-0.6, 0.0, 0.0], [0.05, 0.14, 0], [0.7, -0.16, 0],
         [1.4, 0.12, 0], [2.05, -0.06, 0]],
        0.05));

    /* Plasma Membrane — thin envelope wrapping the whole cell. Rendered
       as a sleeve around the midpiece + head region (most visible there);
       the flagellum's membrane is too thin to show usefully. */
    const plasmaMat = makeStudioMaterial("#a98ec8", 0.22, 0.55, 0.02);
    plasmaMat.depthWrite = false;
    const plasma = new THREE.Mesh(
        new THREE.CapsuleGeometry(0.34, 1.4, 14, 36),
        plasmaMat
    );
    tagMesh(plasma, "plasmaMembrane", 0.22, "#a98ec8");
    plasma.rotation.z = Math.PI / 2;
    plasma.position.set(-1.05, 0, 0);
    plasma.renderOrder = 4;
    root.add(plasma);

    return root;
}

function buildYeastModel() {
    const root = new THREE.Group();
    root.rotation.set(0.02, -0.12, 0);
    root.scale.set(1.1, 1.1, 1.1);

    /* Mother cell — chitin/glucan outer wall (translucent). */
    const wallMat = makeStudioMaterial("#d5a849", 0.42, 0.6, 0.03);
    wallMat.depthWrite = false;
    const wall = new THREE.Mesh(
        new THREE.SphereGeometry(1.15, 56, 56),
        wallMat
    );
    tagMesh(wall, "cellWall", 0.42, "#d5a849");
    wall.renderOrder = 3;
    root.add(wall);

    /* Plasma Membrane — was previously tagged "cellWall" (a second wall
       layer made no biological sense). The inner shell is the plasma
       membrane sitting just inside the chitin wall. */
    const plasmaMat = makeStudioMaterial("#b88040", 0.3, 0.6, 0.03);
    plasmaMat.depthWrite = false;
    const plasma = new THREE.Mesh(
        new THREE.SphereGeometry(1.0, 48, 48),
        plasmaMat
    );
    tagMesh(plasma, "plasmaMembrane", 0.3, "#b88040");
    plasma.renderOrder = 2;
    root.add(plasma);

    /* Daughter bud — smaller sphere attached at one shoulder. */
    const budCenter = new THREE.Vector3(1.05, 0.45, 0.3);
    const budR = 0.55;
    const budMat = makeStudioMaterial("#dab15c", 0.42, 0.6, 0.03);
    budMat.depthWrite = false;
    const bud = new THREE.Mesh(
        new THREE.SphereGeometry(budR, 44, 44),
        budMat
    );
    tagMesh(bud, "bud", 0.42, "#dab15c");
    bud.position.copy(budCenter);
    bud.renderOrder = 3;
    root.add(bud);

    const budInnerMat = makeStudioMaterial("#b88040", 0.3, 0.6, 0.03);
    budInnerMat.depthWrite = false;
    const budInner = new THREE.Mesh(
        new THREE.SphereGeometry(budR * 0.87, 32, 32),
        budInnerMat
    );
    tagMesh(budInner, "bud", 0.3, "#b88040");
    budInner.position.copy(budCenter);
    budInner.renderOrder = 2;
    root.add(budInner);

    /* Central nucleus. */
    root.add(nucleusGroup("nucleus", [0.05, 0.05, 0.1], [0.42, 0.42, 0.42], "#7047a8"));

    /* Vacuole — translucent blue sphere offset to one side. */
    const vacuole = new THREE.Mesh(
        new THREE.SphereGeometry(0.5, 36, 36),
        makeStudioMaterial("#62bdd2", 0.55, 0.5, 0.03)
    );
    tagMesh(vacuole, "vacuole", 0.55, "#62bdd2");
    vacuole.position.set(-0.42, -0.32, 0.28);
    root.add(vacuole);

    /* Mitochondria — were previously tagged "nucleus" (a clear bug —
       mitochondrionGroup builds rod-shaped meshes, never nuclei).
       Retagged "mitochondrion". */
    root.add(mitochondrionGroup("mitochondrion", [0.32, 0.55, 0.42], [0.2, 0, 0.9], [0.55, 0.55, 0.55]));
    root.add(mitochondrionGroup("mitochondrion", [0.52, -0.5, -0.18], [0.15, 0.4, -0.55], [0.5, 0.5, 0.5]));

    /* Endoplasmic Reticulum — continuous with the nuclear envelope.
       A curve tube extending from near the nucleus into the cytoplasm. */
    root.add(curveTubeMesh("er", "#d97757",
        [[0.18, 0.20, 0.28], [0.42, 0.28, 0.35], [0.62, 0.05, 0.38], [0.55, -0.22, 0.32]],
        0.040));
    root.add(curveTubeMesh("er", "#d97757",
        [[-0.18, 0.32, 0.28], [-0.42, 0.20, 0.30], [-0.58, -0.05, 0.22], [-0.45, -0.25, 0.20]],
        0.035));

    /* Ribosomes — scattered through the cytoplasm. */
    root.add(dotsGroup("ribosomes", "#a05f9f", 24, [0.82, 0.78, 0.55]));

    /* Bud Scars — yeast-specific aging marker. Chitin rings on the
       mother surface where previous buds detached. We place 3 small
       rings on different points of the wall to suggest a cell that
       has reproduced a few times already. */
    const scarPositions = [
        [-0.95, 0.35, 0.55],   // left-upper
        [-0.40, -0.85, 0.55],  // bottom-left
        [ 0.55, -0.85, 0.55]   // bottom-right
    ];
    scarPositions.forEach(pos => {
        const scar = new THREE.Mesh(
            new THREE.TorusGeometry(0.12, 0.022, 8, 24),
            makeStudioMaterial("#b87438", 1, 0.6, 0.05)
        );
        tagMesh(scar, "budScar", 1, "#b87438");
        // Position on the wall surface, oriented so the ring lies
        // tangent to the spherical surface (faces outward).
        const v = new THREE.Vector3(pos[0], pos[1], pos[2]).normalize();
        const onSurface = v.clone().multiplyScalar(1.16);
        scar.position.copy(onSurface);
        // Rotate the ring so its plane is perpendicular to the surface normal.
        scar.lookAt(onSurface.clone().add(v));
        root.add(scar);
    });

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

    /* Nucleus — single central nucleus. WAS previously tagged "sarcomere"
       (mistag — nucleusGroup builds a nucleus visual, not a sarcomere
       band) AND the data list didn't even contain a nucleus entry.
       Cardiomyocytes are famously SINGLE-nucleated (cf. skeletal muscle's
       many nuclei from myoblast fusion) so this is a major differentiator. */
    root.add(nucleusGroup("nucleus", [0.05, 0.0, 0.25], [0.38, 0.32, 0.32], "#7a49b0"));

    /* Sarcomere striations — bands across the body length. */
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

    /* Mitochondria — cardiomyocytes are mitochondria-rich. */
    for (let i = 0; i < 7; i++) {
        const x = -1.3 + i * 0.45;
        root.add(mitochondrionGroup("mitochondrion",
            [x, 0.32 * Math.sin(i * 1.3), 0.3], [0.15, 0, 1.55], [0.62, 0.62, 0.62]));
    }

    /* Intercalated discs — at the end-to-end junctions. */
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

    /* T-Tubules — sarcolemma invaginations at the Z-discs. Cardiac
       T-tubules are wider than skeletal. Rendered as short capsules
       diving vertically into the cell at the sarcomere boundaries
       (every other stripe position). */
    for (let i = -5; i <= 5; i += 2) {
        const tt = new THREE.Mesh(
            new THREE.CapsuleGeometry(0.04, 0.62, 6, 14),
            makeStudioMaterial("#ead2a7", 1, 0.55, 0.04)
        );
        tagMesh(tt, "tTubules", 1, "#ead2a7");
        tt.position.set(i * 0.22, 0, -0.10);
        // CapsuleGeometry's axis is Y by default — vertical, perpendicular to
        // the body's long axis (X). Exactly the "transverse tubule" geometry.
        root.add(tt);
    }

    /* Sarcoplasmic Reticulum — runs longitudinally between the
       Z-discs (parallel to the cell long axis), forming the dyad
       structure where each SR cisterna pairs with one T-tubule. */
    [-0.32, 0.32].forEach(y => {
        root.add(curveTubeMesh("sarcoplasmicReticulum", "#b9c7e9",
            [[-1.20, y, -0.15],
             [-0.40, y + 0.02, -0.12],
             [ 0.40, y - 0.03, -0.15],
             [ 1.20, y, -0.13]],
            0.022));
    });

    /* Gap Junctions — small disc-shaped pores embedded inside the
       intercalated discs. Rendered as 4 small bright rings on the face
       of each intercalated disc (suggesting the connexin channel pores
       that let ions flow between cells). */
    [-1.55, 1.55].forEach(x => {
        [[ 0.20,  0.20], [-0.20,  0.20], [ 0.20, -0.20], [-0.20, -0.20]].forEach(yz => {
            const gj = new THREE.Mesh(
                new THREE.TorusGeometry(0.07, 0.014, 6, 18),
                makeStudioMaterial("#e6c46a", 1, 0.55, 0.06)
            );
            tagMesh(gj, "gapJunction", 1, "#e6c46a");
            gj.position.set(x, yz[0], yz[1]);
            gj.rotation.y = Math.PI / 2;  // ring face perpendicular to long axis
            root.add(gj);
        });
    });

    /* Ribosomes — scattered between myofibrils for protein turnover. */
    root.add(dotsGroup("ribosomes", "#a05f9f", 24, [1.3, 0.55, 0.4]));

    return root;
}

function buildVirusModel() {
    const root = new THREE.Group();
    root.scale.set(1.35, 1.35, 1.35);

    /* Icosahedral capsid — the protein shell. */
    const capsidGeom = new THREE.IcosahedronGeometry(0.9, 1);
    const capsid = new THREE.Mesh(capsidGeom, makeStudioMaterial("#b85a9c", 0.95, 0.45, 0.05));
    tagMesh(capsid, "capsid", 0.95, "#b85a9c");
    root.add(capsid);

    /* Matrix Protein — thin layer between capsid and envelope, anchoring
       the spike proteins from underneath. Rendered as a slightly larger
       icosahedron with reduced opacity, sitting just outside the capsid. */
    const matrixMat = makeStudioMaterial("#9a4d8c", 0.55, 0.55, 0.06);
    matrixMat.depthWrite = false;
    const matrix = new THREE.Mesh(
        new THREE.IcosahedronGeometry(0.96, 1),
        matrixMat
    );
    tagMesh(matrix, "matrix", 0.55, "#9a4d8c");
    matrix.renderOrder = 2;
    root.add(matrix);

    /* Envelope — lipid membrane stolen from the host cell. Wraps the
       capsid + matrix; spikes emerge through it. depthWrite:false +
       renderOrder so the nested-transparent stack sorts cleanly. */
    const envelopeMat = makeStudioMaterial("#e0b3d5", 0.32, 0.62, 0.03);
    envelopeMat.depthWrite = false;
    const envelope = new THREE.Mesh(
        new THREE.SphereGeometry(1.05, 48, 48),
        envelopeMat
    );
    tagMesh(envelope, "envelope", 0.32, "#e0b3d5");
    envelope.renderOrder = 3;
    root.add(envelope);

    /* Spike proteins — cones at the 12 icosahedron vertices, now
       emerging FROM the envelope (the position is bumped out to sit
       outside the envelope sphere). */
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
        spike.position.copy(dir).multiplyScalar(1.22);  // bumped outside envelope
        spike.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), dir.clone().normalize());
        root.add(spike);
    });

    /* Genome — a tangled curve tube hinting at the packed nucleic acid
       inside the capsid. */
    root.add(curveTubeMesh("genome", "#7a43ad",
        [[-0.32, 0.20, 0.10], [0.10, -0.16, 0.28], [-0.20, 0.14, -0.20],
         [0.22, 0.25, 0.04], [-0.10, -0.28, 0.18], [0.27, -0.04, -0.16]],
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
        autoRotate: true,
        labelsVisible: false
    };

    // Labels are a child of currentGroup so they auto-rotate with the cell,
    // but disposeGroup() walks meshes only (sprites pass through) so we
    // manage label disposal explicitly. labelsGroup is rebuilt every time
    // installGroup runs.
    let labelsGroup = null;

    function disposeLabels() {
        if (!labelsGroup) return;
        labelsGroup.traverse(node => {
            if (node.isSprite) {
                if (node.material) {
                    if (node.material.map) node.material.map.dispose();
                    node.material.dispose();
                }
            }
        });
        if (labelsGroup.parent) labelsGroup.parent.remove(labelsGroup);
        labelsGroup = null;
    }

    function buildAndAttachLabels() {
        disposeLabels();
        if (!currentGroup || !state.cell) return;
        labelsGroup = buildLabelsGroup(currentGroup, state.cell);
        labelsGroup.visible = !!state.labelsVisible;
        currentGroup.add(labelsGroup);
    }

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
        // Dispose labels first — they're parented under currentGroup and
        // disposeGroup() only walks meshes, so sprites would leak textures.
        disposeLabels();
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
                buildAndAttachLabels();
                onProgress({ phase: "loaded", cell: cell, progress: 100 });
            }).catch(err => {
                if (token !== pendingLoadToken) return;
                // GLB load failed (CORS, 404, malformed) — fall back to
                // procedural geometry so the page still renders something.
                console.warn("biology: GLB load failed for " + cell.id + ", using procedural fallback", err);
                const proc = (PROCEDURAL_BUILDERS[cell.modelKind] || buildAnimalModel)(state.crossSection);
                installGroup(proc, false);
                updateMaterials(proc, state.activeOrganelle, state.viewMode);
                buildAndAttachLabels();
                onProgress({ phase: "error", cell: cell, error: err });
                onError(err);
            });
        } else {
            ++pendingLoadToken; // cancel any in-flight async load
            const proc = (PROCEDURAL_BUILDERS[cell.modelKind] || buildAnimalModel)(state.crossSection);
            installGroup(proc, false);
            updateMaterials(proc, state.activeOrganelle, state.viewMode);
            buildAndAttachLabels();
            onProgress({ phase: "loaded", cell: cell, progress: 100 });
        }
        currentCellId = cell.id;
    }

    function update(props) {
        const next = Object.assign({}, state, props);

        const cellChanged = next.cell && (!state.cell || next.cell.id !== state.cell.id);
        const crossSectionChanged = next.crossSection !== state.crossSection;
        const labelsChanged = next.labelsVisible !== state.labelsVisible;

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
            if (labelsChanged && labelsGroup) labelsGroup.visible = !!state.labelsVisible;
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

    /* isPickable — walks the object's parent chain up to currentGroup and
       returns false if any ancestor (or the object itself) is hidden via
       .visible = false. Needed because three.js's raycaster does NOT
       respect Object3D.visible when traversing — without this, sprites
       in the labelsGroup would intercept clicks even when the user has
       Labels turned off. */
    function isPickable(obj) {
        let p = obj;
        while (p && p !== currentGroup.parent) {
            if (p.visible === false) return false;
            p = p.parent;
        }
        return true;
    }

    function organelleAtPointer(event) {
        const rect = canvas.getBoundingClientRect();
        if (rect.width === 0 || rect.height === 0) return null;
        pointer.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
        pointer.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
        raycaster.setFromCamera(pointer, camera);
        if (!currentGroup) return null;
        const hits = raycaster.intersectObject(currentGroup, true);

        /* First pass — label sprites win. The sprite is a camera-facing
           billboard, so a sprite hit means the cursor is literally over
           a numbered puck. Without this, an outer translucent shell like
           the White Blood plasma-membrane sphere would always be the
           closest 3D hit and eat every label click. */
        for (let i = 0; i < hits.length; i++) {
            const obj = hits[i].object;
            if (!obj.isSprite) continue;
            if (!isPickable(obj)) continue;
            const id = obj.userData && obj.userData.organelleId;
            if (id) return id;
        }

        /* Second pass — nearest mesh hit. Used when the click missed the
           pucks (or labels are off). */
        for (let i = 0; i < hits.length; i++) {
            const obj = hits[i].object;
            if (!isPickable(obj)) continue;
            const ud = obj.userData;
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
            // Gentle drift — about one full turn every ~100s. Slow enough
            // that organelles stay readable; the rotation is a "this is
            // 3D" hint, not a presentation animation.
            currentGroup.rotation.y += dt * 0.06;
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
