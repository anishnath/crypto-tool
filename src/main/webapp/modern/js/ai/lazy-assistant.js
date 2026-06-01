/**
 * Lazy-load ToolAiAssistant adapters on first open (click, shortcut, or checkout return).
 * Prefetches the module on first pointerenter over the trigger button.
 */

const DEFAULT_CHECKOUT_MSG =
  'Payment received — Pro activates shortly after Dodo confirms. Ask AI when ready.';

/**
 * @param {object} opts
 * @param {string} opts.moduleUrl - ES module URL for the tool adapter
 * @param {string} opts.exportName - Factory export (e.g. createPgpAssistant)
 * @param {string} [opts.buttonId] - Trigger button element id
 * @param {object} opts.boot - aiAssistantBoot from ai-assistant-boot.inc.jsp
 * @param {object|(() => object)} [opts.extraOpts] - Extra constructor args (evaluated at first load)
 * @param {(ai: object) => void} [opts.onReady] - Called after mount
 * @param {string|false} [opts.checkoutMessage] - Auto-open after ?checkout=1 (false to disable)
 * @param {boolean} [opts.prefetchOnHover=true]
 */
export function wireLazyAssistant(opts) {
  const {
    moduleUrl,
    exportName,
    buttonId,
    boot,
    extraOpts,
    onReady,
    checkoutMessage = DEFAULT_CHECKOUT_MSG,
    prefetchOnHover = true,
  } = opts;

  let ai = null;
  let ready = null;

  function ensure() {
    if (ai) return Promise.resolve(ai);
    if (!ready) {
      ready = import(moduleUrl).then((mod) => {
        const create = mod[exportName];
        if (typeof create !== 'function') {
          throw new Error(`Lazy assistant: export "${exportName}" not found in ${moduleUrl}`);
        }
        const extras = typeof extraOpts === 'function' ? extraOpts() : (extraOpts || {});
        ai = create({ ...boot, ...extras });
        ai.mount();
        if (typeof onReady === 'function') onReady(ai);
        return ai;
      });
    }
    return ready;
  }

  async function open(prefill = '', autoSend = false) {
    const btn = buttonId ? document.getElementById(buttonId) : null;
    btn?.setAttribute('aria-busy', 'true');
    try {
      (await ensure()).open(prefill, autoSend);
    } finally {
      btn?.removeAttribute('aria-busy');
    }
  }

  const btn = buttonId ? document.getElementById(buttonId) : null;
  btn?.addEventListener('click', () => { open(); });
  if (prefetchOnHover) {
    btn?.addEventListener('pointerenter', () => { ensure().catch(() => {}); }, { once: true });
  }

  document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'A' || e.key === 'a')) {
      e.preventDefault();
      open();
    }
  });

  if (checkoutMessage !== false
    && new URLSearchParams(window.location.search).get('checkout') === '1') {
    const u = new URL(window.location.href);
    u.searchParams.delete('checkout');
    window.history.replaceState({}, '', u.pathname + u.search + u.hash);
    open(checkoutMessage, false);
  }

  return { ensure, open, getInstance: () => ai };
}
