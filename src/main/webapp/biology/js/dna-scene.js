/*
 * biology/js/dna-scene.js
 *
 * Three.js scene module for DNA Viewer 3D (Studio mode).
 *
 * Loaded as an ES module via the import-map declared in dna-viewer.jsp.
 * Builds a procedural double helix from a user-supplied A/T/G/C sequence:
 *   - Two phosphate-backbone curve tubes (Catmull-Rom helix paths)
 *   - One cylinder per base pair connecting the strands, colored by base
 *   - Optional numbered puck label sprites on each base pair
 *
 * Public API (exposed on window.DnaScene):
 *   const ctl = DnaScene.mount(canvas, opts);
 *   ctl.update({ sequence, activeIndex, viewMode, labelsVisible, autoRotate });
 *   ctl.screenshot();
 *   ctl.reset();
 *   ctl.dispose();
 *
 * Patterns mirror biology/js/cell-scene.js so we keep one mental model
 * across the biology tools.
 */

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";

/* ------------------------------------------------------------------ */
/* Base palette + biology data                                         */
/* ------------------------------------------------------------------ */

// Standard Watson-Crick coloring used in this tool's UI.
//   · Canonical bases (A/T/G/C) get distinct colors.
//   · Uracil (U, from RNA input) reuses T's color since U replaces T.
//   · IUPAC ambiguity codes (N, R, Y, S, W, K, M, B, D, H, V) render in
//     a neutral gray so they're visually distinct from canonical bases.
//   · Gaps (- and .) have no rung at all — the backbone continues through
//     but no base-pair cylinder is drawn.
const AMBIGUOUS_COLOR = "#9aa0a6";  // medium gray for IUPAC ambiguity codes

const BASE_COLOR = {
    A: "#e74c3c", T: "#f1c40f", G: "#2ecc71", C: "#3498db",
    U: "#f1c40f",
    R: AMBIGUOUS_COLOR, Y: AMBIGUOUS_COLOR, S: AMBIGUOUS_COLOR,
    W: AMBIGUOUS_COLOR, K: AMBIGUOUS_COLOR, M: AMBIGUOUS_COLOR,
    B: AMBIGUOUS_COLOR, D: AMBIGUOUS_COLOR, H: AMBIGUOUS_COLOR,
    V: AMBIGUOUS_COLOR, N: AMBIGUOUS_COLOR
};
const BACKBONE_COLOR = "#9aa0a6";
const RUNG_GAP_COLOR = "#cfc9bd";

// IUPAC complement table (Watson-Crick + ambiguity reversals).
//   R (purine A/G) ↔ Y (pyrimidine C/T)
//   S (strong G/C) ↔ S       W (weak A/T) ↔ W       K (G/T) ↔ M (A/C)
//   B (not A) ↔ V (not T)    D (not C) ↔ H (not G)  N ↔ N
const COMPLEMENT = {
    A: "T", T: "A", G: "C", C: "G",
    U: "A",
    R: "Y", Y: "R", S: "S", W: "W", K: "M", M: "K",
    B: "V", V: "B", D: "H", H: "D", N: "N",
    "-": "-", ".": "-"
};

function isGap(ch)       { return ch === "-" || ch === "."; }
function isCanonical(ch) { return ch === "A" || ch === "T" || ch === "G" || ch === "C"; }
function isAmbiguous(ch) {
    return ch === "R" || ch === "Y" || ch === "S" || ch === "W" ||
           ch === "K" || ch === "M" || ch === "B" || ch === "D" ||
           ch === "H" || ch === "V" || ch === "N";
}

/* ------------------------------------------------------------------ */
/* Helix geometry constants                                            */
/* ------------------------------------------------------------------ */

// B-DNA-flavored but stylized for legibility:
//   · 10 base pairs per turn (real B-DNA = 10.5)
//   · rise per base pair = 0.4 world units (real ≈ 3.4 Å)
//   · helix radius = 0.95 world units
//   · ~120° / 240° angular offset between strands (close to B-DNA's
//     minor/major groove asymmetry, but rounded for visual symmetry)
const HELIX_RADIUS = 0.95;
const RISE = 0.40;
const TURN_BP = 10;
const TWO_PI_OVER_BP = (2 * Math.PI) / TURN_BP;
const STRAND_OFFSET = Math.PI;   // 180° for stylized symmetry
const RUNG_RADIUS = 0.06;
const BACKBONE_RADIUS = 0.13;

/* ------------------------------------------------------------------ */
/* Material factory                                                    */
/* ------------------------------------------------------------------ */

function makeStudioMaterial(color, opacity, roughness, metalness) {
    return new THREE.MeshStandardMaterial({
        color: new THREE.Color(color),
        roughness: roughness == null ? 0.55 : roughness,
        metalness: metalness == null ? 0.04 : metalness,
        transparent: opacity < 1,
        opacity: opacity == null ? 1 : opacity,
        side: THREE.DoubleSide
    });
}

/* ------------------------------------------------------------------ */
/* Sequence sanitization                                               */
/* ------------------------------------------------------------------ */

/* Strip anything that isn't an IUPAC nucleotide code, U (uracil for
 * RNA), or a gap character ('-' or '.'). Lets users paste FASTA-style
 * data, line numbers, alignment output, etc. without manual cleanup.
 * Returns the cleaned uppercase string; non-IUPAC characters are
 * silently dropped. */
function sanitizeSequence(raw, maxLength) {
    if (!raw) return "";
    const cleaned = String(raw).toUpperCase().replace(/[^ATGCURYSKMBDHVN\-.]/g, "");
    return maxLength ? cleaned.slice(0, maxLength) : cleaned;
}

/* sequenceStats — analyzes a cleaned sequence and returns counts of
 * each character category so the UI can show "2 N bases, 1 U, 3 gaps"
 * style transparency. */
function sequenceStats(seq) {
    const out = { total: seq.length, canonical: 0, rna: 0, ambiguous: 0, gap: 0 };
    for (let i = 0; i < seq.length; i++) {
        const c = seq[i];
        if (isCanonical(c)) out.canonical++;
        else if (c === "U") out.rna++;
        else if (isGap(c)) out.gap++;
        else if (isAmbiguous(c)) out.ambiguous++;
    }
    return out;
}

/* ------------------------------------------------------------------ */
/* Label sprite (reused pattern from cell-scene.js)                    */
/* ------------------------------------------------------------------ */

function makeNumberSprite(number, color) {
    const DPR = Math.min(window.devicePixelRatio || 1, 2);
    const size = 64;
    const fontSize = 30;

    const canvas = document.createElement("canvas");
    canvas.width = size * DPR;
    canvas.height = size * DPR;
    const ctx = canvas.getContext("2d");
    ctx.scale(DPR, DPR);

    const cx = size / 2;
    const cy = size / 2;
    const r = size / 2 - 3;

    ctx.fillStyle = "rgba(20, 18, 14, 0.92)";
    ctx.beginPath();
    ctx.arc(cx, cy, r + 3, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = color || "#9c9c9c";
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI * 2);
    ctx.fill();

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
        depthTest: false
    });
    mat.clippingPlanes = [];

    const sprite = new THREE.Sprite(mat);
    sprite.scale.set(0.20, 0.20, 1);
    sprite.renderOrder = 999;
    sprite.userData.isLabel = true;
    return sprite;
}

/* ------------------------------------------------------------------ */
/* Build helix                                                         */
/* ------------------------------------------------------------------ */

function strandPoint(i, strand) {
    // strand: 0 = front strand, 1 = back strand (180° offset)
    const angle = i * TWO_PI_OVER_BP + (strand === 0 ? 0 : STRAND_OFFSET);
    const y = i * RISE;
    return new THREE.Vector3(
        HELIX_RADIUS * Math.cos(angle),
        y,
        HELIX_RADIUS * Math.sin(angle)
    );
}

function tagMesh(mesh, seqIndex, basePairIndex, baseLetter) {
    // Compound ID lets a single helix or many helices share the same
    // namespace — "s{seq}-bp{pos}". Picker returns this string; the page
    // controller parses it back into (seq, pos).
    mesh.userData.organelleId = "s" + seqIndex + "-bp" + basePairIndex;
    mesh.userData.seqIndex = seqIndex;
    mesh.userData.basePairIndex = basePairIndex;
    mesh.userData.baseLetter = baseLetter;
    mesh.castShadow = false;
    mesh.receiveShadow = false;
    return mesh;
}

/* Build a single helix at the local origin. Returns a Group that the
   caller positions in the world (so multiple helices can be laid out
   side-by-side). All meshes inside get tagged "s{seqIndex}-bp{i}". */
function buildOneHelix(sequence, seqIndex) {
    const group = new THREE.Group();
    if (!sequence || sequence.length === 0) return group;

    const strand0Points = [];
    const strand1Points = [];
    for (let i = 0; i < sequence.length; i++) {
        strand0Points.push(strandPoint(i, 0));
        strand1Points.push(strandPoint(i, 1));
    }

    // Backbone tubes
    if (sequence.length > 1) {
        const curve0 = new THREE.CatmullRomCurve3(strand0Points);
        const curve1 = new THREE.CatmullRomCurve3(strand1Points);
        const segs = Math.max(64, sequence.length * 12);
        const tubeGeom0 = new THREE.TubeGeometry(curve0, segs, BACKBONE_RADIUS, 12, false);
        const tubeGeom1 = new THREE.TubeGeometry(curve1, segs, BACKBONE_RADIUS, 12, false);
        const bbMat = makeStudioMaterial(BACKBONE_COLOR, 1, 0.5, 0.06);
        const tube0 = new THREE.Mesh(tubeGeom0, bbMat);
        const tube1 = new THREE.Mesh(tubeGeom1, bbMat);
        tube0.userData.isBackbone = true;
        tube1.userData.isBackbone = true;
        group.add(tube0, tube1);
    }

    // Base-pair rungs — each one a 3-piece cylinder (A-side / spacer / T-side).
    // Gap positions ('-' or '.') get no rung — the backbones run through
    // the position without a connecting cylinder, leaving a visible break.
    for (let i = 0; i < sequence.length; i++) {
        const letter = sequence[i];
        if (isGap(letter)) continue;
        const complement = COMPLEMENT[letter] || "N";
        const p0 = strand0Points[i];
        const p1 = strand1Points[i];

        const mid = new THREE.Vector3().addVectors(p0, p1).multiplyScalar(0.5);
        const dir = new THREE.Vector3().subVectors(p1, p0);
        const length = dir.length();
        dir.normalize();

        const halfMat0 = makeStudioMaterial(BASE_COLOR[letter] || "#888", 1, 0.55, 0.06);
        const halfGeom0 = new THREE.CylinderGeometry(RUNG_RADIUS, RUNG_RADIUS, length * 0.46, 14);
        const half0 = new THREE.Mesh(halfGeom0, halfMat0);
        half0.position.copy(p0).add(dir.clone().multiplyScalar(length * 0.27));
        half0.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), dir);
        tagMesh(half0, seqIndex, i, letter);
        group.add(half0);

        const spacerGeom = new THREE.CylinderGeometry(RUNG_RADIUS * 0.7, RUNG_RADIUS * 0.7, length * 0.06, 14);
        const spacer = new THREE.Mesh(spacerGeom, makeStudioMaterial(RUNG_GAP_COLOR, 0.85, 0.55, 0.04));
        spacer.position.copy(mid);
        spacer.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), dir);
        tagMesh(spacer, seqIndex, i, letter);
        group.add(spacer);

        const halfMat1 = makeStudioMaterial(BASE_COLOR[complement] || "#888", 1, 0.55, 0.06);
        const halfGeom1 = new THREE.CylinderGeometry(RUNG_RADIUS, RUNG_RADIUS, length * 0.46, 14);
        const half1 = new THREE.Mesh(halfGeom1, halfMat1);
        half1.position.copy(p1).sub(dir.clone().multiplyScalar(length * 0.27));
        half1.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), dir);
        tagMesh(half1, seqIndex, i, letter);
        group.add(half1);
    }

    const totalRise = (sequence.length - 1) * RISE;
    group.position.y = -totalRise / 2;
    group.userData.helixLength = totalRise;
    group.userData.seqIndex = seqIndex;
    return group;
}

/* makeHeaderSprite renders a small "Seq N" label above each helix so
   users can distinguish sequences at a glance. Tagged as label-only
   (no organelleId) so the picker ignores it. */
function makeHeaderSprite(text) {
    const DPR = Math.min(window.devicePixelRatio || 1, 2);
    const W = 144, H = 38;
    const canvas = document.createElement("canvas");
    canvas.width = W * DPR;
    canvas.height = H * DPR;
    const ctx = canvas.getContext("2d");
    ctx.scale(DPR, DPR);
    // Pill background
    ctx.fillStyle = "rgba(20, 18, 14, 0.85)";
    const r = H / 2;
    ctx.beginPath();
    ctx.moveTo(r, 0); ctx.lineTo(W - r, 0);
    ctx.arc(W - r, H / 2, r, -Math.PI / 2, Math.PI / 2);
    ctx.lineTo(r, H);
    ctx.arc(r, H / 2, r, Math.PI / 2, -Math.PI / 2);
    ctx.closePath(); ctx.fill();
    // Text
    ctx.fillStyle = "#fffdf6";
    ctx.font = "700 20px -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', sans-serif";
    ctx.textAlign = "center"; ctx.textBaseline = "middle";
    ctx.fillText(text, W / 2, H / 2 + 1);

    const tex = new THREE.CanvasTexture(canvas);
    tex.colorSpace = THREE.SRGBColorSpace;
    tex.anisotropy = 4;
    const mat = new THREE.SpriteMaterial({
        map: tex, transparent: true, depthWrite: false, depthTest: false
    });
    mat.clippingPlanes = [];
    const sprite = new THREE.Sprite(mat);
    sprite.scale.set(0.55, 0.145, 1);
    sprite.renderOrder = 999;
    sprite.userData.isHeader = true;
    return sprite;
}

/* Build the full scene root containing all sequences side-by-side
   along X, with thin vertical separator lines between adjacent helices
   and a "Seq N" header sprite floating above each one. Returns the
   scene root group and exposes bounds for camera-fit. */
function buildHelixGroup(sequences) {
    const group = new THREE.Group();
    if (!sequences || sequences.length === 0) return group;

    // Horizontal spacing between helix centers. Each helix's diameter
    // is 2*HELIX_RADIUS ≈ 1.9; give a comfy gap so they don't bleed.
    const SPACING = 3.2;

    // Compute total span so we can center the whole arrangement at x=0.
    const totalSpan = (sequences.length - 1) * SPACING;
    const xOffset0 = -totalSpan / 2;

    let maxHelixLength = 0;

    for (let s = 0; s < sequences.length; s++) {
        const sequence = sequences[s];
        if (!sequence || sequence.length === 0) continue;

        const helix = buildOneHelix(sequence, s);
        helix.position.x = xOffset0 + s * SPACING;
        group.add(helix);

        if (helix.userData.helixLength > maxHelixLength) {
            maxHelixLength = helix.userData.helixLength;
        }

        // Header label above the helix top.
        const header = makeHeaderSprite("Seq " + (s + 1) + " · " + sequence.length + " bp");
        // helix is centered vertically (y = -totalRise/2 ... +totalRise/2),
        // so top of strands is at helix.position.y + totalRise/2.
        // We then float the header a bit above that.
        header.position.set(
            xOffset0 + s * SPACING,
            helix.userData.helixLength / 2 + 0.55,
            0
        );
        group.add(header);
    }

    // Separator lines between adjacent helices. A thin vertical bar
    // sitting halfway between helix[i] and helix[i+1], spanning the
    // full vertical extent of the tallest helix.
    if (sequences.length > 1) {
        const sepHeight = Math.max(maxHelixLength + 1.2, 2);
        const sepGeom = new THREE.BoxGeometry(0.02, sepHeight, 0.02);
        for (let s = 0; s < sequences.length - 1; s++) {
            const sepX = xOffset0 + s * SPACING + SPACING / 2;
            const sep = new THREE.Mesh(
                sepGeom.clone(),
                new THREE.MeshBasicMaterial({
                    color: 0x9aa0a6,
                    transparent: true,
                    opacity: 0.35,
                    depthWrite: false
                })
            );
            sep.position.set(sepX, 0, 0);
            sep.userData.isSeparator = true;
            group.add(sep);
        }
    }

    // Expose total bounds so the controller can fit the camera.
    group.userData.totalSpan = totalSpan + 2 * HELIX_RADIUS;
    group.userData.maxHelixLength = maxHelixLength;
    return group;
}

/* ------------------------------------------------------------------ */
/* Build labels group                                                  */
/* ------------------------------------------------------------------ */

/* Labels group — one numbered puck per base pair, across all sequences.
   Matches the helix layout: each helix's labels live in a sub-group
   that's positioned at the same x-offset as the helix itself. */
function buildLabelsGroup(sequences) {
    const labels = new THREE.Group();
    labels.userData.isLabels = true;
    if (!sequences || sequences.length === 0) return labels;

    const SPACING = 3.2;
    const totalSpan = (sequences.length - 1) * SPACING;
    const xOffset0 = -totalSpan / 2;

    for (let s = 0; s < sequences.length; s++) {
        const sequence = sequences[s];
        if (!sequence || sequence.length === 0) continue;

        const helixLabels = new THREE.Group();
        for (let i = 0; i < sequence.length; i++) {
            if (isGap(sequence[i])) continue;  // no label for gap positions
            const p0 = strandPoint(i, 0);
            const p1 = strandPoint(i, 1);
            const mid = new THREE.Vector3().addVectors(p0, p1).multiplyScalar(0.5);
            const out = new THREE.Vector3(mid.x, 0, mid.z).normalize().multiplyScalar(0.3);
            const sprite = makeNumberSprite(i + 1, BASE_COLOR[sequence[i]] || AMBIGUOUS_COLOR);
            sprite.position.copy(mid).add(out);
            sprite.userData.organelleId = "s" + s + "-bp" + i;
            helixLabels.add(sprite);
        }
        const totalRise = (sequence.length - 1) * RISE;
        helixLabels.position.set(xOffset0 + s * SPACING, -totalRise / 2, 0);
        labels.add(helixLabels);
    }
    return labels;
}

/* ------------------------------------------------------------------ */
/* Apply highlight + view mode                                         */
/* ------------------------------------------------------------------ */

function updateMaterials(group, activeKey, viewMode, highlightSet) {
    // highlightSet is a plain object map of compound keys
    // ("s0-bp3" → true) of base pairs the analysis layer wants to
    // emphasise (motif match / mismatch). When non-empty, highlighted
    // base pairs render at full opacity with an emissive halo and the
    // rest are dimmed to ~22% so the matches stand out.
    const hasHighlight = highlightSet && Object.keys(highlightSet).length > 0;

    group.traverse(node => {
        if (!node.isMesh) return;
        const mat = node.material;
        if (!mat || Array.isArray(mat)) return;
        if (!mat.isMeshStandardMaterial) return;
        if (node.userData.isBackbone) return;     // backbones always full
        if (node.userData.isSeparator) return;    // separators always shown

        const id = node.userData.organelleId;
        if (!id) return;

        const active = (activeKey != null && id === activeKey);
        const dimmed = viewMode === "focus" && !active;
        const hidden = viewMode === "hide" && !active;
        const highlighted = hasHighlight && highlightSet[id];
        const dimByHighlight = hasHighlight && !highlighted && !active;

        node.visible = !hidden;
        mat.transparent = mat.opacity < 1 || dimmed || dimByHighlight;
        const baseOpacity = node.userData.baseOpacity != null ? node.userData.baseOpacity : 1;
        if (dimmed) {
            mat.opacity = Math.min(baseOpacity, 0.18);
        } else if (dimByHighlight) {
            mat.opacity = Math.min(baseOpacity, 0.22);
        } else {
            mat.opacity = baseOpacity;
        }
        if (active || highlighted) {
            mat.emissive.set(mat.color);
            mat.emissiveIntensity = active ? 0.55 : 0.40;
        } else {
            mat.emissive.set(0x000000);
            mat.emissiveIntensity = 0;
        }
        mat.needsUpdate = true;
    });
}

/* ------------------------------------------------------------------ */
/* Disposal                                                            */
/* ------------------------------------------------------------------ */

function disposeGroup(group) {
    group.traverse(node => {
        if (node.isMesh) {
            if (node.geometry) node.geometry.dispose();
            const m = node.material;
            if (m) {
                if (Array.isArray(m)) m.forEach(x => x.dispose && x.dispose());
                else if (m.dispose) m.dispose();
            }
        } else if (node.isSprite) {
            if (node.material) {
                if (node.material.map) node.material.map.dispose();
                node.material.dispose();
            }
        }
    });
}

/* ------------------------------------------------------------------ */
/* Main mount                                                          */
/* ------------------------------------------------------------------ */

function mount(canvas, opts) {
    opts = opts || {};
    const onPick = opts.onPick || function () {};

    const renderer = new THREE.WebGLRenderer({
        canvas,
        antialias: true,
        alpha: true,
        premultipliedAlpha: false
    });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    renderer.outputColorSpace = THREE.SRGBColorSpace;

    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(38, 1, 0.1, 100);
    camera.position.set(0, 0.5, 7);

    const controls = new OrbitControls(camera, canvas);
    controls.enableDamping = true;
    controls.dampingFactor = 0.08;
    controls.enablePan = true;
    controls.minDistance = 3.0;
    controls.maxDistance = 14.0;

    // Lighting — same studio feel as cell-atlas
    scene.add(new THREE.AmbientLight(0xffffff, 1.2));
    const hemi = new THREE.HemisphereLight(0xfff8ea, 0xe3ded2, 1.0);
    scene.add(hemi);
    const dir = new THREE.DirectionalLight(0xffffff, 2.2);
    dir.position.set(4.2, 5.2, 5.8);
    scene.add(dir);
    const point = new THREE.PointLight(0xffffff, 0.5);
    point.position.set(-3, -2, 4);
    scene.add(point);

    // Subtle floor blob — provides depth without a hard shadow
    const floorTex = (function () {
        const c = document.createElement("canvas");
        c.width = 256; c.height = 256;
        const ctx = c.getContext("2d");
        const grad = ctx.createRadialGradient(128, 128, 0, 128, 128, 128);
        grad.addColorStop(0,    "rgba(0,0,0,0.42)");
        grad.addColorStop(0.5,  "rgba(0,0,0,0.16)");
        grad.addColorStop(1,    "rgba(0,0,0,0)");
        ctx.fillStyle = grad; ctx.fillRect(0, 0, 256, 256);
        const t = new THREE.CanvasTexture(c);
        t.colorSpace = THREE.SRGBColorSpace;
        return t;
    })();
    const floor = new THREE.Mesh(
        new THREE.PlaneGeometry(8, 8),
        new THREE.MeshBasicMaterial({ map: floorTex, transparent: true, opacity: 0.22, depthWrite: false })
    );
    floor.rotation.x = -Math.PI / 2;
    floor.position.y = -3.0;
    scene.add(floor);

    // Two-level nesting:
    //   floatRoot — handles the subtle drift / bob animation (always on,
    //               independent of auto-rotate so the scene has life even
    //               when the user has rotation off and the helix at rest)
    //   root      — handles the user-controlled auto-rotation
    // The picker raycasts against `root`, so floatRoot's transform doesn't
    // confuse base-pair detection (worldToLocal already accounts for it).
    const floatRoot = new THREE.Group();
    const root = new THREE.Group();
    floatRoot.add(root);
    scene.add(floatRoot);

    const state = {
        sequences: [""],        // array of A/T/G/C strings — one per helix
        activeKey: null,        // e.g. "s0-bp3"
        viewMode: "mesh",
        labelsVisible: false,
        autoRotate: false,
        highlightSet: {}        // map: "s{i}-bp{j}" → true; from motif / mismatch
    };

    let helixGroup = null;
    let labelsGroup = null;

    /* Animation state (transient, kept in the frame loop):
       · unwindT       — 0→1 progress for the helix-unwind reveal on load
       · popKey/popT   — base pair being click-popped (or null) + elapsed time
       · rippleT       — global elapsed clock for the 5'→3' light ripple */
    let unwindT = 1;
    let popKey  = null;
    let popT    = 0;
    let rippleT = 0;
    /* Cache the previously-active key so we can detect click events at the
       scene level (without requiring the page to forward an extra signal). */
    let lastActiveKey = null;

    function rebuild() {
        if (helixGroup) {
            root.remove(helixGroup);
            disposeGroup(helixGroup);
            helixGroup = null;
        }
        if (labelsGroup) {
            root.remove(labelsGroup);
            disposeGroup(labelsGroup);
            labelsGroup = null;
        }
        helixGroup = buildHelixGroup(state.sequences);
        root.add(helixGroup);
        labelsGroup = buildLabelsGroup(state.sequences);
        labelsGroup.visible = !!state.labelsVisible;
        root.add(labelsGroup);
        updateMaterials(helixGroup, state.activeKey, state.viewMode, state.highlightSet);
        // Re-fit camera distance to whatever the new arrangement spans.
        autoFitCamera();
        // Kick off the unwind reveal — helix "grows in" from a collapsed
        // starting pose to its final size + orientation over ~700 ms.
        unwindT = 0;
    }

    function sequencesEqual(a, b) {
        if (!Array.isArray(a) || !Array.isArray(b)) return false;
        if (a.length !== b.length) return false;
        for (let i = 0; i < a.length; i++) if (a[i] !== b[i]) return false;
        return true;
    }

    function update(props) {
        // Legacy single-string `sequence` field is auto-promoted to an
        // array so old callers keep working.
        if (props && typeof props.sequence === "string" && !props.sequences) {
            props = Object.assign({}, props);
            props.sequences = [props.sequence];
            delete props.sequence;
        }
        const next = Object.assign({}, state, props);
        const seqChanged = !sequencesEqual(next.sequences, state.sequences);
        // Detect a *new* active key (user clicked a base pair) — triggers the pop.
        const activeChanged = next.activeKey && next.activeKey !== lastActiveKey;
        Object.assign(state, next);

        if (seqChanged) {
            rebuild();
        } else if (helixGroup) {
            updateMaterials(helixGroup, state.activeKey, state.viewMode, state.highlightSet);
            if (labelsGroup) labelsGroup.visible = !!state.labelsVisible;
        }

        if (activeChanged) {
            popKey = next.activeKey;
            popT = 0;
            // Belt-and-suspenders: force-reset emissive on the meshes that
            // used to be active. updateMaterials should already have done
            // this, but the pulse loop runs once per frame and might have
            // ticked between updateMaterials and the next render — leaving
            // a brief stale glow on the previous selection.
            if (lastActiveKey && helixGroup) {
                helixGroup.traverse(function (n) {
                    if (!n.isMesh || !n.material || !n.material.isMeshStandardMaterial) return;
                    if (n.userData.organelleId !== lastActiveKey) return;
                    n.material.emissive.set(0x000000);
                    n.material.emissiveIntensity = 0;
                });
            }
        }
        lastActiveKey = next.activeKey || null;
    }

    /* Push the camera back to encompass all helices. With N sequences
       side-by-side the total X span grows; we move the camera further
       on Z so they all stay in frame. */
    function autoFitCamera() {
        if (!helixGroup) return;
        const span = helixGroup.userData.totalSpan || (2 * HELIX_RADIUS);
        const height = helixGroup.userData.maxHelixLength || 4;
        // Fit the wider of width / height. Add slack so the helix isn't
        // glued to the edge of the canvas.
        const fitWidth = span * 1.4;
        const fitHeight = height * 1.2;
        const dist = Math.max(7, fitWidth, fitHeight);
        camera.position.set(0, 0.5, dist);
        controls.minDistance = Math.max(3.0, dist * 0.4);
        controls.maxDistance = dist * 2.4;
    }

    function reset() {
        controls.reset();
        autoFitCamera();
        camera.lookAt(0, 0, 0);
    }

    /* screenshot — captures the current scene as a base64 image data URL.
       Accepts optional width/height; when supplied, the renderer is
       temporarily resized so the capture works even when the canvas is
       hidden (e.g. user is on the Linear View tab) AND the output has
       a known print-friendly resolution. Without arguments, captures
       at the current canvas size. */
    function screenshot(mimeType, width, height) {
        if (!width || !height) {
            renderer.render(scene, camera);
            return canvas.toDataURL(mimeType || "image/png");
        }
        // Save current renderer + camera state.
        const savedSize = renderer.getSize(new THREE.Vector2());
        const savedAspect = camera.aspect;
        // Force the requested size for a clean capture regardless of
        // canvas visibility. updateStyle=false → only the drawing
        // buffer is resized, the on-page canvas layout is unchanged.
        renderer.setSize(width, height, false);
        camera.aspect = width / height;
        camera.updateProjectionMatrix();
        renderer.render(scene, camera);
        const url = canvas.toDataURL(mimeType || "image/png");
        // Restore the renderer + camera so the live view isn't disturbed.
        renderer.setSize(savedSize.x, savedSize.y, false);
        camera.aspect = savedAspect;
        camera.updateProjectionMatrix();
        return url;
    }

    function dispose() {
        cancelAnimationFrame(rafId);
        controls.dispose();
        if (helixGroup) { root.remove(helixGroup); disposeGroup(helixGroup); }
        if (labelsGroup) { root.remove(labelsGroup); disposeGroup(labelsGroup); }
        floor.geometry.dispose();
        if (floor.material.map) floor.material.map.dispose();
        floor.material.dispose();
        renderer.dispose();
        window.removeEventListener("resize", onResize);
        if (resizeObserver) resizeObserver.disconnect();
    }

    // Resize / fit
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

    /* ---- Raycaster picker — labels first, then mesh rungs ---- */
    const raycaster = new THREE.Raycaster();
    const pointer = new THREE.Vector2();

    function isPickable(obj) {
        let p = obj;
        while (p && p !== root.parent) {
            if (p.visible === false) return false;
            p = p.parent;
        }
        return true;
    }

    function basePairAtPointer(event) {
        const rect = canvas.getBoundingClientRect();
        if (rect.width === 0 || rect.height === 0) return null;
        pointer.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
        pointer.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
        raycaster.setFromCamera(pointer, camera);
        if (!helixGroup) return null;

        const targets = [helixGroup];
        if (labelsGroup) targets.push(labelsGroup);
        const hits = [];
        targets.forEach(t => { raycaster.intersectObject(t, true, hits); });
        hits.sort(function (a, b) { return a.distance - b.distance; });

        // Sprites first
        for (let i = 0; i < hits.length; i++) {
            const obj = hits[i].object;
            if (!obj.isSprite) continue;
            if (!isPickable(obj)) continue;
            const id = obj.userData && obj.userData.organelleId;
            if (id) return id;
        }
        // Then meshes
        for (let i = 0; i < hits.length; i++) {
            const obj = hits[i].object;
            if (!isPickable(obj)) continue;
            const ud = obj.userData;
            if (ud && ud.organelleId) return ud.organelleId;
        }
        return null;
    }

    canvas.style.cursor = "grab";
    canvas.addEventListener("pointermove", function (e) {
        if (e.buttons !== 0) return;
        canvas.style.cursor = basePairAtPointer(e) ? "pointer" : "grab";
    });
    let pointerDownAt = null;
    canvas.addEventListener("pointerdown", function (e) {
        pointerDownAt = { x: e.clientX, y: e.clientY };
    });
    canvas.addEventListener("pointerup", function (e) {
        const start = pointerDownAt;
        pointerDownAt = null;
        if (!start) return;
        const dx = e.clientX - start.x;
        const dy = e.clientY - start.y;
        if (dx * dx + dy * dy > 25) return;
        const id = basePairAtPointer(e);
        if (id) onPick(id);
    });

    /* ---- Animation loop ---- */
    let rafId = 0;
    let isRunning = true;
    const clock = new THREE.Clock();
    let pulseT = 0;

    // Easing — easeOutCubic. Smooth ramp-up that decelerates near 1.
    function easeOutCubic(t) {
        return 1 - Math.pow(1 - Math.min(1, Math.max(0, t)), 3);
    }

    function frame() {
        if (!isRunning) return;
        rafId = requestAnimationFrame(frame);
        const dt = clock.getDelta();
        const t = clock.elapsedTime;

        // ── Float drift ──────────────────────────────────────────────
        // Always-on ambient motion. Sin/cos amplitudes are tiny so
        // OrbitControls remains the dominant motion source.
        floatRoot.rotation.x = Math.sin(t * 0.9) * 0.04;
        floatRoot.rotation.z = Math.cos(t * 0.7) * 0.03;
        floatRoot.position.y = Math.sin(t * 1.1) * 0.08;

        // ── Helix unwind reveal ──────────────────────────────────────
        // When the sequence rebuilds, unwindT resets to 0. We tween it to 1
        // over ~700ms; while < 1, the helix is rendered shrunken and
        // rotated, "growing in" as the timeline completes.
        if (helixGroup && unwindT < 1) {
            unwindT = Math.min(1, unwindT + dt / 0.7);
            const e = easeOutCubic(unwindT);
            // Y-scale tween: 0.05 (almost-flat ribbon) → 1.0 (full helix)
            helixGroup.scale.y = 0.05 + e * 0.95;
            // X+Z scale tween: 0.7 → 1.0 (so the rungs flare out gently)
            helixGroup.scale.x = helixGroup.scale.z = 0.70 + e * 0.30;
            // Unspin: helix rotates 90° as it grows so it feels like
            // it's untwisting into its final pose.
            helixGroup.rotation.y = (1 - e) * (Math.PI * 0.5);
            // Labels grow with it so they don't pop in early.
            if (labelsGroup) {
                labelsGroup.scale.set(helixGroup.scale.x, helixGroup.scale.y, helixGroup.scale.z);
                labelsGroup.rotation.y = helixGroup.rotation.y;
            }
        } else if (helixGroup && unwindT === 1 && (helixGroup.scale.y !== 1 || helixGroup.rotation.y !== 0)) {
            // Snap to final values once unwind is done.
            helixGroup.scale.set(1, 1, 1);
            helixGroup.rotation.y = 0;
            if (labelsGroup) {
                labelsGroup.scale.set(1, 1, 1);
                labelsGroup.rotation.y = 0;
            }
        }

        // ── Auto-rotate ──────────────────────────────────────────────
        // Skip while unwinding so the user can clearly see the unwind effect.
        if (state.autoRotate && root && unwindT === 1) {
            root.rotation.y += dt * 0.06;
        }

        // ── Active-pair pulse ────────────────────────────────────────
        // Heartbeat emissive intensity on the currently-active base pair
        // so the eye can track it on a still scene.
        if (state.activeKey && helixGroup) {
            pulseT += dt;
            const breath = 0.5 + 0.5 * Math.sin(pulseT * Math.PI * 2 * 0.9);
            helixGroup.traverse(function (node) {
                if (!node.isMesh || !node.material || !node.material.isMeshStandardMaterial) return;
                if (node.userData.organelleId !== state.activeKey) return;
                node.material.emissiveIntensity = 0.40 + breath * 0.40;
            });
        } else {
            pulseT = 0;
        }

        // ── Click-pop on a freshly-activated base pair ───────────────
        // Tween scale from 1 → 1.30 → 1 over 220ms when popKey is set.
        // Layered on top of the static scale so it composes with unwind.
        if (popKey && helixGroup) {
            popT += dt;
            const D = 0.22;
            if (popT >= D) {
                // End of pop — reset scales to 1 and clear the trigger.
                helixGroup.traverse(function (node) {
                    if (!node.isMesh) return;
                    if (node.userData.organelleId !== popKey) return;
                    node.scale.set(1, 1, 1);
                });
                popKey = null;
                popT = 0;
            } else {
                // Triangular pulse: scale up over first half, down over second.
                const half = D / 2;
                const a = popT < half ? popT / half : 1 - (popT - half) / half;
                const s = 1 + 0.30 * a;
                helixGroup.traverse(function (node) {
                    if (!node.isMesh) return;
                    if (node.userData.organelleId !== popKey) return;
                    node.scale.set(s, s, s);
                });
            }
        }

        // ── 5'→3' light ripple ──────────────────────────────────────
        // A subtle additive emissive boost that travels along each helix
        // from base 0 → end every 6 seconds, suggesting direction of
        // reading. Kept low-intensity so it doesn't fight motif or pulse
        // highlights. Skipped during unwind and when a motif/mismatch
        // highlight is active (the highlights need to dominate then).
        if (helixGroup && unwindT === 1 &&
            (!state.highlightSet || Object.keys(state.highlightSet).length === 0)) {
            rippleT = (t / 6) % 1;
            const WINDOW = 0.06;
            helixGroup.traverse(function (node) {
                if (!node.isMesh || !node.material || !node.material.isMeshStandardMaterial) return;
                if (node.userData.isBackbone || node.userData.isSeparator) return;
                const id = node.userData.organelleId;
                if (!id || id === state.activeKey) return; // active gets its own pulse
                const bp = node.userData.basePairIndex;
                if (bp == null) return;
                // Per-sequence ripple: each helix reads independently
                // 5'→3'. Find total length for this sequence.
                const seqIdx = node.userData.seqIndex || 0;
                const seq = state.sequences[seqIdx];
                if (!seq || seq.length === 0) return;
                const pos = bp / Math.max(1, seq.length - 1);
                const d = Math.abs(rippleT - pos);
                if (d < WINDOW) {
                    const w = 1 - d / WINDOW;             // 0..1
                    node.material.emissiveIntensity = w * 0.18;
                    node.material.emissive.set(node.material.color);
                } else if (node.material.emissiveIntensity !== 0) {
                    // Decay back to 0 quickly to avoid stuck glow.
                    node.material.emissiveIntensity = 0;
                    node.material.emissive.set(0x000000);
                }
            });
        }

        controls.update();
        renderer.render(scene, camera);
    }
    frame();

    function onVisibilityChange() {
        if (document.hidden) { isRunning = false; cancelAnimationFrame(rafId); }
        else if (!isRunning) { isRunning = true; clock.getDelta(); frame(); }
    }
    document.addEventListener("visibilitychange", onVisibilityChange);

    const originalDispose = dispose;
    function disposeFull() {
        document.removeEventListener("visibilitychange", onVisibilityChange);
        originalDispose();
    }

    return {
        update: update,
        reset: reset,
        screenshot: screenshot,
        dispose: disposeFull,
        sanitize: function (raw) { return sanitizeSequence(raw, 64); }
    };
}

/* parseSequencesInput — turns the textarea contents into an array of
   sanitized sequences. Splits on newlines, skips empty lines and
   FASTA-style headers (lines starting with '>' or ';'), and caps the
   total set of helices to a reasonable max so a giant paste doesn't
   tank performance. */
function parseSequencesInput(raw, opts) {
    opts = opts || {};
    const maxBpPerSeq = opts.maxBpPerSeq || 64;
    const maxSeqs     = opts.maxSeqs     || 6;
    if (!raw) return [];
    const lines = String(raw).split(/\r?\n/);
    const out = [];
    let buffer = "";
    function flush() {
        if (!buffer) return;
        const clean = sanitizeSequence(buffer, maxBpPerSeq);
        if (clean) out.push(clean);
        buffer = "";
    }
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) { flush(); continue; }
        if (line[0] === ">" || line[0] === ";") { flush(); continue; }
        buffer += line;
    }
    flush();
    return out.slice(0, maxSeqs);
}

window.DnaScene = {
    mount: mount,
    sanitize: function (raw) { return sanitizeSequence(raw, 64); },
    parseSequences: parseSequencesInput,
    sequenceStats: sequenceStats,
    isGap: isGap,
    isCanonical: isCanonical,
    isAmbiguous: isAmbiguous,
    BASE_COLOR: BASE_COLOR,
    COMPLEMENT: COMPLEMENT,
    AMBIGUOUS_COLOR: AMBIGUOUS_COLOR
};
