/**
 * Ray Optics Simulator — AI scene payload validation and helpers.
 */

export const SCENE_OBJECT_TYPES = [
  'PointSource', 'ParallelBeam', 'SingleRay',
  'FlatMirror', 'CurvedMirror', 'ParabolicMirror', 'IdealMirror',
  'GlassSlab', 'Prism', 'CircleLens', 'SphericalLens', 'IdealLens',
  'BeamSplitter', 'DiffractionGrating', 'GrinLens',
  'Blocker', 'Aperture', 'CircleBlocker', 'Observer',
];

const TYPE_SET = new Set(SCENE_OBJECT_TYPES);
const LIGHT_TYPES = new Set(['PointSource', 'ParallelBeam', 'SingleRay']);

export function summarizeSceneObjects(objects) {
  const counts = {};
  for (const o of objects || []) {
    if (!o?.type) continue;
    counts[o.type] = (counts[o.type] || 0) + 1;
  }
  const parts = Object.keys(counts).sort().map((t) => `${counts[t]}× ${t}`);
  return parts.length ? parts.join(', ') : '';
}

export function validateScenePayload(data) {
  const errors = [];
  const warnings = [];
  if (!data || typeof data !== 'object') {
    return { valid: false, errors: ['Scene payload must be a JSON object.'], warnings };
  }
  const objects = data.objects;
  if (!Array.isArray(objects) || !objects.length) {
    errors.push('Scene must include a non-empty "objects" array.');
    return { valid: false, errors, warnings };
  }

  let hasLight = false;
  for (let i = 0; i < objects.length; i++) {
    const o = objects[i];
    if (!o || typeof o !== 'object') {
      errors.push(`Object ${i + 1} is invalid.`);
      continue;
    }
    if (!TYPE_SET.has(o.type)) {
      errors.push(`Unknown object type "${o.type}" at index ${i}.`);
    }
    if (typeof o.x !== 'number' || typeof o.y !== 'number') {
      errors.push(`Object ${i + 1} (${o.type || '?'}) needs numeric x and y.`);
    }
    if (LIGHT_TYPES.has(o.type)) hasLight = true;
  }

  if (!hasLight) {
    warnings.push('Scene has no light source — add PointSource, ParallelBeam, or SingleRay.');
  }

  return { valid: errors.length === 0, errors, warnings, hasLight };
}

/** Accept full export JSON or compact AI payload. */
export function normalizeScenePayload(raw) {
  const data = typeof raw === 'string' ? JSON.parse(raw) : raw;
  const objects = Array.isArray(data?.objects) ? data.objects : null;
  if (!objects) throw new Error('Missing objects array.');

  const normalized = {
    scene: {
      rayMode: data.scene?.rayMode || data.rayMode || 'rays',
      fresnelEnabled: !!(data.scene?.fresnelEnabled ?? data.fresnelEnabled),
      backgroundN: Number(data.scene?.backgroundN ?? data.backgroundN ?? 1) || 1,
      showGrid: !!(data.scene?.showGrid ?? data.showGrid),
      gridSize: Number(data.scene?.gridSize ?? data.gridSize ?? 50) || 50,
    },
    objects: objects.map((o) => {
      const copy = { ...o };
      delete copy.id;
      return copy;
    }),
  };

  const validation = validateScenePayload(normalized);
  if (!validation.valid) {
    throw new Error(validation.errors[0] || 'Invalid scene.');
  }
  return { payload: normalized, validation };
}

export function isScenePayload(obj) {
  return !!(obj && Array.isArray(obj.objects) && obj.objects.length > 0);
}
