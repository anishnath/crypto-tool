/**
 * AI assistant for physics/ray-optics-simulator.jsp.
 * Scene generation uses JSON compatible with RayUI.importSceneData.
 * Requires window.rayOpticsShell from the page (snapshot + apply).
 */
import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';
import { RAY_OPTICS_CHAT_PROMPT } from '../../../../physics/js/ray-optics-ai-prompt.js';
import {
  isScenePayload,
  normalizeScenePayload,
  summarizeSceneObjects,
} from '../../../../physics/js/ray-optics-ai-engine.js';

const CONTEXT_MAP_NOTE = `NOTE: This tool sends the live canvas as [CURRENT CONTEXT] and the user's message as [USER]. Treat [CURRENT CONTEXT] as [CURRENT SCENE] and [USER] as [QUESTION] in the rules below.\n\n`;

const QUICK_ACTIONS = [
  { label: 'Prism rainbow', prompt: 'Prism rainbow: multiple colored rays through a glass prism with dispersion', sendImmediately: true },
  { label: 'Telescope', prompt: 'Simple refracting telescope with two ideal lenses and parallel beam input', sendImmediately: true },
  { label: 'Convex lens', prompt: 'Parallel beam focused by a converging ideal lens', sendImmediately: true },
  { label: 'TIR demo', prompt: 'Total internal reflection in a glass slab with a single ray at a steep angle', sendImmediately: true },
  { label: 'Beam splitter', prompt: 'Beam splitter with reflected and transmitted paths to mirrors', sendImmediately: true },
  { label: 'Microscope', prompt: 'Compound microscope with two converging lenses and a point source object', sendImmediately: true },
  { label: 'Diffraction grating', prompt: 'Diffraction grating splitting white parallel beam into spectral orders', sendImmediately: true },
  { label: 'Explain scene', prompt: 'Explain how the current optical scene works — no scene JSON changes.', sendImmediately: true },
  { label: 'Why no rays?', prompt: 'Why might rays not appear or behave unexpectedly in this scene?', sendImmediately: true },
];

/**
 * @param {object} opts — aiAssistantBoot fields; uses window.rayOpticsShell
 */
export function createRayOpticsSimulatorAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.rayOpticsShell;

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
        features: [
          'Much higher monthly AI limits',
          'Pro chat model tier',
          'No rate-limit waiting between requests',
        ],
      },
    },
    toolId: opts.toolId || 'physics/ray-optics-simulator',
    title: 'Ray Optics AI',
    subtitle: 'Generate optical scenes, iterate on layouts, or ask about ray behavior.',
    placeholder: 'e.g. "Telescope with two lenses" or "Why is there no spectrum?"',
    footerText: 'Apply loads scene on canvas · Ctrl+Shift+A',
    historyTurns: 6,
    systemPrompt: CONTEXT_MAP_NOTE + RAY_OPTICS_CHAT_PROMPT,
    seedContext: () => {
      const snap = shell()?.getSnapshot?.();
      if (!snap) return '(simulator not ready)';
      const lines = [`Objects: ${snap.objectCount || 0}`];
      if (snap.summary) lines.push(snap.summary);
      if (snap.sceneJson) {
        lines.push('', 'Current scene JSON:', snap.sceneJson);
      } else {
        lines.push('', '(Canvas is empty.)');
      }
      return lines.join('\n');
    },
    getQuickActions: () => QUICK_ACTIONS,
    applyActions: [
      {
        id: 'scene',
        order: 1,
        label: 'Load scene on canvas',
        extract: applyExtractors.fencedJson(isScenePayload),
        apply: (payload) => {
          const ro = shell();
          if (!ro) throw new Error('Ray optics simulator not ready.');
          const result = ro.applyScene(payload);
          if (!result?.applied) throw new Error(result?.error || 'Could not apply scene.');
          return result;
        },
      },
    ],
    getApplyLabel: (matched) => {
      const m = matched.find((x) => x.action.id === 'scene');
      const name = m?.payload?.name;
      const count = m?.payload?.objects?.length || 0;
      if (name && count) return `Load "${name}" (${count} objects)`;
      return count ? `Load scene (${count} objects)` : 'Load scene on canvas';
    },
  });

  const originalOpen = assistant.open.bind(assistant);
  assistant.open = async function open(prefill, autoSend) {
    await shell()?.refreshSnapshot?.().catch(() => {});
    return originalOpen(prefill, autoSend);
  };

  const originalSend = assistant._send.bind(assistant);
  assistant._send = async function wrappedSend() {
    await shell()?.refreshSnapshot?.().catch(() => {});
    return originalSend();
  };

  return assistant;
}

export { normalizeScenePayload, summarizeSceneObjects };
