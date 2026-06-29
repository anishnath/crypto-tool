/**
 * NCERT exam book AI — tutor for question/chapter pages (classes 9–12).
 * Shell (window.ncertShell), VCA adapter, prompt, and open-panel bridge.
 */
import { ToolAiAssistant } from '../assistant-core.js';
import { typesetKatexWhenReady } from '../../katex-render.js';

// ─── Shell ───────────────────────────────────────────────────────────────────

function normalizeContext(raw) {
  if (!raw || typeof raw !== 'object') return { pageType: 'unknown' };

  const q = raw.question;
  const ctx = {
    pageType: raw.pageType || 'unknown',
    bookClass: raw.bookClass || '',
    bookPart: raw.bookPart || '',
    subjectLabel: raw.subjectLabel || '',
    chapterNum: raw.chapterNum || '',
    chapterName: raw.chapterName || '',
    questionCount: raw.questionCount || 0,
    exercise: raw.exercise || '',
    questionNumber: raw.questionNumber || '',
    marks: raw.marks ?? '',
    difficulty: raw.difficulty ?? '',
    type: raw.type || '',
    questionPlain: raw.questionPlain || '',
    questionLatex: raw.questionLatex || '',
    hint: raw.hint || '',
    solutionSteps: raw.solutionSteps || [],
    answerPlain: raw.answerPlain || '',
    answerLatex: raw.answerLatex || '',
    physicalQuantities: raw.physicalQuantities || null,
  };

  if (q && typeof q === 'object') {
    ctx.exercise = ctx.exercise || q.exercise || '';
    ctx.questionNumber = ctx.questionNumber || q.question_number || '';
    ctx.marks = ctx.marks !== '' ? ctx.marks : (q.marks ?? '');
    ctx.difficulty = ctx.difficulty !== '' ? ctx.difficulty : (q.difficulty ?? '');
    ctx.type = ctx.type || q.type || '';
    ctx.questionPlain = ctx.questionPlain || q.question_plain || '';
    ctx.questionLatex = ctx.questionLatex || q.question_latex || '';
    ctx.hint = ctx.hint || q.hint || '';
    ctx.solutionSteps = ctx.solutionSteps.length ? ctx.solutionSteps : (q.solution_steps || []);
    ctx.answerPlain = ctx.answerPlain || q.correct_answer_plain || '';
    ctx.answerLatex = ctx.answerLatex || q.correct_answer_latex || '';
    ctx.physicalQuantities = ctx.physicalQuantities || q.physical_quantities || null;
  }

  return ctx;
}

function ensureNcertShell() {
  if (window.ncertShell) {
    if (window.ncertPageContext) {
      window.ncertShell.setContext(window.ncertPageContext);
    }
    return;
  }

  let pageContext = { pageType: 'unknown' };

  window.ncertShell = {
    setContext(ctx) {
      pageContext = normalizeContext(ctx);
      if (ctx && typeof ctx === 'object') {
        window.ncertPageContext = ctx;
      }
    },
    getSnapshot() {
      return { ...pageContext };
    },
  };

  document.addEventListener('ncert:context-ready', (e) => {
    window.ncertShell?.setContext?.(e.detail);
  });

  if (window.ncertPageContext) {
    pageContext = normalizeContext(window.ncertPageContext);
  }
}

ensureNcertShell();

// ─── Prompt ──────────────────────────────────────────────────────────────────

function buildNcertPrompt(subjectLabel) {
  const subj = subjectLabel || 'NCERT';
  return `You are a **patient CBSE/NCERT tutor** for **8gwifi.org NCERT Solutions** (${subj}, Classes 9–12).

Use [CURRENT CONTEXT] for the live page: class, subject, chapter, exercise, question text, hint, and official solution metadata when on a question page.

**Tutor modes**
1. **Don't get the question** — restate what the problem asks in plain language: given info, what to find, key terms/notation. **No solution, no hints toward the answer.**
2. **Explain step** — walk through the first key step or idea to start; tie to CBSE notation and units. **Not** the full solution.
3. **Similar question** — one short practice problem on the same concept with 2–3 hints max. **No** full worked solution.
4. **Exam tip** — CBSE marking scheme, what to show for partial marks, units/format checks.
5. **Chapter guide** (chapter listing pages) — study plan: key topics, exercise order, revision tips.
6. **Q&A generator** (chapter pages) — 4–5 original NCERT-style practice questions with answers after \`---\` under **Answers**.

\`\`\`
**Q1** (2 marks · Easy)
<question text — use LaTeX for maths>

**Q2** (3 marks · Medium)
...

---
**Answers**
**A1:** <concise answer or key steps>
**A2:** ...
\`\`\`

Rules for Q&A generator:
- Generate **3–5 questions** unless the user asks for a different count.
- Vary difficulty (Easy / Medium / Hard) and question types (short answer, numerical, proof, MCQ if asked).
- Questions must be **original** — same topic and syllabus, different numbers/scenarios than the current page question.
- Put all answers **after** a \`---\` separator under **Answers** so students can attempt first.
- For MCQ mode: 4 options (A–D), mark correct option in the answer section with a one-line explanation.

**Do not**
- Give solutions or answer hints when the student asked **Don't get the question** — only clarify what is being asked.
- Dump the full step-by-step solution when the student asked for **similar question** (unless they explicitly want the full solution).
- Invent a different final answer than the official one when explaining — use context as ground truth.
- Tell students to buy books or leave the site — they are already on the solution page.
- Use Apply / code blocks — there is no editor on this page. Answer in clear prose and LaTeX where helpful.
- **Math (KaTeX):** whenever formulas appear, use **only** \`$...$\` for inline math and \`$$...$$\` for display equations on their own line. Do **not** use \`\\(...\\)\`, \`\\[...\\]\`, or markdown code backticks around math. Keep LaTeX KaTeX-safe (standard CBSE notation: \\frac, \\sqrt, sets, relations).`;
}

// ─── Context formatting ─────────────────────────────────────────────────────

function difficultyLabel(d) {
  const n = Number(d);
  if (Number.isNaN(n)) return '';
  if (n < 0.4) return 'Easy';
  if (n < 0.7) return 'Medium';
  return 'Hard';
}

function formatSeedContext(snap) {
  if (!snap || snap.pageType === 'unknown') {
    return '(Page still loading — ask about NCERT/CBSE concepts for this chapter.)';
  }

  const lines = [
    `Class: ${snap.bookClass || '?'}`,
    snap.subjectLabel ? `Subject: ${snap.subjectLabel}` : null,
    snap.bookPart ? `Book part: ${snap.bookPart}` : null,
    snap.chapterNum ? `Chapter ${snap.chapterNum}: ${snap.chapterName || ''}` : snap.chapterName || null,
  ].filter(Boolean);

  if (snap.pageType === 'chapter') {
    lines.push('', `Chapter listing (${snap.questionCount || '?'} questions)`);
    lines.push('The learner sees all exercises and questions for this chapter.');
    return lines.join('\n');
  }

  if (snap.pageType === 'question') {
    lines.push(
      '',
      `Exercise: ${snap.exercise || '?'}`,
      `Question: ${snap.questionNumber || '?'}`,
      snap.type ? `Type: ${snap.type}` : null,
      snap.marks !== '' && snap.marks != null ? `Marks: ${snap.marks}` : null,
      snap.difficulty !== '' && snap.difficulty != null ? `Difficulty: ${difficultyLabel(snap.difficulty)}` : null,
    );
    lines.push('', 'Question text:', (snap.questionPlain || snap.questionLatex || '').slice(0, 4000));

    if (snap.hint) lines.push('', 'Built-in hint on page:', String(snap.hint).slice(0, 1500));

    if (snap.physicalQuantities) {
      const pq = snap.physicalQuantities;
      lines.push('', 'Physical quantities (given / to find / formulas):');
      if (pq.given?.length) lines.push('Given:', ...pq.given.map((g) => `- ${g}`));
      if (pq.to_find?.length) lines.push('To find:', ...pq.to_find.map((t) => `- ${t}`));
      if (pq.formulas_used?.length) lines.push('Formulas:', ...pq.formulas_used.map((f) => `- ${f}`));
    }

    lines.push('', '[Official solution on page — use for accuracy; do not repeat verbatim unless explaining.]');
    if (snap.solutionSteps?.length) {
      lines.push(`Solution steps (${snap.solutionSteps.length}):`);
      snap.solutionSteps.slice(0, 12).forEach((step, i) => {
        lines.push(`  ${i + 1}. ${String(step).slice(0, 800)}`);
      });
    }
    const ans = snap.answerPlain || snap.answerLatex;
    if (ans) lines.push('', 'Final answer:', String(ans).slice(0, 500));
  }

  return lines.join('\n');
}

function currentSnapshot() {
  const snap = window.ncertShell?.getSnapshot?.();
  if (snap?.pageType && snap.pageType !== 'unknown') return snap;
  if (window.ncertPageContext) return normalizeContext(window.ncertPageContext);
  return snap;
}

function buildQuickActions(snap) {
  const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });

  if (snap?.pageType === 'chapter') {
    return [
      chip('Study plan', 'Give a short study plan for this chapter — key topics, which exercises to try first, and 3 revision tips. Prose only.'),
      chip('Practice Q&A', 'Generate 4 original NCERT/CBSE-style practice questions for this chapter (mixed difficulty and marks). Put all answers after --- under **Answers**.'),
      chip('Exam focus', 'What CBSE board exam topics from this chapter matter most? Bullet the high-yield concepts only.'),
    ];
  }

  if (snap?.pageType === 'question') {
    return [
      chip("Don't get it", "I don't understand what this question is asking. Explain it in plain language: what is given, what must be found, and any key terms or notation. Do not solve it or give the answer."),
      chip('Explain step', 'Explain the first key step or idea to start this problem. Do not give the complete solution.'),
      chip('Similar question', 'Give one similar practice question with 2–3 hints — no full worked solution.'),
      chip('Exam tip', 'CBSE exam tip for this type of question: marking scheme, what to show for partial marks, and units/format checks.'),
    ];
  }

  return [
    chip('Explain topic', 'Explain the main concept for this NCERT chapter in simple terms.'),
  ];
}

/** Typeset LaTeX in an assistant bubble via KaTeX (shared katex-render.js). */
function typesetNcertMath(body) {
  void typesetKatexWhenReady(body);
}

// ─── Adapter ─────────────────────────────────────────────────────────────────

/**
 * @param {object} opts — aiAssistantBoot + subjectLabel
 */
export function createNcertAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.ncertShell;
  const subjectLabel = opts.subjectLabel || 'NCERT';

  return new ToolAiAssistant({
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
        features: ['Much higher monthly AI limits', 'Pro chat model tier', 'No rate-limit waiting between requests'],
      },
    },
    floatingCorner: 'right',
    toolId: opts.toolId || 'exams/ncert',
    title: 'NCERT AI',
    subtitle: 'Understand · explain · practice · exam tips',
    placeholder: 'Ask about this question, or tap a chip below…',
    footerText: 'Ctrl+Shift+A · NCERT tutor',
    historyTurns: 8,
    contextValidator: false,
    systemPrompt: buildNcertPrompt(subjectLabel),
    seedContext: () => formatSeedContext(currentSnapshot()),
    getQuickActions: () => buildQuickActions(currentSnapshot()),
    onAssistantRender: (body) => typesetNcertMath(body),
  });
}

// ─── Open panel ──────────────────────────────────────────────────────────────

function warnToast(msg) {
  if (typeof window.showToast === 'function') window.showToast(msg, 'warning');
}

/**
 * @param {{ open: Function }} assistantApi
 * @param {object} boot
 */
export function installNcertOpenAI(assistantApi, boot) {
  window.ncertOpenAI = async function ncertOpenAI(prefill, autoSend) {
    if (window.ncertPageContext && window.ncertShell?.setContext) {
      window.ncertShell.setContext(window.ncertPageContext);
    }
    if (boot?.billing?.requireSignIn && !(boot.userId || '')) {
      warnToast('Sign in to use AI');
    }
    await assistantApi.open(prefill || '', autoSend === true);
  };
}

/** Publish page context from inline loaders (available before module loads). */
export function emitNcertContext(detail) {
  window.ncertPageContext = detail || {};
  document.dispatchEvent(new CustomEvent('ncert:context-ready', { detail: window.ncertPageContext }));
}
