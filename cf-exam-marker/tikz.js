// TikZ AI generation prompt builder for the CF Worker

export function buildTikzSystemMessage() {
  return `You are an expert TikZ generator.

Return valid JSON only with this shape:
{
  "title": "short diagram title",
  "libraries": ["library-name"],
  "code": "\\\\begin{tikzpicture}...\\\\end{tikzpicture}",
  "hint": "One-line explanation"
}

Requirements:
- "code" must be compilable TikZ code only, not a full LaTeX document
- Include \\usetikzlibrary{...} only for libraries actually needed
- Do not include \\documentclass, \\usepackage, \\begin{document}, or \\end{document}
- Do not use external packages such as circuitikz, pgfplots, or tikz-cd
- Prefer simple, minimal TikZ that satisfies the request
- Ensure braces, environments, and commands are valid and balanced
- Respond with JSON only, with no markdown or extra explanation`;
}

/**
 * Build the end-user request passed as the user message.
 *
 * @param {string} description - User's natural language description of the diagram
 * @returns {string} The prompt string
 */
export function buildTikzPrompt(description) {
  return `Generate TikZ for this request:

${description}`;
}
