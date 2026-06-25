/**
 * Lewis Structure Generator — chemistryShell profile for shared Chemistry AI.
 */
export function configureLewisChemistryShell() {
  window.chemistryShell = {
    toolName: 'Lewis Structure Generator',
    subtitle: 'Lewis · VSEPR · formal charge',
    placeholder: 'Ask why the program drew this — tutor only, no structure generation…',
    footerText: 'Ctrl+Shift+A · program draws structures; AI explains',
    formulaApplyEnabled: true,

    applyFormula(formula, charge, opts) {
      if (typeof window.lewisApplyFormula !== 'function') {
        return { applied: false, error: 'Lewis editor not ready.' };
      }
      return window.lewisApplyFormula(formula, charge, opts);
    },

    formatFormulaApplyLabel(item) {
      const ch = Number(item?.charge) || 0;
      const chPart = ch ? (ch > 0 ? ` (+${ch})` : ` (${ch})`) : '';
      const namePart = item?.name ? `${item.name}: ` : '';
      return `${namePart}${item.formula}${chPart} → Generate`;
    },

    promptExtra: `**This tool:** Lewis dots, VSEPR geometry, and formal charge — all **computed and drawn by the program**, not by you.

**Your role:** Tutor only. Explain formulas, rules, and what the **engine result summary** means. Never draw Lewis structures, dot diagrams, bond layouts, or geometry figures in your reply.

**Suggested practice formulas (apply buttons):** When you recommend molecules to try, output each as its own fenced block so the student can click **Apply → Generate** (the program draws the structure):

\`\`\`formula
H2S
charge: 0
\`\`\`

Optional: \`name: Hydrogen sulfide\` inside the block. For ions use \`charge: -1\` etc. Multiple blocks in one reply → multiple apply buttons. Do **not** draw Lewis structures in prose.

**Tutor modes**
1. **Don't get it** — plain language: formula meaning, what the on-screen diagram shows. No drawing.
2. **Explain result** — after Generate: explain from engine summary. Do not redraw.
3. **VSEPR & shape** — geometry and polarity from engine output when available.
4. **Formal charges** — explain FC from engine output.
5. **Similar molecule** — 1–3 \`\`\`formula\`\`\` blocks with hints in prose; no dot diagrams.

If [CURRENT CONTEXT] has no engine result, teach theory or offer \`\`\`formula\`\`\` blocks to apply.`,

    getContext() {
      if (typeof window.lewisGetContext === 'function') return window.lewisGetContext();
      return null;
    },

    formatContext(snap) {
      if (!snap) {
        return '(Open a tab, enter a formula, and click Generate — then ask about the result.)';
      }

      const lines = [`Active tab: ${snap.tab || 'lewis'}`];

      if (snap.tab === 'lewis' || !snap.tab) {
        lines.push(
          `Formula: ${snap.formula || '(none)'}`,
          `Charge: ${snap.charge ?? '0'}`,
        );
      } else if (snap.tab === 'vsepr') {
        lines.push(
          `Central atom: ${snap.centralAtom || '(none)'}`,
          `Bonding regions: ${snap.bondingPairs ?? '?'}`,
          `Lone pairs: ${snap.lonePairs ?? '?'}`,
        );
      } else if (snap.tab === 'formal') {
        lines.push(
          `Atom: ${snap.formalAtom || '(none)'}`,
          `Valence e⁻: ${snap.formalValence ?? '?'}`,
          `Non-bonding e⁻: ${snap.formalNonBonding ?? '?'}`,
          `Bonding e⁻: ${snap.formalBonding ?? '?'}`,
        );
      }

      if (snap.resultSummary) {
        lines.push('', 'Engine result summary:', snap.resultSummary.slice(0, 6000));
      } else {
        lines.push('', 'Engine result: (not generated yet — teach general concepts for the inputs above.)');
      }

      return lines.join('\n');
    },

    getQuickActions(snap) {
      const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
      const tab = snap?.tab || 'lewis';
      const hasResult = !!(snap?.resultSummary);

      if (tab === 'vsepr') {
        return [
          chip("Don't get it", 'Explain VSEPR and what bonding regions vs lone pairs mean for this input — plain language, no jargon dump.'),
          chip('Predict shape', hasResult
            ? 'Explain the electron geometry, molecular shape, and bond angle from the program\'s result. Why do lone pairs change the shape? No diagrams — prose only.'
            : 'Explain what molecular shape to expect for these bonding/lone pair counts. Tell me to click Predict — do not give final angles as if you calculated them.'),
          chip('Exam tip', 'CBSE/classroom tip: what to write for VSEPR questions (AXE notation, angle justification) for this case. No structure drawings.'),
        ];
      }

      if (tab === 'formal') {
        return [
          chip("Don't get it", 'Explain formal charge in plain language and what each input box means for this atom.'),
          chip('Explain FC', hasResult
            ? 'Walk through the formal charge meaning from the program\'s result step by step. Do not recalculate different numbers.'
            : 'Explain how formal charge works for this atom with my inputs. Tell me to click Calculate for the numeric result — do not compute FC yourself.'),
          chip('Best structure', 'How do formal charges help pick the best Lewis structure? When is a non-zero FC acceptable? No dot diagrams.'),
        ];
      }

      return [
        chip("Don't get it", 'I am confused. Explain the formula and what the program\'s Lewis diagram represents — plain language only. Do NOT draw or describe a dot structure yourself; tell me to click Generate if I have not yet.'),
        chip('Explain result', hasResult
          ? 'Explain the program\'s Lewis result: central atom, bonds, lone pairs, octet/expanded octet. Use only the engine summary — do not redraw the structure.'
          : 'I have not clicked Generate yet. Explain how I would approach this molecule conceptually, then tell me to use Generate for the actual structure. Do not draw it yourself.'),
        chip('VSEPR & shape', hasResult
          ? 'From the program\'s result, explain molecular geometry, bond angles, and polarity. No ASCII diagrams.'
          : 'Explain VSEPR concepts for this formula. Remind me to Generate the Lewis structure first — do not predict the exact shape with numbers unless from engine output.'),
        chip('Similar molecule', 'Suggest 2–3 similar molecules to practice. For each one, output a separate ```formula``` block (formula + charge lines only) plus one hint in prose. No Lewis diagrams — I will click Apply → Generate for each.'),
      ];
    },
  };
}
