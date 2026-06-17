/**
 * AI assistant for physics/optical-designer.jsp.
 * Design JSON matches ODModel.Design.toJSON / fromJSON.
 * Requires window.opticalDesignerShell from the page.
 */
import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const CONTEXT_MAP = `NOTE: [CURRENT CONTEXT] is the live lens design. [USER] is the question.\n\n`;

const MATERIALS = [
  'Air', 'Vacuum', 'Perfect Mirror',
  'N-BK7', 'N-SF11', 'N-SF2', 'F2', 'N-FK51A', 'N-LAK9',
  'Fused Silica', 'CaF₂', 'BaF₂', 'MgF₂', 'Sapphire', 'Diamond',
  'PMMA', 'Polycarbonate', 'Water',
];

const PRESETS = [
  'Plano-Convex Singlet', 'Symmetric Biconvex', 'Achromatic Doublet',
  'Cooke Triplet', 'Petzval Lens', 'Plastic Camera Lens',
];

const SYSTEM_PROMPT = `${CONTEXT_MAP}You are an expert optical designer for **8gwifi.org Optical Designer** (sequential ray tracing, Sellmeier materials, spot/ABCD/chromatic analysis).

**Modes**
1. **Build / modify design** — return one \`\`\`json block with the **full** design (not a diff).
2. **Explain / analyze** — answer from [CURRENT CONTEXT]; no JSON unless asked to change the design.

## Design JSON (same as Export)
\`\`\`json
{
  "name": "Short title",
  "description": "One sentence",
  "version": 1,
  "wavelengthCenter": 0.55,
  "wavelengthShort": 0.44,
  "wavelengthLong": 0.62,
  "beamRadius": 10,
  "raysPerBeam": 7,
  "fovAngle": 0,
  "symBeams": false,
  "imageRadius": 21.6,
  "initialMaterial": "Air",
  "autofocus": "paraxial",
  "surfaces": [
    { "radius": 60, "aperture": 14, "thickness": 6, "material": "N-BK7", "conic": 0 },
    { "radius": -48, "aperture": 14, "thickness": 2, "material": "N-SF11", "conic": 0 },
    { "radius": -180, "aperture": 14, "thickness": 40, "material": "Air", "conic": 0 }
  ]
}
\`\`\`

**Surfaces** (ordered left→right, light enters from left):
- \`radius\` mm — positive/negative curvature; \`"Inf"\` or \`"-Inf"\` for flat
- \`aperture\` — semi-diameter mm
- \`thickness\` — mm to **next** surface vertex (last surface = back focal distance / image space)
- \`material\` — medium **after** this surface (use exact names below)
- \`conic\` — conic constant K (0=sphere, -1=parabola)

**Environment**
- Wavelengths in **μm**: center/short/long (typical 0.55 / 0.44 / 0.62)
- \`autofocus\`: \`"off"\` | \`"paraxial"\` | \`"marginal"\`
- \`objectDistance\` optional mm; omit or use Infinity for collimated object
- \`initialMaterial\` usually \`"Air"\`

**Materials**: ${MATERIALS.join(', ')}

**Built-in presets** (compose equivalent surfaces when asked): ${PRESETS.join(', ')}

**Tips**
- Achromatic doublet: crown (N-BK7) + flint (N-SF2 or N-SF11), cemented or air-spaced
- Cooke triplet: positive-negative-positive three-glass layout
- Last surface thickness often sets image distance; use autofocus paraxial when unsure
- Keep apertures consistent within a group; 2–13 surfaces supported

**CRITICAL**
1. Valid \`\`\`json only when generating
2. At least one glass surface for lens designs; bookend with Air
3. Material strings must match the list exactly (including CaF₂ subscript form)`;

const QUICK_ACTIONS = [
  { label: 'Achromat', prompt: 'Achromatic doublet using N-BK7 and N-SF2 with reasonable radii and thicknesses', sendImmediately: true },
  { label: 'Cooke triplet', prompt: 'Cooke triplet lens design with three glass elements', sendImmediately: true },
  { label: 'Plano-convex', prompt: 'Plano-convex singlet focusing collimated light', sendImmediately: true },
  { label: 'Petzval', prompt: 'Petzval lens with two separated achromatic groups', sendImmediately: true },
  { label: 'Reduce chromatic', prompt: 'Suggest changes to reduce chromatic aberration in the current design', sendImmediately: true },
  { label: 'Explain design', prompt: 'Explain this lens design — focal length, groups, and aberrations. No JSON.', sendImmediately: true },
];

function isDesignPayload(o) {
  return Array.isArray(o?.surfaces) && o.surfaces.length > 0
    && o.surfaces.every((s) => s && typeof s.material === 'string');
}

export function createOpticalDesignerAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.opticalDesignerShell;

  const assistant = new VibeCodingAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    billing: {
      enabled: true,
      requireSignIn: opts.billing?.requireSignIn === true,
      ctx,
      userId: userId || '',
      plans: {
        monthly: { name: 'Monthly', priceLabel: '', cadence: 'Billed monthly · cancel anytime' },
        yearly: { name: 'Yearly', priceLabel: '', cadence: 'Billed yearly', badge: 'Best value' },
        features: ['Higher AI limits', 'Pro model tier', 'No rate-limit waiting'],
      },
    },
    toolId: opts.toolId || 'physics/optical-designer',
    title: 'Optical Design AI',
    subtitle: 'Generate lens systems or ask about aberrations and materials.',
    placeholder: 'e.g. "Achromatic doublet f/4" or "Why is RMS spot large?"',
    footerText: 'Apply loads design · Ctrl+Shift+A',
    historyTurns: 6,
    systemPrompt: SYSTEM_PROMPT,
    seedContext: () => {
      const snap = shell()?.getSnapshot?.();
      if (!snap?.designJson) return '(no design loaded)';
      const lines = [`Surfaces: ${snap.surfaceCount || 0}`];
      if (snap.summary) lines.push(snap.summary);
      lines.push('', 'Current design JSON:', snap.designJson);
      return lines.join('\n');
    },
    getQuickActions: () => QUICK_ACTIONS,
    applyActions: [{
      id: 'design',
      order: 1,
      label: 'Apply design',
      extract: applyExtractors.fencedJson(isDesignPayload),
      apply: (payload) => {
        const od = shell();
        if (!od) throw new Error('Optical designer not ready.');
        const result = od.applyDesign(payload);
        if (!result?.applied) throw new Error(result?.error || 'Could not apply design.');
        return result;
      },
    }],
    getApplyLabel: (matched) => {
      const m = matched.find((x) => x.action.id === 'design');
      const n = m?.payload?.name;
      const c = m?.payload?.surfaces?.length || 0;
      return n && c ? `Apply "${n}" (${c} surfaces)` : (c ? `Apply design (${c} surfaces)` : 'Apply design');
    },
  });

  const origOpen = assistant.open.bind(assistant);
  assistant.open = async (prefill, autoSend) => {
    await shell()?.refreshSnapshot?.().catch(() => {});
    return origOpen(prefill, autoSend);
  };
  const origSend = assistant._send.bind(assistant);
  assistant._send = async () => {
    await shell()?.refreshSnapshot?.().catch(() => {});
    return origSend();
  };
  return assistant;
}
