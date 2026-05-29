import { ToolAiAssistant } from '../assistant-core.js';

/**
 * Minimal adapter for tool pages that only need chat + optional apply hooks.
 * Pair with {@code ai-assistant-boot.inc.jsp} on the JSP side.
 */
export function createGenericToolAssistant(opts) {
  const {
    systemPrompt,
    seedContext,
    title = 'AI Assistant',
    subtitle = '',
    placeholder = 'Ask anything about this tool…',
    billing,
    ...rest
  } = opts;

  const billingConfig = billing === false
    ? null
    : {
      enabled: true,
      ctx: rest.ctx || '',
      userId: rest.userId || '',
      ...(billing && typeof billing === 'object' ? billing : {}),
    };

  return new ToolAiAssistant({
    title,
    subtitle,
    placeholder,
    systemPrompt: (systemPrompt || 'You are a helpful assistant for this tool.').trim(),
    seedContext: typeof seedContext === 'function' ? seedContext : () => '',
    billing: billingConfig,
    ...rest,
  });
}
