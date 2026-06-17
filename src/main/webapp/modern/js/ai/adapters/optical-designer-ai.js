/**
 * AI assistant for physics/optical-designer.jsp.
 * Supports design JSON and US-patent-style prescription tables.
 */
import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const CONTEXT_MAP = `NOTE: [CURRENT CONTEXT] is the live lens design. [USER] is the question.\n\n`;

const MATERIALS = [
  'Air', 'Vacuum', 'Perfect Mirror',
  'N-BK7', 'N-SF11', 'N-SF2', 'F2', 'N-FK51A', 'N-LAK9',
  'Fused Silica', 'CaF₂', 'BaF₂', 'MgF₂', 'Sapphire', 'Diamond',
  'PMMA', 'Polycarbonate', 'Water',
];

const PATENT_CATALOG = `
| Patent / reference | Elements | Surfaces | Notes |
| US11125971B2 | 6 plastic | 11 | Smartphone wide; aspherics + mid stop |
| US7869142B2 | 4 plastic | 10 | Mobile f≈4.9 mm F/2.8 + IR glass |
| US20140211324 | 7 plastic | 17 | Fast compact f≈4.5 mm F/1.64 |
| COOKE1913 | 3 glass | 7 | Classic photographic Cooke triplet |
Tool command \`/patent US11125971B2\` loads built-in tables instantly (no JSON).`;

const PATENT_RX_PROMPT = `
## US patent / paper prescription tables (complex multi-element designs)

Use this format when the user asks for patent-style, mobile-camera, or multi-element (5–13 surface) designs.
Return a \`\`\`prescription fenced block** (tab-separated), **not** JSON.

\`\`\`prescription
Surface	Label	Type	Radius	Thickness	n	Abbe
S1	L1	Aspheric	8.363	1.219	1.81	40.7
S2		Aspheric	3.299	2.825
ST	ST	Stop	Infinity	2.540
\`\`\`

**Column rules**
- One **row per surface** (patent Table 1 style). Units: **mm**, n at d-line (~0.5876 µm), Abbe = Vd.
- **Radius**: signed curvature; \`Infinity\` / \`Inf\` for flat. Aspheric surfaces: use spherical R from patent (ignore A4/A6… unless Conic K given).
- **Thickness**: axial distance to **next** surface. Negative values appear for aperture/stop offsets — keep them.
- **n, Abbe**: only on the **first surface** of each glass element; blank on air-side partner rows.
- **Stop**: row with ST / Stop / Aperture, radius Infinity, small thickness.
- **Conic K** optional 6th numeric column (K=-1 parabola). Higher-order aspheric terms are **not** imported — note in prose if needed.

**Material mapping**
- Match n+Vd to library: N-BK7 (1.517/64), N-SF11 (1.627/28), N-SF2 (1.647/33), F2 (1.620/36), PMMA (~1.49/57), Polycarbonate (~1.585/30).
- Patent plastics (n≈1.53–1.92): pick closest plastic or glass; tool may register Custom (n=…) if no match.

**Complex design patterns**
- Smartphone 4–6G: alternating positive/negative plastic menisci, stop between groups, IR/cover glass at end (n≈1.517).
- Fast lenses: mix low-V flint (n≈1.63–1.92, Vd<30) with crown (Vd>55).
- Achromat / doublet: crown + flint pair, cemented (zero air gap) or small air gap.
- Cooke / Petzval: 3–6 elements, positive-negative-positive groups.

**Built-in patent tables** (user can type \`/patent ID\`):
${PATENT_CATALOG}`;

const SYSTEM_PROMPT = `${CONTEXT_MAP}You are an expert optical designer for **8gwifi.org Optical Designer** (sequential ray tracing, Sellmeier materials, spot/ABCD/chromatic analysis).

**Modes**
1. **Build / modify** — return **full** design (not a diff):
   - **Simple** (≤4 elements, classroom): \`\`\`json design block (see schema).
   - **Complex / patent / mobile / 5+ surfaces**: \`\`\`prescription tab table (preferred).
2. **Explain / analyze** — plain language from [CURRENT CONTEXT]; no output blocks unless asked.

## Simple design JSON (singlet, doublet, triplet presets)
\`\`\`json
{
  "name": "Achromatic doublet",
  "description": "BK7 + SF11 crown-flint",
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

JSON surfaces: radius mm (number or "Inf"), aperture semi-diameter mm, thickness mm, material after surface, conic K.
Materials: ${MATERIALS.join(', ')}.
Simple presets for JSON only: Plano-Convex Singlet, Symmetric Biconvex, Achromatic Doublet, Cooke Triplet, Petzval Lens, Plastic Camera Lens.

${PATENT_RX_PROMPT}

**CRITICAL**
1. Match output format to complexity — prescription for patent/mobile/multi-element; JSON for simple edits.
2. Valid fenced block only when generating.
3. At least one glass surface; bookend with Air.`;

const QUICK_ACTIONS = [
  { label: 'US11125971B2', prompt: '/patent US11125971B2', sendImmediately: true },
  { label: 'US7869142B2', prompt: '/patent US7869142B2', sendImmediately: true },
  { label: 'US20140211324', prompt: '/patent US20140211324', sendImmediately: true },
  { label: '6G mobile lens', prompt: 'Design a 6-element smartphone camera lens in US patent prescription table format (plastic aspherics, mid stop, ~12 mm semi-aperture). Use ```prescription block.', sendImmediately: true },
  { label: 'Fast f/1.8 lens', prompt: 'Design a fast f/1.8 compact imaging lens (5–7 elements) as a patent-style prescription table with mixed crown/flint plastics.', sendImmediately: true },
  { label: 'Achromat Rx', prompt: 'Achromatic doublet prescription table (crown + flint) with realistic radii from patent literature.', sendImmediately: true },
  { label: 'Cooke triplet', prompt: 'Classic Cooke triplet as prescription table (7 surfaces, stop at center).', sendImmediately: true },
  { label: 'Explain design', prompt: 'Explain this design — focal length, element groups, chromatic and spherical aberration. No JSON or prescription.', sendImmediately: true },
];

function isDesignPayload(o) {
  return Array.isArray(o?.surfaces) && o.surfaces.length > 0
    && o.surfaces.every((s) => s && typeof s.material === 'string');
}

function looksLikePrescription(text) {
  if (!text || text.length < 40) return null;
  const lines = text.trim().split(/\r?\n/).filter((l) => l.trim());
  if (lines.length < 3) return null;
  const header = lines[0].toLowerCase();
  const hasCols = header.includes('radius') || header.includes('thickness')
    || (header.includes('surface') && lines[1].includes('\t'));
  const dataRows = lines.slice(hasCols && header.includes('surface') ? 1 : 0)
    .filter((l) => l.includes('\t') && /[\d\-Inf]/i.test(l));
  return dataRows.length >= 2 ? text.trim() : null;
}

function extractPrescription(text) {
  const fenced = applyExtractors.fencedLang('prescription', 20)(text)
    || applyExtractors.fencedLang('txt', 20)(text);
  if (fenced) return fenced;
  return looksLikePrescription(text);
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
    subtitle: 'Patent prescriptions, multi-element designs, or aberration Q&A.',
    placeholder: 'e.g. "/patent US7869142B2" or "6-element mobile lens prescription"',
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
    applyActions: [
      {
        id: 'prescription',
        order: 0,
        label: 'Load prescription table',
        extract: extractPrescription,
        apply: (text) => {
          const od = shell();
          if (!od) throw new Error('Optical designer not ready.');
          const result = od.applyPrescription(text);
          if (!result?.applied) throw new Error(result?.error || 'Could not apply prescription.');
          return result;
        },
      },
      {
        id: 'design',
        order: 1,
        label: 'Apply design JSON',
        extract: applyExtractors.fencedJson(isDesignPayload),
        apply: (payload) => {
          const od = shell();
          if (!od) throw new Error('Optical designer not ready.');
          const result = od.applyDesign(payload);
          if (!result?.applied) throw new Error(result?.error || 'Could not apply design.');
          return result;
        },
      },
    ],
    getApplyLabel: (matched) => {
      const rx = matched.find((x) => x.action.id === 'prescription');
      if (rx?.payload) {
        const rows = String(rx.payload).trim().split(/\r?\n/).filter((l) => l.includes('\t')).length;
        return rows ? `Load prescription (${rows} rows)` : 'Load prescription table';
      }
      const m = matched.find((x) => x.action.id === 'design');
      const n = m?.payload?.name;
      const c = m?.payload?.surfaces?.length || 0;
      return n && c ? `Apply "${n}" (${c} surfaces)` : (c ? `Apply design (${c} surfaces)` : 'Apply design JSON');
    },
    onSend: async (userText) => {
      const t = userText.trim();
      const patentMatch = t.match(/^\/patent\s+(US[\w]+|COOKE1913|COOKE)\b/i);
      if (patentMatch) {
        const od = shell();
        if (!od) return false;
        const result = od.applyPatentId(patentMatch[1]);
        if (!result?.applied && window.ToolUtils?.showToast) {
          ToolUtils.showToast(result?.error || 'Patent not found.', 4000, 'error');
        }
        return true;
      }
      return false;
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
