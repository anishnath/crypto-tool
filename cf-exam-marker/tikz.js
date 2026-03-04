// TikZ AI generation prompt builder for the CF Worker

/**
 * Build a prompt for GPT to generate TikZ code from a natural language description.
 *
 * @param {string} description - User's natural language description of the diagram
 * @returns {string} The prompt string
 */
export function buildTikzPrompt(description) {
  return `You are an expert LaTeX/TikZ programmer. Generate a complete, working TikZ diagram based on the user's description.

## User Request
${description}

## Rules
- Output ONLY valid JSON, no markdown fences, no explanation outside JSON
- The "code" field must contain ONLY the tikzpicture environment (starting with \\begin{tikzpicture} and ending with \\end{tikzpicture})
- Do NOT include \\documentclass, \\begin{document}, \\usepackage, or any preamble in "code"
- If TikZ libraries are needed (arrows, shapes, calc, positioning, etc.), list them in the "libraries" array
- Keep the diagram clean, well-spaced, and labeled where appropriate
- Use standard TikZ syntax compatible with TikZJax (avoid pgfplots, tikz-3dplot, or obscure packages)
- The "title" should be a short (3-6 word) descriptive title for the diagram
- The "hint" should be one sentence explaining what was drawn

## Response Format (JSON only)
{
  "title": "short diagram title",
  "libraries": ["arrows.meta", "shapes"],
  "code": "\\\\begin{tikzpicture}...\\\\end{tikzpicture}",
  "hint": "One-line explanation of what was generated"
}`;
}
