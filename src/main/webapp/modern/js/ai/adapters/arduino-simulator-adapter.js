import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const FILE_NAME_RE = /^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,62}\.[a-zA-Z0-9]+$/;
const CODE_LANG_RE = /^(?:cpp|c\+\+|arduino|ino|c|h|hpp|hh|cc|cxx|txt)$/i;

function parseFileNameFromFenceMeta(meta) {
  const text = String(meta || '').trim();
  if (!text) return null;
  const kv = /(?:title|file|filename|path)\s*=\s*["']?([^"'\s]+)["']?/i.exec(text);
  if (kv && FILE_NAME_RE.test(kv[1])) return kv[1];
  const bare = /^([a-zA-Z0-9][a-zA-Z0-9_.-]{0,62}\.[a-zA-Z0-9]+)$/.exec(text);
  if (bare && FILE_NAME_RE.test(bare[1])) return bare[1];
  return null;
}

function parseFileNameFromContentPrefix(content) {
  const s = String(content || '');
  const m = /^\s*(?:\/\/|#|\/\*)\s*file\s*:\s*([a-zA-Z0-9][a-zA-Z0-9_.-]{0,62}\.[a-zA-Z0-9]+)\s*(?:\*\/)?\s*\n/i.exec(s);
  if (!m) return null;
  return FILE_NAME_RE.test(m[1]) ? m[1] : null;
}

function stripFilePrefixLine(content) {
  return String(content || '').replace(/^\s*(?:\/\/|#|\/\*)\s*file\s*:\s*[a-zA-Z0-9][a-zA-Z0-9_.-]{0,62}\.[a-zA-Z0-9]+\s*(?:\*\/)?\s*\n/i, '');
}

/**
 * Parse AI response into either:
 *  - { kind: 'single', code: string }
 *  - { kind: 'multi', files: [{ name, content }] }
 */
function extractSketchPayload(text) {
  const src = String(text || '');
  const fenceRe = /```([\w#+.-]*)[ \t]*([^\n]*)\n([\s\S]*?)```/g;
  /** @type {{ name: string, content: string }[]} */
  const named = [];
  /** @type {string[]} */
  const unnamedCode = [];
  let m;
  while ((m = fenceRe.exec(src)) !== null) {
    const lang = (m[1] || '').toLowerCase();
    const meta = m[2] || '';
    let content = (m[3] || '').trim();
    if (!content) continue;
    const nameFromMeta = parseFileNameFromFenceMeta(meta);
    const nameFromBody = parseFileNameFromContentPrefix(content);
    const fileName = nameFromMeta || nameFromBody;
    if (fileName) {
      if (nameFromBody) content = stripFilePrefixLine(content).trim();
      if (content) named.push({ name: fileName, content });
      continue;
    }
    if (!lang || CODE_LANG_RE.test(lang)) unnamedCode.push(content);
  }

  if (named.length >= 2 || named.some((f) => f.name.toLowerCase() === 'sketch.ino')) {
    const merged = new Map();
    for (const f of named) merged.set(f.name.toLowerCase(), f);
    return { kind: 'multi', files: Array.from(merged.values()) };
  }

  if (named.length === 1 && unnamedCode.length) {
    return { kind: 'multi', files: [named[0], { name: 'sketch.ino', content: unnamedCode[unnamedCode.length - 1] }] };
  }

  if (unnamedCode.length) return { kind: 'single', code: unnamedCode[unnamedCode.length - 1] };

  return null;
}

/**
 * Create a tool-specific assistant for the Arduino simulator while keeping
 * the assistant core generic/reusable for other tools.
 */
export function createArduinoSimulatorAssistant(opts) {
  const {
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    fileManager,
    editor,
    componentPanel,
    wireManager,
    diagramSync,
    stopRunner,
    selection,
    exportDiagram,
    getLastCompileErrors,
    logOutput,
  } = opts;

  const PROMPT_TEMPLATES = Object.freeze({
    newProject: [
      'Create a new project for <board>.',
      'Goal: <what it should do>.',
      'Use components: <list>.',
      'Pin constraints: <pins to use/avoid>.',
      'Return full sketch + wokwi diagram JSON.',
    ].join('\n'),
    explain: [
      'Explain the current code and circuit.',
      'Focus on: signal flow, pin mapping, timing/logic, and likely failure points.',
      'Keep it practical and tied to CURRENT CONTEXT only.',
    ].join('\n'),
    fixErrors: [
      'Fix the compile errors and return the FULL corrected sketch.',
      'Do not rename board-specific APIs unless required.',
      'Preserve intended behavior unless compile errors force a change.',
    ].join('\n'),
  });

  async function applyAiDiagram(diagram) {
    const partCount = diagram?.parts?.length ?? 0;
    const connCount = diagram?.connections?.length ?? 0;
    logOutput('→ AI: applying diagram — ' + partCount + ' parts, ' + connCount + ' connections');

    try {
      stopRunner();
      selection.deselect();
      const result = await diagramSync.applyExternalDiagram(diagram, { focusTab: false });
      if (result.errors?.length) {
        for (const err of result.errors) logOutput('  ⚠ Diagram: ' + err, 'warning');
      }
      logOutput('✓ AI: diagram.json updated — ' + result.partsLoaded + ' components, ' + result.wiresLoaded + ' wires');
    } catch (err) {
      logOutput('✗ AI: diagram apply failed — ' + (err?.message || err), 'error');
      throw err;
    }
  }

  return new VibeCodingAssistant({
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
      // Plan name + price come live from the Go API (/api/billing/plans, which
      // reads the Dodo products). These are only fallbacks/overrides used before
      // that fetch resolves or if it fails — feature bullets + cadence copy live
      // here; priceLabel can be set to force a static price.
      plans: {
        monthly: { name: 'Monthly', priceLabel: '', cadence: 'Billed monthly · cancel anytime' },
        yearly: { name: 'Yearly', priceLabel: '', cadence: 'Billed yearly', badge: 'Best value' },
        features: [
          'Much higher monthly AI limits',
          'No rate-limit waiting between requests',
          'Priority access on Arduino & other tools',
        ],
      },
    },
    toolId: 'electronics/arduino-simulator',
    title: 'Arduino AI',
    subtitle: 'Generate, explain, and fix using your current board/code/circuit context.',
    placeholder: 'Try: "UNO traffic light using pins 8,9,10 with 1s cycle"...',
    footerText: 'Tip: mention board + components + pin constraints for best results',
    historyTurns: 3,
    systemPrompt: `You are an expert embedded engineer for an Arduino / ESP32 / Pico simulator (Wokwi-style).
Use ONLY [CURRENT CONTEXT] as source of truth for board, code, and circuit.

Output rules:
- New project:
  - Single-file project: return sketch in one cpp fence.
  - Multi-file project: return one fence per file with filename metadata, e.g.
    \`\`\`cpp title=sketch.ino
    // code
    \`\`\`
    \`\`\`cpp title=LedDriver.h
    // code
    \`\`\`
  - Also return Wokwi diagram in exactly one triple-backtick json fence.
- Code change/fix:
  - Single-file edit: return FULL updated sketch in one cpp fence.
  - Multi-file edit: return one fence per changed file with \`title=<filename>\`.
- Explain: plain text only unless user explicitly asks for code.
- If context is incomplete, state the missing fields clearly in 1-3 bullets and ask a targeted follow-up. Do not hallucinate.

Explain format (when asked to explain):
1) What it does
2) Code walkthrough (setup/loop and key logic)
3) Circuit wiring and pin map
4) Board-specific notes (timing/voltage/peripheral caveats)
5) Likely failure points + quick checks

Respect board FQBN and pin constraints from [CURRENT CONTEXT].`,
    seedContext: () => {
      const boardSelect = document.getElementById('boardSelect');
      const board = boardSelect.value;
      const boardName = boardSelect.options[boardSelect.selectedIndex].text;
      const activeFile = fileManager.activeFile;
      const isInoTab = activeFile && /\.ino$/i.test(activeFile.name);
      let sketchName = '';
      let sketch = '';
      if (isInoTab) {
        sketchName = activeFile.name;
        sketch = (editor.getCode() || '').trim();
      } else {
        const sketchFile = fileManager.files.find((f) => /\.ino$/i.test(f.name));
        if (sketchFile) {
          sketchName = sketchFile.name;
          sketch = (sketchFile.content || '').trim();
        }
      }

      const parts = [];
      if (board) parts.push(`Board FQBN: ${board} (${boardName})`);
      if (sketch) parts.push(`Sketch (${sketchName || 'sketch.ino'}):\n${sketch}`);

      const lastCompileErrors = String(getLastCompileErrors?.() || '').trim();
      if (lastCompileErrors) parts.push(`Last compile errors:\n${lastCompileErrors}`);

      let diagramText = '';
      try {
        const diagramFile = fileManager.files.find((f) => f.name === 'diagram.json');
        if (diagramFile?.content) {
          const obj = JSON.parse(diagramFile.content);
          if (obj && Array.isArray(obj.parts)
              && (obj.parts.length > 1 || (obj.connections && obj.connections.length))) {
            diagramText = diagramFile.content.trim();
          }
        }
        if (!diagramText) {
          const boardTag = document.getElementById('arduinoBoard')?.tagName?.toLowerCase() || 'wokwi-arduino-uno';
          const diagram = exportDiagram(boardTag, 'board', { x: 0, y: 0 }, componentPanel.components, wireManager.wires);
          if (diagram?.parts?.length > 1 || diagram?.connections?.length) {
            diagramText = JSON.stringify(diagram);
          }
        }
      } catch { /* no diagram */ }
      if (diagramText) parts.push(`Circuit diagram JSON:\n${diagramText}`);
      return parts.join('\n\n');
    },
    getQuickActions: () => {
      const actions = [
        { label: 'New project', prompt: PROMPT_TEMPLATES.newProject },
        { label: 'Explain', prompt: PROMPT_TEMPLATES.explain, sendImmediately: true },
        { label: 'Prompt tips', prompt: 'Use this structure:\n' + PROMPT_TEMPLATES.newProject },
      ];
      if (String(getLastCompileErrors?.() || '').trim()) {
        actions.unshift({
          label: 'Fix errors',
          prompt: PROMPT_TEMPLATES.fixErrors,
          sendImmediately: true,
        });
      }
      return actions;
    },
    applyActions: [
      {
        id: 'sketch',
        order: 1,
        label: 'Apply code/files to editor',
        extract: extractSketchPayload,
        apply: (payload) => {
          if (!payload) throw new Error('AI returned no code payload to apply.');
          const active = fileManager.activeIndex;
          if (Number.isInteger(active) && active >= 0 && active < fileManager.files.length) {
            fileManager.files[active].content = editor.getCode();
          }

          if (payload.kind === 'single') {
            const code = payload.code;
            const sketchIdx = fileManager.files.findIndex((f) => /\.ino$/i.test(f.name));
            const idx = sketchIdx >= 0 ? sketchIdx : 0;
            fileManager.files[idx].content = code;
            fileManager.files[idx].modified = true;
            if (fileManager.activeIndex === idx) editor.setCode(code);
            if (fileManager.onChange) fileManager.onChange();
            logOutput('✓ AI: sketch.ino applied');
            return;
          }

          const files = payload.files
            .filter((f) => FILE_NAME_RE.test(f.name) && String(f.content || '').trim().length > 0);
          if (!files.length) throw new Error('No valid named files found in AI response.');

          if (fileManager.files.length + files.length > 64) {
            throw new Error('Too many files in AI response (max 64 total).');
          }

          let updated = 0;
          let created = 0;
          for (const f of files) {
            const existing = fileManager.files.findIndex((x) => x.name.toLowerCase() === f.name.toLowerCase());
            if (existing >= 0) {
              fileManager.files[existing].content = f.content;
              fileManager.files[existing].modified = true;
              updated += 1;
            } else {
              fileManager.files.push({ name: f.name, content: f.content, modified: true });
              created += 1;
            }
          }

          const sketchIdx = fileManager.files.findIndex((f) => f.name.toLowerCase() === 'sketch.ino');
          const focusIdx = sketchIdx >= 0 ? sketchIdx : fileManager.activeIndex;
          if (focusIdx >= 0 && focusIdx < fileManager.files.length) {
            fileManager.activeIndex = focusIdx;
            editor.setCode(fileManager.files[focusIdx].content);
          }
          if (fileManager.onChange) fileManager.onChange();
          logOutput(`✓ AI: multi-file apply complete — ${updated} updated, ${created} created`);
        },
      },
      {
        id: 'circuit',
        order: 2,
        label: 'Apply circuit to canvas',
        extract: applyExtractors.wokwiDiagram(),
        apply: (diagram) => applyAiDiagram(diagram),
      },
    ],
    getApplyLabel: (matched) => {
      const ids = new Set(matched.map((m) => m.action.id));
      if (ids.has('sketch') && ids.has('circuit')) return 'Apply code & circuit';
      return matched.map((m) => m.action.label).join(' & ');
    },
    onError: (err) => logOutput('✗ AI: ' + (err.message || err), 'error'),
  });
}

