// Logarithm-specific AI prompt builder for math-steps
// Handles: solve, expand, condense, simplify, evaluate for logarithmic expressions

/**
 * Build a logarithm-specific prompt for OpenAI step-by-step solutions.
 *
 * @param {string} expression - The logarithm expression/equation (user-readable form)
 * @param {string} variable   - Variable to solve for (default "x")
 * @param {string} answer     - Known answer if available, or "unknown"
 * @param {string} mode       - One of: solve, expand, condense, simplify, evaluate
 * @returns {string} The prompt string
 */
export function buildLogarithmPrompt(expression, variable, answer, mode) {
  const v = variable || 'x';
  const hasAnswer = answer && answer !== 'unknown' && answer !== expression;

  let problemDesc;
  let modeRules;

  switch (mode) {
    case 'solve':
      problemDesc = hasAnswer
        ? `Solve the logarithmic equation: ${expression}, answer is ${v} = ${answer}`
        : `Solve the logarithmic equation for ${v}: ${expression}`;
      modeRules = `- Identify the type of logarithmic equation (single log, multiple logs same base, multiple logs different bases)
- If logs have the same base: use product rule log_b(M)+log_b(N)=log_b(MN) or quotient rule to combine into a single log
- Convert from logarithmic form to exponential form: log_b(x)=y means b^y=x
- Solve the resulting algebraic equation (linear, quadratic, etc.)
- Check for extraneous solutions: the argument of every logarithm must be positive
- State the final answer clearly as ${v} = value`;
      break;

    case 'expand':
      problemDesc = hasAnswer
        ? `Expand the logarithmic expression: ${expression} = ${answer}`
        : `Expand the logarithmic expression using log rules: ${expression}`;
      modeRules = `- Apply the product rule: log_b(MN) = log_b(M) + log_b(N)
- Apply the quotient rule: log_b(M/N) = log_b(M) - log_b(N)
- Apply the power rule: log_b(M^n) = n * log_b(M)
- Show each rule application as a separate step
- Write the fully expanded form as the final answer`;
      break;

    case 'condense':
      problemDesc = hasAnswer
        ? `Condense into a single logarithm: ${expression} = ${answer}`
        : `Condense into a single logarithm: ${expression}`;
      modeRules = `- Apply the power rule in reverse: n * log_b(M) = log_b(M^n)
- Apply the product rule in reverse: log_b(M) + log_b(N) = log_b(MN)
- Apply the quotient rule in reverse: log_b(M) - log_b(N) = log_b(M/N)
- Show each rule application as a separate step
- Write the single condensed logarithm as the final answer`;
      break;

    case 'simplify':
      problemDesc = hasAnswer
        ? `Simplify the logarithmic expression: ${expression} = ${answer}`
        : `Simplify the logarithmic expression: ${expression}`;
      modeRules = `- Use known values: log_b(1)=0, log_b(b)=1, log_b(b^n)=n, ln(e^n)=n
- Apply change of base formula if needed: log_b(x) = ln(x)/ln(b)
- Simplify any resulting arithmetic
- If the expression reduces to a number, show the numeric result
- Show each simplification step clearly`;
      break;

    case 'evaluate':
      problemDesc = hasAnswer
        ? `Evaluate numerically: ${expression} = ${answer}`
        : `Evaluate the logarithmic expression to a decimal value: ${expression}`;
      modeRules = `- Convert to natural log if needed using change of base: log_b(x) = ln(x)/ln(b)
- Compute each ln value numerically (e.g. ln(2) ≈ 0.6931, ln(10) ≈ 2.3026)
- Show the arithmetic step by step
- Give the final decimal answer rounded to 6 significant figures`;
      break;

    default:
      problemDesc = hasAnswer
        ? `Logarithm problem: ${expression} = ${answer}`
        : `Logarithm problem: ${expression}`;
      modeRules = `- Identify what type of logarithm problem this is
- Apply the appropriate logarithm rules (product, quotient, power, change of base)
- Show each step of the manipulation clearly
- Give the final simplified answer`;
  }

  return `Show detailed solution steps for: ${problemDesc}

Logarithm rules you may use:
- Product rule: \\log_b(MN) = \\log_b(M) + \\log_b(N)
- Quotient rule: \\log_b(M/N) = \\log_b(M) - \\log_b(N)
- Power rule: \\log_b(M^n) = n \\cdot \\log_b(M)
- Change of base: \\log_b(x) = \\frac{\\ln(x)}{\\ln(b)}
- Inverse: b^{\\log_b(x)} = x and \\log_b(b^x) = x
- ln means log base e, log means log base 10 unless subscript specified

Rules:
- Give 4-7 clear steps. Do NOT skip intermediate algebra.
- Step 1: Rewrite the original problem in standard mathematical notation
- Step 2: Identify which logarithm rule(s) to apply
${modeRules}
- Each step: short descriptive title + full LaTeX formula showing the work
- Use \\log_{b} for log base b, \\ln for natural log, \\log_{10} for common log
- LaTeX must use \\frac{}{}, \\log_{}, \\ln, \\left(, \\right) etc.
- JSON only, no explanation text outside the JSON

Response format:
{"steps":[{"t":"step title","l":"LaTeX formula"}],"method":"method name"}`;
}
