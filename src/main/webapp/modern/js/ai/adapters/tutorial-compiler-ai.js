/**
 * Tutorial compiler AI — single module for tutorial-compiler.jsp.
 * Shell (window.tutorialShell), VCA adapter, prompt, and open-panel bridge.
 */
import { VibeCodingAssistant, applyExtractors, extractFencedBlocks } from '../assistant-core.js';

// ─── Shell ───────────────────────────────────────────────────────────────────

function ensureTutorialShell() {
  if (window.tutorialShell) return;

  let activeEditorId = null;

  function editor(id) {
    return window.codeMirrorEditors && window.codeMirrorEditors[id];
  }

  function container(id) {
    return document.getElementById(`${id}-container`);
  }

  function resolveId(id) {
    return id || activeEditorId;
  }

  function readRunMeta(id) {
    const c = container(id);
    if (!c) {
      return { stdout: '', stderr: '', exitCode: '', error: '', isError: false, hasRun: false };
    }
    return {
      stdout: c.dataset.lastStdout || '',
      stderr: c.dataset.lastStderr || '',
      exitCode: c.dataset.lastExitCode || '',
      error: c.dataset.lastError || '',
      isError: c.dataset.lastIsError === '1',
      hasRun: c.dataset.hasRun === '1',
    };
  }

  window.tutorialShell = {
    setActiveEditor(id) {
      if (id) activeEditorId = id;
    },
    getActiveEditorId() {
      return activeEditorId;
    },
    getSnapshot(id) {
      const eid = resolveId(id);
      if (!eid) return null;

      const cm = editor(eid);
      const c = container(eid);
      const lang = c ? (c.dataset.language || 'python') : 'python';
      const inputEl = document.getElementById(`${eid}-input`);
      const run = readRunMeta(eid);
      const selection = cm ? cm.getSelection().trim() : '';

      let output = run.stdout;
      if (run.stderr) output = output ? `${output}\n${run.stderr}` : run.stderr;
      if (run.error) output = output ? `${output}\nError: ${run.error}` : `Error: ${run.error}`;

      return {
        editorId: eid,
        language: lang,
        code: cm ? cm.getValue() : '',
        selection,
        stdin: inputEl ? inputEl.value : '',
        stdout: run.stdout,
        stderr: run.stderr,
        exitCode: run.exitCode,
        error: run.error,
        output,
        outputIsError: run.isError,
        hasRun: run.hasRun,
      };
    },
    applyCode(content, id) {
      const eid = resolveId(id);
      const cm = editor(eid);
      if (!cm) return { applied: false, error: 'Editor not ready' };

      const code = String(content || '').trim();
      if (!code) return { applied: false, error: 'Empty code' };

      cm.setValue(code);
      cm.focus();
      return { applied: true, editorId: eid };
    },
  };
}

ensureTutorialShell();

// ─── Prompt ──────────────────────────────────────────────────────────────────

function buildTutorialCompilerPrompt(track, lesson) {
  let trackNote = 'interactive coding tutorials with runnable examples.';
  if (track === 'dsa') {
    trackNote = 'data structures & algorithms tutorials (Python examples). Focus on correctness, complexity, and pedagogy.';
  } else if (track === 'php-functions') {
    trackNote = 'PHP standard-library function reference with runnable examples.';
  } else if (track === 'bash') {
    trackNote = 'Bash/shell scripting tutorials.';
  }

  const lessonLine = lesson
    ? `\nThe learner is on lesson **${lesson}** in the **${track}** track. Tie explanations to that topic when relevant.`
    : '';

  return `You are a **patient coding tutor** for **8gwifi.org Tutorials** (${trackNote}).

Use [CURRENT CONTEXT] as the live lesson editor: track, lesson, language, code, stdin, run output, and selection.${lessonLine}

**How Apply works**
- **Apply to editor** replaces the **entire code editor** with your fenced block.
- Return **complete runnable source** only for **Fix** or **Challenge** (starter code) — not for hints, quizzes, or debug steps.
- For explain, hint, debug-steps, quiz, trace, complexity, or what's-next: answer in **prose** (tiny snippets OK, no full program replace).

**Language rules**
- Match **Language** in [CURRENT CONTEXT].
- **Java**: public class \`Main\` with \`public static void main\`.
- **Go**: \`package main\` + \`func main()\`.
- **Rust**: \`fn main()\` unless the lesson uses modules.
- **Bash**: mind quoting and \`[[\`; shebang when appropriate.
- **Lua**: 1-based indexing.
- **PHP**: mind \`<?php\` when starter code uses it.
- **Python / DSA**: idiomatic Python 3; mention complexity when teaching algorithms.

**Tutor modes**
1. **Explain** — what the code does, or why a run failed. Be concise (2–5 short paragraphs).
2. **Fix** — read stderr/output; return one corrected \`\`\`<language> block with the full fixed program.
3. **Debug steps** — teach *how* to find the bug (checklist/strategy). **No full fix** unless they ask separately.
4. **Hint only** — nudge toward the answer. **No complete solution**, no full corrected program.
5. **Trace it** — step through execution (line-by-line or sample values). Prose only unless a tiny illustrative snippet helps.
6. **Challenge** — one short exercise + starter code; **2–3 hints** starting with \`Hint:\`. **No full solution.**
7. **Quiz me** — 2–3 comprehension questions with answers hidden until they try (or put answers at the end briefly).
8. **Explain code** — walk through structure and idioms.
9. **Complexity / edge cases** (DSA) — time/space complexity or common edge inputs, tied to the code in context.
10. **What's next?** — suggest the next topic in this track after the current lesson.

**Do not**
- Tell learners to install tools locally — they run code in the browser editor.
- Give full solutions for **Hint only**, **Challenge**, or **Quiz me** when those modes were requested.
- Refuse to help with tutorial exercises — guide them to learn.`;
}

// ─── Code extraction ─────────────────────────────────────────────────────────

const CODE_LANGS = [
  'python', 'py', 'java', 'go', 'golang', 'cpp', 'c++', 'cxx', 'c', 'rust', 'rs',
  'ruby', 'rb', 'javascript', 'js', 'nodejs', 'typescript', 'ts', 'php', 'kotlin',
  'swift', 'scala', 'bash', 'shell', 'sh', 'lua',
];

const LANG_CANON = {
  py: 'python', js: 'javascript', nodejs: 'javascript', ts: 'typescript',
  golang: 'go', 'c++': 'cpp', cxx: 'cpp', rs: 'rust', rb: 'ruby', sh: 'bash', shell: 'bash',
};

function canonLang(lang) {
  const k = String(lang || '').trim().toLowerCase();
  return k ? (LANG_CANON[k] || k) : '';
}

function fenceLangsFor(lang) {
  const c = canonLang(lang);
  if (c === 'bash') return ['bash', 'shell', 'sh'];
  if (c === 'cpp') return ['cpp', 'c++', 'cxx'];
  if (c === 'javascript') return ['javascript', 'js', 'nodejs'];
  if (c === 'typescript') return ['typescript', 'ts'];
  if (c === 'go') return ['go', 'golang'];
  if (c === 'rust') return ['rust', 'rs'];
  if (c === 'ruby') return ['ruby', 'rb'];
  return [c];
}

function extractEditorCode(text, preferredLang) {
  const pref = canonLang(preferredLang);
  const langs = [...new Set([...fenceLangsFor(pref), ...CODE_LANGS])];
  const blocks = extractFencedBlocks(text, { langs, minLength: 4 });
  if (blocks.length) {
    const matching = blocks.filter((b) => canonLang(b.lang) === pref);
    const pool = matching.length ? matching : blocks;
    return pool[pool.length - 1].content.trim();
  }
  return applyExtractors.fencedCode(langs, { minLength: 4 })(text)?.trim() || null;
}

function formatSeedContext(snap, track, lesson) {
  if (!snap) return '(editor not ready)';
  const lines = [
    `Track: ${track || 'tutorials'}`,
    lesson ? `Lesson: ${lesson}` : null,
    `Language: ${snap.language}`,
    `Editor: ${snap.editorId || 'unknown'}`,
  ].filter(Boolean);

  if (snap.stdin) lines.push('', 'Stdin:', snap.stdin.slice(0, 2000));
  if (snap.selection) lines.push('', 'Selected code:', snap.selection.slice(0, 4000));

  const code = String(snap.code || '').trim();
  const cap = 12000;
  lines.push('', 'Editor code:', code.length > cap ? `${code.slice(0, cap)}\n… [truncated]` : code || '(empty)');

  if (snap.hasRun) {
    lines.push('', `Run output${snap.outputIsError ? ' (errors)' : ''}:`, (snap.output || '(no output)').slice(0, 8000));
    if (snap.exitCode !== '' && snap.exitCode != null) lines.push(`Exit code: ${snap.exitCode}`);
  } else {
    lines.push('', 'Run output: (not run yet)');
  }

  return lines.join('\n');
}

function buildQuickActions(snap, track, lesson) {
  const lang = snap?.language || 'code';
  const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
  const actions = [];

  // On error — fix + teach debugging first
  if (snap?.outputIsError) {
    actions.push(
      chip('Fix it', `Fix my ${lang} code using the error in context. Return the complete corrected program in one fenced block.`),
      chip('Debug steps', 'Teach me how to debug this error myself — a short checklist or strategy. Do not give the full fixed program.'),
    );
  }

  // After run — explain result + trace
  if (snap?.hasRun) {
    actions.push(
      chip(
        snap.outputIsError ? 'Explain error' : 'Explain output',
        snap.outputIsError
          ? 'Explain why my code failed and what concept I misunderstood. Prose only — no full fix unless I ask.'
          : 'Explain why my program produced this output. Prose only.',
      ),
      chip('Trace it', 'Trace through my code step by step for the current input. Show key variable/state changes. Prose only.'),
    );
  }

  // Always — core tutor loop
  actions.push(
    chip('Hint only', 'Give me a hint toward the answer — no complete solution and no full corrected program.'),
    chip('Explain code', 'Explain my current code to a learner. Walk through structure and idioms. No code changes.'),
    chip('Challenge me', 'One short practice exercise + starter code in a fenced block; 2–3 lines starting with Hint: — no full solution.'),
    chip('Quiz me', 'Ask 2–3 short comprehension questions about my code or this lesson topic. Put brief answers at the end after a separator.'),
  );

  // DSA track
  if (track === 'dsa') {
    actions.push(
      chip('Complexity', 'Analyze time and space complexity of my approach. Mention if a better complexity is possible and why.'),
      chip('Edge cases', 'List important edge cases for this code/algorithm and whether my solution handles them.'),
    );
  }

  // Lesson progression
  if (lesson) {
    actions.push(
      chip('What\'s next?', `I'm on lesson "${lesson}" in the ${track} track. What should I learn next and why? Prose only, 2–4 sentences.`),
    );
  }

  return actions;
}

// ─── Adapter ─────────────────────────────────────────────────────────────────

/**
 * @param {object} opts — aiAssistantBoot + track
 */
export function createTutorialCompilerAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.tutorialShell;
  const track = opts.track || 'compiler';
  const getLesson = typeof opts.getLessonHint === 'function'
    ? opts.getLessonHint
    : () => document.body?.getAttribute('data-lesson') || '';

  let preferredLang = '';

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
        features: ['Much higher monthly AI limits', 'Pro chat model tier', 'No rate-limit waiting between requests'],
      },
    },
    floatingCorner: 'left',
    toolId: opts.toolId || `tutorials/${track}`,
    title: 'Tutorial AI',
    subtitle: 'Hint · explain · fix · practice · quiz',
    placeholder: 'Ask about this lesson, fix an error, or request a challenge…',
    footerText: 'Apply replaces editor code · Ctrl+Shift+A',
    historyTurns: 8,
    contextValidator: false,
    systemPrompt: buildTutorialCompilerPrompt(track, getLesson()),
    seedContext: () => {
      const snap = shell()?.getSnapshot?.();
      preferredLang = snap?.language || preferredLang;
      return formatSeedContext(snap, track, getLesson());
    },
    getQuickActions: () => buildQuickActions(shell()?.getSnapshot?.(), track, getLesson()),
    applyActions: [{
      id: 'editor',
      order: 1,
      label: 'Apply to editor',
      extract: (text) => extractEditorCode(text, preferredLang || shell()?.getSnapshot?.()?.language),
      apply: (payload) => {
        const sh = shell();
        if (!sh) throw new Error('Tutorial editor not ready.');
        const result = sh.applyCode(payload);
        if (!result?.applied) throw new Error(result?.error || 'Could not apply code.');
        return result;
      },
    }],
    getApplyLabel: () => {
      const lang = preferredLang || shell()?.getSnapshot?.()?.language || 'code';
      return `Apply ${lang} to editor`;
    },
  });

  const originalSend = assistant._send.bind(assistant);
  assistant._send = async function wrappedSend() {
    preferredLang = shell()?.getSnapshot?.()?.language || preferredLang;
    return originalSend();
  };

  return assistant;
}

// ─── Open panel from compiler ✨ AI button ───────────────────────────────────

function warnToast(msg) {
  if (typeof window.showToast === 'function') window.showToast(msg, 'warning');
}

/**
 * @param {{ open: Function, ensure: Function }} assistantApi
 * @param {object} boot
 */
export function installTutorialOpenAI(assistantApi, boot) {
  window.tutorialOpenAI = async function tutorialOpenAI(id) {
    if (boot?.billing?.requireSignIn && !(boot.userId || '')) {
      warnToast('Sign in to use AI');
    }
    window.tutorialShell?.setActiveEditor(id);
    await assistantApi.open('', false);
  };
}
