import {
  fetchRecentTikzGenerations,
  saveTikzGeneration,
  updateTikzGenerationPreview,
  titleFromPrompt,
  uniqueTitleFromPrompt,
  splitStoredTikz,
} from './tikz-generations-client.js';

/** @type {string | null} */
let pendingPreviewGenId = null;

export function clearPendingPreviewGeneration() {
  pendingPreviewGenId = null;
}

function fallbackTitle(source) {
  return source === 'image_convert' ? 'Image to TikZ' : 'TikZ diagram';
}

/**
 * Save TikZ code immediately when the user applies AI output or image conversion.
 * Preview SVG is attached later via {@link onTikzRendered}.
 */
export async function recordAppliedTikzGeneration(ctx, userId, {
  userPrompt = '',
  tikzCode = '',
  source = 'ai_apply',
} = {}) {
  const code = String(tikzCode || '').trim();
  if (!code) return null;

  const title = uniqueTitleFromPrompt(userPrompt, fallbackTitle(source));
  const id = await saveTikzGeneration(ctx, {
    userId,
    source,
    userPrompt,
    title,
    tikzCode: code,
  });
  if (id) pendingPreviewGenId = id;
  return id;
}

/** After TikZJax render, attach SVG thumbnail to the last saved generation. */
export async function onTikzRendered(ctx, userId, previewSvg, reload) {
  const id = pendingPreviewGenId;
  pendingPreviewGenId = null;
  if (id && previewSvg) {
    await updateTikzGenerationPreview(ctx, { userId, id, previewSvg });
  }
  if (typeof reload === 'function') await reload();
}

export function initTikzRecentsPanel({ ctx, userId, gridEl, sectionEl, signedIn = false }) {
  if (!gridEl || !sectionEl) return;

  const load = async () => {
    try {
      const items = await fetchRecentTikzGenerations(ctx, {
        userId,
        mineLimit: 10,
        publicLimit: signedIn ? 20 : 10,
      });
      renderTikzRecents(items, gridEl, sectionEl, signedIn);
    } catch {
      sectionEl.hidden = true;
    }
  };

  const schedule = window.requestIdleCallback
    ? (fn) => window.requestIdleCallback(fn, { timeout: 4000 })
    : (fn) => window.setTimeout(fn, 800);

  schedule(load);
  return { reload: load };
}

function renderTikzRecents(items, gridEl, sectionEl, signedIn) {
  gridEl.innerHTML = '';
  if (!items.length) {
    sectionEl.hidden = true;
    return;
  }
  sectionEl.hidden = false;

  const header = sectionEl.querySelector('.tikz-recents-header');
  if (header) {
    header.textContent = signedIn
      ? 'Recent diagrams — yours first, then community'
      : 'Recent community diagrams — yours appear first when you create one';
  }

  for (const item of items) {
    const card = document.createElement('button');
    card.type = 'button';
    card.className = 'tikz-recent-card' + (item.is_mine ? ' tikz-recent-card-mine' : '');
    card.title = item.title || item.user_prompt || 'Load TikZ';

    const thumb = document.createElement('div');
    thumb.className = 'tikz-recent-thumb';
    if (item.preview_svg) {
      thumb.innerHTML = item.preview_svg;
      const svg = thumb.querySelector('svg');
      if (svg) {
        svg.setAttribute('width', '100%');
        svg.setAttribute('height', '100%');
        svg.removeAttribute('style');
      }
    } else {
      thumb.textContent = 'TikZ';
    }

    const meta = document.createElement('div');
    meta.className = 'tikz-recent-meta';

    const label = document.createElement('div');
    label.className = 'tikz-recent-label';
    label.textContent = item.title || titleFromPrompt(item.user_prompt);

    if (item.author_label) {
      const author = document.createElement('span');
      author.className = 'tikz-recent-author' + (item.is_mine ? ' tikz-recent-author-mine' : '');
      author.textContent = item.author_label;
      meta.appendChild(author);
    }
    meta.appendChild(label);

    card.appendChild(thumb);
    card.appendChild(meta);
    card.addEventListener('click', () => {
      if (typeof window.tikzLoadCode !== 'function' || !item.tikz_code) return;
      clearPendingPreviewGeneration();
      const { preamble, code } = splitStoredTikz(item.tikz_code);
      window.tikzLoadCode(code, preamble);
    });
    gridEl.appendChild(card);
  }
}
