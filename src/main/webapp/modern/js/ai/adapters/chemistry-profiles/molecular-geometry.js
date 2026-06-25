/**
 * 3D Molecular Geometry Calculator — chemistryShell profile for Chemistry AI.
 */
export function configureMolecularGeometryChemistryShell() {
  window.chemistryShell = {
    toolName: '3D Molecular Geometry Calculator',
    subtitle: 'VSEPR · 3D models · compare',
    placeholder: 'Ask about shape, bond angles, hybridization — program computes…',
    footerText: 'Ctrl+Shift+A · program renders 3D; AI explains',
    formulaApplyEnabled: true,

    applyFormula(formula, charge, opts) {
      if (typeof window.mgApplyFormula !== 'function') {
        return { applied: false, error: 'Geometry calculator not ready.' };
      }
      return window.mgApplyFormula(formula, charge, opts);
    },

    formatFormulaApplyLabel(item) {
      const ch = Number(item?.charge) || 0;
      const chPart = ch ? (ch > 0 ? ` (+${ch})` : ` (${ch})`) : '';
      const namePart = item?.name ? `${item.name}: ` : '';
      return `${namePart}${item.formula}${chPart} → Calculate`;
    },

    promptExtra: `**This tool:** Interactive 3D VSEPR geometry from formula/name or bonding/lone pair counts — **computed and rendered by the program** (PubChem 3D when available), not by you.

**Your role:** Tutor only. Explain VSEPR, electron vs molecular geometry, bond angles, hybridization, and what the **engine result summary** means. Never draw 3D structures or ASCII models in chat.

**Suggested practice (apply buttons):** When recommending molecules to try, output each as:

\`\`\`formula
CH4
charge: 0
\`\`\`

Optional \`name: Methane\`. Multiple blocks → multiple **Calculate** buttons. Do not describe the 3D model in prose — the program renders it.

**Do not** invent bond angles, shapes, or hybridization different from [CURRENT CONTEXT] engine summary.`,

    getContext() {
      if (typeof window.mgGetContext === 'function') return window.mgGetContext();
      return null;
    },

    formatContext(snap) {
      if (!snap) {
        return '(Enter a formula or BP/LP counts and click Calculate Geometry — then ask about the result.)';
      }

      const lines = [
        `Input mode: ${snap.inputMode || 'formula'}`,
        `Output panel: ${snap.outputPanel || 'result'}`,
      ];

      if (snap.inputMode === 'pairs') {
        lines.push(
          `Bonding pairs: ${snap.bondingPairs ?? '?'}`,
          `Lone pairs: ${snap.lonePairs ?? '?'}`,
        );
      } else {
        lines.push(`Formula / name: ${snap.formula || '(none)'}`);
      }

      if (snap.outputPanel === 'compare') {
        lines.push(
          `Compare A: ${snap.compare1 || '(none)'}`,
          `Compare B: ${snap.compare2 || '(none)'}`,
        );
      }

      if (snap.resultSummary) {
        lines.push('', 'Engine result summary:', snap.resultSummary.slice(0, 6000));
      } else {
        lines.push('', 'Engine result: (not calculated yet — teach VSEPR concepts for the inputs above.)');
      }

      return lines.join('\n');
    },

    getQuickActions(snap) {
      const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
      const hasResult = !!(snap?.resultSummary);
      const panel = snap?.outputPanel || 'result';

      if (panel === 'compare') {
        return [
          chip("Don't get it", 'Explain what the Compare panel shows and how to read the diff table — plain language.'),
          chip('Explain diff', hasResult
            ? 'Explain the geometry differences between the two molecules from the program results. Use engine summary only.'
            : 'Tell me to run Compare with two formulas first — do not invent geometries.'),
          chip('Exam tip', 'CBSE tip: how to compare molecular shapes, bond angles, and polarity in exam answers.'),
        ];
      }

      if (snap?.inputMode === 'pairs') {
        return [
          chip("Don't get it", 'Explain bonding pairs vs lone pairs and steric number — plain language.'),
          chip('Explain result', hasResult
            ? 'Explain electron geometry, molecular shape, bond angle, and hybridization from the program result. No diagrams.'
            : 'I have not clicked Calculate yet. Explain what to expect for these BP/LP counts, then tell me to Calculate.'),
          chip('Example molecule', 'Suggest 2–3 real molecules with these BP/LP counts as separate ```formula``` blocks with hints. No 3D descriptions.'),
          chip('Exam tip', 'How to write AXE notation and justify bond angle compression from lone pairs.'),
        ];
      }

      return [
        chip("Don't get it", 'Explain what this molecule\'s geometry result means — plain language. Do not redraw the 3D model.'),
        chip('Explain result', hasResult
          ? 'Explain molecular shape, bond angle, electron geometry, and hybridization from the engine summary only.'
          : 'I have not clicked Calculate Geometry yet. Explain how to approach this formula conceptually, then tell me to Calculate.'),
        chip('VSEPR & LP effect', hasResult
          ? 'How do lone pairs affect the molecular shape vs electron geometry for this result? Prose only.'
          : 'Explain lone pair effects in VSEPR generally; remind me to Calculate for this formula.'),
        chip('Similar molecule', 'Suggest 2–3 similar molecules as separate ```formula``` blocks with hints — I will click Apply → Calculate.'),
      ];
    },
  };
}
