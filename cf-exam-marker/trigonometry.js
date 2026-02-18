// Trigonometry-specific AI prompt builder for math-steps
// Handles: evaluate, quadrant, coterminal, identity, prove, solve_equation, solve_inequality, simplify

/**
 * Build a trigonometry-specific prompt for OpenAI step-by-step solutions.
 *
 * @param {string} expression - The trig expression or equation
 * @param {string} variable   - Variable name (default "x")
 * @param {string} answer     - Additional info or "unknown"
 * @param {string} mode       - One of: evaluate, quadrant, coterminal, identity, prove, solve_equation, solve_inequality, simplify
 * @returns {string} The prompt string
 */
export function buildTrigonometryPrompt(expression, variable, answer, mode) {
  const v = variable || 'x';

  let problemDesc;
  let modeRules;

  switch (mode) {
    case 'evaluate':
      problemDesc = `Evaluate the trigonometric expression: ${expression}`;
      modeRules = `- Identify the trig function and angle
- Convert between degrees and radians if needed
- Find the reference angle and determine the quadrant
- Look up exact values for special angles (0, 30, 45, 60, 90, etc.)
- Apply the correct sign based on the quadrant
- Give both the exact value (with radicals/fractions) and the decimal approximation
- Show all 6 trig function values if it's a special angle`;
      break;

    case 'quadrant':
      problemDesc = `Determine the quadrant and properties of angle: ${expression}`;
      modeRules = `- Normalize the angle to [0°, 360°) by adding/subtracting multiples of 360°
- Determine which quadrant the angle falls in (Q1: 0-90, Q2: 90-180, Q3: 180-270, Q4: 270-360)
- Calculate the reference angle
- List the signs of all 6 trig functions in that quadrant (ASTC rule)
- If it's a special angle, give the exact values of all 6 functions`;
      break;

    case 'coterminal':
      problemDesc = `Find coterminal angles of: ${expression}`;
      modeRules = `- Normalize the given angle to [0°, 360°) or [0, 2π)
- Show the formula: θ_co = θ + 360°·n (or + 2πn)
- List 3 positive coterminal angles (n = 1, 2, 3)
- List 3 negative coterminal angles (n = -1, -2, -3)
- Explain that all coterminal angles share the same terminal side`;
      break;

    case 'identity':
      problemDesc = `List and explain trigonometric identities for category: ${expression}`;
      modeRules = `- List all identities in the specified category
- For each identity, show the formula in LaTeX
- Briefly explain when each identity is useful
- If an expression is provided, show how to apply the identities to it`;
      break;

    case 'prove':
      problemDesc = `Verify and prove (or disprove) the trigonometric identity: ${expression}`;
      modeRules = `- CRITICAL: First verify if the identity is actually true before attempting to prove it
- Simplify BOTH sides independently to their simplest forms
- Compare the simplified forms — if they are NOT equal, the identity is FALSE
- If FALSE: clearly state "This is NOT a valid identity" in the final step title, show a specific counterexample angle (e.g. x=π/4) with numeric values for both sides to demonstrate they differ, and set method to "Not a valid identity"
- If TRUE: start with the more complex side (LHS or RHS)
- Apply known identities step by step
- Name each identity used (Pythagorean, double angle, etc.)
- Show every algebraic manipulation clearly
- Transform until you reach the other side
- Do NOT work on both sides simultaneously — work one side to match the other
- Do NOT fabricate or skip algebraic steps — every transformation must be mathematically justified
- Final step: confirm LHS = RHS`;
      break;

    case 'solve_equation':
      problemDesc = `Solve the trigonometric equation: ${expression}`;
      modeRules = `- CRITICAL: First check if the equation has any solutions at all
- For sin(x)=k or cos(x)=k: if |k| > 1, there are NO solutions — clearly state "No Solution" and explain why (range of sin/cos is [-1,1]), set method to "No Solution"
- For tan(x)=k: solutions always exist for any real k
- For csc(x)=k or sec(x)=k: if |k| < 1, there are NO solutions
- If the equation is valid, identify the type of trig equation
- For simple forms (sin(x)=k, cos(x)=k, tan(x)=k): use inverse trig functions
- For compound forms: factor, use identities to reduce, or convert to a single trig function
- Find all solutions in [0, 2π) first
- Then write the general solution using + 2nπ (for sin/cos) or + nπ (for tan)
- VERIFY each solution by substituting back into the original equation — discard any extraneous solutions
- Do NOT fabricate solutions — every solution must satisfy the original equation
- Express answers in exact form (radians with π fractions)`;
      break;

    case 'solve_inequality':
      problemDesc = `Solve the trigonometric inequality: ${expression}`;
      modeRules = `- CRITICAL: First check if the inequality is trivially true, trivially false, or has no solutions
- For sin(x) > k where k ≥ 1: NO solutions (sin never exceeds 1) — state "No Solution", set method to "No Solution"
- For sin(x) < k where k ≤ -1: NO solutions
- For sin(x) > k where k < -1: ALL real numbers are solutions — state "All Real Numbers"
- Apply the same range logic for cos(x), and for csc(x)/sec(x) (range is (-∞,-1]∪[1,∞))
- If the inequality has valid solutions, solve the corresponding equation (replace inequality with =)
- Find all critical points in [0, 2π)
- Test intervals between critical points — VERIFY by substituting a specific value from each interval
- Use the unit circle to visualize the solution regions
- Write the solution set in interval notation
- Express the general solution with periodicity
- Do NOT fabricate solution intervals — every interval must be verified with a test point`;
      break;

    case 'simplify':
      problemDesc = `Simplify the trigonometric expression: ${expression}`;
      modeRules = `- Identify which identities apply (Pythagorean, double angle, sum-to-product, etc.)
- Apply identities step by step, showing before and after each transformation
- Factor common terms when possible
- Convert all functions to sin and cos if stuck
- Simplify fractions and combine terms
- CRITICAL: In the final step, VERIFY the simplification is correct by evaluating BOTH the original expression and the simplified form at a specific angle (e.g. x=π/6) and confirming they give the same numeric value
- If the values differ, your simplification is WRONG — go back and fix it
- Do NOT fabricate identity applications — every step must be a valid mathematical transformation
- If the expression cannot be simplified further, state "Already in simplest form" and set method to "Already Simplified"`;
      break;

    default:
      problemDesc = `Trigonometric calculation: ${expression}`;
      modeRules = `- Show clear step-by-step work
- Use standard trig identities where applicable
- Give exact values when possible`;
  }

  return `Show detailed solution steps for: ${problemDesc}

Rules:
- Give 4-8 clear steps. Do NOT skip intermediate algebra.
- Step 1: Rewrite the problem clearly
${modeRules}
- Each step: short descriptive title + full LaTeX formula
- LaTeX must use \\sin, \\cos, \\tan, \\csc, \\sec, \\cot, \\frac{}{}, \\sqrt{}, \\pi, \\theta
- JSON only, no explanation text outside the JSON

Response format:
{"steps":[{"t":"step title","l":"LaTeX formula"}],"method":"method name"}`;
}
