/**
 * AI assistant for physics/labs/circuit-simulator.jsp.
 * Circuit generation uses compact netlist lines (parseNetlist / formatNetlist).
 * Requires window.circuitShell from the page (snapshot + apply).
 */
import { VibeCodingAssistant, applyExtractors, extractFencedBlocks } from '../assistant-core.js';
import { CIRCUIT_CHAT_PROMPT } from '../../../../physics/labs/js/circuit/ai-prompt.js';
import { isNetlistLine, netlistTextToElements } from '../../../../physics/labs/js/circuit/circuit-ai-engine.js';

const CONTEXT_MAP_NOTE = `NOTE: This tool sends the live canvas as [CURRENT CONTEXT] and the user's message as [USER]. Treat [CURRENT CONTEXT] as [CURRENT CIRCUIT] and [USER] as [QUESTION] in the rules below.\n\n`;

function extractNetlistPayload(text) {
  const fenced = applyExtractors.fencedLang('netlist', 10)(text);
  if (fenced) return fenced;

  const blocks = extractFencedBlocks(text, { minLength: 10 });
  for (let i = blocks.length - 1; i >= 0; i--) {
    const content = blocks[i].content;
    const firstLine = (content.split('\n').find((l) => l.trim()) || '').trim();
    if (isNetlistLine(firstLine)) return content;
  }

  const trimmed = String(text ?? '').trim();
  if (!trimmed) return null;
  const lines = trimmed.split(/\r?\n/).map((l) => l.replace(/#.*$/, '').trim()).filter(Boolean);
  const netlistLines = lines.filter((l) => isNetlistLine(l) || l.startsWith('error '));
  if (netlistLines.length >= 1 && netlistLines.length >= lines.length * 0.5) {
    return netlistLines.join('\n');
  }
  return null;
}

const QUICK_ACTIONS = [
  { label: 'LED + 330Ω', prompt: 'LED with 330 ohm resistor powered by 5V', sendImmediately: true },
  { label: 'Voltage divider', prompt: 'Voltage divider with 10k and 5k resistors, 9V battery', sendImmediately: true },
  { label: 'RC low-pass', prompt: 'RC low-pass filter, R=10k, C=100nF, AC source at 1kHz', sendImmediately: true },
  { label: 'Op-amp inverter', prompt: 'Inverting op-amp amplifier with gain of -10, 1kHz AC input', sendImmediately: true },
  { label: 'BJT switch', prompt: 'NPN BJT switch driving LED, base through 10k from 5V, Vcc=9V', sendImmediately: true },
  { label: 'Half-wave rectifier', prompt: 'Half-wave rectifier with diode, 100uF smoothing cap, 1k load', sendImmediately: true },
  { label: 'Zener regulator', prompt: 'Zener regulator: 12V input, 5.1V zener, 470 ohm series resistor', sendImmediately: true },
  { label: 'SR latch', prompt: 'SR latch using two cross-coupled NAND gates', sendImmediately: true },
  { label: 'Explain circuit', prompt: 'Explain how the current circuit works — no netlist changes.', sendImmediately: true },
  { label: 'Why no current?', prompt: 'Why might current dots not be animating on this circuit?', sendImmediately: true },
  { label: 'From image', prompt: '/image', sendImmediately: true },
];

/**
 * @param {object} opts — aiAssistantBoot fields; uses window.circuitShell
 */
export function createCircuitSimulatorAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.circuitShell;

  const assistant = new VibeCodingAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    billing: {
      enabled: true,
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
    toolId: opts.toolId || 'physics/labs/circuit-simulator',
    title: 'Circuit AI',
    subtitle: 'Generate circuits, iterate on netlists, or ask about simulation.',
    placeholder: 'e.g. "RC filter 10k 100nF" or "Why is there no current?"',
    footerText: 'Apply loads circuit on canvas · Ctrl+Shift+A',
    historyTurns: 6,
    systemPrompt: CONTEXT_MAP_NOTE + CIRCUIT_CHAT_PROMPT,
    seedContext: () => {
      const snap = shell()?.getSnapshot?.();
      if (!snap?.netlist) return '(empty canvas)';
      const lines = [`Elements: ${snap.elementCount || 0}`];
      if (snap.summary) lines.push(snap.summary);
      lines.push('', snap.netlist.trim());
      return lines.join('\n');
    },
    getQuickActions: () => QUICK_ACTIONS,
    applyActions: [
      {
        id: 'netlist',
        order: 1,
        label: 'Load circuit on canvas',
        extract: extractNetlistPayload,
        apply: (text) => {
          const ckt = shell();
          if (!ckt) throw new Error('Circuit simulator not ready.');
          const result = ckt.applyNetlist(text);
          if (!result?.applied) throw new Error(result?.error || 'Could not apply netlist.');
          return result;
        },
      },
    ],
    getApplyLabel: (matched) => {
      const m = matched.find((x) => x.action.id === 'netlist');
      const count = m?.payload ? netlistTextToElements(m.payload, { autoSourceGround: false }).length : 0;
      return count ? `Load circuit (${count} elements)` : 'Load circuit on canvas';
    },
    onSend: async (userText) => {
      const t = userText.trim().toLowerCase();
      if (t === '/image' || t === 'from image') {
        await shell()?.openFromImage?.();
        return true;
      }
      return false;
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
