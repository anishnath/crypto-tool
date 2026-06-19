/**
 * AI Cubing Coach for math/rubik-nxn-solver.jsp.
 * Teaching only — applies named algorithm demos via WCA blocks.
 * Requires window.rubikShell from bootstrap().
 */
import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';
import { RUBIK_NXN_COACH_PROMPT } from '../../../../js/rubiks-nxn/rubik-nxn-ai-prompt.js';

const CONTEXT_MAP_NOTE = `NOTE: [CURRENT CONTEXT] is the live simulator state; [USER] is the learner's question. Treat them per the rules below.\n\n`;

const MOVE_LIKE = /^[\sURFDLBEMESxyzlrudfbw0-9'2]+$/i;

function extractWcaMoves(text) {
  for (const lang of ['wca', 'moves', 'notation', 'scramble']) {
    const block = applyExtractors.fencedLang(lang, 2)(text);
    if (block) return block.trim();
  }
  const fallback = applyExtractors.fencedCode([], {
    minLength: 2,
    fallbackTest: (c) => MOVE_LIKE.test(c.trim()) && /[URFDLB]/i.test(c),
  })(text);
  return fallback?.trim() || null;
}

const QUICK_ACTIONS = [
  { label: 'Explain notation', prompt: 'Explain WCA notation for my current cube size — outer, wide, and inner-slice turns with examples. No solve.', sendImmediately: true },
  { label: 'CFOP overview', prompt: 'Give a concise CFOP overview (Cross, F2L, OLL, PLL) for 3×3 with learning order tips. No solve.', sendImmediately: true },
  { label: 'Demo Sune', prompt: 'Explain what the Sune algorithm does, then demo it on a solved 3×3 in a wca block.', sendImmediately: true },
  { label: 'Demo T-Perm', prompt: 'Explain the T-Perm (PLL) and demo it on a solved 3×3 in a wca block.', sendImmediately: true },
  { label: '4×4 parity', prompt: 'Explain OLL and PLL parity on 4×4 — when they happen and how cubers handle them. No solve for my cube.', sendImmediately: true },
  { label: 'Big-cube reduction', prompt: 'Explain the reduction method for my current cube size: centres, edges, then 3×3 finish. No solve.', sendImmediately: true },
  { label: 'Practice drill', prompt: 'Suggest a short practice drill (≤15 moves) suited to my cube size. Include one wca demo block if helpful.', sendImmediately: true },
  { label: 'Speedcubing tips', prompt: 'Give 3 practical speedcubing tips for my level based on my cube size — lookahead, finger tricks, inspection. No solve.', sendImmediately: true },
];

/**
 * @param {object} opts — aiAssistantBoot fields; uses window.rubikShell
 */
export function createRubikNxnAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.rubikShell;

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
    toolId: opts.toolId || 'math/rubik-nxn',
    title: 'Cubing Coach',
    subtitle: 'Notation, methods, and algorithm demos — never solves your scramble.',
    placeholder: 'e.g. "Explain Rw on 4×4" or "Demo Sune on 3×3"',
    footerText: 'Apply runs demo moves on the 3D cube · Ctrl+Shift+A',
    historyTurns: 6,
    systemPrompt: CONTEXT_MAP_NOTE + RUBIK_NXN_COACH_PROMPT,
    seedContext: () => {
      const snap = shell()?.getCoachContext?.();
      if (!snap) return '(simulator not ready)';
      const lines = [
        `Cube size: ${snap.sizeLabel}`,
        `Status: ${snap.status || 'unknown'}`,
      ];
      if (snap.banner) lines.push(`Banner: ${snap.banner}`);
      if (snap.scrambleInput) lines.push(`Scramble input (do NOT solve): ${snap.scrambleInput}`);
      lines.push(`Edit mode: ${snap.editMode ? 'on' : 'off'}`);
      if (snap.hasSolution) {
        lines.push(`Solution loaded: ${snap.solutionMoveCount} moves (playback ${snap.playbackStep}/${snap.playbackTotal})`);
      }
      if (snap.activeGuideTab) lines.push(`Cubing guide tab: ${snap.activeGuideTab}`);
      return lines.join('\n');
    },
    getQuickActions: () => QUICK_ACTIONS,
    applyActions: [
      {
        id: 'wca-demo',
        order: 1,
        label: 'Play demo on cube',
        extract: extractWcaMoves,
        apply: async (payload) => {
          const rk = shell();
          if (!rk) throw new Error('Rubik simulator not ready.');
          const result = await rk.applyTeachingMoves(payload, { fromSolved: true, maxMoves: 50 });
          if (!result?.applied) throw new Error('Could not apply demo moves.');
          return result;
        },
      },
    ],
    getApplyLabel: (matched) => {
      const m = matched.find((x) => x.action.id === 'wca-demo');
      const raw = typeof m?.payload === 'string' ? m.payload : '';
      const count = raw.trim() ? raw.trim().split(/\s+/).length : 0;
      return count ? `Play demo (${count} moves)` : 'Play demo on cube';
    },
  });

  return assistant;
}
