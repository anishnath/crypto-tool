// Polynomial-specific AI prompt builder for math-steps
// Handles: add, subtract, multiply, divide, factor, roots, evaluate

/**
 * Build a polynomial-specific prompt for OpenAI step-by-step solutions.
 *
 * @param {string} expression - The polynomial expression P(x)
 * @param {string} variable   - Variable name (default "x")
 * @param {string} answer     - Q(x) for binary ops, x-value for evaluate, or "unknown"
 * @param {string} mode       - One of: add, subtract, multiply, divide, factor, roots, evaluate
 * @returns {string} The prompt string
 */
export function buildPolynomialPrompt(expression, variable, answer, mode) {
  const v = variable || 'x';
  const hasAnswer = answer && answer !== 'unknown' && answer !== expression;

  let problemDesc;
  let modeRules;

  switch (mode) {
    case 'add':
      problemDesc = hasAnswer
        ? `Add two polynomials: P(${v}) = ${expression} and Q(${v}) = ${answer}`
        : `Polynomial addition: ${expression}`;
      modeRules = `- Write both polynomials aligned by degree (highest to lowest)
- Group like terms (same degree of ${v}) together
- Add the coefficients of each group of like terms
- Write the resulting polynomial in standard form (descending powers)
- State the degree of the result`;
      break;

    case 'subtract':
      problemDesc = hasAnswer
        ? `Subtract polynomials: P(${v}) = ${expression} minus Q(${v}) = ${answer}`
        : `Polynomial subtraction: ${expression}`;
      modeRules = `- Write both polynomials: P(${v}) and Q(${v})
- Distribute the negative sign across all terms of Q(${v})
- Group like terms (same degree of ${v}) together
- Add the coefficients of each group of like terms
- Write the result in standard form (descending powers)
- State the degree of the result`;
      break;

    case 'multiply':
      problemDesc = hasAnswer
        ? `Multiply polynomials: P(${v}) = ${expression} times Q(${v}) = ${answer}`
        : `Polynomial multiplication: ${expression}`;
      modeRules = `- Write both polynomials
- If both are binomials, use FOIL (First, Outer, Inner, Last)
- Otherwise, distribute each term of P(${v}) across all terms of Q(${v})
- Show each partial product on its own line
- Combine like terms
- Write the result in standard form (descending powers)
- State the degree of the result (should be deg(P) + deg(Q))`;
      break;

    case 'divide':
      problemDesc = hasAnswer
        ? `Polynomial long division: P(${v}) = ${expression} divided by Q(${v}) = ${answer}`
        : `Polynomial division: ${expression}`;
      modeRules = `- Set up polynomial long division with dividend P(${v}) and divisor Q(${v})
- Step through the long division algorithm:
  1. Divide the leading term of the dividend by the leading term of the divisor
  2. Multiply the entire divisor by that quotient term
  3. Subtract to get a new remainder
  4. Repeat until the degree of the remainder is less than the degree of the divisor
- Show each division step clearly with the partial quotient and remainder
- Write the final result as: P(${v}) = Q(${v}) \\cdot quotient + remainder
- If remainder is 0, note that Q(${v}) divides P(${v}) evenly`;
      break;

    case 'factor':
      problemDesc = `Factor the polynomial: ${expression}`;
      modeRules = `- Identify the degree and type of polynomial
- First check for common factors (GCF)
- For degree 2: use the quadratic formula, factoring by grouping, or difference of squares
- For degree 3+: try rational root theorem, synthetic division, or factor by grouping
- Show each factoring step clearly
- Verify by expanding the factored form back
- Write the complete factored form
- Note any irreducible factors over the reals`;
      break;

    case 'roots':
      problemDesc = `Find all roots of: ${expression} = 0`;
      modeRules = `- Set the polynomial equal to zero
- Identify the degree (this determines the maximum number of roots)
- Try factoring first (GCF, grouping, quadratic formula)
- For degree 3+: use rational root theorem to find candidate rational roots p/q
- Test candidates using synthetic division or direct substitution
- Once a root is found, factor it out and reduce the degree
- For remaining quadratic factors, use the quadratic formula
- List all roots (real and complex)
- Verify each root by substitution if practical`;
      break;

    case 'evaluate':
      problemDesc = hasAnswer
        ? `Evaluate P(${v}) = ${expression} at ${v} = ${answer}`
        : `Evaluate the polynomial: ${expression}`;
      modeRules = `- Write the original polynomial P(${v})
- Substitute ${v} = ${hasAnswer ? answer : '?'} into every occurrence of ${v}
- Show the substituted expression with all values plugged in
- Evaluate each term separately (show the power computation, then the multiplication)
- Add all term values together step by step
- State the final numerical result`;
      break;

    default:
      problemDesc = hasAnswer
        ? `Polynomial problem: ${expression}, second polynomial: ${answer}`
        : `Polynomial problem: ${expression}`;
      modeRules = `- Identify the type of polynomial operation
- Show each step of the computation clearly
- Write the final answer in standard form`;
  }

  return `Show detailed solution steps for: ${problemDesc}

Polynomial concepts you may reference:
- Standard form: terms ordered by descending degree, e.g. a_n ${v}^n + a_{n-1} ${v}^{n-1} + ... + a_1 ${v} + a_0
- Degree: highest power of ${v} with non-zero coefficient
- Like terms: terms with the same power of ${v}
- Rational Root Theorem: if p/q is a root, p divides the constant term and q divides the leading coefficient
- Factor Theorem: (${v} - r) is a factor iff P(r) = 0

Rules:
- Give 4-8 clear steps. Do NOT skip intermediate algebra.
- Step 1: Rewrite the original problem in standard mathematical notation
${modeRules}
- Each step: short descriptive title + full LaTeX formula showing the work
- LaTeX must use \\frac{}{}, \\cdot, \\left(, \\right), ^{} for exponents
- Write polynomials in standard form with descending powers
- JSON only, no explanation text outside the JSON

Response format:
{"steps":[{"t":"step title","l":"LaTeX formula"}],"method":"method name"}`;
}
