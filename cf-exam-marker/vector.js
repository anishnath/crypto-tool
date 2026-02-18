// Vector-specific AI prompt builder for math-steps
// Handles: add, subtract, dot_product, cross_product, magnitude, projection, angle, etc.

/**
 * Build a vector-specific prompt for OpenAI step-by-step solutions.
 *
 * @param {string} expression - JSON string of vector a, e.g. "[1,2,3]"
 * @param {string} variable   - unused for vectors, kept for API compatibility
 * @param {string} answer     - JSON string of vector b, or "unknown"
 * @param {string} mode       - One of: add, subtract, scalar_multiply, dot_product, cross_product, magnitude, unit_vector, angle, projection, rejection, area, triple_scalar, linear_independence
 * @returns {string} The prompt string
 */
export function buildVectorPrompt(expression, variable, answer, mode) {
  let vecA, vecB;
  try { vecA = JSON.parse(expression); } catch (e) { vecA = expression; }
  try { vecB = JSON.parse(answer); } catch (e) { vecB = answer; }

  const aStr = Array.isArray(vecA) ? `(${vecA.join(', ')})` : String(vecA);
  const bStr = Array.isArray(vecB) ? `(${vecB.join(', ')})` : String(vecB);
  const hasB = answer && answer !== 'unknown' && answer !== expression;

  let problemDesc;
  let modeRules;

  switch (mode) {
    case 'add':
      problemDesc = hasB
        ? `Add vectors: a = ${aStr} and b = ${bStr}`
        : `Vector addition: a = ${aStr}`;
      modeRules = `- Write both vectors in component form
- Add corresponding components: (a_x+b_x, a_y+b_y, a_z+b_z)
- Show each component addition separately
- Write the result vector
- State the magnitude of the result`;
      break;

    case 'subtract':
      problemDesc = hasB
        ? `Subtract vectors: a = ${aStr} minus b = ${bStr}`
        : `Vector subtraction: a = ${aStr}`;
      modeRules = `- Write both vectors in component form
- Subtract corresponding components: (a_x-b_x, a_y-b_y, a_z-b_z)
- Show each component subtraction separately
- Write the result vector`;
      break;

    case 'dot_product':
      problemDesc = hasB
        ? `Compute dot product: a = ${aStr} dot b = ${bStr}`
        : `Dot product: a = ${aStr}`;
      modeRules = `- Write the dot product formula: a·b = Σ(a_i × b_i)
- Multiply corresponding components
- Sum all products
- State the scalar result
- If result is 0, note vectors are orthogonal`;
      break;

    case 'cross_product':
      problemDesc = hasB
        ? `Compute cross product: a = ${aStr} × b = ${bStr}`
        : `Cross product: a = ${aStr}`;
      modeRules = `- Write vectors a and b
- Set up the 3×3 determinant with i, j, k in first row
- Expand the determinant using cofactor expansion
- Compute each component of the result
- State the result vector
- Compute the magnitude |a×b| (area of parallelogram)`;
      break;

    case 'magnitude':
      problemDesc = `Compute magnitude of vector a = ${aStr}`;
      modeRules = `- Write the magnitude formula: |a| = √(Σ a_i²)
- Square each component
- Sum the squares
- Take the square root
- State the final result`;
      break;

    case 'projection':
      problemDesc = hasB
        ? `Compute projection of b = ${bStr} onto a = ${aStr}`
        : `Vector projection onto a = ${aStr}`;
      modeRules = `- Write the projection formula: proj_a(b) = (a·b / a·a) × a
- Compute the dot product a·b
- Compute a·a
- Divide to get the scalar coefficient
- Multiply by vector a to get the result
- State the projection vector`;
      break;

    case 'angle':
      problemDesc = hasB
        ? `Find angle between a = ${aStr} and b = ${bStr}`
        : `Angle computation for a = ${aStr}`;
      modeRules = `- Write the angle formula: θ = arccos(a·b / |a||b|)
- Compute the dot product a·b
- Compute |a| and |b|
- Divide: cos(θ) = (a·b) / (|a| × |b|)
- Take arccos to get θ in radians
- Convert to degrees: θ° = θ × 180/π`;
      break;

    default:
      problemDesc = hasB
        ? `Vector operation (${mode}): a = ${aStr}, b = ${bStr}`
        : `Vector operation (${mode}): a = ${aStr}`;
      modeRules = `- Identify the vector operation
- Show each step of the computation clearly
- Write the final answer`;
  }

  return `Show detailed solution steps for: ${problemDesc}

Vector concepts you may reference:
- Component form: v = (v_x, v_y, v_z)
- Magnitude: |v| = √(v_x² + v_y² + v_z²)
- Dot product: a·b = a_x·b_x + a_y·b_y + a_z·b_z = |a||b|cos(θ)
- Cross product: a×b = (a_y·b_z - a_z·b_y, a_z·b_x - a_x·b_z, a_x·b_y - a_y·b_x)
- Unit vector: â = a/|a|
- Projection: proj_a(b) = (a·b/a·a)·a

Rules:
- Give 4-8 clear steps. Do NOT skip intermediate arithmetic.
- Step 1: Rewrite the original vectors in standard notation
${modeRules}
- Each step: short descriptive title + full LaTeX formula showing the work
- LaTeX must use \\frac{}{}, \\cdot, \\left(, \\right), ^{} for exponents
- Use \\vec{a}, \\vec{b} for vector notation
- Use \\begin{pmatrix} ... \\end{pmatrix} for column vectors
- JSON only, no explanation text outside the JSON

Response format:
{"steps":[{"t":"step title","l":"LaTeX formula"}],"method":"method name"}`;
}
