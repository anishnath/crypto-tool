// TikZ AI generation prompt builder for the CF Worker

/**
 * Build a prompt for GPT to generate TikZ code from a natural language description.
 *
 * @param {string} description - User's natural language description of the diagram
 * @returns {string} The prompt string
 */
export function buildTikzPrompt(description) {
  return `You are an expert LaTeX/TikZ programmer. Generate a complete, working TikZ diagram based on the user's description. The code will be compiled by pdflatex with TeX Live — it must compile without errors.

## User Request
${description}

## Rules
- Output ONLY valid JSON, no markdown fences, no explanation outside JSON
- The "code" field must be self-contained TikZ code ready to compile via the TikZ endpoint
- Include \\usetikzlibrary{...} lines at the top of "code" for every library you reference
- Do NOT include \\documentclass, \\begin{document}, \\end{document}, or \\usepackage
- Use \\begin{tikzpicture}...\\end{tikzpicture} or \\tikz shorthand only
- You may use any TikZ library: arrows.meta, calc, positioning, shapes, shapes.geometric, shapes.misc, decorations, decorations.pathmorphing, decorations.markings, decorations.text, patterns, shadows, trees, graphs, graphdrawing, 3d, angles, quotes, intersections, through, backgrounds, fit, matrix, chains, scopes, spy, turtle, lindenmayersystems, math, automata, petri, er, mindmap, calendar, folding, babel, external, fadings, fixedpointarithmetic, fpu, plotmarks
- Do NOT use separate LaTeX packages (circuitikz, pgfplots, tikz-cd) — these require a different compilation endpoint. Draw circuits, plots, and diagrams using basic TikZ drawing commands instead.

## Correctness Requirements
- Every \\draw, \\fill, \\node, \\path, \\coordinate command MUST end with a semicolon
- Every opening brace { must have a matching closing brace }
- Every \\begin{tikzpicture} must have a matching \\end{tikzpicture}
- Every \\begin{scope} must have a matching \\end{scope}
- Do NOT invent TikZ commands — only use commands documented in the PGF/TikZ manual
- If you use arrow tips like Stealth, Latex, Triangle, ensure \\usetikzlibrary{arrows.meta} is declared
- If you use node shapes like diamond, ellipse, trapezium, ensure \\usetikzlibrary{shapes.geometric} is declared
- If you use positioning keys like "right=of", ensure \\usetikzlibrary{positioning} is declared
- If you use calc coordinates like ($(A)!0.5!(B)$), ensure \\usetikzlibrary{calc} is declared
- If you use decorations like snake, zigzag, ensure the correct decorations sub-library is declared
- Coordinates must use valid syntax: (x,y) or (angle:radius) or (nodename) or (nodename.anchor)
- Use node[anchor] not node[at] for positioning relative to other nodes
- plot coordinates must use the form: plot coordinates {(x1,y1) (x2,y2) ...} — no commas between points
- \\foreach syntax is: \\foreach \\var in {list} { body } — the body must be in braces

## Common Mistakes to Avoid
- Do NOT use \\draw[->] with Stealth arrows without arrows.meta library
- Do NOT use "node distance" without positioning library
- Do NOT use \\graph without graphs library
- Do NOT confuse \\fill (fills shape) with \\filldraw (fills and draws outline)
- Do NOT use [scale] on a node and expect text to scale — use [transform shape] for that
- Do NOT put semicolons inside \\foreach body — only at the end of the full \\foreach statement
- Do NOT use color names like "red!30!blue" in node text — use \\textcolor{}{} for that

## Self-Check Before Responding
Mentally compile the code. Verify:
1. All braces are balanced
2. All semicolons are present
3. All referenced libraries are declared in \\usetikzlibrary
4. All node names referenced in \\draw commands are actually defined
5. No undefined commands or options are used

## Examples of Correct Code

### Simple graph
\\usetikzlibrary{arrows.meta}
\\begin{tikzpicture}[->,>=Stealth,node distance=2cm]
  \\node[circle,draw] (a) {A};
  \\node[circle,draw,right of=a] (b) {B};
  \\draw (a) -- (b);
\\end{tikzpicture}

### Flowchart
\\usetikzlibrary{shapes.geometric,arrows.meta,positioning}
\\begin{tikzpicture}[node distance=1.5cm,>={Stealth[round]},every node/.style={font=\\small}]
  \\node[rectangle,draw,rounded corners] (start) {Start};
  \\node[diamond,draw,below=of start,aspect=2] (dec) {Check?};
  \\node[rectangle,draw,below=of dec] (end) {End};
  \\draw[->] (start) -- (dec);
  \\draw[->] (dec) -- node[right] {yes} (end);
\\end{tikzpicture}

## Response Format (JSON only)
{
  "title": "short diagram title",
  "libraries": ["arrows.meta", "shapes.geometric"],
  "code": "\\\\usetikzlibrary{arrows.meta,shapes.geometric}\\n\\\\begin{tikzpicture}...\\\\end{tikzpicture}",
  "hint": "One-line explanation of what was generated"
}`;
}
